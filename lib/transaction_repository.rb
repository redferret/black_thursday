require_relative './repository'

class TransactionRepository < Repository
  def inspect
    "#<#{self.class} #{@models.size} rows>"
  end

  def initialize(filename)
    load_models(filename, Transaction)
  end

  def find_all_by_invoice_id(invoice_id)
    find_all_by do |transaction|
      transaction.invoice_id == invoice_id
    end
  end

  def find_all_by_credit_card_number(credit_card_number)
    find_all_by do |transaction|
      transaction.credit_card_number == credit_card_number
    end
  end

  def find_all_by_result(result)
    find_all_by do |transaction|
      transaction.result == result
    end
  end

  def create(attributes)
    new_transaction = Transaction.new(attributes)
    super(new_transaction)
  end

  def update(id, attributes)
    super(id, attributes) do |transaction|
      transaction.update_credit_card_number(attributes[:credit_card_number])
      transaction.update_credit_card_exp_date(attributes[:credit_card_expiration_date])
      transaction.update_result(attributes[:result])
    end
  end

  def any_success?(invoice_id)
    @models.any? do |transaction|
      transaction.invoice_id == invoice_id && transaction.success?
    end
  end
end
