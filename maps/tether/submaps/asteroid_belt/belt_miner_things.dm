// Belt mob spawners
/obj/tether_away_spawner/belt_normal
	name = "Belt Normal Spawner"
	faction = "belter"
	atmos_comp = TRUE
	prob_spawn = 100
	prob_fall = 50
	//guard = 20
	mobs_to_pick_from = list(
		/mob/living/simple_mob/animal/giant_spider/hunter = 1,
		/mob/living/simple_mob/animal/giant_spider/phorogenic/weak = 1,
		/mob/living/simple_mob/animal/giant_spider/tunneler = 1,
	)

/obj/tether_away_spawner/belt_hard
	name = "Belt Hard Spawner"
	faction = "belter"
	atmos_comp = TRUE
	prob_spawn = 100
	prob_fall = 50
	//guard = 20
	mobs_to_pick_from = list(
		/mob/living/simple_mob/vore/aggressive/corrupthound = 1,
		/mob/living/simple_mob/vore/aggressive/rat/phoron = 2
	)

/obj/tether_away_spawner/belt_boss
	name = "Belt Boss Spawner"
	faction = "belter"
	atmos_comp = TRUE
	prob_spawn = 100
	prob_fall = 100
	//guard = 70
	mobs_to_pick_from = list(
		/mob/living/simple_mob/vore/aggressive/dragon = 1
	)

/obj/random/asteroid_belt
	name = "random asteroid belt loot"
	desc = "Random loot for Belt Miners."
	icon = 'icons/obj/items.dmi'
	icon_state = "spickaxe"
