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

eva_roa = Student.find_by_email("evabungle@gmail.com")
eva_roa.student_profile.image_src = "/assets/profile_pictures/Eva.jpg"
eva_roa.student_profile.save!

jt_platt = Student.find_by_email("James.T.Platt@gmail.com")
jt_platt.student_profile.image_src = "/assets/profile_pictures/JT Platt3.jpg"
jt_platt.student_profile.save!

peter_whitfield = Student.find_by_email("petergwhitfield@gmail.com")
peter_whitfield.student_profile.image_src = "/assets/profile_pictures/Peter2.jpg"
peter_whitfield.student_profile.save!

# tamara_solorzano = Student.find_by_email("st.tamara@gmail.com")

cory_whiteland = Student.find_by_email("corywhiteland@gmail.com")
cory_whiteland.student_profile.image_src = "/assets/profile_pictures/Cory.jpg"
cory_whiteland.student_profile.save!

william_quan = Student.find_by_email("williamuquan@gmail.com")
william_quan.student_profile.image_src = "/assets/profile_pictures/William.jpg"
william_quan.student_profile.save!

dilys_sun = Student.find_by_email("optanovo@gmail.com")
dilys_sun.student_profile.image_src = "/assets/profile_pictures/Dilys2.jpg"
dilys_sun.student_profile.save!

ian_dahlberg = Student.find_by_email("ijdahlberg@gmail.com")
ian_dahlberg.student_profile.image_src = "/assets/profile_pictures/Ian.jpg"
ian_dahlberg.student_profile.save!

casey_mccalister = Student.find_by_email("casey.mccallister@gmail.com")
casey_mccalister.student_profile.image_src = "/assets/profile_pictures/Casey2.jpg"
casey_mccalister.student_profile.save!

bert_mcguirk = Student.find_by_email("bert.mcguirk@gmail.com")
bert_mcguirk.student_profile.image_src = "/assets/profile_pictures/Greg.jpg"
bert_mcguirk.student_profile.save!

# aarthi_rajiv = Student.find_by_email("aarthi_career@gmail.com")

rick_sanchez = Student.find_by_email("r_san56@yahoo.com")
rick_sanchez.student_profile.image_src = "/assets/profile_pictures/Rick2.jpg"
rick_sanchez.student_profile.save!

eylem_ozaslan = Student.find_by_email("eylem.ozaslan@gmail.com")
eylem_ozaslan.student_profile.image_src = "/assets/profile_pictures/Eylem.jpg"
eylem_ozaslan.student_profile.save!

angie_rangel = Student.find_by_email("heyrangel@yahoo.com")
angie_rangel.student_profile.image_src = "/assets/profile_pictures/Angie.jpg"
angie_rangel.student_profile.save!

# jeremy_shoenig = Student.find_by_email("jshoenig@hotmail.com")

victor_tran = Student.find_by_email("vicfortran@gmail.com")
victor_tran.student_profile.image_src = "/assets/profile_pictures/Victor2.jpg"
victor_tran.student_profile.save!

john_theodore = Student.find_by_email("JohnTheodore42@gmail.com")
john_theodore.student_profile.image_src = "/assets/profile_pictures/JT Theodore.jpg"
john_theodore.student_profile.save!

miles_fink = Student.find_by_email("mfinkca@gmail.com")
miles_fink.student_profile.image_src = "/assets/profile_pictures/Miles3.jpg"
miles_fink.student_profile.save!

scottie_bryant = Student.find_by_email("sbphilly@hotmail.com")
scottie_bryant.student_profile.image_src = "/assets/profile_pictures/Scott.jpg"
scottie_bryant.student_profile.save!

randall_frisk = Student.find_by_email("friskslalom6@gmail.com")
randall_frisk.student_profile.image_src = "/assets/profile_pictures/Randall.jpg"
randall_frisk.student_profile.save!

marcos_guimaraes = Student.find_by_email("markuz.br@gmail.com")
marcos_guimaraes.student_profile.image_src = "/assets/profile_pictures/Markuz.jpg"
marcos_guimaraes.student_profile.save!

ben_jones = Student.find_by_email("CompanionxCube@gmail.com")
ben_jones.student_profile.image_src = "/assets/profile_pictures/Ben2.jpg"
ben_jones.student_profile.save!

samson_gowon = Student.find_by_email("glongi@hotmail.com")
samson_gowon.student_profile.image_src = "/assets/profile_pictures/Samson.jpg"
samson_gowon.student_profile.save!


jose_luigi_flores = Student.find_by_email("Joseflores8082@gmail.com")
jose_luigi_flores.student_profile.image_src = "/assets/profile_pictures/Jose2.jpg"
jose_luigi_flores.student_profile.save!