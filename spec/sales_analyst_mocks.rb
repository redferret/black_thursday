require 'csv'

require './data/invoice_mocks'
require './data/invoice_item_mocks'
require './spec/sales_engine_mocks'
require './lib/item_repository'
require './lib/invoice_repository'
require './lib/invoice_item_repository'
require './lib/sales_analyst'

class SalesAnalystMocks
  def self.price_sums_for_each_merchant
    @@price_sums_for_each_merchant
  end

  def self.sales_analyst_mock(eg)
    merchants_as_mocks = MerchantMocks.merchants_as_mocks(eg)

    items_as_hashes = ItemMocks.items_as_hashes(unit_price: 1000.0,
                                                number_of_hashes: 3,
                                                merchant_id: 0)
    items_as_hashes += ItemMocks.items_as_hashes(number_of_hashes: 7, merchant_id: 1)
    items_as_hashes += ItemMocks.items_as_hashes(number_of_hashes: 4, merchant_id: 2)
    items_as_hashes += ItemMocks.items_as_hashes(number_of_hashes: 12, merchant_id: 3)

    invoices_as_hashes = InvoiceMocks.invoices_as_hashes(number_of_hashes: 1, random_dates: false, created_at: proc {Time.new(2020, 1, 11)}, status: :pending, merchant_id: (0))
    invoices_as_hashes += InvoiceMocks.invoices_as_hashes(number_of_hashes: 2, random_dates: false, created_at: proc { Time.new(2020, 2, 12) }, status: :shipped, merchant_id: (1))
    invoices_as_hashes += InvoiceMocks.invoices_as_hashes(number_of_hashes: 3, random_dates: false, created_at: proc { Time.new(2020, 3, 13) }, status: :returned, merchant_id: (2))
    invoices_as_hashes += InvoiceMocks.invoices_as_hashes(number_of_hashes: 3, random_dates: false, created_at: proc { Time.new(2020, 4, 14) }, status: :shipped, merchant_id: (3))
    invoices_as_hashes += InvoiceMocks.invoices_as_hashes(number_of_hashes: 3, random_dates: false, created_at: proc { Time.new(2020, 5, 15) }, status: :returned, merchant_id: (4))
    invoices_as_hashes += InvoiceMocks.invoices_as_hashes(number_of_hashes: 3, random_dates: false, created_at: proc { Time.new(2020, 6, 16) }, status: :shipped, merchant_id: (5))
    invoices_as_hashes += InvoiceMocks.invoices_as_hashes(number_of_hashes: 3, random_dates: false, created_at: proc { Time.new(2020, 7, 17) }, status: :returned, merchant_id: (6))
    invoices_as_hashes += InvoiceMocks.invoices_as_hashes(number_of_hashes: 3, random_dates: false, created_at: proc { Time.new(2020, 8, 18) }, status: :pending, merchant_id: (7))
    invoices_as_hashes += InvoiceMocks.invoices_as_hashes(number_of_hashes: 3, random_dates: false, created_at: proc { Time.new(2020, 9, 19) }, status: :returned, merchant_id: (8))
    invoices_as_hashes += InvoiceMocks.invoices_as_hashes(number_of_hashes: 12, random_dates: false, created_at: proc { Time.new(2020, 10, 20) }, status: :returned, merchant_id: (0))

    transactions_as_hashes = TransactionMocks.transactions_as_hashes(random_dates: false, invoice_id: 0, result: :success)
    transactions_as_hashes += TransactionMocks.transactions_as_hashes(random_dates: false, invoice_id: 1, result: :failure)
    transactions_as_hashes += TransactionMocks.transactions_as_hashes(random_dates: false, invoice_id: 9, result: :failure)

    invoice_items_as_hashes = InvoiceItemMocks.invoice_items_as_hashes(number_of_hashes: 4, invoice_id: 0, quantity: 2, unit_price: 10.00,
      item_id: 0)

    @@price_sums_for_each_merchant = merchants_as_mocks.each_with_object({}) do |merchant, sums_by_merchant|
      item_hashes = items_as_hashes.find_all do |item_hash|
        item_hash[:merchant_id] == merchant.id
      end
      sum_of_prices = Mockable.sum_item_prices_from_hash(item_hashes)
      sums_by_merchant[merchant.id] = sum_of_prices
    end

    items_as_mocks = ItemMocks.items_as_mocks(eg, items_as_hashes)
    invoices_as_mocks = InvoiceMocks.invoices_as_mocks(eg, invoices_as_hashes)
    invoice_items_as_mocks = InvoiceItemMocks.invoice_items_as_mocks(eg, invoice_items_as_hashes)
    transactions_as_mocks = TransactionMocks.transactions_as_mocks(eg, transactions_as_hashes)

    eg.allow_any_instance_of(ItemRepository).to eg.receive(:create_items).and_return(items_as_mocks)
    eg.allow_any_instance_of(MerchantRepository).to eg.receive(:create_merchants).and_return(merchants_as_mocks)
    eg.allow_any_instance_of(InvoiceRepository).to eg.receive(:create_invoices).and_return(invoices_as_mocks)
    eg.allow_any_instance_of(TransactionRepository).to eg.receive(:create_transactions).and_return(transactions_as_mocks)
    eg.allow_any_instance_of(InvoiceItemRepository).to eg.receive(:create_invoice_items).and_return(invoice_items_as_mocks)

    item_repository = ItemRepository.new('fake_file')
    merchant_repository = MerchantRepository.new('fake_file')
    invoice_repository = InvoiceRepository.new('fake_file')
    transaction_repository = TransactionRepository.new('fake_file')
    invoice_item_repository = InvoiceItemRepository.new('fake_file')

    sales_engine = eg.instance_double("SalesEngine")

    eg.allow(sales_engine).to eg.receive(:items).and_return item_repository
    eg.allow(sales_engine).to eg.receive(:merchants).and_return merchant_repository
    eg.allow(sales_engine).to eg.receive(:transactions).and_return transaction_repository
    eg.allow(sales_engine).to eg.receive(:invoices).and_return invoice_repository
    eg.allow(sales_engine).to eg.receive(:invoice_items).and_return invoice_item_repository
    eg.allow(sales_engine).to eg.receive(:all_items).and_return item_repository.items
    eg.allow(sales_engine).to eg.receive(:all_merchants).and_return merchant_repository.merchants
    eg.allow(sales_engine).to eg.receive(:all_invoices).and_return invoice_repository.invoices
    eg.allow(sales_engine).to eg.receive(:all_transactions).and_return transaction_repository.transactions
    eg.allow(sales_engine).to eg.receive(:all_invoice_items).and_return invoice_item_repository.invoice_items

    SalesAnalyst.new(sales_engine)
  end
end
