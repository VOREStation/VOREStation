//A system to create fun little species appreciation announcements, build primarily by following ATC as an example
//The system is simple, it just creates an appreciation message about 90 minutes into a shift, where it picks a species to appreciate for the day. Then will make infrequent reminders of this throughout the rest of the shift.
//It also has the ability to choose a random player's species to appreciate, even if it's a custom one, as long as there at least 5 human mob players.

SUBSYSTEM_DEF(appreciation)
	name = "Appreciation Messages"
	priority = FIRE_PRIORITY_APPRECIATE
	runlevels = RUNLEVEL_GAME
	wait = 2 MINUTES 								//This really does not need to fire very often at all
	flags = SS_NO_INIT | SS_BACKGROUND

	VAR_PRIVATE/next_tick = 0
	VAR_PRIVATE/delay_min = 90 MINUTES				//How long between announcements, minimum
	VAR_PRIVATE/delay_max = 180 MINUTES				//Ditto, maximum
							//Shorter delays are probably too spammy, 90-180 minutes means a message every two hours or so, which shouldn't be too intrusive.
	VAR_PRIVATE/backoff_delay = 5 MINUTES			//How long to back off if we can't talk and want to.  Default is 5 mins.
	VAR_PRIVATE/initial_delay = 90 MINUTES			//How long to wait before sending the first message of the shift.
	VAR_PRIVATE/squelched = FALSE					//If appreciation messages are squelched currently

	var/list/current_player_list = list()
	var/list/human_list = list()
	var/appreciated
	var/required_humans = 5							//The minimum number of humans in the list needed to allow it to choose one of their species.

/datum/controller/subsystem/appreciation/fire(resumed = FALSE)
	if(times_fired < 1)
		return
	if(times_fired == 1)
		next_tick = world.time + initial_delay
		return

	if(!resumed)
		if(world.time < next_tick)
			return
		if(squelched)
			next_tick = world.time + backoff_delay
			return
		next_tick = world.time + rand(delay_min,delay_max)

		if(appreciated)
			do_appreciate()
			return

		current_player_list = player_list.Copy()

	while(current_player_list.len)
		var/mob/M = current_player_list[current_player_list.len]
		current_player_list.len--

		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			human_list += H

		if (MC_TICK_CHECK)
			return

	current_player_list.Cut()
	build_appreciation()
	human_list.Cut()

	if(squelched)
		next_tick = world.time + backoff_delay
		return

	do_appreciate()


/datum/controller/subsystem/appreciation/proc/build_appreciation()
	if(human_list.len < required_humans)
		appreciated = pick(loremaster.appreciation_targets)
		return

	if(prob(50))
		appreciated = pick(loremaster.appreciation_targets)
		return

	var/mob/living/carbon/human/H = pick(human_list)
	if(!istype(H))
		appreciated = pick(loremaster.appreciation_targets)
		return

	if(H.custom_species)
		appreciated = H.custom_species
		return

	appreciated = H.species.name


/datum/controller/subsystem/appreciation/proc/do_appreciate()
	var/appreciation_message = pick(loremaster.appreciation_messages)
	var/terrible_factoid = pick(loremaster.terrible_factoids)
	msg("Today is [appreciated] appreciation day! [terrible_factoid] [appreciation_message]")

/datum/controller/subsystem/appreciation/proc/msg(var/message,var/sender)
	ASSERT(message)
	GLOB.global_announcer.autosay("[message]", sender ? sender : "Cultural Awareness")

/datum/controller/subsystem/appreciation/proc/is_squelched()
	return squelched

/datum/controller/subsystem/appreciation/proc/cancel_appreciation(var/yes = 1,var/silent = FALSE)
	if(yes)
		if(!squelched && !silent)
			msg("Today's appreciation day has been suspended.")
		squelched = 1
		return

	if(squelched && !silent)
		msg("Appreciation day has been resumed, get appreciating!")
	squelched = 0
