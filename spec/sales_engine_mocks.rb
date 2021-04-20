require './lib/repository'

class SalesEngineMocks
  def self.sales_engine(eg)
    eg.allow_any_instance_of(Repository).to eg.receive(:load_models)

    files = { items: './file1.csv', merchants: './file2.csv', invoices: './file3.csv',
              transactions: './file4.csv', invoice_items: './file5.csv', customers: './file6.csv' }
    SalesEngine.from_csv(files)
  end
end
