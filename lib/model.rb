require 'time'

class Model
  attr_reader :id

  def initialize(attributes)
    @id = attributes[:id].to_i
    @created_at = attributes[:created_at]
    @updated_at = attributes[:updated_at]
  end

  def update_time
    @updated_at = Time.now
  end

  def update_id(id)
    @id = id
  end

  def created_at
    return @created_at if @created_at.instance_of?(Time)
    @created_at = Time.parse(@created_at)
  end

  def updated_at
    return @updated_at if @updated_at.instance_of?(Time)
    @updated_at = Time.parse(@updated_at)
  end
end
