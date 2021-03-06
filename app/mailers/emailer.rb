class Emailer < ActionMailer::Base
    default :from => ENV['GMAIL_USERNAME']
    
    def email_verification_password(user)
        @user = user
        @url  = "http://codingdojo.herokuapp.com"
        @link  = "http://codingdojo.herokuapp.com/change_password/"
        #@link  = "http://localhost:3000/change_password/"

        secret = Digest::SHA1.hexdigest("codingDojoLibrary")

        new_encryption = ActiveSupport::MessageEncryptor.new(secret)
        encrypted_link = new_encryption.encrypt(user.id.to_s + ":@:" + user.email + ":@:" +Date.today.to_time.to_i.to_s)


        #CGI::URI.encode(CGI::URI.decode(CGI::URI.decode(encrypted_link)))
        #encrypted_link["/"] = "@"

        @link = @link + encrypted_link.gsub("\/", '@')
        
        mail(:to => @user.email, :subject => "CodingDojo Recruiters Library, Please reset your password")
    end

    def email_password_changed(user)
        @user = user
        @url  = "http://codingdojo.herokuapp.com"

        mail(:to => @user.email, :subject => "CodingDojo Recruiters Library, Your password has changed")
    end

    def new_leads(recruiter)
        @recruiter = recruiter
        mail(:to => CODINGDOJO_MASTER, :subject => "CodingDojo Recruiters Library, New Recruiter Request")
    end

    def send_introduction_email(student, recruiter)
        @recruiter = recruiter
        @student   = student

        mail(:to => @student.email,
             :subject => @student.title,
             :reply_to => @recruiter.email)
    end

    def import_notification(user, students)
        @students = students 
        @user = user
        @url  = "http://codingdojo.herokuapp.com"

        mail(:to => @user.email,
             :subject => "CodingDojo Recruiters Library, New Import from CSV")
    end

    def new_recruiter_access(recruiter, password)
        @recruiter = recruiter 
        @password = password 
        @url  = "http://codingdojo.herokuapp.com"

        mail(:to => @recruiter.email,
             :subject => "CodingDojo Recruiters Library, Welcome to Community")
    end
end