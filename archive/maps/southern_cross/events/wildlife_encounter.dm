// This event sends random sif mobs at someone in the wilderness, unannounced.

/datum/event2/meta/wildlife_encounter
	name = "random encounter"
	departments = list(DEPARTMENT_EVERYONE)
	chaos = 10
	event_type = /datum/event2/event/wildlife_encounter

/datum/event2/meta/wildlife_encounter/get_weight()
	var/explorers = metric.count_people_with_job(/datum/job/explorer) + metric.count_people_with_job(/datum/job/sar)

	if(!explorers)
		return 0
	return 20 + explorers * 50

/datum/event2/event/wildlife_encounter
	var/mob/living/victim = null
	var/list/potential_victims = list()

/datum/event2/event/wildlife_encounter/set_up()
	for(var/mob/living/L in player_list)
		//if(!(L.z in get_location_z_levels()))
		//	log_debug("Not on the right z-level")
		//	continue // Not on the right z-level.
		if(L.stat)
			continue // Don't want dead people.
		var/turf/T = get_turf(L)
		var/area/A = get_area(L)
		if(T?.is_outdoors() && istype(A, /area/tether/outpost/exploration_plains)) // VOREStation Edit
			potential_victims += L

	if(potential_victims.len)
		victim = pick(potential_victims)

/datum/event2/event/wildlife_encounter/start()
	if(!victim)
		log_debug("Failed to find a target for random encounter. Aborting.")
		abort()
		return

	var/number_of_packs = rand(1, 3)
	// Getting off screen tiles is kind of tricky due to potential edge cases that could arise.
	// The method we're gonna do is make a big square around the victim, then
	// subtract a smaller square in the middle for the default vision range.

	var/list/outer_square = get_safe_square(victim, world.view + 5)
	var/list/inner_square = get_safe_square(victim, world.view + 1)

	var/list/donut = outer_square - inner_square
	for(var/T in donut)
		if(!istype(T, /turf/simulated/floor/outdoors))
			donut -= T

	var/build_path = item_to_spawn()
	var/turf/spawning_turf = null
	var/attempts = 0

	while (!spawning_turf && attempts != 10)
		spawning_turf = pick(donut)
		for(var/i = 1 to potential_victims.len)
			if (get_dist(spawning_turf, potential_victims[i]) < world.view)
				spawning_turf = null
				log_debug("Failed to locate position out of sight of [potential_victims[i]].")
		attempts++

	potential_victims = null

	log_debug("Sending [number_of_packs] [build_path]\s after \the [victim].")
	for(var/i = 1 to number_of_packs)

		if(spawning_turf)
			var/mob/living/simple_mob/M = new build_path(spawning_turf)
			M.ai_holder?.give_destination(get_turf(victim))
		else
			log_debug("Failed to locate turf to spawn encounter.")

/datum/event2/event/wildlife_encounter/proc/item_to_spawn()
	return pick(prob(22);/mob/living/simple_mob/animal/sif/savik,
				prob(20);/mob/living/simple_mob/animal/sif/frostfly,
				prob(10);/mob/living/simple_mob/animal/sif/tymisian,
				prob(45);/mob/living/simple_mob/animal/sif/shantak,
				prob(15);/mob/living/simple_mob/animal/sif/kururak/hibernate,
				prob(10);/mob/living/simple_mob/animal/sif/kururak,
				prob(3);/mob/living/simple_mob/animal/giant_spider,
				prob(8);/mob/living/simple_mob/animal/giant_spider/hunter,
				prob(3);/mob/living/simple_mob/animal/giant_spider/webslinger,
				prob(3);/mob/living/simple_mob/animal/giant_spider/carrier,
				prob(6);/mob/living/simple_mob/animal/giant_spider/lurker,
				prob(4);/mob/living/simple_mob/animal/giant_spider/tunneler,
				prob(5);/mob/living/simple_mob/animal/giant_spider/pepper,
				prob(5);/mob/living/simple_mob/animal/giant_spider/thermic,
				prob(1);/mob/living/simple_mob/animal/giant_spider/phorogenic,
				prob(30);/mob/living/simple_mob/animal/giant_spider/frost)

/datum/event2/event/wildlife_encounter/proc/get_safe_square(atom/center, radius)
	var/lower_left_x = max(center.x - radius, 1 + TRANSITIONEDGE)
	var/lower_left_y = max(center.y - radius, 1 + TRANSITIONEDGE)

	var/upper_right_x = min(center.x + radius, world.maxx - TRANSITIONEDGE)
	var/upper_right_y = min(center.y + radius, world.maxy - TRANSITIONEDGE)

	var/turf/lower_left = locate(lower_left_x, lower_left_y, victim.z)
	var/turf/upper_right = locate(upper_right_x, upper_right_y, victim.z)

	return block(lower_left, upper_right)
