/mob/observer/dead/verb/backup_ping()
	set category = "Ghost.Join"
	set name = "Notify Transcore"
	set desc = "If your past-due backup notification was missed or ignored, you can use this to send a new one."

	if(!mind)
		to_chat(src,span_warning("Your ghost is missing game values that allow this functionality, sorry."))
		return
	var/datum/transcore_db/db = SStranscore.db_by_mind_name(mind.name)
	if(db)
		var/datum/transhuman/mind_record/record = db.backed_up[src.mind.name]
		if(!(record.dead_state == MR_DEAD))
			if((world.time - timeofdeath ) > 5 MINUTES)	//Allows notify transcore to be used if you have an entry but for some reason weren't marked as dead
				record.dead_state = MR_DEAD				//Such as if you got scanned but didn't take an implant. It's a little funky, but I mean, you got scanned
				db.notify(record)						//So you probably will want to let someone know if you die.
				record.last_notification = world.time
				to_chat(src, span_notice("New notification has been sent."))
			else
				to_chat(src, span_warning("Your backup is not past-due yet."))
		else if((world.time - record.last_notification) < 5 MINUTES)
			to_chat(src, span_warning("Too little time has passed since your last notification."))
		else
			db.notify(record)
			record.last_notification = world.time
			to_chat(src, span_notice("New notification has been sent."))
	else
		to_chat(src,span_warning("No backup record could be found, sorry."))
/*
/mob/observer/dead/verb/backup_delay()
	set category = "Ghost.Settings"
	set name = "Cancel Transcore Notification"
	set desc = "You can use this to avoid automatic backup notification happening. Manual notification can still be used."

	if(!mind)
		to_chat(src,span_warning("Your ghost is missing game values that allow this functionality, sorry."))
		return
	var/datum/transcore_db/db = SStranscore.db_by_mind_name(mind.name)
	if(db)
		var/datum/transhuman/mind_record/record = db.backed_up[src.mind.name]
		if(record.dead_state == MR_DEAD || !(record.do_notify))
			to_chat(src, span_warning("The notification has already happened or been delayed."))
		else
			record.do_notify = FALSE
			to_chat(src, span_notice("Overdue mind backup notification delayed successfully."))
	else
		to_chat(src,span_warning("No backup record could be found, sorry."))
*/
/mob/observer/dead/verb/findghostpod() //Moves the ghost instead of just changing the ghosts's eye -Nodrak
	set category = "Ghost.Join"
	set name = "Ghost Spawn"
	set desc = "Open Ghost Spawn Menu"

	if(!isobserver(src)) //Make sure they're an observer!
		return

	if(selecting_ghostrole)
		return

	var/datum/tgui_module/ghost_spawn_menu/ui = new(src)
	ui.tgui_interact(src)

/mob/observer/dead/verb/findautoresleever()
	set category = "Ghost.Join"
	set name = "Find Auto Resleever"
	set desc = "Find a Auto Resleever"
	set popup_menu = FALSE

	if(!isobserver(src)) //Make sure they're an observer!
		return

	// Set up an assorted list of auto-resleevers using their area name as the key, (as there should only ever be one per area)
	var/list/autoresleevers = list()
	for(var/obj/machinery/transhuman/autoresleever/A in GLOB.active_autoresleevers)
		if(A.spawntype)
			continue
		else
			var/area/resleever_area = get_area(A)
			autoresleevers[resleever_area.name] = A

	var/obj/machinery/transhuman/autoresleever/chosen_resleever = null
	if(length(autoresleevers) > 1)
		// Prompt user to choose which one they wanna go to
		var/choice = tgui_input_list(src, "There are multiple auto-resleevers available! Choose one.", "Choose Auto-Resleever", autoresleevers)
		if(!choice)
			// well okay then :L
			return
		chosen_resleever = autoresleevers[choice]
	else
		// If there's less than one, just choose whatever one is available (if any)
		chosen_resleever = autoresleevers[pick(autoresleevers)]

	if(!chosen_resleever)
		to_chat(src, span_warning("There appears to be no auto-resleevers available."))
		return
	var/L = get_turf(chosen_resleever)
	if(!L)
		to_chat(src, span_warning("There appears to be something wrong with this auto-resleever, try again."))
		return

	forceMove(L)
