/obj/effect/bhole
	name = "black hole"
	icon = 'icons/obj/objects.dmi'
	desc = "FUCK FUCK FUCK AAAHHH"
	icon_state = "bhole3"
	opacity = 1
	unacidable = TRUE
	density = FALSE
	anchored = TRUE

/obj/effect/bhole/Initialize(mapload)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(controller)), 0.4 SECONDS, TIMER_DELETE_ME)

/obj/effect/bhole/proc/controller()
	if(!isturf(loc))
		qdel(src)
		return

	//DESTROYING STUFF AT THE EPICENTER
	for(var/mob/living/M in orange(1,src))
		qdel(M)
	for(var/obj/O in orange(1,src))
		qdel(O)
	var/base_turf = get_base_turf_by_area(src)
	for(var/turf/simulated/ST in orange(1,src))
		if(ST.type == base_turf)
			continue
		ST.ChangeTurf(base_turf)
	addtimer(CALLBACK(src, PROC_REF(pull_1)), 0.6 SECONDS, TIMER_DELETE_ME)

/obj/effect/bhole/proc/pull_1()
	grav(10, 4, 10, 0)
	addtimer(CALLBACK(src, PROC_REF(pull_2)), 0.6 SECONDS, TIMER_DELETE_ME)

/obj/effect/bhole/proc/pull_2()
	grav(8, 4, 10, 0)
	addtimer(CALLBACK(src, PROC_REF(pull_3)), 0.6 SECONDS, TIMER_DELETE_ME)

/obj/effect/bhole/proc/pull_3()
	grav(9, 4, 10, 0)
	addtimer(CALLBACK(src, PROC_REF(pull_4)), 0.6 SECONDS, TIMER_DELETE_ME)

/obj/effect/bhole/proc/pull_4()
	grav(7, 3, 40, 1)
	addtimer(CALLBACK(src, PROC_REF(pull_5)), 0.6 SECONDS, TIMER_DELETE_ME)

/obj/effect/bhole/proc/pull_5()
	grav(5, 3, 40, 1)
	addtimer(CALLBACK(src, PROC_REF(pull_6)), 0.6 SECONDS, TIMER_DELETE_ME)

/obj/effect/bhole/proc/pull_6()
	grav(6, 3, 40, 1)
	addtimer(CALLBACK(src, PROC_REF(pull_7)), 0.6 SECONDS, TIMER_DELETE_ME)

/obj/effect/bhole/proc/pull_7()
	grav(4, 2, 50, 6)
	addtimer(CALLBACK(src, PROC_REF(pull_8)), 0.6 SECONDS, TIMER_DELETE_ME)

/obj/effect/bhole/proc/pull_8()
	grav(3, 2, 50, 6)
	addtimer(CALLBACK(src, PROC_REF(pull_9)), 0.6 SECONDS, TIMER_DELETE_ME)

/obj/effect/bhole/proc/pull_9()
	grav(2, 2, 75,25)
	addtimer(CALLBACK(src, PROC_REF(move)), 0.6 SECONDS, TIMER_DELETE_ME)

/obj/effect/bhole/proc/move()
	//MOVEMENT
	if(prob(50))
		anchored = FALSE
		step(src, pick(alldirs))
		anchored = TRUE
	controller()

/obj/effect/bhole/proc/grav(var/r, var/ex_act_force, var/pull_chance, var/turf_removal_chance)
	if(!isturf(loc))	//blackhole cannot be contained inside anything. Weird stuff might happen
		qdel(src)
		return
	for(var/t = -r, t < r, t++)
		affect_coord(x+t, y-r, ex_act_force, pull_chance, turf_removal_chance)
		affect_coord(x-t, y+r, ex_act_force, pull_chance, turf_removal_chance)
		affect_coord(x+r, y+t, ex_act_force, pull_chance, turf_removal_chance)
		affect_coord(x-r, y-t, ex_act_force, pull_chance, turf_removal_chance)
	return

/obj/effect/bhole/proc/affect_coord(var/x, var/y, var/ex_act_force, var/pull_chance, var/turf_removal_chance)
	//Get turf at coordinate
	var/turf/T = locate(x, y, z)
	if(isnull(T))	return

	//Pulling and/or ex_act-ing movable atoms in that turf
	if( prob(pull_chance) )
		for(var/obj/O in T.contents)
			if(O.anchored)
				O.ex_act(ex_act_force)
			else
				step_towards(O,src)
		for(var/mob/living/M in T.contents)
			step_towards(M,src)

	//Destroying the turf
	if( T && istype(T,/turf/simulated) && prob(turf_removal_chance) )
		var/turf/simulated/ST = T
		var/base_turf = get_base_turf_by_area(src)
		if(ST.type != base_turf)
			ST.ChangeTurf(base_turf)
