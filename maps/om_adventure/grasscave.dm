#if MAP_TEST
#include "pois/darkstar.dmm"
#include "pois/darktear1.dmm"
#include "pois/darktear2.dmm"
#include "pois/darktear3.dmm"
#include "pois/darktear4.dmm"
#include "pois/fleshtear1.dmm"
#include "pois/fleshtear2.dmm"
#include "pois/fleshtear3.dmm"
#include "pois/fleshtear4.dmm"
#include "pois/cabin1.dmm"
#include "pois/cabin2.dmm"
#include "pois/cabin3.dmm"
#include "pois/camp.dmm"
#include "pois/shuttlewreck1.dmm"
#include "pois/shuttlewreck2.dmm"
#include "pois/shuttlewreck3.dmm"
#include "pois/shuttlewreck4.dmm"
#include "pois/darktear_sample.dmm"
#include "pois/fleshtear_samples.dmm"
#endif


/obj/effect/shuttle_landmark/premade/om_adventure/grasscave/center
	name = "Anomaly - Center Alpha"
	landmark_tag = "om-grasscave-center"

/obj/effect/shuttle_landmark/premade/om_adventure/grasscave/center_alt
	name = "Anomaly - Center Beta"
	landmark_tag = "om-grasscave-center2"

/obj/effect/shuttle_landmark/premade/om_adventure/grasscave/southeast
	name = "Anomaly - Southeast Alpha"
	landmark_tag = "om-grasscave-southeast"

/obj/effect/shuttle_landmark/premade/om_adventure/grasscave/southeast_alt
	name = "Anomaly - Southeast Beta"
	landmark_tag = "om-grasscave-southeast2"


/area/om_adventure/grasscave
	name = "Grass Cave"
	icon = 'icons/turf/areas_vr.dmi'
	icon_state = "bluwhicir"
	requires_power = TRUE
	dynamic_lighting = TRUE
	flags = RAD_SHIELDED
	base_turf = /turf/simulated/floor/weird_things/dark
	ambience = AMBIENCE_FOREBODING

/area/om_adventure/grasscave/explored

/area/om_adventure/grasscave/unexplored
	ambience = AMBIENCE_RUINS

/area/om_adventure/grasscave/rocks

/obj/effect/overmap/visitable/simplemob/spacewhale/grasscave
	initial_generic_waypoints = list("om-grasscave-center", "om-grasscave-center2", "om-grasscave-southeast", "om-grasscave-southeast2")

/turf/simulated/mineral/omadventure/make_ore(var/rare_ore)
	if(mineral)
		return
	var/mineral_name
	if(rare_ore)
		mineral_name = pickweight(list(
			"marble" = 3,
			"uranium" = 10,
			"platinum" = 10,
			"hematite" = 20,
			"carbon" = 30,
			"diamond" = 20,
			"gold" = 8,
			"silver" = 8,
			"phoron" = 18,
			"lead" = 5,
			"verdantium" = 5))
	else
		mineral_name = pickweight(list(
			"marble" = 2,
			"uranium" = 5,
			"platinum" = 5,
			"hematite" = 35,
			"carbon" = 30,
			"gold" = 3,
			"silver" = 3,
			"phoron" = 25,
			"lead" = 1))

	if(mineral_name && (mineral_name in GLOB.ore_data))
		mineral = GLOB.ore_data[mineral_name]
		UpdateMineral()
	update_icon()

/datum/random_map/noise/ore/grasscave
	descriptor = "grasscave ore distribution map"
	deep_val = 0.6 //More riches, normal is 0.7 and 0.8
	rare_val = 0.5

/datum/map_template/om_adventure

/area/om_adventure/poi
	name = "POI - OM-A"
	icon = 'icons/turf/areas_vr.dmi'
	icon_state = "orawhisqu"
	ambience = AMBIENCE_FOREBODING

/area/om_adventure/poi/darkstar
	name = "POI - Darkstar"

/datum/map_template/om_adventure/outdoor/darkstar
	name = "Darkstar"
	desc = "A mysterious shape!"
	mappath = 'pois/darkstar.dmm'
	cost = 5

/area/om_adventure/poi/darktear1
	name = "POI - Darktear 1"

/datum/map_template/om_adventure/cave/darktear1
	name = "darktear1"
	desc = "A mysterious shape!"
	mappath = 'pois/darktear1.dmm'
	cost = 5

/area/om_adventure/poi/darktear2
	name = "POI - Darktear 2"

/datum/map_template/om_adventure/cave/darktear2
	name = "darktear2"
	desc = "A mysterious shape!"
	mappath = 'pois/darktear2.dmm'
	cost = 5

/area/om_adventure/poi/darktear3
	name = "POI - Darktear 3"

/datum/map_template/om_adventure/cave/darktear3
	name = "darktear3"
	desc = "A mysterious shape!"
	mappath = 'pois/darktear3.dmm'
	cost = 5

/area/om_adventure/poi/darktear4
	name = "POI - Darktear 4"

/datum/map_template/om_adventure/cave/darktear4
	name = "darktear4"
	desc = "A mysterious shape!"
	mappath = 'pois/darktear4.dmm'
	cost = 5

/area/om_adventure/poi/darktear_sample
	name = "POI - Darktear Scientific"

/datum/map_template/om_adventure/cave/darktear_sample
	name = "darktear (Samples)"	//1 uncommon-or-rare sample
	desc = "Ooh, spooky"
	mappath = 'pois/darktear_sample.dmm'
	cost = 5

/area/om_adventure/poi/fleshtear1
	name = "POI - Fleshtear 1"

/datum/map_template/om_adventure/cave/fleshtear1
	name = "fleshtear1"
	desc = "Wow gross!"
	mappath = 'pois/fleshtear1.dmm'
	cost = 5

/area/om_adventure/poi/fleshtear2
	name = "POI - Fleshtear 2"

/datum/map_template/om_adventure/cave/fleshtear2
	name = "fleshtear2"
	desc = "Wow gross!"
	mappath = 'pois/fleshtear2.dmm'
	cost = 5

/area/om_adventure/poi/fleshtear3
	name = "POI - Fleshtear 3"

/datum/map_template/om_adventure/cave/fleshtear3
	name = "fleshtear3"
	desc = "Wow gross!"
	mappath = 'pois/fleshtear3.dmm'
	cost = 5

/area/om_adventure/poi/fleshtear4
	name = "POI - Fleshtear 4"

/datum/map_template/om_adventure/cave/fleshtear4
	name = "fleshtear4"
	desc = "Wow gross!"
	mappath = 'pois/fleshtear4.dmm'
	cost = 5

/area/om_adventure/poi/fleshtear_samples
	name = "POI - Fleshtear Scientific"

/datum/map_template/om_adventure/cave/fleshtear_samples
	name = "fleshtear (Samples)"	//3 common/uncommon samples
	desc = "Ooh, meaty"
	mappath = 'pois/fleshtear_samples.dmm'
	cost = 5

/area/om_adventure/poi/cabin1
	name = "POI - Cabin 1"

/datum/map_template/om_adventure/outdoor/cabin1
	name = "cabin1"
	desc = "A comfy home!"
	mappath = 'pois/cabin1.dmm'
	cost = 20

/area/om_adventure/poi/cabin2
	name = "POI - Cabin 2"

/datum/map_template/om_adventure/outdoor/cabin2
	name = "cabin2"
	desc = "A comfy home!"
	mappath = 'pois/cabin2.dmm'
	cost = 20

/area/om_adventure/poi/cabin3
	name = "POI - Cabin 3"

/datum/map_template/om_adventure/outdoor/cabin3
	name = "cabin3"
	desc = "A comfy... home?"
	mappath = 'pois/cabin3.dmm'
	cost = 10

/area/om_adventure/poi/camp
	name = "POI - Camp"

/datum/map_template/om_adventure/outdoor/camp
	name = "Camp"
	desc = "A camp!"
	mappath = 'pois/camp.dmm'
	cost = 20

/area/om_adventure/poi/shuttlewreck1
	name = "POI - Shuttlewreck 1"

/datum/map_template/om_adventure/outdoor/shuttlewreck1
	name = "Shuttle wreck"
	desc = "Long abandoned!"
	mappath = 'pois/shuttlewreck1.dmm'
	cost = 5

/area/om_adventure/poi/shuttlewreck2
	name = "POI - Shuttlewreck 2"

/datum/map_template/om_adventure/outdoor/shuttlewreck2
	name = "Shuttle wreck"
	desc = "Long abandoned!"
	mappath = 'pois/shuttlewreck2.dmm'
	cost = 10

/area/om_adventure/poi/shuttlewreck3
	name = "POI - Shuttlewreck 3"

/datum/map_template/om_adventure/outdoor/shuttlewreck3
	name = "Shuttle wreck"
	desc = "Long abandoned!"
	mappath = 'pois/shuttlewreck3.dmm'
	cost = 5

/area/om_adventure/poi/shuttlewreck4
	name = "POI - Shuttlewreck 4"

/datum/map_template/om_adventure/outdoor/shuttlewreck4
	name = "Shuttle wreck"
	desc = "Long abandoned!"
	mappath = 'pois/shuttlewreck4.dmm'
	cost = 10

/area/om_adventure/poi/medicalcenter
	name = "POI - medical center"

/datum/map_template/om_adventure/outdoor/medicalcenter
	name = "Medical Center"
	desc = "Maybe they used to heal people here."
	mappath = 'pois/medicalcenter.dmm'
	cost = 10

/area/om_adventure/poi/shippart1
	name = "POI - ship part 1"

/datum/map_template/om_adventure/outdoor/shippart1
	name = "Ship Part"
	desc = "Something bad happened here."
	mappath = 'pois/shippart1.dmm'
	cost = 10

/area/om_adventure/poi/woodentemple
	name = "POI - Wooden Temple"

/datum/map_template/om_adventure/cave/woodentemple
	name = "Wooden Temple"
	desc = "A comfy wooden temple."
	mappath = 'pois/woodentemple.dmm'
	cost = 10

/area/om_adventure/poi/alienchamber1
	name = "POI - Alien Chamber 1"

/datum/map_template/om_adventure/cave/alienchamber1
	name = "Alien Chamber"
	desc = "A mysterious alien chamber!"
	mappath = 'pois/alienchamber1.dmm'
	cost = 10

/area/om_adventure/poi/alienchamber2
	name = "POI - Alien Chamber 2"

/datum/map_template/om_adventure/cave/alienchamber2
	name = "Alien Chamber"
	desc = "A mysterious alien chamber!"
	mappath = 'pois/alienchamber2.dmm'
	cost = 10

/area/om_adventure/poi/alienchamber3
	name = "POI - Alien Chamber 3"

/datum/map_template/om_adventure/cave/alienchamber3
	name = "Alien Chamber"
	desc = "A mysterious alien chamber!"
	mappath = 'pois/alienchamber3.dmm'
	cost = 10

/area/om_adventure/poi/alienchamber4
	name = "POI - Alien Chamber 4"

/datum/map_template/om_adventure/cave/alienchamber4
	name = "Alien Chamber"
	desc = "A mysterious alien chamber!"
	mappath = 'pois/alienchamber4.dmm'
	cost = 10

/obj/tether_away_spawner/spookyland
	name = "Spookyland Spawner"
	icon = 'icons/mob/randomlandmarks.dmi'
	icon_state = "monster"

	faction = FACTION_SPOOKYLAND
	prob_spawn = 50
	prob_fall = 10
	//guard = 10 //Don't wander too far, to stay alive.
	mobs_to_pick_from = list(
		/mob/living/simple_mob/shadekin/blue = 1,
		/mob/living/simple_mob/shadekin/red = 1,
		/mob/living/simple_mob/shadekin/green = 10,
		/mob/living/simple_mob/shadekin/purple = 1,
		/mob/living/simple_mob/shadekin/yellow = 20,
		/mob/living/simple_mob/vore/alienanimals/space_ghost = 100,
		/mob/living/simple_mob/vore/alienanimals/space_jellyfish = 100,
		/mob/living/simple_mob/faithless = 50,
		/mob/living/simple_mob/mechanical/infectionbot = 30,
		/mob/living/simple_mob/animal/passive/cat/bluespace = 1,
		/mob/living/simple_mob/animal/passive/dog/void_puppy = 1
		)
