# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130530090103) do

  create_table "favorites", :force => true do |t|
    t.integer  "recruiter_id"
    t.integer  "student_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "favorites", ["recruiter_id"], :name => "index_favorites_on_recruiter_id"
  add_index "favorites", ["student_id"], :name => "index_favorites_on_student_id"

  create_table "recruiter_candidates", :force => true do |t|
    t.integer  "recruiter_id"
    t.integer  "student_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "recruiter_candidates", ["recruiter_id"], :name => "index_recruiter_candidates_on_recruiter_id"
  add_index "recruiter_candidates", ["student_id"], :name => "index_recruiter_candidates_on_student_id"

  create_table "recruiter_views", :force => true do |t|
    t.integer  "recruiter_id"
    t.integer  "student_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "status"
  end

  add_index "recruiter_views", ["recruiter_id"], :name => "index_recruiter_views_on_recruiter_id"
  add_index "recruiter_views", ["student_id"], :name => "index_recruiter_views_on_student_id"

  create_table "recruiters", :force => true do |t|
    t.string   "email"
    t.string   "encrypted_password"
    t.string   "name"
    t.text     "individual_description"
    t.string   "company"
    t.text     "company_description"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.string   "salt"
    t.integer  "level"
    t.string   "title"
    t.integer  "engineers_managed"
    t.text     "terms_and_condition"
    t.integer  "status"
    t.string   "company_website"
  end

  create_table "skills", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "student_profiles", :force => true do |t|
    t.string   "image_src"
    t.string   "video_url"
    t.string   "project1_name"
    t.string   "project1_url"
    t.string   "project2_name"
    t.string   "project2_url"
    t.string   "project3_name"
    t.string   "project3_url"
    t.string   "resume_url"
    t.integer  "student_id"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.float    "white_belt_score"
    t.float    "yellow_belt_score"
    t.float    "green_belt_score"
    t.float    "red_belt_score"
    t.float    "black_belt_score"
    t.date     "white_belt_date"
    t.date     "yellow_belt_date"
    t.date     "green_belt_date"
    t.date     "red_belt_date"
    t.date     "black_belt_date"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "avatar_url_file_name"
    t.string   "avatar_url_content_type"
    t.integer  "avatar_url_file_size"
    t.datetime "avatar_url_updated_at"
    t.string   "resume_file_name"
    t.string   "resume_content_type"
    t.integer  "resume_file_size"
    t.datetime "resume_updated_at"
  end

  add_index "student_profiles", ["student_id"], :name => "index_student_profiles_on_student_id"

  create_table "student_skills", :force => true do |t|
    t.datetime "earned_at"
    t.integer  "skill_id"
    t.integer  "student_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "student_skills", ["skill_id"], :name => "index_student_skills_on_skill_id"
  add_index "student_skills", ["student_id"], :name => "index_student_skills_on_student_id"

  create_table "students", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "encrypted_password"
    t.integer  "level"
    t.string   "location"
    t.string   "salt"
    t.datetime "hired_date"
    t.string   "hired_company"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.integer  "status"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

end
