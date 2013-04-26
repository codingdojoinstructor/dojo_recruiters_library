class StudentsController < ApplicationController
  include StudentsHelper

  before_filter :require_admin_access, :only => [:new, :create]
  before_filter :require_user_access, :only => [:edit, :update]
  before_filter :require_login

  def index
    @students = Student.all
  end

  def show
    @student = Student.find(params[:id])
    @profile = @student.student_profile
    belts = @student.student_belts.order("belt_id ASC")

    @belts = {1=>"N/C", 2=>"N/C", 3=>"N/C", 4=>"N/C", 5=>"N/C"}
    for i in 1..5
      belts.each do |belt|
        @belts[i] = belt.score if belt.belt_id == i and belt.score.to_i > 7
      end
    end
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
      if(@profile.update_attributes(params[:student_profile]))
        flash.now[:notice] = 'Student profile/project information was successfully updated.'
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
    @belts = Belt.all
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
