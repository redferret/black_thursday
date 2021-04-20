require_relative './repository'

class MerchantRepository < Repository
  def inspect
    "#<#{self.class} #{@models.size} rows>"
  end

  def initialize(filename)
    load_models(filename, Merchant)
  end

  def find_by_name(name)
    find_by do |merchant|
      merchant.name.downcase == name.downcase
    end
  end

  def find_all_by_name(name)
    find_all_by do |merchant|
      merchant.name.downcase == name.downcase
    end
  end

  def create(attributes)
    merchant = Merchant.new(attributes)
    super(merchant)
  end

  def update(id, attributes)
    super(id, attributes) do |merchant|
      merchant.update_name(attributes[:name])
    end
  end
end
