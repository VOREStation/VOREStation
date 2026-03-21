/*
Event Collector Admin Commands
*/

ADMIN_VERB_AND_CONTEXT_MENU(modify_event_collector, R_ADMIN, "Configure Collector", "Configure Event Collector.", ADMIN_CATEGORY_FUN_EVENT_KIT, obj/structure/event_collector/target in GLOB.event_collectors)
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

	to_chat(user, msg)


	var/list/options = list(
		"Cancel",
		"Start New Recipe",
		"Clear Current Recipe",
		"Force Clear Blockers"
	)

	var/option = tgui_input_list(user, "What Would You Like To Do?", "Event Collector",options,"Cancel")
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

ADMIN_VERB_AND_CONTEXT_MENU(induce_malfunction, R_ADMIN, "Toggle Malfunction State", "Configure Collector Blocker.", ADMIN_CATEGORY_FUN_EVENT_KIT, obj/structure/event_collector_blocker/target in GLOB.event_collector_blockers)
	if(target.block_amount)
		target.fix()
		return

	target.induce_failure()
