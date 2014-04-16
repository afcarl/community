namespace :data do

  desc 'Add dummy rows to the contacts table'
  task :add_contacts => :environment do
    50.times do | n |
      name = "Clone#{n+1}"
      c = Contact.new
      c.name     = name
      c.sex      = 'male'
      c.phone    = '704-888-8888'
      c.email    = "#{name}@gmail.com".downcase
      c.birthday = '1980-04-01'.to_date
      c.street   = "#{n+1} Industrial Pkwy"
      c.city     = "Charlotte"
      c.state    = "NC"
      c.postal_code = '28666'
      c.save!
      puts c.inspect
    end
  end

end
