class StudentsController < ApplicationController
  include StudentsHelper

  def index
    @students = Student.all
  	render :layout => "students_dashboard"
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

    render :layout => "students"
  end

  def new

  end

  def update
    @student = Student.find(params[:id])
    @profile = @student.student_profile
    if @profile.update_attributes(params[:user])
      redirect_to @student, notice: 'Student was successfully updated.'
    else
      render action: "edit"
    end
  end

  def edit
    @student = Student.find(params[:id])
    @profile = @student.student_profile
   #  puts @profile, @student
   #  render :text => @profile.to_yaml
  	render :layout => "students_edit"
  end 
end
