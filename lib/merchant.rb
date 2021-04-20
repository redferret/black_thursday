class Merchant
  attr_reader :id,
              :name,
              :created_at,
              :updated_at

  def initialize(details)
    @id = details[:id].to_i
    @name = details[:name]
    @created_at = details[:created_at]
    @updated_at = details[:updated_at]
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
