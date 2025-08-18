// Pilots

/datum/access/explorer
	id = ACCESS_EXPLORER
	desc = "Explorer"
	region = ACCESS_REGION_GENERAL

//Cynosure Jobs

/datum/department/planetside
	name = DEPARTMENT_PLANET
	color = "#555555"
	sorting_order = 2 // Same as cargo in importance.

/datum/job/explorer
	title = "Explorer"
	flag = EXPLORER
	departments = list(DEPARTMENT_RESEARCH, DEPARTMENT_PLANET)
	department_flag = MEDSCI
	faction = FACTION_STATION
	total_positions = 4
	spawn_positions = 4
	supervisors = "the Research Director"
	selection_color =  "#633D63"
	economic_modifier = 4
	access = list(ACCESS_EXPLORER, ACCESS_RESEARCH)
	minimal_access = list(ACCESS_EXPLORER, ACCESS_RESEARCH)

	outfit_type = /decl/hierarchy/outfit/job/explorer2
	job_description = "An Explorer searches for interesting things on the surface of Sif, and returns them to the station."

	alt_titles = list(
		JOB_PILOT = /decl/hierarchy/outfit/job/pilot)

/datum/job/rd
	access = list(ACCESS_RD, ACCESS_HEADS, ACCESS_TOX, ACCESS_GENETICS, ACCESS_MORGUE,
						ACCESS_TOX_STORAGE, ACCESS_TELEPORTER, ACCESS_SEC_DOORS,
						ACCESS_RESEARCH, ACCESS_ROBOTICS, ACCESS_XENOBIOLOGY, ACCESS_AI_UPLOAD, ACCESS_TECH_STORAGE,
						ACCESS_RC_ANNOUNCE, ACCESS_KEYCARD_AUTH, ACCESS_TCOMSAT, ACCESS_GATEWAY, ACCESS_XENOARCH,
						ACCESS_NETWORK, ACCESS_MAINT_TUNNELS, ACCESS_EXPLORER, ACCESS_EVA, ACCESS_EXTERNAL_AIRLOCKS)
	minimal_access = list(ACCESS_RD, ACCESS_HEADS, ACCESS_TOX, ACCESS_GENETICS, ACCESS_MORGUE,
						ACCESS_TOX_STORAGE, ACCESS_TELEPORTER, ACCESS_SEC_DOORS,
						ACCESS_RESEARCH, ACCESS_ROBOTICS, ACCESS_XENOBIOLOGY, ACCESS_AI_UPLOAD, ACCESS_TECH_STORAGE,
						ACCESS_RC_ANNOUNCE, ACCESS_KEYCARD_AUTH, ACCESS_TCOMSAT, ACCESS_GATEWAY, ACCESS_XENOARCH,
						ACCESS_NETWORK, ACCESS_MAINT_TUNNELS, ACCESS_EXPLORER, ACCESS_EVA, ACCESS_EXTERNAL_AIRLOCKS)

/*
	alt_titles = list(
		JOB_ALT_EXPLORERE_TECHNICIAN = /decl/hierarchy/outfit/job/explorer2/technician,
		JOB_ALT_EXPLORER_MEDIC = /decl/hierarchy/outfit/job/explorer2/medic)
*/
