# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Codingdojo::Application.initialize!


if ENV['RAILS_ENV'] == 'production'

  ActionMailer::Base.smtp_settings = {
    :address => 'ssl://smtp.googlemail.com',
    :port => 587,
    :authentication => :plain,
    :user_name => ENV['GMAIL_USERNAME'],
    :password => ENV['GMAIL_PASSWORD'],
    :domain => 'heroku.com'
   }

  ActionMailer::Base.delivery_method = :smtp

else
	ActionMailer::Base.smtp_settings = {
	:address              => 'smtp.gmail.com',
	:port                 => 587,
	:user_name            => 'nguillen@village88.com',
	:password             => 'njguillen',
	:authentication       => 'plain' 
	}
end