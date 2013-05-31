# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Codingdojo::Application.initialize!


if ENV['RAILS_ENV'] == 'development'
	ActionMailer::Base.smtp_settings = {
	:address              => 'smtp.gmail.com',
	:port                 => 587,
	:user_name            => 'nguillen@village88.com',
	:password             => 'njguillen',
	:authentication       => 'plain' 
	}
end