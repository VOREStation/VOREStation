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
	supervisors = "the Head of Personnel"
	selection_color = "#d6d05c"
	economic_modifier = 8
	minimal_player_age = 7
	pto_type = PTO_EXPLORATION
	dept_time_required = 20

	access = list(access_eva, access_maint_tunnels, access_external_airlocks, access_pilot, access_explorer, access_gateway, access_pathfinder)
	minimal_access = list(access_eva, access_maint_tunnels, access_external_airlocks, access_pilot, access_explorer, access_gateway, access_pathfinder)
	outfit_type = /decl/hierarchy/outfit/job/pathfinder
	job_description = "The Pathfinder's job is to lead and manage expeditions, and is the primary authority on all off-station expeditions."
	alt_titles = list("Expedition Lead" = /datum/alt_title/expedition_lead, "Exploration Manager" = /datum/alt_title/exploration_manager)

/datum/alt_title/expedition_lead
	title = "Expedition Lead"

/datum/alt_title/exploration_manager
	title = "Exploration Manager"


/datum/job/pilot
	title = "Pilot"
	flag = PILOT
	departments = list(DEPARTMENT_CIVILIAN)
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 5
	spawn_positions = 5
	supervisors = "the Head of Personnel"
	selection_color = "#515151"
	economic_modifier = 5
	minimal_player_age = 3
	pto_type = PTO_EXPLORATION
	access = list(access_pilot)
	minimal_access = list(access_pilot)
	outfit_type = /decl/hierarchy/outfit/job/pilot
	job_description = "A Pilot flies the various shuttles in the Virgo-Erigone System."
	alt_titles = list("Co-Pilot" = /datum/alt_title/co_pilot, "Navigator" = /datum/alt_title/navigator, "Helmsman" = /datum/alt_title/helmsman)

/datum/alt_title/co_pilot
	title = "Co-Pilot"
	title_blurb = "A Co-Pilot is there primarily to assist main pilot as well as learn from them"

/datum/alt_title/navigator
	title = "Navigator"

/datum/alt_title/helmsman
	title = "Helmsman"


/datum/job/explorer
	title = "Explorer"
	flag = EXPLORER
	departments = list(DEPARTMENT_PLANET)
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Pathfinder and the Head of Personnel"
	selection_color = "#999440"
	economic_modifier = 6
	pto_type = PTO_EXPLORATION
	access = list(access_explorer, access_external_airlocks, access_eva)
	minimal_access = list(access_explorer, access_external_airlocks, access_eva)
	outfit_type = /decl/hierarchy/outfit/job/explorer2
	job_description = "An Explorer searches for interesting things, and returns them to the station."
	alt_titles = list( "Offsite Scout" = /datum/alt_title/offsite_scout)


/datum/alt_title/offsite_scout
	title = "Offsite Scout"


/datum/job/sar
	title = "Field Medic"
	flag = SAR
	departments = list(DEPARTMENT_PLANET, DEPARTMENT_MEDICAL)
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Pathfinder and the Chief Medical Officer"
	selection_color = "#999440"
	economic_modifier = 6
	minimal_player_age = 3
	pto_type = PTO_MEDICAL
	access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_chemistry, access_eva, access_maint_tunnels, access_external_airlocks, access_pilot)
	minimal_access = list(access_medical, access_medical_equip, access_morgue, access_pilot)
	outfit_type = /decl/hierarchy/outfit/job/medical/sar
	job_description = "A Field medic works as the field doctor of expedition teams."
	alt_titles = list("Expedition Medic" = /datum/alt_title/expedition_medic, "Offsite Medic" = /datum/alt_title/offsite_medic)

/datum/alt_title/expedition_medic
	title = "Expedition Medic"

/datum/alt_title/offsite_medic
	title = "Offsite Medic"


///explo offsite rework
/datum/job/Archaeologist
	title = "Archaeologist"
	departments = list(DEPARTMENT_PLANET, DEPARTMENT_RESEARCH)
	department_flag = MEDSCI
	faction = "Station"
	supervisors = "the Pathfinder and the Research Director"
	total_positions = 2
	spawn_positions = 2
	pto_type = PTO_SCIENCE
	access = list(access_tox, access_tox_storage, access_research, access_xenobiology, access_xenoarch, access_xenobotany)
	minimal_access = list(access_tox, access_tox_storage, access_research, access_xenoarch,access_eva, access_maint_tunnels, access_external_airlocks,)
	minimal_player_age = 14

/datum/job/offsite_engineer
	title = "Offsite Engineer"
	flag = ENGINEER
	departments = list(DEPARTMENT_ENGINEERING, DEPARTMENT_PLANET)
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Chief Engineer and the Pathfinder"
	selection_color = "#5B4D20"
	economic_modifier = 5
	access = list(access_eva, access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels, access_external_airlocks, access_construction, access_atmospherics)
	minimal_access = list(access_explorer, access_external_airlocks,access_eva, access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels, access_external_airlocks, access_construction, access_explorer, access_external_airlocks, access_eva)

/datum/job/Surveyor
	title = "Surveyor"
	flag= MINER
	departments = list(DEPARTMENT_CARGO,DEPARTMENT_PLANET)
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Quartermaster, the Pathfinder, and the Head of Personnel"
	selection_color = "#7a4f33"
	economic_modifier = 5
	access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_mining, access_mining_station,access_explorer, access_external_airlocks, access_eva)
	minimal_access = list(access_mining, access_mining_station, access_mailsorting,access_explorer, access_external_airlocks, access_eva)