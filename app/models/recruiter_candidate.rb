class RecruiterCandidate < ActiveRecord::Base
  belongs_to :recruiter
  belongs_to :student

  attr_accessible :recruiter_id, :student_id
end
