/obj/effect/landmark/floorbreak
	name = "Floor Breaker"
	icon_state = "floorbreaker"
	delete_me = FALSE //just to be sure

/obj/effect/landmark/floorbreak/Initialize(mapload)
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/landmark/floorbreak/LateInitialize()
	if(istype(src.loc, /turf/simulated/floor))
		var/turf/simulated/floor/our_turf = src.loc
		our_turf.break_tile()
	else
		log_world("Floor Breaker at [src.loc.x] / [src.loc.y] was somehow placed in a non-turf location, or placed on an unsimulated or non-floor turf (e.g. wall, open space).")
	qdel(src)
