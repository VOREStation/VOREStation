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

//Creates a new turf
/turf/proc/ChangeTurf(var/turf/N, var/tell_universe=1, var/force_lighting_update = 0, var/preserve_outdoors = FALSE)
	if (!N)
		return

	if(N == /turf/space)
		var/turf/below = GetBelow(src)
		if(istype(below) && (air_master.has_valid_zone(below) || air_master.has_valid_zone(src)) && (!istype(below, /turf/unsimulated/wall) && !istype(below, /turf/simulated/sky)))	// VOREStation Edit: Weird open space
			N = /turf/simulated/open

	var/obj/fire/old_fire = fire
	var/old_opacity = opacity
	var/old_dynamic_lighting = dynamic_lighting
	var/old_affecting_lights = affecting_lights
	var/old_lighting_overlay = lighting_overlay
	var/old_corners = corners
	var/old_outdoors = outdoors
	var/old_dangerous_objects = dangerous_objects

	//to_world("Replacing [src.type] with [N]")

	if(connections) connections.erase_all()

	if(istype(src,/turf/simulated))
		//Yeah, we're just going to rebuild the whole thing.
		//Despite this being called a bunch during explosions,
		//the zone will only really do heavy lifting once.
		var/turf/simulated/S = src
		if(S.zone) S.zone.rebuild()

	if(ispath(N, /turf/simulated/floor))
		var/turf/simulated/W = new N( locate(src.x, src.y, src.z) )
		if(old_fire)
			fire = old_fire

		if (istype(W,/turf/simulated/floor))
			W.RemoveLattice()

		if(tell_universe)
			universe.OnTurfChange(W)

		if(air_master)
			air_master.mark_for_update(src) //handle the addition of the new turf.

		for(var/turf/space/S in range(W,1))
			S.update_starlight()

		W.levelupdate()
		W.update_icon(1)
		W.post_change()
		. = W

	else

		var/turf/W = new N( locate(src.x, src.y, src.z) )

		if(old_fire)
			old_fire.RemoveFire()

		if(tell_universe)
			universe.OnTurfChange(W)

		if(air_master)
			air_master.mark_for_update(src)

		for(var/turf/space/S in range(W,1))
			S.update_starlight()

		W.levelupdate()
		W.update_icon(1)
		W.post_change()
		. =  W

	recalc_atom_opacity()

	dangerous_objects = old_dangerous_objects

	if(lighting_overlays_initialised)
		lighting_overlay = old_lighting_overlay
		affecting_lights = old_affecting_lights
		corners = old_corners
		if((old_opacity != opacity) || (dynamic_lighting != old_dynamic_lighting))
			reconsider_lights()
		if(dynamic_lighting != old_dynamic_lighting)
			if(dynamic_lighting)
				lighting_build_overlay()
			else
				lighting_clear_overlay()

	if(preserve_outdoors)
		outdoors = old_outdoors
