//////////////////////////////////
//			Assistant
//////////////////////////////////
/datum/job/assistant
	title = JOB_ALT_ASSISTANT
	flag = ASSISTANT
	departments = list(DEPARTMENT_CIVILIAN)
	sorting_order = -1
	department_flag = CIVILIAN
	faction = FACTION_STATION
	total_positions = -1
	spawn_positions = -1
	supervisors = "absolutely everyone"
	selection_color = "#515151"
	economic_modifier = 1
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()

	outfit_type = /decl/hierarchy/outfit/job/assistant
	job_description = "An Assistant does whatever is requested of them. Though they are part of the crew, they have no real authority."
/*	alt_titles = list(JOB_ALT_TECHNICAL_ASSISTANT = /datum/alt_title/tech_assist,
						JOB_ALT_MEDICAL_INTERN= /datum/alt_title/med_intern, JOB_ALT_RESEARCH_ASSISTANT = /datum/alt_title/research_assist,
						JOB_ALT_VISITOR = /datum/alt_title/visitor)
	)	*/	//VOREStation Removal: no alt-titles for visitors

/datum/job/assistant/get_access()
	if(CONFIG_GET(flag/assistant_maint))
		return list(access_maint_tunnels)
	else
		return list()

// Assistant Alt Titles
/datum/alt_title/tech_assist
	title = JOB_ALT_TECHNICAL_ASSISTANT
	title_blurb = "A " + JOB_ALT_TECHNICAL_ASSISTANT + " attempts to provide whatever the Engineering department needs. They are not proper Engineers, and are \
					often in training to become an " + JOB_ENGINEER + ". A " + JOB_ALT_TECHNICAL_ASSISTANT + " has no real authority."

/datum/alt_title/med_intern
	title = JOB_ALT_MEDICAL_INTERN
	title_blurb = "A " + JOB_ALT_MEDICAL_INTERN + " attempts to provide whatever the Medical department needs. They are frequently asked to pay attention to \
					the suit sensors console. A " + JOB_ALT_MEDICAL_INTERN + " has no real authority."

/datum/alt_title/research_assist
	title = JOB_ALT_RESEARCH_ASSISTANT
	title_blurb = "A " + JOB_ALT_RESEARCH_ASSISTANT + " attempts to assist anyone working in the Research department. They are expected to follow the instruction \
					of proper Research staff, as it is frequently a matter of safety. A " + JOB_ALT_RESEARCH_ASSISTANT + " has no real authority."

/datum/alt_title/visitor
	title = JOB_ALT_VISITOR
	title_blurb = "A " + JOB_ALT_VISITOR + " is anyone who has arrived on the station but does not have a specific job to do. Many off-duty crewmembers \
					who care to make use of the station's facilities arrive as Visitors. Properly registered Vistors are considered \
					to be part of the crew for most if not all purposes, but they have no real authority."
	title_outfit = /decl/hierarchy/outfit/job/assistant/visitor

/datum/alt_title/resident		// Just in case it makes a comeback
	title = JOB_ALT_RESIDENT
	title_blurb = "A " + JOB_ALT_RESIDENT + " is an individual who resides on the station, frequently in a different part of the station than what is seen. \
					They are considered to be part of the crew for most purposes, but have no real authority."
	title_outfit = /decl/hierarchy/outfit/job/assistant/resident

//////////////////////////////////
//		Intern
//////////////////////////////////

/datum/job/intern
	title = JOB_INTERN
	flag = INTERN
	departments = list(DEPARTMENT_CIVILIAN)
	department_flag = ENGSEC // Ran out of bits
	faction = FACTION_STATION
	total_positions = -1
	spawn_positions = -1
	supervisors = "the staff from the department you're interning in"
	selection_color = "#555555"
	economic_modifier = 2
	access = list()			//See /datum/job/intern/get_access()
	minimal_access = list()	//See /datum/job/intern/get_access()
	outfit_type = /decl/hierarchy/outfit/job/assistant/intern
	alt_titles = list(JOB_ALT_APPRENTICE_ENGINEER = /datum/alt_title/intern_eng,
					  JOB_ALT_MEDICAL_INTERN = /datum/alt_title/intern_med,
					  JOB_ALT_RESEARCH_INTERN = /datum/alt_title/intern_sci,
					  JOB_ALT_SECURITY_CADET = /datum/alt_title/intern_sec,
					  JOB_ALT_JR_CARGO_TECH = /datum/alt_title/intern_crg,
					  JOB_ALT_SERVER = /datum/alt_title/server,
					  JOB_ALT_ASSISTANT = /datum/alt_title/assistant)
	job_description = "An " + JOB_INTERN + " does whatever is requested of them, often doing so in process of learning \
						another job. Though they are part of the crew, they have no real authority."
	timeoff_factor = 0 // Interns, noh
	requestable = FALSE

/datum/alt_title/intern_eng
	title = JOB_ALT_APPRENTICE_ENGINEER
	title_blurb = "An " + JOB_ALT_APPRENTICE_ENGINEER + " attempts to provide whatever the Engineering department needs. They are not proper Engineers, and are \
					often in training to become an Engineer. An " + JOB_ALT_APPRENTICE_ENGINEER + " has no real authority."
	title_outfit = /decl/hierarchy/outfit/job/assistant/engineer

/datum/alt_title/intern_med
	title = JOB_ALT_MEDICAL_INTERN
	title_blurb = "A " + JOB_ALT_MEDICAL_INTERN + " attempts to provide whatever the Medical department needs. They are not proper Doctors, and are \
					often in training to become a Doctor. A " + JOB_ALT_MEDICAL_INTERN + " has no real authority."
	title_outfit = /decl/hierarchy/outfit/job/assistant/medic

/datum/alt_title/intern_sci
	title = JOB_ALT_RESEARCH_INTERN
	title_blurb = "A " + JOB_ALT_RESEARCH_INTERN + " attempts to provide whatever the Research department needs. They are not proper " + JOB_SCIENTIST + "s, and are \
					often in training to become a " + JOB_SCIENTIST + ". A " + JOB_ALT_RESEARCH_INTERN + " has no real authority."
	title_outfit = /decl/hierarchy/outfit/job/assistant/scientist

/datum/alt_title/intern_sec
	title = JOB_ALT_SECURITY_CADET
	title_blurb = "A " + JOB_ALT_SECURITY_CADET + " attempts to provide whatever the Security department needs. They are not proper Officers, and are \
					often in training to become an Officer. A " + JOB_ALT_SECURITY_CADET + " has no real authority."
	title_outfit = /decl/hierarchy/outfit/job/assistant/officer

/datum/alt_title/intern_crg
	title = JOB_ALT_JR_CARGO_TECH
	title_blurb = "A " + JOB_ALT_JR_CARGO_TECH + " attempts to provide whatever the Cargo department needs. They are not proper Cargo Technicians, and are \
					often in training to become a " + JOB_CARGO_TECHNICIAN + ". A " + JOB_ALT_JR_CARGO_TECH + " has no real authority."
	title_outfit = /decl/hierarchy/outfit/job/assistant/cargo
/*
/datum/alt_title/intern_exp
	title = "Jr. " + JOB_EXPLORER + ""
	title_blurb = "A Jr. " + JOB_EXPLORER + " attempts to provide whatever the Exploration department needs. They are not proper " + JOB_EXPLORER + "s, and are \
					often in training to become an " + JOB_EXPLORER + ". A Jr. " + JOB_EXPLORER + " has no real authority."
	title_outfit = /decl/hierarchy/outfit/job/assistant/explorer
*/
/datum/alt_title/server
	title = JOB_ALT_SERVER
	title_blurb = "A " + JOB_ALT_SERVER + " helps out kitchen and diner staff with various tasks, primarily food delivery. A " + JOB_ALT_SERVER + " has no real authority."
	title_outfit = /decl/hierarchy/outfit/job/service/server

/datum/alt_title/assistant
	title = JOB_ALT_ASSISTANT
	title_blurb = "An " + JOB_ALT_ASSISTANT + " helps out wherever they might be needed. They have no authority, but can volunteer to help if help is needed."
	title_outfit = /decl/hierarchy/outfit/job/service/server

/datum/job/intern/New()
	..()
	if(config)
		total_positions = CONFIG_GET(number/limit_interns)
		spawn_positions = CONFIG_GET(number/limit_interns)

/datum/job/intern/get_access()
	if(CONFIG_GET(flag/assistant_maint))
		return list(access_maint_tunnels)
	else
		return list()

//////////////////////////////////
//		Visitor
//////////////////////////////////

/datum/job/assistant		// Visitor
	title = JOB_ALT_VISITOR
	supervisors = "nobody! You don't work here"
	job_description = "A " + JOB_ALT_VISITOR + " is just there to visit the place. They have no real authority or responsibility."
	timeoff_factor = 0
	requestable = FALSE
	alt_titles = list("Guest" = /datum/alt_title/guest, "Traveler" = /datum/alt_title/traveler)

/datum/job/assistant/New()
	..()
	if(config)
		total_positions = CONFIG_GET(number/limit_visitors)
		spawn_positions = CONFIG_GET(number/limit_visitors)

/datum/job/assistant/get_access()
	return list()

/datum/alt_title/guest
	title = "Guest"

/datum/alt_title/traveler
	title = "Traveler"
