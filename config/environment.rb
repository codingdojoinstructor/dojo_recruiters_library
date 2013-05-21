# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Codingdojo::Application.initialize!

ActionMailer::Base.smtp_settings = {
    :address              => 'smtp.gmail.com',
    :port                 => 587,
    :domain               => 'gmail.com',
    :user_name            => 'nguillen@village88.com',
    :password             => 'njguillen',
    :authentication       => 'plain',
    :enable_starttls_auto => true  }
