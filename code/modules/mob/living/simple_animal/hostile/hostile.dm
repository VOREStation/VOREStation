/mob/living/simple_animal/hostile
	faction = "hostile"
	break_stuff_probability = 10
	stop_automated_movement_when_pulled = 0
	destroy_surroundings = 1
	a_intent = I_HURT
	hostile = 1


/mob/living/simple_animal/hostile/Life()

	. = ..()
	if(!.)
		walk(src, 0)
		return 0