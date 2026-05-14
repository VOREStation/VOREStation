/datum/job/chief_engineer/New()
	. = ..()
	access |= list(ACCESS_MECHA, ACCESS_CHANGE_IDS)
	minimal_access |= list(ACCESS_MECHA, ACCESS_CHANGE_IDS)

/datum/job/engineer/New()
	. = ..()
	access |= list(ACCESS_MECHA, ACCESS_ATMOSPHERICS)

/datum/job/atmos/New()
	. = ..()
	access |= list(ACCESS_MECHA)

/datum/job/mechatronic_engineer
	title = JOB_MECHATRONIC_ENGINEER
	flag = MECHENG
	departments = list(DEPARTMENT_ENGINEERING)
	department_flag = MEDSCI
	faction = FACTION_STATION
	total_positions = 3
	spawn_positions = 3
	pto_type = PTO_ENGINEERING
	supervisors = "the " + JOB_CHIEF_ENGINEER
	selection_color = "#5B4D20"
	economic_modifier = 5
	access = list(ACCESS_MECHA, ACCESS_EVA, ACCESS_ENGINE, ACCESS_ENGINE_EQUIP, ACCESS_TECH_STORAGE, ACCESS_MAINT_TUNNELS, ACCESS_EXTERNAL_AIRLOCKS, ACCESS_CONSTRUCTION, ACCESS_ATMOSPHERICS, ACCESS_EXTERNAL_AIRLOCKS)
	minimal_access = list(ACCESS_MECHA, ACCESS_EVA, ACCESS_ENGINE, ACCESS_ATMOSPHERICS, ACCESS_MAINT_TUNNELS, ACCESS_EMERGENCY_STORAGE, ACCESS_CONSTRUCTION, ACCESS_EXTERNAL_AIRLOCKS)

	// alt_titles

	minimal_player_age = 3
	min_age_by_species = list(SPECIES_PROMETHEAN = 2)
	outfit_type = /datum/decl/hierarchy/outfit/job/engineering/mechatronic
	job_description = "A " + JOB_MECHATRONIC_ENGINEER + " is primarly concerned about the station's large machinery, like Cyborgs, mechs, and the AI."
