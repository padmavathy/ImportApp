class Operation < ActiveRecord::Base
  has_and_belongs_to_many :categories
  belongs_to :company

  validates_presence_of :invoice_num, :invoice_date, :amount, :operation_date, :kind, :status
  validates_numericality_of :amount, greater_than: 0
  validates_uniqueness_of :invoice_num
  def self.opt_count
    self.all.count
  end

  def self.no_of_imp_row
    self.where.not(:company_id => 0).count
  end

  def self.no_of_failed_row
    self.where(:company_id => 0).count
  end
end
