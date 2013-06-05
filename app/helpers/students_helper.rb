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
end
