class Course < ActiveRecord::Base

  self.primary_key = 'course_id'

  has_many :students
  has_many :enrollments

  validates :course_id, uniqueness: true
  validates :name,      presence: true
  validates :state,     presence: true

  scope :active, -> { where(state: 'active') }
  scope :inactive, -> { where.not(state: 'active') }

  def active?
    'active' == self.state 
  end
end
