require 'rspec'
require 'csv'
require './lib/file_io'
require './lib/customer_repository'

describe CustomerRepository do
  details = {
    id: 1,
    first_name: 'Julia',
    last_name: 'Child',
    created_at: Time.now,
    updated_at: Time.now
  }
  customer_hashes = []
  10.times { customer_hashes << details }

  describe '#initialize' do
    it 'exists' do
      mock_data = MockData.mock_generator(self, 'Customer', customer_hashes)
      allow_any_instance_of(CustomerRepository).to receive(:create_customers).and_return(mock_data)
      c_repo = CustomerRepository.new('fake.csv')

      expect(c_repo).is_a? CustomerRepository
    end

    it 'has a customers array' do
      mock_data = MockData.mock_generator(self, 'Customer', customer_hashes)
      allow_any_instance_of(CustomerRepository).to receive(:create_customers).and_return(mock_data)
      c_repo = CustomerRepository.new('fake.csv')

      expect(c_repo.customers).is_a? Array
    end
  end

  describe '#all' do
    it 'returns an array of all customers' do
      mock_data = MockData.mock_generator(self, 'Customer', customer_hashes)
      allow_any_instance_of(CustomerRepository).to receive(:create_customers).and_return(mock_data)
      c_repo = CustomerRepository.new('fake.csv')

      expect(c_repo.all.length).to eq 10
    end
  end

  describe '#find_by_id' do
    it 'returns a Customer with matching id' do
      mock_data = MockData.mock_generator(self, 'Customer', customer_hashes)
      allow_any_instance_of(CustomerRepository).to receive(:create_customers).and_return(mock_data)
      c_repo = CustomerRepository.new('fake.csv')

      expected = c_repo.customers.first
      expect(c_repo.find_by_id(1)).to eq expected
    end
  end
end
