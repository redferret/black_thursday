require './lib/model'

class Invoice < Model
  attr_reader :customer_id,
              :merchant_id,
              :status

  def initialize(transaction_details)
    super
    @customer_id = transaction_details[:customer_id].to_i
    @merchant_id = transaction_details[:merchant_id].to_i
    @status = transaction_details[:status].to_sym
  end

  def update_status(status)
    @status = status unless status.nil?
  end
end
