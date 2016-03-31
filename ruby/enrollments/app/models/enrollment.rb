class Enrollment < ActiveRecord::Base

  belongs_to :course
  belongs_to :student

  validates :course_id,  presence: true
  validates :student_id, presence: true
  validates :state,      presence: true

  scope :active, -> { where(state: 'active') }
  scope :inactive, -> { where.not(state: 'active') }

  def active?
    'active' == self.state 
  end
end
