require_relative './repository'

class InvoiceRepository < Repository
  def inspect
    "#<#{self.class} #{@models.size} rows>"
  end

  def initialize(filename)
    load_models(filename, Invoice)
  end

  def find_all_by_customer_id(customer_id)
    find_all_by do |invoice|
      invoice.customer_id == customer_id
    end
  end

  def find_all_by_merchant_id(merchant_id)
    find_all_by do |invoice|
      invoice.merchant_id == merchant_id
    end
  end

  def find_all_by_status(status)
    find_all_by do |invoice|
      invoice.status == status
    end
  end

  def create(attributes)
    new_invoice = Invoice.new(attributes)
    super(new_invoice)
  end

  def update(id, attributes)
    super(id, attributes) do |invoice|
      invoice.update_status(attributes[:status])
    end
  end
end
