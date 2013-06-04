require 'open-uri'
require 'net/http'

class StudentsController < ApplicationController
  include StudentsHelper

  before_filter :require_admin_access, :only => [:new, :request_renew]
  before_filter :require_user_access, :only => [:edit, :update]
  before_filter :require_login

  def index
    if defined?(params[:search]) and !params[:search].nil?

      session[:search] = params[:search]
      @students = Student.search(session[:search], nil)

      student_list = @students

    else
      session[:search] = nil

      if session[:filter].nil?
        clear_student_list
      end

      if is_admin?
        @students = Student.all if is_admin?
      else
        @students = Student.where("status > ?", 0)
      end
    end
  end

  def save_filter    
    if params[:data] == 'nil'
      session[:filter] = nil 
    else
      session[:filter] = ActiveSupport::JSON.decode( params[:data] )
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

end
