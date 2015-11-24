require 'csv'
class HomeController < ApplicationController
  before_filter :operation_check, :only => [:upload_url]
  def index

  end
  def upload_csv
     @operations = Operation.all
     @operations_count = Operation.opt_count
     @import_successed_rows = Operation.no_of_imp_row
     @import_failed_rows= Operation.no_of_failed_row
  end
  def upload_url
    if params[:file_path].present?
     CSV.foreach(params[:file_path].path, headers: true, encoding: 'ISO-8859-1:UTF-8') do |row|
       a = row.to_hash
       company = Company.find_by_name(a['company'].lstrip.rstrip)  if !a['company'].nil?
       company_id = company.nil? ? 0 : company.id
       Operation.create(
           :invoice_num => a['invoice_num'],
           :invoice_date => a['invoice_date'],
           :operation_date => a['operation_date'],
           :amount => a['amount'],
           :reporter => a['reporter'],
           :notes => a['notes'],
           :status => a['status'],
           :kind => a['kind'],
           :company_id => company_id
       )
      kind_downcase = a['kind'].downcase.split(";").sort! if !a['kind'].nil?
      kind_arr_str =  kind_downcase.join(";")  if !kind_downcase.nil?
       Category.find_or_create_by(
          :name => kind_arr_str
       )

  end
    redirect_to home_upload_csv_path
    else
      flash[:alert] = "Please Upload a file"
      redirect_to home_upload_csv_path
   end

  end

  def operation_check
   if Operation.all.empty?
     return true
   else
     flash[:alert] = "Could not upload CSV More than once"
     redirect_to home_upload_csv_path
   end
  end

end

