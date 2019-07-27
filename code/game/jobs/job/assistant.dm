//VOREStation Edit - Basically this whole file
/datum/job/intern
	title = "Intern"
	flag = INTERN
	department = "Civilian"
	department_flag = ENGSEC // VOREStation Edit - Ran out of bits
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = "the staff from the departmen you're interning in"
	selection_color = "#555555"
	economic_modifier = 2
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()
	outfit_type = /decl/hierarchy/outfit/job/assistant/intern
	alt_titles = list("Apprentice Engineer","Medical Intern","Lab Assistant","Security Cadet","Jr. Cargo Tech", "Jr. Explorer") //VOREStation Edit
	timeoff_factor = 0 //VOREStation Edit - Interns, noh

//VOREStation Add
/datum/job/intern/New()
	..()
	if(config)
		total_positions = config.limit_interns
		spawn_positions = config.limit_interns
//VOREStation Add End

// VOREStation Add
/datum/job/assistant
	title = USELESS_JOB
	flag = ASSISTANT
	department = "Civilian"
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = "nobody! You don't work here"
	selection_color = "#515151"
	economic_modifier = 1
	access = list()
	minimal_access = list()
	outfit_type = /decl/hierarchy/outfit/job/assistant
	timeoff_factor = 0
/datum/job/assistant/New()
	..()
	if(config)
		total_positions = config.limit_visitors
		spawn_positions = config.limit_visitors

/datum/job/assistant/get_access()
	if(config.assistant_maint)
		return list(access_maint_tunnels)
	else
		return list()
//VOREStation Add End
