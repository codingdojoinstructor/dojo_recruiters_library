# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# name: string
# email: string
# password: string
# level: integer
# location: string
# hired_date: datetime
# hired_company: string

# eva_roa = Student.find_by_email("evabungle@gmail.com")

# jt_platt = Student.find_by_email("James.T.Platt@gmail.com")

# peter_whitfield = Student.find_by_email("petergwhitfield@gmail.com")

tamara_solorzano = Student.find_by_email("st.tamara@gmail.com")
red_belt = tamara_solorzano.student_belts.new
red_belt.belt_id = 4
red_belt.score = 10
red_belt.save!

# cory_whiteland = Student.find_by_email("corywhiteland@gmail.com")

# william_quan = Student.find_by_email("williamuquan@gmail.com")

dilys_sun = Student.find_by_email("optanovo@gmail.com")
red_belt, black_belt = dilys_sun.student_belts.new, dilys_sun.student_belts.new
red_belt.belt_id = 4
red_belt.score = 9.5
red_belt.save!
black_belt.belt_id = 5
black_belt.score = 8
black_belt.save!

ian_dahlberg = Student.find_by_email("ijdahlberg@gmail.com")
red_belt = ian_dahlberg.student_belts.new
red_belt.belt_id = 4
red_belt.score = 9
red_belt.save!

# casey_mccalister = Student.find_by_email("casey.mccallister@gmail.com")

# bert_mcguirk = Student.find_by_email("bert.mcguirk@gmail.com")

# aarthi_rajiv = Student.find_by_email("aarthi_career@gmail.com")

# rick_sanchez = Student.find_by_email("r_san56@yahoo.com")

eylem_ozaslan = Student.find_by_email("eylem.ozaslan@gmail.com")
green_belt = eylem_ozaslan.student_belts.new
green_belt.belt_id = 3
green_belt.score = 9.5
green_belt.save!

# angie_rangel = Student.find_by_email("heyrangel@yahoo.com")

# jeremy_shoenig = Student.find_by_email("jshoenig@hotmail.com")

# victor_tran = Student.find_by_email("vicfortran@gmail.com")

# john_theodore = Student.find_by_email("JohnTheodore42@gmail.com")

# miles_fink = Student.find_by_email("mfinkca@gmail.com")

# scottie_bryant = Student.find_by_email("sbphilly@hotmail.com")

# randall_frisk = Student.find_by_email("friskslalom6@gmail.com")

# marcos_guimaraes = Student.find_by_email("markuz.br@gmail.com")

ben_jones = Student.find_by_email("CompanionxCube@gmail.com")
red_belt = ben_jones.student_belts.new
red_belt.belt_id = 4
red_belt.score = 7.5
red_belt.save!

# samson_gowon = Student.find_by_email("glongi@hotmail.com")

# jose_luigi_flores = Student.find_by_email("Joseflores8082@gmail.com")