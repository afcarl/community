
class CasesController < ApplicationController

  def index
    begin
      @cases = Desk.new.get_cases
      if @cases.nil?
        flash[:error]  = 'API call to Desk.com was not successful'
      else
        flash[:notice] = 'API call to Desk.com was successful'
      end
    rescue Exception => e
      @cases = nil
      Rails.logger.error e.inspect
    end
  end

end
