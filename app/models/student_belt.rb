class StudentBelt < ActiveRecord::Base
  belongs_to :belt
  belongs_to :student
  attr_accessible :earned_at, :score
end
