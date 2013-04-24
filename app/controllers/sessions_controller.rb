class SessionsController < ApplicationController
  def new
  end

  def create
    puts params

  	user = Student.authenticate(params[:session][:email], params[:session][:password])

  	if user.nil?
  		flash[:error] = "Invalid email/password combination."
  		redirect_to signin_path
  	else
  		sign_in user
  		redirect_to students_path
  	end

  end

  def destroy
  	sign_out
    redirect_to signin_path
  end

end
