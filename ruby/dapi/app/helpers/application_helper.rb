
module ApplicationHelper

  def app_name
    'DAPI'
  end

  def desk_site_name
    'JoakimSoftware LLC'
  end

  def epoch_label
    "Label_#{Time.now.to_i}"
  end

  def bootstrap_flash_class(name)
    case name
      when :notice then "bg-success"
      when :error  then "bg-danger"
      when :alert  then "bg-info"
      else "none"
    end
  end

end
