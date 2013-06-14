class Student < ActiveRecord::Base


  has_one :student_profile, :dependent => :destroy

  has_many :student_skills
  accepts_nested_attributes_for :student_skills

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

  def self.search_by_keyword_and_filter(search, filters)
    if !search.nil? 
      search_condition = "%" + search + "%"
      if Rails.env == 'production'
        search_query = "(name ILIKE '#{search_condition}' OR email ILIKE '#{search_condition}' OR location ILIKE '#{search_condition}')"
      else
        search_query = "(name LIKE '#{search_condition}' OR email LIKE '#{search_condition}' OR location LIKE '#{search_condition}')"
      end

      search_query += " AND  (status = 1) " 
    else
      search_query = " status = 1 " 
    end

    if filters.nil?
      self.where(search_query)
    else
      if !filters[:belt_id].nil? 

        white_belt = false
        with_white_belt = false

        if filters[:belt_id].length == 1
            if filters[:belt_id].include?("1")
              white_belt = true
            end
        else
            if filters[:belt_id].include?("1")                
              with_white_belt = true
            else
              with_white_belt = false
            end
        end

        if white_belt == true or with_white_belt == true
            white_belt_students = []

            Student.all.each do |student|
              if student.student_skills.length == 0
                white_belt_students.push(student)
              end
            end
        end

        if !filters[:skill_id].nil? 
          search_query += "AND ((student_skills.belt_id in (#{filters[:belt_id].join(',')}))"
        else
          if white_belt == false and with_white_belt == false
            student_belts =   StudentSkill.find(:all, :select => 'student_id', :group  => "student_id HAVING MAX(belt_id) in (#{filters[:belt_id].join(",")})")
            return self.where("id in (#{student_belts.map(&:student_id).to_s.gsub(/\[/, '').gsub(/\]/, '')}) AND  (status = 1)")
          elsif with_white_belt == true
            student_belts =   StudentSkill.find(:all, :select => 'student_id', :group  => "student_id HAVING MAX(belt_id) in (#{filters[:belt_id].join(",")})")
            return self.where("(id in (#{student_belts.map(&:student_id).to_s.gsub(/\[/, '').gsub(/\]/, '')}) or id in (#{white_belt_students.map(&:id).to_s.gsub(/\[/, '').gsub(/\]/, '')})) AND  (status = 1)")
          elsif white_belt == true
            return self.where("id in (#{white_belt_students.map(&:id).to_s.gsub(/\[/, '').gsub(/\]/, '')}) AND  (status = 1)")
          end
        end

      end

      if !filters[:skill_id].nil?
        if !filters[:belt_id].nil?      
          if white_belt == false and with_white_belt == false
            search_query += " OR (student_skills.skill_id in (#{filters[:skill_id].join(',')})))"
          else
            search_query += " OR students.id in (#{white_belt_students.map(&:id).to_s.gsub(/\[/, '').gsub(/\]/, '')}) OR (student_skills.skill_id in (#{filters[:skill_id].join(',')})))"
          end     
          
        else
          search_query += " AND (student_skills.skill_id in (#{filters[:skill_id].join(',')}))"
        end


        #abort(self.includes(:student_skills).where(search_query).to_sql)

        self.includes(:student_skills).where(search_query)
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