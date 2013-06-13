class StudentSkill < ActiveRecord::Base
  belongs_to :skill
  belongs_to :student
  attr_accessible :earned_at, :skill_id, :scores, :belt_id, :student_id

  scope :belt, order("belt_id DESC").limit(1)

  validates :earned_at,	:presence 	=> true

  validates :scores,	:presence 	=> true
end
