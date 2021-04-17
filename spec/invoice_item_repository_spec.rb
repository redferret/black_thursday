require 'rspec'
require 'csv'
require './lib/file_io'
require './lib/invoice_item_repository'

describe InvoiceItemRepository do 
  describe '#initialize' do
    it 'exists' do
      allow_any_instance_of(InvoiceItemRepository).to receive(:create_invoice_items).and_return(MockData.invoice_items_as_hashes)
      ii_repo = InvoiceItemRepository.new('fake.csv')

      expect(ii_repo).is_a? InvoiceItemRepository
    end
  end

  describe '#all' do
    it 'returns all known InvoiceItem instances' do
      allow_any_instance_of(InvoiceItemRepository).to receive(:create_invoice_items).and_return(MockData.invoice_items_as_hashes)
      ii_repo = InvoiceItemRepository.new('fake.csv')

      expected = ii_repo.all.length
      expect(expected).to eq 10
    end
  end

  describe '#find_by_id' do
    it 'returns either nil or an instance of InvoiceItemRepository with matching ID' do
      mock_data = MockData.invoice_items_as_mocks(self)
      allow_any_instance_of(InvoiceItemRepository).to receive(:create_invoice_items).and_return(mock_data)
      ii_repo = InvoiceItemRepository.new('fake.csv')

      expected = ii_repo.invoice_items.first
      expect(ii_repo.find_by_id(50)).to eq nil
      expect(ii_repo.find_by_id(0)).to eq expected
    end
  end

  describe '#find_all_by_item_id' do
    it 'returns either [] or array of InvoiceItems with matching item ID' do
      details = MockData.invoice_items_as_hashes(item_id_range: (1..1))
      mock_data = MockData.invoice_items_as_mocks(self, details)
      allow_any_instance_of(InvoiceItemRepository).to receive(:create_invoice_items).and_return(mock_data)
      ii_repo = InvoiceItemRepository.new('fake.csv')

      expect(ii_repo.find_all_by_item_id(59)).to eq []
      expect(ii_repo.find_all_by_item_id(1).length).to eq 10
      expect(ii_repo.find_all_by_item_id(1).first.class).is_a? InvoiceItem
    end
  end

  describe '#find_all_by_invoice_id' do
    it 'returns either [] or array of InvoiceItems with matching invoice ID' do
      details = MockData.invoice_items_as_hashes(invoice_id_range: (1..1))
      mock_data = MockData.invoice_items_as_mocks(self, details)
      allow_any_instance_of(InvoiceItemRepository).to receive(:create_invoice_items).and_return(mock_data)
      ii_repo = InvoiceItemRepository.new('fake.csv')

      expect(ii_repo.find_all_by_invoice_id(59)).to eq []
      expect(ii_repo.find_all_by_invoice_id(1).length).to eq 10
      expect(ii_repo.find_all_by_invoice_id(1).first.class).is_a? InvoiceItem
    end
  end

  describe '#create' do
    it 'creates a new InvoiceItem with provided attributes' do
      mock_data = MockData.invoice_items_as_mocks(self)
      allow_any_instance_of(InvoiceItemRepository).to receive(:create_invoice_items).and_return(mock_data)
      ii_repo = InvoiceItemRepository.new('fake.csv')

      attributes = {
        :id => nil,
        :item_id => 17,
        :invoice_id => 81,
        :quantity => 1,
        :unit_price => BigDecimal(10.99, 4),
        :created_at => Time.now,
        :updated_at => Time.now
              }

      ii_repo.create(attributes)

      expected = ii_repo.invoice_items.last
      expect(ii_repo.all.length).to eq 11
      expect(expected.invoice_id).to eq 81
    end

    it 'sets id to current highest InvoiceItem id plus 1' do
      mock_data = MockData.invoice_items_as_mocks(self)
      allow_any_instance_of(InvoiceItemRepository).to receive(:create_invoice_items).and_return(mock_data)
      ii_repo = InvoiceItemRepository.new('fake.csv')

      attributes = {
        :id => nil,
        :item_id => 17,
        :invoice_id => 81,
        :quantity => 1,
        :unit_price => BigDecimal(10.99, 4),
        :created_at => Time.now,
        :updated_at => Time.now
              }

      ii_repo.create(attributes)

      expected = ii_repo.invoice_items.last
      expect(expected.id).to eq 10
    end
  end

  describe '#find_max_id' do
    it 'finds the highest id and returns it as an integer' do
      mock_data = MockData.invoice_items_as_mocks(self)
      allow_any_instance_of(InvoiceItemRepository).to receive(:create_invoice_items).and_return(mock_data)
      ii_repo = InvoiceItemRepository.new('fake.csv')

      expect(ii_repo.find_max_id).to eq 9
    end
  end

  describe '#create_first_invoice_item' do
    it 'can create an invoice item when InvoiceRepository has empty array of InvoiceItems' do
      mock_data = MockData.invoice_items_as_mocks(self)
      allow_any_instance_of(InvoiceItemRepository).to receive(:create_invoice_items).and_return([])
      ii_repo = InvoiceItemRepository.new('fake.csv')

      attributes = {
        :id => nil,
        :item_id => 17,
        :invoice_id => 81,
        :quantity => 1,
        :unit_price => BigDecimal(10.99, 4),
        :created_at => Time.now,
        :updated_at => Time.now
              }

      expected = ii_repo.create(attributes)

      expect(ii_repo.invoice_items).to eq expected
      expect(ii_repo.invoice_items.first.id).to eq 1
    end
  end

  describe '#update' do
    it 'updates the InvoiceItem instance with corresponding id to provided attributes' do
      mock_data = MockData.invoice_items_as_mocks(self)
      allow_any_instance_of(InvoiceItemRepository).to receive(:create_invoice_items).and_return(mock_data)
      ii_repo = InvoiceItemRepository.new('fake.csv')

      new_invoice_item = {
        :id => nil,
        :item_id => 17,
        :invoice_id => 81,
        :quantity => 1,
        :unit_price => BigDecimal(10.99, 4),
        :created_at => Time.now,
        :updated_at => Time.now
              }

      ii_repo.create(new_invoice_item)

      attributes = { 
        :quantity => 17,
        :unit_price => BigDecimal(51.19, 4)
        }
      ii_repo.update(10, attributes)

      expected = ii_repo.invoice_items.last

      expect(expected.quantity).to eq 17
      expect(expected.unit_price).to eq 51.19
    end

    it 'updates the updated_at time' do
      mock_data = MockData.invoice_items_as_mocks(self)
      allow_any_instance_of(InvoiceItemRepository).to receive(:create_invoice_items).and_return(mock_data)
      ii_repo = InvoiceItemRepository.new('fake.csv')

      new_invoice_item = {
        :id => nil,
        :item_id => 17,
        :invoice_id => 81,
        :quantity => 1,
        :unit_price => BigDecimal(10.99, 4),
        :created_at => Time.now,
        :updated_at => Time.now
              }

      ii_repo.create(new_invoice_item)
      originial_invoice_item = ii_repo.find_by_id(10)
      original_time = originial_invoice_item.updated_at

      attributes = { 
        :quantity => 17,
        :unit_price => BigDecimal(51.19, 4)
        }
      ii_repo.update(10, attributes)

      updated_invoice_item = ii_repo.find_by_id(10)

      expect(updated_invoice_item.updated_at).to be > original_time
    end
  end
end
