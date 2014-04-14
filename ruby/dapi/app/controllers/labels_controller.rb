
class LabelsController < ApplicationController

  def index
    begin
      @labels = get_labels
    rescue Exception => e
      @labels = nil
      Rails.logger.error e.inspect
    end
  end

  def create
    name, desc = params[:name], params[:description]
    begin
      api = Desk.new
      post_data = {
        'name'        => name,
        'description' => desc,
        'types'       => ['case', 'macro'],
        'color'       => 'red',
        'enabled'     => true
      }
      result = api.create_label(post_data)
      Rails.logger.error("create_label result: #{result.inspect}")
      if result && result['id']
        flash[:notice] = "Label created; id: #{result['id']}  name: #{name}"
      else
        flash[:error] = "Error creating label with name '#{name}'"
      end
    rescue Exception => e
      flash[:error] = "Exception creating label with name '#{name}'"
      Rails.logger.error e.inspect
    ensure
      @labels = get_labels
    end
    redirect_to labels_index_path
  end

  private

  def get_labels
    begin
      Desk.new.get_labels
    rescue Exception => e
      Rails.logger.error e.inspect
      nil
    end
  end

end
