class Contact < ActiveRecord::Base

  validates :name,  length: { minimum: 4 }
  validates :sex,   inclusion: { in: %w(male female), message: "%{value} is not a valid sex" }
  validates :age,   numericality: { only_integer: true, greater_than_or_equal_to: 0 }, :allow_nil => true
  validates :email, uniqueness: true   #presence: true,
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i , :allow_nil => true

  # These attrubutes may be moved to a separate Address model in a future sprint.
  validates :street, length: { minimum: 4 }
  validates :city  , length: { minimum: 2 }
  validates :state,  length: { minimum: 2 }
  validates :postal_code, length: { minimum: 5 }

  # TODO - add image upload functionality, and generate a small version of it for the
  # contacts list in the left-nav, in a future sprint.

  # AR callbacks
  before_validation :before_hook
  before_create     :before_hook
  before_save       :before_hook

  private

  def before_hook
    if self.birthday  # calculate the age if the birthday is present
      now = Time.now.utc.to_date
      self.age = now.year - birthday.year - (birthday.to_date.change(:year => now.year) > now ? 1 : 0)
    end
    if self.email.to_s.strip == ''
      self.email = nil
    end
  end

end
