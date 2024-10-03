/proc/count_drones()
	var/drones = 0
	for(var/mob/living/silicon/robot/drone/D in player_list)
		drones++
	return drones

/obj/machinery/drone_fabricator
	name = "drone fabricator"
	desc = "A large automated factory for producing maintenance drones."
	appearance_flags = 0

	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 20
	active_power_usage = 5000

	var/fabricator_tag = "Upper Level"
	var/drone_progress = 0
	var/produce_drones = 2
	var/time_last_drone = 500
	var/drone_type = /mob/living/silicon/robot/drone

	icon = 'icons/obj/machines/drone_fab.dmi'
	icon_state = "drone_fab_idle"

/obj/machinery/drone_fabricator/derelict
	name = "construction drone fabricator"
	fabricator_tag = "Upper Level Construction"
	drone_type = /mob/living/silicon/robot/drone/construction

/obj/machinery/drone_fabricator/mining
	name = "mining drone fabricator"
	fabricator_tag = "Upper Level Mining"
	drone_type = /mob/living/silicon/robot/drone/mining

/obj/machinery/drone_fabricator/New()
	..()

/obj/machinery/drone_fabricator/power_change()
	..()
	if (stat & NOPOWER)
		icon_state = "drone_fab_nopower"

/obj/machinery/drone_fabricator/process()

	if(ticker.current_state < GAME_STATE_PLAYING)
		return

	if(stat & NOPOWER || !produce_drones)
		if(icon_state != "drone_fab_nopower") icon_state = "drone_fab_nopower"
		return

	if(drone_progress >= 100)
		icon_state = "drone_fab_idle"
		return

	icon_state = "drone_fab_active"
	var/elapsed = world.time - time_last_drone
	drone_progress = round((elapsed/config.drone_build_time)*100)

	if(drone_progress >= 100)
		visible_message("\The [src] voices a strident beep, indicating a drone chassis is prepared.")

/obj/machinery/drone_fabricator/examine(mob/user)
	. = ..()
	if(produce_drones && drone_progress >= 100 && istype(user,/mob/observer/dead) && config.allow_drone_spawn && count_drones() < config.max_maint_drones)
		. += "<br><B>A drone is prepared. Select 'Join As Drone' from the Ghost tab to spawn as a maintenance drone.</B>"

/obj/machinery/drone_fabricator/proc/create_drone(var/client/player)

	if(stat & NOPOWER)
		return

	if(!produce_drones || !config.allow_drone_spawn || count_drones() >= config.max_maint_drones)
		return

	if(player && !istype(player.mob,/mob/observer/dead))
		return

	visible_message("\The [src] churns and grinds as it lurches into motion, disgorging a shiny new drone after a few moments.")
	flick("h_lathe_leave",src)
	drone_progress = 0

	time_last_drone = world.time

	var/mob/living/silicon/robot/drone/new_drone = new drone_type(get_turf(src))
	if(player)
		announce_ghost_joinleave(player, 0, "They have taken control over a maintenance drone.")
		if(player.mob && player.mob.mind) player.mob.mind.reset()
		new_drone.transfer_personality(player)

	return new_drone

/mob/observer/dead/verb/join_as_drone()

	set category = "Ghost"
	set name = "Join As Drone"
	set desc = "If there is a powered, enabled fabricator in the game world with a prepared chassis, join as a maintenance drone."

	if(ticker.current_state < GAME_STATE_PLAYING)
		to_chat(src, span_danger("The game hasn't started yet!"))
		return

	if(!(config.allow_drone_spawn))
		to_chat(src, span_danger("That verb is not currently permitted."))
		return

	if (!src.stat)
		return

	if (usr != src)
		return 0 //something is terribly wrong

	if(jobban_isbanned(src,JOB_CYBORG))
		to_chat(usr, span_danger("You are banned from playing synthetics and cannot spawn as a drone."))
		return

	// VOREStation Addition Start
	if(config.use_age_restriction_for_jobs && isnum(src.client.player_age))
		var/time_till_play = max(0, 3 - src.client.player_age)
		if(time_till_play)
			to_chat(usr, span_danger("You have not been playing on the server long enough to join as drone."))
			return
	// VOREStation Addition End

	if(!MayRespawn(1))
		return

	var/deathtime = world.time - src.timeofdeath
	var/deathtimeminutes = round(deathtime / (1 MINUTE))
	var/pluralcheck = "minute"
	if(deathtimeminutes == 0)
		pluralcheck = ""
	else if(deathtimeminutes == 1)
		pluralcheck = " [deathtimeminutes] minute and"
	else if(deathtimeminutes > 1)
		pluralcheck = " [deathtimeminutes] minutes and"
	var/deathtimeseconds = round((deathtime - deathtimeminutes * 1 MINUTE) / 10,1)

	if (deathtime < 5 MINUTES)
		to_chat(usr, "You have been dead for[pluralcheck] [deathtimeseconds] seconds.")
		to_chat(usr, "You must wait 5 minutes to respawn as a drone!")
		return

	var/list/all_fabricators = list()
	for(var/obj/machinery/drone_fabricator/DF in machines)
		if(DF.stat & NOPOWER || !DF.produce_drones)
			continue
		if(DF.drone_progress >= 100)
			all_fabricators[DF.fabricator_tag] = DF

	if(!all_fabricators.len)
		to_chat(src, span_danger("There are no available drone spawn points, sorry."))
		return

	var/choice = tgui_input_list(src, "Which fabricator do you wish to use?", "Fabricator Choice", all_fabricators)
	if(choice)
		var/obj/machinery/drone_fabricator/chosen_fabricator = all_fabricators[choice]
		chosen_fabricator.create_drone(src.client)
