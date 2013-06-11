class Student < ActiveRecord::Base
  has_one :student_profile, :dependent => :destroy

  has_many :student_skills
  has_many :skills, :through=> :student_skills

  has_many :recruiter_views
  has_many :viewers, :through => :recruiter_views, :source => :recruiter

  has_many :recruiter_candidates
  has_many :recruiter_lists, :through => :recruiter_candidates, :source => :recruiter
  
  attr_accessor :password, :title, :message

  attr_accessible :email, :password, :password_confirmation, :hired_company, :hired_date, :location, :name, :status

  email_regex = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]+)\z/i

  validates :name,	:presence 	=> true,
  					:length  	=> { :maximum => 50 }

  validates :email,	:presence	=> true,
  					:format		=> { :with => email_regex },
           	:uniqueness 	=> { :case_sensitive => false }

  validates :password, 	:presence => true,
  	   		  :confirmation 	 => true,
  	        :length	        => { :within => 6..40 },
            :if => :password_changed?

  validates :password_confirmation, :presence => true,
            :if => :password_changed?

  before_save :encrypt_password, :create_profile

  def has_password?(submitted_password)
  	encrypted_password == encrypt(submitted_password)
  end

  # class method that checks whether the user's email and submitted_password are valid
  def self.authenticate(email, submitted_password)
  	user = find_by_email(email)

   	return nil if user.nil?
   	return user if user.has_password?(submitted_password)
  end

  def self.authenticate_email(email)
      user = find_by_email(email)

      return nil if user.nil?
      return user
  end

  def self.user_exist(id, email)
      user = find_by_email(email)

      return nil if user.nil?
      return user if user.id == id and user.status != 0 #Only active recruiter can change the password
      return nil
  end

  def self.search(search, belt_filters)
    search_query = "status = 1";

    if !search.nil? 
      search_condition = "%" + search + "%"
      search_query = "#{search_query} and (name LIKE '#{search_condition}' OR email LIKE '#{search_condition}' OR location LIKE '#{search_condition}')"
    end

    if belt_filters.nil?
      self.where(search_query)
    else
      search_filter = ''

      belt_filters['filters'].each do |belts|
        belts.each do |filter|
          field = filter.downcase.gsub(/-/, "_")

          search_filter += (search_filter == '' ? '' : ' OR ' )
          if field == 'white_belt'
            search_filter += "((student_profiles.yellow_belt_score is null)";
            search_filter += "and (student_profiles.green_belt_score is null)";
            search_filter += "and (student_profiles.red_belt_score is null)";
            search_filter += "and (student_profiles.black_belt_score is null))";
          else
            search_filter += "(student_profiles.#{field}_score is not null)";
          end
        end
      end

      if search.nil?  
          search_query = "#{search_query} and (#{search_filter})" 

          self.joins(:student_profile).where(search_query)
      else
          search_query = search_query + " and (#{search_filter})"
          
          self.joins(:student_profile).where(search_query)
      end
    end
  end



  private
    def create_profile
      profile = StudentProfile.new()
      self.student_profile = profile if self.new_record?
    end

    # see if the user entered the password information or if it's a new record that needs the password 
    def password_changed?
        !self.password.blank? or self.encrypted_password.blank?
    end

  	def encrypt_password
      if self.new_record? or (!self.new_record? and (!password.nil? and password != ""))

        # generate a unique salt if it's a new user
    		self.salt = Digest::SHA2.hexdigest("#{Time.now.utc}--#{password}") if self.new_record?
    	
    		# encrypt the password and store that in the encrypted_password field
    		self.encrypted_password = encrypt(password)
      end
  	end

  	# encrypt the password using both the salt and the passed password
  	def encrypt(pass)
  		Digest::SHA2.hexdigest("#{self.salt}--#{pass}")
  	end

end