
/obj/effect/temporary_effect/pulse/snake
	name = "snake head"
	pulses_remaining = 20
	pulse_delay = 0.5 SECONDS

	icon_state = "arrow_omni"

	invisibility = 100

// The atom which created this.
	var/atom/movable/creator
// Will the snake ever intentionally move onto its creator's turf?
	var/safe = FALSE

	var/ignore_density = FALSE

// The turfs this snake has already crossed.
	var/list/iterated_turfs = list()
// How many turfs this snake should remember.
	var/total_turf_memory = 5
// Is the snake hunting a specific atom? (Will always try to meander toward this target.)
	var/atom/hunting

/obj/effect/temporary_effect/pulse/snake/Initialize(var/ml, var/atom/hunt_target, var/atom/Creator)
	if(hunt_target)
		hunting = hunt_target
	if(Creator)
		creator = Creator
	. = ..()

/obj/effect/temporary_effect/pulse/snake/pulse_loop()	// Override needed unfortunately to handle the possibility of not finding a target turf.
	set waitfor = FALSE

	while(pulses_remaining)
		sleep(pulse_delay)
		if(on_pulse())
			pulses_remaining--
		else
			break
	qdel(src)

/obj/effect/temporary_effect/pulse/snake/on_pulse()
	var/list/possible_turfs = list()

	if(LAZYLEN(iterated_turfs) && iterated_turfs.len > total_turf_memory)
		iterated_turfs.Cut(total_turf_memory + 1)

	for(var/direction in list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST) - turn(src.dir,180))
		var/turf/T = get_step(src, direction)
		if(T in iterated_turfs)
			continue

		if(!ignore_density && T.density)
			continue

		if(safe && creator && get_dir(src, T) == get_dir(src,creator))
			continue

		if(hunting && get_dist(T, hunting) > get_dist(src, hunting))
			continue

		possible_turfs |= T

		if(T == get_step(src, dir))
			possible_turfs[T] = 4
		else
			possible_turfs[T] = 1

	var/turf/Target

	if(LAZYLEN(possible_turfs))	// Pick from our remaining possible turfs.
		Target = pickweight(possible_turfs)
	else	// IF we have none left, just pick a random one.
		for(var/turf/T in oview(1, src))
			possible_turfs |= T
		Target = pick(possible_turfs)

	if(Target)
		iterated_turfs.Insert(1, Target)
		on_leave_turf(get_turf(src))
		dir = get_dir(src, Target)
		forceMove(Target)
		on_enter_turf(Target)
		return TRUE

	else
		on_leave_turf(get_turf(src))
		return FALSE

/obj/effect/temporary_effect/pulse/snake/proc/on_leave_turf(var/turf/T)

/obj/effect/temporary_effect/pulse/snake/proc/on_enter_turf(var/turf/T)

/obj/effect/temporary_effect/pulse/snake/testing/on_leave_turf(var/turf/T)
	if(T)
		new /obj/effect/temporary_effect/eruption/testing(T, 3 SECONDS, "#ff0000")

/obj/effect/temporary_effect/pulse/snake/testing/on_enter_turf(var/turf/T)
	if(T)
		T.color = "#00ff00"

		spawn(3 SECONDS)
			T.color = initial(T.color)

/obj/effect/temporary_effect/pulse/snake/testing/hunter/pulse_loop()
	hunting = locate(/mob/living) in range(7, src)
	..()

/*
 * Subtypes
 */

/obj/effect/temporary_effect/pulse/snake/flamestrike
	name = "fiery shockwave"

	total_turf_memory = 8
	pulses_remaining = 8
	pulse_delay = 0.2 SECONDS

/obj/effect/temporary_effect/pulse/snake/flamestrike/on_leave_turf(var/turf/T)
	if(T)
		new /obj/effect/temporary_effect/eruption/flamestrike(T, 1.2 SECONDS, "#f75000")
