class StudentSkill < ActiveRecord::Base
  belongs_to :skill
  belongs_to :student
  attr_accessible :earned_at
end
