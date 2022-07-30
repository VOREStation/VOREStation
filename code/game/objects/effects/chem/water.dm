/obj/effect/vfx/water
	name = "water"
	icon = 'icons/effects/effects.dmi'
	icon_state = "extinguish"
	mouse_opacity = 0
	pass_flags = PASSTABLE | PASSGRILLE | PASSBLOB

/obj/effect/vfx/water/Initialize()
	. = ..()
	QDEL_IN(src, 15 SECONDS)

/obj/effect/vfx/water/proc/set_color() // Call it after you move reagents to it
	icon += reagents.get_color()

/obj/effect/vfx/water/proc/set_up(var/turf/target, var/step_count = 5, var/delay = 5)
	if(!target)
		return
	for(var/i = 1 to step_count)
		if(!loc)
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
				break
			if(T == get_turf(target))
				break
		sleep(delay)
	sleep(10)
	qdel(src)

/obj/effect/vfx/water/Move(turf/newloc)
	if(newloc.density)
		return 0
	. = ..()

/obj/effect/vfx/water/Bump(atom/A)
	if(reagents)
		reagents.touch(A)
	return ..()

//Used by spraybottles.
/obj/effect/vfx/water/chempuff
	name = "chemicals"
	icon = 'icons/obj/chempuff.dmi'
	icon_state = ""
