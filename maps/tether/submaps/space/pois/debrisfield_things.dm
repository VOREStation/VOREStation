/obj/tether_away_spawner/debrisfield
	atmos_comp = FALSE
	prob_spawn = 100
	prob_fall = 15

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

/obj/tether_away_spawner/debrisfield/derelict
	name = "debris field derelict random mob spawner"
	faction = "derelict"
	mobs_to_pick_from = list(
		/mob/living/simple_mob/mechanical/corrupt_maint_drone = 2,
		/mob/living/simple_mob/mechanical/infectionbot = 3,
		/mob/living/simple_mob/mechanical/combat_drone = 1
	)

/obj/tether_away_spawner/debrisfield/derelict/corrupt_maint_swarm
	name = "debris field derelict maint swarm"
	faction = "derelict"
	mobs_to_pick_from = list(
		/mob/living/simple_mob/mechanical/corrupt_maint_drone = 4
	)

/obj/tether_away_spawner/debrisfield/derelict/mech_wizard
	name = "debris field derelict wizard lol"
	faction = "derelict"
	mobs_to_pick_from = list(
		/mob/living/simple_mob/mechanical/technomancer_golem = 2
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

/obj/random/slimecore
	name = "random slime core"
	desc = "Random slime core."
	icon = 'icons/mob/slimes.dmi'
	icon_state = "rainbow slime extract"

/obj/random/slimecore/item_to_spawn()
	return pick(prob(3);/obj/item/slime_extract/metal,
				prob(3);/obj/item/slime_extract/blue,
				prob(3);/obj/item/slime_extract/purple,
				prob(3);/obj/item/slime_extract/orange,
				prob(3);/obj/item/slime_extract/yellow,
				prob(3);/obj/item/slime_extract/gold,
				prob(3);/obj/item/slime_extract/silver,
				prob(3);/obj/item/slime_extract/dark_purple,
				prob(3);/obj/item/slime_extract/dark_blue,
				prob(3);/obj/item/slime_extract/red,
				prob(3);/obj/item/slime_extract/green,
				prob(3);/obj/item/slime_extract/pink,
				prob(2);/obj/item/slime_extract/oil,
				prob(2);/obj/item/slime_extract/bluespace,
				prob(2);/obj/item/slime_extract/cerulean,
				prob(2);/obj/item/slime_extract/amber,
				prob(2);/obj/item/slime_extract/sapphire,
				prob(2);/obj/item/slime_extract/ruby,
				prob(2);/obj/item/slime_extract/emerald,
				prob(2);/obj/item/slime_extract/light_pink,
				prob(1);/obj/item/slime_extract/grey,
				prob(1);/obj/item/slime_extract/rainbow)