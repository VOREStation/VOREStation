/datum/controller/subsystem/ticker/proc/declare_completion(was_forced = END_ROUND_AS_NORMAL)
	set waitfor = FALSE

	for(var/datum/callback/roundend_callbacks as anything in round_end_events)
		roundend_callbacks.InvokeAsync()
	LAZYCLEARLIST(round_end_events)

	to_chat(world, span_filter_system("<br><br><br><H1>A round of [mode.name] has ended!</H1>"))
	for(var/mob/Player in GLOB.player_list)
		if(Player.mind && !isnewplayer(Player))
			if(Player.stat != DEAD)
				var/turf/playerTurf = get_turf(Player)
				if(emergency_shuttle.departed && emergency_shuttle.evac)
					if(isNotAdminLevel(playerTurf.z))
						to_chat(Player, span_filter_system(span_blue(span_bold("You survived the round, but remained on [station_name()] as [Player.real_name]."))))
					else
						to_chat(Player, span_filter_system(span_green(span_bold("You managed to survive the events on [station_name()] as [Player.real_name]."))))
				else if(isAdminLevel(playerTurf.z))
					to_chat(Player, span_filter_system(span_green(span_bold("You successfully underwent crew transfer after events on [station_name()] as [Player.real_name]."))))
				else if(issilicon(Player))
					to_chat(Player, span_filter_system(span_green(span_bold("You remain operational after the events on [station_name()] as [Player.real_name]."))))
				else
					to_chat(Player, span_filter_system(span_blue(span_bold("You missed the crew transfer after the events on [station_name()] as [Player.real_name]."))))
			else
				if(isobserver(Player))
					var/mob/observer/dead/O = Player
					if(!O.started_as_observer)
						to_chat(Player, span_filter_system(span_red(span_bold("You did not survive the events on [station_name()]..."))))
				else
					to_chat(Player, span_filter_system(span_red(span_bold("You did not survive the events on [station_name()]..."))))
	to_chat(world, span_filter_system("<br>"))

	for (var/mob/living/silicon/ai/aiPlayer in GLOB.mob_list)
		if (aiPlayer.stat != 2)
			to_chat(world, span_filter_system(span_bold("[aiPlayer.name]'s laws at the end of the round were:"))) // VOREStation edit
		else
			to_chat(world, span_filter_system(span_bold("[aiPlayer.name]'s laws when it was deactivated were:"))) // VOREStation edit
		aiPlayer.show_laws(1)

		if (aiPlayer.connected_robots.len)
			var/robolist = span_bold("The AI's loyal minions were:") + " "
			for(var/mob/living/silicon/robot/robo in aiPlayer.connected_robots)
				robolist += "[robo.name][robo.stat?" (Deactivated), ":", "]"  // VOREStation edit
			to_chat(world, span_filter_system("[robolist]"))

	var/dronecount = 0

	for (var/mob/living/silicon/robot/robo in GLOB.mob_list)

		if(istype(robo, /mob/living/silicon/robot/platform))
			var/mob/living/silicon/robot/platform/tank = robo
			if(!tank.has_had_player)
				continue

		if(istype(robo,/mob/living/silicon/robot/drone) && !istype(robo,/mob/living/silicon/robot/drone/swarm))
			dronecount++
			continue

		if (!robo.connected_ai)
			if (robo.stat != 2)
				to_chat(world, span_filter_system(span_bold("[robo.name] survived as an AI-less stationbound synthetic! Its laws were:"))) // VOREStation edit
			else
				to_chat(world, span_filter_system(span_bold("[robo.name] was unable to survive the rigors of being a stationbound synthetic without an AI. Its laws were:"))) // VOREStation edit

			if(robo) //How the hell do we lose robo between here and the world messages directly above this?
				robo.laws.show_laws(world)

	if(dronecount)
		to_chat(world, span_filter_system(span_bold("There [dronecount>1 ? "were" : "was"] [dronecount] industrious maintenance [dronecount>1 ? "drones" : "drone"] at the end of this round.")))

	mode.declare_completion()//To declare normal completion.

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

	sleep(5 SECONDS)
	ready_for_reboot = TRUE
	standard_reboot()

/datum/controller/subsystem/ticker/proc/standard_reboot()
	if(ready_for_reboot)
		if(mode.station_was_nuked)
			Reboot("Station destroyed by Nuclear Device.", "nuke")
		else
			Reboot("Round ended.", "proper completion")
	else
		CRASH("Attempted standard reboot without ticker roundend completion")
