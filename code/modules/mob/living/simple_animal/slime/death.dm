/mob/living/simple_animal/slime/death(gibbed)

	if(stat == DEAD)
		return

	if(!gibbed && is_adult)
		var/death_type = type_on_death
		if(!death_type)
			death_type = src.type
		var/mob/living/simple_animal/slime/S = make_new_slime(death_type)
		S.rabid = TRUE
		step_away(S, src)
		is_adult = FALSE
		maxHealth = initial(maxHealth)
		revive()
		if(!client)
			rabid = TRUE
		number = rand(1, 1000)
		update_name()
		return

	stop_consumption()
	. = ..(gibbed, "stops moving and partially dissolves...")

	update_icon()

	return