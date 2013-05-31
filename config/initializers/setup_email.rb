ActionMailer::Base.smtp_settings = {  
  	:address              => "smtp.gmail.com",  
  	:port                 => 587,  
  	:domain               => "village88.com",  
 	:user_name => 'nguillen@village88.com',
	:password => 'njguillen'  
	:authentication => "plain",
	:enable_starttls_auto => true,
}