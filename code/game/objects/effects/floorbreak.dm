/obj/effect/floorbreak
	name = "Floor Breaker"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "floorbreaker"

/obj/effect/floorbreak/Initialize(mapload)
	. = ..()
	if(!istype(src.loc, /turf/simulated/floor))
		log_world("Floor Breaker at X: [src.loc.x], Y: [src.loc.y] was somehow placed in a non-turf location, or placed on an unsimulated turf, non-floor turf, or other invalid location (e.g. wall, open space, inside a container).")
		return INITIALIZE_HINT_QDEL
	return INITIALIZE_HINT_LATELOAD

/obj/effect/floorbreak/LateInitialize()
	var/turf/simulated/floor/our_turf = src.loc
	our_turf.break_tile()
	qdel(src)
