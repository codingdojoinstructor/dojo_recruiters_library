require 'open-uri'
require 'net/http'
require 'csv'
require 'roo'

class StudentsController < ApplicationController
  include StudentsHelper

  before_filter :require_admin_access, :only => [:new, :request_renew, :new_batch]
  before_filter :require_user_access, :only => [:edit, :update]
  before_filter :require_login


  def index
    @search_keyword = nil

    if (defined?(session[:search]) and !session[:search].nil?) or (defined?(session[:filter]) and !session[:filter].nil?)

      @students = Student.search_by_keyword_and_filter(session[:search], session[:filter])

      student_list = @students
    else

      if is_admin?
        @students = Student.all.shuffle if is_admin?
      else
        @students = Student.where("status > ?", 0).shuffle
      end
    end

    @skills = Skill.order(:id).all
  end


  def search
    session[:search] = params[:search]
    session[:filter] = params[:student_skills]

    if params[:student_skills].nil?
      @students = Student.search_by_keyword_and_filter(params[:search], nil)
    else
      @students = Student.search_by_keyword_and_filter(params[:search], params[:student_skills])
    end

    respond_to do |format|              
        format.html 
        format.js
    end
  end

  def show
    @student = Student.find(params[:id])
    @profile = @student.student_profile
    
    if is_recruiter?
        if !Net::HTTPNotModified
            @recruiter_views = RecruiterView.where(:recruiter_id => current_user.id, :student_id => @student.id, :status => 0)
            @recruiter_views.status = 1
            @recruiter_views.updated_at = Time.now
            @recruiter_views.save
        end

        @recruiter_views = RecruiterView.where(:recruiter_id => current_user.id, :student_id => @student.id, :status => 0).last

        if @recruiter_views.nil?
            @recruiter_view = RecruiterView.new(:student_id => @student.id, :recruiter_id => current_user.id, :status => 0)
            @recruiter_view.save
        else
            @recruiter_view = @recruiter_views
        end
    end
  end

  def show_user
    @student = Student.find(params[:id])
    @profile = @student.student_profile   

    respond_to do |format|
        format.js
    end
  end
  
  def new
    @student = Student.new()
  end

  def new_students
    @student_lists = nil
  end
  
    def open_spreadsheet(file)
	  case File.extname(file.original_filename)
		  when ".csv" then  Roo::Csv.new(file.path, nil, :ignore)
		  when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
		  when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
		  else false
	  end
	end

  def process_batch
    new_encryption = ActiveSupport::MessageEncryptor.new(SECRET)
	
    if defined?(params[:student][:user])
	
    
		csv = open_spreadsheet(params[:student][:user])
		if csv != false

			headers = Hash.new 
			missing_headers = []
			index = 0
			  
			row_header = csv.row(1)
			
			student_headers = row_header.take(4)
			profile_headers = row_header.slice(4, row_header.length)
			#Check Student header in the CSV file. 
			STUDENT_HEADER.each do |student_header|
				header_found = false

				student_headers.each do |header|
				  if header == student_header
					#GET THE POSITION OF THE HEADER IN THE CSV FILE
					headers[header.to_sym] = index.to_i
					header_found = true
				  end 
				end

				if header_found == false
				  missing_headers.push(student_header)
				end


				index = index.to_i + 1
			end
			
			
			STUDENT_PROFILE_HEADER.each do |profile_header|
				header_found = false

				#Check Profile header in the CSV file. 
				profile_headers.each do |header|
				  if header == profile_header          
					#GET THE POSITION OF THE HEADER IN THE CSV FILE
					headers[header.to_sym] = index
					header_found = true
				  end 
				end

				if header_found == false
				  missing_headers.push(profile_header)
				end

				index = index + 1
			end


			if missing_headers.length == 0
				students = []
				index = 0
				inserted = 0
				updated = 0
				error = 0
				

				(2..csv.last_row).each do |row|
					#skip header
					student_information = Hash.new
					student_valid = false

					# GET STUDENT INFORMATION
					student_information[:student] = Hash.new
					
					STUDENT_HEADER.each do |student_header|
					  value = csv.row(row)[headers[student_header.to_sym]]
					  
					  if !value.nil?

						INTEGER_HEADER.each do |header|
						  if header == student_header
							value = value.to_i
						  end
						end 

						student_information[:student][student_header.to_sym] = value
					  else									
						if student_header == "status"
							student_information[:student][student_header.to_sym] = 1
						end
					  end
					end 
					

					# CHECK IF STUDENT EMAIL EXIST
					ninja = Student.authenticate_email(student_information[:student][:email])

					if ninja.nil?
					  # CREATE PASSWORD FOR NEW STUDENT
					  student_information[:student][:password] = new_encryption.encrypt(student_information[:student][:name] + student_information[:student][:email])[0..10]
					  student_information[:student][:password_confirmation] = student_information[:student][:password]
					  ninja = Student.new(student_information[:student])
					  if ninja.save
						student_information[:student][:error] = nil
						inserted += 1
						student_valid = true                
					  else
						student_information[:student][:error] = ninja.errors.full_messages
						error += 1
					  end
					else
					  # UPDATE WHEN STUDENT ALREADY EXIST
					  if ninja.update_attributes(student_information[:student])
						student_valid = true
						student_information[:student][:error] = nil
						updated += 1
					  else
						student_information[:student][:error] = ninja.errors.full_messages
						error += 1
					  end
					end

					#CREATE / UPDATE PROFILE WHEN STUDENT WAS CREATED / UPDATED
					student_information[:profile] = Hash.new

					if student_valid
					  STUDENT_PROFILE_HEADER.each do |profile_header|
						value = csv.row(row)[headers[profile_header.to_sym]]

						if !value.nil?
						  FLOAT_HEADER.each do |header|
							if header == profile_header
							  value = value.to_f
							end
						  end 

						  DATE_HEADER.each do |header|
							if header == profile_header
							  value = value.to_date
							end
						  end 
						  
						  student_information[:profile][profile_header.to_sym] = value
						end
					  end 

					  if ninja.student_profile.nil?
						if !ninja.student_profile.new(student_information[:profile])
						  student_information[:profile][:error] = ninja.student_profile.errors.full_messages
						else
						  student_information[:profile][:error] = nil
						  update_student_skills(ninja, "import_from_csv")
						end
					  else
						if !ninja.student_profile.update_attributes(student_information[:profile])
						  student_information[:profile][:error] = ninja.student_profile.errors.full_messages
						else
						  student_information[:profile][:error] = nil
						  update_student_skills(ninja, "import_from_csv")
						end
					  end
					end

					students.push(student_information)
				end

				index = index + 1
				@student_lists = students


				Emailer.import_notification(current_user, students).deliver

			else
				flash[:notice] = "Import students failed. You have missing headers: #{missing_headers.to_s}"
			end
		else
			flash[:notice] = "Unknown file type: #{params[:student][:user].original_filename}"
		end
    else
      flash[:notice] = "Import students failed. File cannot be processed."
    end

    render "new_students"
  end

  def create
    @student = Student.new(params[:student])
    
    if @student.save
      redirect_to @student, notice: 'Comment was successfully created.'
    else
      render action: "new"
    end

  end

  def update

    @student = Student.find(params[:id])
    @profile = @student.student_profile

    if(params[:student_profile])

      # Saving
      if((params[:student_profile][:action] == 'upload_picture_file' or params[:student_profile][:action] == 'add_picture_link') and is_admin?)
          if(params[:student_profile][:action] == 'upload_picture_file')
              profile =  @profile.update_attributes(:avatar=>params[:student_profile][:avatar], :image_src=>nil)
          elsif(params[:student_profile][:action] == 'add_picture_link')
              profile =  @profile.update_attributes(:image_src=>params[:student_profile][:image_src])
          end

          if(profile)
              flash.now[:notice] = 'Student profile picture was successfully updated.'
          else
              flash.now[:error] = ''

              @profile.errors.full_messages.each do |message|
                  flash[:error] = flash[:error] + message
              end
          end
      elsif((params[:student_profile][:action] == 'upload_resume_file' or params[:student_profile][:action] == 'add_resume_link') and is_admin?)
          if(params[:student_profile][:action] == 'upload_resume_file')
              profile =  @profile.update_attributes(:resume=>params[:student_profile][:resume], :resume_url=>nil)
          elsif(params[:student_profile][:action] == 'add_resume_link')
              profile =  @profile.update_attributes(:resume_url=>params[:student_profile][:resume_url])
          end

          if(profile)
              flash.now[:notice] = 'Student profile picture was successfully updated.'
          else
              flash.now[:error] = ''

              @profile.errors.full_messages.each do |message|
                  flash[:error] = flash[:error] + message
              end

          end
      elsif(@profile.update_attributes(params[:student_profile]))
            flash.now[:notice] = 'Student profile/project information was successfully updated.'
            update_student_skills(@student, "user_update")
      else
            flash.now[:error] = "Something went wrong"
      end
    elsif(params[:student]) 
      # prevent normal user from updating the status
      params[:student].delete("status") unless is_admin?

      if @student.update_attributes(params[:student])
        flash.now[:notice] = 'Student information was successfully updated.'
      else
        flash.now[:error] = "Something went wrong"
      end
    end

    render action: "edit"
  end

  def edit
    @student = Student.find(params[:id])
    @profile = @student.student_profile
  end

  def save_filter    
    if params[:data] == 'nil'
      session[:filter] = nil 
    else
      session[:filter] = ActiveSupport::JSON.decode( params[:data] )
    end
  end

  #This display_resume method is intended for development only since only resume are only stored in local storage
  def display_resume
      @student = Student.find(params[:id])
      @profile = @student.student_profile      

      data =  File.open(get_resume_path(@profile), 'rb'){|f| f.read}
      
      send_data data, :disposition => 'inline', :type => 'application/pdf'      
  end

  private
  def require_login
    unless signed_in?
      flash[:error] = "You must be logged in to access this section"
      redirect_to signin_path
    end

    if is_recruiter? && inactive_recruiter?
        if current_user.status == 0
            flash[:error] = "Your account is still inactive. We'll get back to you soon."
        else
            flash[:error] = "You must agree first in the terms and condition to perform this action. You have been logged out."
        end

        sign_out
        redirect_to signin_path
    end
  end

  def require_user_access
    unless current_user?(Student.find(params[:id])) or is_admin?
      flash[:error] = "User access required. You don't have sufficient privilege to perform that action. You have been redirected."
      redirect_to students_path
    end
  end

  def require_admin_access
    puts "is admin?", is_admin?
    unless is_admin?
      flash[:error] = "admin access required. You don't have sufficient privilege to perform that action. You have been redirected."
      redirect_to students_path 
    end
  end
  
  # This is used to read docx file and view as pdf
  #def generate_pdf_from_word_file(file_path)
  #  data = Docx::Document.open(file_path)

  #  Prawn::Document.new(:page_size => 'A4') do
  #      text data.to_s
  #  end.render
  #end
end
