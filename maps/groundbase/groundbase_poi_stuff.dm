#if MAP_TEST
#include "pois/od-testthing-a.dmm"
#endif


/area/groundbase/poi
	name = "POI - Rascal's Pass"
	icon = 'icons/turf/areas_vr.dmi'
	icon_state = "orawhisqu"
	ambience = AMBIENCE_FOREBODING

/datum/map_template/groundbase/outdoor
	name = "Outdoors"
	desc = "POIs for outdoors!"
	mappath = 'pois/od-testthing-a.dmm'
	cost = 1
	allow_duplicates = FALSE

/area/groundbase/poi/outdoor
	name = "POI - Outdoors"
	ceiling_type = /turf/simulated/floor/virgo3c
/*
/datum/map_template/groundbase/maintcaves
	name = "Caves"
	desc = "POIs for caves!"
	mappath = 'pois/darkstar.dmm'
	cost = 1

/area/groundbase/poi/cave
	name = "POI - Caves"
*/