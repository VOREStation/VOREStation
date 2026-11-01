//Fire aberration
/obj/effect/abstract/aberration/spawner
	name = "Spawner aberration"

	///What range we spawn our effects.
	var/range = 4

	///If we use random range or not
	var/random_range = TRUE

	///Minimum range of effects
	var/random_min = 3

	///Maximum range of effects
	var/random_max = 5

	///How much the % chance drops the further it goes outwards. Avoids having a giant square.
	var/percent_drop = 15

	///What effect we spawn
	var/effect_to_spawn

	///If we qdel after we place our stuff or not.
	var/delete_after_placement = TRUE

	// Store the results of the randomized effect rolls, so that if we pulse multiple times we will not pick new spots to generate effects
	var/list/prior_random_rolls = list()

	start_active = FALSE


/obj/effect/abstract/aberration/spawner/Initialize(mapload)
	if(!effect_to_spawn)
		return INITIALIZE_HINT_QDEL
	. = ..()
	if(random_range)
		range = rand(random_min, random_max)
		place_effects()
	if(delete_after_placement)
		return INITIALIZE_HINT_QDEL

/obj/effect/abstract/aberration/spawner/Destroy()
	prior_random_rolls.Cut()
	. = ..()


/obj/effect/abstract/aberration/spawner/proc/place_effects()
	// First spawn uses a ranged probability to spawn effects
	if(!length(prior_random_rolls))
		for(var/turf/simulated/turf in range(src, range))
			var/how_far = get_dist(src, turf)
			var/roll = prob(100 - ((how_far - 1) * percent_drop))
			prior_random_rolls[turf] = roll
			if(roll)
				get_effect(turf)
		return
	// All after reuse the first rolled turfs to prevent making giant squares of effects
	for(var/turf/simulated/turf in prior_random_rolls)
		if(prior_random_rolls[turf])
			get_effect(turf)

/obj/effect/abstract/aberration/spawner/proc/get_effect(turf/spawn_turf)
	var/obj/thing_to_find = locate(effect_to_spawn) in spawn_turf
	if(thing_to_find)
		return
	new effect_to_spawn(spawn_turf)
