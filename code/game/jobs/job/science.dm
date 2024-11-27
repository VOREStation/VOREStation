//////////////////////////////////
//		Research Director
//////////////////////////////////
/datum/job/rd
	title = JOB_RESEARCH_DIRECTOR
	flag = RD
	departments_managed = list(DEPARTMENT_RESEARCH)
	departments = list(DEPARTMENT_RESEARCH, DEPARTMENT_COMMAND)
	sorting_order = 2
	department_flag = MEDSCI
	faction = FACTION_STATION
	total_positions = 1
	spawn_positions = 1
	supervisors = "the " + JOB_SITE_MANAGER
	selection_color = "#AD6BAD"
	req_admin_notify = 1
	economic_modifier = 15
	access = list(access_rd, access_heads, access_tox, access_genetics, access_morgue,
			            access_tox_storage, access_teleporter,
			            access_research, access_robotics, access_xenobiology, access_ai_upload, access_tech_storage,
			            access_RC_announce, access_keycard_auth, access_tcomsat, access_xenoarch, access_eva, access_network, access_xenobotany)
	minimal_access = list(access_rd, access_heads, access_tox, access_genetics, access_morgue,
			            access_tox_storage, access_teleporter,
			            access_research, access_robotics, access_xenobiology, access_ai_upload, access_tech_storage,
			            access_RC_announce, access_keycard_auth, access_tcomsat, access_gateway, access_xenoarch, access_eva, access_network, access_xenobotany)

	minimum_character_age = 25
	minimal_player_age = 14
	min_age_by_species = list(SPECIES_UNATHI = 70, "mechanical" = 10, SPECIES_HUMAN_VATBORN = 14)
	ideal_character_age = 50
	ideal_age_by_species = list(SPECIES_UNATHI = 140, "mechanical" = 20, SPECIES_HUMAN_VATBORN = 20)
	banned_job_species = list(SPECIES_TESHARI, SPECIES_DIONA, SPECIES_PROMETHEAN, SPECIES_ZADDAT, "digital")
	disallow_jobhop = TRUE
	pto_type = PTO_SCIENCE
	dept_time_required = 60

	outfit_type = /decl/hierarchy/outfit/job/science/rd
	job_description = "The " + JOB_RESEARCH_DIRECTOR + " manages and maintains the Research department. They are required to ensure the safety of the entire crew, \
						at least with regards to anything occurring in the Research department, and to inform the crew of any disruptions that \
						might originate from Research. The " + JOB_RESEARCH_DIRECTOR + " often has at least passing knowledge of most of the Research department, but \
						are encouraged to allow their staff to perform their own duties."
	alt_titles = list(JOB_ALT_RESEARCH_SUPERVISOR = /datum/alt_title/research_supervisor, JOB_ALT_RESEARCH_MANAGER = /datum/alt_title/research_manager,
						JOB_ALT_HEAD_OF_DEVELOPMENT = /datum/alt_title/head_of_development,JOB_ALT_HEAD_SCIENTIST = /datum/alt_title/head_scientist)

/datum/job/rd/get_request_reasons()
	return list("Repairs needed", "Training crew", "Assembling expedition team")

// " + JOB_RESEARCH_DIRECTOR + " Alt Titles
/datum/alt_title/research_supervisor
	title = JOB_ALT_RESEARCH_SUPERVISOR

/datum/alt_title/research_manager
	title = JOB_ALT_RESEARCH_MANAGER

/datum/alt_title/head_of_development
	title = JOB_ALT_HEAD_OF_DEVELOPMENT

/datum/alt_title/head_scientist
	title = JOB_ALT_HEAD_SCIENTIST

//////////////////////////////////
//			Scientist
//////////////////////////////////
/datum/job/scientist
	title = JOB_SCIENTIST
	flag = SCIENTIST
	departments = list(DEPARTMENT_RESEARCH)
	department_flag = MEDSCI
	faction = FACTION_STATION
	total_positions = 5
	spawn_positions = 5
	pto_type = PTO_SCIENCE
	supervisors = "the " + JOB_RESEARCH_DIRECTOR
	selection_color = "#633D63"
	economic_modifier = 7
	access = list(access_robotics, access_tox, access_tox_storage, access_research, access_xenobiology, access_xenoarch, access_xenobotany)
	minimal_access = list(access_tox, access_tox_storage, access_research, access_xenoarch)
	min_age_by_species = list(SPECIES_PROMETHEAN = 2)
	banned_job_species = list("digital")

	minimal_player_age = 14

	outfit_type = /decl/hierarchy/outfit/job/science/scientist
	job_description = "A " + JOB_SCIENTIST + " is a generalist working in the Research department, with general knowledge of the scientific process, as well as \
						the principles and requirements of Research and Development. They may also formulate experiments of their own devising, if \
						they find an appropriate topic."
	alt_titles = list(JOB_ALT_RESEARCHER = /datum/alt_title/researcher, JOB_ALT_LAB_ASSISTANT = /datum/alt_title/lab_assistant, JOB_ALT_XENOARCHAEOLOGIST = /datum/alt_title/xenoarch,
							JOB_ALT_XENOPALEONTOLOGIST = /datum/alt_title/xenopaleontologist, JOB_ALT_ANOMALIST = /datum/alt_title/anomalist, JOB_ALT_PHORON_RESEARCHER = /datum/alt_title/phoron_research,
						JOB_ALT_GAS_PHYSICIST = /datum/alt_title/gas_physicist, JOB_ALT_CIRCUIT_DESIGNER = /datum/alt_title/circuit_designer, JOB_ALT_CIRCUIT_PROGRAMMER = /datum/alt_title/circuit_programmer)

/datum/job/scientist/get_request_reasons()
	return list("Assembling expedition team")

// Scientist Alt Titles
/datum/alt_title/xenoarch
	title = JOB_ALT_XENOARCHAEOLOGIST
	title_blurb = "A " + JOB_ALT_XENOARCHAEOLOGIST + " enters digsites in search of artifacts of alien origin. These digsites are frequently in vacuum or other inhospitable \
					locations, and as such a " + JOB_ALT_XENOARCHAEOLOGIST + " should be prepared to handle hostile evironmental conditions."

/datum/alt_title/anomalist
	title = JOB_ALT_ANOMALIST
	title_blurb = "An " + JOB_ALT_ANOMALIST + " is a " + JOB_SCIENTIST + " whose expertise is analyzing alien artifacts. They are familar with the most common methods of testing artifact \
					function. They work closely with " + JOB_ALT_XENOARCHAEOLOGIST + "s, or Miners, if either role is present."

/datum/alt_title/phoron_research
	title = JOB_ALT_PHORON_RESEARCHER
	title_blurb = "A " + JOB_ALT_PHORON_RESEARCHER + " is a specialist in the practical applications of phoron, and has knowledge of its practical uses and dangers. \
					Many " + JOB_ALT_PHORON_RESEARCHER + "s are interested in the combustability and explosive properties of gaseous phoron, as well as the specific hazards \
					of working with the substance in that state."

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

//////////////////////////////////
//			Xenobiologist
//////////////////////////////////
/datum/job/xenobiologist
	title = JOB_XENOBIOLOGIST
	flag = XENOBIOLOGIST
	departments = list(DEPARTMENT_RESEARCH)
	department_flag = MEDSCI
	faction = FACTION_STATION
	total_positions = 3
	spawn_positions = 3
	pto_type = PTO_SCIENCE
	supervisors = "the " + JOB_RESEARCH_DIRECTOR
	selection_color = "#633D63"
	economic_modifier = 7
	access = list(access_robotics, access_tox, access_tox_storage, access_research, access_xenobiology, access_hydroponics)
	minimal_access = list(access_research, access_xenobiology, access_hydroponics, access_tox_storage)
	banned_job_species = list("digital")

	minimal_player_age = 14
	min_age_by_species = list(SPECIES_PROMETHEAN = 2)

	outfit_type = /decl/hierarchy/outfit/job/science/xenobiologist
	job_description = "A " + JOB_XENOBIOLOGIST + " studies esoteric lifeforms, usually in the relative safety of their lab. They attempt to find ways to benefit \
						from the byproducts of these lifeforms, and their main subject at present is the Giant Slime."

	alt_titles = list(JOB_ALT_XENOZOOLOGIST = /datum/alt_title/xenozoologist, JOB_ALT_XENOANTHROPOLOGIST = /datum/alt_title/xenoanthropologist)

// Xenobiologist Alt Titles
/datum/alt_title/xenobot
	title = JOB_XENOBOTANIST
	title_blurb = "A " + JOB_XENOBOTANIST + " grows and cares for a variety of abnormal, custom made, and frequently dangerous plant life. When the products of these plants \
					is both safe and beneficial to the station, they may choose to introduce it to the rest of the crew."

/datum/alt_title/xenozoologist
	title = JOB_ALT_XENOZOOLOGIST

/datum/alt_title/xenoanthropologist
	title = JOB_ALT_XENOANTHROPOLOGIST
	title_blurb = JOB_ALT_XENOANTHROPOLOGIST + " still heavily focuses their study on alien lifeforms, but their specialty leans more towards fellow sapient beings than simple animals."

//////////////////////////////////
//			Roboticist
//////////////////////////////////
/datum/job/roboticist
	title = JOB_ROBOTICIST
	flag = ROBOTICIST
	departments = list(DEPARTMENT_RESEARCH)
	department_flag = MEDSCI
	faction = FACTION_STATION
	total_positions = 3
	spawn_positions = 2
	pto_type = PTO_SCIENCE
	supervisors = "the " + JOB_RESEARCH_DIRECTOR
	selection_color = "#633D63"
	economic_modifier = 5
	access = list(access_robotics, access_tox, access_tox_storage, access_tech_storage, access_morgue, access_research) //As a job that handles so many corpses, it makes sense for them to have morgue access.
	minimal_access = list(access_robotics, access_tech_storage, access_morgue, access_research) //As a job that handles so many corpses, it makes sense for them to have morgue access.
	minimal_player_age = 7
	min_age_by_species = list(SPECIES_PROMETHEAN = 2)
	banned_job_species = list("digital")

	outfit_type = /decl/hierarchy/outfit/job/science/roboticist
	job_description = "A " + JOB_ROBOTICIST + " maintains and repairs the station's synthetics, including crew with prosthetic limbs. \
						They can also assist the station by producing simple robots and even pilotable exosuits."
	alt_titles = list(
			JOB_ALT_ASSEMBLY_TECHNICIAN = /datum/alt_title/assembly_tech,
			JOB_ALT_BIOMECHANICAL_ENGINEER = /datum/alt_title/biomech,
			JOB_ALT_MECHATRONIC_ENGINEER = /datum/alt_title/mech_tech,
		JOB_ALT_SOFTWARE_ENGINEER = /datum/alt_title/software_engi)

/datum/job/roboticist/get_request_reasons()
	return list("Repairs needed")

// Roboticist Alt Titles
/datum/alt_title/biomech
	title = JOB_ALT_BIOMECHANICAL_ENGINEER
	title_blurb = "A " + JOB_ALT_BIOMECHANICAL_ENGINEER + " primarily works on prosthetics, and the organic parts attached to them. They may have some \
					knowledge of the relatively simple surgical procedures used in making cyborgs and attaching prosthesis."

/datum/alt_title/mech_tech
	title = JOB_ALT_MECHATRONIC_ENGINEER
	title_blurb = "A " + JOB_ALT_MECHATRONIC_ENGINEER + " focuses on the construction and maintenance of Exosuits, and should be well versed in their use. \
					They may also be called upon to work on synthetics and prosthetics, if needed."

/datum/alt_title/software_engi
	title = JOB_ALT_SOFTWARE_ENGINEER
	title_blurb = "A " + JOB_ALT_SOFTWARE_ENGINEER + " specializes in working with software and firmware. They also often deal with integrated circuits."

/datum/alt_title/assembly_tech
	title = JOB_ALT_ASSEMBLY_TECHNICIAN

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