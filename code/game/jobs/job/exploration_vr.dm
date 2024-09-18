/obj/item/weapon/card/id/medical/sar
	assignment = JOB_FIELD_MEDIC
	rank = JOB_FIELD_MEDIC
	icon_state = "cyan"
	primary_color = rgb(47,189,189)
	secondary_color = rgb(127,223,223)

/obj/item/card/id/explorer
	name = "identification card"
	desc = "A card issued to station exploration staff."
	icon_state = "cyan"
	primary_color = rgb(47,189,189)
	secondary_color = rgb(127,223,223)
	rank = JOB_EXPLORER

/obj/item/card/id/explorer/head
	name = "identification card"
	desc = "A card which represents discovery of the unknown."
	icon_state = "cyanGold"
	primary_color = rgb(47,189,189)
	secondary_color = rgb(127,223,223)
	rank = JOB_PATHFINDER

/datum/department/planetside
	name = DEPARTMENT_PLANET
	color = "#bab421"
	sorting_order = 2 // Same as cargo in importance.



/datum/job/pathfinder
	title = JOB_PATHFINDER
	flag = PATHFINDER
	departments = list(DEPARTMENT_PLANET)
	departments_managed = list(DEPARTMENT_PLANET)
	sorting_order = 1 // above the other explorers
	department_flag = MEDSCI
	faction = FACTION_STATION
	total_positions = 1
	spawn_positions = 1
	supervisors = "the " + JOB_HEAD_OF_PERSONNEL
	selection_color = "#d6d05c"
	economic_modifier = 8
	minimal_player_age = 7
	pto_type = PTO_EXPLORATION
	dept_time_required = 20

	access = list(access_eva, access_maint_tunnels, access_external_airlocks, access_pilot, access_explorer, access_gateway, access_pathfinder, access_RC_announce)
	minimal_access = list(access_eva, access_maint_tunnels, access_external_airlocks, access_pilot, access_explorer, access_gateway, access_pathfinder, access_RC_announce)
	outfit_type = /decl/hierarchy/outfit/job/pathfinder
	job_description = "The " + JOB_PATHFINDER + "'s job is to lead and manage expeditions, and is the primary authority on all off-station expeditions."
	alt_titles = list(JOB_ALT_EXPEDITION_LEAD = /datum/alt_title/expedition_lead, JOB_ALT_EXPLORATION_MANAGER = /datum/alt_title/exploration_manager)

/datum/alt_title/expedition_lead
	title = JOB_ALT_EXPEDITION_LEAD

/datum/alt_title/exploration_manager
	title = JOB_ALT_EXPLORATION_MANAGER

/datum/job/pathfinder/get_request_reasons()
	return list("Training crew")

/datum/job/explorer
	title = JOB_EXPLORER
	flag = EXPLORER
	departments = list(DEPARTMENT_PLANET)
	department_flag = MEDSCI
	faction = FACTION_STATION
	total_positions = 3
	spawn_positions = 3
	supervisors = "the " + JOB_PATHFINDER + " and the " + JOB_HEAD_OF_PERSONNEL
	selection_color = "#999440"
	economic_modifier = 6
	pto_type = PTO_EXPLORATION
	access = list(access_explorer, access_external_airlocks, access_eva)
	minimal_access = list(access_explorer, access_external_airlocks, access_eva)
	outfit_type = /decl/hierarchy/outfit/job/explorer2
	job_description = "An " + JOB_EXPLORER + " searches for interesting things, and returns them to the station."
	alt_titles = list(JOB_ALT_SURVEYOR = /datum/alt_title/surveyor, JOB_ALT_OFFSITE_SCOUT = /datum/alt_title/offsite_scout)

/datum/alt_title/surveyor
	title = JOB_ALT_SURVEYOR

/datum/alt_title/offsite_scout
	title = JOB_ALT_OFFSITE_SCOUT


/datum/job/sar
	title = JOB_FIELD_MEDIC
	flag = SAR
	departments = list(DEPARTMENT_PLANET, DEPARTMENT_MEDICAL)
	department_flag = MEDSCI
	faction = FACTION_STATION
	total_positions = 2
	spawn_positions = 2
	supervisors = "the " + JOB_PATHFINDER + " and the " + JOB_CHIEF_MEDICAL_OFFICER
	selection_color = "#999440"
	economic_modifier = 6
	minimal_player_age = 3
	pto_type = PTO_EXPLORATION
	access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_chemistry, access_eva, access_maint_tunnels, access_external_airlocks, access_pilot)
	minimal_access = list(access_medical, access_medical_equip, access_morgue, access_pilot)
	outfit_type = /decl/hierarchy/outfit/job/medical/sar
	job_description = "A " + JOB_FIELD_MEDIC + " works as the field doctor of expedition teams."
	alt_titles = list(JOB_ALT_EXPEDITION_MEDIC = /datum/alt_title/expedition_medic, JOB_ALT_OFFSITE_MEDIC = /datum/alt_title/offsite_medic)

/datum/alt_title/expedition_medic
	title = JOB_ALT_EXPEDITION_MEDIC

/datum/alt_title/offsite_medic
	title = JOB_ALT_OFFSITE_MEDIC
