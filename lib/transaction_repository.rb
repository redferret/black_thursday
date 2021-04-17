# frozen_string_literal: true

require_relative './transaction'

class TransactionRepository
  attr_reader :transactions

  def initialize(filename)
    @transactions = create_transactions(filename)
  end

  def create_transactions(filename)
    FileIo.process_csv(filename, Transaction)
  end

  def all
    @transactions
  end

  def find_by_id(id)
    @transactions.find { |transaction| transaction.id == id }
  end

  def find_all_by_invoice_id(invoice_id)
    @transactions.find_all do |transaction|
      transaction.invoice_id == invoice_id
    end
  end

  def find_all_by_credit_card_number(credit_card_number)
    @transactions.find_all do |transaction|
      transaction.credit_card_number == credit_card_number
    end
  end

  def find_all_by_result(result)
    @transactions.find_all do |transaction|
      transaction.result == result
    end
  end

  def find_max_id
    @transactions.max_by(&:id).id
  end

  def create(attributes)
    new_transaction = Transaction.new(attributes)
    new_transaction.update_id(find_max_id + 1)
    @transactions << new_transaction
  end 
end
