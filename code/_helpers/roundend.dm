/datum/controller/subsystem/ticker/proc/declare_completion(was_forced = END_ROUND_AS_NORMAL)
	set waitfor = FALSE

	for(var/datum/callback/roundend_callbacks as anything in round_end_events)
		roundend_callbacks.InvokeAsync()
	LAZYCLEARLIST(round_end_events)

	to_chat(world, span_filter_system("<BR><BR><BR><H1>The round has ended.</H1>"))
	log_game("The round has ended.")
	for(var/channel_tag in CONFIG_GET(str_list/channel_announce_end_game))
		send2chat(new /datum/tgs_message_content("[GLOB.round_id ? "Round [GLOB.round_id]" : "The round has"] just ended."), channel_tag)
	send2adminchat("Server", "Round just ended.")

	PlayerStats()
	var/extra_delay = mode.declare_completion()//To declare normal completion.
	RoundTrivia()

	//Ask the event manager to print round end information
	SSevents.RoundEnd()

	//Print a list of antagonists to the server log
	var/list/total_antagonists = list()
	//Look into all mobs in world, dead or alive
	for(var/datum/mind/Mind in minds)
		var/temprole = Mind.special_role
		if(temprole)							//if they are an antagonist of some sort.
			if(temprole in total_antagonists)	//If the role exists already, add the name to it
				total_antagonists[temprole] += ", [Mind.name]([Mind.key])"
			else
				total_antagonists.Add(temprole) //If the role doesnt exist in the list, create it and add the mob
				total_antagonists[temprole] += ": [Mind.name]([Mind.key])"

	//Now print them all into the log!
	log_game("Antagonists at round end were...")
	for(var/i in total_antagonists)
		log_game("[i]s[total_antagonists[i]].")

	SSdbcore.SetRoundEnd()

	ready_for_reboot = TRUE
	addtimer(CALLBACK(src, PROC_REF(standard_reboot)), 5 SECONDS + extra_delay)

/datum/controller/subsystem/ticker/proc/standard_reboot()
	if(ready_for_reboot)
		if(mode.station_was_nuked)
			Reboot("Station destroyed by Nuclear Device.", "nuke")
		else
			Reboot("Round ended.", "proper completion")
	else
		CRASH("Attempted standard reboot without ticker roundend completion")
