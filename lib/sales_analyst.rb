require_relative './sales_engine'

class SalesAnalyst
  attr_reader :sales_engine,
              :item_repo,
              :transaction_repo,
              :merchant_repo,
              :invoice_repo,
              :invoice_item_repo

  def initialize(sales_engine)
    @sales_engine = sales_engine
    @item_repo = sales_engine.items
    @transaction_repo = sales_engine.transactions
    @merchant_repo = sales_engine.merchants
    @invoice_repo = sales_engine.invoices
    @invoice_item_repo = sales_engine.invoice_items
  end

  def num_of_items_per_merchant
    all_merchants.each_with_object({}) do |merchant, total_per_merchant|
      total_items = all_items.count do |item|
        item.merchant_id == merchant.id
      end
      total_per_merchant[merchant] = total_items
    end
  end

  def average_items_per_merchant
    average = all_items.length.to_f / all_merchants.length
    average.round(2)
  end

  def average_items_per_merchant_standard_deviation
    mean = average_items_per_merchant
    item_counts = num_of_items_per_merchant.values
    std_dev = standard_deviation(item_counts, mean)
  end

  def standard_deviations_of_mean(mean, std_dev, n = 1)
    std_dev_n = std_dev * n
    mean + std_dev_n
  end

  def merchants_with_high_item_count
    mean = average_items_per_merchant
    std_dev = average_items_per_merchant_standard_deviation
    z = standard_deviations_of_mean(mean, std_dev)
    merchants = []
    num_of_items_per_merchant.each_pair do |merchant, item_count|
      merchants << merchant if item_count >= z
    end
    merchants
  end

  def average_item_price_for_merchant(merchant_id)
    items = @item_repo.find_all_by_merchant_id(merchant_id)
    if items.empty?
      nil
    else
      items_sum = items.sum(&:unit_price)
      average_price = items_sum / items.length
      average_price.round(2)
    end
  end

  def merchants_with_items
    num_of_items_per_merchant.reject do |_merchant, num_of_items|
      num_of_items.zero?
    end.keys
  end

  def average_average_price_per_merchant
    sum_of_averages = merchants_with_items.sum do |merchant|
      average_item_price_for_merchant(merchant.id)
    end
    average_average_price = sum_of_averages / all_merchants.length
    average_average_price.round(2)
  end

  def golden_items
    mean = all_items.sum(&:unit_price) / all_items.length
    item_prices = all_items.map { |item| item.unit_price }
    std_dev = standard_deviation(item_prices, mean)
    min_price = standard_deviations_of_mean(mean, std_dev, 2)
    all_items.find_all { |item| item.unit_price > min_price }
  end

  def standard_deviation(values, mean)
    sums = values.sum { |value| (value - mean)**2 }
    std_dev = Math.sqrt(sums / (values.length - 1).to_f)
    std_dev.round(2)
  end

  def average_invoices_per_merchant
    average = all_invoices.length.to_f / all_merchants.length
    average.round(2)
  end

  def num_of_invoices_per_merchant
    all_merchants.each_with_object({}) do |merchant, total_per_merchant|
      total_invoices = all_invoices.count do |invoice|
        invoice.merchant_id == merchant.id
      end
      total_per_merchant[merchant] = total_invoices
    end
  end

  def average_invoices_per_merchant_standard_deviation
    mean = average_invoices_per_merchant
    invoice_counts = num_of_invoices_per_merchant.values
    standard_deviation(invoice_counts, mean)
  end

  def top_merchants_by_invoice_count
    high_invoice_count = standard_deviations_of_mean(average_invoices_per_merchant, average_invoices_per_merchant_standard_deviation, 2)
    merchants = []
    num_of_invoices_per_merchant.each_pair do |merchant, invoice_count|
      merchants << merchant if invoice_count >= high_invoice_count
    end
    merchants
  end

  def bottom_merchants_by_invoice_count
    low_invoice_count = standard_deviations_of_mean(average_invoices_per_merchant, average_invoices_per_merchant_standard_deviation, -2)
    merchants = []
    num_of_invoices_per_merchant.each_pair do |merchant, invoice_count|
      merchants << merchant if invoice_count <= low_invoice_count
    end
    merchants
  end

  def invoice_created_at_times
    if all_invoices[0].created_at.class == String
      all_invoices.map do |invoice|
        Time.parse(invoice.created_at)
      end
    else
      all_invoices.map do |invoice|
        invoice.created_at
      end
    end
  end

  def invoice_created_at_by_weekday
    weekdays = invoice_created_at_times.map do |time|
      time.wday
    end
    weekdays.map do |weekday|
      Date::DAYNAMES[weekday]
    end
  end

  def convert_wday_integers_to_hash
    invoice_created_at_by_weekday.tally
  end

  def average_invoices_per_day
    convert_wday_integers_to_hash.values.sum / 7
  end

  def average_invoices_per_day_standard_deviation
    values = convert_wday_integers_to_hash.values
    mean = average_invoices_per_day
    sums = values.sum { |value| (value - mean)**2 }
    std_dev = Math.sqrt(sums / (values.length - 1).to_f)
    std_dev.round(2)
  end

  def top_days_by_invoice_count
    threshold = standard_deviations_of_mean(average_invoices_per_day, average_invoices_per_day_standard_deviation)
    top_days = []
    weekday_hash = convert_wday_integers_to_hash
    weekday_hash.map do |weekday, invoices|
      top_days << weekday if invoices > threshold
    end
    top_days
  end

  def invoice_status(status)
    with_status = all_invoices.select do |invoice|
      invoice.status == status
    end.length
    (with_status.to_f / all_invoices.length * 100).round(2)
  end

  def invoice_paid_in_full?(invoice_id)
    @transaction_repo.any_success?(invoice_id)
  end

  def invoice_total(invoice_id)
    if invoice_paid_in_full?(invoice_id)
      @invoice_item_repo.total_for_invoice(invoice_id)
    else
      0
    end
  end

  def total_revenue_by_date(date)
    # should make a method in InvoiceRepo for find_all_by_date
    invoices_for_date = all_invoices.find_all do |invoice|
      invoice.created_at == date
    end
    invoices_for_date.sum do |invoice|
      invoice_total(invoice.id)
    end
  end

  def invoices_by_merchant
    all_merchants.reduce({}) do |hash, merchant|
      hash[merchant] = @invoice_repo.find_all_by_merchant_id(merchant.id)
      hash
    end
  end

  def revenue_by_merchant
    invoices_by_merchant.transform_values do |invoices|
      invoices.sum { |invoice| invoice_total(invoice.id).to_f }
    end
  end

  def top_revenue_earners(x = 20)
    revenue_list = revenue_by_merchant.sort_by {|merchant, revenue| revenue}.reverse
    merchants_by_revenue = revenue_list.map { |array| array[0] }
    merchants_by_revenue.first(x)
  end

  def merchants_with_pending_invoices
    all_merchants.find_all do |merchant|
      invoices_by_merchant[merchant].any? do |invoice|
        !invoice_paid_in_full?(invoice.id)
      end
    end
  end

  def most_sold_item_for_merchant(merchant_id)
    invoices = @invoice_repo.find_all_by_merchant_id(merchant_id)
    invoice_items = invoices.reduce([]) do |array, invoice|
      array << @invoice_item_repo.find_all_by_invoice_id(invoice.id)
    end.flatten
    items_as_hash = invoice_items.reduce(Hash.new(0)) do |hash, invoice_item|
      hash[invoice_item.item_id] += invoice_item.quantity
      hash
    end
    sorted_items = items_as_hash.sort_by {|item, count| count}.reverse
    single_most_sold = sorted_items.first
    most_sold_items = sorted_items.find_all do |item|
      item[1] == single_most_sold[1]
    end
    most_sold_items.map {|array| @item_repo.find_by_id(array[0])}
  end

  def all_items
    @item_repo.all
  end

  def all_merchants
    @merchant_repo.all
  end

  def all_invoices
    @invoice_repo.all
  end

  def all_transactions
    @transaction_repo.all
  end

  def all_invoice_items
    @invoice_item_repo.all
  end

  def all_customers
    @customer_repo.all
  end
end
