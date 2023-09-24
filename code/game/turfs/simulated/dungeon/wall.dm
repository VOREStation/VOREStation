// Special wall type for Point of Interests.

/turf/simulated/wall/dungeon
	block_tele = TRUE // Anti-cheese.

/turf/simulated/wall/dungeon/Initialize(mapload)
	. = ..(mapload, "dungeonium")

/turf/simulated/wall/dungeon/attackby()
	return

/turf/simulated/wall/dungeon/ex_act()
	return

/turf/simulated/wall/dungeon/take_damage()	//These things are suppose to be unbreakable
	return

/turf/simulated/wall/update_icon()
	if(!material)
		return

	if(!damage_overlays[1]) //list hasn't been populated
		generate_overlays()

	cut_overlays()
	var/image/I

	if(!density)
		I = image(wall_masks, "rockvault")
		I.color = material.icon_colour
		add_overlay(I)
		return
	..()

/turf/simulated/wall/solidrock //for more stylish anti-cheese.
	description_info = "Probably not going to be able to drill or bomb your way through this, best to try and find a way around."
	var/rock_side = "rock_side"
	block_tele = TRUE

/turf/simulated/wall/solidrock/Initialize(mapload)
	. = ..(mapload, "bedrock")

/turf/simulated/wall/solidrock/Initialize()
	. = ..()
	update_icon(1)

/turf/simulated/wall/solidrock/update_material()
	name = "solid rock"
	desc = "This rock seems dense, impossible to drill."

/turf/simulated/wall/solidrock/proc/get_cached_border(var/cache_id, var/direction, var/icon_file, var/icon_state, var/offset = 32)
	if(!mining_overlay_cache["[cache_id]_[direction]"])
		var/image/new_cached_image = image(icon_state, dir = direction, layer = ABOVE_TURF_LAYER)
		switch(direction)
			if(NORTH)
				new_cached_image.pixel_y = offset
			if(SOUTH)
				new_cached_image.pixel_y = -offset
			if(EAST)
				new_cached_image.pixel_x = offset
			if(WEST)
				new_cached_image.pixel_x = -offset
		mining_overlay_cache["[cache_id]_[direction]"] = new_cached_image
		return new_cached_image

	return mining_overlay_cache["[cache_id]_[direction]"]

/turf/simulated/wall/solidrock/update_icon(var/update_neighbors)
	if(density)
		var/image/I
		for(var/i = 1 to 4)
			I = image('icons/turf/wall_masks.dmi', "rock[wall_connections[i]]", dir = 1<<(i-1))
			add_overlay(I)
		for(var/direction in cardinal)
			var/turf/T = get_step(src,direction)
			if(istype(T) && !T.density)
				add_overlay(get_cached_border(rock_side,direction,icon,rock_side))

	else if(update_neighbors)
		for(var/direction in alldirs)
			if(istype(get_step(src, direction), /turf/simulated/wall/solidrock))
				var/turf/simulated/wall/solidrock/M = get_step(src, direction)
				M.update_icon()

/turf/simulated/wall/solidrock/attackby()
	return

/turf/simulated/wall/solidrock/ex_act()
	return

/turf/simulated/wall/solidrock/take_damage()	//These things are suppose to be unbreakable
	return


//Mossy rocks for POI. Unbreakable, no teleport.

/turf/simulated/wall/solidrock/mossyrockpoi // Version for POI labyrinths. No teleporting, no breaking.
	desc = "An old, yet impressively durably rock wall."
	var/mossyrock_side = "mossyrock_side"

/turf/simulated/wall/solidrock/Initialize(mapload)
	. = ..(mapload, "mossyrock")

/turf/simulated/wall/solidrock/mossyrockpoi/update_icon(var/update_neighbors)
	if(density)
		var/image/I
		for(var/i = 1 to 4)
			I = image('icons/turf/wall_masks.dmi', "mossyrock[wall_connections[i]]", dir = 1<<(i-1))
			add_overlay(I)
		for(var/direction in cardinal)
			var/turf/T = get_step(src,direction)
			if(istype(T) && !T.density)
				add_overlay(get_cached_border(mossyrock_side,direction,icon,mossyrock_side))

	else if(update_neighbors)
		for(var/direction in alldirs)
			if(istype(get_step(src, direction), /turf/simulated/wall/solidrock/mossyrockpoi))
				var/turf/simulated/wall/solidrock/mossyrockpoi/M = get_step(src, direction)
				M.update_icon()