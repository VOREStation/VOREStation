
GLOBAL_LIST(department_goals)
GLOBAL_LIST(active_department_goals)

/hook/startup/proc/initializeDepartmentGoals()
	GLOB.department_goals = list(GOAL_GENERAL, GOAL_MEDICAL, GOAL_SECURITY, GOAL_ENGINEERING, GOAL_CARGO, GOAL_RESEARCH)
	GLOB.active_department_goals = list(GOAL_GENERAL, GOAL_MEDICAL, GOAL_SECURITY, GOAL_ENGINEERING, GOAL_CARGO, GOAL_RESEARCH)

	for(var/category in GLOB.department_goals)
		GLOB.department_goals[category] = list()

		for(var/subtype in subtypesof(/datum/goal))
			var/datum/goal/SG = new subtype()

			if(SG.name == "goal")
				continue

			if(SG.category == category)
				GLOB.department_goals[category] |= SG

	for(var/category in GLOB.active_department_goals)
		GLOB.active_department_goals[category] = list()
		var/list/cat_goals = GLOB.department_goals[category]

		var/goal_count = rand(2,4)

		for(var/count = 1 to goal_count)
			var/datum/goal/G

			if(LAZYLEN(cat_goals))
				G = pick(cat_goals)

			if(G)
				G.active_goal = TRUE
				cat_goals -= G

				GLOB.active_department_goals[category] |= G
	return 1

/hook/roundend/proc/checkDepartmentGoals()
	for(var/category in GLOB.active_department_goals)
		var/list/cat_goals = GLOB.active_department_goals[category]

		to_world(span_world("[category]"))

		if(!LAZYLEN(cat_goals))
			to_world(span_filter_system("There were no assigned goals!"))

		else
			for(var/datum/goal/G in cat_goals)
				var/success = G.check_completion()
				to_world(span_filter_system("[success ? span_notice("[G.name]") : span_warning("[G.name]")]"))
				to_world(span_filter_system("[G.goal_text]"))
	return 1

/datum/goal
	var/name = "goal"

	var/goal_text = "Do nothing! Congratulations."

	var/active_goal = FALSE

	var/category = GOAL_GENERAL

/datum/goal/proc/check_completion()
	return FALSE

/datum/goal/common
	name = "goal"

	goal_text = "Congratulations, you still do nothing."

/datum/goal/medical
	name = "goal"

	goal_text = "Congratulations, you still do nothing."
	category = GOAL_MEDICAL

/datum/goal/security
	name = "goal"

	goal_text = "Congratulations, you still do nothing."
	category = GOAL_SECURITY

/datum/goal/engineering
	name = "goal"

	goal_text = "Congratulations, you still do nothing."
	category = GOAL_ENGINEERING

/datum/goal/cargo
	name = "goal"

	goal_text = "Congratulations, you still do nothing."
	category = GOAL_CARGO

/datum/goal/research
	name = "goal"

	goal_text = "Congratulations, you still do nothing."
	category = GOAL_RESEARCH
