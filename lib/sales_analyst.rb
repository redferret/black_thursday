require_relative './sales_engine'

class SalesAnalyst
  attr_reader :sales_engine

  def initialize(sales_engine)
    @sales_engine = sales_engine
  end

  def num_of_items_per_merchant
    all_items = @sales_engine.items.all
    all_merchants = @sales_engine.merchants.all

    all_merchants.each_with_object({}) do |merchant, total_per_merchant|
      total_items = all_items.count do |item|
        item.merchant_id == merchant.id
      end
      total_per_merchant[merchant] = total_items
    end
  end

  def average_items_per_merchant
    items = @sales_engine.items.all
    merchants = @sales_engine.merchants.all

    items.length / merchants.length
  end

  def average_items_per_merchant_standard_deviation
    item_count_per_merchant = num_of_items_per_merchant
    mean = average_items_per_merchant

    item_counts = item_count_per_merchant.values

    sums = item_counts.sum do |item_count|
      (item_count - mean)**2
    end

    Math.sqrt(sums / (item_counts.length - 1).to_f)
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
    all_items = @sales_engine.items.all
    items = all_items.find_all do |item|
      merchant_id == item.merchant_id
    end
    items_sum = items.sum(&:unit_price)
    items_sum / items.length
  end
end
