require 'rspec'
require './data/merchant_mocks'
require './lib/merchant'
require './lib/merchant_repository'

describe MerchantRepository do
  describe '#initialize' do
    it 'exists' do
      mock_data = MerchantMocks.merchants_as_hashes
      allow(FileIo).to receive(:process_csv).and_return(mock_data)
      m_repo = MerchantRepository.new('fake.csv')

      expect(m_repo).is_a? MerchantRepository
    end

    it 'has a merchants array' do
      mock_data = MerchantMocks.merchants_as_hashes
      allow(FileIo).to receive(:process_csv).and_return(mock_data)
      m_repo = MerchantRepository.new('fake.csv')

      expect(m_repo.all).is_a? Array
    end
  end

  describe '#all' do
    it 'returns the list of Merchants' do
      mock_data = MerchantMocks.merchants_as_mocks(self)
      allow(FileIo).to receive(:process_csv).and_return(mock_data)
      m_repo = MerchantRepository.new('fake.csv')

      expect(m_repo.all.length).to eq 10
    end
  end

  describe '#find_by_id' do
    it 'finds the merchant by the given id' do
      mock_data = MerchantMocks.merchants_as_mocks(self)
      allow(FileIo).to receive(:process_csv).and_return(mock_data)
      m_repo = MerchantRepository.new('fake.csv')

      expected = m_repo.all.first
      actual = m_repo.find_by_id(0)
      expect(actual).to eq expected
    end

    it 'retunrs nil if no merchant exists for id' do
      details = MerchantMocks.merchants_as_hashes
      mock_data = MerchantMocks.merchants_as_mocks(self, details)
      allow(FileIo).to receive(:process_csv).and_return(mock_data)
      m_repo = MerchantRepository.new('fake.csv')

      actual = m_repo.find_by_id(30)
      expect(actual).to be_nil
    end
  end

  describe '#find_by_name' do
    it 'finds a merchant by the given name' do
      mock_data = MerchantMocks.merchants_as_mocks(self)
      allow(FileIo).to receive(:process_csv).and_return(mock_data)
      m_repo = MerchantRepository.new('fake.csv')

      expected = m_repo.all.first
      actual = m_repo.find_by_name('Merchant 0')
      expect(actual).to eq expected
    end
  end

  describe '#find_all_by_name' do
    it 'finds all merchants by the given name' do
      mock_data = MerchantMocks.merchants_as_mocks(self)
      allow(FileIo).to receive(:process_csv).and_return(mock_data)
      m_repo = MerchantRepository.new('fake.csv')

      m_repo.create({ name: 'Merchant 0' })
      m_repo.create({ name: 'Merchant 0' })
      m_repo.create({ name: 'Merchant 0' })

      merchants = m_repo.find_all_by_name('Merchant 0')
      merchants.each do |merchant|
        expect(merchant.name).to eq 'Merchant 0'
      end
    end
  end

  describe '#delete' do
    it 'deletes a merchant with the given id' do
      mock_data = MerchantMocks.merchants_as_mocks(self)
      allow(FileIo).to receive(:process_csv).and_return(mock_data)
      m_repo = MerchantRepository.new('fake.csv')

      expect(m_repo.all.length).to eq 10
      m_repo.delete(2)
      expect(m_repo.all.length).to eq 9
    end

    it 'does nothing if no merchant with given id' do
      details = MerchantMocks.merchants_as_hashes
      mock_data = MerchantMocks.merchants_as_mocks(self, details)
      allow(FileIo).to receive(:process_csv).and_return(mock_data)
      m_repo = MerchantRepository.new('fake.csv')

      expect(m_repo.all.length).to eq 10
      m_repo.delete(56)
      expect(m_repo.all.length).to eq 10
    end
  end

  describe '#create' do
    it 'creates a new Merchant' do
      mock_data = MerchantMocks.merchants_as_mocks(self)
      allow(FileIo).to receive(:process_csv).and_return(mock_data)
      m_repo = MerchantRepository.new('fake.csv')
      allow(m_repo).to receive(:newest_id).and_return(10)

      m_repo.create({ name: 'Sami' })
      new_merchant = m_repo.all.last.name

      expect(m_repo.all.length).to eq 11
      expect(new_merchant).to eq 'Sami'
    end
  end

  describe '#update' do
    it 'updates a merchant with the given id and attributes' do
      mock_data = MerchantMocks.merchants_as_mocks(self)
      allow(FileIo).to receive(:process_csv).and_return(mock_data)
      m_repo = MerchantRepository.new('fake.csv')

      m_repo.create({ name: 'Sami' })
      new_merchant = m_repo.all.last
      m_repo.update(10, { name: 'Dustin Huntsman' })

      expect(new_merchant.name).to eq 'Dustin Huntsman'
    end

    it 'does nothing if no merchant with given id and attributes' do
      details = MerchantMocks.merchants_as_hashes
      mock_data = MerchantMocks.merchants_as_mocks(self, details)
      allow(FileIo).to receive(:process_csv).and_return(mock_data)
      m_repo = MerchantRepository.new('fake.csv')

      m_repo.create({ id: 0, name: 'Sami' })
      new_merchant = m_repo.all.last
      m_repo.update(56, { name: 'Dustin Huntsman' })
    end
  end
end
