/obj/structure/drop_pod
	name = "drop pod"
	desc = "Standard Commonwealth drop pod. There are file marks where the serial number should be, however."
	icon = 'icons/obj/structures/droppod.dmi'
	icon_state = "pod"
	density = TRUE
	anchored = TRUE

	var/polite = FALSE // polite ones don't violently murder everything
	var/finished = FALSE
	var/datum/gas_mixture/pod_air/air

/obj/structure/drop_pod/polite
	polite = TRUE

/obj/structure/drop_pod/New(newloc, atom/movable/A, auto_open = FALSE)
	..()
	if(A)
		A.forceMove(src) // helo
		podfall(auto_open)
		air = new

/obj/structure/drop_pod/Destroy()
	. = ..()
	qdel_null(air)

/obj/structure/drop_pod/proc/podfall(auto_open)
	set waitfor = FALSE // sleeping in new otherwise

	var/turf/T = get_turf(src)
	if(!T)
		warning("Drop pod wasn't spawned on a turf")
		return

	moveToNullspace()
	icon_state = "[initial(icon_state)]_falling"

	// Show warning on 3x3 area centred on our drop spot
	var/list/turfs_nearby = block(get_step(T, SOUTHWEST), get_step(T, NORTHEAST))
	for(var/turf/TN in turfs_nearby)
		new /obj/effect/temporary_effect/shuttle_landing(TN)

	// Wait a minute
	sleep(4 SECONDS)

	// Wheeeeeee
	plane = ABOVE_PLANE
	pixel_y = 300
	alpha = 0
	forceMove(T)
	playsound(T, 'sound/effects/droppod.ogg', 50, 1)
	animate(src, pixel_y = 0, time = 3 SECONDS, easing = SINE_EASING|EASE_OUT)
	animate(src, alpha = 255, time = 1 SECOND, flags = ANIMATION_PARALLEL)
	filters += filter(type="drop_shadow", x=-64, y=100, size=10)
	animate(filters[filters.len], x=0, y=0, size=0, time=3 SECONDS, flags=ANIMATION_PARALLEL, easing=SINE_EASING|EASE_OUT)
	sleep(2 SECONDS)
	new /obj/effect/effect/smoke(T)
	T.hotspot_expose(900)
	sleep(1 SECOND)
	filters = null

	// CRONCH
	playsound(src, 'sound/effects/meteorimpact.ogg', 50, 1)
	if(!polite)
		for(var/atom/A in view(1, T))
			if(A == src)
				continue
			A.ex_act(2)
	else
		for(var/turf/simulated/floor/F in view(1, T))
			F.burn_tile(900)

	for(var/obj/O in T)
		if(O == src)
			continue
		qdel(O)
	for(var/mob/living/L in T)
		L.gib()

	// Landed! Simmer
	plane = initial(plane)
	icon_state = "[initial(icon_state)]"

	if(auto_open)
		sleep(2 SECONDS)
		open_pod()
		visible_message("\The [src] pops open!")
	else
		for(var/mob/M in src)
			to_chat(M, span_danger("You've landed! Open the hatch if you think it's safe! \The [src] has enough air to last for a while..."))

/obj/structure/drop_pod/proc/open_pod()
	if(finished)
		return
	icon_state = "[initial(icon_state)]_open"
	playsound(src, 'sound/effects/magnetclamp.ogg', 100, 1)
	for(var/atom/movable/AM in src)
		AM.forceMove(loc)
		AM.set_dir(SOUTH) // cus
	qdel_null(air)
	finished = TRUE

/obj/structure/drop_pod/attack_hand(mob/living/user)
	if(istype(user) && (Adjacent(user) || (user in src)) && !user.incapacitated())
		if(finished)
			to_chat(user, span_warning("Nothing left to do with it now. Maybe you can break it down into materials."))
		else
			open_pod()
			user.visible_message(span_infoplain(span_bold("[user]") + " opens \the [src]!"),span_infoplain("You open \the [src]!"))

/obj/structure/drop_pod/attackby(obj/item/O, mob/user)
	if(O.has_tool_quality(TOOL_WRENCH))
		if(finished)
			to_chat(user, span_notice("You start breaking down \the [src]."))
			if(do_after(user, 10 SECONDS, src, exclusive = TASK_ALL_EXCLUSIVE))
				new /obj/item/stack/material/plasteel(loc, 10)
				playsound(user, O.usesound, 50, 1)
				qdel(src)
		else
			to_chat(user, span_warning("\The [src] hasn't been opened yet. Do that first."))
	return ..()

/obj/structure/drop_pod/return_air()
	return air || ..()

/obj/structure/drop_pod/return_air_for_internal_lifeform()
	return air || ..()

/obj/structure/drop_pod/assume_air(datum/gas_mixture/giver)
	if(air)
		return air.merge(giver)
	else
		return ..()

// This is about 0.896m^3 of atmosphere, which is enough to last for quite a while.
/datum/gas_mixture/pod_air
	volume = 2500
	temperature = 293.150
	total_moles = 104

/datum/gas_mixture/pod_air/New()
	. = ..()
	gas = list(
		GAS_O2 = 21,
		GAS_N2 = 79)
