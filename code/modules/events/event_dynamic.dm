
/*
/proc/start_events()
	//changed to a while(1) loop since they are more efficient.
	//Moved the spawn in here to allow it to be called with advance proc call if it crashes.
	//and also to stop spawn copying variables from the game ticker
	spawn(3000)
		while(1)
			/*if(prob(50))//Every 120 seconds and prob 50 2-4 weak spacedusts will hit the station
				spawn(1)
					dust_swarm("weak")*/
			if(!event)
				//CARN: checks to see if random events are enabled.
				if(config.allow_random_events)
					hadevent = event()
				else
					Holiday_Random_Event()
			else
				event = 0
			sleep(2400)
			*/

var/list/event_last_fired = list()

//Always triggers an event when called, dynamically chooses events based on job population
/proc/spawn_dynamic_event()
	if(!CONFIG_GET(flag/allow_random_events))
		return

	var/minutes_passed = world.time/600

	var/list/active_with_role = number_active_with_role()
	//var/engineer_count = number_active_with_role(DEPARTMENT_ENGINEERING)
	//var/security_count = number_active_with_role(DEPARTMENT_SECURITY)
	//var/medical_count = number_active_with_role(DEPARTMENT_MEDICAL)
	//var/AI_count = number_active_with_role(JOB_AI)
	//var/janitor_count = number_active_with_role(JOB_JANITOR)

	// Maps event names to event chances
	// For each chance, 100 represents "normal likelihood", anything below 100 is "reduced likelihood", anything above 100 is "increased likelihood"
	// Events have to be manually added to this proc to happen
	var/list/possibleEvents = list()

	//see:
	// Code/WorkInProgress/Cael_Aislinn/Economy/Economy_Events.dm
	// Code/WorkInProgress/Cael_Aislinn/Economy/Economy_Events_Mundane.dm

	possibleEvents[/datum/event/economic_event] = 300
	possibleEvents[/datum/event/trivial_news] = 400
	//possibleEvents[/datum/event/mundane_news] = 300
	possibleEvents[/datum/event/lore_news] = 300 // up this if the above ones get removed as they damn well should

	//possibleEvents[/datum/event/pda_spam] = max(min(25, player_list.len) * 4, 200)
	possibleEvents[/datum/event/money_lotto] = max(min(5, player_list.len), 50)
	if(GLOB.account_hack_attempted)
		possibleEvents[/datum/event/money_hacker] = max(min(25, player_list.len) * 4, 200)


	possibleEvents[/datum/event/carp_migration] = 20 + 10 * active_with_role[DEPARTMENT_ENGINEERING]
	possibleEvents[/datum/event/brand_intelligence] = 20 + 25 * active_with_role[JOB_JANITOR]

	possibleEvents[/datum/event/rogue_drone] = 5 + 25 * active_with_role[DEPARTMENT_ENGINEERING] + 25 * active_with_role[DEPARTMENT_SECURITY]
	possibleEvents[/datum/event/infestation] = 100 + 100 * active_with_role[JOB_JANITOR]

	possibleEvents[/datum/event/communications_blackout] = 50 + 25 * active_with_role[JOB_AI] + active_with_role[DEPARTMENT_RESEARCH] * 25
	possibleEvents[/datum/event/ionstorm] = active_with_role[JOB_AI] * 25 + active_with_role[JOB_CYBORG] * 25 + active_with_role[DEPARTMENT_ENGINEERING] * 10 + active_with_role[DEPARTMENT_RESEARCH] * 5
	possibleEvents[/datum/event/grid_check] = 25 + 10 * active_with_role[DEPARTMENT_ENGINEERING]
	possibleEvents[/datum/event/electrical_storm] = 15 * active_with_role[JOB_JANITOR] + 5 * active_with_role[DEPARTMENT_ENGINEERING]
	possibleEvents[/datum/event/wallrot] = 30 * active_with_role[DEPARTMENT_ENGINEERING] + 50 * active_with_role[JOB_ALT_GARDENER]

	if(!spacevines_spawned)
		possibleEvents[/datum/event/spacevine] = 10 + 5 * active_with_role[DEPARTMENT_ENGINEERING]
	if(minutes_passed >= 30) // Give engineers time to set up engine
		possibleEvents[/datum/event/meteor_wave] = 10 * active_with_role[DEPARTMENT_ENGINEERING]
		possibleEvents[/datum/event/blob] = 10 * active_with_role[DEPARTMENT_ENGINEERING]

	if(active_with_role[DEPARTMENT_MEDICAL] > 0)
		possibleEvents[/datum/event/radiation_storm] = active_with_role[DEPARTMENT_MEDICAL] * 10
		possibleEvents[/datum/event/spontaneous_appendicitis] = active_with_role[DEPARTMENT_MEDICAL] * 10

	possibleEvents[/datum/event/prison_break] = active_with_role[DEPARTMENT_SECURITY] * 50
	if(active_with_role[DEPARTMENT_SECURITY] > 0)
		if(!sent_spiders_to_station)
			possibleEvents[/datum/event/spider_infestation] = max(active_with_role[DEPARTMENT_SECURITY], 5) + 5
		possibleEvents[/datum/event/random_antag] = max(active_with_role[DEPARTMENT_SECURITY], 5) + 2.5

	for(var/event_type in event_last_fired) if(possibleEvents[event_type])
		var/time_passed = world.time - event_last_fired[event_type]
		var/full_recharge_after = 60 * 60 * 10 * 3 // 3 hours
		var/weight_modifier = max(0, (full_recharge_after - time_passed) / 300)

		possibleEvents[event_type] = max(possibleEvents[event_type] - weight_modifier, 0)

	var/picked_event = pickweight(possibleEvents)
	event_last_fired[picked_event] = world.time

	// Debug code below here, very useful for testing so don't delete please.
	var/debug_message = "Firing random event. "
	for(var/V in active_with_role)
		debug_message += "#[V]:[active_with_role[V]] "
	debug_message += "||| "
	for(var/V in possibleEvents)
		debug_message += "[V]:[possibleEvents[V]]"
	debug_message += "|||Picked:[picked_event]"
	log_debug(debug_message)

	if(!picked_event)
		return

	//The event will add itself to the MC's event list
	//and start working via the constructor.
	new picked_event

	//moved this to proc/check_event()
	/*var/chance = possibleEvents[picked_event]
	var/base_chance = 0.4
	switch(player_list.len)
		if(5 to 10)
			base_chance = 0.6
		if(11 to 15)
			base_chance = 0.7
		if(16 to 20)
			base_chance = 0.8
		if(21 to 25)
			base_chance = 0.9
		if(26 to 30)
			base_chance = 1.0
		if(30 to 100000)
			base_chance = 1.1

	// Trigger the event based on how likely it currently is.
	if(!prob(chance * eventchance * base_chance / 100))
		return 0*/

	/*switch(picked_event)
		if("Meteor")
			command_alert("Meteors have been detected on collision course with the station.", "Meteor Alert")
			for(var/mob/M in player_list)
				if(!istype(M,/mob/new_player))
					M << sound('sound/AI/meteors.ogg')
			spawn(100)
				meteor_wave(10)
				spawn_meteors()
			spawn(700)
				meteor_wave(10)
				spawn_meteors()
		if("Space Ninja")
			//Handled in space_ninja.dm. Doesn't announce arrival, all sneaky-like.
			space_ninja_arrival()
		if("Radiation")
			high_radiation_event()
		if("Virus")
			viral_outbreak()
		if("Alien")
			alien_infestation()
		if("Prison Break")
			prison_break()
		if("Carp")
			carp_migration()
		if("Lights")
			lightsout(1,2)
		if("Appendicitis")
			appendicitis()
		if("Ion Storm")
			IonStorm()
		if("Spacevine")
			spacevine_infestation()
		if("Communications")
			communications_blackout()
		if("Grid Check")
			grid_check()
		if("Meteor")
			meteor_shower()*/

	return 1

// Returns how many characters are currently active(not logged out, not AFK for more than 10 minutes)
// with a specific role.
// Note that this isn't sorted by department, because e.g. having a roboticist shouldn't make meteors spawn.
/proc/number_active_with_role()
	var/list/active_with_role = list()
	active_with_role[DEPARTMENT_ENGINEERING] = 0
	active_with_role[DEPARTMENT_MEDICAL] = 0
	active_with_role[DEPARTMENT_SECURITY] = 0
	active_with_role[DEPARTMENT_RESEARCH] = 0
	active_with_role[JOB_AI] = 0
	active_with_role[JOB_CYBORG] = 0
	active_with_role[JOB_JANITOR] = 0
	active_with_role[JOB_BOTANIST] = 0

	for(var/mob/M in player_list)
		if(!M.mind || !M.client || M.client.is_afk(10 MINUTES)) // longer than 10 minutes AFK counts them as inactive
			continue

		active_with_role["Any"]++

		if(istype(M, /mob/living/silicon/robot))
			var/mob/living/silicon/robot/R = M
			if(R.module)
				if(istype(R.module, /obj/item/robot_module/robot/engineering))
					active_with_role[DEPARTMENT_ENGINEERING]++
				else if(istype(R.module, /obj/item/robot_module/robot/security))
					active_with_role[DEPARTMENT_SECURITY]++
				else if(istype(R.module, /obj/item/robot_module/robot/medical))
					active_with_role[DEPARTMENT_MEDICAL]++
				else if(istype(R.module, /obj/item/robot_module/robot/research))
					active_with_role[DEPARTMENT_RESEARCH]++
				else if(istype(R.module, /obj/item/robot_module/robot/janitor))
					active_with_role[JOB_JANITOR]++
				else if(istype(R.module, /obj/item/robot_module/robot/clerical/butler))
					active_with_role[JOB_BOTANIST]++

		if(M.mind.assigned_role in SSjob.get_job_titles_in_department(DEPARTMENT_ENGINEERING))
			active_with_role[DEPARTMENT_ENGINEERING]++

		if(M.mind.assigned_role in SSjob.get_job_titles_in_department(DEPARTMENT_MEDICAL))
			active_with_role[DEPARTMENT_MEDICAL]++

		if(M.mind.assigned_role in SSjob.get_job_titles_in_department(DEPARTMENT_SECURITY))
			active_with_role[DEPARTMENT_SECURITY]++

		if(M.mind.assigned_role in SSjob.get_job_titles_in_department(DEPARTMENT_RESEARCH))
			active_with_role[DEPARTMENT_RESEARCH]++

		if(M.mind.assigned_role == JOB_AI)
			active_with_role[JOB_AI]++

		if(M.mind.assigned_role == JOB_CYBORG)
			active_with_role[JOB_CYBORG]++

		if(M.mind.assigned_role == JOB_JANITOR)
			active_with_role[JOB_JANITOR]++

		if(M.mind.assigned_role == JOB_BOTANIST)
			active_with_role[JOB_BOTANIST]++

	return active_with_role
