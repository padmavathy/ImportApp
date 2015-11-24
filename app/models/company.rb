class Company < ActiveRecord::Base
  has_many :operations

  validates_presence_of :name
  def self.find_company(id)
    company = Company.find_by_id(id)
  end
  def number_of_operations
     self.operations.count
  end
  def avg_amount_operation
     self.operations.average(:amount)
  end
  def  max_amount_of_opt
     self.operations.map(&:amount).max
  end
  def  no_of_opt_status_accepted
     self.operations.where(:status => "accepted").count
  end

  def to_csv(options = {})
    column_names = %w{invoice_num invoice_date operation_date amount reporter notes status kind }
    company_column_name = %w{company}
    company_name = %w{name}
    CSV.generate(options) do |csv|
      csv.add_row column_names + company_column_name

      self.operations.each do |opt|

        values = opt.attributes.slice(*column_names).values

        if opt.company
          values += opt.company.attributes.slice(*company_name).values
        end

        csv.add_row values
      end
    end
  end

  def self.search(search)
     Operation.where('lower(status) LIKE :search OR lower(kind) LIKE :search OR lower(invoice_num) LIKE :search OR lower(reporter) LIKE :search', search: "%#{search.downcase}%")
  end

end
