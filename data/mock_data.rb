class MockData

  def self.get_a_random_date(random = true)
    if random
      date_s = "20#{rand(10..21)}-#{rand(1..12)}-#{rand(1..28)}"
      return Date.strptime(date_s, '%Y-%m-%d')
    else
      return Date.strptime('2020-01-01', '%Y-%m-%d')
    end
  end

  def self.get_mock_merchants(number_of_mocks = 10, random_dates = true)
    mocked_merchants = []
    number_of_mocks.times do |merchant_number|
      merchant = {}
      date = get_a_random_date(random_dates)
      merchant[:name] = "Merchant #{merchant_number}"
      merchant[:id] = merchant_number
      merchant[:created_at] = date.prev_year.to_s
      merchant[:updated_at] = date.to_s
      mocked_merchants << merchant
    end
    mocked_merchants
  end

  def self.get_mock_items(number_of_mocks = 10, random_prices = true)
    
  end
end