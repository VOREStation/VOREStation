/datum/job/chief_engineer
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

/datum/alt_title/head_engineer
	title = JOB_ALT_HEAD_ENGINEER

/datum/alt_title/foreman
	title = JOB_ALT_FOREMAN

/datum/alt_title/maintenance_manager
	title = JOB_ALT_MAINTENANCE_MANAGER

/datum/job/chief_engineer/get_request_reasons()
	return list("Engine setup", "Construction project", "Repairs necessary", "Training crew", "Assembling expedition team")


/datum/job/engineer
	pto_type = PTO_ENGINEERING
	alt_titles = list(JOB_ALT_MAINTENANCE_TECHNICIAN = /datum/alt_title/maint_tech, JOB_ALT_ENGINE_TECHNICIAN = /datum/alt_title/engine_tech,
						JOB_ALT_ELECTRICIAN = /datum/alt_title/electrician, JOB_ALT_CONSTRUCTION_ENGINEER = /datum/alt_title/construction_engi, JOB_ALT_ENGINEERING_CONTRACTOR = /datum/alt_title/engineering_contractor,  JOB_ALT_COMPUTER_TECHNICIAN = /datum/alt_title/computer_tech)

/datum/alt_title/construction_engi
	title = JOB_ALT_CONSTRUCTION_ENGINEER
	title_blurb = "A " + JOB_ALT_CONSTRUCTION_ENGINEER + " fulfills similar duties to other engineers, but usually occupies spare time with construction of extra facilities in dedicated areas or \
					as additions to station layout."

/datum/alt_title/engineering_contractor
	title = JOB_ALT_ENGINEERING_CONTRACTOR
	title_blurb = "An " + JOB_ALT_ENGINEERING_CONTRACTOR + " fulfills similar duties to other engineers, but isn't directly employed by NT proper."

/datum/job/engineer/get_request_reasons()
	return list("Engine setup", "Construction project", "Repairs necessary", "Assembling expedition team")

/datum/alt_title/computer_tech
	title = JOB_ALT_COMPUTER_TECHNICIAN
	title_blurb = "A " + JOB_ALT_COMPUTER_TECHNICIAN + " fulfills similar duties to other engineers, but specializes in working with software and computers. They also often deal with integrated circuits."

/datum/job/atmos
	spawn_positions = 3
	pto_type = PTO_ENGINEERING
	alt_titles = list(JOB_ALT_ATMOSPHERIC_ENGINEER = /datum/alt_title/atmos_engi, JOB_ALT_ATMOSPHERIC_MAINTAINER = /datum/alt_title/atmos_maint, JOB_ALT_DISPOSALS_TECHNICIAN = /datum/alt_title/disposals_tech,
						JOB_ALT_FUEL_TECHNICIAN = /datum/alt_title/refuel_tech)

/datum/alt_title/atmos_maint
	title = JOB_ALT_ATMOSPHERIC_MAINTAINER

/datum/alt_title/atmos_engi
	title = JOB_ALT_ATMOSPHERIC_ENGINEER

/datum/alt_title/disposals_tech
	title = JOB_ALT_DISPOSALS_TECHNICIAN
	title_blurb = "A " + JOB_ALT_DISPOSALS_TECHNICIAN + " is an " + JOB_ATMOSPHERIC_TECHNICIAN + " still and can fulfill all the same duties, although specializes more in disposals delivery system's operations and configurations."

/datum/alt_title/refuel_tech
	title = JOB_ALT_FUEL_TECHNICIAN

/datum/job/atmos/get_request_reasons()
	return list("Construction project", "Repairs necessary", "Assembling expedition team")
