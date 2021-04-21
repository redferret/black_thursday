require_relative './repository'

class CustomerRepository < Repository
  attr_reader :customers

  def inspect
    "#<#{self.class} #{@models.size} rows>"
  end

  def initialize(filename)
    load_models(filename, Customer)
  end

  def find_all_by_first_name(name)
    find_all_by do |customer|
      customer.first_name.downcase.include?(name.downcase)
    end
  end

  def find_all_by_last_name(name)
    find_all_by do |customer|
      customer.last_name.downcase.include?(name.downcase)
    end
  end

  def create(attributes)
    new_customer = Customer.new(attributes)
    super(new_customer)
  end

  def update(id, attributes)
    customer = find_by_id(id)
    unless customer.nil?
      customer.update_first_name(attributes[:first_name])
      customer.update_last_name(attributes[:last_name])
      customer.update_time
    end
  end
end
