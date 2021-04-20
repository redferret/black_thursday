require_relative './repository'

class InvoiceItemRepository < Repository
  def inspect
    "#<#{self.class} #{@models.size} rows>"
  end

  def initialize(filename)
    load_models(filename, InvoiceItem)
  end

  def find_all_by_item_id(id)
    find_all_by do |invoice_item|
      invoice_item.item_id == id
    end
  end

  def find_all_by_invoice_id(id)
    find_all_by do |invoice_item|
      invoice_item.invoice_id == id
    end
  end

  def create(attributes)
    invoice_item = InvoiceItem.new(attributes)
    super(invoice_item)
  end

  def update(id, attributes)
    super(id, attributes) do |invoice_item|
      invoice_item.update_quantity(attributes[:quantity])
      invoice_item.update_unit_price(attributes[:unit_price])
    end
  end
end
