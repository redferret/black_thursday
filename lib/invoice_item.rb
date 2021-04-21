require './lib/model'

class InvoiceItem < Model
  attr_reader :item_id,
              :invoice_id,
              :quantity,
              :unit_price

  def initialize(details)
    super
    @item_id = details[:item_id].to_i
    @invoice_id = details[:invoice_id].to_i
    @quantity = details[:quantity].to_i
    @unit_price = BigDecimal(details[:unit_price]) / 100
  end

  def unit_price_to_dollars
    @unit_price.to_f
  end

  def update_quantity(quantity)
    @quantity = quantity unless quantity.nil?
  end

  def update_unit_price(unit_price)
    @unit_price = unit_price unless unit_price.nil?
  end

  def total
    @unit_price * @quantity
  end
end
