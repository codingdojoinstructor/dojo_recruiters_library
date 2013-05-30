class SessionsController < ApplicationController
  def new
      if signed_in?
          if (!is_recruiter?) or (is_recruiter? and !inactive_recruiter?)
              redirect_to students_path
          end
      end
  end

  def create
    user = Student.authenticate(params[:session][:email], params[:session][:password])

  	if user.nil?
      recruiter = Recruiter.authenticate(params[:session][:email], params[:session][:password])
      if recruiter.nil?
        flash[:error] = "Invalid email/password combination."
        flash[:location] = nil
      else
        sign_in_recruiter recruiter

        if recruiter.status == 2
            flash[:location] = 'terms'
        else
            flash[:location] = students_path
        end
      end

  	else
  		sign_in user
        flash[:location] = students_path
    end
  end

  def request_password

      if(params[:session][:action] == 'get_form')
          flash[:result] = nil
      elsif(params[:session][:action] == 'send_form')

          flash[:result] = 'alert-success'
          student = Student.authenticate_email(params[:session][:email])

          flash[:notice] = "Password Reset email was sent to " + params[:session][:email]

          respond_to do |format|
              if student.nil?
                  format.html { redirect_to @student.new }
                  format.js
              else
                  Emailer.email_verification_password(student).deliver
                  format.html { redirect_to @student.new }
              end

              format.html { redirect_to @student.new }
              format.js
          end
      end
  end

  def change_password
      encrypted = params[:id].gsub("@", '\/')
      new_encryption = ActiveSupport::MessageEncryptor.new(SECRET)

      student = new_encryption.decrypt(encrypted).split(/:@:/)

      student_exist = Student.user_exist(student[0].to_i, student[1].to_s)

      if student_exist
          flash[:time_elapsed] = ((Date.today.to_time.to_i - DateTime.parse(student[1]).to_i)/60).to_i

          if flash[:time_elapsed] < (24*60)
              flash[:user_id] = new_encryption.encrypt(student[0].to_s)
              flash[:user] = student_exist
              flash[:header] = "Enter your new password " + flash[:user].name
              flash[:expired] = false
              flash[:failed] = false
          else
              flash[:expired] = true
              flash[:message] = "Change Password already expired. Try to request change password in the Login form"
          end

      else
          flash[:failed] = true
          flash[:message] = "Change Password already used . Try to request change password in the Login form"
      end


  end

  def update_password
      new_encryption = ActiveSupport::MessageEncryptor.new(SECRET)
      encrypt = params[:id]
      id = new_encryption.decrypt(encrypt)

      student = Student.find(id.to_i)
      student.password =  params[:session][:password]
      student.password_confirmation =  params[:session][:password_confirmation]
      save = student.save

      if save == false
          flash[:message] = ""
          flash[:result] = 'alert-error'
          flash[:success] = false
          student.errors.full_messages.each do |message|
              flash[:message] = flash[:message] + message
          end
      else
          flash[:result] = 'alert-success'
          flash[:success] = true
          flash[:message] = "Password updated! You may now login with your new password. "
          flash[:email]  = student.email
      end

      respond_to do |format|
          if flash[:success] === true
              Emailer.email_password_changed(student).deliver
          end

          format.html { redirect_to signin_path, :flash => { :message => flash[:message] , :email => flash[:email]   }}
          format.js
      end
  end

  def destroy
    sign_out
    redirect_to signin_path
  end

end
