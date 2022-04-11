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
	alt_titles = list("Chief Physician" = /datum/alt_title/chief_physician, "Medical Director" = /datum/alt_title/medical_director, "Healthcare Manager" = /datum/alt_title/healthcare_manager)

/datum/alt_title/chief_physician
	title = "Chief Physician"

/datum/alt_title/medical_director
	title = "Medical Director"

/datum/alt_title/healthcare_manager
	title = "Healthcare Manager"


/datum/job/doctor
	spawn_positions = 5
	pto_type = PTO_MEDICAL
	alt_titles = list("Physician" = /datum/alt_title/physician, "Medical Practitioner" = /datum/alt_title/medical_practitioner, "Surgeon" = /datum/alt_title/surgeon,
						"Emergency Physician" = /datum/alt_title/emergency_physician, "Nurse" = /datum/alt_title/nurse, "Orderly" = /datum/alt_title/orderly,
						"Virologist" = /datum/alt_title/virologist)


/datum/alt_title/physician
	title = "Physician"

/datum/alt_title/medical_practitioner
	title = "Medical Practitioner"

/datum/alt_title/orderly
	title = "Orderly"
	title_blurb = "An Orderly acts as Medbay's general helping hand, assisting any doctor that might need some form of help, as well as handling manual \
					and dirty labor around the department."
	title_outfit = /decl/hierarchy/outfit/job/medical/doctor/nurse


/datum/job/chemist
	pto_type = PTO_MEDICAL
	alt_titles = list("Pharmacist" = /datum/alt_title/pharmacist, "Pharmacologist" = /datum/alt_title/pharmacologist)

/datum/alt_title/pharmacologist
	title = "Pharmacologist"
	title_blurb = "A Pharmacologist focuses on the chemical needs of the Medical Department, primarily specializing in producing more advanced forms of medicine."


/datum/job/psychiatrist
	pto_type = PTO_MEDICAL
	alt_titles = list("Psychologist" = /datum/alt_title/psychologist, "Psychoanalyst" = /datum/alt_title/psychoanalyst, "Psychotherapist" = /datum/alt_title/psychotherapist)

/datum/alt_title/psychoanalyst
	title = "Psychoanalyst"
	title_blurb =  "A Psychoanalyst provides mental health services to crew members in need, focusing more on therapy than medication. They may also be \
					called upon to determine whatever ails the mentally unwell, frequently under Security supervision."
	title_outfit = /decl/hierarchy/outfit/job/medical/psychiatrist/psychologist

/datum/alt_title/psychotherapist
	title = "Psychotherapist"
	title_blurb =  "A Psychotherapist provides mental health services to crew members in need, focusing more on therapy than medication. They may also be \
					called upon to determine whatever ails the mentally unwell, frequently under Security supervision."
	title_outfit = /decl/hierarchy/outfit/job/medical/psychiatrist/psychologist


/datum/job/paramedic
	pto_type = PTO_MEDICAL
	alt_titles = list("Emergency Medical Technician" = /datum/alt_title/emt, "Medical Responder" = /datum/alt_title/medical_responder)

/datum/alt_title/medical_responder
	title = "Medical Responder"
	title_blurb = "A Medical Responder is primarily concerned with the recovery of patients who are unable to make it to the Medical Department on their \
					own. They are capable of keeping a patient stabilized until they reach the hands of someone with more training."
	title_outfit = /decl/hierarchy/outfit/job/medical/paramedic/emt