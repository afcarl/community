class Student < ActiveRecord::Base

  self.primary_key = 'student_id'

  has_and_belongs_to_many :courses

  validates :student_id, uniqueness: true
  validates :name,       presence: true
  validates :state,      presence: true

  scope :active, -> { where(state: 'active') }
  scope :inactive, -> { where.not(state: 'active') }

  def active?
    'active' == self.state 
  end
end
