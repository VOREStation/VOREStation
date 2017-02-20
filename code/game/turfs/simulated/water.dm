// This doesn't inherit from /outdoors/ so that the pool can use it as well.
/turf/simulated/floor/water
	name = "shallow water"
	desc = "A body of water.  It seems shallow enough to walk through, if needed."
	icon = 'icons/turf/outdoors.dmi'
	icon_state = "water_shallow"
	var/under_state = "rock"
	edge_blending_priority = -1
	movement_cost = 4
	outdoors = TRUE
	var/movement_message = "You are slowed considerably from the water as you move across it." // Displayed to mobs crossing from one water tile to another.
	var/depth = 1 // Higher numbers indicates deeper water.

/turf/simulated/floor/water/New()
	update_icon()
	..()

/turf/simulated/floor/water/update_icon()
	..() // To get the edges.  This also gets rid of other overlays so it needs to go first.
	var/image/floorbed_sprite = image(icon = 'icons/turf/outdoors.dmi', icon_state = under_state)
	underlays.Add(floorbed_sprite)
	update_icon_edge()

/turf/simulated/floor/water/get_edge_icon_state()
	return "water_shallow"

/turf/simulated/floor/water/return_air_for_internal_lifeform(var/mob/living/L)
	if(L && L.lying)
		if(L.can_breathe_water()) // For squid.
			var/datum/gas_mixture/water_breath = new()
			var/datum/gas_mixture/above_air = return_air()
			var/amount = 300
			water_breath.adjust_gas("oxygen", amount) // Assuming water breathes just extract the oxygen directly from the water.
			water_breath.temperature = above_air.temperature
			return water_breath
		else
			return null // Lying down means they're submerged, which means no air.
	return return_air() // Otherwise their head is above the water, so get the air from the atmosphere instead.

/turf/simulated/floor/water/Entered(atom/movable/AM, atom/oldloc)
	if(istype(AM, /mob/living))
		var/mob/living/L = AM
		L.update_water()
		if(!istype(oldloc, /turf/simulated/floor/water))
			to_chat(L, "<span class='warning'>You get drenched in water from entering \the [src]!</span>")
		else
			to_chat(L, "<span class='warning'>[movement_message]</span>")
	AM.water_act(5)
	..()

/turf/simulated/floor/water/Exited(atom/movable/AM, atom/newloc)
	if(istype(AM, /mob/living))
		var/mob/living/L = AM
		L.update_water()
		if(!istype(newloc, /turf/simulated/floor/water))
			to_chat(L, "<span class='warning'>You climb out of \the [src].</span>")
	..()

/turf/simulated/floor/water/deep
	name = "deep water"
	desc = "A body of water.  It seems quite deep."
//	icon_state = "seadeep" // So it shows up in the map editor as water.
	under_state = "abyss"
	edge_blending_priority = -2
	movement_cost = 8
	movement_message = "You swim forwards."
	depth = 2

/*
/turf/simulated/floor/water/deep/update_icon()
	..() // To get the edges.  This also gets rid of other overlays so it needs to go first.
	icon_state = "abyss"
*/

/turf/simulated/floor/water/pool
	name = "pool"
	desc = "Don't worry, it's not closed."
	under_state = "pool"
	outdoors = FALSE

/mob/living/proc/can_breathe_water()
	return FALSE

/mob/living/carbon/human/can_breathe_water()
	if(species)
		return species.can_breathe_water()
	return ..()

/mob/living/proc/check_submerged()
	var/turf/simulated/floor/water/T = loc
	if(istype(T))
		return T.depth
	return 0

// Use this to have things react to having water applied to them.
/atom/movable/proc/water_act(amount)
	return

/mob/living/water_act(amount)
	adjust_fire_stacks(amount * 5)
	for(var/atom/movable/AM in contents)
		AM.water_act(amount)