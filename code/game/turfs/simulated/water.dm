// This doesn't inherit from /outdoors/ so that the pool can use it as well.
/turf/simulated/floor/water
	name = "shallow water"
	desc = "A body of water.  It seems shallow enough to walk through, if needed."
	icon = 'icons/turf/outdoors.dmi'
	icon_state = "seashallow" // So it shows up in the map editor as water.
	var/water_state = "water_shallow"
	var/under_state = "rock"
	edge_blending_priority = -1
	movement_cost = 4
	outdoors = OUTDOORS_YES
	flags = TURF_ACID_IMMUNE

	layer = WATER_FLOOR_LAYER

	can_dirty = FALSE	// It's water

	var/depth = 1 // Higher numbers indicates deeper water.

	var/reagent_type = "water"

/turf/simulated/floor/water/Initialize()
	. = ..()
	var/decl/flooring/F = get_flooring_data(/decl/flooring/water)
	footstep_sounds = F?.footstep_sounds
	update_icon()
	handle_fish()

/turf/simulated/floor/water/update_icon()
	..() // To get the edges.

	icon_state = under_state // This isn't set at compile time in order for it to show as water in the map editor.
	var/image/water_sprite = image(icon = 'icons/turf/outdoors.dmi', icon_state = water_state, layer = WATER_LAYER)
	add_overlay(water_sprite)

/turf/simulated/floor/water/get_edge_icon_state()
	return "water_shallow"

/turf/simulated/floor/water/attackby(obj/item/O as obj, mob/user as mob)
	var/obj/item/weapon/reagent_containers/RG = O
	if (istype(RG) && RG.is_open_container())
		RG.reagents.add_reagent(reagent_type, min(RG.volume - RG.reagents.total_volume, RG.amount_per_transfer_from_this))
		user.visible_message("<span class='notice'>[user] fills \the [RG] using \the [src].</span>","<span class='notice'>You fill \the [RG] using \the [src].</span>")
		return 1

	else if(istype(O, /obj/item/weapon/mop))
		O.reagents.add_reagent(reagent_type, 5)
		to_chat(user, "<span class='notice'>You wet \the [O] in \the [src].</span>")
		playsound(src, 'sound/effects/slosh.ogg', 25, 1)
		return 1

	else return ..()

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
			var/gasid = "carbon_dioxide"
			if(ishuman(L))
				var/mob/living/human/H = L
				if(H.species && H.species.exhale_type)
					gasid = H.species.exhale_type
			var/datum/gas_mixture/water_breath = new()
			var/datum/gas_mixture/above_air = return_air()
			water_breath.adjust_gas(gasid, BREATH_MOLES) // They have no oxygen, but non-zero moles and temp
			water_breath.temperature = above_air.temperature
			return water_breath
	return return_air() // Otherwise their head is above the water, so get the air from the atmosphere instead.

/turf/simulated/floor/water/Entered(atom/movable/AM, atom/oldloc)
	if(istype(AM, /mob/living))
		var/mob/living/L = AM
		L.update_water()
		if(L.check_submerged() <= 0)
			return
		if(!istype(oldloc, /turf/simulated/floor/water))
			to_chat(L, "<span class='warning'>You get drenched in water from entering \the [src]!</span>")
	AM.water_act(5)
	..()

/turf/simulated/floor/water/Exited(atom/movable/AM, atom/newloc)
	if(istype(AM, /mob/living))
		var/mob/living/L = AM
		L.update_water()
		if(L.check_submerged() <= 0)
			return
		if(!istype(newloc, /turf/simulated/floor/water))
			to_chat(L, "<span class='warning'>You climb out of \the [src].</span>")
	..()

/turf/simulated/floor/water/deep
	name = "deep water"
	desc = "A body of water.  It seems quite deep."
	icon_state = "seadeep" // So it shows up in the map editor as water.
	under_state = "abyss"
	edge_blending_priority = -2
	movement_cost = 8
	depth = 2
	special_temperature = T0C - 5.5 //as cool as the atmosphere outside, if someone asks, its the phoron solved in the water that stops the freezing

/turf/simulated/floor/water/pool
	name = "pool"
	desc = "Don't worry, it's not closed."
	under_state = "pool"
	outdoors = OUTDOORS_NO

/turf/simulated/floor/water/deep/pool
	name = "deep pool"
	desc = "Don't worry, it's not closed."
	outdoors = OUTDOORS_NO

/mob/living/proc/can_breathe_water()
	return FALSE

/mob/living/human/can_breathe_water()
	if(species)
		return species.can_breathe_water()
	return ..()

/mob/living/proc/check_submerged()
	if(buckled)
		return 0
	if(hovering)
		return 0
	if(locate(/obj/structure/catwalk) in loc)
		return 0
	var/turf/simulated/floor/water/T = loc
	if(istype(T))
		return T.depth
	return 0

// Use this to have things react to having water applied to them.
/atom/movable/proc/water_act(amount)
	return

/mob/living/water_act(amount)
	adjust_fire_stacks(-amount * 5)
	for(var/atom/movable/AM in contents)
		AM.water_act(amount)
	remove_modifiers_of_type(/datum/modifier/fire)
	inflict_water_damage(20 * amount) // Only things vulnerable to water will actually be harmed (slimes/prommies).

var/list/shoreline_icon_cache = list()

/turf/simulated/floor/water/beach
	name = "beach shoreline"
	desc = "The waves look calm and inviting."
	icon_state = "beach"
	depth = 0

/turf/simulated/floor/water/beach/update_icon()
	return

/turf/simulated/floor/water/beach/corner
	icon_state = "beachcorner"

/turf/simulated/floor/water/shoreline
	name = "shoreline"
	desc = "The waves look calm and inviting."
	icon_state = "shoreline"
	water_state = "rock" // Water gets generated as an overlay in update_icon()
	depth = 0

/turf/simulated/floor/water/shoreline/corner
	icon_state = "shorelinecorner"

// Water sprites are really annoying, so let BYOND sort it out.
/turf/simulated/floor/water/shoreline/update_icon()
	underlays.Cut()
	cut_overlays()
	..() // Get the underlay first.
	var/cache_string = "[initial(icon_state)]_[water_state]_[dir]"
	if(cache_string in shoreline_icon_cache) // Check to see if an icon already exists.
		add_overlay(shoreline_icon_cache[cache_string])
	else // If not, make one, but only once.
		var/icon/shoreline_water = icon(src.icon, "shoreline_water", src.dir)
		var/icon/shoreline_subtract = icon(src.icon, "[initial(icon_state)]_subtract", src.dir)
		shoreline_water.Blend(shoreline_subtract,ICON_SUBTRACT)
		var/image/final = image(shoreline_water)
		final.layer = WATER_LAYER

		shoreline_icon_cache[cache_string] = final
		add_overlay(shoreline_icon_cache[cache_string])

/turf/simulated/floor/water/is_safe_to_enter(mob/living/L)
	if(L.get_water_protection() < 1)
		return FALSE
	return ..()

/turf/simulated/floor/water/contaminated
	desc = "This water smells pretty acrid."
	var/poisonlevel = 10

/turf/simulated/floor/water/contaminated/Entered(atom/movable/AM, atom/oldloc)
	..()
	if(istype(AM, /mob/living))
		var/mob/living/L = AM
		if(L.isSynthetic())
			return
		poisonlevel *= 1 - L.get_water_protection()
		if(poisonlevel > 0)
			L.adjustToxLoss(poisonlevel)