ActionMailer::Base.smtp_settings = {  
  	:address              => "smtp.gmail.com",  
  	:tls 				  => true,
  	:port                 => 587,  
 	:user_name => ENV['GMAIL_USERNAME'],
	:password =>  ENV['GMAIL_PASSWORD'], 
	:authentication => "plain",
	:enable_starttls_auto => true
}