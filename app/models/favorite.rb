class Favorite < ActiveRecord::Base
  belongs_to :recruiter
  belongs_to :student
  # attr_accessible :title, :body
end
