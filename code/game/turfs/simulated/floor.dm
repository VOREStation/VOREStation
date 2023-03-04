/turf/simulated/floor
	name = "plating"
	desc = "Unfinished flooring."
	icon = 'icons/turf/flooring/plating_vr.dmi'
	icon_state = "plating"

	// Damage to flooring.
	var/broken
	var/burnt

	// Plating data.
	var/base_name = "plating"
	var/base_desc = "The naked hull."
	var/base_icon = 'icons/turf/flooring/plating_vr.dmi'
	var/base_icon_state = "plating"
	var/static/list/base_footstep_sounds = list("human" = list(
		'sound/effects/footstep/plating1.ogg',
		'sound/effects/footstep/plating2.ogg',
		'sound/effects/footstep/plating3.ogg',
		'sound/effects/footstep/plating4.ogg',
		'sound/effects/footstep/plating5.ogg'))
	var/list/old_decals = null

	// Flooring data.
	var/flooring_override
	var/initial_flooring
	var/decl/flooring/flooring
	var/mineral = DEFAULT_WALL_MATERIAL
	var/can_be_plated = TRUE // This is here for inheritance's sake. Override to FALSE for turfs you don't want someone to simply slap a plating over such as hazards.

	thermal_conductivity = 0.040
	heat_capacity = 10000

	/// Measures how thick the snow on this turf is.
	/// Currently this is an arbitrary number; anything higher than 2 isn't meaningful. 0 means there's no snow.
	/// A turf whose `snow_layers` is `NEVER_HAS_SNOW` cannot accrue snow.
	/// Check `__defines/turfs.dm` for relevant defines.
	var/snow_layers = SNOW_NONE
	/// When characters walk over snowy floors, they leave footprints (see Entered()). This list holds those footprints and gets read when updating the icon.
	var/list/snow_footprints

/turf/simulated/floor/is_plating()
	return (!flooring || flooring.is_plating)

/turf/simulated/floor/get_movement_cost()
	return max(movement_cost, clamp(snow_layers, SNOW_NONE, SNOW_HEAVY))

/turf/simulated/floor/Entered(atom/A, atom/OL)
	. = ..()
	if(isliving(A) && has_snow())
		var/mob/living/L = A
		var/footprint_state = L.get_snow_footprint_state()
		if(!footprint_state)
			return
		var/mdir = "[A.dir]"
		LAZYSET(snow_footprints, mdir, footprint_state)
		update_icon(TRUE)

/turf/simulated/floor/Initialize(mapload, floortype)
	. = ..()
	if(!floortype && initial_flooring)
		floortype = initial_flooring
	if(floortype)
		set_flooring(get_flooring_data(floortype), TRUE)
		refresh_snow(FALSE)
		. = INITIALIZE_HINT_LATELOAD // We'll update our icons after everyone is ready
	else
		footstep_sounds = base_footstep_sounds
	if(can_dirty && can_start_dirty)
		if(prob(dirty_prob))
			dirt += rand(50,100)
			update_dirt() //5% chance to start with dirt on a floor tile- give the janitor something to do

/turf/simulated/floor/LateInitialize()
	. = ..()
	update_icon(TRUE)

/// Increases the number of snow layers on this turf by `amt`. Negative values decrease instead.
/turf/simulated/floor/proc/adjust_snow(amt)
	if (snow_layers <= NEVER_HAS_SNOW || amt == 0)
		return
	snow_layers = max(SNOW_NONE, snow_layers + amt)
	refresh_snow()

/// Sets the number of snow layers on this turf to be equal to `amt`.
/turf/simulated/floor/proc/set_snow(amt)
	if (snow_layers <= NEVER_HAS_SNOW || snow_layers == amt)
		return
	snow_layers = max(SNOW_NONE, amt)
	refresh_snow()

/// Checks whether or not this turf has snow layers equal to `amt`.
/// `amt` defaults to `SNOW_LIGHT`, meaning that running the proc with no arguments
/// will check if the turf has any snow at all.
/turf/simulated/floor/proc/has_snow(amt = SNOW_LIGHT)
	return snow_layers >= amt

/turf/simulated/floor/proc/refresh_snow(do_icon_update = TRUE)
	if (has_snow())
		edge_blending_priority = 6
	else
		edge_blending_priority = initial(edge_blending_priority)
	refresh_footstep_sounds()
	if (do_icon_update)
		update_icon(TRUE)

/turf/simulated/floor/proc/refresh_footstep_sounds()
	if (has_snow())
		var/decl/flooring/snow = GET_DECL(/decl/flooring/snow)
		footstep_sounds = snow?.footstep_sounds
	else if (flooring)
		footstep_sounds = flooring.footstep_sounds
	else
		footstep_sounds = base_footstep_sounds

/turf/simulated/floor/proc/swap_decals()
	var/current_decals = decals
	decals = old_decals
	old_decals = current_decals

/turf/simulated/floor/proc/set_flooring(var/decl/flooring/newflooring, var/initializing)
	//make_plating(defer_icon_update = 1)
	if(is_plating() && !initializing) // Plating -> Flooring
		swap_decals()
	flooring = newflooring
	refresh_footstep_sounds()
	if(!initializing)
		update_icon(1)
	levelupdate()

//This proc will set floor_type to null and the update_icon() proc will then change the icon_state of the turf
//This proc auto corrects the grass tiles' siding.
/turf/simulated/floor/proc/make_plating(var/place_product, var/defer_icon_update)
	cut_overlays()

	for(var/obj/effect/decal/writing/W in src)
		qdel(W)

	name = base_name
	desc = base_desc
	icon = base_icon
	icon_state = base_icon_state
	footstep_sounds = base_footstep_sounds

	if(!is_plating()) // Flooring -> Plating
		swap_decals()
		if(flooring.build_type && place_product)
			new flooring.build_type(src)
		var/newtype = flooring.get_plating_type()
		if(newtype) // Has a custom plating type to become
			set_flooring(get_flooring_data(newtype))
		else
			flooring = null

	set_light(0)
	broken = null
	burnt = null
	flooring_override = null
	levelupdate()

	if(!defer_icon_update)
		update_icon(1)

/turf/simulated/floor/levelupdate()
	var/floored_over = !is_plating()
	for(var/obj/O in src)
		O.hide(O.hides_under_flooring() && floored_over)

/turf/simulated/floor/can_engrave()
	return (!flooring || flooring.can_engrave)

/turf/simulated/floor/rcd_values(mob/living/user, obj/item/weapon/rcd/the_rcd, passed_mode)
	switch(passed_mode)
		if(RCD_FLOORWALL)
			// A wall costs four sheets to build (two for the grider and two for finishing it).
			var/cost = RCD_SHEETS_PER_MATTER_UNIT * 4
			// R-walls cost five sheets, however.
			if(the_rcd.make_rwalls)
				cost += RCD_SHEETS_PER_MATTER_UNIT * 1
			return list(
				RCD_VALUE_MODE = RCD_FLOORWALL,
				RCD_VALUE_DELAY = 2 SECONDS,
				RCD_VALUE_COST = cost
			)
		if(RCD_AIRLOCK)
			// Airlock assemblies cost four sheets. Let's just add another for the electronics/wires/etc.
			return list(
				RCD_VALUE_MODE = RCD_AIRLOCK,
				RCD_VALUE_DELAY = 5 SECONDS,
				RCD_VALUE_COST = RCD_SHEETS_PER_MATTER_UNIT * 5
			)
		if(RCD_WINDOWGRILLE)
			// One steel sheet for the girder (two rods, which is one sheet).
			return list(
				RCD_VALUE_MODE = RCD_WINDOWGRILLE,
				RCD_VALUE_DELAY = 1 SECOND,
				RCD_VALUE_COST = RCD_SHEETS_PER_MATTER_UNIT * 1
			)
		if(RCD_DECONSTRUCT)
			// Old RCDs made deconning the floor cost 10 units (IE, three times on full RCD).
			// Now it's ten sheets worth of units (which is the same capacity-wise, three times on full RCD).
			return list(
				RCD_VALUE_MODE = RCD_DECONSTRUCT,
				RCD_VALUE_DELAY = 5 SECONDS,
				RCD_VALUE_COST = RCD_SHEETS_PER_MATTER_UNIT * 10
			)
	return FALSE


/turf/simulated/floor/rcd_act(mob/living/user, obj/item/weapon/rcd/the_rcd, passed_mode)
	switch(passed_mode)
		if(RCD_FLOORWALL)
			to_chat(user, span("notice", "You build a wall."))
			ChangeTurf(/turf/simulated/wall)
			var/turf/simulated/wall/T = get_turf(src) // Ref to the wall we just built.
			// Apparently set_material(...) for walls requires refs to the material singletons and not strings.
			// This is different from how other material objects with their own set_material(...) do it, but whatever.
			var/datum/material/M = name_to_material[the_rcd.material_to_use]
			T.set_material(M, the_rcd.make_rwalls ? M : null, M)
			T.add_hiddenprint(user)
			return TRUE
		if(RCD_AIRLOCK)
			if(locate(/obj/machinery/door/airlock) in src)
				return FALSE // No more airlock stacking.
			to_chat(user, span("notice", "You build an airlock."))
			new the_rcd.airlock_type(src)
			return TRUE
		if(RCD_WINDOWGRILLE)
			if(locate(/obj/structure/grille) in src)
				return FALSE
			to_chat(user, span("notice", "You construct the grille."))
			var/obj/structure/grille/G = new(src)
			G.anchored = TRUE
			return TRUE
		if(RCD_DECONSTRUCT)
			to_chat(user, span("notice", "You deconstruct \the [src]."))
			ChangeTurf(get_base_turf_by_area(src), preserve_outdoors = TRUE)
			return TRUE

/turf/simulated/floor/AltClick(mob/user)
	if(isliving(user))
		var/mob/living/livingUser = user
		if(try_graffiti(livingUser, livingUser.get_active_hand()))
			return
	. = ..()