require 'csv'
class CompaniesController < ApplicationController
  helper CompaniesHelper
  def index
    @companies = Company.all
  end

  def search
     @search_results = Company.search(params["search"]).paginate(page: params[:page], per_page: 25)
     respond_to do |format|
       format.js # search.js.erb
     end
  end

  def show
    @company = Company.find_company(params["id"])
    @no_of_operations = @company.number_of_operations
    @avg_amount_operation = @company.avg_amount_operation
    @max_amount_of_opt = @company.max_amount_of_opt
    @no_of_opt_status_accepted = @company.no_of_opt_status_accepted
    respond_to do |format|
      #format.html # show.html.erb
      format.js # show.js.erb
      format.csv { send_data @company.to_csv, filename: "company-#{Date.today}.csv" }
    end
  end
end
