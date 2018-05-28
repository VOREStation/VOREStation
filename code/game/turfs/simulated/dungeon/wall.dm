// Special wall type for Point of Interests.

/turf/simulated/wall/dungeon
	block_tele = TRUE // Anti-cheese.

/turf/simulated/wall/dungeon/New(var/newloc)
	..(newloc,"dungeonium")

/turf/simulated/wall/dungeon/attackby()
	return

/turf/simulated/wall/dungeon/ex_act()
	return

/turf/simulated/wall/solidrock //for more stylish anti-cheese.
	name = "solid rock"
	desc = "This rock seems dense, impossible to drill."
	description_info = "Probably not going to be able to drill or bomb your way through this, best to try and find a way around."
	icon_state = "bedrock"
	var/base_state = "bedrock"
	block_tele = TRUE

/turf/simulated/wall/solidrock/update_icon()
	for(var/direction in cardinal)
		var/turf/T = get_step(src,direction)
		if(istype(T) && !T.density)
			var/place_dir = turn(direction, 180)
			if(!mining_overlay_cache["rock_side_[place_dir]"])
				mining_overlay_cache["rock_side_[place_dir]"] = image('icons/turf/walls.dmi', "rock_side", dir = place_dir)
			T.add_overlay(mining_overlay_cache["rock_side_[place_dir]"])

/turf/simulated/wall/solidrock/initialize()
	icon_state = base_state
	update_icon(1)

/turf/simulated/wall/solidrock/attackby()
	return

/turf/simulated/wall/solidrock/ex_act()
	return