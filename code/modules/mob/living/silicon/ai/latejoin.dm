var/global/list/empty_playable_ai_cores = list()

/hook/roundstart/proc/spawn_empty_ai()
	for(var/obj/effect/landmark/start/S in landmarks_list)
		if(S.name != JOB_AI)
			continue
		if(locate(/mob/living) in S.loc)
			continue
		empty_playable_ai_cores += new /obj/structure/AIcore/deactivated(get_turf(S))

	return 1

/mob/living/silicon/ai/verb/store_core()
	set name = "Store Core"
	set category = "OOC.Game"
	set desc = "Enter intelligence storage. This is functionally equivalent to cryo or robotic storage, freeing up your job slot."

	if(ticker && ticker.mode && ticker.mode.name == "AI malfunction")
		to_chat(usr, span_danger("You cannot use this verb in malfunction. If you need to leave, please adminhelp."))
		return

	// Guard against misclicks, this isn't the sort of thing we want happening accidentally
	if(tgui_alert(usr, "WARNING: This will immediately empty your core and ghost you, removing your character from the round permanently (similar to cryo and robotic storage). Are you entirely sure you want to do this?", "Store Core", list("No", "Yes")) != "Yes")
		return

	// We warned you.
	empty_playable_ai_cores += new /obj/structure/AIcore/deactivated(loc)
	global_announcer.autosay("[src] has been moved to intelligence storage.", "Artificial Intelligence Oversight")

	//Handle job slot/tater cleanup.
	set_respawn_timer()
	clear_client()
