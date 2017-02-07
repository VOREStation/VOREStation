// This doesn't inherit from /outdoors/ so that the pool can use it as well.
/turf/simulated/floor/water
	name = "shallow water"
	desc = "A body of water.  It seems shallow enough to walk through, if needed."
	icon = 'icons/turf/outdoors.dmi'
	icon_state = "water_shallow"
	var/under_state = "rockwall"
	edge_blending_priority = -1
	movement_cost = 4
	outdoors = TRUE
	var/movement_message = "You are slowed considerably from the water as you move across it." // Displayed to mobs crossing from one water tile to another.
	var/depth = 1 // Higher numbers indicates deeper water.

/turf/simulated/floor/water/New()
	update_icon()
	..()

/turf/simulated/floor/water/update_icon()
//	icon_state = "rockwall"
	..() // To get the edges.  This also gets rid of other overlays so it needs to go first.
//	var/image/water_sprite = image(icon = 'icons/turf/outdoors.dmi', icon_state = "water_shallow", layer = FLOAT_LAYER - 0.1) // Layer is slightly lower so that the adjacent edges go over the water.
	var/image/floorbed_sprite = image(icon = 'icons/turf/outdoors.dmi', icon_state = under_state)
	//water_sprite.alpha = 150
	underlays.Add(floorbed_sprite)
	update_icon_edge()

/turf/simulated/floor/water/get_edge_icon_state()
	return "water_shallow"

/turf/simulated/floor/water/return_air_for_internal_lifeform(var/mob/living/L)
	if(L && L.lying)
		if(L.can_breathe_water())
			var/datum/gas_mixture/water_breath = new()
			var/amount = (ONE_ATMOSPHERE * BREATH_VOLUME) / (R_IDEAL_GAS_EQUATION * T20C)
			water_breath.adjust_gas("oxygen", amount) // Assuming water breathes just extract the oxygen directly from the water.
			return water_breath
		else
			return null // Lying down means they're submerged, which means no air.
	return return_air() // Otherwise their head is above the water, so get the air from the atmosphere instead.

/turf/simulated/floor/water/Entered(atom/movable/AM, atom/oldloc)
	if(istype(AM, /mob/living))
		var/mob/living/L = AM
		L.adjust_fire_stacks(-50)
		L.update_water()
		if(!istype(oldloc, /turf/simulated/floor/water))
			to_chat(L, "<span class='warning'>You get drenched in water from entering \the [src]!</span>")
		else
			to_chat(L, "<span class='warning'>[movement_message]</span>")
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
/mob/living/proc/can_breathe_water()
	return FALSE

/mob/living/carbon/human/can_breathe_water()
	if(species && species.name == "Skrell")
		return TRUE
	return ..()

/mob/living/proc/check_submerged()
	var/turf/simulated/floor/water/T = loc
	if(istype(T))
		return T.depth
	return 0