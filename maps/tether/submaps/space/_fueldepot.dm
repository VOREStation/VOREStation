/obj/effect/overmap/visitable/sector/fueldepot
	name = "Fuel Depot"
	desc = "Self-service refueling depot."
	icon = 'icons/obj/overmap_vr.dmi'
	icon_state = "fueldepot"
	color = "#33FF33"
	initial_generic_waypoints = list("fueldepot_east","fueldepot_west","fueldepot_north","fueldepot_south")

/area/tether_away/fueldepot
	name = "Away Mission - Fuel Depot"
	icon = 'icons/turf/areas_vr.dmi'
	icon_state = "dark"
	lightswitch = FALSE

/obj/effect/shuttle_landmark/premade/fueldepot/east
	name = "Fuel Depot - East Dock"
	landmark_tag = "fueldepot_east"

/obj/effect/shuttle_landmark/premade/fueldepot/west
	name = "Fuel Depot - West Dock"
	landmark_tag = "fueldepot_west"

/obj/effect/shuttle_landmark/premade/fueldepot/north
	name = "Fuel Depot - North Dock"
	landmark_tag = "fueldepot_north"

/obj/effect/shuttle_landmark/premade/fueldepot/south
	name = "Fuel Depot - South Dock"
	landmark_tag = "fueldepot_south"

/turf/simulated/floor/tiled/techmaint/airless
	oxygen = 0
	nitrogen = 0
	temperature = TCMB