/datum/job/hos
	disallow_jobhop = TRUE
	pto_type = PTO_SECURITY
	dept_time_required = 60

	access = list(access_security, access_eva, access_sec_doors, access_brig, access_armory,
						access_forensics_lockers, access_morgue, access_maint_tunnels, access_all_personal_lockers,
						access_construction,
						access_heads, access_hos, access_RC_announce, access_keycard_auth, access_gateway, access_external_airlocks)
	minimal_access = list(access_security, access_eva, access_sec_doors, access_brig, access_armory,
						access_forensics_lockers, access_morgue, access_maint_tunnels, access_all_personal_lockers,
						access_construction,
						access_heads, access_hos, access_RC_announce, access_keycard_auth, access_gateway, access_external_airlocks)
	alt_titles = list("Security Commander" = /datum/alt_title/sec_commander, "Chief of Security" = /datum/alt_title/sec_chief, "Security Manager" = /datum/alt_title/security_manager)

/datum/alt_title/security_manager
	title = "Security Manager"

/datum/job/hos/get_request_reasons()
	return list("Wildlife management", "Forensic investigation")


/datum/job/warden
	pto_type = PTO_SECURITY
	dept_time_required = 20
	alt_titles = list("Brig Sentry" = /datum/alt_title/brig_sentry, "Armory Superintendent" = /datum/alt_title/armory_superintendent)

/datum/alt_title/brig_sentry
	title = "Brig Sentry"

/datum/alt_title/armory_superintendent
	title = "Armory Superintendent"

/datum/job/warden/get_request_reasons()
	return list("Wildlife management")


/datum/job/detective
	pto_type = PTO_SECURITY
	alt_titles = list("Investigator" = /datum/alt_title/investigator, "Security Inspector" = /datum/alt_title/security_inspector, "Forensic Technician" = /datum/alt_title/forensic_tech)

/datum/alt_title/investigator
	title = "Investigator"

/datum/alt_title/security_inspector
	title = "Security Inspector"

/datum/job/detective/get_request_reasons()
	return list("Forensic investigation")


/datum/job/officer
	total_positions = 5
	spawn_positions = 5
	pto_type = PTO_SECURITY
	alt_titles = list("Patrol Officer" = /datum/alt_title/patrol_officer, "Security Guard" = /datum/alt_title/security_guard,
						"Security Deputy" = /datum/alt_title/security_guard, "Junior Officer" = /datum/alt_title/junior_officer, "Security Contractor" = /datum/alt_title/security_contractor)

/datum/alt_title/patrol_officer
	title = "Patrol Officer"

/datum/alt_title/security_guard
	title = "Security Guard"

/datum/alt_title/security_deputy
	title = "Security Deputy"

/datum/alt_title/security_contractor
	title = "Security Contractor"

/datum/job/officer/get_request_reasons()
	return list("Wildlife management")