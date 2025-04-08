/turf/New(loc, ..., is_turfchange=FALSE)
	. = ..(args)

/turf/simulated
	var/datum/sunlight_handler/shandler
	var/shandler_noinit = FALSE

/turf/simulated/New(loc, ..., is_turfchange=FALSE) //This is so fucking awful have mercy on my soul for writing this
	if(is_turfchange)
		shandler_noinit = TRUE
	. = ..(args)

/turf/simulated/Initialize(mapload)
	. = ..(args)
	if(mapload)
		return INITIALIZE_HINT_LATELOAD

/turf/simulated/LateInitialize()
	if(((SSplanets && SSplanets.z_to_planet.len >= z && SSplanets.z_to_planet[z]) || SSlighting.get_pshandler_z(z)) && has_dynamic_lighting()) //Only for planet turfs or fakesuns that specify they want to use this system
		if(is_outdoors())
			var/turf/T = GetAbove(src)
			if(T && !isopenturf(T) && (SSplanets.z_to_planet.len >= T.z && SSplanets.z_to_planet[T.z]))
				make_indoors()
		if(!shandler_noinit)
			shandler = new(src)
			shandler.manualInit()

/turf/simulated/lighting_build_overlay()
	..()
	if(shandler)
		shandler.only_sun_object = lighting_object

/datum/sunlight_handler
	var/datum/simple_sun/sun
	var/turf/simulated/holder
	var/datum/lighting_object/only_sun_object
	var/effect_str_r = 0
	var/effect_str_g = 0
	var/effect_str_b = 0
	//agony but necessary for memory optimization
	var/datum/lighting_corner/affected_NE
	var/datum/lighting_corner/affected_NW
	var/datum/lighting_corner/affected_SW
	var/datum/lighting_corner/affected_SE
	var/datum/lighting_corner/only_sun_NE
	var/datum/lighting_corner/only_sun_NW
	var/datum/lighting_corner/only_sun_SW
	var/datum/lighting_corner/only_sun_SE
	var/sunlight = FALSE
	var/inherited = FALSE
	var/datum/planet_sunlight_handler/pshandler
	var/sleeping = FALSE

/datum/sunlight_handler/New(var/parent)
	. = ..()
	holder = parent

//Moved initialization here to make sure that it doesn't happen too early when replacing turfs.
/datum/sunlight_handler/proc/manualInit()
	if(!holder.lighting_corners_initialised)
		GENERATE_MISSING_CORNERS(holder)
	var/corners = list(holder.lighting_corner_NE,holder.lighting_corner_NW,holder.lighting_corner_SE,holder.lighting_corner_SW)
	for(var/datum/lighting_corner/corner in corners)
		if(corner.sunlight == SUNLIGHT_NONE)
			corner.sunlight = SUNLIGHT_POSSIBLE
	try_get_sun()
	sunlight_check()

/datum/sunlight_handler/proc/holder_change()
	GENERATE_MISSING_CORNERS(holder) //Somehow corners are self destructing under specific circumstances. Likely race conditions. This is slightly unoptimal but may be necessary.
	sunlight_check() //Also not optimal but made necessary by race conditions
	sunlight_update()
	for(var/dir in (cardinal + cornerdirs))
		var/turf/simulated/T = get_step(holder, dir)
		if(istype(T) && T.shandler)
			T.shandler.sunlight_update()
	sunlight_update()
	//Might seem silly and unoptimized to call update twice, but this is not called frequently and it makes things easier.
	//Logical flow goes:
	//Update 1: Disowns the lighting corner
	//Update surrounding turfs: Allows for corner to be claimed by other sunlight handler
	//Update 2: Accounts for changes made by surrounding turfs

/datum/sunlight_handler/proc/get_affected_list()
	var/list/affected = list()
	if(affected_NE) affected += affected_NE
	if(affected_NW) affected += affected_NW
	if(affected_SW) affected += affected_SW
	if(affected_SE) affected += affected_SE
	return affected

/datum/sunlight_handler/proc/add_to_affected(var/datum/lighting_corner/corner)
	if(holder.lighting_corner_NE == corner)
		affected_NE = corner
		return
	if(holder.lighting_corner_NW == corner)
		affected_NW = corner
		return
	if(holder.lighting_corner_SW == corner)
		affected_SW = corner
		return
	if(holder.lighting_corner_SE == corner)
		affected_SE = corner
		return

/datum/sunlight_handler/proc/remove_from_affected(var/datum/lighting_corner/corner)
	if(affected_NE == corner)
		affected_NE = null
		return
	if(affected_NW == corner)
		affected_NW = null
		return
	if(affected_SW == corner)
		affected_SW = null
		return
	if(affected_SE == corner)
		affected_SE = null
		return

/datum/sunlight_handler/proc/get_only_sun_list()
	var/list/only_sun = list()
	if(only_sun_NE) only_sun += only_sun_NE
	if(only_sun_NW) only_sun += only_sun_NW
	if(only_sun_SW) only_sun += only_sun_SW
	if(only_sun_SE) only_sun += only_sun_SE
	return only_sun

/datum/sunlight_handler/proc/add_to_only_sun(var/datum/lighting_corner/corner)
	if(holder.lighting_corner_NE == corner)
		only_sun_NE = corner
		return
	if(holder.lighting_corner_NW == corner)
		only_sun_NW = corner
		return
	if(holder.lighting_corner_SW == corner)
		only_sun_SW = corner
		return
	if(holder.lighting_corner_SE == corner)
		only_sun_SE = corner
		return

/datum/sunlight_handler/proc/remove_from_only_sun(var/datum/lighting_corner/corner)
	if(only_sun_NE == corner)
		only_sun_NE = null
		return
	if(only_sun_NW == corner)
		only_sun_NW = null
		return
	if(only_sun_SW == corner)
		only_sun_SW = null
		return
	if(only_sun_SE == corner)
		only_sun_SE = null
		return

/datum/sunlight_handler/proc/turf_update(var/old_density, var/turf/new_turf, var/above)
	if(above)
		sunlight_check()
		sunlight_update()
		return
	if(new_turf.density && !old_density && sunlight) //This has the potential to cut off our sunlight
		sunlight_check()
		sunlight_update()
	else if (!new_turf.density && old_density && !sunlight) //This has the potential to introduce sunlight
		sunlight_check()
		sunlight_update()

/datum/sunlight_handler/proc/sunlight_check()
	GENERATE_MISSING_CORNERS(holder) //Somehow corners are self destructing under specific circumstances. Likely race conditions. This is slightly unoptimal but may be necessary.
	set_sleeping(FALSE) //We set sleeping to false just incase. If the conditions are correct, we'll end up going back to sleeping soon enough anyways.
	var/cur_sunlight = sunlight
	if(holder.is_outdoors())
		sunlight = SUNLIGHT_OVERHEAD
	if(holder.density)
		sunlight = FALSE
	if(try_get_sun() && !holder.is_outdoors() && !holder.density)
		var/outside_near = FALSE
		outer_loop:
			for(var/dir in cardinal)
				var/steps = 1
				var/turf/cur_turf = get_step(holder,dir)
				while(cur_turf && !cur_turf.density && steps < (SUNLIGHT_RADIUS + 1))
					if(cur_turf.is_outdoors())
						outside_near = TRUE
						break outer_loop
					steps += 1
					cur_turf = get_step(cur_turf,dir)
		if(!outside_near) //If cardinal directions fail, then check diagonals.
			var/radius = ONE_OVER_SQRT_2 * SUNLIGHT_RADIUS + 1
			outer_loop:
				for(var/dir in cornerdirs)
					var/steps = 1
					var/turf/cur_turf = get_step(holder,dir)
					var/opp_dir = turn(dir,180)
					var/north_south = opp_dir & (NORTH|SOUTH)
					var/east_west = opp_dir & (EAST|WEST)

					while(cur_turf && !cur_turf.density && steps < radius)
						var/turf/vert_behind = get_step(cur_turf,north_south)
						var/turf/hori_behind = get_step(cur_turf,east_west)
						if(vert_behind.density && hori_behind.density) //Prevent light from passing infinitesimally small gaps
							break outer_loop
						if(cur_turf.is_outdoors())
							outside_near = TRUE
							break outer_loop
						steps += 1
						cur_turf = get_step(cur_turf,dir)
		if(outside_near)
			sunlight = TRUE
		else if(sunlight)
			sunlight = FALSE

	if(cur_sunlight != sunlight)
		sunlight_update()
		if(!sunlight)
			SSlighting.sunlight_queue -= src
		else
			SSlighting.sunlight_queue += src

/datum/sunlight_handler/proc/sunlight_update()
	var/list/corners = list(holder.lighting_corner_NE,holder.lighting_corner_NW,holder.lighting_corner_SE,holder.lighting_corner_SW)
	var/list/new_corners = list()
	var/list/removed_corners = list()
	var/list/affected = get_affected_list()
	var/list/only_sun = get_only_sun_list()
	var/sunlightonly_corners = 0
	var/sunlightonly_shade_corners = 0
	var/sleepable_corners = 0
	for(var/datum/lighting_corner/corner in corners)
		switch(corner.sunlight)
			if(SUNLIGHT_NONE)
				if(sunlight)
					corner.sunlight = SUNLIGHT_CURRENT
					new_corners += corner
				else
					corner.sunlight = SUNLIGHT_POSSIBLE
			if(SUNLIGHT_POSSIBLE)
				if(sunlight)
					corner.sunlight = SUNLIGHT_CURRENT
					new_corners += corner
			if(SUNLIGHT_CURRENT)
				if(!sunlight && (corner in affected))
					remove_from_affected(corner)
					removed_corners += corner
					corner.sunlight = SUNLIGHT_POSSIBLE
			if(SUNLIGHT_ONLY)
				sunlightonly_corners++
				if(!(sunlight == SUNLIGHT_OVERHEAD) && (corner in only_sun))
					remove_from_only_sun(corner)
					sunlightonly_corners--
					if(sunlight)
						new_corners += corner
						corner.sunlight = SUNLIGHT_CURRENT
						continue
					corner.lum_r = 0
					corner.lum_g = 0
					corner.lum_b = 0
					continue
				sleepable_corners += corner.all_onlysun()
			if(SUNLIGHT_ONLY_SHADE)
				sunlightonly_shade_corners++
				if(!(sunlight == TRUE) && (corner in only_sun))
					remove_from_only_sun(corner)
					sunlightonly_shade_corners--
					if(sunlight)
						new_corners += corner
						corner.sunlight = SUNLIGHT_CURRENT
						continue
					corner.lum_r = 0
					corner.lum_g = 0
					corner.lum_b = 0
					continue
				sleepable_corners += corner.all_onlysun()

	if(!try_get_sun()) return

	var/sunonly_val = (sunlight == SUNLIGHT_OVERHEAD) ? SUNLIGHT_ONLY : SUNLIGHT_ONLY_SHADE

	if(sunlight)
		for(var/datum/lighting_corner/corner in affected)
			if(!LAZYLEN(corner.affecting))
				remove_from_affected(corner)
				removed_corners += corner
				add_to_only_sun(corner)
				corner.sunlight = sunonly_val
		for(var/datum/lighting_corner/corner in new_corners)
			if(!LAZYLEN(corner.affecting))
				new_corners -= corner
				add_to_only_sun(corner)
				corner.sunlight = sunonly_val

	if((sunlightonly_corners == 4 || sunlightonly_shade_corners == 4) && !only_sun_object)
		var/datum/lighting_object/holder_object = holder.lighting_object
		if(holder_object && !holder_object.sunlight_only)
			only_sun_object = holder_object
			only_sun_object.set_sunonly(sunonly_val, pshandler)


	if(sunlightonly_corners < 4 && sunlightonly_shade_corners < 4 && only_sun_object)
		only_sun_object.set_sunonly(FALSE, pshandler)
		only_sun_object = null

	if(only_sun_object)
		//Edge cases but needed to make sure that the correct overlay is used in the case that all corners switch from shade to overhead or vice versa between updates
		if(only_sun_object.sunlight_only == SUNLIGHT_ONLY_SHADE && sunlight == SUNLIGHT_OVERHEAD)
			only_sun_object.set_sunonly(SUNLIGHT_ONLY, pshandler)
		else if(only_sun_object.sunlight_only == SUNLIGHT_ONLY && sunlight == SUNLIGHT_CURRENT)
			only_sun_object.set_sunonly(SUNLIGHT_ONLY_SHADE, pshandler)
		only_sun_object.update_sun()

	for(var/datum/lighting_corner/corner in only_sun)
		corner.update_sun(pshandler)

	if(sleepable_corners == 4)
		set_sleeping(TRUE)
	else
		set_sleeping(FALSE)

	if(!affected.len && !new_corners.len && !removed_corners.len)
		return //Nothing to do, avoid wasting time.

	var/sunlight_mult = 0
	switch(sunlight)
		if(TRUE)
			sunlight_mult = 0.6
		if(SUNLIGHT_OVERHEAD)
			sunlight_mult = 1.0
	var/brightness = sun.brightness * sunlight_mult * SSlighting.sun_mult
	var/list/color = hex2rgb(sun.color)
	var/red = brightness * (color[1] / 255.0)
	var/green = brightness * (color[2] / 255.0)
	var/blue = brightness * (color[3] / 255.0)
	var/delta_r = red - effect_str_r
	var/delta_g = green - effect_str_g
	var/delta_b = blue - effect_str_b

	for(var/datum/lighting_corner/corner in affected)
		corner.update_lumcount(delta_r,delta_g,delta_b,from_sholder=TRUE)

	for(var/datum/lighting_corner/corner in new_corners)
		corner.update_lumcount(red,green,blue,from_sholder=TRUE)
		add_to_affected(corner)

	for(var/datum/lighting_corner/corner in removed_corners)
		corner.update_lumcount(-effect_str_r,-effect_str_g,-effect_str_b,from_sholder=TRUE)

	if(!affected.len)
		effect_str_r = 0
		effect_str_g = 0
		effect_str_b = 0
		return

	effect_str_r = red
	effect_str_g = green
	effect_str_b = blue

/datum/sunlight_handler/proc/corner_sunlight_change(var/datum/lighting_corner/sender)
	if(only_sun_object)
		only_sun_object.set_sunonly(FALSE, pshandler)
		only_sun_object = null

	set_sleeping(FALSE)
	wake_sleepers()

	if(!(sender in get_only_sun_list()))
		return

	sender.sunlight = SUNLIGHT_CURRENT

	sender.update_lumcount(effect_str_r,effect_str_g,effect_str_b,from_sholder=TRUE)
	remove_from_only_sun(sender)
	add_to_affected(sender)

/datum/sunlight_handler/proc/set_sleeping(var/val)
	if(sleeping == val)
		return
	sleeping = val
	if(val)
		pshandler.shandlers -= src
		SSlighting.sunlight_queue -= src
	else
		pshandler.shandlers |= src
		SSlighting.sunlight_queue |= src //Just in case somehow gets set to false twice use |=

/datum/sunlight_handler/proc/wake_sleepers(var/val)
	var/list/corners = list(holder.lighting_corner_NE,holder.lighting_corner_NW,holder.lighting_corner_SE,holder.lighting_corner_SW)
	for(var/datum/lighting_corner/corner in corners)
		corner.wake_sleepers()

/datum/sunlight_handler/proc/try_get_sun()
	if(sun) return TRUE
	if(!sleeping && SSlighting.get_pshandler_z(holder.z))
		pshandler = SSlighting.get_pshandler_z(holder.z)
		pshandler.shandlers += src
		sun = pshandler.sun
		return TRUE
	else
		return FALSE
