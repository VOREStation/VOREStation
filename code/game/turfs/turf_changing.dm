/turf/proc/ReplaceWithLattice()
	src.ChangeTurf(get_base_turf_by_area(src))
	spawn()
		new /obj/structure/lattice( locate(src.x, src.y, src.z) )

// Removes all signs of lattice on the pos of the turf -Donkieyo
/turf/proc/RemoveLattice()
	var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
	if(L)
		qdel(L)

// Called after turf replaces old one
/turf/proc/post_change()
	levelupdate()

	var/turf/simulated/open/above = GetAbove(src)
	if(istype(above))
		above.update_icon()

	var/turf/simulated/below = GetBelow(src)
	if(istype(below))
		below.update_icon() // To add or remove the 'ceiling-less' overlay.

/proc/has_valid_ZAS_zone(turf/simulated/T)
	if(!istype(T))
		return FALSE
	return HAS_VALID_ZONE(T)

//Creates a new turf
/turf/proc/ChangeTurf(var/turf/N, var/tell_universe=1, var/force_lighting_update = 0, var/preserve_outdoors = FALSE)
	if (!N)
		return

	if(N == /turf/space)
		var/turf/below = GetBelow(src)
		var/zones_present = has_valid_ZAS_zone(below) || has_valid_ZAS_zone(src)
		if(istype(below) && zones_present && !(src.z in using_map.below_blocked_levels) && (!istype(below, /turf/unsimulated/wall) && !istype(below, /turf/simulated/sky)))	// VOREStation Edit: Weird open space
			N = /turf/simulated/open

	var/obj/fire/old_fire = fire
	var/old_dynamic_lighting = dynamic_lighting
	var/old_lighting_object = lighting_object
	var/old_lighting_corner_NE = lighting_corner_NE
	var/old_lighting_corner_SE = lighting_corner_SE
	var/old_lighting_corner_SW = lighting_corner_SW
	var/old_lighting_corner_NW = lighting_corner_NW
	var/old_directional_opacity = directional_opacity
	var/old_outdoors = outdoors
	var/old_dangerous_objects = dangerous_objects
	var/old_dynamic_lumcount = dynamic_lumcount

	var/turf/Ab = GetAbove(src)
	if(Ab)
		Ab.multiz_turf_del(src, DOWN)
	var/turf/Be = GetBelow(src)
	if(Be)
		Be.multiz_turf_del(src, UP)

	if(connections) connections.erase_all()

	if(istype(src,/turf/simulated))
		//Yeah, we're just going to rebuild the whole thing.
		//Despite this being called a bunch during explosions,
		//the zone will only really do heavy lifting once.
		var/turf/simulated/S = src
		if(S.zone) S.zone.rebuild()

	cut_overlays(TRUE)
	RemoveElement(/datum/element/turf_z_transparency)
	changing_turf = TRUE
	qdel(src)

	var/turf/W = new N( locate(src.x, src.y, src.z) )
	if(ispath(N, /turf/simulated/floor))
		if(old_fire)
			W.fire = old_fire
		W.RemoveLattice()
	else if(old_fire)
		old_fire.RemoveFire()

	if(tell_universe)
		universe.OnTurfChange(W)

	if(SSair)
		SSair.mark_for_update(W)

	for(var/turf/space/S in range(W, 1))
		S.update_starlight()
	W.levelupdate()
	W.update_icon(1)
	W.post_change()
	. =  W

	dangerous_objects = old_dangerous_objects

	lighting_corner_NE = old_lighting_corner_NE
	lighting_corner_SE = old_lighting_corner_SE
	lighting_corner_SW = old_lighting_corner_SW
	lighting_corner_NW = old_lighting_corner_NW

	dynamic_lumcount = old_dynamic_lumcount

	if(SSlighting.subsystem_initialized)
		lighting_object = old_lighting_object

		directional_opacity = old_directional_opacity
		recalculate_directional_opacity()

		if (dynamic_lighting != old_dynamic_lighting)
			if (IS_DYNAMIC_LIGHTING(src))
				lighting_build_overlay()
			else
				lighting_clear_overlay()
		else if(lighting_object && !lighting_object.needs_update)
			lighting_object.update()

		for(var/turf/space/space_tile in RANGE_TURFS(1, src))
			space_tile.update_starlight()

	if(preserve_outdoors)
		outdoors = old_outdoors
