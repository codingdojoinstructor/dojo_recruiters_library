module SessionsHelper

  def sign_in_recruiter(recruiter)
    session[:recruiter_id] = recruiter.id
    self.current_user = recruiter
  end

  def is_recruiter?
    session[:recruiter_id]
  end

  def sign_in(user)
    session[:user_id] = user.id
    self.current_user = user
  end
  
  # setter method
  def current_user=(user)
    @current_user = user
  end

  # getter method
  def current_user
    if @current_user.nil? and session[:user_id]
      @current_user = Student.find(session[:user_id])
    elsif @current_user.nil? and session[:recruiter_id]
      @current_user = Recruiter.find(session[:recruiter_id])
    end
    return @current_user
  end

  def is_admin?
    current_user.level == 9
  end

  def inactive_recruiter?
      current_user.terms_status != 1
  end


  def signed_in?
    !current_user.nil?
  end

  def sign_out
    session[:user_id] = nil
    session[:recruiter_id] = nil
    self.current_user = nil
  end

  def current_user?(user)
    user == current_user 
  end

  def deny_access
    redirect_to signin_path, :notice => "Please sign in to access this page."
  end

end
