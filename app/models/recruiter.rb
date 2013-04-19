class Recruiter < ActiveRecord::Base
  attr_accessible :company, :company_description, :email, :encrypted_password, :individual_description, :name
end
