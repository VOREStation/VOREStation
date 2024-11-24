//////////////////////////////////
//		Head of Security
//////////////////////////////////
/datum/job/hos
	title = JOB_HEAD_OF_SECURITY
	flag = HOS
	departments_managed = list(DEPARTMENT_SECURITY)
	departments = list(DEPARTMENT_SECURITY, DEPARTMENT_COMMAND)
	sorting_order = 2
	department_flag = ENGSEC
	faction = FACTION_STATION
	total_positions = 1
	spawn_positions = 1
	supervisors = "the " + JOB_SITE_MANAGER
	selection_color = "#8E2929"
	req_admin_notify = 1
	economic_modifier = 10
	access = list(access_security, access_eva, access_sec_doors, access_brig, access_armory,
							access_forensics_lockers, access_morgue, access_maint_tunnels, access_all_personal_lockers,
							access_construction,
							access_heads, access_hos, access_RC_announce, access_keycard_auth, access_gateway, access_external_airlocks)
	minimal_access = list(access_security, access_eva, access_sec_doors, access_brig, access_armory,
							access_forensics_lockers, access_morgue, access_maint_tunnels, access_all_personal_lockers,
							access_construction,
						access_heads, access_hos, access_RC_announce, access_keycard_auth, access_gateway, access_external_airlocks)
	minimum_character_age = 25
	min_age_by_species = list(SPECIES_HUMAN_VATBORN = 14)
	minimal_player_age = 14
	ideal_character_age = 50
	ideal_age_by_species = list(SPECIES_HUMAN_VATBORN = 20)
	banned_job_species = list(SPECIES_TESHARI, SPECIES_DIONA, SPECIES_PROMETHEAN, SPECIES_ZADDAT, "digital", SPECIES_UNATHI, "mechanical")
	disallow_jobhop = TRUE
	pto_type = PTO_SECURITY
	dept_time_required = 60

	outfit_type = /decl/hierarchy/outfit/job/security/hos
	job_description = "	The " + JOB_HEAD_OF_SECURITY + " manages the Security Department, keeping the station safe and making sure the rules are followed. They are expected to \
						keep the other Department Heads, and the rest of the crew, aware of developing situations that may be a threat. If necessary, the HoS may \
						perform the duties of absent Security roles, such as distributing gear from the Armory."
	alt_titles = list(JOB_ALT_SECURITY_COMMANDER = /datum/alt_title/sec_commander, JOB_ALT_CHIEF_OF_SECURITY = /datum/alt_title/sec_chief, JOB_ALT_SECURITY_MANAGER = /datum/alt_title/security_manager)

/datum/job/hos/get_request_reasons()
	return list("Wildlife management", "Forensic investigation", "Training crew", "Assembling expedition team")

// Head of Security Alt Titles
/datum/alt_title/sec_commander
	title = JOB_ALT_SECURITY_COMMANDER

/datum/alt_title/sec_chief
	title = JOB_ALT_CHIEF_OF_SECURITY

/datum/alt_title/security_manager
	title = JOB_ALT_SECURITY_MANAGER

//////////////////////////////////
//			Warden
//////////////////////////////////
/datum/job/warden
	title = JOB_WARDEN
	flag = WARDEN
	departments = list(DEPARTMENT_SECURITY)
	sorting_order = 1
	department_flag = ENGSEC
	faction = FACTION_STATION
	total_positions = 1
	spawn_positions = 1
	supervisors = "the " + JOB_HEAD_OF_SECURITY
	selection_color = "#601C1C"
	economic_modifier = 5
	pto_type = PTO_SECURITY
	dept_time_required = 20
	access = list(access_security, access_eva, access_sec_doors, access_brig, access_armory, access_maint_tunnels, access_morgue, access_external_airlocks)
	minimal_access = list(access_security, access_eva, access_sec_doors, access_brig, access_armory, access_maint_tunnels, access_external_airlocks)
	minimal_player_age = 5
	banned_job_species = list(SPECIES_ZADDAT, SPECIES_PROMETHEAN, SPECIES_TESHARI, SPECIES_DIONA)
	alt_titles = list(JOB_ALT_BRIG_SENTRY = /datum/alt_title/brig_sentry, JOB_ALT_ARMORY_SUPERINTENDENT = /datum/alt_title/armory_superintendent, JOB_ALT_MASTERATARMS = /datum/alt_title/master_at_arms)
	outfit_type = /decl/hierarchy/outfit/job/security/warden
	job_description = "The " + JOB_WARDEN + " watches over the physical Security Department, making sure the Brig and Armoury are secure and in order at all times. They oversee \
						prisoners that have been processed and brigged, and are responsible for their well being. The " + JOB_WARDEN + " is also in charge of distributing \
						Armoury gear in a crisis, and retrieving it when the crisis has passed. In an emergency, the " + JOB_WARDEN + " may be called upon to direct the \
						Security Department as a whole."

/datum/job/warden/get_request_reasons()
	return list("Wildlife management")

//Warden Alt Titles
/datum/alt_title/brig_sentry
	title = JOB_ALT_BRIG_SENTRY

/datum/alt_title/armory_superintendent
	title = JOB_ALT_ARMORY_SUPERINTENDENT

/datum/alt_title/master_at_arms
	title = JOB_ALT_MASTERATARMS

//////////////////////////////////
//			Detective
//////////////////////////////////
/datum/job/detective
	title = JOB_DETECTIVE
	flag = DETECTIVE
	departments = list(DEPARTMENT_SECURITY)
	department_flag = ENGSEC
	faction = FACTION_STATION
	total_positions = 2
	spawn_positions = 2
	pto_type = PTO_SECURITY
	supervisors = "the " + JOB_HEAD_OF_SECURITY
	selection_color = "#601C1C"
	access = list(access_security, access_sec_doors, access_forensics_lockers, access_morgue, access_maint_tunnels, access_eva, access_external_airlocks, access_brig) //Vorestation edit - access_brig
	minimal_access = list(access_security, access_sec_doors, access_forensics_lockers, access_morgue, access_maint_tunnels, access_eva, access_external_airlocks)
	economic_modifier = 5
	minimal_player_age = 3
	banned_job_species = list(SPECIES_ZADDAT, SPECIES_PROMETHEAN, SPECIES_DIONA)

	outfit_type = /decl/hierarchy/outfit/job/security/detective
	job_description = "A " + JOB_DETECTIVE + " works to help Security find criminals who have not properly been identified, through interviews and forensic work. \
						For crimes only witnessed after the fact, or those with no survivors, they attempt to piece together what they can from pure evidence."
	alt_titles = list(JOB_ALT_INVESTIGATOR = /datum/alt_title/investigator, JOB_ALT_SECURITY_INSPECTOR = /datum/alt_title/security_inspector, JOB_ALT_FORENSIC_TECHNICIAN = /datum/alt_title/forensic_tech)

/datum/job/detective/get_request_reasons()
	return list("Forensic investigation")

// Detective Alt Titles
/datum/alt_title/forensic_tech
	title = JOB_ALT_FORENSIC_TECHNICIAN
	title_blurb = "A " + JOB_ALT_FORENSIC_TECHNICIAN + " works more with hard evidence and labwork than a " + JOB_DETECTIVE + ", but they share the purpose of solving crimes."
	title_outfit = /decl/hierarchy/outfit/job/security/detective/forensic

/datum/alt_title/investigator
	title = JOB_ALT_INVESTIGATOR

/datum/alt_title/security_inspector
	title = JOB_ALT_SECURITY_INSPECTOR

//////////////////////////////////
//		Security Officer
//////////////////////////////////
/datum/job/officer
	title = JOB_SECURITY_OFFICER
	flag = OFFICER
	departments = list(DEPARTMENT_SECURITY)
	department_flag = ENGSEC
	faction = FACTION_STATION
	total_positions = 5
	spawn_positions = 5
	pto_type = PTO_SECURITY
	supervisors = "the " + JOB_HEAD_OF_SECURITY
	selection_color = "#601C1C"
	economic_modifier = 4
	access = list(access_security, access_eva, access_sec_doors, access_brig, access_maint_tunnels, access_morgue, access_external_airlocks)
	minimal_access = list(access_security, access_eva, access_sec_doors, access_brig, access_maint_tunnels, access_external_airlocks)
	minimal_player_age = 3
	banned_job_species = list(SPECIES_ZADDAT, SPECIES_TESHARI, SPECIES_DIONA)

	outfit_type = /decl/hierarchy/outfit/job/security/officer
	job_description = "A " + JOB_SECURITY_OFFICER + " is concerned with maintaining the safety and security of the station as a whole, dealing with external threats and \
						apprehending criminals. A " + JOB_SECURITY_OFFICER + " is responsible for the health, safety, and processing of any prisoner they arrest. \
						No one is above the Law, not Security or Command."
	alt_titles = list(JOB_ALT_PATROL_OFFICER = /datum/alt_title/patrol_officer, JOB_ALT_SECURITY_GUARD = /datum/alt_title/security_guard,
						JOB_ALT_SECURITY_DEPUTY = /datum/alt_title/security_guard, JOB_ALT_JUNIOR_OFFICER = /datum/alt_title/junior_officer, JOB_ALT_SECURITY_CONTRACTOR = /datum/alt_title/security_contractor)

	min_age_by_species = list(SPECIES_PROMETHEAN = 3)

/datum/job/officer/get_request_reasons()
	return list("Wildlife management", "Assembling expedition team")

// Security Officer Alt Titles
/datum/alt_title/junior_officer
	title = JOB_ALT_JUNIOR_OFFICER
	title_blurb = "A " + JOB_ALT_JUNIOR_OFFICER + " is an inexperienced " + JOB_SECURITY_OFFICER + ". They likely have training, but not experience, and are frequently \
					paired off with a more senior co-worker. Junior Officers may also be expected to take over the boring duties of other Officers \
					including patrolling the station or maintaining specific posts."

/datum/alt_title/patrol_officer
	title = JOB_ALT_PATROL_OFFICER

/datum/alt_title/security_guard
	title = JOB_ALT_SECURITY_GUARD

/datum/alt_title/security_deputy
	title = JOB_ALT_SECURITY_DEPUTY

/datum/alt_title/security_contractor
	title = JOB_ALT_SECURITY_CONTRACTOR
