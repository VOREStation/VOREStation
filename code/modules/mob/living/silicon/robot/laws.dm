/mob/living/silicon/robot/verb/cmd_show_laws()
	set category = "Abilities.Silicon"
	set name = "Show Laws"
	show_laws()

/mob/living/silicon/robot/show_laws(var/everyone = 0)
	laws_sanity_check()
	var/who

	if (everyone)
		who = world
	else
		who = src
	if(lawupdate)
		if (connected_ai)
			if(connected_ai.stat || connected_ai.control_disabled)
				to_chat(src, span_infoplain(span_bold("AI signal lost, unable to sync laws.")))

			else
				lawsync()
				photosync()
				to_chat(src, span_infoplain(span_bold("Laws synced with AI, be sure to note any changes.")))
				// TODO: Update to new antagonist system.
				if(mind && mind.special_role == "traitor" && mind.original == src)
					to_chat(src, span_infoplain(span_bold("Remember, your AI does NOT share or know about your law 0.")))
		else
			to_chat(src, span_infoplain(span_bold("No AI selected to sync laws with, disabling lawsync protocol.")))
			lawupdate = FALSE

	to_chat(who, span_infoplain(span_bold("Obey these laws:")))
	laws.show_laws(who)
	if(shell) //AI shell
		to_chat(who, span_infoplain(span_bold("Remember, you are an AI remotely controlling your shell, other AIs can be ignored.")))
	// TODO: Update to new antagonist system.
	else if(mind && (mind.special_role == "traitor" && mind.original == src) && connected_ai)
		to_chat(who, span_infoplain(span_bold("Remember, [connected_ai.name] is technically your master, but your objective comes first.")))
	else if(connected_ai)
		to_chat(who, span_infoplain(span_bold("Remember, [connected_ai.name] is your master, other AIs can be ignored.")))
	else if(emagged)
		to_chat(who, span_infoplain(span_bold("Remember, you are not required to listen to the AI.")))
	else
		to_chat(who, span_infoplain(span_bold("Remember, you are not bound to any AI, you are not required to listen to them.")))


/mob/living/silicon/robot/lawsync()
	laws_sanity_check()
	var/datum/ai_laws/master = connected_ai && lawupdate ? connected_ai.laws : null
	if (master)
		master.sync(src)
	..()
	return

/mob/living/silicon/robot/proc/robot_checklaws()
	set category = "Abilities.Silicon"
	set name = "State Laws"
	subsystem_law_manager()
