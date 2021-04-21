require_relative './model'

class Customer < Model
  attr_reader  :first_name,
               :last_name

  def initialize(details)
    super
    @first_name = details[:first_name]
    @last_name = details[:last_name]
  end

  def update_first_name(name)
    return false if name.nil?

    @first_name = name
  end

  def update_last_name(name)
    return false if name.nil?

    @last_name = name
  end
end
