require 'rspec'
require './lib/transaction'

describe Transaction do
  describe '#initialize' do
    it 'exists' do
      details = ({
        :id => 6,
        :invoice_id => 8,
        :credit_card_number => "4242424242424242",
        :credit_card_expiration_date => "0220",
        :result => "success",
        :created_at => Time.now,
        :updated_at => Time.now
          })

      transaction = Transaction.new(details)

      expect(transaction).is_a? Transaction
    end

    it 'has an id' do
      details = ({
        :id => 6,
        :invoice_id => 8,
        :credit_card_number => "4242424242424242",
        :credit_card_expiration_date => "0220",
        :result => "success",
        :created_at => Time.now,
        :updated_at => Time.now
          })

      transaction = Transaction.new(details)

      expect(transaction.id).to eq 6
    end

  end

end