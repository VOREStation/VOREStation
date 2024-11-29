//////////////////////////////////
//		Chief Engineer
//////////////////////////////////
/datum/job/chief_engineer
	title = JOB_CHIEF_ENGINEER
	flag = CHIEF
	departments_managed = list(DEPARTMENT_ENGINEERING)
	departments = list(DEPARTMENT_ENGINEERING, DEPARTMENT_COMMAND)
	sorting_order = 2
	department_flag = ENGSEC
	faction = FACTION_STATION
	total_positions = 1
	spawn_positions = 1
	supervisors = "the "+ JOB_SITE_MANAGER
	selection_color = "#7F6E2C"
	req_admin_notify = 1
	economic_modifier = 10

	minimum_character_age = 25
	min_age_by_species = list(SPECIES_UNATHI = 70, "mechanical" = 10, SPECIES_HUMAN_VATBORN = 14)
	ideal_character_age = 50
	ideal_age_by_species = list(SPECIES_UNATHI = 140, "mechanical" = 20, SPECIES_HUMAN_VATBORN = 20)
	banned_job_species = list(SPECIES_TESHARI, SPECIES_DIONA, SPECIES_PROMETHEAN, SPECIES_ZADDAT, "digital")

	disallow_jobhop = TRUE
	pto_type = PTO_ENGINEERING
	dept_time_required = 60

	access = list(access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels,
				            access_teleporter, access_external_airlocks, access_atmospherics, access_emergency_storage, access_eva,
				            access_heads, access_construction,
				            access_ce, access_RC_announce, access_keycard_auth, access_tcomsat, access_ai_upload, access_gateway)

	minimal_access = list(access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels,
				            access_teleporter, access_external_airlocks, access_atmospherics, access_emergency_storage, access_eva,
				            access_heads, access_construction,
				            access_ce, access_RC_announce, access_keycard_auth, access_tcomsat, access_ai_upload, access_gateway)
	alt_titles = list(JOB_ALT_HEAD_ENGINEER = /datum/alt_title/head_engineer, JOB_ALT_FOREMAN = /datum/alt_title/foreman, JOB_ALT_MAINTENANCE_MANAGER = /datum/alt_title/maintenance_manager)
	minimal_player_age = 7

	outfit_type = /decl/hierarchy/outfit/job/engineering/chief_engineer
	job_description = "The " + JOB_CHIEF_ENGINEER + " manages the Engineering Department, ensuring that the Engineers work on what needs to be done, handling distribution \
						of manpower as much as they handle hands-on operations and repairs. They are also expected to keep the rest of the station informed of \
						any structural threats to the station that may be hazardous to health or disruptive to work."

/datum/job/chief_engineer/get_request_reasons()
	return list("Engine setup", "Construction project", "Repairs necessary", "Training crew", "Assembling expedition team")

/datum/alt_title/head_engineer
	title = JOB_ALT_HEAD_ENGINEER

/datum/alt_title/foreman
	title = JOB_ALT_FOREMAN

/datum/alt_title/maintenance_manager
	title = JOB_ALT_MAINTENANCE_MANAGER

//////////////////////////////////
//			Engineer
//////////////////////////////////
/datum/job/engineer
	title = JOB_ENGINEER
	flag = ENGINEER
	departments = list(DEPARTMENT_ENGINEERING)
	department_flag = ENGSEC
	faction = FACTION_STATION
	total_positions = 5
	spawn_positions = 5
	supervisors = "the "+ JOB_CHIEF_ENGINEER
	selection_color = "#5B4D20"
	economic_modifier = 5
	pto_type = PTO_ENGINEERING

	access = list(access_eva, access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels, access_external_airlocks, access_construction, access_atmospherics)
	minimal_access = list(access_eva, access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels, access_external_airlocks, access_construction)
	alt_titles = list(JOB_ALT_MAINTENANCE_TECHNICIAN = /datum/alt_title/maint_tech, JOB_ALT_ENGINE_TECHNICIAN = /datum/alt_title/engine_tech,
						JOB_ALT_ELECTRICIAN = /datum/alt_title/electrician, JOB_ALT_CONSTRUCTION_ENGINEER = /datum/alt_title/construction_engi, JOB_ALT_ENGINEERING_CONTRACTOR = /datum/alt_title/engineering_contractor,  JOB_ALT_COMPUTER_TECHNICIAN = /datum/alt_title/computer_tech, JOB_ALT_SALVAGE_TECHNICIAN = /datum/alt_title/salvage_tech)

	minimal_player_age = 3
	min_age_by_species = list(SPECIES_PROMETHEAN = 2)

	outfit_type = /decl/hierarchy/outfit/job/engineering/engineer
	job_description = "An " + JOB_ENGINEER + " keeps the station running. They repair damages, keep the atmosphere stable, and ensure that power is being \
						generated and distributed. On quiet shifts, they may be called upon to make cosmetic alterations to the station."

/datum/job/engineer/get_request_reasons()
	return list("Engine setup", "Construction project", "Repairs necessary", "Assembling expedition team")

// Engineer Alt Titles
/datum/alt_title/maint_tech
	title = JOB_ALT_MAINTENANCE_TECHNICIAN
	title_blurb = "A " + JOB_ALT_MAINTENANCE_TECHNICIAN + " is generally a junior Engineer, and can be expected to run the mildly unpleasant or boring tasks that other \
					Engineers don't care to do."

/datum/alt_title/engine_tech
	title = JOB_ALT_ENGINE_TECHNICIAN
	title_blurb = "An " + JOB_ALT_ENGINE_TECHNICIAN + " tends to the engine, most commonly a Supermatter crystal. They are expected to be able to keep it stable, and \
					possibly even run it beyond normal tolerances."

/datum/alt_title/electrician
	title = JOB_ALT_ELECTRICIAN
	title_blurb = "An " + JOB_ALT_ELECTRICIAN + "'s primary duty is making sure power is properly distributed thoughout the station, utilizing solars, substations, and other \
					methods to ensure every department has power in an emergency."

/datum/alt_title/construction_engi
	title = JOB_ALT_CONSTRUCTION_ENGINEER
	title_blurb = "A " + JOB_ALT_CONSTRUCTION_ENGINEER + " fulfills similar duties to other engineers, but usually occupies spare time with construction of extra facilities in dedicated areas or \
					as additions to station layout."

/datum/alt_title/engineering_contractor
	title = JOB_ALT_ENGINEERING_CONTRACTOR
	title_blurb = "An " + JOB_ALT_ENGINEERING_CONTRACTOR + " fulfills similar duties to other engineers, but isn't directly employed by NT proper."

/datum/alt_title/computer_tech
	title = JOB_ALT_COMPUTER_TECHNICIAN
	title_blurb = "A " + JOB_ALT_COMPUTER_TECHNICIAN + " fulfills similar duties to other engineers, but specializes in working with software and computers. They also often deal with integrated circuits."

/datum/alt_title/salvage_tech
	title = JOB_ALT_SALVAGE_TECHNICIAN
	title_blurb = "A " + JOB_ALT_SALVAGE_TECHNICIAN + " is responsible for breaking down debris and obsolete equipment to recover useful components and materials."

//////////////////////////////////
//			Atmos Tech
//////////////////////////////////
/datum/job/atmos
	title = JOB_ATMOSPHERIC_TECHNICIAN
	flag = ATMOSTECH
	departments = list(DEPARTMENT_ENGINEERING)
	department_flag = ENGSEC
	faction = FACTION_STATION
	total_positions = 3
	spawn_positions = 3
	pto_type = PTO_ENGINEERING
	supervisors = "the " + JOB_CHIEF_ENGINEER
	selection_color = "#5B4D20"
	economic_modifier = 5
	access = list(access_eva, access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels, access_external_airlocks, access_construction, access_atmospherics, access_external_airlocks)
	minimal_access = list(access_eva, access_engine, access_atmospherics, access_maint_tunnels, access_emergency_storage, access_construction, access_external_airlocks)

	alt_titles = list(JOB_ALT_ATMOSPHERIC_ENGINEER = /datum/alt_title/atmos_engi, JOB_ALT_ATMOSPHERIC_MAINTAINER = /datum/alt_title/atmos_maint, JOB_ALT_DISPOSALS_TECHNICIAN = /datum/alt_title/disposals_tech,
						JOB_ALT_FUEL_TECHNICIAN = /datum/alt_title/refuel_tech)

	minimal_player_age = 3
	min_age_by_species = list(SPECIES_PROMETHEAN = 2)

	outfit_type = /decl/hierarchy/outfit/job/engineering/atmos
	job_description = "An " + JOB_ATMOSPHERIC_TECHNICIAN + " is primarily concerned with keeping the station's atmosphere breathable. They are expected to have a good \
						understanding of the pipes, vents, and scrubbers that move gasses around the station, and to be familiar with proper firefighting procedure."

/datum/job/atmos/get_request_reasons()
	return list("Construction project", "Repairs necessary", "Assembling expedition team")

/datum/alt_title/refuel_tech
	title = JOB_ALT_FUEL_TECHNICIAN

/datum/alt_title/atmos_maint
	title = JOB_ALT_ATMOSPHERIC_MAINTAINER

/datum/alt_title/atmos_engi
	title = JOB_ALT_ATMOSPHERIC_ENGINEER

/datum/alt_title/disposals_tech
	title = JOB_ALT_DISPOSALS_TECHNICIAN
	title_blurb = "A " + JOB_ALT_DISPOSALS_TECHNICIAN + " is an " + JOB_ATMOSPHERIC_TECHNICIAN + " still and can fulfill all the same duties, although specializes more in disposals delivery system's operations and configurations."
