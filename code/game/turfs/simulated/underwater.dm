
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
	if(isliving(AM))
		var/mob/living/L = AM
		L.update_water()
		if(L.check_submerged() <= 0)
			return
		if(!istype(oldloc, /turf/simulated/floor/water/underwater))
			to_chat(L, span_warning("You get drenched in water from entering \the [src]!"))
	AM.water_act(5)
	..()

/turf/simulated/floor/water/underwater/Exited(atom/movable/AM, atom/newloc)
	if(isliving(AM))
		var/mob/living/L = AM
		L.update_water()
		if(L.check_submerged() <= 0)
			return
		if(!istype(newloc, /turf/simulated/floor/water/underwater))
			to_chat(L, span_warning("You climb out of \the [src]."))
	..()

/turf/simulated/floor/water/deep/ocean/diving

/turf/simulated/floor/water/deep/ocean/diving/CanZPass(atom, direction)
	return TRUE

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

/turf/simulated/floor/water/underwater/rocks
	icon_state = "rock"

/turf/simulated/floor/water/underwater/open
	icon = 'icons/effects/weather.dmi'
	icon_state = "underwater-indoors" // Just looks underwater in the map editor, will be invisible once ingame
	name = "deeper waters"
	desc = "The watery depths seem to go even deeper here."

/turf/simulated/floor/water/underwater/open/update_icon()
	. = ..()
	icon = 'icons/turf/open_space.dmi'
	icon_state = "black_open_lighter"

/turf/simulated/floor/water/underwater/open/LateInitialize()
	. = ..()
	AddElement(/datum/element/turf_z_transparency, FALSE)

/turf/simulated/floor/water/underwater/open/CanZPass(atom/A, direction, recursive)
	return TRUE

/turf/simulated/floor/water/underwater/open/handle_water_icons()
	// We'll rely on the turfs below for water visuals!
	SHOULD_CALL_PARENT(FALSE)
	var/atom/movable/weather_visuals/visuals = new(null)
	visuals.icon = 'icons/effects/weather.dmi'
	visuals.icon_state = "underwater"
	vis_contents += visuals

// Indoors variants that do not use outdoor lighting, and must re-add water overlay icons since they won't be relying on the weather system to do it!

/turf/simulated/floor/water/underwater/indoors
	outdoors = OUTDOORS_NO
	var/overlay_icon = 'icons/effects/weather.dmi'
	var/overlay_state = "underwater-indoors"
	var/atom/movable/weather_visuals/visuals

/turf/simulated/floor/water/underwater/indoors/handle_water_icons()
	SHOULD_CALL_PARENT(FALSE)
	var/atom/movable/weather_visuals/visuals = new(null)
	visuals.icon = overlay_icon
	visuals.icon_state = overlay_state
	vis_contents += visuals

/turf/simulated/floor/water/underwater/indoors/open
	icon = 'icons/effects/weather.dmi'
	icon_state = "underwater-indoors" // Just looks underwater in the map editor, will be invisible once ingame
	name = "deeper waters"
	desc = "The watery depths seem to go even deeper here."

/turf/simulated/floor/water/underwater/indoors/open/LateInitialize()
	. = ..()
	AddElement(/datum/element/turf_z_transparency, FALSE)

/turf/simulated/floor/water/underwater/indoors/open/update_icon()
	. = ..()
	icon = 'icons/turf/open_space.dmi'
	icon_state = "black_open_lighter"

/turf/simulated/floor/water/underwater/indoors/open/CanZPass(atom/A, direction, recursive)
	return TRUE

/turf/simulated/floor/water/underwater/indoors/cult
	icon = 'icons/turf/flooring/cult.dmi'
	icon_state = "cult"

/turf/simulated/floor/water/underwater/indoors/ruins
	icon = 'maps/redgate/falls/icons/turfs/marble.dmi'
	icon_state = "1"

/turf/simulated/floor/water/underwater/indoors/sand
	icon = 'icons/misc/beach.dmi'
	icon_state = "sand"

/turf/simulated/floor/water/underwater/indoors/wood
	icon = 'icons/turf/flooring/wood_vr.dmi'
	icon_state = "wood"

/turf/simulated/floor/water/underwater/indoors/woodbroken
	icon = 'icons/turf/flooring/wood_vr.dmi'
	icon_state = "wood-broken0"

/turf/simulated/floor/water/underwater/indoors/rocks
	icon_state = "rock"

/turf/simulated/floor/water/underwater/indoors/rocks/vis_hide
	flags = TURF_ACID_IMMUNE | VIS_HIDE
