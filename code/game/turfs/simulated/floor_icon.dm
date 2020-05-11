var/list/flooring_cache = list()

var/image/no_ceiling_image = null

/hook/startup/proc/setup_no_ceiling_image()
	cache_no_ceiling_image()
	return TRUE

/proc/cache_no_ceiling_image()
	no_ceiling_image = image(icon = 'icons/turf/open_space.dmi', icon_state = "no_ceiling")
	no_ceiling_image.plane = PLANE_MESONS

/turf/simulated/floor/update_icon(var/update_neighbors)

	if(lava)
		return

	cut_overlays()

	if(flooring)
		// Set initial icon and strings.
		name = flooring.name
		desc = flooring.desc
		icon = flooring.icon

		if(flooring_override)
			icon_state = flooring_override
		else
			icon_state = flooring.icon_base
			if(flooring.has_base_range)
				icon_state = "[icon_state][rand(0,flooring.has_base_range)]"
				flooring_override = icon_state

		// Apply edges, corners, and inner corners.
		var/has_border = 0
		if(flooring.flags & TURF_HAS_EDGES)
			for(var/step_dir in cardinal)
				var/turf/simulated/floor/T = get_step(src, step_dir)
				if(!test_link(T))
					has_border |= step_dir
					add_overlay(get_flooring_overlay("[flooring.icon_base]-edge-[step_dir]", "[flooring.icon_base]_edges", step_dir))

			//Note: Doesn't actually check northeast, this is bitmath to check if we're edge'd (aka not smoothed) to NORTH and EAST
			//North = 0001, East = 0100, Northeast = 0101, so (North|East) == Northeast, therefore (North|East)&Northeast == Northeast
			if((has_border & NORTHEAST) == NORTHEAST)
				add_overlay(get_flooring_overlay("[flooring.icon_base]-edge-[NORTHEAST]", "[flooring.icon_base]_edges", NORTHEAST))
			if((has_border & NORTHWEST) == NORTHWEST)
				add_overlay(get_flooring_overlay("[flooring.icon_base]-edge-[NORTHWEST]", "[flooring.icon_base]_edges", NORTHWEST))
			if((has_border & SOUTHEAST) == SOUTHEAST)
				add_overlay(get_flooring_overlay("[flooring.icon_base]-edge-[SOUTHEAST]", "[flooring.icon_base]_edges", SOUTHEAST))
			if((has_border & SOUTHWEST) == SOUTHWEST)
				add_overlay(get_flooring_overlay("[flooring.icon_base]-edge-[SOUTHWEST]", "[flooring.icon_base]_edges", SOUTHWEST))

			if(flooring.flags & TURF_HAS_CORNERS)
				//Like above but checking for NO similar bits rather than both similar bits.
				if((has_border & NORTHEAST) == 0) //Are connected NORTH and EAST
					var/turf/simulated/floor/T = get_step(src, NORTHEAST)
					if(!test_link(T)) //But not NORTHEAST
						add_overlay(get_flooring_overlay("[flooring.icon_base]-corner-[NORTHEAST]", "[flooring.icon_base]_corners", NORTHEAST))
				if((has_border & NORTHWEST) == 0)
					var/turf/simulated/floor/T = get_step(src, NORTHWEST)
					if(!test_link(T))
						add_overlay(get_flooring_overlay("[flooring.icon_base]-corner-[NORTHWEST]", "[flooring.icon_base]_corners", NORTHWEST))
				if((has_border & SOUTHEAST) == 0)
					var/turf/simulated/floor/T = get_step(src, SOUTHEAST)
					if(!test_link(T))
						add_overlay(get_flooring_overlay("[flooring.icon_base]-corner-[SOUTHEAST]", "[flooring.icon_base]_corners", SOUTHEAST))
				if((has_border & SOUTHWEST) == 0)
					var/turf/simulated/floor/T = get_step(src, SOUTHWEST)
					if(!test_link(T))
						add_overlay(get_flooring_overlay("[flooring.icon_base]-corner-[SOUTHWEST]", "[flooring.icon_base]_corners", SOUTHWEST))

	// Re-apply floor decals
	if(LAZYLEN(decals))
		add_overlay(decals)

	if(is_plating() && !(isnull(broken) && isnull(burnt))) //temp, todo
		icon = 'icons/turf/flooring/plating.dmi'
		icon_state = "dmg[rand(1,4)]"
	else if(flooring)
		if(!isnull(broken) && (flooring.flags & TURF_CAN_BREAK))
			add_overlay(get_flooring_overlay("[flooring.icon_base]-broken-[broken]","broken[broken]")) // VOREStation Edit - Eris overlays
		if(!isnull(burnt) && (flooring.flags & TURF_CAN_BURN))
			add_overlay(get_flooring_overlay("[flooring.icon_base]-burned-[burnt]","burned[burnt]")) // VOREStation Edit - Eris overlays

	if(update_neighbors)
		for(var/turf/simulated/floor/F in range(src, 1))
			if(F == src)
				continue
			F.update_icon()

	// Show 'ceilingless' overlay.
	var/turf/above = GetAbove(src)
	if(above && isopenspace(above) && !istype(src, /turf/simulated/floor/outdoors)) // This won't apply to outdoor turfs since its assumed they don't have a ceiling anyways.
		add_overlay(no_ceiling_image)

	// Update our 'them-to-us' edges, aka edges from external turfs we feel should spill onto us
	if(edge_blending_priority && !forbid_turf_edge())
		update_icon_edge()

// This updates an edge from an adjacent turf onto us, not our own 'internal' edges.
// For e.g. we might be outdoor metal plating, and we want to find sand next to us to have it 'spill onto' our turf with an overlay.
/turf/simulated/proc/update_icon_edge()
	for(var/checkdir in cardinal) // Check every direction
		var/turf/simulated/T = get_step(src, checkdir) // Get the turf in that direction
		// Our conditions:
		// Has to be a /turf/simulated
		// Has to have it's own edge_blending_priority
		// Has to have a higher priority than us
		// Their icon_state is not our icon_state
		// They don't forbid_turf_edge			
		if(istype(T) && T.edge_blending_priority && edge_blending_priority < T.edge_blending_priority && icon_state != T.icon_state && !T.forbid_turf_edge())
			var/cache_key = "[T.get_edge_icon_state()]-[checkdir]" // Usually [icon_state]-[dirnum]
			if(!turf_edge_cache[cache_key])
				var/image/I = image(icon = 'icons/turf/outdoors_edge.dmi', icon_state = "[T.get_edge_icon_state()]-edge", dir = checkdir, layer = ABOVE_TURF_LAYER) // Icon should be abstracted out
				I.plane = TURF_PLANE
				turf_edge_cache[cache_key] = I
			add_overlay(turf_edge_cache[cache_key])

// We will take this state and use it for a cache key, and append '-edge' to it to get the edge overlay (edges *from other turfs*, not our own internal edges)
/turf/simulated/proc/get_edge_icon_state()
	return icon_state

// Tests if we shouldn't apply a turf edge.
// Returns the blocker if one exists.
/turf/simulated/proc/forbid_turf_edge()
	for(var/obj/structure/S in contents)
		if(S.block_turf_edges)
			return S
	return null


/turf/simulated/floor/proc/test_link(var/turf/simulated/floor/them)
	return (istype(them) && them.flooring?.name == src.flooring.name)

/turf/simulated/floor/proc/get_flooring_overlay(var/cache_key, var/icon_base, var/icon_dir = 0)
	if(!flooring_cache[cache_key])
		var/image/I = image(icon = flooring.icon, icon_state = icon_base, dir = icon_dir)
		I.layer = layer
		flooring_cache[cache_key] = I
	return flooring_cache[cache_key]

