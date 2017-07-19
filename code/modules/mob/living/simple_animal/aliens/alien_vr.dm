/mob/living/simple_animal/hostile/alien/proc/disable_for_wilderness()
	var/datum/map_z_level/z_level = get_z_level_datum(src)
	if(!istype(z_level, /datum/map_z_level/tether/wilderness))
		return
	var/datum/map_z_level/tether/wilderness/wilderness = z_level
	if(wilderness.activated)
		return
	life_disabled = 1
	wilderness.frozen_mobs += src
	for(var/i = 1 to 20)
		step_rand(src)
		sleep(2)

/mob/living/simple_animal/hostile/alien/wilderness_spawn/New()
	..()
	disable_for_wilderness()

/mob/living/simple_animal/hostile/alien/drone/wilderness_spawn/New()
	..()
	disable_for_wilderness()

/mob/living/simple_animal/hostile/alien/sentinel/wilderness_spawn/New()
	..()
	disable_for_wilderness()

/mob/living/simple_animal/hostile/alien/queen/wilderness_spawn/New()
	..()
	disable_for_wilderness()

/mob/living/simple_animal/hostile/alien/queen/large/wilderness_spawn/New()
	..()
	disable_for_wilderness()