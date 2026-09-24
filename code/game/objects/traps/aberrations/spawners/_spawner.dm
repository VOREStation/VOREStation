//Fire abberation
/obj/effect/abstract/abberation/spawner
	name = "Spawner Abberation"

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

	start_active = FALSE


/obj/effect/abstract/abberation/spawner/Initialize(mapload)
	if(!effect_to_spawn)
		return INITIALIZE_HINT_QDEL
	. = ..()
	if(random_range)
		range = rand(random_min, random_max)
		place_effects()
	if(delete_after_placement)
		return INITIALIZE_HINT_QDEL

/obj/effect/abstract/abberation/spawner/proc/place_effects()
	for(var/turf/simulated/turf in range(src, range))
		var/how_far = get_dist(src, turf)
		if(prob(100 - ((how_far - 1) * percent_drop))) //100% at 1 range, 85 at 2 range, 70 at 3, 55 at 4, 40 at 5
			var/obj/thing_to_find = locate(effect_to_spawn) in turf
			if(thing_to_find)
				continue
			new effect_to_spawn(turf)
