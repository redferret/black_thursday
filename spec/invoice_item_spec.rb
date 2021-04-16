require 'rspec'
require './lib/invoice_item'

describe InvoiceItem do 
  it 'exists' do
    ii_details = {
    :id => 6,
    :item_id => 7,
    :invoice_id => 8,
    :quantity => 1,
    :unit_price => BigDecimal(10.99, 4),
    :created_at => Time.now,
    :updated_at => Time.now
          }
    invoice_item = InvoiceItem.new(ii_details)

    expect(invoice_item).is_a? InvoiceItem
  end
end
