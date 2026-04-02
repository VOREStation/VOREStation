/obj/effect/effect/water
	name = "water"
	icon = 'icons/effects/effects.dmi'
	icon_state = "extinguish"
	mouse_opacity = 0
	pass_flags = PASSTABLE | PASSGRILLE | PASSBLOB

/obj/effect/effect/water/Initialize(mapload)
	. = ..()
	QDEL_IN(src, 15 SECONDS)

/obj/effect/effect/water/proc/set_color() // Call it after you move reagents to it
	icon += reagents.get_color()

/obj/effect/effect/water/proc/set_up(var/turf/target, var/step_count = 5, var/delay = 5)
	if(!target)
		return
	step_process(target, step_count, delay)

/obj/effect/effect/water/proc/step_process(var/turf/target, var/step_count, var/delay, var/iteration)
	step_count--
	if(!loc)
		qdel(src)
		return
	step_towards(src, target)
	var/turf/T = get_turf(src)
	if(T && reagents)
		reagents.touch_turf(T, reagents.total_volume) //VOREStation Add
		var/mob/M
		for(var/atom/A in T)
			if(!ismob(A) && A.simulated) // Mobs are handled differently
				reagents.touch(A, reagents.total_volume)
			else if(ismob(A) && !M)
				M = A
		if(M)
			reagents.splash(M, reagents.total_volume)
			QDEL_IN(src, 1 SECOND)
			return
		if(T == get_turf(target))
			QDEL_IN(src, 1 SECOND)
			return

	if(step_count > 0)
		addtimer(CALLBACK(src, PROC_REF(step_process), target, step_count, delay, iteration), delay)
	else
		QDEL_IN(src, 1 SECOND)

/obj/effect/effect/water/Move(turf/newloc)
	if(newloc.density)
		return 0
	. = ..()

/obj/effect/effect/water/Bump(atom/A)
	if(reagents)
		reagents.touch(A)
	return ..()

//Used by spraybottles.
/obj/effect/effect/water/chempuff
	name = "chemicals"
	icon = 'icons/obj/chempuff.dmi'
	icon_state = ""
