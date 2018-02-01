// This causes tether submap maps to get 'checked' and compiled, when undergoing a unit test.
// This is so Travis can validate PoIs, and ensure future changes don't break PoIs, as PoIs are loaded at runtime and the compiler can't catch errors.
//Away missions defined here for testing


/datum/map_template/tether_lateload
	allow_duplicates = FALSE

/// Static - Always Loaded
/datum/map_template/tether_lateload/tether_ships
	name = "Tether - Ships"
	desc = "Ship transit map and whatnot."
	mappath = 'tether_ships.dmm'

/obj/effect/step_trigger/zlevel_fall/initialize()
	. = ..()

	if(istype(get_turf(src), /turf/simulated/floor))
		src:target_z = z
		qdel(src)

/obj/effect/step_trigger/zlevel_fall/Trigger(var/atom/movable/A) //mostly from /obj/effect/step_trigger/teleporter/planetary_fall, step_triggers.dm L160
	var/attempts = 100
	var/turf/simulated/T
	while(attempts && !T)
		var/turf/simulated/candidate = locate(rand(5,world.maxx-5),rand(5,world.maxy-5),src:target_z)
		if(candidate.density)
			attempts--
			continue

		T = candidate
		break

	if(!T)
		message_admins("ERROR: planetary_fall step trigger could not find a suitable landing turf.")
		return

	if(isobserver(A))
		A.forceMove(T) // Harmlessly move ghosts.
		return

	if(isliving(A)) // Someday, implement parachutes.  For now, just turbomurder whoever falls.
		var/mob/living/L = A
		L.fall_impact(T, 42, 90, FALSE, TRUE)	//You will not be defibbed from this.
	message_admins("\The [A] fell out of the sky.")
	A.forceMove(T)

/obj/effect/step_trigger/zlevel_fall/beach
	var/static/target_z


/// Away Missions
#if AWAY_MISSION_TEST
#include "beach/beach.dmm"
#include "beach/cave.dmm"
#endif

#include "beach/beach.dm"
/datum/map_template/tether_lateload/away_beach
	name = "Desert Planet - Z1 Beach"
	desc = "The beach away mission."
	mappath = 'beach/beach.dmm'
/datum/map_template/tether_lateload/away_beach_cave
	name = "Desert Planet - Z2 Cave"
	desc = "The beach away mission's cave."
	mappath = 'beach/cave.dmm'

#include "alienship/alienship.dm"
/datum/map_template/tether_lateload/away_alienship
	name = "Alien Ship - Z1 Ship"
	desc = "The alien ship away mission."
	mappath = 'alienship/alienship.dmm'
