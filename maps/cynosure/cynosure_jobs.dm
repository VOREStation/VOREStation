// Pilots

var/const/EXPLORER 			=(1<<14)

var/const/access_explorer = 43

/datum/access/explorer
	id = access_explorer
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
	faction = "Station"
	total_positions = 4
	spawn_positions = 4
	supervisors = "the Research Director"
	selection_color =  "#633D63"
	economic_modifier = 4
	access = list(access_explorer, access_research)
	minimal_access = list(access_explorer, access_research)

	outfit_type = /decl/hierarchy/outfit/job/explorer2
	job_description = "An Explorer searches for interesting things on the surface of Sif, and returns them to the station."

	alt_titles = list(
		"Pilot" = /decl/hierarchy/outfit/job/pilot)

/*
	alt_titles = list(
		"Explorer Technician" = /decl/hierarchy/outfit/job/explorer2/technician,
		"Explorer Medic" = /decl/hierarchy/outfit/job/explorer2/medic)
*/
