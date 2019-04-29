// Weakened version of Phoron spiders
/mob/living/simple_mob/animal/giant_spider/phorogenic/weak
	maxHealth = 100
	health = 100

	melee_damage_lower = 10
	melee_damage_upper = 25
	attack_armor_pen = 10

	poison_chance = 20

// Underdark mob spawners
/obj/tether_away_spawner/underdark_normal
	name = "Underdark Normal Spawner"
	faction = "underdark"
	atmos_comp = TRUE
	prob_spawn = 100
	prob_fall = 50
	//guard = 20
	mobs_to_pick_from = list(
		/mob/living/simple_mob/animal/giant_spider/hunter = 1,
		/mob/living/simple_mob/animal/giant_spider/phorogenic/weak = 1,
		/mob/living/simple_mob/animal/giant_spider/tunneler = 1,
	)

/obj/tether_away_spawner/underdark_hard
	name = "Underdark Hard Spawner"
	faction = "underdark"
	atmos_comp = TRUE
	prob_spawn = 100
	prob_fall = 50
	//guard = 20
	mobs_to_pick_from = list(
		/mob/living/simple_mob/vore/aggressive/corrupthound = 1,
		/mob/living/simple_mob/vore/aggressive/rat/phoron = 2
	)

/obj/tether_away_spawner/underdark_boss
	name = "Underdark Boss Spawner"
	faction = "underdark"
	atmos_comp = TRUE
	prob_spawn = 100
	prob_fall = 100
	//guard = 70
	mobs_to_pick_from = list(
		/mob/living/simple_mob/vore/aggressive/dragon = 1
	)



//POI STUFF

//Goldhall
VIRGO3B_TURF_CREATE(/turf/simulated/floor/tiled/kafel_full/yellow)

/obj/item/weapon/reagent_containers/food/condiment/ketchup/Initialize()
	. = ..()
	reagents.add_reagent("ketchup", 50)

//