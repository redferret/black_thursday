require_relative './repository'

class InvoiceItemRepository < Repository
  def inspect
    "#<#{self.class} #{@models.size} rows>"
  end

  def initialize(filename)
    load_models(filename, InvoiceItem)
  end

  def find_all_by_item_id(item_id)
    @invoice_items.select do |invoice_item|
      invoice_item.item_id == item_id
    end
  end

  def find_all_by_invoice_id(invoice_id)
    @invoice_items.select do |invoice_item|
      invoice_item.invoice_id == invoice_id
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
  def total_for_invoice(invoice_id)
    find_all_by_invoice_id(invoice_id).sum do |invoice_item|
      invoice_item.total
    end
  end
end
