// Pilots

var/const/SAR 				=(1<<11)
var/const/PILOT 			=(1<<13)
var/const/EXPLORER 			=(1<<14)

var/const/ACCESS_PILOT = 67
var/const/ACCESS_EXPLORER = 43

/datum/access/pilot
	id = ACCESS_PILOT
	desc = "Pilot"
	region = ACCESS_REGION_SUPPLY

/datum/access/explorer
	id = ACCESS_EXPLORER
	desc = "Explorer"
	region = ACCESS_REGION_GENERAL

//SC Jobs

/*

//Will see about getting working later.

/datum/job/captain
	title = "Station Director"
	flag = CAPTAIN
	department = "Command"
	head_position = 1
	department_flag = ENGSEC
	faction = FACTION_STATION
	total_positions = 1
	spawn_positions = 1
	supervisors = "company officials and Corporate Regulations"
	selection_color = "#1D1D4F"
	req_admin_notify = 1
	access = list() 			//See get_access()
	minimal_access = list() 	//See get_access()
	minimal_player_age = 14
	economic_modifier = 20

	minimum_character_age = 25
	ideal_character_age = 50 // Because 70 is a tad on the old side

	outfit_type = /decl/hierarchy/outfit/job/captain
	alt_titles = list("Site Manager", "Overseer")

/datum/job/captain/get_access()
	return get_all_station_access()
*/

/datum/department/planetside
	name = DEPARTMENT_PLANET
	color = "#555555"
	sorting_order = 2 // Same as cargo in importance.

/datum/job/pilot
	title = "Pilot"
	flag = PILOT
	departments = list(DEPARTMENT_PLANET)
	department_flag = CIVILIAN
	faction = FACTION_STATION
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Head of Personnel"
	selection_color = "#515151"
	economic_modifier = 4
	access = list(ACCESS_PILOT, ACCESS_CARGO, ACCESS_MINING, ACCESS_MINING_STATION)
	minimal_access = list(ACCESS_PILOT, ACCESS_CARGO, ACCESS_MINING, ACCESS_MINING_STATION)

	outfit_type = /decl/hierarchy/outfit/job/pilot
	job_description = "A Pilot flies one of the shuttles between the Southern Cross and the outpost on Sif."

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
	banned_job_species = list(SPECIES_ZADDAT)

	outfit_type = /decl/hierarchy/outfit/job/explorer2
	job_description = "An Explorer searches for interesting things on the surface of Sif, and returns them to the station."

/*
	alt_titles = list(
		JOB_ALT_EXPLORERE_TECHNICIAN = /decl/hierarchy/outfit/job/explorer2/technician,
		JOB_ALT_EXPLORER_MEDIC = /decl/hierarchy/outfit/job/explorer2/medic)
*/

/datum/job/sar
	title = "Search and Rescue"
	flag = SAR
	departments = list(DEPARTMENT_PLANET, DEPARTMENT_MEDICAL)
	department_flag = MEDSCI
	faction = FACTION_STATION
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Chief Medical Officer"
	selection_color = "#515151"
	economic_modifier = 4
	access = list(ACCESS_MEDICAL, ACCESS_MEDICAL_EQUIP, ACCESS_MORGUE, ACCESS_SURGERY, ACCESS_CHEMISTRY, ACCESS_VIROLOGY, ACCESS_EVA, ACCESS_MAINT_TUNNELS, ACCESS_EXTERNAL_AIRLOCKS, ACCESS_PSYCHIATRIST, ACCESS_EXPLORER)
	minimal_access = list(ACCESS_MEDICAL, ACCESS_MEDICAL_EQUIP, ACCESS_MORGUE, ACCESS_EXPLORER)
	min_age_by_species = list(SPECIES_PROMETHEAN = 2)

	outfit_type = /decl/hierarchy/outfit/job/medical/sar
	job_description = "A Search and Rescue operative recovers individuals who are injured or dead on the surface of Sif."
