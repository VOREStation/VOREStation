// 'Space' mobs don't care about atmos (like carp)
/mob/living/simple_mob/animal/space
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

// They can also, you know, move around, in space
/mob/living/simple_mob/animal/space/Process_Spacemove(var/check_drift = 0)
	return TRUE