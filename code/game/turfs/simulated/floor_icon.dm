var/list/flooring_cache = list()

var/image/no_ceiling_image = null

/hook/startup/proc/setup_no_ceiling_image()
	cache_no_ceiling_image()
	return TRUE

/proc/cache_no_ceiling_image()
	no_ceiling_image = image(icon = 'icons/turf/open_space.dmi', icon_state = "no_ceiling")
	no_ceiling_image.plane = PLANE_MESONS

/turf/simulated/floor/update_icon(var/update_neighbors)
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
									//VOREStation Addition Start
			if(flooring.do_season)
				if(!season)
					do_season()
				icon_state = "[icon_state]-[season]"	//VOREStation Addition End
			if(flooring.has_base_range)
				icon_state = "[icon_state][rand(0,flooring.has_base_range)]"
				flooring_override = icon_state

		// Apply edges, corners, and inner corners.
		var/has_border = 0
		if(flooring.flags & TURF_HAS_EDGES)
			for(var/step_dir in cardinal)
				var/turf/simulated/floor/T = get_step(src, step_dir)
				if(!flooring.test_link(src, T))
					has_border |= step_dir
					add_overlay(flooring.get_flooring_overlay("[flooring.icon_base]-edge-[step_dir]", "[flooring.icon_base]_edges", step_dir))

			//Note: Doesn't actually check northeast, this is bitmath to check if we're edge'd (aka not smoothed) to NORTH and EAST
			//North = 0001, East = 0100, Northeast = 0101, so (North|East) == Northeast, therefore (North|East)&Northeast == Northeast
			if((has_border & NORTHEAST) == NORTHEAST)
				add_overlay(flooring.get_flooring_overlay("[flooring.icon_base]-edge-[NORTHEAST]", "[flooring.icon_base]_edges", NORTHEAST))
			if((has_border & NORTHWEST) == NORTHWEST)
				add_overlay(flooring.get_flooring_overlay("[flooring.icon_base]-edge-[NORTHWEST]", "[flooring.icon_base]_edges", NORTHWEST))
			if((has_border & SOUTHEAST) == SOUTHEAST)
				add_overlay(flooring.get_flooring_overlay("[flooring.icon_base]-edge-[SOUTHEAST]", "[flooring.icon_base]_edges", SOUTHEAST))
			if((has_border & SOUTHWEST) == SOUTHWEST)
				add_overlay(flooring.get_flooring_overlay("[flooring.icon_base]-edge-[SOUTHWEST]", "[flooring.icon_base]_edges", SOUTHWEST))

			if(flooring.flags & TURF_HAS_CORNERS)
				//Like above but checking for NO similar bits rather than both similar bits.
				if((has_border & NORTHEAST) == 0) //Are connected NORTH and EAST
					var/turf/simulated/floor/T = get_step(src, NORTHEAST)
					if(!flooring.test_link(src, T)) //But not NORTHEAST
						add_overlay(flooring.get_flooring_overlay("[flooring.icon_base]-corner-[NORTHEAST]", "[flooring.icon_base]_corners", NORTHEAST))
				if((has_border & NORTHWEST) == 0)
					var/turf/simulated/floor/T = get_step(src, NORTHWEST)
					if(!flooring.test_link(src, T))
						add_overlay(flooring.get_flooring_overlay("[flooring.icon_base]-corner-[NORTHWEST]", "[flooring.icon_base]_corners", NORTHWEST))
				if((has_border & SOUTHEAST) == 0)
					var/turf/simulated/floor/T = get_step(src, SOUTHEAST)
					if(!flooring.test_link(src, T))
						add_overlay(flooring.get_flooring_overlay("[flooring.icon_base]-corner-[SOUTHEAST]", "[flooring.icon_base]_corners", SOUTHEAST))
				if((has_border & SOUTHWEST) == 0)
					var/turf/simulated/floor/T = get_step(src, SOUTHWEST)
					if(!flooring.test_link(src, T))
						add_overlay(flooring.get_flooring_overlay("[flooring.icon_base]-corner-[SOUTHWEST]", "[flooring.icon_base]_corners", SOUTHWEST))

	// Re-apply floor decals
	if(LAZYLEN(decals))
		add_overlay(decals)

	if(is_plating() && !(isnull(broken) && isnull(burnt))) //temp, todo
		icon = 'icons/turf/flooring/plating.dmi'
		icon_state = "dmg[rand(1,4)]"
	else if(flooring)
		if(!isnull(broken) && (flooring.flags & TURF_CAN_BREAK))
			if(istype(src, /turf/simulated/floor/wood))
				add_overlay(flooring.get_flooring_overlay("[flooring.icon_base]-broken-[broken]","[flooring.icon_base]-broken[broken]"))
			else
				add_overlay(flooring.get_flooring_overlay("[flooring.icon_base]-broken-[broken]","broken[broken]"))
		if(!isnull(burnt) && (flooring.flags & TURF_CAN_BURN))
			add_overlay(flooring.get_flooring_overlay("[flooring.icon_base]-burned-[burnt]","burned[burnt]"))

	if(update_neighbors)
		for(var/turf/simulated/floor/F in range(src, 1))
			if(F == src)
				continue
			F.update_icon()

	// Show 'ceilingless' overlay.
	var/turf/above = GetAbove(src)
	if(!is_outdoors() && above && isopenspace(above)) // This won't apply to outdoor turfs since its assumed they don't have a ceiling anyways.
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
				var/image/I = image(icon = T.icon_edge, icon_state = "[T.get_edge_icon_state()]-edge", dir = checkdir, layer = ABOVE_TURF_LAYER) // VOREStation Edit - icon_edge
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

//Tests whether this flooring will smooth with the specified turf
//You can override this if you want a flooring to have super special snowflake smoothing behaviour
/decl/flooring/proc/test_link(var/turf/origin, var/turf/T, var/countercheck = FALSE)

	var/is_linked = FALSE
	if (countercheck)
		//If this is a countercheck, we skip all of the above, start off with true, and go straight to the atom lists
		is_linked = TRUE
	else if(T)

		//If it's a wall, use the wall_smooth setting
		if(istype(T, /turf/simulated/wall))
			if(wall_smooth == SMOOTH_ALL)
				is_linked = TRUE

		//If it's space or openspace, use the space_smooth setting
		else if(isspace(T) || isopenspace(T))
			if(space_smooth == SMOOTH_ALL)
				is_linked = TRUE

		//If we get here then its a normal floor
		else if (istype(T, /turf/simulated/floor))
			var/turf/simulated/floor/t = T
			//If the floor is the same as us,then we're linked,
			if (t.flooring?.type == type)
				is_linked = TRUE
				/*
					But there's a caveat. To make atom black/whitelists work correctly, we also need to check that
					they smooth with us. Ill call this counterchecking for simplicity.
					This is needed to make both turfs have the correct borders

					To prevent infinite loops we have a countercheck var, which we'll set true
				*/

				if (smooth_movable_atom != SMOOTH_NONE)
					//We do the countercheck, passing countercheck as true
					is_linked = test_link(T, origin, countercheck = TRUE)

			else if (floor_smooth == SMOOTH_ALL)
				is_linked = TRUE

			else if (floor_smooth != SMOOTH_NONE)
				//If we get here it must be using a whitelist or blacklist
				if (floor_smooth == SMOOTH_WHITELIST)
					for (var/v in flooring_whitelist)
						if (istype(t.flooring, v))
							//Found a match on the list
							is_linked = TRUE
							break
				else if(floor_smooth == SMOOTH_BLACKLIST)
					is_linked = TRUE //Default to true for the blacklist, then make it false if a match comes up
					for (var/v in flooring_whitelist)
						if (istype(t.flooring, v))
							//Found a match on the list
							is_linked = FALSE
							break

	//Alright now we have a preliminary answer about smoothing, however that answer may change with the following
	//Atom lists!
	var/best_priority = -1
	//A white or blacklist entry will only override smoothing if its priority is higher than this
	//And then this value becomes its priority
	if (smooth_movable_atom != SMOOTH_NONE)
		if (smooth_movable_atom == SMOOTH_WHITELIST || smooth_movable_atom == SMOOTH_GREYLIST)
			for (var/list/v in movable_atom_whitelist)
				var/d_type = v[1]
				var/list/d_vars = v[2]
				var/d_priority = v[3]
				//Priority is the quickest thing to check first
				if (d_priority <= best_priority)
					continue

				//Ok, now we start testing all the atoms in the target turf
				for (var/a in T) //No implicit typecasting here, faster

					if (istype(a, d_type))
						//It's the right type, so we're sure it will have the vars we want.

						var/atom/movable/AM = a
						//Typecast it to a movable atom
						//Lets make sure its in the way before we consider it
						if (!AM.is_between_turfs(origin, T))
							continue

						//From here on out, we do dangerous stuff that may runtime if the coder screwed up


						var/match = TRUE
						for (var/d_var in d_vars)
							//For each variable we want to check
							if (AM.vars[d_var] != d_vars[d_var])
								//We get a var of the same name from the atom's vars list.
								//And check if it equals our desired value
								match = FALSE
								break //If any var doesn't match the desired value, then this atom is not a match, move on


						if (match)
							//If we've successfully found an atom which matches a list entry
							best_priority = d_priority //This one is king until a higher priority overrides it

							//And this is a whitelist, so this match forces is_linked to true
							is_linked = TRUE


		if (smooth_movable_atom == SMOOTH_BLACKLIST || smooth_movable_atom == SMOOTH_GREYLIST)
			//All of this blacklist code is copypasted from above, with only minor name changes
			for (var/list/v in movable_atom_blacklist)
				var/d_type = v[1]
				var/list/d_vars = v[2]
				var/d_priority = v[3]
				//Priority is the quickest thing to check first
				if (d_priority <= best_priority)
					continue

				//Ok, now we start testing all the atoms in the target turf
				for (var/a in T) //No implicit typecasting here, faster

					if (istype(a, d_type))
						//It's the right type, so we're sure it will have the vars we want.

						var/atom/movable/AM = a
						//Typecast it to a movable atom
						//Lets make sure its in the way before we consider it
						if (!AM.is_between_turfs(origin, T))
							continue

						//From here on out, we do dangerous stuff that may runtime if the coder screwed up

						var/match = TRUE
						for (var/d_var in d_vars)
							//For each variable we want to check
							if (AM.vars[d_var] != d_vars[d_var])
								//We get a var of the same name from the atom's vars list.
								//And check if it equals our desired value
								match = FALSE
								break //If any var doesn't match the desired value, then this atom is not a match, move on


						if (match)
							//If we've successfully found an atom which matches a list entry
							best_priority = d_priority //This one is king until a higher priority overrides it

							//And this is a blacklist, so this match forces is_linked to false
							is_linked = FALSE

	return is_linked

/turf/simulated/floor/proc/get_flooring_overlay(var/cache_key, var/icon_base, var/icon_dir = 0)
	if(!flooring_cache[cache_key])
		var/image/I = image(icon = flooring.icon, icon_state = icon_base, dir = icon_dir)
		I.layer = layer
		flooring_cache[cache_key] = I
	return flooring_cache[cache_key]

