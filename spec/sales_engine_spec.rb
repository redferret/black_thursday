require 'csv'

require './data/customer_mocks'
require './data/invoice_mocks'
require './data/invoice_item_mocks'
require './data/item_mocks'
require './data/merchant_mocks'
require './data/sales_engine_mocks'
require './data/transaction_mocks'


require './lib/customer'
require './lib/file_io'
require './lib/invoice'
require './lib/invoice_item'
require './lib/item'
require './lib/merchant'
require './lib/sales_engine'
require './lib/sales_analyst'
require './lib/transaction'



describe SalesEngine do
  describe '#from_csv' do
    it 'creates a new instance of SalesEngine' do
      sales_engine = SalesEngineMocks.sales_engine(self)

      expect(sales_engine).to be_a SalesEngine
    end
  end

  describe '#items' do
    it 'has an ItemRepository' do
      sales_engine = SalesEngineMocks.sales_engine(self)

      expect(sales_engine.items).to be_an ItemRepository
      sales_engine.all_items
      expect(sales_engine.items).to have_received(:all)
    end
  end

  describe '#merchants' do
    it 'has an MerchantRepository' do
      sales_engine = SalesEngineMocks.sales_engine(self)

      expect(sales_engine.merchants).to be_a MerchantRepository
      sales_engine.all_merchants
      expect(sales_engine.merchants).to have_received(:all)
    end
  end

  describe '#invoices' do
    it 'has an InvoiceRepository' do
      sales_engine = SalesEngineMocks.sales_engine(self)

      expect(sales_engine.invoices).to be_an InvoiceRepository
      sales_engine.all_invoices
      expect(sales_engine.invoices).to have_received(:all)
    end
  end

  describe '#transactions' do
    it 'has an TransactionRepository' do
      sales_engine = SalesEngineMocks.sales_engine(self)

      expect(sales_engine.transactions).to be_an TransactionRepository
      sales_engine.all_transactions
      expect(sales_engine.transactions).to have_received(:all)
    end
  end

  describe '#invoice_items' do
    it 'has an InvoiceItemRepository' do
      sales_engine = SalesEngineMocks.sales_engine(self)
      invoice_item_repo = sales_engine.invoice_items

      expect(invoice_item_repo).to be_an InvoiceItemRepository
      sales_engine.all_invoice_items
      expect(sales_engine.invoice_items).to have_received(:all)
    end
  end

  describe '#customers' do
    it 'has a CustomerRepository' do
      sales_engine = SalesEngineMocks.sales_engine(self)
      customer_repo = sales_engine.customers

      expect(customer_repo).to be_a CustomerRepository
      sales_engine.all_customers
      expect(sales_engine.customers).to have_received(:all)
    end
  end

  describe '#analyst' do
    it 'returns a new instance of SalesAnalyst' do
      sales_engine = SalesEngineMocks.sales_engine(self)
      sales_analyst = sales_engine.analyst

      expect(sales_analyst).to be_a SalesAnalyst
    end
  end
end
