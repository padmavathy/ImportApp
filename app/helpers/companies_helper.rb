module CompaniesHelper
  def company_operations(com_id)
     operations =  Operation.where(:company_id => com_id).order("operation_date ASC").map(&:id).first(5)
  end
end
