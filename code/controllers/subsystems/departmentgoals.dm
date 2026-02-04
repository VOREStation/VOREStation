SUBSYSTEM_DEF(departmentgoals)
	name = "Department Goals"
	wait = 5 SECONDS

	dependencies = list(
		/datum/controller/subsystem/mobs
	)
	runlevels = RUNLEVEL_GAME

	VAR_PRIVATE/min_goals = 2
	VAR_PRIVATE/max_goals = 5
	VAR_PRIVATE/list/currentrun = list()
	var/list/active_department_goals = list() // List of goal datums that were assigned on round start
	VAR_PRIVATE/completed_goals = 0

/datum/controller/subsystem/departmentgoals/Initialize()
	for(var/category in list(GOAL_GENERAL, GOAL_MEDICAL, GOAL_SECURITY, GOAL_ENGINEERING, GOAL_CARGO, GOAL_RESEARCH))
		active_department_goals[category] = list()

	// Get the pool of available goals
	var/list/all_goal_types = list()
	for(var/datum/goal/checked_goal as anything in subtypesof(/datum/goal))
		if(checked_goal.name == /datum/goal::name || !checked_goal.enabled)
			continue
		all_goal_types += checked_goal

	// Pick random goals
	for(var/count = 1 to rand(min_goals, max_goals))
		var/new_path = pick(all_goal_types)
		all_goal_types -= new_path

		var/datum/goal/new_goal = new new_path()
		active_department_goals[new_goal.category] += new_goal

	RegisterSignal(SSdcs, COMSIG_GLOB_ROUND_START, PROC_REF(handle_round_start))
	RegisterSignal(SSdcs, COMSIG_GLOB_ROUND_END, PROC_REF(handle_round_end))
	return SS_INIT_SUCCESS

/datum/controller/subsystem/departmentgoals/Shutdown()
	UnregisterSignal(SSdcs, COMSIG_GLOB_ROUND_START)
	UnregisterSignal(SSdcs, COMSIG_GLOB_ROUND_END)
	. = ..()

/datum/controller/subsystem/departmentgoals/stat_entry(msg)
	msg = "G: [active_department_goals.len] | F: [completed_goals] | Cr: [currentrun.len]"
	return ..()

/datum/controller/subsystem/departmentgoals/fire()
	// If no queue exists, make one and start it
	if(!currentrun.len)
		for(var/category in active_department_goals)
			var/list/dept_goals = active_department_goals[category]
			for(var/datum/goal/dept_goal in dept_goals)
				currentrun += dept_goal
			completed_goals = 0
	// Solve the current queue until empty, over multiple ticks if needed
	while(currentrun.len)
		var/datum/goal/dept_goal = currentrun[1]
		completed_goals += dept_goal.check_completion()
		currentrun -= dept_goal
		if(MC_TICK_CHECK)
			return

///////////////////////////////////////////////////////////////////////////////////////////////
// Signals for roundstart announcements and round end praise
///////////////////////////////////////////////////////////////////////////////////////////////
/datum/controller/subsystem/departmentgoals/proc/handle_round_start()
	SIGNAL_HANDLER
	// Lets admins set somes stuff quickly
	addtimer(CALLBACK(src, PROC_REF(announce_goals)), 30 SECONDS)

/datum/controller/subsystem/departmentgoals/proc/announce_goals()
	var/list/all_goals = list()
	for(var/category in active_department_goals)
		var/list/cat_goals = active_department_goals[category]
		if(!cat_goals.len)
			continue
		all_goals += cat_goals

	if(!all_goals.len)
		command_announcement.Announce("There are no department goals for this shift.", "Station Resource Department")
		return
	command_announcement.Announce("Department goals have been updated for this shift. (Check your IC tab's \"Check Round Goals\" for details!)", "Station Resource Department")

/datum/controller/subsystem/departmentgoals/proc/handle_round_end()
	SIGNAL_HANDLER
	if(!active_department_goals.len)
		return
	show_goal_status_to(world)

/datum/controller/subsystem/departmentgoals/proc/show_goal_status_to(user)
	to_chat(user, span_notice(span_world("Department goals are:")))

	var/any_goals = FALSE
	for(var/category in active_department_goals)
		var/list/cat_goals = active_department_goals[category]
		if(!cat_goals.len)
			continue

		to_chat(user, span_filter_system(span_bold("[category]:")))
		for(var/datum/goal/G in cat_goals)
			to_chat(user, span_filter_system("[G.get_completed() ? span_notice("[G.name]") : span_danger("[G.name]")]: [span_filter_system("[G.goal_text]")] [G.progress_string()]"))
			any_goals = TRUE

	if(!any_goals)
		to_chat(user, span_info("There are no station goals."))


/// Debugging only, should probably leave commented out as well. Adds one of each goal type to the active list
/datum/controller/subsystem/departmentgoals/proc/debug_remove_all_goals()
	for(var/category in active_department_goals)
		var/list/active_goals_sublist = active_department_goals[category]
		QDEL_LIST(active_goals_sublist)

/datum/controller/subsystem/departmentgoals/proc/debug_add_all_goals()
	for(var/subtype in subtypesof(/datum/goal))
		var/datum/goal/goal_template = subtype
		if(goal_template.name == /datum/goal::name)
			continue
		var/list/active_goals_sublist = active_department_goals[goal_template.category]
		active_goals_sublist += new goal_template()


// Move these helpers when upported or make a tgui instead
/mob/verb/check_round_goals()
	set name = "Check Round Goals"
	set desc = "View currently active round goals, and if they have been completed."
	set category = "IC.Notes"

	SSdepartmentgoals.show_goal_status_to(usr)

/datum/admins/proc/add_department_goal()
	set category = "Debug.Events"
	set name = "Add Department Goal"
	set desc = "Adds a goal for the station to reach."

	if(!check_rights(R_EVENT))
		return
	var/choice = tgui_input_list(usr,"Choose goal to add:","New Goal", subtypesof(/datum/goal))
	if(!choice)
		return

	var/datum/goal/template = choice
	var/list/dept_goals = SSdepartmentgoals.active_department_goals[template.category]
	dept_goals += new template()
	log_admin("[key_name(usr)] has added a department goal: [template.name].")

/datum/admins/proc/remove_department_goal()
	set category = "Debug.Events"
	set name = "Remove Department Goal"
	set desc = "Remove a goal from the station's current department goals."

	if(!check_rights(R_EVENT))
		return

	var/list/all_goals = list()
	for(var/category in SSdepartmentgoals.active_department_goals)
		all_goals += SSdepartmentgoals.active_department_goals[category]
	if(!all_goals.len)
		to_chat(usr, span_warning("There are no station goals."))
		return

	var/datum/goal/choice = tgui_input_list(usr,"Choose goal to remove:","Remove Goal", all_goals)
	if(!choice)
		return

	log_admin("[key_name(usr)] has removed the department goal: [choice].")
	SSdepartmentgoals.active_department_goals[choice.category] -= choice
	qdel(choice)
