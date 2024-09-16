/datum/job/captain
	disallow_jobhop = TRUE
	pto_type = PTO_CIVILIAN
	dept_time_required = 80 //Pending something more complicated
	alt_titles = list(JOB_ALT_OVERSEER= /datum/alt_title/overseer, JOB_ALT_FACILITY_DIRECTOR = /datum/alt_title/facility_director, JOB_ALT_CHIEF_SUPERVISOR = /datum/alt_title/chief_supervisor,
						JOB_ALT_CAPTAIN = /datum/alt_title/captain)

/datum/alt_title/facility_director
	title = JOB_ALT_FACILITY_DIRECTOR

/datum/alt_title/chief_supervisor
	title = JOB_ALT_CHIEF_SUPERVISOR

/datum/alt_title/captain
	title = JOB_ALT_CAPTAIN

/datum/job/captain/get_request_reasons()
	return list("Training crew", "Assembling expedition team")

/datum/job/hop
	disallow_jobhop = TRUE
	pto_type = PTO_CIVILIAN
	departments = list(DEPARTMENT_COMMAND, DEPARTMENT_CIVILIAN)
	departments_managed = list(DEPARTMENT_CIVILIAN, DEPARTMENT_CARGO, DEPARTMENT_PLANET)
	dept_time_required = 60

	alt_titles = list(JOB_ALT_CREW_RESOURCE_OFFICER = /datum/alt_title/cro, JOB_ALT_DEPUTY_MANAGER = /datum/alt_title/deputy_manager, JOB_ALT_STAFF_MANAGER = /datum/alt_title/staff_manager,
						JOB_ALT_FACILITY_STEWARD = /datum/alt_title/facility_steward, JOB_ALT_FIRST_MATE = /datum/alt_title/first_mate)

	access = list(access_security, access_sec_doors, access_brig, access_forensics_lockers,
			            access_medical, access_engine, access_change_ids, access_ai_upload, access_eva, access_heads,
			            access_all_personal_lockers, access_maint_tunnels, access_bar, access_janitor, access_construction, access_morgue,
			            access_crematorium, access_kitchen, access_cargo, access_cargo_bot, access_mailsorting, access_qm, access_hydroponics, access_lawyer,
			            access_chapel_office, access_library, access_research, access_mining, access_heads_vault, access_mining_station,
			            access_hop, access_RC_announce, access_clown, access_tomfoolery, access_mime, access_keycard_auth, access_gateway, access_entertainment)
	minimal_access = list(access_security, access_sec_doors, access_brig, access_forensics_lockers,
			            access_medical, access_engine, access_change_ids, access_ai_upload, access_eva, access_heads,
			            access_all_personal_lockers, access_maint_tunnels, access_bar, access_janitor, access_construction, access_morgue,
			            access_crematorium, access_kitchen, access_cargo, access_cargo_bot, access_mailsorting, access_qm, access_hydroponics, access_lawyer,
			            access_chapel_office, access_library, access_research, access_mining, access_heads_vault, access_mining_station,
			            access_hop, access_RC_announce, access_clown, access_tomfoolery, access_mime, access_keycard_auth, access_gateway, access_entertainment)

/datum/alt_title/deputy_manager
	title = JOB_ALT_DEPUTY_MANAGER

/datum/alt_title/staff_manager
	title = JOB_ALT_STAFF_MANAGER

/datum/alt_title/facility_steward
	title = JOB_ALT_FACILITY_STEWARD

/datum/alt_title/first_mate
	title = JOB_ALT_FIRST_MATE

/datum/job/hop/get_request_reasons()
	return list("ID modification", "Training crew", "Assembling expedition team")


/datum/job/secretary
	disallow_jobhop = TRUE
	pto_type = PTO_CIVILIAN
	alt_titles = list(JOB_ALT_COMMAND_LIAISON = /datum/alt_title/command_liaison, JOB_ALT_COMMAND_ASSISTANT = /datum/alt_title/command_assistant, JOB_ALT_COMMAND_INTERN = /datum/alt_title/command_intern,
						JOB_ALT_BRIDGE_SECRETARY = /datum/alt_title/bridge_secretary, JOB_ALT_BRIDGE_ASSISTANT = /datum/alt_title/bridge_assistant)

/datum/alt_title/command_liaison
	title = JOB_ALT_COMMAND_LIAISON

/datum/alt_title/command_assistant
	title = JOB_ALT_COMMAND_ASSISTANT

/datum/alt_title/command_intern
	title = JOB_ALT_COMMAND_INTERN

/datum/alt_title/bridge_secretary
	title = JOB_ALT_BRIDGE_SECRETARY

/datum/alt_title/bridge_assistant
	title = JOB_ALT_BRIDGE_ASSISTANT
