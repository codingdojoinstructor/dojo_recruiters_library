require "open-uri"

class StudentProfile < ActiveRecord::Base
    belongs_to :student

    attr_accessible :image_src, :project1_name, :project1_url, :project2_name, :project2_url, :project3_name, :project3_url, :resume_url, :video_url, :white_belt_score, :white_belt_date, :yellow_belt_score, :yellow_belt_date, :green_belt_score, :green_belt_date, :red_belt_score, :red_belt_date, :black_belt_score, :black_belt_date, :avatar, :resume


    has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/assets/default_prof_pic.jpg"

    has_attached_file :resume

    validates_attachment_content_type :avatar,
                                      :content_type => ['image/jpeg', 'image/png', 'image/jpg']

    validates_attachment_content_type :resume,
                                      :content_type => [ 'application/pdf' ],
                                      :message => "only pdf files are allowed"
end
