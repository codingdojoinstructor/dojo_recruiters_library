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

        path = profile.resume_url

        if path.index("http://").nil? 
          path = "http://#{path}"
        end

        file_path = path
      else
        file_name = profile[:pdf_resume_file_name]
        path = profile.resume.path.split("?")
        file_path = path[0]
      end

      file_path
	end

	def google_doc_viewer(file_path)
		google_link = file_path.gsub(/:/, "%3F").gsub("/", "%2F")
		%Q{<embed class="view_resume"  src="http://docs.google.com/viewer?url=#{google_link}&embedded=true" width="600" height="780" style="border: none;"></embed>}
	end
end
