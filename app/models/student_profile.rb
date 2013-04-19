class StudentProfile < ActiveRecord::Base
  belongs_to :student
  attr_accessible :project1_name, :project1_url, :project2_name, :project2_url, :project3_name, :project3_url, :resume_url, :video_url
end
