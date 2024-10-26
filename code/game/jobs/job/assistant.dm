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
