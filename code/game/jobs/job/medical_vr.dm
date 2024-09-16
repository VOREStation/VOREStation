/datum/job/cmo
	disallow_jobhop = TRUE
	pto_type = PTO_MEDICAL
	dept_time_required = 60

	access = list(access_medical, access_medical_equip, access_morgue, access_genetics, access_heads,
			access_chemistry, access_virology, access_cmo, access_surgery, access_RC_announce,
			access_keycard_auth, access_psychiatrist, access_eva, access_external_airlocks, access_maint_tunnels, access_gateway)

	minimal_access = list(access_medical, access_medical_equip, access_morgue, access_genetics, access_heads,
			access_chemistry, access_virology, access_cmo, access_surgery, access_RC_announce,
			access_keycard_auth, access_psychiatrist, access_eva, access_external_airlocks, access_maint_tunnels, access_gateway)
	alt_titles = list(JOB_ALT_CHIEF_PHYSICIAN = /datum/alt_title/chief_physician, JOB_ALT_MEDICAL_DIRECTOR = /datum/alt_title/medical_director, JOB_ALT_HEALTHCARE_MANAGER = /datum/alt_title/healthcare_manager)

/datum/alt_title/chief_physician
	title = JOB_ALT_CHIEF_PHYSICIAN

/datum/alt_title/medical_director
	title = JOB_ALT_MEDICAL_DIRECTOR

/datum/alt_title/healthcare_manager
	title = JOB_ALT_HEALTHCARE_MANAGER

/datum/job/cmo/get_request_reasons()
	return list("Surgery pending", "Viral outbreak", "Training crew", "Assembling expedition team")


/datum/job/doctor
	spawn_positions = 5
	pto_type = PTO_MEDICAL
	alt_titles = list(JOB_ALT_PHYSICIAN = /datum/alt_title/physician, JOB_ALT_MEDICAL_PRACTITIONER = /datum/alt_title/medical_practitioner, JOB_ALT_SURGEON = /datum/alt_title/surgeon,
						JOB_ALT_EMERGENCY_PHYSICIAN = /datum/alt_title/emergency_physician, JOB_ALT_NURSE = /datum/alt_title/nurse, JOB_ALT_ORDERLY = /datum/alt_title/orderly,
						JOB_ALT_VIROLOGIST = /datum/alt_title/virologist, JOB_ALT_MEDICAL_CONTRACTOR = /datum/alt_title/medical_contractor)

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

/datum/job/doctor/get_request_reasons()
	return list("Surgery pending", "Viral outbreak", "Assembling expedition team")


/datum/job/chemist
	pto_type = PTO_MEDICAL
	alt_titles = list(JOB_ALT_PHARMACIST = /datum/alt_title/pharmacist, JOB_ALT_PHARMACOLOGIST = /datum/alt_title/pharmacologist)

/datum/alt_title/pharmacologist
	title = JOB_ALT_PHARMACOLOGIST
	title_blurb = "A " + JOB_ALT_PHARMACOLOGIST + " focuses on the chemical needs of the Medical Department, primarily specializing in producing more advanced forms of medicine."


/datum/job/psychiatrist
	pto_type = PTO_MEDICAL
	alt_titles = list(JOB_ALT_PSYCHOLOGIST = /datum/alt_title/psychologist, JOB_ALT_PSYCHOANALYST = /datum/alt_title/psychoanalyst, JOB_ALT_PSYCHOTHERAPIST = /datum/alt_title/psychotherapist)

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


/datum/job/paramedic
	pto_type = PTO_MEDICAL
	alt_titles = list(JOB_ALT_EMERGENCY_MEDICAL_TECHNICIAN = /datum/alt_title/emt, JOB_ALT_MEDICAL_RESPONDER = /datum/alt_title/medical_responder, JOB_ALT_SEARCH_AND_RESCUE = /datum/alt_title/sar)
	total_positions = 3
	spawn_positions = 3

/datum/alt_title/medical_responder
	title = JOB_ALT_MEDICAL_RESPONDER
	title_blurb = "A " + JOB_ALT_MEDICAL_RESPONDER + " is primarily concerned with the recovery of patients who are unable to make it to the Medical Department on their \
					own. They are capable of keeping a patient stabilized until they reach the hands of someone with more training."
	title_outfit = /decl/hierarchy/outfit/job/medical/paramedic/emt

/datum/alt_title/sar
	title = JOB_ALT_SEARCH_AND_RESCUE

/datum/job/paramedic/get_request_reasons()
	return list("Assembling expedition team")
