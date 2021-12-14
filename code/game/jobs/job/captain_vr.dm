/datum/job/captain
	disallow_jobhop = TRUE
	pto_type = PTO_CIVILIAN
	dept_time_required = 80 //Pending something more complicated
	alt_titles = list("Overseer"= /datum/alt_title/overseer, "Facility Director" = /datum/alt_title/facility_director, "Chief Supervisor" = /datum/alt_title/chief_supervisor,
						"Captain" = /datum/alt_title/captain)

/datum/alt_title/facility_director
	title = "Facility Director"

/datum/alt_title/chief_supervisor
	title = "Chief Supervisor"

/datum/alt_title/captain
	title = "Captain"

/datum/job/hop
	disallow_jobhop = TRUE
	pto_type = PTO_CIVILIAN
	departments = list(DEPARTMENT_COMMAND, DEPARTMENT_CIVILIAN)
	departments_managed = list(DEPARTMENT_CIVILIAN, DEPARTMENT_CARGO, DEPARTMENT_PLANET)
	dept_time_required = 60

	alt_titles = list("Crew Resources Officer" = /datum/alt_title/cro, "Deputy Manager" = /datum/alt_title/deputy_manager, "Staff Manager" = /datum/alt_title/staff_manager,
						"Facility Steward" = /datum/alt_title/facility_steward)

	access = list(access_security, access_sec_doors, access_brig, access_forensics_lockers,
			            access_medical, access_engine, access_change_ids, access_ai_upload, access_eva, access_heads,
			            access_all_personal_lockers, access_maint_tunnels, access_bar, access_janitor, access_construction, access_morgue,
			            access_crematorium, access_kitchen, access_cargo, access_cargo_bot, access_mailsorting, access_qm, access_hydroponics, access_lawyer,
			            access_chapel_office, access_library, access_research, access_mining, access_heads_vault, access_mining_station,
			            access_hop, access_RC_announce, access_clown, access_tomfoolery, access_mime, access_keycard_auth, access_gateway)
	minimal_access = list(access_security, access_sec_doors, access_brig, access_forensics_lockers,
			            access_medical, access_engine, access_change_ids, access_ai_upload, access_eva, access_heads,
			            access_all_personal_lockers, access_maint_tunnels, access_bar, access_janitor, access_construction, access_morgue,
			            access_crematorium, access_kitchen, access_cargo, access_cargo_bot, access_mailsorting, access_qm, access_hydroponics, access_lawyer,
			            access_chapel_office, access_library, access_research, access_mining, access_heads_vault, access_mining_station,
			            access_hop, access_RC_announce, access_clown, access_tomfoolery, access_mime, access_keycard_auth, access_gateway)

/datum/alt_title/deputy_manager
	title = "Deputy Manager"

/datum/alt_title/staff_manager
	title = "Staff Manager"

/datum/alt_title/facility_steward
	title = "Facility Steward"


/datum/job/secretary
	disallow_jobhop = TRUE
	pto_type = PTO_CIVILIAN
	alt_titles = list("Command Liaison" = /datum/alt_title/command_liaison, "Command Assistant" = /datum/alt_title/command_assistant, "Command Intern" = /datum/alt_title/command_intern,
						"Bridge Secretary" = /datum/alt_title/bridge_secretary, "Bridge Assistant" = /datum/alt_title/bridge_assistant)

/datum/alt_title/command_liaison
	title = "Command Liaison"

/datum/alt_title/command_assistant
	title = "Command Assistant"

/datum/alt_title/command_intern
	title = "Command Intern"

/datum/alt_title/bridge_secretary
	title = "Bridge Secretary"

/datum/alt_title/bridge_assistant
	title = "Bridge Assistant"