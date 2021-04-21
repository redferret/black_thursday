require_relative './model'

class Merchant < Model
  attr_reader :name

  def initialize(details)
    super
    @name = details[:name]
  end

  def update_name(name)
    @name = name
  end

  def update_time
    @updated_at = Time.now
  end

  def update_id(id)
    @id = id
  end
end
