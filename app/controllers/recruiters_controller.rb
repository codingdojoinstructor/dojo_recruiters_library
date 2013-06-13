require 'open-uri'
require 'rubygems'
require 'pdf/reader'

class RecruitersController < ApplicationController
  before_filter :require_login, :require_admin_access, :only => [:index, :show, :new, :edit, :create, :update, :destroy, :display_terms, :term_approval]

  def index
    @recruiters = Recruiter.all
  end

  def show
    @recruiter = Recruiter.find(params[:id])
  end

  def new
    @recruiter = Recruiter.new
  end

  def edit
    @recruiter = Recruiter.find(params[:id])
  end

  def create
    @recruiter = Recruiter.new(params[:recruiter])
    @recruiter.status = 2  # Newly added recruiter status but not yet logged in in the Recruiter's Library Site

    if @recruiter.save
      redirect_to @recruiter, notice: 'Recruiter was successfully created.'
    else
      render action: "new"
    end
  end

  def update_view
      @view = RecruiterView.find(params[:id])
      @view.updated_at = Time.now
      @view.status = params[:status]
      @view.save
  end


  def update
    @recruiter = Recruiter.find(params[:id])

    if @recruiter.update_attributes(params[:recruiter])
        if is_recruiter?
            flash[:success] = 'Your information was successfully updated.'
        else
            flash[:success] = 'Recruiter was successfully updated.'
        end
    else
        flash[:error] = ''

        @recruiter.errors.full_messages.each do |message|
            flash[:error] = flash[:error] + message
        end
    end

    redirect_to edit_recruiter_path(@recruiter)
  end

  def destroy
    @recruiter = Recruiter.find(params[:id])
    @recruiter.destroy
    redirect_to recruiters_url
  end

  def display_terms
      file_path = PLACEMENT_TERMS_PATH
      file_name = "Placement Terms"
      data = File.open(file_path, 'rb'){|f| f.read}

      send_data data, :disposition => 'inline', :type => 'application/pdf'
  end

  def term_approval
      if defined?(params[:recruiter][:status]) && !params[:recruiter][:status].nil? && params[:recruiter][:status] != ''
          if current_user.update_attributes(:status => params[:recruiter][:status])
              message = ''
              PDF::Reader.open(PLACEMENT_TERMS_PATH) do |reader|
                  reader.pages.each do |page|
                      message = message + page.text
                  end
              end
              flash[:location] = students_path
              current_user.update_attributes(:terms_and_condition => message)
          else
              sign_out
              flash[:location] = nil
              flash[:message] = 'Internal server error occured. You have been logged out.'
          end
      else
          sign_out
          flash[:location] = nil
          flash[:message] = 'You have declined the terms and condition. You have been logged out.'
      end
  end

  def request_leads
    flash[:action] = params[:form][:action]
    flash[:result] = nil

    if flash[:action] == 'request company profile'
        @recruiter = Recruiter.new
    elsif flash[:action] == 'submit company profile'
        @recruiter = Recruiter.new(params[:recruiter])
    elsif flash[:action] == 'request leads'
        @recruiter = Recruiter.find_by_email(params[:recruiter][:email])

        if @recruiter.nil?

            @recruiter = Recruiter.new(params[:recruiter])
            @recruiter.status = 0
            @recruiter.password = 123456
            @recruiter.password_confirmation = 123456

            if @recruiter.save
                Emailer.new_leads(@recruiter).deliver
                flash[:result] = 'success'
            else
                flash[:result] = 'internal server error occurred'
            end
        else
            flash[:result] = 'recruiter exist'
        end
    end

    respond_to do |format|
        format.html
        format.js
    end
  end

  def get_introduce
      @student = Student.find(params[:id])

      if defined?(params[:form][:action]) && params[:form][:action] == 'send_email'

          @student.title         = params[:student][:title]
          @student.message       = params[:student][:message]

          Emailer.send_introduction_email(@student, current_user).deliver
          flash[:result] = 'success'
      else
          flash[:result] = nil
      end

      respond_to do |format|
          format.html
          format.js
      end
  end

  def save_to_short_list
      if(RecruiterCandidate.where(:recruiter_id => current_user.id, :student_id=> params[:id]).length == 0)
          recruiter_candidate = RecruiterCandidate.new()
          recruiter_candidate.recruiter_id = current_user.id
          recruiter_candidate.student_id = params[:id]
          recruiter_candidate.save

          @candidate = Student.find(recruiter_candidate.student_id);

          respond_to do |format|

            format.html
            format.js
          end
      end
  end

  def remove_from_short_list
      recruiter_candidate = RecruiterCandidate.find_by_recruiter_id_and_student_id(current_user.id, params[:id])

      if !recruiter_candidate.blank?
        @candidate = recruiter_candidate.student_id

        recruiter_candidate.delete

        respond_to do |format|
              format.html
              format.js
        end
      end
  end
  


  private

  def require_login
    unless signed_in?
      flash[:error] = "You must be logged in to access this section"
      redirect_to signin_path
    end
  end

  def require_admin_access

    unless is_admin? or inactive_recruiter?
        unless (is_recruiter? and (:edit || :show || :update) and  (!Recruiter.where(:id=>params[:id]).nil? and current_user?(Recruiter.find(params[:id]))))
              flash[:error] = "You don't have sufficient privilege to perform that action. You have been redirected."
              redirect_to signin_path
        end
    end
  end

end
