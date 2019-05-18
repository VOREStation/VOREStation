/obj/tether_away_spawner/debrisfield
	atmos_comp = FALSE

/obj/tether_away_spawner/debrisfield/carp
	name = "debris field carp spawner"
	mobs_to_pick_from = list(
		/mob/living/simple_mob/animal/space/carp = 3,
		/mob/living/simple_mob/animal/space/carp/large = 1
	)

/obj/tether_away_spawner/debrisfield/carp/hard
	mobs_to_pick_from = list(
		/mob/living/simple_mob/animal/space/carp/large = 2,
		/mob/living/simple_mob/animal/space/carp/large/huge = 1
	)


//Sciship
/mob/living/simple_mob/tomato/space
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

/mob/living/simple_mob/tomato/space/Process_Spacemove(var/check_drift = 0)
	return TRUE