module StudentsHelper

	def displayBelt(student)

		student_belts = student.student_belts.order("belt_id ASC")
	    belts = {1=>"white-belt-student", 2=>"yellow-belt-student", 3=>"green-belt-student", 4=>"red-belt-student", 5=>"black-belt-student"}
	    belt_class = ""

	    for i in 1..5
	      student_belts.each do |belt|
	      	belt_class << belts[i] + " " if belt.belt_id == i
	      end
	    end

	    belt_class
	end
end
