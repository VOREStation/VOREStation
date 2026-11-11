/obj/machinery/transportpod
	name = "Ballistic Transportation Pod"
	desc = "A fast transit ballistic pod used to get from one place to the next. Batteries not included!"
	icon = 'icons/obj/structures.dmi'
	icon_state = "borg_pod_opened"

	density = TRUE //thicc
	anchored = FALSE
	use_power = USE_POWER_OFF

	var/in_transit = FALSE
	var/used = FALSE
	var/static/list/available_landing_sites
	var/mob/occupant = null
	var/datum/gas_mixture/pod_air/air

/obj/machinery/transportpod/Initialize(mapload)
	. = ..()
	air = new
	if(isnull(available_landing_sites))
		available_landing_sites = list()
		for(var/obj/effect/landmark/land_spot in GLOB.landmarks_list)
			if(land_spot.name != "droppod_landing")
				continue
			var/area/A = get_area(land_spot)
			if(!A)
				continue
			available_landing_sites["[A]"] = get_turf(land_spot)

/obj/machinery/transportpod/Destroy()
	. = ..()
	in_transit = FALSE
	go_out()
	QDEL_NULL(air)

/obj/machinery/transportpod/attack_hand(mob/user)
	. = ..()
	if(!occupant)
		return
	if(in_transit)
		return
	if(used)
		return
	send_to_station(user)

/obj/machinery/transportpod/proc/send_to_station(mob/user)
	if(!user) // If event manager called as a verb
		user = usr
	if(!occupant)
		return
	if(in_transit)
		return
	if(!length(available_landing_sites))
		to_chat(occupant, span_warning("There is nowhere left to land!"))
		return

	var/choice = tgui_input_list(user, "Choose a landing site.", "Landing site.", available_landing_sites)
	if(!choice)
		return
	if(!(choice in available_landing_sites))
		to_chat(occupant, span_warning("The landing site at [choice] no longer exists!"))
		return

	used = TRUE
	anchored = TRUE
	var/turf/goal = available_landing_sites[choice]
	var/list/possible_landings = list()
	for(var/turf/simulated/floor/valid in range(3, goal))
		if(!valid.CanPass(src,valid))
			continue
		for(var/atom/movable/thing in valid)//Basic level check for structures in the way (Like grilles and windows)
			if(!(thing.CanPass(src,valid)))
				continue
		possible_landings += valid
	if(length(possible_landings))
		goal = pick(possible_landings)
	addtimer(CALLBACK(src, PROC_REF(send_pod), goal), 2 SECONDS, TIMER_DELETE_ME)

/obj/machinery/transportpod/proc/send_pod(turf/goal)
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE)

	in_transit = TRUE
	var/list/turfs_nearby = block(get_step(goal, SOUTHWEST), get_step(goal, NORTHEAST))
	for(var/turf/TN in turfs_nearby)
		new /obj/effect/temporary_effect/shuttle_landing(TN)
	playsound(src, 'sound/effects/shuttles/hyperspace_begin.ogg', 50, FALSE)
	addtimer(CALLBACK(src, PROC_REF(handle_transit), goal), 4 SECONDS, TIMER_DELETE_ME)

/obj/machinery/transportpod/proc/handle_transit(turf/goal)
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE)

	plane = ABOVE_PLANE
	pixel_y = 300
	alpha = 0
	forceMove(goal)
	update_icon()

	animate(src, pixel_y = 0, time = 1 SECONDS, easing = SINE_EASING|EASE_OUT)
	animate(src, alpha = 255, time = 1 SECOND, flags = ANIMATION_PARALLEL)
	filters += filter(type="drop_shadow", x=-64, y=100, size=10)
	animate(filters[filters.len], x=0, y=0, size=0, time=3 SECONDS, flags=ANIMATION_PARALLEL, easing=SINE_EASING|EASE_OUT)
	addtimer(CALLBACK(src, PROC_REF(after_fall), goal), 1.1 SECONDS, TIMER_DELETE_ME)

/obj/machinery/transportpod/proc/after_fall(turf/goal)
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE)

	filters = null
	playsound(src, 'sound/effects/meteorimpact.ogg', 50, FALSE)
	explosion(goal, 1, 1, 0, 3)
	for(var/turf/simulated/floor/F in view(1, goal))
		F.burn_tile(900)
	if(ismob(occupant))
		to_chat(occupant, span_danger("You've landed! Open the hatch if you think it's safe! \The [src] has enough air to last for a while..."))
	plane = initial(plane)
	anchored = FALSE
	in_transit = FALSE
	update_icon()
	if(ispath(occupant))
		addtimer(CALLBACK(src, PROC_REF(go_out)), rand(1,3) SECONDS, TIMER_DELETE_ME)

/obj/machinery/transportpod/ex_act(severity)
	return

/obj/machinery/transportpod/relaymove(mob/user as mob)
	if(user.stat)
		return
	go_out()
	return

/obj/machinery/transportpod/update_icon()
	if(occupant)
		icon_state = "borg_pod_closed"
	else
		icon_state = "borg_pod_opened"

/obj/machinery/transportpod/Bumped(mob/living/O)
	go_in(O)

/obj/machinery/transportpod/proc/go_in(mob/living/carbon/human/O)
	if(occupant)
		return

	if(O.incapacitated()) //aint no sleepy people getting in here
		return
	if(in_transit)
		return
	if(used)
		return

	add_fingerprint(O)
	O.forceMove(src)
	if(isanimal(O) && !O.client)
		occupant = O.type
		qdel(O)
	else
		occupant = O
		if(tgui_alert(O, "Are you sure you're ready to launch?", "Transport Pod", list("Yes", "No")) == "Yes")
			send_to_station(O)
		else
			go_out()
	update_icon()
	return 1

/obj/machinery/transportpod/proc/go_out()
	if(!occupant)
		return
	if(in_transit)
		return
	playsound(src, 'sound/effects/magnetclamp.ogg', 100, 1)
	if(ispath(occupant))
		new occupant(src.loc)
	else
		occupant.forceMove(src.loc)
	occupant = null
	update_icon()

/obj/machinery/transportpod/verb/move_eject()
	set category = "Object"
	set name = "Eject Pod"
	set src in oview(1)

	if(usr.incapacitated())
		return
	if(in_transit)
		return

	go_out()
	add_fingerprint(usr)
	return

/obj/machinery/transportpod/verb/move_inside()
	set category = "Object"
	set name = "Enter Pod"
	set src in oview(1)

	if(usr.incapacitated()) //just to DOUBLE CHECK the damn sleepy people don't touch the pod
		return
	if(in_transit)
		return
	if(used)
		return

	go_in(usr)


/obj/machinery/transportpod/return_air()
	return return_air_for_internal_lifeform()

/obj/machinery/transportpod/return_air_for_internal_lifeform()
	return air


// Alt pod style
/obj/machinery/transportpod/alt
	icon = 'icons/obj/structures/droppod.dmi'
	icon_state = "pod_open"

/obj/machinery/transportpod/alt/update_icon()
	if(in_transit)
		icon_state = "pod_falling"
	else if(occupant)
		icon_state = "pod"
	else
		icon_state = "pod_open"
