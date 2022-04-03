#define ME_HEART_TILE 0
#define ME_CRUST_TILE 1
#define ME_CARDINAL_TILE 2
#define ME_EMPTY_TILE 3
#define ME_CORE_TILE 7

/datum/random_map/meteor
	descriptor = "meteor"
	initial_wall_cell = 0
	limit_x = 5
	limit_y = 5
	preserve_map = 0

	wall_type = /turf/simulated/mineral/moon
	floor_type = /turf/simulated/mineral/moon/ore

	auto_apply = TRUE

	var/core_type = /turf/simulated/mineral/moon/xenoarch

	var/placement_explosion_dev =   1
	var/placement_explosion_heavy = 2
	var/placement_explosion_light = 6
	var/placement_explosion_flash = 4

	var/applied = FALSE

/datum/random_map/meteor/New(var/seed, var/tx, var/ty, var/tz, var/tlx, var/tly, var/do_not_apply, var/do_not_announce)
	//Make sure there is a clear midpoint.
	if(limit_x % 2 == 0) limit_x++
	if(limit_y % 2 == 0) limit_y++
	..()

/datum/random_map/meteor/generate_map()

	// No point calculating these 200 times.
	var/x_midpoint = n_ceil(limit_x / 2)
	var/y_midpoint = n_ceil(limit_y / 2)

	// Draw walls/floors
	for(var/x = 1, x <= limit_x, x++)
		for(var/y = 1, y <= limit_y, y++)
			var/current_cell = get_map_cell(x,y)
			if(!current_cell)
				continue

			var/on_x_bound = (x == 1 || x == limit_x)
			var/on_y_bound = (y == 1 || y == limit_x)
			var/draw_corners = (limit_x < 5 && limit_y < 5)
			if(on_x_bound || on_y_bound)
				// Draw the actual walls.
				if(draw_corners || (!on_x_bound || !on_y_bound))
					map[current_cell] = ME_CRUST_TILE
				//Don't draw the far corners on large pods.
				else
					map[current_cell] = ME_EMPTY_TILE
			else
				// Fill in the corners.
				if((x == 2 || x == (limit_x-1)) && (y == 2 || y == (limit_y-1)))
					map[current_cell] = ME_CRUST_TILE
				// Fill in EVERYTHING ELSE.
				else
					map[current_cell] = ME_HEART_TILE

	// Draw the meteor core.
	var/current_cell = get_map_cell(x_midpoint,y_midpoint)
	if(current_cell)
		map[current_cell] = ME_CORE_TILE
	return 1

/datum/random_map/meteor/apply_to_map()
	if(!applied)
		applied = TRUE
		if(placement_explosion_dev || placement_explosion_heavy || placement_explosion_light || placement_explosion_flash)
			var/turf/T = locate((origin_x + n_ceil(limit_x / 2)-1), (origin_y + n_ceil(limit_y / 2)-1), origin_z)
			if(istype(T))
				explosion(T, placement_explosion_dev, placement_explosion_heavy, placement_explosion_light, placement_explosion_flash)
				sleep(15) // Let the explosion finish proccing before we ChangeTurf(), otherwise it might destroy our spawned objects.
	return ..()

/datum/random_map/meteor/get_appropriate_path(var/value)
	if(value == ME_HEART_TILE)
		return floor_type
	else if(value == ME_CRUST_TILE)
		return wall_type
	else if(value == ME_CORE_TILE)
		return core_type
	return null

// Meteors are circular. Get the direction this object is facing from the center of the pod.
/datum/random_map/meteor/get_spawn_dir(var/x, var/y)
	var/x_midpoint = n_ceil(limit_x / 2)
	var/y_midpoint = n_ceil(limit_y / 2)
	if(x == x_midpoint && y == y_midpoint)
		return null
	var/turf/target = locate(origin_x+x-1, origin_y+y-1, origin_z)
	var/turf/middle = locate(origin_x+x_midpoint-1, origin_y+y_midpoint-1, origin_z)
	if(!istype(target) || !istype(middle))
		return null
	return get_dir(middle, target)

/datum/random_map/meteor/get_additional_spawns(var/value, var/turf/T, var/spawn_dir)
	// Splatter anything under us that survived the explosion.
	if(value != ME_EMPTY_TILE && T.contents.len)
		for(var/atom/movable/AM in T)
			if(AM.simulated && !istype(AM, /mob/observer))
				qdel(AM)

/datum/admins/proc/call_meteor()
	set category = "Fun"
	set desc = "Drop a meteor on your current location."
	set name = "Drop Large Meteor"

	if(!check_rights(R_FUN)) return

	if(alert("Are you SURE you wish to drop this meteor? It will cause a sizable explosion and gib anyone underneath it.",,"No","Yes") == "No")
		return

	new /datum/random_map/meteor(null, usr.x-1, usr.y-1, usr.z)
