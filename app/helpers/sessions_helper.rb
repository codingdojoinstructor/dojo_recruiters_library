module SessionsHelper

  def sign_in_recruiter(recruiter)
    session[:recruiter_id] = recruiter.id
    self.current_user = recruiter
  end

  def is_recruiter?
    session[:recruiter_id]
  end

  def sign_in(user)
    session[:user_id] = user.id
    self.current_user = user
  end
  
  # setter method
  def current_user=(user)
    @current_user = user
  end

  # getter method
  def current_user
    if @current_user.nil? and session[:user_id]
      @current_user = Student.find(session[:user_id])
    elsif @current_user.nil? and session[:recruiter_id]
      @current_user = Recruiter.find(session[:recruiter_id])
    end
    return @current_user
  end

  def update_student_skills(student, task)

      CODINGDOJO_BELTS[0].each_with_index do |belt, index|
      if CODINGDOJO_BELTS[0][index][:id] > 1
        skills = Skill.where(:belt_id => CODINGDOJO_BELTS[0][index][:id])

        if CODINGDOJO_BELTS[0][index][:id] == 2 and !student.student_profile.yellow_belt_score.nil? and !student.student_profile.yellow_belt_score.blank?
          skills.each do |skill|
            StudentSkill.create(student_id: student.id, skill_id: skill.id, scores: student.student_profile.yellow_belt_score, earned_at: student.student_profile.yellow_belt_date, belt_id: skill.belt_id)
            display_task(task, "Added #{student.name}'s skill: #{skill.name}: #{student.student_profile.yellow_belt_score}")
          end
        elsif CODINGDOJO_BELTS[0][index][:id] == 3 and !student.student_profile.green_belt_score.nil? and !student.student_profile.green_belt_score.blank?
          skills.each do |skill|
            StudentSkill.create(student_id: student.id, skill_id: skill.id, scores: student.student_profile.green_belt_score, earned_at: student.student_profile.green_belt_date, belt_id: skill.belt_id)
            display_task(task, "Added #{student.name}'s skill: #{skill.name}: #{student.student_profile.green_belt_score}")
          end          
        elsif CODINGDOJO_BELTS[0][index][:id] == 4 and !student.student_profile.red_belt_score.nil? and !student.student_profile.red_belt_score.blank?
          skills.each do |skill|
            StudentSkill.create(student_id: student.id, skill_id: skill.id, scores: student.student_profile.red_belt_score, earned_at: student.student_profile.red_belt_date, belt_id: skill.belt_id)
            display_task(task, "Added #{student.name}'s skill: #{skill.name}: #{student.student_profile.red_belt_score}")
          end
        elsif CODINGDOJO_BELTS[0][index][:id] == 5 and !student.student_profile.black_belt_score.nil? and !student.student_profile.black_belt_score.blank?
          skills.each do |skill|
            StudentSkill.create(student_id: student.id, skill_id: skill.id, scores: student.student_profile.black_belt_score, earned_at: student.student_profile.black_belt_date, belt_id: skill.belt_id)
            display_task(task, "Added #{student.name}'s skill: #{skill.name}: #{student.student_profile.black_belt_date}")
          end
        end
      end
    end  
  end

  def display_task(task, message)
    if task == 'rake_task'     
      puts message
    end
  end

  def is_admin?
    current_user.level == 9
  end

  def inactive_recruiter?
      current_user.status != 1
  end


  def signed_in?
    !current_user.nil?
  end

  def sign_out
    session[:user_id] = nil
    session[:recruiter_id] = nil
    self.current_user = nil
  end

  def current_user?(user)
    user == current_user 
  end

  def deny_access
    redirect_to signin_path, :notice => "Please sign in to access this page."
  end

  def student_list=(students)
    @student_list = students
  end

  def student_list
    if @student_list.nil? and (!session[:search].nil? or !session[:filter].nil?)
      
      if session[:filter].nil?
        @student_list = Student.search_by_keyword_and_filter(session[:search], nil)
      else
        @student_list = Student.search_by_keyword_and_filter(session[:search], session[:filter])
      end
    end

    return @student_list
  end
end
