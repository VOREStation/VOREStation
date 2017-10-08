#define Z_LEVEL_FIRST_PLANE						1
#define Z_LEVEL_SECOND_PLANE					2

/datum/map/plane
	name = "Another Test Map"
	full_name = "The Flat Test Map"
	path = "plane"

	lobby_icon = 'icons/misc/title.dmi'
	lobby_screens = list("mockingjay00")

	zlevel_datum_type = /datum/map_z_level/plane

	station_name  = "The Plain Plane for Air Planes"
	station_short = "The Plane"
	dock_name     = "the Maximum Fun Chamber"
	boss_name     = "Mister Fun"
	boss_short    = "Mr. Fun"
	company_name  = "Fun Inc."
	company_short = "FI"
	starsys_name  = "Not Vir"

/datum/map_z_level/plane/first
	z = Z_LEVEL_FIRST_PLANE
	name = "The Ground"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER
	transit_chance = 50
	base_turf = /turf/simulated/floor/outdoors/rocks

/datum/map_z_level/plane/second
	z = Z_LEVEL_SECOND_PLANE
	name = "The Sky"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER
	transit_chance = 50
	base_turf = /turf/simulated/open

/datum/planet/sif
	expected_z_levels = list(
		Z_LEVEL_FIRST_PLANE,
		Z_LEVEL_SECOND_PLANE
	)