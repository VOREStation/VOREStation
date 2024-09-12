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
	alt_titles = list("Research Supervisor" = /datum/alt_title/research_supervisor, "Research Manager" = /datum/alt_title/research_manager,
						"Head of Development" = /datum/alt_title/head_of_development,"Head Scientist" = /datum/alt_title/head_scientist)

/datum/alt_title/research_manager
	title = "Research Manager"

/datum/alt_title/head_of_development
	title = "Head of Development"

/datum/alt_title/head_scientist
	title = "Head Scientist"

/datum/job/rd/get_request_reasons()
	return list("Repairs needed", "Training crew", "Assembling expedition team")


/datum/job/scientist
	spawn_positions = 5
	pto_type = PTO_SCIENCE
	alt_titles = list("Researcher" = /datum/alt_title/researcher, "Lab Assistant" = /datum/alt_title/lab_assistant, "Xenoarchaeologist" = /datum/alt_title/xenoarch,
						"Xenopaleontologist" = /datum/alt_title/xenopaleontologist, "Anomalist" = /datum/alt_title/anomalist, "Phoron Researcher" = /datum/alt_title/phoron_research,
						"Gas Physicist" = /datum/alt_title/gas_physicist, "Circuit Designer" = /datum/alt_title/circuit_designer, "Circuit Programmer" = /datum/alt_title/circuit_programmer)


	access = list(access_robotics, access_tox, access_tox_storage, access_research, access_xenobiology, access_xenoarch, access_xenobotany)
	minimal_access = list(access_tox, access_tox_storage, access_research, access_xenoarch)					// Unchanged (for now?), mostly here for reference

/datum/alt_title/researcher
	title = "Researcher"

/datum/alt_title/lab_assistant
	title = "Lab Assistant"
	title_blurb = "A Lab Assistant is a lower-level member of research staff, whose main purpose is to help scientists with their specialized work in more menial fashion, while also \
					learning the specializations in process."

/datum/alt_title/xenopaleontologist
	title = "Xenopaleontologist"
	title_blurb = "A Xenopaleontologist enters digsites in search of fossils and other ancient remants of alien life. These digsites are frequently in vacuum or other inhospitable \
					locations, and as such a Xenopaleontologist should be prepared to handle hostile evironmental conditions."

/datum/alt_title/gas_physicist
	title = "Gas Physicist"
	title_blurb = "A Gas Physicist is a specialist in various practical applications of gasses, but currently focuses their attention on phoron, and has knowledge of its practical uses and dangers. \
					Many Gas Physicists are interested in the combustability and explosive properties of gaseous phoron, as well as the specific hazards \
					of working with the substance in that state."

/datum/alt_title/circuit_designer
	title = "Circuit Designer"
	title_blurb = "A Circuit Designer is a Scientist whose expertise is working with integrated circuits. They are familar with the workings and programming of those devices. \
				   They work to create various useful devices using the capabilities of integrated circuitry."

/datum/alt_title/circuit_programmer
	title = "Circuit Programmer"
	title_blurb = "A Circuit Programmer is a Scientist whose expertise is working with integrated circuits. They are familar with the workings and programming of those devices. \
				   They work to create various useful devices using the capabilities of integrated circuitry."

/datum/job/scientist/get_request_reasons()
	return list("Assembling expedition team")

/datum/job/xenobiologist
	spawn_positions = 3
	pto_type = PTO_SCIENCE
	alt_titles = list("Xenozoologist" = /datum/alt_title/xenozoologist, "Xenoanthropologist" = /datum/alt_title/xenoanthropologist)

/datum/alt_title/xenozoologist
	title = "Xenozoologist"

/datum/alt_title/xenoanthropologist
	title = "Xenoanthropologist"
	title_blurb = "Xenoanthropologist still heavily focuses their study on alien lifeforms, but their specialty leans more towards fellow sapient beings than simple animals."


/datum/job/roboticist
	total_positions = 3
	pto_type = PTO_SCIENCE
	alt_titles = list("Assembly Technician" = /datum/alt_title/assembly_tech, "Biomechanical Engineer" = /datum/alt_title/biomech, "Mechatronic Engineer" = /datum/alt_title/mech_tech)

/datum/alt_title/assembly_tech
	title = "Assembly Technician"

/datum/job/roboticist/get_request_reasons()
	return list("Repairs needed")

//////////////////////////////////
//			Xenobotanist
//////////////////////////////////
/datum/job/xenobotanist
	title = "Xenobotanist"
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
	job_description = "A Xenobotanist grows and cares for a variety of abnormal, custom made, and frequently dangerous plant life. When the products of these plants \
					are both safe and beneficial to the station, they may choose to introduce it to the rest of the crew."
	alt_titles = list("Xenohydroponicist" = /datum/alt_title/xenohydroponicist, "Xenoflorist" = /datum/alt_title/xenoflorist)

/datum/alt_title/xenoflorist
	title = "Xenoflorist"

/datum/alt_title/xenohydroponicist
	title = "Xenohydroponicist"
