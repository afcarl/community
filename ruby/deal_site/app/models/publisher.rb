class Publisher < ActiveRecord::Base
  has_many   :advertisers
  belongs_to :parent, class_name: "Publisher"
  has_many   :publishers, foreign_key: :parent_id
  validates  :name, :uniqueness => true

  validate :parent_is_another_publisher

  @@root_entertainment_publisher = nil

  def self.root_entertainment_publisher_id
    unless @@root_entertainment_publisher
      @@root_entertainment_publisher = Publisher.find_by_name('Entertainment')
    end
    (@@root_entertainment_publisher.nil?) ? nil : @@root_entertainment_publisher.id
  end

  def parent_is_another_publisher
    if parent && parent == self
      errors.add :parent, " cannot be self"
    end
    true
  end

end
