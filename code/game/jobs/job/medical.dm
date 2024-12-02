//////////////////////////////////
//		Chief Medical Officer
//////////////////////////////////
/datum/job/cmo
	title = JOB_CHIEF_MEDICAL_OFFICER
	flag = CMO
	departments_managed = list(DEPARTMENT_MEDICAL)
	departments = list(DEPARTMENT_MEDICAL, DEPARTMENT_COMMAND)
	sorting_order = 2
	department_flag = MEDSCI
	faction = FACTION_STATION
	total_positions = 1
	spawn_positions = 1
	supervisors = "the " + JOB_SITE_MANAGER
	selection_color = "#026865"
	req_admin_notify = 1
	economic_modifier = 10
	access = list(access_medical, access_medical_equip, access_morgue, access_genetics, access_heads,
				access_chemistry, access_virology, access_cmo, access_surgery, access_RC_announce,
				access_keycard_auth, access_psychiatrist, access_eva, access_external_airlocks, access_maint_tunnels, access_gateway)

	minimal_access = list(access_medical, access_medical_equip, access_morgue, access_genetics, access_heads,
				access_chemistry, access_virology, access_cmo, access_surgery, access_RC_announce,
				access_keycard_auth, access_psychiatrist, access_eva, access_external_airlocks, access_maint_tunnels, access_gateway)
	alt_titles = list(JOB_ALT_CHIEF_PHYSICIAN = /datum/alt_title/chief_physician, JOB_ALT_MEDICAL_DIRECTOR = /datum/alt_title/medical_director, JOB_ALT_HEALTHCARE_MANAGER = /datum/alt_title/healthcare_manager)

	minimum_character_age = 25
	min_age_by_species = list(SPECIES_UNATHI = 70, "mechanical" = 10, SPECIES_HUMAN_VATBORN = 14)
	minimal_player_age = 10
	ideal_character_age = 50
	ideal_age_by_species = list(SPECIES_UNATHI = 140, "mechanical" = 20, SPECIES_HUMAN_VATBORN = 20)
	banned_job_species = list(SPECIES_TESHARI, SPECIES_DIONA, SPECIES_PROMETHEAN, SPECIES_ZADDAT, "digital")

	disallow_jobhop = TRUE
	pto_type = PTO_MEDICAL
	dept_time_required = 60

	outfit_type = /decl/hierarchy/outfit/job/medical/cmo
	job_description = "The CMO manages the Medical department and is a position requiring experience and skill; their goal is to ensure that their \
						staff keep the station's crew healthy and whole. They are primarily interested in making sure that patients are safely found and \
						transported to Medical for treatment. They are expected to keep the crew informed about threats to their health and safety, and \
						about the importance of Suit Sensors."

/datum/job/cmo/get_request_reasons()
	return list("Surgery pending", "Viral outbreak", "Training crew", "Assembling expedition team")

/datum/alt_title/chief_physician
	title = JOB_ALT_CHIEF_PHYSICIAN

/datum/alt_title/medical_director
	title = JOB_ALT_MEDICAL_DIRECTOR

/datum/alt_title/healthcare_manager
	title = JOB_ALT_HEALTHCARE_MANAGER

//////////////////////////////////
//		Medical Doctor
//////////////////////////////////
/datum/job/doctor
	title = JOB_MEDICAL_DOCTOR
	flag = DOCTOR
	departments = list(DEPARTMENT_MEDICAL)
	department_flag = MEDSCI
	faction = FACTION_STATION
	total_positions = 5
	spawn_positions = 5
	pto_type = PTO_MEDICAL
	supervisors = "the " + JOB_CHIEF_MEDICAL_OFFICER
	selection_color = "#013D3B"
	economic_modifier = 7
	access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_chemistry, access_virology, access_genetics, access_eva)
	minimal_access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_virology, access_eva)
	outfit_type = /decl/hierarchy/outfit/job/medical/doctor
	job_description = "A " + JOB_MEDICAL_DOCTOR + " is a Jack-of-All-Trades Medical title, covering a variety of skill levels and minor specializations. They are likely \
						familiar with basic first aid, and a number of accompanying medications, and can generally save, if not cure, a majority of the \
						patients they encounter."
	alt_titles = list(JOB_ALT_PHYSICIAN = /datum/alt_title/physician, JOB_ALT_MEDICAL_PRACTITIONER = /datum/alt_title/medical_practitioner, JOB_ALT_SURGEON = /datum/alt_title/surgeon,
							JOB_ALT_EMERGENCY_PHYSICIAN = /datum/alt_title/emergency_physician, JOB_ALT_NURSE = /datum/alt_title/nurse, JOB_ALT_ORDERLY = /datum/alt_title/orderly,
						JOB_ALT_VIROLOGIST = /datum/alt_title/virologist, JOB_ALT_MEDICAL_CONTRACTOR = /datum/alt_title/medical_contractor)

	min_age_by_species = list(SPECIES_PROMETHEAN = 3)

/datum/job/doctor/get_request_reasons()
	return list("Surgery pending", "Viral outbreak", "Assembling expedition team")

//Medical Doctor Alt Titles
/datum/alt_title/surgeon
	title = JOB_ALT_SURGEON
	title_blurb = "A " + JOB_ALT_SURGEON + " specializes in providing surgical aid to injured patients, up to and including amputation and limb reattachement. They are expected \
					to know the ins and outs of anesthesia and surgery."
	title_outfit = /decl/hierarchy/outfit/job/medical/doctor/surgeon

/datum/alt_title/emergency_physician
	title = JOB_ALT_EMERGENCY_PHYSICIAN
	title_blurb = "An " + JOB_ALT_EMERGENCY_PHYSICIAN + " is a Medical professional trained for stabilizing and treating severely injured and/or dying patients. \
					They are generally the first response for any such individual brought to the Medbay, and can sometimes be expected to help their patients \
					make a full recovery."
	title_outfit = /decl/hierarchy/outfit/job/medical/doctor/emergency_physician

/datum/alt_title/nurse
	title = JOB_ALT_NURSE
	title_blurb = "A " + JOB_ALT_NURSE + " acts as a general purpose Doctor's Aide, providing basic care to non-critical patients, and stabilizing critical patients during \
					busy periods. They frequently watch the suit sensors console, to help manage the time of other Doctors. In rare occasions, a " + JOB_ALT_NURSE + " can be \
					called upon to revive deceased crew members."
	title_outfit = /decl/hierarchy/outfit/job/medical/doctor/nurse

/datum/alt_title/virologist
	title = JOB_ALT_VIROLOGIST
	title_blurb = "A " + JOB_ALT_VIROLOGIST + " cures active diseases in the crew, and prepares antibodies for possible infections. They also have the skills \
					to produce the various types of virus foods or mutagens."
	title_outfit = /decl/hierarchy/outfit/job/medical/doctor/virologist

/datum/alt_title/physician
	title = JOB_ALT_PHYSICIAN

/datum/alt_title/medical_practitioner
	title = JOB_ALT_MEDICAL_PRACTITIONER

/datum/alt_title/orderly
	title = JOB_ALT_ORDERLY
	title_blurb = "An " + JOB_ALT_ORDERLY + " acts as Medbay's general helping hand, assisting any doctor that might need some form of help, as well as handling manual \
					and dirty labor around the department."
	title_outfit = /decl/hierarchy/outfit/job/medical/doctor/nurse

/datum/alt_title/medical_contractor
	title = JOB_ALT_MEDICAL_CONTRACTOR
	title_blurb = "A " + JOB_ALT_MEDICAL_CONTRACTOR + " can be anything from a full-blown doctor to the likes of a nurse or orderly, but isn't directly employed by NT proper."

//////////////////////////////////
//			Chemist
//////////////////////////////////
/datum/job/chemist
	title = JOB_CHEMIST
	flag = CHEMIST
	departments = list(DEPARTMENT_MEDICAL)
	department_flag = MEDSCI
	faction = FACTION_STATION
	total_positions = 2
	spawn_positions = 2
	pto_type = PTO_MEDICAL
	supervisors = "the " + JOB_CHIEF_MEDICAL_OFFICER
	selection_color = "#013D3B"
	economic_modifier = 5
	access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_chemistry, access_virology, access_genetics)
	minimal_access = list(access_medical, access_medical_equip, access_chemistry)
	minimal_player_age = 3
	min_age_by_species = list(SPECIES_PROMETHEAN = 3)

	outfit_type = /decl/hierarchy/outfit/job/medical/chemist
	job_description = "A " + JOB_CHEMIST + " produces and maintains a stock of basic to advanced chemicals for medical and occasionally research use. \
						They are likely to know the use and dangers of many lab-produced chemicals."
	alt_titles = list(JOB_ALT_PHARMACIST = /datum/alt_title/pharmacist, JOB_ALT_PHARMACOLOGIST = /datum/alt_title/pharmacologist)

// Chemist Alt Titles
/datum/alt_title/pharmacist
	title = JOB_ALT_PHARMACIST
	title_blurb = "A " + JOB_ALT_PHARMACIST + " focuses on the chemical needs of the Medical Department, and often offers to fill crew prescriptions at their discretion."

/datum/alt_title/pharmacologist
	title = JOB_ALT_PHARMACOLOGIST
	title_blurb = "A " + JOB_ALT_PHARMACOLOGIST + " focuses on the chemical needs of the Medical Department, primarily specializing in producing more advanced forms of medicine."

/* I'm commenting out Geneticist so you can't actually see it in the job menu, given that you can't play as one - Jon.
//////////////////////////////////
//			Geneticist
//////////////////////////////////
/datum/job/geneticist
	title = JOB_GENETICIST
	flag = GENETICIST
	departments = list(DEPARTMENT_MEDICAL, DEPARTMENT_RESEARCH)
	department_flag = MEDSCI
	faction = FACTION_STATION
	total_positions = 0
	spawn_positions = 0
	supervisors = "the " + JOB_CHIEF_MEDICAL_OFFICER + " and " + JOB_RESEARCH_DIRECTOR
	selection_color = "#013D3B"
	economic_modifier = 7
	access = list(access_medical, access_morgue, access_surgery, access_chemistry, access_virology, access_genetics, access_research)
	minimal_access = list(access_medical, access_morgue, access_genetics, access_research)

	outfit_type = /decl/hierarchy/outfit/job/medical/geneticist
	job_description = "A " + JOB_GENETICIST + " operates genetic manipulation equipment to repair any genetic defects encountered in crew, from cloning or radiation as examples. \
						When required, geneticists have the skills to clone, and are the superior choice when available for doing so."
*/

//////////////////////////////////
//			Psychiatrist
//////////////////////////////////
/datum/job/psychiatrist
	title = JOB_PSYCHIATRIST
	flag = PSYCHIATRIST
	departments = list(DEPARTMENT_MEDICAL)
	department_flag = MEDSCI
	faction = FACTION_STATION
	total_positions = 1
	spawn_positions = 1
	pto_type = PTO_MEDICAL
	economic_modifier = 5
	supervisors = "the " + JOB_CHIEF_MEDICAL_OFFICER
	selection_color = "#013D3B"
	access = list(access_medical, access_medical_equip, access_morgue, access_psychiatrist)
	minimal_access = list(access_medical, access_medical_equip, access_psychiatrist)
	outfit_type = /decl/hierarchy/outfit/job/medical/psychiatrist
	job_description = "A " + JOB_PSYCHIATRIST + " provides mental health services to crew members in need. They may also be called upon to determine whatever \
					ails the mentally unwell, frequently under Security supervision. They understand the effects of various psychoactive drugs."
	alt_titles = list(JOB_ALT_PSYCHOLOGIST = /datum/alt_title/psychologist, JOB_ALT_PSYCHOANALYST = /datum/alt_title/psychoanalyst, JOB_ALT_PSYCHOTHERAPIST = /datum/alt_title/psychotherapist)
	banned_job_species = list(SPECIES_PROMETHEAN, SPECIES_DIONA)

//Psychiatrist Alt Titles
/datum/alt_title/psychologist
	title = JOB_ALT_PSYCHOLOGIST
	title_blurb =  "A " + JOB_ALT_PSYCHOLOGIST + " provides mental health services to crew members in need, focusing more on therapy than medication. They may also be \
					called upon to determine whatever ails the mentally unwell, frequently under Security supervision."
	title_outfit = /decl/hierarchy/outfit/job/medical/psychiatrist/psychologist

/datum/alt_title/psychoanalyst
	title = JOB_ALT_PSYCHOANALYST
	title_blurb =  "A " + JOB_ALT_PSYCHOANALYST + " provides mental health services to crew members in need, focusing more on therapy than medication. They may also be \
					called upon to determine whatever ails the mentally unwell, frequently under Security supervision."
	title_outfit = /decl/hierarchy/outfit/job/medical/psychiatrist/psychologist

/datum/alt_title/psychotherapist
	title = JOB_ALT_PSYCHOTHERAPIST
	title_blurb =  "A " + JOB_ALT_PSYCHOTHERAPIST + " provides mental health services to crew members in need, focusing more on therapy than medication. They may also be \
					called upon to determine whatever ails the mentally unwell, frequently under Security supervision."
	title_outfit = /decl/hierarchy/outfit/job/medical/psychiatrist/psychologist

//////////////////////////////////
//			Paramedic
//////////////////////////////////
/datum/job/paramedic
	title = JOB_PARAMEDIC
	flag = PARAMEDIC
	departments = list(DEPARTMENT_MEDICAL)
	department_flag = MEDSCI
	faction = FACTION_STATION
	total_positions = 3
	spawn_positions = 3
	pto_type = PTO_MEDICAL
	supervisors = "the " + JOB_CHIEF_MEDICAL_OFFICER
	selection_color = "#013D3B"
	economic_modifier = 4
	access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_chemistry, access_virology, access_eva, access_maint_tunnels, access_external_airlocks, access_psychiatrist)
	minimal_access = list(access_medical, access_medical_equip, access_morgue, access_eva, access_maint_tunnels, access_external_airlocks)
	outfit_type = /decl/hierarchy/outfit/job/medical/paramedic
	job_description = "A " + JOB_PARAMEDIC + " is primarily concerned with the recovery of patients who are unable to make it to the Medical Department on their own. \
						They may also be called upon to keep patients stable when Medical is busy or understaffed."
	alt_titles = list(JOB_ALT_EMERGENCY_MEDICAL_TECHNICIAN = /datum/alt_title/emt, JOB_ALT_MEDICAL_RESPONDER = /datum/alt_title/medical_responder, JOB_ALT_SEARCH_AND_RESCUE = /datum/alt_title/sar)
	banned_job_species = list(SPECIES_DIONA)

	min_age_by_species = list(SPECIES_PROMETHEAN = 2)

/datum/job/paramedic/get_request_reasons()
	return list("Assembling expedition team")

// Paramedic Alt Titles
/datum/alt_title/emt
	title = JOB_ALT_EMERGENCY_MEDICAL_TECHNICIAN
	title_blurb = "An " + JOB_ALT_EMERGENCY_MEDICAL_TECHNICIAN + " is primarily concerned with the recovery of patients who are unable to make it to the Medical Department on their \
					own. They are capable of keeping a patient stabilized until they reach the hands of someone with more training."
	title_outfit = /decl/hierarchy/outfit/job/medical/paramedic/emt

/datum/alt_title/medical_responder
	title = JOB_ALT_MEDICAL_RESPONDER
	title_blurb = "A " + JOB_ALT_MEDICAL_RESPONDER + " is primarily concerned with the recovery of patients who are unable to make it to the Medical Department on their \
					own. They are capable of keeping a patient stabilized until they reach the hands of someone with more training."
	title_outfit = /decl/hierarchy/outfit/job/medical/paramedic/emt

/datum/alt_title/sar
	title = JOB_ALT_SEARCH_AND_RESCUE
