require './lib/model'

class Transaction < Model
  attr_reader :invoice_id,
              :credit_card_number,
              :credit_card_expiration_date,
              :result

  def initialize(details)
    super
    @invoice_id = details[:invoice_id].to_i
    @credit_card_number = details[:credit_card_number]
    @credit_card_expiration_date = details[:credit_card_expiration_date]
    @result = details[:result].to_sym
  end

  def update_credit_card_number(credit_card_number)
    @credit_card_number = credit_card_number unless credit_card_number.nil?
  end

  def update_credit_card_exp_date(credit_card_expiration_date)
    unless credit_card_expiration_date.nil?
      @credit_card_expiration_date = credit_card_expiration_date
    end
  end

  def update_result(result)
    @result = result unless result.nil?
  end
end
