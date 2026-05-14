/datum/job/rd/New()
	. = ..()
	access -= list(ACCESS_ROBOTICS, ACCESS_AI_UPLOAD)
	access |= list(ACCESS_MAINT_TUNNELS, ACCESS_CHANGE_IDS)
	minimal_access -= list(ACCESS_ROBOTICS, ACCESS_AI_UPLOAD)
	minimal_access |= list(ACCESS_MAINT_TUNNELS, ACCESS_CHANGE_IDS)

/datum/job/scientist/New()
	. = ..()
	access -= list(ACCESS_ROBOTICS, ACCESS_AI_UPLOAD)
	alt_titles -= list(JOB_ALT_CIRCUIT_DESIGNER, JOB_ALT_CIRCUIT_PROGRAMMER)

/datum/job/roboticist
	departments = list(DEPARTMENT_MEDICAL)
	department_flag = ENGSEC
	supervisors = "the " + JOB_CHIEF_MEDICAL_OFFICER
	selection_color = "#013D3B"
	pto_type = PTO_MEDICAL
	// outfit_type =
	access = list(ACCESS_ROBOTICS, ACCESS_EVA, ACCESS_MEDICAL, ACCESS_MEDICAL_EQUIP, ACCESS_MAINT_TUNNELS, ACCESS_EXTERNAL_AIRLOCKS)
	minimal_access = list(ACCESS_ROBOTICS, ACCESS_EVA, ACCESS_MAINT_TUNNELS)
	alt_titles = list(
		JOB_ALT_BIOMECHANICAL_ENGINEER = /datum/alt_title/biomech
	)
	outfit_type = /datum/decl/hierarchy/outfit/job/medical/roboticist
