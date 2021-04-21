require './lib/model'

class Item < Model
  attr_reader :name,
              :description,
              :unit_price,
              :merchant_id

  def initialize(attributes)
    super
    @name = attributes[:name]
    @description = attributes[:description]
    @unit_price = BigDecimal(attributes[:unit_price]) / 100
    @merchant_id = attributes[:merchant_id].to_i
  end

  def unit_price_to_dollars
    @unit_price.to_f
  end

  def update_name(name)
    @name = name unless name.nil?
  end

  def update_description(description)
    @description = description unless description.nil?
  end

  def update_unit_price(unit_price)
    @unit_price = unit_price unless unit_price.nil?
  end
end
