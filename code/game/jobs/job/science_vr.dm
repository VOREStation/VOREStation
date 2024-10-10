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
			            access_RC_announce, access_keycard_auth, access_tcomsat, access_gateway, access_xenoarch, access_eva, access_network, access_xenobotany)
	alt_titles = list(JOB_ALT_RESEARCH_SUPERVISOR = /datum/alt_title/research_supervisor, JOB_ALT_RESEARCH_MANAGER = /datum/alt_title/research_manager,
						JOB_ALT_HEAD_OF_DEVELOPMENT = /datum/alt_title/head_of_development,JOB_ALT_HEAD_SCIENTIST = /datum/alt_title/head_scientist)

/datum/alt_title/research_manager
	title = JOB_ALT_RESEARCH_MANAGER

/datum/alt_title/head_of_development
	title = JOB_ALT_HEAD_OF_DEVELOPMENT

/datum/alt_title/head_scientist
	title = JOB_ALT_HEAD_SCIENTIST

/datum/job/rd/get_request_reasons()
	return list("Repairs needed", "Training crew", "Assembling expedition team")


/datum/job/scientist
	spawn_positions = 5
	pto_type = PTO_SCIENCE
	alt_titles = list(JOB_ALT_RESEARCHER = /datum/alt_title/researcher, JOB_ALT_LAB_ASSISTANT = /datum/alt_title/lab_assistant, JOB_ALT_XENOARCHAEOLOGIST = /datum/alt_title/xenoarch,
						JOB_ALT_XENOPALEONTOLOGIST = /datum/alt_title/xenopaleontologist, JOB_ALT_ANOMALIST = /datum/alt_title/anomalist, JOB_ALT_PHORON_RESEARCHER = /datum/alt_title/phoron_research,
						JOB_ALT_GAS_PHYSICIST = /datum/alt_title/gas_physicist, JOB_ALT_CIRCUIT_DESIGNER = /datum/alt_title/circuit_designer, JOB_ALT_CIRCUIT_PROGRAMMER = /datum/alt_title/circuit_programmer)


	access = list(access_robotics, access_tox, access_tox_storage, access_research, access_xenobiology, access_xenoarch, access_xenobotany)
	minimal_access = list(access_tox, access_tox_storage, access_research, access_xenoarch)					// Unchanged (for now?), mostly here for reference

/datum/alt_title/researcher
	title = JOB_ALT_RESEARCHER

/datum/alt_title/lab_assistant
	title = JOB_ALT_LAB_ASSISTANT
	title_blurb = "A " + JOB_ALT_LAB_ASSISTANT + " is a lower-level member of research staff, whose main purpose is to help scientists with their specialized work in more menial fashion, while also \
					learning the specializations in process."

/datum/alt_title/xenopaleontologist
	title = JOB_ALT_XENOPALEONTOLOGIST
	title_blurb = "A " + JOB_ALT_XENOPALEONTOLOGIST + " enters digsites in search of fossils and other ancient remants of alien life. These digsites are frequently in vacuum or other inhospitable \
					locations, and as such a " + JOB_ALT_XENOPALEONTOLOGIST + " should be prepared to handle hostile evironmental conditions."

/datum/alt_title/gas_physicist
	title = JOB_ALT_GAS_PHYSICIST
	title_blurb = "A " + JOB_ALT_GAS_PHYSICIST + " is a specialist in various practical applications of gasses, but currently focuses their attention on phoron, and has knowledge of its practical uses and dangers. \
					Many " + JOB_ALT_GAS_PHYSICIST + "s are interested in the combustability and explosive properties of gaseous phoron, as well as the specific hazards \
					of working with the substance in that state."

/datum/alt_title/circuit_designer
	title = JOB_ALT_CIRCUIT_DESIGNER
	title_blurb = "A " + JOB_ALT_CIRCUIT_DESIGNER + " is a " + JOB_SCIENTIST + " whose expertise is working with integrated circuits. They are familar with the workings and programming of those devices. \
				   They work to create various useful devices using the capabilities of integrated circuitry."

/datum/alt_title/circuit_programmer
	title = JOB_ALT_CIRCUIT_PROGRAMMER
	title_blurb = "A " + JOB_ALT_CIRCUIT_PROGRAMMER + " is a " + JOB_SCIENTIST + " whose expertise is working with integrated circuits. They are familar with the workings and programming of those devices. \
				   They work to create various useful devices using the capabilities of integrated circuitry."

/datum/job/scientist/get_request_reasons()
	return list("Assembling expedition team")

/datum/job/xenobiologist
	spawn_positions = 3
	pto_type = PTO_SCIENCE
	alt_titles = list(JOB_ALT_XENOZOOLOGIST = /datum/alt_title/xenozoologist, JOB_ALT_XENOANTHROPOLOGIST = /datum/alt_title/xenoanthropologist)

/datum/alt_title/xenozoologist
	title = JOB_ALT_XENOZOOLOGIST

/datum/alt_title/xenoanthropologist
	title = JOB_ALT_XENOANTHROPOLOGIST
	title_blurb = JOB_ALT_XENOANTHROPOLOGIST + " still heavily focuses their study on alien lifeforms, but their specialty leans more towards fellow sapient beings than simple animals."


/datum/job/roboticist
	total_positions = 3
	pto_type = PTO_SCIENCE
	alt_titles = list(
		JOB_ALT_ASSEMBLY_TECHNICIAN = /datum/alt_title/assembly_tech,
		JOB_ALT_BIOMECHANICAL_ENGINEER = /datum/alt_title/biomech,
		JOB_ALT_MECHATRONIC_ENGINEER = /datum/alt_title/mech_tech,
		JOB_ALT_SOFTWARE_ENGINEER = /datum/alt_title/software_engi)

/datum/alt_title/software_engi
	title = JOB_ALT_SOFTWARE_ENGINEER
	title_blurb = "A " + JOB_ALT_SOFTWARE_ENGINEER + " specializes in working with software and firmware. They also often deal with integrated circuits."

/datum/alt_title/assembly_tech
	title = JOB_ALT_ASSEMBLY_TECHNICIAN

/datum/job/roboticist/get_request_reasons()
	return list("Repairs needed")

//////////////////////////////////
//			Xenobotanist
//////////////////////////////////
/datum/job/xenobotanist
	title = JOB_XENOBOTANIST
	flag = XENOBOTANIST
	departments = list(DEPARTMENT_RESEARCH)
	department_flag = MEDSCI
	faction = FACTION_STATION
	total_positions = 2
	spawn_positions = 2
	supervisors = "the " + JOB_RESEARCH_DIRECTOR
	selection_color = "#633D63"
	economic_modifier = 7
	access = list(access_robotics, access_tox, access_tox_storage, access_research, access_xenobotany, access_hydroponics)
	minimal_access = list(access_research, access_xenobotany, access_hydroponics, access_tox_storage)
	pto_type = PTO_SCIENCE

	minimal_player_age = 14

	outfit_type = /decl/hierarchy/outfit/job/science/xenobiologist
	job_description = "A " + JOB_XENOBOTANIST + " grows and cares for a variety of abnormal, custom made, and frequently dangerous plant life. When the products of these plants \
					are both safe and beneficial to the station, they may choose to introduce it to the rest of the crew."
	alt_titles = list(JOB_ALT_XENOHYDROPONICIST = /datum/alt_title/xenohydroponicist, JOB_ALT_XENOFLORIST = /datum/alt_title/xenoflorist)

/datum/alt_title/xenoflorist
	title = JOB_ALT_XENOFLORIST

/datum/alt_title/xenohydroponicist
	title = JOB_ALT_XENOHYDROPONICIST
