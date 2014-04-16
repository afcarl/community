json.array!(@contacts) do |contact|
  json.extract! contact, :id, :name, :sex, :age, :birthday, :phone, :email, :street, :city, :state, :postal_code
  json.url contact_url(contact, format: :json)
end
