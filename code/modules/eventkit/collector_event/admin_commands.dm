/*
Event Collector Admin Commands
*/

/client/proc/modify_event_collector(var/obj/structure/event_collector/target in GLOB.event_collectors)
	set category = "Fun.Event Kit"
	set desc="Configure Event Collector"
	set name="Configure Collector"

	if(!check_rights(R_ADMIN))
		return

	var/msg = "---------------\n"
	if(target?.active_recipe?.len > 0)
		msg += " [target] has [target.active_recipe.len] left in its current recipe\n"
		for(var/i in target.active_recipe)
			msg += "* [i] \n"

	else
		msg += "[target] has no more required items! \n"

	if(target.calls_remaining > 0)
		msg += "[target] has [target.calls_remaining] progress to go! - unless stopped or slowed, this is about [(target.calls_remaining / 10 ) * 2] seconds! \n"

	var/blockers = target.get_blockers()

	if(blockers > 0)
		msg += "[target] has [blockers] things blocking/slowing it down! Anything more than 10 means it's stopped!"

	to_chat(usr,msg)


	var/list/options = list(
		"Cancel",
		"Start New Recipe",
		"Clear Current Recipe",
		"Force Clear Blockers"
	)

	var/option = tgui_input_list(usr, "What Would You Like To Do?", "Event Collector",options,"Cancel")
	switch(option)
		if("Cancel")
			return
		if("Start New Recipe")
			target.pick_new_recipe()
		if("Clear Current Recipe")
			target.active_recipe = list()
			target.awaiting_next_recipe = TRUE
			target.calls_remaining = 0

		if("Force Clear Blockers")
			if(islist(GLOB.event_collector_blockers[target.blocker_channel]))
				for(var/obj/structure/event_collector_blocker/tofix in GLOB.event_collector_blockers[target.blocker_channel])
					tofix.fix()

		if("Empty Stored Items")
			target.empty_items()

/client/proc/induce_malfunction(var/obj/structure/event_collector_blocker/target in GLOB.event_collector_blockers)
	set category = "Fun.Event Kit"
	set desc="Configure Collector Blocker"
	set name="Toggle Malfunction State"

	if(!check_rights(R_ADMIN))
		return

	if(target.block_amount)
		target.fix()

	else
		target.induce_failure()
