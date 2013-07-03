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

          if !student.nil?
              Emailer.email_verification_password(student).deliver
          else
            recruiter = Recruiter.authenticate_email(params[:session][:email])

            if !recruiter.nil?
              Emailer.email_verification_password(recruiter).deliver
            end
          end

          respond_to do |format|              
              format.html { redirect_to user }
              format.js
          end
      end
  end

  def change_password
      encrypted = params[:id].gsub("@", '\/')
      new_encryption = ActiveSupport::MessageEncryptor.new(SECRET)

      student = new_encryption.decrypt(encrypted).split(/:@:/)

      student_exist = Student.user_exist(student[0].to_i, student[1].to_s)

      exist = false
      user = nil

      if student_exist
          time_elapsed = ((Date.today.to_time.to_i - DateTime.parse(student[2]).to_i)/60).to_i
          exist = true
          user = student_exist
      else
        recruiter_exist = Recruiter.user_exist(student[0].to_i, student[1].to_s)

        if recruiter_exist
          time_elapsed = ((Date.today.to_time.to_i - DateTime.parse(student[2]).to_i)/60).to_i
          exist = true
          user = recruiter_exist
        end
      end 


      if time_elapsed < (24*60) and exist == true
          @id = new_encryption.encrypt(student[0].to_s)
          @email = new_encryption.encrypt(student[1].to_s)
          @user = user
          flash[:header] = "Enter your new password " + user.name
          flash[:failed] = false
      else
          flash[:failed] = true
          flash[:message] = "Change Password is either used or expired . Try to request change password in the Login form"
      end


  end


  def update_password
      new_encryption = ActiveSupport::MessageEncryptor.new(SECRET)
      id = new_encryption.decrypt(params[:id])
      email = new_encryption.decrypt(params[:email])

      student = Student.find_by_id_and_email(id.to_i, email)

      user = (!student.nil?) ? student : Recruiter.find_by_id_and_email(id.to_i, email)

      user.password =  params[:session][:password]
      user.password_confirmation =  params[:session][:password_confirmation]
      save = user.save

      if save == false
          flash[:message] = ""
          flash[:result] = 'alert-error'
          flash[:success] = false

          user.errors.full_messages.each do |message|
              flash[:message] = flash[:message] + message
          end
      else
          flash[:result] = 'alert-success'
          flash[:success] = true
          flash[:message] = "Password updated! You may now login with your new password. "
          flash[:email]  = user.email
          Emailer.email_password_changed(user).deliver
      end

      respond_to do |format|
          format.html { redirect_to signin_path, :flash => { :message => flash[:message] , :email => flash[:email]   }}
          format.js
      end
  end

  def destroy
    sign_out
    redirect_to signin_path
  end

end
