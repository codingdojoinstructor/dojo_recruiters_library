module StudentsHelper

	def displayBelt(student)

		belt_class = student.student_skills.belt.length == 0 ? "white-belt-student " : CODINGDOJO_BELTS[0] [student.student_skills.belt[0].belt_id - 1][:belt] + "-student"
	    belt_class
	end

	def displaySkills(student)
		skill_sets = student.student_skills.map(&:skill_id).to_s
		skill_sets
	end

	def embed_video(video_link)
		if video_link[/youtu\.be\/([^\?]*)/]
			link = "http://www.youtube.com/embed/#{ $5 }"
		elsif video_link[/^.*((v\/)|(embed\/)|(watch\?))\??v?=?([^\&\?]*).*/]
			link = "http://www.youtube.com/embed/#{ $5 }"
		else
			link = video_link
		end

		%Q{<iframe class="profile-video" src="#{link}"  frameborder="0" webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>}

	end

	def get_resume_path(profile)
	  if !profile.resume_url.nil?
        file_path = profile.resume_url
      else
        file_name = profile[:pdf_resume_file_name]
        file_path = profile.resume.path

        if Rails.env == 'production'
        	file_path = profile.resume.url
    	end
      end

      if !file_path.nil?
	      if file_path.index("http://").nil? and file_path.index("https://").nil?
	      	  if Rails.env == 'production' or !profile.resume_url.nil?
	          	file_path = "http://#{file_path}"
	          end
	      end
	  end

      file_path
	end

	def google_doc_viewer(file_path)
		if file_path.include?('docs.google.com')
			google_link = file_path
		else
			google_link = file_path.gsub(/:/, "%3A").gsub("/", "%2F")
			google_link = "http://docs.google.com/viewer?url=#{google_link}"
		end

		%Q{<embed class="view_resume"  src="#{google_link}&embedded=true" width="600" height="780" style="border: none;"></embed>}
	end
end
