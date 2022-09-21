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
	alt_titles = list("Head Engineer" = /datum/alt_title/head_engineer, "Foreman" = /datum/alt_title/foreman, "Maintenance Manager" = /datum/alt_title/maintenance_manager)

/datum/alt_title/head_engineer
	title = "Head Engineer"

/datum/alt_title/foreman
	title = "Foreman"

/datum/alt_title/maintenance_manager
	title = "Maintenance Manager"

/datum/job/chief_engineer/get_request_reasons()
	return list("Engine setup", "Construction project", "Repairs necessary", "Training crew")


/datum/job/engineer
	pto_type = PTO_ENGINEERING
	alt_titles = list("Maintenance Technician" = /datum/alt_title/maint_tech, "Engine Technician" = /datum/alt_title/engine_tech,
						"Electrician" = /datum/alt_title/electrician, "Construction Engineer" = /datum/alt_title/construction_engi, "Engineering Contractor" = /datum/alt_title/engineering_contractor)

/datum/alt_title/construction_engi
	title = "Construction Engineer"
	title_blurb = "A Construction Engineer fulfills similar duties to other engineers, but usually occupies spare time with construction of extra facilities in dedicated areas or \
					as additions to station layout."

/datum/alt_title/engineering_contractor
	title = "Engineering Contractor"
	title_blurb = "An Engineering Contractor fulfills similar duties to other engineers, but isn't directly employed by NT proper."

/datum/job/engineer/get_request_reasons()
	return list("Engine setup", "Construction project", "Repairs necessary")




/datum/job/atmos
	spawn_positions = 3
	pto_type = PTO_ENGINEERING
	alt_titles = list("Atmospheric Engineer" = /datum/alt_title/atmos_engi, "Atmospheric Maintainer" = /datum/alt_title/atmos_maint, "Disposals Technician" = /datum/alt_title/disposals_tech)

/datum/alt_title/atmos_maint
	title = "Atmospheric Maintainer"

/datum/alt_title/atmos_engi
	title = "Atmospheric Engineer"

/datum/alt_title/disposals_tech
	title = "Disposals Technician"
	title_blurb = "A Disposals Technician is an Atmospheric Technician still and can fulfill all the same duties, although specializes more in disposals delivery system's operations and configurations."

/datum/job/atmos/get_request_reasons()
	return list("Construction project", "Repairs necessary")