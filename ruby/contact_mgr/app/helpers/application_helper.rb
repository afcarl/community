module ApplicationHelper

  def all_contacts
    Contact.all.to_a
  end

  def current_contact_id
    session[:current_contact_id]
  end

  def bootstrap_flash_class(name)
    case name.to_s.to_sym
      when :notice then "bg-success"
      when :error  then "bg-danger"
      when :alert  then "bg-info"
      else "none"
    end
  end

  def contact_sex_options
    [['Male', 'male'], ['Female', 'female']]
  end

end
