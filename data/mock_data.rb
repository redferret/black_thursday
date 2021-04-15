require 'Date'

class MockData
  def self.get_a_random_date(random = true)
    if random
      date_s = "20#{rand(10..21)}-#{rand(1..12)}-#{rand(1..28)}"
      return Date.strptime(date_s, '%Y-%m-%d')
    else
      return Date.strptime('2020-01-01', '%Y-%m-%d')
    end
  end

  def self.get_a_random_price
    (rand(1..120) + (rand(100) / 100.0))
  end

  def self.merchants_as_mocks(merchant_hashes)
    mocked_merchants = []

    merchant_hashes.each do |merchant_hash|
      raise 'Bind self of ExampleGroup to your mocks. use {self}' if not block_given?
      eg = yield
      merchant_mock = eg.instance_double('Merchant',
        name: merchant_hash[:name],
        id: merchant_hash[:id],
        created_at: merchant_hash[:created_at],
        updated_at: merchant_hash[:updated_at]
      )
      mocked_merchants << merchant_mock
    end
    mocked_merchants
  end

  def self.merchants_as_hash(number_of_mocks: 10, random_dates: true)
    mocked_merchants = []
    number_of_mocks.times do |merchant_number|
      merchant = {}
      date = get_a_random_date(random_dates)

      merchant[:name] = "Merchant #{merchant_number}"
      merchant[:id] = merchant_number
      if block_given?
        merchant[:created_at] = yield(date).to_s
        merchant[:updated_at] = date.to_s
      else
        merchant[:created_at] = date.prev_year.to_s
        merchant[:updated_at] = date.to_s
      end
      mocked_merchants << merchant
    end
    mocked_merchants
  end

  def self.items_as_mocks(item_hashes)
    mocked_items = []
    item_hashes.each do |item_hash|
      raise 'Bind self of ExampleGroup to your mocks. use {self}' if not block_given?
      eg = yield
      item = eg.instance_double('Item',
        name: item_hash[:name],
        id: item_hash[:id],
        unit_price: item_hash[:unit_price],
        description: item_hash[:description],
        merchant_id: item_hash[:merchant_id],
        created_at: item_hash[:created_at],
        updated_at: item_hash[:updated_at]
      )
      mocked_items << item
    end
    mocked_items
  end

  def self.items_as_hash(number_of_mocks: 10, number_of_merchants: 2, random_dates: true, price_of: 0)
    mocked_items = []
    number_of_mocks.times do |item_number|
      item = {}
      date = get_a_random_date(random_dates)
      item[:name] = "Item #{item_number}"
      item[:id] = item_number
      if price_of == 0
        item[:unit_price] = get_a_random_price
      else
        item[:unit_price] = price_of
      end
      item[:description] = 'Item Description'
      item[:merchant_id] = item_number % number_of_merchants
      if block_given?
        item[:created_at] = yield(date).to_s
        item[:updated_at] = date.to_s
      else
        item[:created_at] = date.prev_year.to_s
        item[:updated_at] = date.to_s
      end
      mocked_items << item
    end
    mocked_items
  end

  def self.sum_item_prices_from_hash(items)
    items.sum do |item|
      item[:unit_price]
    end
  end

  def self.mean_of_item_prices_from_hash(items)
    sum = sum_item_prices_from_hash(items)
    (sum / items.length)
  end
end
