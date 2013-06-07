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