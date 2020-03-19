var/const/PATHFINDER 		=(1<<11)
var/const/EXPLORER 			=(1<<12)
var/const/PILOT 			=(1<<13)
var/const/SAR 				=(1<<14)

/obj/item/weapon/card/id/medical/sar
	assignment = "Field Medic"
	rank = "Field Medic"
	icon_state = "cyan"
	primary_color = rgb(47,189,189)
	secondary_color = rgb(127,223,223)

/obj/item/weapon/card/id/explorer
	name = "identification card"
	desc = "A card issued to station exploration staff."
	icon_state = "cyan"
	primary_color = rgb(47,189,189)
	secondary_color = rgb(127,223,223)

/obj/item/weapon/card/id/explorer/head
	name = "identification card"
	desc = "A card which represents discovery of the unknown."
	icon_state = "cyanGold"
	primary_color = rgb(47,189,189)
	secondary_color = rgb(127,223,223)

/datum/department/planetside
	name = DEPARTMENT_PLANET
	color = "#bab421"
	sorting_order = 2 // Same as cargo in importance.

/datum/job/pathfinder
	title = "Pathfinder"
	flag = PATHFINDER
	departments = list(DEPARTMENT_PLANET)
	departments_managed = list(DEPARTMENT_PLANET)
	sorting_order = 1 // above the other explorers
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the research director"
	selection_color = "#d6d05c"
	economic_modifier = 7
	minimal_player_age = 7
	pto_type = PTO_EXPLORATION

	access = list(access_eva, access_maint_tunnels, access_external_airlocks, access_pilot, access_explorer, access_research, access_gateway)
	minimal_access = list(access_eva, access_maint_tunnels, access_external_airlocks, access_pilot, access_explorer, access_research, access_gateway)
	outfit_type = /decl/hierarchy/outfit/job/pathfinder
	job_description = "	The Pathfinder's job is to lead and manage expeditions, and is the primary authority on all off-station expeditions."

/datum/alt_title/pathfinder
	title = "Pathfinder"

/datum/job/pilot
	title = "Pilot"
	flag = PILOT
	departments = list(DEPARTMENT_PLANET)
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the pathfinder and the head of personnel"
	selection_color = "#999440"
	economic_modifier = 5
	minimal_player_age = 3
	pto_type = PTO_EXPLORATION
	access = list(access_pilot)
	minimal_access = list(access_pilot)
	outfit_type = /decl/hierarchy/outfit/job/pilot
	job_description = "A Pilot flies the various shuttles in the Virgo-Erigone System."

/datum/alt_title/pilot
	title = "Pilot"

/datum/job/explorer
	title = "Explorer"
	flag = EXPLORER
	departments = list(DEPARTMENT_PLANET)
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the pathfinder and the research director"
	selection_color = "#999440"
	economic_modifier = 6
	pto_type = PTO_EXPLORATION
	access = list(access_explorer, access_research)
	minimal_access = list(access_explorer, access_research)
	outfit_type = /decl/hierarchy/outfit/job/explorer2
	job_description = "An Explorer searches for interesting things, and returns them to the station."

/datum/alt_title/explorer
	title = "Explorer"

/datum/job/sar
	title = "Field Medic"
	flag = SAR
	departments = list(DEPARTMENT_PLANET)
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the pathfinder and the chief medical officer"
	selection_color = "#999440"
	economic_modifier = 6
	minimal_player_age = 3
	pto_type = PTO_EXPLORATION
	access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_chemistry, access_eva, access_maint_tunnels, access_external_airlocks, access_pilot)
	minimal_access = list(access_medical, access_medical_equip, access_morgue, access_pilot)
	outfit_type = /decl/hierarchy/outfit/job/medical/sar
	job_description = "A Field medic works as the field doctor of expedition teams."

/datum/alt_title/field_medic
	title = "Field Medic"

/datum/job/offduty_exploration
	title = "Off-duty Explorer"
	latejoin_only = TRUE
	timeoff_factor = -1
	total_positions = -1
	faction = "Station"
	departments = list(DEPARTMENT_OFFDUTY)
	supervisors = "nobody! Enjoy your time off"
	selection_color = "#999440"
	access = list(access_maint_tunnels, access_external_airlocks)
	minimal_access = list(access_maint_tunnels, access_external_airlocks)
	outfit_type = /decl/hierarchy/outfit/job/assistant/explorer
	job_description = "Off-duty crew has no responsibilities or authority and is just there to spend their well-deserved time off."
	pto_type = PTO_EXPLORATION

/datum/alt_title/offduty_exp
	title = "Off-duty Explorer"