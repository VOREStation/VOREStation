/mob/living/simple_mob/humanoid
	mob_class = MOB_CLASS_HUMANOID

	// Generic humanoid mob tolerances
	min_oxy = 5
	max_oxy = 0
	min_tox = 0
	max_tox = 1
	min_co2 = 0
	max_co2 = 5
	min_n2 = 0
	max_n2 = 0
	unsuitable_atoms_damage = 15

	health = 150			// Point of human crit, as of commenting
	maxHealth = 150

	// Most humans leave a corpse
	var/corpse = null

/mob/living/simple_mob/humanoid/death()
	..()
	if(corpse)
		new corpse (src.loc)
	qdel(src)
	return