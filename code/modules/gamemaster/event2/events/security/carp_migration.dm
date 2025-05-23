/datum/event2/meta/carp_migration
	name = "carp migration"
	event_class = "carp"
	departments = list(DEPARTMENT_SECURITY, DEPARTMENT_EVERYONE)
	chaos = 30
	chaotic_threshold = EVENT_CHAOS_THRESHOLD_MEDIUM_IMPACT
	event_type = /datum/event2/event/mob_spawning/carp_migration

/datum/event2/meta/carp_migration/get_weight()
	return 10 + (metric.count_people_in_department(DEPARTMENT_SECURITY) * 20) + (metric.count_all_space_mobs() * 40)


/datum/event2/event/mob_spawning/carp_migration
	announce_delay_lower_bound = 1 MINUTE
	announce_delay_upper_bound = 2 MINUTES
	length_lower_bound = 30 SECONDS
	length_upper_bound = 1 MINUTE
	var/carp_cap = 30 // No more than this many (living) carp can exist from this event.
	var/carp_smallest_group = 3
	var/carp_largest_group = 5
	var/carp_wave_cooldown = 10 SECONDS

	var/last_carp_wave_time = null // Last world.time we spawned a carp wave.

/datum/event2/event/mob_spawning/carp_migration/announce()
	var/announcement = "Unknown biological entities been detected near \the [location_name()], please stand-by."
	command_announcement.Announce(announcement, "Lifesign Alert")

/datum/event2/event/mob_spawning/carp_migration/event_tick()
	if(last_carp_wave_time + carp_wave_cooldown > world.time)
		return
	last_carp_wave_time = world.time

	if(count_spawned_mobs() < carp_cap)
		spawn_mobs_in_space(
			mob_type = /mob/living/simple_mob/animal/space/carp/event,
			number_of_groups = rand(1, 4),
			min_size_of_group = carp_smallest_group,
			max_size_of_group = carp_largest_group
		)

/datum/event2/event/mob_spawning/carp_migration/end()
	// Clean up carp that died in space for some reason.
	for(var/mob/living/simple_mob/SM in spawned_mobs)
		if(SM.stat == DEAD)
			var/turf/T = get_turf(SM)
			if(istype(T, /turf/space))
				if(prob(75))
					qdel(SM)
