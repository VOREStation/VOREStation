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

/datum/job/pathfinder
	title = "Pathfinder"
	flag = PATHFINDER
	department = "Exploration"
	head_position = 1
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the research director"
	selection_color = "#d6d05c"
	economic_modifier = 7
	minimal_player_age = 7

	access = list(access_eva, access_maint_tunnels, access_external_airlocks, access_pilot, access_explorer, access_research, access_gateway)
	minimal_access = list(access_eva, access_maint_tunnels, access_external_airlocks, access_pilot, access_explorer, access_research, access_gateway)
	outfit_type = /decl/hierarchy/outfit/job/pathfinder

/datum/job/pilot
	title = "Pilot"
	flag = PILOT
	department = "Exploration"
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the pathfinder and the head of personnel"
	selection_color = "#999440"
	economic_modifier = 5
	minimal_player_age = 3
	access = list(access_pilot)
	minimal_access = list(access_pilot)
	outfit_type = /decl/hierarchy/outfit/job/pilot

/datum/job/explorer
	title = "Explorer"
	flag = EXPLORER
	department = "Exploration"
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the pathfinder and the research director"
	selection_color = "#999440"
	economic_modifier = 6
	access = list(access_explorer, access_research)
	minimal_access = list(access_explorer, access_research)
	outfit_type = /decl/hierarchy/outfit/job/explorer2

/datum/job/sar
	title = "Field Medic"
	flag = SAR
	department = "Exploration"
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the pathfinder and the chief medical officer"
	selection_color = "#999440"
	economic_modifier = 6
	minimal_player_age = 3
	access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_chemistry, access_eva, access_maint_tunnels, access_external_airlocks, access_pilot)
	minimal_access = list(access_medical, access_medical_equip, access_morgue, access_pilot)
	outfit_type = /decl/hierarchy/outfit/job/medical/sar

/datum/job/offduty_exploration
	title = "Off-duty Explorer"
	latejoin_only = TRUE
	timeoff_factor = -1
	total_positions = -1
	faction = "Station"
	department = "Exploration"
	supervisors = "nobody! Enjoy your time off"
	selection_color = "#999440"
	access = list(access_maint_tunnels, access_external_airlocks)
	minimal_access = list(access_maint_tunnels, access_external_airlocks)
	outfit_type = /decl/hierarchy/outfit/job/assistant/explorer
