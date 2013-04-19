class SessionsController < ApplicationController
  def new
    render :layout => "login"
  end

  def create
    puts params

  	user = Student.authenticate(params[:session][:email], params[:session][:password])

  	if user.nil?
  		flash[:error] = "Invalid email/password combination."
  		redirect_to signin_path
  	else
  		sign_in user
  		redirect_to user
  	end

  end

  def destroy
  	sign_out
    redirect_to signin_path
  end

end
