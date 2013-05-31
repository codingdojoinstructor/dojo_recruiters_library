class Recruiter < ActiveRecord::Base

  has_many :recruiter_views
  has_many :candidate, :through => :recruiter_views, :source => :student

  has_many :recruiter_candidates
  has_many :candidate_list, :through => :recruiter_candidates, :source => :student

  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation, :individual_description, :company, :company_description, :title, :engineers_managed, :status, :terms_and_condition, :company_website

  email_regex = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]+)\z/i

  validates :company,	:presence 	=> true

  validates :name,	:presence 	=> true,
  					:length  	=> { :maximum => 50 }
  validates :email,	:presence	=> true,
  					:format		=> { :with => email_regex },
           	:uniqueness => { :case_sensitive => false }
            
  validates :password, :presence => true,
  	   		:confirmation 	 	=> true,
  	        :length	        	=> { :within => 6..40 },
            :if => :password_changed?
  validates :password_confirmation, :presence => true,
            :if => :password_changed?

  validates :title, :presence => true

  validates :engineers_managed, :presence => true,
            :numericality => { :only_integer => true },
            :length	      => { :minimum => 0, :maximum => 30 }

  before_save :encrypt_password

  def has_password?(submitted_password)
  	encrypted_password == encrypt(submitted_password)
  end

  # class method that checks whether the user's email and submitted_password are valid
  def self.authenticate(email, submitted_password)
  	user = find_by_email(email)

   	return nil if user.nil?
   	return user if user.has_password?(submitted_password)
  end

private

    # see if the user entered the password information or if it's a new record that needs the password 
    # this is to allow admin to update the recruiters information without having to change the password
    def password_changed?
        !password.blank? or self.encrypted_password.blank?
    end

  	def encrypt_password
  		# generate a unique salt if it's a new user
  		self.salt = Digest::SHA2.hexdigest("#{Time.now.utc}--#{password}") if self.new_record?
  	
  		# encrypt the password and store that in the encrypted_password field
  		self.encrypted_password = encrypt(password) if !password.blank?
  	end

  	# encrypt the password using both the salt and the passed password
  	def encrypt(pass)
  		Digest::SHA2.hexdigest("#{self.salt}--#{pass}")
  	end	        

end
