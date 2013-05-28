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
      @view.save
  end


  def update
    @recruiter = Recruiter.find(params[:id])

    if @recruiter.update_attributes(params[:recruiter])
      redirect_to @recruiter, notice: 'Recruiter was successfully updated.'
    else
      render action: "edit"
    end
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
        @recruiter = Recruiter.where(:email=>params[:recruiter][:email])

        if @recruiter.length == 0

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

  private

  def require_login
    unless signed_in?
      flash[:error] = "You must be logged in to access this section"
      redirect_to signin_path
    end
  end

  def require_admin_access
    unless is_admin? or inactive_recruiter?
      flash[:error] = "You don't have sufficient privilege to perform that action. You have been redirected."
      redirect_to signin_path
    end
  end

end
