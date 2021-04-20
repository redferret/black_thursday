require 'rspec'

require './data/invoice_mocks'
require './data/item_mocks'
require './data/merchant_mocks'
require './lib/sales_analyst'
require './spec/sales_analyst_mocks'


RSpec.describe SalesAnalystMocks do
  describe '#sales_analyst_mock' do
    it 'returns a mocked sales analyst' do
      sales_analyst_mock = SalesAnalystMocks.sales_analyst_mock(self)
      expect(sales_analyst_mock).not_to eq nil
    end
  end
end
