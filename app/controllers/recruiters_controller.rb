class RecruitersController < ApplicationController
  before_filter :require_login, :require_admin_access

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
    if @recruiter.save
      redirect_to @recruiter, notice: 'Recruiter was successfully created.'
    else
      render action: "new"
    end
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


  private
  def require_login
    unless signed_in?
      flash[:error] = "You must be logged in to access this section"
      redirect_to signin_path
    end
  end

  def require_admin_access
    unless is_admin?
      flash[:error] = "You don't have sufficient privilege to perform that action. You have been redirected."
      redirect_to signin_path 
    end
  end

end
