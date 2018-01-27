//VORESTATION EDIT!!! This whole file is being included by hand to get these jobs rather than using the map datum itself.
// Pilots

var/const/SAR 				=(1<<11)
var/const/PILOT 			=(1<<15) //VOREStation Edit - Bumped up 2
var/const/EXPLORER 			=(1<<12) //VOREStation Edit - Moved to science

var/const/access_pilot = 67
var/const/access_explorer = 43

/datum/access/pilot
	id = access_pilot
	desc = "Pilot"
	region = ACCESS_REGION_SUPPLY

/datum/access/explorer
	id = access_explorer
	desc = "Explorer"
	region = ACCESS_REGION_GENERAL

//SC IDs

/obj/item/weapon/card/id/medical/sar
	assignment = "Search and Rescue"
	rank = "Search and Rescue"
	job_access_type = /datum/job/sar

/obj/item/weapon/card/id/civilian/pilot
	assignment = "Pilot"
	rank = "Pilot"
	job_access_type = /datum/job/pilot

/obj/item/weapon/card/id/civilian/explorer
	assignment = "Explorer"
	rank = "Explorer"
	job_access_type = /datum/job/explorer

//SC Jobs

/*

//Will see about getting working later.

/datum/job/captain
	title = "Station Director"
	flag = CAPTAIN
	department = "Command"
	head_position = 1
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "company officials and Corporate Regulations"
	selection_color = "#1D1D4F"
	idtype = /obj/item/weapon/card/id/gold
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

/datum/job/pilot
	title = "Pilot"
	flag = PILOT
	department = "Civilian"
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the head of personnel"
	selection_color = "#515151"
	idtype = /obj/item/weapon/card/id/civilian/pilot
	economic_modifier = 4
	access = list(access_pilot, access_cargo, access_mining, access_mining_station)
	minimal_access = list(access_pilot, access_cargo, access_mining, access_mining_station)
	outfit_type = /decl/hierarchy/outfit/job/pilot

/datum/job/explorer
	title = "Explorer"
	flag = EXPLORER
	department = "Science" //VOREStation Edit
	department_flag = MEDSCI //VOREStation Edit
	faction = "Station"
	total_positions = 3 //VOREStation Edit
	spawn_positions = 3 //VOREStation Edit
	supervisors = "the research director" //VOREStation Edit
	selection_color = "#633D63" //VOREStation Edit
	idtype = /obj/item/weapon/card/id/civilian/explorer
	economic_modifier = 4
	access = list(access_pilot, access_explorer, access_research) //VOREStation Edit
	minimal_access = list(access_pilot, access_explorer, access_research) //VOREStation Edit
	outfit_type = /decl/hierarchy/outfit/job/explorer2
	alt_titles = list(
		"Explorer Technician" = /decl/hierarchy/outfit/job/explorer2/technician,
		"Explorer Medic" = /decl/hierarchy/outfit/job/explorer2/medic)

/datum/job/sar
	title = "Search and Rescue"
	flag = SAR
	department = "Medical"
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 2 //VOREStation Edit
	spawn_positions = 2 //VOREStation Edit
	supervisors = "the chief medical officer"
	selection_color = "#013D3B" //VOREStation Edit
	idtype = /obj/item/weapon/card/id/medical
	economic_modifier = 4
	access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_chemistry, access_virology, access_eva, access_maint_tunnels, access_external_airlocks, access_psychiatrist, access_explorer)
	minimal_access = list(access_medical, access_medical_equip, access_morgue, access_explorer)
	outfit_type = /decl/hierarchy/outfit/job/medical/sar