/////LANDING LANDMARKS
/obj/effect/shuttle_landmark/premade/spacerocks/center
	name = "asteroid field center"
	landmark_tag = "sr-c"

/obj/effect/shuttle_landmark/premade/spacerocks/north
	name = "asteroid field north"
	landmark_tag = "sr-n"

/obj/effect/shuttle_landmark/premade/spacerocks/south
	name = "asteroid field south"
	landmark_tag = "sr-s"

/obj/tether_away_spawner/asteroidbaddies
	name = "Asteroid Mob Spawner"
	faction = FACTION_SPACE_ROCK
	atmos_comp = TRUE
	prob_spawn = 100
	prob_fall = 40
	//guard = 20
	mobs_to_pick_from = list(
		/mob/living/simple_mob/vore/alienanimals/space_jellyfish = 1,
		/mob/living/simple_mob/vore/alienanimals/startreader = 3,
		/mob/living/simple_mob/vore/alienanimals/space_ghost = 2,
		/mob/living/simple_mob/vore/oregrub = 1,
		/mob/living/simple_mob/animal/space/ray = 10,
		/mob/living/simple_mob/animal/space/bats = 10,
		/mob/living/simple_mob/animal/space/gnat = 15,
		/mob/living/simple_mob/animal/space/carp = 3,
		/mob/living/simple_mob/animal/space/carp/large = 1,
		/mob/living/simple_mob/animal/space/carp/large/huge = 1
	)
