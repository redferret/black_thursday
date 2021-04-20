require './lib/model'

class Merchant < Model
  attr_reader :name

  def initialize(details)
    super
    @name = details[:name]
  end

  def update_name(name)
    @name = name
  end
end
