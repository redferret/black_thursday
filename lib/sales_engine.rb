require 'CSV'
require './lib/item'
require './lib/merchant'

class SalesEngine
  attr_reader :items, :merchants

  def self.from_csv(files)
    instance = SalesEngine.new
    instance.load_items(files[:items])
    instance.load_merchants(files[:merchants])
    instance
  end

  def load_items(file_name)
    @items = []
    CSV.foreach(file_name, headers: true, header_converters: :symbol) do |row|
      @items << Item.new(row)
    end
  end

  def load_merchants(file_name)
    @merchants = []
    CSV.foreach(file_name, headers: true, header_converters: :symbol) do |row|
      @merchants << Merchant.new(row)
    end
  end

  def analyst
  end 
end
