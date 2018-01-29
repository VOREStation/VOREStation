/datum/job/assistant
	title = "Intern"
	flag = INTERN
	department = "Civilian"
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = "absolutely everyone"
	selection_color = "#515151"
	economic_modifier = 2
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()
	outfit_type = /decl/hierarchy/outfit/job/assistant
	alt_titles = list("Engineering Intern","Medical Intern","Research Intern","Security Intern","Cargo Intern") //VOREStation Edit
//VOREStation Add
/datum/job/assistant/New()
	..()
	total_positions = config.limit_interns
	spawn_positions = config.limit_interns
//VOREStation Add End

/datum/job/assistant/get_access()
	if(config.assistant_maint)
		return list(access_maint_tunnels)
	else
		return list()

// VOREStation Add
/datum/job/visitor
	title = "Visitor"
	flag = ASSISTANT
	department = "Civilian"
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = "absolutely everyone"
	selection_color = "#515151"
	economic_modifier = 1
	access = list()
	minimal_access = list()
	outfit_type = /decl/hierarchy/outfit/job/assistant
	alt_titles = list("Test Subject")
//VOREStation Add
/datum/job/visitor/New()
	..()
	total_positions = config.limit_visitors
	spawn_positions = config.limit_visitors
//VOREStation Add End

// VOREStation Add End