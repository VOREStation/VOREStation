/datum/random_map/noise/ore/underdark
	descriptor = "Underdark ore distribution map"
	deep_val = 0.7
	rare_val = 0.5

// Weakened version of Phoron spiders
/mob/living/simple_mob/animal/giant_spider/phorogenic/weak
	maxHealth = 100
	health = 100

	melee_damage_lower = 10
	melee_damage_upper = 25
	attack_armor_pen = 10

	poison_chance = 20

// Adds Phoron Wolf
/mob/living/simple_mob/vore/wolf/phoron

	faction = FACTION_UNDERDARK
	movement_cooldown = -1.5

	harm_intent_damage = 5
	melee_damage_lower = 5
	melee_damage_upper = 12

	minbodytemp = 200

// Lazy way of making sure wolves survive outside.
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0

// Underdark mob spawners
/obj/tether_away_spawner/underdark_drone_swarm
	name = "Underdark Drone Swarm Spawner"
	faction = FACTION_UNDERDARK
	atmos_comp = TRUE
	prob_spawn = 100
	prob_fall = 10
	//guard = 20
	mobs_to_pick_from = list(
		/mob/living/simple_mob/mechanical/corrupt_maint_drone = 3,
	)

/obj/tether_away_spawner/underdark_normal
	name = "Underdark Normal Spawner"
	faction = FACTION_UNDERDARK
	atmos_comp = TRUE
	prob_spawn = 100
	prob_fall = 50
	//guard = 20
	mobs_to_pick_from = list(
		/mob/living/simple_mob/animal/giant_spider/hunter = 3,
		/mob/living/simple_mob/animal/giant_spider/phorogenic/weak = 3,
		/mob/living/simple_mob/animal/giant_spider/tunneler = 3,
		/mob/living/simple_mob/vore/oregrub = 1,
	)

/obj/tether_away_spawner/underdark_hard
	name = "Underdark Hard Spawner"
	faction = FACTION_UNDERDARK
	atmos_comp = TRUE
	prob_spawn = 100
	prob_fall = 50
	//guard = 20
	mobs_to_pick_from = list(
		/mob/living/simple_mob/vore/aggressive/corrupthound = 3,
		/mob/living/simple_mob/vore/aggressive/rat/phoron = 6,
		/mob/living/simple_mob/vore/oregrub/lava = 1,
	)

/obj/tether_away_spawner/underdark_boss
	name = "Underdark Boss Spawner"
	faction = FACTION_UNDERDARK
	atmos_comp = TRUE
	prob_spawn = 100
	prob_fall = 100
	//guard = 70
	mobs_to_pick_from = list(
		/mob/living/simple_mob/vore/aggressive/dragon = 1
	)

//POI STUFF
VIRGO3B_TURF_CREATE(/turf/simulated/mineral/ignore_oregen)
VIRGO3B_TURF_CREATE(/turf/simulated/mineral/floor/ignore_oregen)
VIRGO3B_TURF_CREATE(/turf/simulated/mineral/ignore_cavegen)
VIRGO3B_TURF_CREATE(/turf/simulated/mineral/floor/ignore_cavegen)

//Vault2
VIRGO3B_TURF_CREATE(/turf/simulated/floor/tiled/freezer)

//Abandonedshelter
VIRGO3B_TURF_CREATE(/turf/simulated/shuttle/floor/voidcraft)

//Goldhall
VIRGO3B_TURF_CREATE(/turf/simulated/floor/tiled/kafel_full/yellow)

//Mechbay
/obj/mecha/working/ripley/abandoned/Initialize()
	. = ..()
	for(var/obj/item/mecha_parts/mecha_tracking/B in src.contents)	//Deletes the beacon so it can't be found easily
		qdel(B)
