/turf/simulated/floor/water/underwater
	name = "sea floor"
	desc = "It's the bottom of the sea, there's water all over the place!"
	icon = 'icons/turf/outdoors.dmi'
	icon_state = "seafloor" // So it shows up in the map editor as water.
	water_state = "seafloor"
	edge_blending_priority = -1
	movement_cost = 4
	can_be_plated = FALSE
	outdoors = OUTDOORS_YES
	flags = TURF_ACID_IMMUNE

	can_dirty = FALSE	// It's water

	depth = 10 // Higher numbers indicates deeper water, 10 is unused right now, but may be useful for adding effects in the future.

	reagent_type = REAGENT_ID_WATER

/turf/simulated/floor/water/underwater/return_air_for_internal_lifeform(var/mob/living/L)
	if(L.can_breathe_water()) // For squid.
		var/datum/gas_mixture/water_breath = new()
		var/datum/gas_mixture/above_air = return_air()
		var/amount = 300
		water_breath.adjust_gas(GAS_O2, amount) // Assuming water breathes just extract the oxygen directly from the water.
		water_breath.temperature = above_air.temperature
		return water_breath
	else
		var/gasid = GAS_CO2
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			if(H.species && H.species.exhale_type)
				gasid = H.species.exhale_type
		var/datum/gas_mixture/water_breath = new()
		var/datum/gas_mixture/above_air = return_air()
		water_breath.adjust_gas(gasid, BREATH_MOLES) // They have no oxygen, but non-zero moles and temp
		water_breath.temperature = above_air.temperature
		return water_breath

/turf/simulated/floor/water/underwater/Entered(atom/movable/AM, atom/oldloc)
	if(istype(AM, /mob/living))
		var/mob/living/L = AM
		L.update_water()
		if(L.check_submerged() <= 0)
			return
		if(!istype(oldloc, /turf/simulated/floor/water/underwater))
			to_chat(L, span_warning("You get drenched in water from entering \the [src]!"))
	AM.water_act(5)
	..()

/turf/simulated/floor/water/underwater/Exited(atom/movable/AM, atom/newloc)
	if(istype(AM, /mob/living))
		var/mob/living/L = AM
		L.update_water()
		if(L.check_submerged() <= 0)
			return
		if(!istype(newloc, /turf/simulated/floor/water/underwater))
			to_chat(L, span_warning("You climb out of \the [src]."))
	..()

/turf/simulated/floor/water/deep/ocean/diving

/turf/simulated/floor/water/deep/ocean/diving/CanZPass(atom, direction)
	return 1

//Variations of underwater icons

/turf/simulated/floor/water/underwater/cult
	icon = 'icons/turf/flooring/cult.dmi'
	icon_state = "cult" // So it shows up in the map editor as water.
	water_icon = 'icons/turf/flooring/cult.dmi'
	water_state = "cult"

/turf/simulated/floor/water/underwater/ruins
	icon = 'maps/redgate/falls/icons/turfs/marble.dmi'
	icon_state = "1" // So it shows up in the map editor as water.
	water_icon = 'maps/redgate/falls/icons/turfs/marble.dmi'
	water_state = "1"

/turf/simulated/floor/water/underwater/sand
	icon = 'icons/misc/beach.dmi'
	icon_state = "sand" // So it shows up in the map editor as water.
	water_icon = 'icons/misc/beach.dmi'
	water_state = "sand"

/turf/simulated/floor/water/underwater/wood
	icon = 'icons/turf/flooring/wood_vr.dmi'
	icon_state = "wood" // So it shows up in the map editor as water.
	water_icon = 'icons/turf/flooring/wood_vr.dmi'
	water_state = "wood"

/turf/simulated/floor/water/underwater/woodbroken
	icon = 'icons/turf/flooring/wood_vr.dmi'
	icon_state = "wood-broken0" // So it shows up in the map editor as water.
	water_icon = 'icons/turf/flooring/wood_vr.dmi'
	water_state = "wood-broken0"
