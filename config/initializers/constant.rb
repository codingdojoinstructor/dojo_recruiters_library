#TERMS AND CONDTION PDF FILE PATH
PLACEMENT_TERMS_PATH = 'doc/placement_terms.pdf'

#SECRET KEY FOR CHANGE PASSWORD LINK
SECRET = Digest::SHA1.hexdigest("codingDojoLibrary")

#EMAILS FOR NEW LEADS
CODINGDOJO_MASTER = 'jsupsupin@village88.com'


# ------------------------------------- IMPORT STUDENT VIA CSV ------------------------------------
#CSV Student Header Column
STUDENT_HEADER = ["name", "email", "location", "status"]

#CSV Studet Profile Header Column
STUDENT_PROFILE_HEADER = ["video_url", "project1_name", "project1_url", "project2_name", "project2_url", "project3_name" ,"project3_url", "resume_url", "image_src", "white_belt_score", "white_belt_date", "yellow_belt_score", "yellow_belt_date", "green_belt_score", "green_belt_date", "red_belt_score", "red_belt_date", "black_belt_score", "black_belt_date"]

#DATE HEADER
DATE_HEADER = ["white_belt_date", "yellow_belt_date", "green_belt_date", "red_belt_date", "black_belt_date"]

#FLOAT HEADER
FLOAT_HEADER = ["white_belt_score", "yellow_belt_score", "green_belt_score", "red_belt_score", "black_belt_score"]

#INTEGER HEADER
INTEGER_HEADER = ["status"]


# ------------------------------------- BELT TYPE --------------------------------------------------

CODINGDOJO_BELTS =  [
						0 => {:id => 1, :belt => 'white-belt', :label => 'White Belt'}, 
						1 => {:id => 2, :belt => 'yellow-belt', :label => 'Yellow Belt'},
						2 => {:id => 3, :belt => 'green-belt', :label => 'Green Belt'}, 
						3 => {:id => 4, :belt => 'red-belt', :label => 'Red Belt'}, 
						4 => {:id => 5, :belt => 'black-belt', :label => 'Black Belt'}
					]