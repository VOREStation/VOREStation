// -- Datums -- //

//We're including two new shuttle destinations. One is in orbit of our 'desert planet'
/datum/shuttle_destination/excursion/virgo2orbit //Must be a unique path
	name = "Virgo 2 Orbit" //The name of the destination
	my_area = /area/shuttle/excursion/space //The area the shuttle goes when it's settled at this destination
	preferred_interim_area = /area/shuttle/excursion/space_moving //The area the shuttle goes while it's moving there
	skip_me = TRUE //Must be TRUE on all away-mission destinations for reasons

	routes_to_make = list( //These are routes the shuttle connects to,
		/datum/shuttle_destination/excursion/bluespace = 30 SECONDS //This is a normal destination that's part of Tether
	)

//The other destination is landed on the surface
/datum/shuttle_destination/excursion/beach
	name = "Coastal Area"
	my_area = /area/shuttle/excursion/away_beach
	preferred_interim_area = /area/shuttle/excursion/sand_moving
	skip_me = TRUE

	routes_to_make = list(
		/datum/shuttle_destination/excursion/virgo2orbit = 30 SECONDS //This is the above one
	)

//This is a special subtype of the thing that generates ores on a map
//It will generate more rich ores because of the lower numbers than the normal one
/datum/random_map/noise/ore/beachmine
	descriptor = "beach mine ore distribution map"
	deep_val = 0.6 //More riches, normal is 0.7 and 0.8
	rare_val = 0.5

//The check_map_sanity proc is sometimes unsatisfied with how AMAZING our ores are
/datum/random_map/noise/ore/beachmine/check_map_sanity()
	var/rare_count = 0
	var/surface_count = 0
	var/deep_count = 0

	// Increment map sanity counters.
	for(var/value in map)
		if(value < rare_val)
			surface_count++
		else if(value < deep_val)
			rare_count++
		else
			deep_count++
	// Sanity check.
	if(surface_count < 100)
		admin_notice("<span class='danger'>Insufficient surface minerals. Rerolling...</span>", R_DEBUG)
		return 0
	else if(rare_count < 50)
		admin_notice("<span class='danger'>Insufficient rare minerals. Rerolling...</span>", R_DEBUG)
		return 0
	else if(deep_count < 50)
		admin_notice("<span class='danger'>Insufficient deep minerals. Rerolling...</span>", R_DEBUG)
		return 0
	else
		return 1

// -- Objs -- //

//This is a special type of object which will build our shuttle paths, only if this map loads
//You do need to place this object on the map somewhere.
/obj/shuttle_connector/beach
	name = "shuttle connector - beach"
	shuttle_name = "Excursion Shuttle"
	//This list needs to be in the correct order, and start with the one that connects to the rest of the shuttle 'network'
	destinations = list(/datum/shuttle_destination/excursion/virgo2orbit, /datum/shuttle_destination/excursion/beach)

//This object simply performs any map setup that needs to happen on our map if it loads.
//As with the above, you do need to place this object on the map somewhere.
/obj/away_mission_init/beachcave
	name = "away mission initializer - beachcave"

//In our case, it initializes the ores and random submaps in the beach's cave, then deletes itself
/obj/away_mission_init/beachcave/initialize()
	// Cave submaps are first.
	seed_submaps(list(z), 50, /area/tether_away/cave/unexplored/normal, /datum/map_template/surface/mountains/normal)
	seed_submaps(list(z), 50, /area/tether_away/cave/unexplored/deep, /datum/map_template/surface/mountains/deep)

	// Now for the tunnels.
	new /datum/random_map/automata/cave_system/no_cracks(null, 1, 1, z, world.maxx, world.maxy)
	new /datum/random_map/noise/ore/beachmine(null, 1, 1, z, 64, 64)

	qdel(src)

// These are step-teleporters, for map edge transitions
// This top one goes INTO the cave
/obj/effect/step_trigger/teleporter/away_beach_tocave/New()
	..()
	teleport_x = src.x //X is horizontal. This is a top of map transition, so you want the same horizontal alignment in the cave as you have on the beach
	teleport_y = 2 //2 is because it's putting you on row 2 of the map to the north
	teleport_z = z+1 //The cave is always our Z-level plus 1, because it's loaded after us

//This one goes OUT OF the cave
/obj/effect/step_trigger/teleporter/away_beach_tobeach/New()
	..()
	teleport_x = src.x //Same reason as bove
	teleport_y = world.maxy - 1 //This means "1 space from the top of the map"
	teleport_z = z-1 //Opposite of 'tocave', beach is always loaded as the map before us

// -- Turfs -- //

//These are just some special turfs for the beach water
/turf/simulated/floor/beach/coastwater
	name = "Water"
	icon_state = "water"

/turf/simulated/floor/beach/coastwater/New()
	..()
	overlays += image("icon"='icons/misc/beach.dmi',"icon_state"="water","layer"=MOB_LAYER+0.1)

// -- Areas -- //

//And some special areas, including our shuttle landing spot (must be unique)
/area/shuttle/excursion/away_beach
	name = "\improper Excursion Shuttle - Beach"

/area/tether_away/beach
	name = "\improper Desert Planet Beach"
	icon_state = "away"
	base_turf = /turf/simulated/floor/beach/sand //This is what the ground turns into if destroyed/bombed/etc
	//Not going to do sunlight simulations here like virgo3b
	//So we just make the whole beach fullbright all the time
	dynamic_lighting = 0

/area/tether_away/beach/powershed
	name = "\improper Desert Planet Coast"
	icon_state = "blue2"
	base_turf = /turf/simulated/floor/beach/sand

/area/tether_away/beach/coast
	name = "\improper Desert Planet Coast"
	icon_state = "blue2"
	base_turf = /turf/simulated/floor/beach/coastline

/area/tether_away/beach/water
	name = "\improper Desert Planet Water"
	icon_state = "bluenew"
	base_turf = /turf/simulated/floor/beach/coastwater

/area/tether_away/beach/jungle
	name = "\improper Desert Planet Jungle"
	icon_state = "green"
	base_turf = /turf/simulated/floor/beach/sand/desert

//Some areas for the cave, which are referenced by our init object to seed submaps and ores
/area/tether_away/cave
	flags = RAD_SHIELDED
	ambience = list('sound/ambience/ambimine.ogg', 'sound/ambience/song_game.ogg')

/area/tether_away/cave/explored/normal
	name = "Tunnels"
	icon_state = "explored"

/area/tether_away/cave/unexplored/normal
	name = "Tunnels"
	icon_state = "unexplored"

/area/tether_away/cave/explored/deep
	name = "Depths"
	icon_state = "explored_deep"

/area/tether_away/cave/unexplored/deep
	name = "Depths"
	icon_state = "unexplored_deep"
