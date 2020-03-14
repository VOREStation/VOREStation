/obj/effect/overmap/visitable/sector/tether_gateway/snowoutpost
	initial_generic_waypoints = list("tether_excursion_snow_outpost")
	true_name = "Snowy Outpost"
	true_desc = "Scans indicate this planetoid has a very cold atmosphere and almost perpetual snow. There are signs of habitation on the surface."

// -- Areas -- //

/area/awaymission/snow_outpost
	icon_state = "blank"
	mobcountmax = 0
	floracountmax = 0
	base_turf = /turf/snow/snow2
	ambience = list('sound/music/main.ogg', 'sound/ambience/maintenance/maintenance4.ogg', 'sound/ambience/sif/sif1.ogg', 'sound/ambience/ruins/ruins1.ogg')
	base_turf = /turf/simulated/floor/snow/snow2

/area/awaymission/snow_outpost/outside
	icon_state = "away1"
	always_unpowered = 1
	dynamic_lighting = 0
	mobcountmax = 50
	floracountmax = 300
	valid_mobs = list(/mob/living/simple_mob/animal/sif/savik, /mob/living/simple_mob/animal/wolf, /mob/living/simple_mob/animal/sif/shantak,
					  /mob/living/simple_mob/animal/sif/kururak, /mob/living/simple_mob/animal/sif/frostfly)
	valid_flora = list(/obj/structure/flora/tree/pine, /obj/structure/flora/tree/pine, /obj/structure/flora/tree/pine,
					/obj/structure/flora/tree/dead, /obj/structure/flora/grass/brown, /obj/structure/flora/grass/green,
					/obj/structure/flora/grass/both, /obj/structure/flora/bush, /obj/structure/flora/ausbushes/grassybush,
					/obj/structure/flora/ausbushes/sunnybush, /obj/structure/flora/ausbushes/genericbush, /obj/structure/flora/ausbushes/pointybush,
					/obj/structure/flora/ausbushes/lavendergrass, /obj/structure/flora/ausbushes/sparsegrass, /obj/structure/flora/ausbushes/fullgrass)

/area/awaymission/snow_outpost/outside/EvalValidSpawnTurfs()
	..()
	if(mobcountmax || floracountmax)
		for(var/turf/simulated/floor/water/W in src)
			valid_spawn_turfs -= W
		for(var/turf/simulated/floor/outdoors/ice/I in src)
			valid_spawn_turfs -= I

/area/awaymission/snow_outpost/dark
	icon_state = "red"
	requires_power = 1
	always_unpowered = 1
	dynamic_lighting = 1

/area/awaymission/snow_outpost/outside/nospawn
	icon_state = "away2"
	mobcountmax = 0
	floracountmax = 0

/area/awaymission/snow_outpost/powered
	requires_power = 0
	dynamic_lighting = 1
	icon_state = "away"
	ambience = list('sound/ambience/chapel/chapel1.ogg', 'sound/ambience/ruins/ruins5.ogg', 'sound/ambience/ruins/ruins1.ogg')  // Rykka was here. <3
