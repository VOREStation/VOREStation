
/obj/effect/decal/cleanable/chempuddle
	name = "puddle"
	icon = 'icons/effects/chempuddle.dmi'
	icon_state = "puddle"

	mouse_opacity = FALSE

/obj/effect/decal/cleanable/chempuddle/Initialize()
	. = ..()

	create_reagents(100)

	addtimer(CALLBACK(src, .proc/evaporation_pulse), 10 SECONDS)

/obj/effect/decal/cleanable/chempuddle/Destroy()
	var/turf/T = get_turf(src)

	. = ..()

	for(var/obj/effect/decal/cleanable/chempuddle/CP in range(1, T))
		CP.update_icon(TRUE)

/obj/effect/decal/cleanable/chempuddle/proc/Spread(exclude=list())
	if(!reagents && !QDELETED(src))
		qdel(src)
		return

	if(reagents.total_volume < (25 * reagents.get_viscosity())) return
	var/turf/simulated/S = get_turf(src)
	if(!istype(S)) return

	exclude |= S

	var/list/possible_targets = list()
	for(var/d in cardinal)
		var/turf/simulated/target = get_step(src,d)
		var/turf/simulated/origin = get_turf(src)
		if(!(target in exclude))
			if((target in origin.AdjacentTurfs()))
				if(istype(target))
					possible_targets |= target

	if(LAZYLEN(possible_targets))
		while(possible_targets.len)
			var/turf/T = pick(possible_targets)	// Don't always go NORTH, please. It's kind of weird.

			var/obj/effect/decal/cleanable/chempuddle/other_puddle = locate() in T
			if(!istype(other_puddle))
				other_puddle = new(T)
			reagents.trans_to_holder(other_puddle.reagents, (reagents.total_volume - (25 * reagents.get_viscosity())) * (1 / possible_targets.len))
			possible_targets -= T
			other_puddle.Spread(exclude)

	if(reagents.total_volume)
		for(var/datum/reagent/current in reagents.reagent_list)
			current.touch_turf(S, current.volume / 4)
		reagents.update_total()

	update_icon()

/obj/effect/decal/cleanable/chempuddle/fire_act()	// Boil bubble toil and trouble. This will "evaporate" chems, and allow some to do their more dangerous effects, IE Fuel.
	. = ..()
	Spread()

/obj/effect/decal/cleanable/chempuddle/Crossed(atom/movable/AM, oldloc)
	Spread()	// Splashing through puddles can disturb them enough to spread them.
	. = ..()

	if(reagents.total_volume)
		reagents.touch(AM, max(min(3, reagents.total_volume),reagents.total_volume / 3))

/obj/effect/decal/cleanable/chempuddle/update_icon(var/recursion = FALSE)
	var/list/cardinals = list(NORTH,SOUTH,EAST,WEST)
	var/list/present_puddles = list()
	for(var/dir in cardinals)
		if(locate(/obj/effect/decal/cleanable/chempuddle) in get_step(src, dir))
			present_puddles |= dir

	if(LAZYLEN(present_puddles))
		icon_state = initial(icon_state)
		for(var/dir in present_puddles)
			icon_state += "-[dir]"

	if(!recursion)
		for(var/obj/effect/decal/cleanable/chempuddle/CP in range(1, src))
			CP.update_icon(TRUE)

	color = reagents.get_color()

/obj/effect/decal/cleanable/chempuddle/proc/evaporation_pulse()
	set waitfor = FALSE
	var/turf/T = get_turf(src)
	var/evaporation_rate = 1
	if(istype(T, /turf/space))
		evaporation_rate = 10

	else if(T.outdoors)
		evaporation_rate = 3

	if(T.temperature > T0C + 10)
		evaporation_rate *= 2

	reagents.remove_any(evaporation_rate)

	if(!reagents || reagents.total_volume <= 0)
		qdel(src)
		return

	Spread()
	addtimer(CALLBACK(src, .proc/evaporation_pulse), 10 SECONDS)
