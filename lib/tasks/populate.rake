require "#{Rails.root}/app/helpers/sessions_helper"
include SessionsHelper

namespace :db do
  desc "Populate Database"
  task :populate_student_skills, [:action] => :environment do |t, argument|
    argument.with_defaults(:action => "codingdojo new")

    if argument.action == "codingdojo new"

      [Skill, StudentSkill].each(&:destroy_all)

      ActiveRecord::Base.connection.execute("DELETE from sqlite_sequence where name = 'skills'")
      ActiveRecord::Base.connection.execute("DELETE from sqlite_sequence where name = 'student_skills'")
      
      Skill.create(name: "HTML", description: "HTML", belt_id: 2)
      Skill.create(name: "CSS", description: "CSS", belt_id: 2)
      Skill.create(name: "JQuery / Javascript", description: "JQuery / Javascript", belt_id: 2)

      Skill.create(name: "PHP", description: "PHP", belt_id: 3)
      Skill.create(name: "Ajax", description: "Ajax", belt_id: 3)
      Skill.create(name: "MySQL / Database Design", description: "MySQL / Database Design", belt_id: 3)
      Skill.create(name: "Agile", description: "Agile", belt_id: 3)

      Skill.create(name: "OOP", description: "OOP", belt_id: 4)
      Skill.create(name: "Git / SVN", description: "Git / SVN", belt_id: 4)
      Skill.create(name: "Ruby", description: "Ruby", belt_id: 4)
      Skill.create(name: "Linux and Cloud Server", description: "Linux and Cloud Server", belt_id: 4)

      Skill.create(name: "Ruby on Rails", description: "Ruby on Rails", belt_id: 5)
      Skill.create(name: "CodeIgniter", description: "CodeIgniter", belt_id: 5)
      Skill.create(name: "TDD", description: "TDD", belt_id: 5)

      Student.all.each do |student|
        update_student_skills(student, "rake_task")  
      end
    end
  end
end