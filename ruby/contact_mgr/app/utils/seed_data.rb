
class SeedData

  attr_reader :options

  def initialize(opts={})
    @options  = opts
  end

  def load
    begin
      load_contacts
    rescue Exception => e
      Rails.logger.error("Exception in SeedData.load - #{e.class.name} - #{e.message}")
    end
  end

  def load_contacts
    contacts = JSON.parse(IO.read("db/data/contacts.json"))
    contacts.each do | cdata |
      adata = cdata['address']
      c = Contact.new
      c.name  = cdata['name']
      c.sex   = cdata['sex']
      c.age   = cdata['age'].to_i
      c.phone = cdata['phone']
      c.email = cdata['email']
      c.birthday = cdata['birthday']
      if adata
        c.street = adata['street']
        c.city   = adata['city']
        c.state  = adata['state']
        c.postal_code = adata['postcode']
      end
      c.save!
      Rails.logger.warn("SeedData.load_contacts: #{c.inspect}") if verbose?
    end
  end

  private

  def verbose?
    options[:verbose]
  end

end
