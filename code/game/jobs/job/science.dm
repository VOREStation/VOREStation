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
			            access_tox_storage, access_teleporter, access_sec_doors,
			            access_research, access_robotics, access_xenobiology, access_ai_upload, access_tech_storage,
			            access_RC_announce, access_keycard_auth, access_tcomsat, access_gateway, access_xenoarch, access_network)
	minimal_access = list(access_rd, access_heads, access_tox, access_genetics, access_morgue,
			            access_tox_storage, access_teleporter, access_sec_doors,
			            access_research, access_robotics, access_xenobiology, access_ai_upload, access_tech_storage,
			            access_RC_announce, access_keycard_auth, access_tcomsat, access_gateway, access_xenoarch, access_network)

	minimum_character_age = 25
	minimal_player_age = 14
	min_age_by_species = list(SPECIES_UNATHI = 70, "mechanical" = 10, SPECIES_HUMAN_VATBORN = 14)
	ideal_character_age = 50
	ideal_age_by_species = list(SPECIES_UNATHI = 140, "mechanical" = 20, SPECIES_HUMAN_VATBORN = 20)
	banned_job_species = list(SPECIES_TESHARI, SPECIES_DIONA, SPECIES_PROMETHEAN, SPECIES_ZADDAT, "digital")

	outfit_type = /decl/hierarchy/outfit/job/science/rd
	job_description = "The " + JOB_RESEARCH_DIRECTOR + " manages and maintains the Research department. They are required to ensure the safety of the entire crew, \
						at least with regards to anything occurring in the Research department, and to inform the crew of any disruptions that \
						might originate from Research. The " + JOB_RESEARCH_DIRECTOR + " often has at least passing knowledge of most of the Research department, but \
						are encouraged to allow their staff to perform their own duties."
	alt_titles = list("Research Supervisor" = /datum/alt_title/research_supervisor)


// " + JOB_RESEARCH_DIRECTOR + " Alt Titles
/datum/alt_title/research_supervisor
	title = "Research Supervisor"

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
	spawn_positions = 3
	supervisors = "the " + JOB_RESEARCH_DIRECTOR
	selection_color = "#633D63"
	economic_modifier = 7
	access = list(access_robotics, access_tox, access_tox_storage, access_research, access_xenobiology, access_xenoarch)
	minimal_access = list(access_tox, access_tox_storage, access_research, access_xenoarch)
	min_age_by_species = list(SPECIES_PROMETHEAN = 2)
	banned_job_species = list("digital")

	minimal_player_age = 14

	outfit_type = /decl/hierarchy/outfit/job/science/scientist
	job_description = "A " + JOB_SCIENTIST + " is a generalist working in the Research department, with general knowledge of the scientific process, as well as \
						the principles and requirements of Research and Development. They may also formulate experiments of their own devising, if \
						they find an appropriate topic."
	alt_titles = list("Xenoarchaeologist" = /datum/alt_title/xenoarch, "Anomalist" = /datum/alt_title/anomalist, \
						"Phoron Researcher" = /datum/alt_title/phoron_research)

// Scientist Alt Titles
/datum/alt_title/xenoarch
	title = "Xenoarchaeologist"
	title_blurb = "A Xenoarchaeologist enters digsites in search of artifacts of alien origin. These digsites are frequently in vacuum or other inhospitable \
					locations, and as such a Xenoarchaeologist should be prepared to handle hostile evironmental conditions."

/datum/alt_title/anomalist
	title = "Anomalist"
	title_blurb = "An Anomalist is a " + JOB_SCIENTIST + " whose expertise is analyzing alien artifacts. They are familar with the most common methods of testing artifact \
					function. They work closely with Xenoarchaeologists, or Miners, if either role is present."

/datum/alt_title/phoron_research
	title = "Phoron Researcher"
	title_blurb = "A Phoron Researcher is a specialist in the practical applications of phoron, and has knowledge of its practical uses and dangers. \
					Many Phoron Researchers are interested in the combustability and explosive properties of gaseous phoron, as well as the specific hazards \
					of working with the substance in that state."

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
	spawn_positions = 2
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
/*VR edit start
	alt_titles = list(JOB_XENOBOTANIST = /datum/alt_title/xenobot)

 Xenibiologist Alt Titles
/datum/alt_title/xenobot
	title = JOB_XENOBOTANIST
	title_blurb = "A " + JOB_XENOBOTANIST + " grows and cares for a variety of abnormal, custom made, and frequently dangerous plant life. When the products of these plants \
					is both safe and beneficial to the station, they may choose to introduce it to the rest of the crew."
VR edit end*/

//////////////////////////////////
//			Roboticist
//////////////////////////////////
/datum/job/roboticist
	title = JOB_ROBOTICIST
	flag = ROBOTICIST
	departments = list(DEPARTMENT_RESEARCH)
	department_flag = MEDSCI
	faction = FACTION_STATION
	total_positions = 2
	spawn_positions = 2
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
	alt_titles = list("Biomechanical Engineer" = /datum/alt_title/biomech, "Mechatronic Engineer" = /datum/alt_title/mech_tech)

// Roboticist Alt Titles
/datum/alt_title/biomech
	title = "Biomechanical Engineer"
	title_blurb = "A Biomechanical Engineer primarily works on prosthetics, and the organic parts attached to them. They may have some \
					knowledge of the relatively simple surgical procedures used in making cyborgs and attaching prosthesis."

/datum/alt_title/mech_tech
	title = "Mechatronic Engineer"
	title_blurb = "A Mechatronic Engineer focuses on the construction and maintenance of Exosuits, and should be well versed in their use. \
					They may also be called upon to work on synthetics and prosthetics, if needed."
