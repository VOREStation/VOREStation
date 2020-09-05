/datum/job/rd
	disallow_jobhop = TRUE
	pto_type = PTO_SCIENCE
	dept_time_required = 60

	access = list(access_rd, access_heads, access_tox, access_genetics, access_morgue,
			            access_tox_storage, access_teleporter,
			            access_research, access_robotics, access_xenobiology, access_ai_upload, access_tech_storage,
			            access_RC_announce, access_keycard_auth, access_tcomsat, access_xenoarch, access_eva, access_network, access_xenobotany)
	minimal_access = list(access_rd, access_heads, access_tox, access_genetics, access_morgue,
			            access_tox_storage, access_teleporter,
			            access_research, access_robotics, access_xenobiology, access_ai_upload, access_tech_storage,
			            access_RC_announce, access_keycard_auth, access_tcomsat, access_xenoarch, access_eva, access_network, access_xenobotany)

/datum/job/scientist
	spawn_positions = 5
	pto_type = PTO_SCIENCE
	alt_titles = list("Xenoarchaeologist" = /datum/alt_title/xenoarch, "Anomalist" = /datum/alt_title/anomalist, \
						"Phoron Researcher" = /datum/alt_title/phoron_research, "Circuit Designer" = /datum/alt_title/circuit_designer)


	access = list(access_robotics, access_tox, access_tox_storage, access_research, access_xenobiology, access_xenoarch, access_xenobotany)
	minimal_access = list(access_tox, access_tox_storage, access_research, access_xenoarch)					// Unchanged (for now?), mostly here for reference


/datum/alt_title/circuit_designer
	title = "Circuit Designer"
	title_blurb = "A Circuit Designer is a Scientist whose expertise is working with integrated circuits. They are familar with the workings and programming of those devices. \
				   They work to create various useful devices using the capabilities of integrated circuitry."

/datum/job/xenobiologist
	spawn_positions = 3
	pto_type = PTO_SCIENCE

/datum/job/roboticist
	total_positions = 3
	pto_type = PTO_SCIENCE

//////////////////////////////////
//			Xenobotanist
//////////////////////////////////
/datum/job/xenobotanist
	title = "Xenobotanist"
	flag = XENOBOTANIST
	departments = list(DEPARTMENT_RESEARCH)
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Research Director"
	selection_color = "#633D63"
	economic_modifier = 7
	access = list(access_robotics, access_tox, access_tox_storage, access_research, access_xenobotany, access_hydroponics)
	minimal_access = list(access_research, access_xenobotany, access_hydroponics, access_tox_storage)
	pto_type = PTO_SCIENCE

	minimal_player_age = 14

	outfit_type = /decl/hierarchy/outfit/job/science/xenobiologist
	job_description = "A Xenobotanist grows and cares for a variety of abnormal, custom made, and frequently dangerous plant life. When the products of these plants \
					are both safe and beneficial to the station, they may choose to introduce it to the rest of the crew."
