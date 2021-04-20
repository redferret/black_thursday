require 'bigdecimal'
require_relative './repository'

class ItemRepository < Repository
  def inspect
    "#<#{self.class} #{@models.size} rows>"
  end

  def initialize(filename)
    load_models(filename, Item)
  end

  def find_by_name(name)
    find_by do |item|
      item.name.casecmp?(name)
    end
  end

  def find_all_with_description(description)
    find_all_by do |item|
      item_description = item.description.downcase
      item_description.include?(description.downcase)
    end
  end

  def find_all_by_price(price)
    find_all_by do |item|
      item.unit_price == price
    end
  end

  def find_all_by_price_in_range(range)
    find_all_by do |item|
      range.cover?(item.unit_price)
    end
  end

  def find_all_by_merchant_id(merchant_id)
    find_all_by do |item|
      item.merchant_id == merchant_id
    end
  end

  def create(attributes)
    item = Item.new(attributes)
    super(item)
  end

  def update(id, attributes)
    super(id, attributes) do |item|
      item.update_name(attributes[:name])
      item.update_description(attributes[:description])
      item.update_unit_price(attributes[:unit_price])
    end
  end
end
