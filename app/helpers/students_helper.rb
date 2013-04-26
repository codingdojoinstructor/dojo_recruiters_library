module StudentsHelper

	def displayBelt(student)

		profile = student.student_profile
		puts profile

		belt_class = "white-belt-student "

		belt_class << "yellow-belt-student " unless profile.yellow_belt_score.nil?
	    belt_class << "green-belt-student " unless profile.green_belt_score.nil?
	    belt_class << "red-belt-student " unless profile.red_belt_score.nil?
	    belt_class << "black-belt-student " unless profile.black_belt_score.nil?

	    belt_class
	end
end
