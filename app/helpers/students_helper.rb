module StudentsHelper

	def displayBelt(student)

		profile = student.student_profile
		puts profile

		belt_class = "white-belt-student "

		belt_class = "yellow-belt-student " unless profile.yellow_belt_score.nil?
	    belt_class = "green-belt-student " unless profile.green_belt_score.nil?
	    belt_class = "red-belt-student " unless profile.red_belt_score.nil?
	    belt_class = "black-belt-student " unless profile.black_belt_score.nil?

	    belt_class
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
