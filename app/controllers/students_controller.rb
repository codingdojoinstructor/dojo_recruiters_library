require 'open-uri'

class StudentsController < ApplicationController
  include StudentsHelper

  before_filter :require_admin_access, :only => [:new, :request_renew]
  before_filter :require_user_access, :only => [:edit, :update]
  before_filter :require_login

  def index
    if is_admin?
      @students = Student.all if is_admin?
    else
      @students = Student.where("status > ?", 0)
    end
  end

  def show
    @student = Student.find(params[:id])
    @profile = @student.student_profile
  end

  def display_resume
      @student = Student.find(params[:id])
      @profile = @student.student_profile

      file_name = @profile[:pdf_resume_file_name]
      file_path = @profile.resume.path
      data = File.open(file_path, 'rb'){|f| f.read}

      send_data data, :disposition => 'inline', :type => 'application/pdf'
  end

  def new
    @student = Student.new()
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
      else
            flash.now[:error] = "Something went wrong"
      end
    elsif(params[:student]) 
      # prevent normal user from updating the status
      params[:student].delete("status") unless is_admin?
      params[:student].delete("password") if params[:student][:password] == ""

      if @student.update_attributes.(params[:student])
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

  private
  def require_login
    unless signed_in?
      flash[:error] = "You must be logged in to access this section"
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

end
