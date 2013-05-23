class Emailer < ActionMailer::Base
    default :from => "nguillen@village88.com"

    def email_verification_password(user)
        @user = user
        @url  = "http://codingdojo.herokuapp.com"
        #@link  = "http://codingdojo.herokuapp.com/change_password/"
        @link  = "http://localhost:3000/change_password/"

        secret = Digest::SHA1.hexdigest("codingDojoLibrary")

        new_encryption = ActiveSupport::MessageEncryptor.new(secret)
        encrypted_link = new_encryption.encrypt(user.id.to_s + ":@:" + user.email + ":@:" +Date.today.to_time.to_i.to_s)


        #CGI::URI.encode(CGI::URI.decode(CGI::URI.decode(encrypted_link)))
        #encrypted_link["/"] = "@"

        @link = @link + encrypted_link.gsub("\/", '@')
        mail(:to => user.email, :subject => "Coding Dojo Recruiters Library, Please reset your password")
    end

    def email_password_changed(user)
        @user = user
        @url  = "http://codingdojo.herokuapp.com"

        mail(:to => user.email, :subject => "Coding Dojo Recruiters Library, Your password has changed")
    end
end