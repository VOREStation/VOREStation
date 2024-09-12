var/datum/announcement/minor/captain_announcement = new(do_newscast = 1)

//////////////////////////////////
//			Captain
//////////////////////////////////

/datum/job/captain
	title = JOB_SITE_MANAGER
	flag = CAPTAIN
	departments = list(DEPARTMENT_COMMAND)
	sorting_order = 3 // Above everyone.
	departments_managed = list(DEPARTMENT_COMMAND)
	department_flag = ENGSEC
	faction = FACTION_STATION
	total_positions = 1
	spawn_positions = 1
	supervisors = "company officials and Corporate Regulations"
	selection_color = "#2F2F7F"
	req_admin_notify = 1
	access = list() 			//See get_access()
	minimal_access = list() 	//See get_access()
	minimal_player_age = 14
	economic_modifier = 20

	minimum_character_age = 25
	min_age_by_species = list(SPECIES_HUMAN_VATBORN = 14)
	ideal_character_age = 70 // Old geezer captains ftw
	ideal_age_by_species = list(SPECIES_HUMAN_VATBORN = 55) /// Vatborn live shorter, no other race eligible for captain besides human/skrell
	banned_job_species = list(SPECIES_UNATHI, SPECIES_TAJ, SPECIES_DIONA, SPECIES_PROMETHEAN, SPECIES_ZADDAT, "mechanical", "digital")

	outfit_type = /decl/hierarchy/outfit/job/captain
	job_description = "The " + JOB_SITE_MANAGER + " manages the other Command Staff, and through them the rest of the station. Though they have access to everything, \
						they do not understand everything, and are expected to delegate tasks to the appropriate crew member. The " + JOB_SITE_MANAGER + " is expected to \
						have an understanding of Standard Operating Procedure, and is subject to it, and legal action, in the same way as every other crew member."
	alt_titles = list("Overseer"= /datum/alt_title/overseer)


/*
/datum/job/captain/equip(var/mob/living/carbon/human/H)
	. = ..()
	if(.)
		H.implant_loyalty(src)
*/

/datum/job/captain/get_access()
	return get_all_station_access().Copy()


// Captain Alt Titles
/datum/alt_title/overseer
	title = "Overseer"

//////////////////////////////////
//		Head of Personnel
//////////////////////////////////
/datum/job/hop
	title = JOB_HEAD_OF_PERSONNEL
	flag = HOP
	departments = list(DEPARTMENT_COMMAND, DEPARTMENT_CIVILIAN, DEPARTMENT_CARGO)
	sorting_order = 2 // Above the QM, below captain.
	departments_managed = list(DEPARTMENT_CIVILIAN, DEPARTMENT_CARGO)
	department_flag = CIVILIAN
	faction = FACTION_STATION
	total_positions = 1
	spawn_positions = 1
	supervisors = "the " + JOB_SITE_MANAGER
	selection_color = "#1D1D4F"
	req_admin_notify = 1
	minimal_player_age = 10
	economic_modifier = 10

	minimum_character_age = 25
	min_age_by_species = list(SPECIES_UNATHI = 70, SPECIES_TESHARI = 20, "mechanical" = 10, SPECIES_HUMAN_VATBORN = 14)
	ideal_character_age = 50
	ideal_age_by_species = list(SPECIES_UNATHI = 140, SPECIES_TESHARI = 27, "mechanical" = 20, SPECIES_HUMAN_VATBORN = 20)
	banned_job_species = list(SPECIES_PROMETHEAN, SPECIES_ZADDAT, "digital", SPECIES_DIONA)

	outfit_type = /decl/hierarchy/outfit/job/hop
	job_description = "The " + JOB_HEAD_OF_PERSONNEL + " manages the Service department, the Exploration team, and most other civilians. They also \
						manage the Supply department, through the Quartermaster. In addition, the " + JOB_HEAD_OF_PERSONNEL + " oversees the personal accounts \
						of the crew, including their money and access. If necessary, the " + JOB_HEAD_OF_PERSONNEL + " is first in line to assume Acting Command."
	alt_titles = list("Crew Resources Officer" = /datum/alt_title/cro)

	access = list(access_security, access_sec_doors, access_brig, access_forensics_lockers,
			            access_medical, access_engine, access_change_ids, access_ai_upload, access_eva, access_heads,
			            access_all_personal_lockers, access_maint_tunnels, access_bar, access_janitor, access_construction, access_morgue,
			            access_crematorium, access_kitchen, access_cargo, access_cargo_bot, access_mailsorting, access_qm, access_hydroponics, access_lawyer,
			            access_chapel_office, access_library, access_research, access_mining, access_heads_vault, access_mining_station,
			            access_hop, access_RC_announce, access_keycard_auth, access_gateway)
	minimal_access = list(access_security, access_sec_doors, access_brig, access_forensics_lockers,
			            access_medical, access_engine, access_change_ids, access_ai_upload, access_eva, access_heads,
			            access_all_personal_lockers, access_maint_tunnels, access_bar, access_janitor, access_construction, access_morgue,
			            access_crematorium, access_kitchen, access_cargo, access_cargo_bot, access_mailsorting, access_qm, access_hydroponics, access_lawyer,
			            access_chapel_office, access_library, access_research, access_mining, access_heads_vault, access_mining_station,
			            access_hop, access_RC_announce, access_keycard_auth, access_gateway)

// HOP Alt Titles
/datum/alt_title/cro
	title = "Crew Resources Officer"

//////////////////////////////////
//		Command Secretary
//////////////////////////////////

/datum/job/secretary
	title = JOB_COMMAND_SECRETARY
	flag = BRIDGE
	departments = list(DEPARTMENT_COMMAND)
	department_accounts = list(DEPARTMENT_COMMAND)
	department_flag = CIVILIAN
	faction = FACTION_STATION
	total_positions = 2
	spawn_positions = 2
	supervisors = "command staff"
	selection_color = "#1D1D4F"
	minimal_player_age = 5
	economic_modifier = 7

	access = list(access_heads, access_keycard_auth)
	minimal_access = list(access_heads, access_keycard_auth)

	outfit_type = /decl/hierarchy/outfit/job/secretary
	job_description = "A " + JOB_COMMAND_SECRETARY + " handles paperwork duty for the Heads of Staff, so they can better focus on managing their departments. \
						They are not Heads of Staff, and have no real authority."
