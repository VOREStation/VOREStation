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
	alt_titles = list(JOB_ALT_SECURITY_COMMANDER = /datum/alt_title/sec_commander, JOB_ALT_CHIEF_OF_SECURITY = /datum/alt_title/sec_chief, JOB_ALT_SECURITY_MANAGER = /datum/alt_title/security_manager)

/datum/alt_title/security_manager
	title = JOB_ALT_SECURITY_MANAGER

/datum/job/hos/get_request_reasons()
	return list("Wildlife management", "Forensic investigation", "Training crew", "Assembling expedition team")


/datum/job/warden
	pto_type = PTO_SECURITY
	dept_time_required = 20
	alt_titles = list(JOB_ALT_BRIG_SENTRY = /datum/alt_title/brig_sentry, JOB_ALT_ARMORY_SUPERINTENDENT = /datum/alt_title/armory_superintendent, JOB_ALT_MASTERATARMS = /datum/alt_title/master_at_arms)

/datum/alt_title/brig_sentry
	title = JOB_ALT_BRIG_SENTRY

/datum/alt_title/armory_superintendent
	title = JOB_ALT_ARMORY_SUPERINTENDENT

/datum/alt_title/master_at_arms
	title = JOB_ALT_MASTERATARMS

/datum/job/warden/get_request_reasons()
	return list("Wildlife management")


/datum/job/detective
	pto_type = PTO_SECURITY
	alt_titles = list(JOB_ALT_INVESTIGATOR = /datum/alt_title/investigator, JOB_ALT_SECURITY_INSPECTOR = /datum/alt_title/security_inspector, JOB_ALT_FORENSIC_TECHNICIAN = /datum/alt_title/forensic_tech)

/datum/alt_title/investigator
	title = JOB_ALT_INVESTIGATOR

/datum/alt_title/security_inspector
	title = JOB_ALT_SECURITY_INSPECTOR

/datum/job/detective/get_request_reasons()
	return list("Forensic investigation")


/datum/job/officer
	total_positions = 5
	spawn_positions = 5
	pto_type = PTO_SECURITY
	alt_titles = list(JOB_ALT_PATROL_OFFICER = /datum/alt_title/patrol_officer, JOB_ALT_SECURITY_GUARD = /datum/alt_title/security_guard,
						JOB_ALT_SECURITY_DEPUTY = /datum/alt_title/security_guard, JOB_ALT_JUNIOR_OFFICER = /datum/alt_title/junior_officer, JOB_ALT_SECURITY_CONTRACTOR = /datum/alt_title/security_contractor)

/datum/alt_title/patrol_officer
	title = JOB_ALT_PATROL_OFFICER

/datum/alt_title/security_guard
	title = JOB_ALT_SECURITY_GUARD

/datum/alt_title/security_deputy
	title = JOB_ALT_SECURITY_DEPUTY

/datum/alt_title/security_contractor
	title = JOB_ALT_SECURITY_CONTRACTOR

/datum/job/officer/get_request_reasons()
	return list("Wildlife management", "Assembling expedition team")
