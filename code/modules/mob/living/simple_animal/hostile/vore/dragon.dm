/mob/living/simple_animal/hostile/vore/large/dragon
	name = "phoron dragon"
	desc = "Here to pillage stations and kidnap princesses, and there probably aren't any princesses."
	icon_dead = "reddragon-dead"
	icon_living = "reddragon"
	icon_state = "reddragon"
	maxHealth = 500 // Boss
	health = 500
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/carpmeat
	melee_damage_lower = 10
	melee_damage_upper = 60
	old_y = 0
	pixel_y = 0
	capacity = 2
	faction = "dragon"

	//Space dragons aren't affected by atmos.
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

/mob/living/simple_animal/hostile/vore/large/dragon/Process_Spacemove(var/check_drift = 0)
	return 1	//No drifting in space for space dragons!

/mob/living/simple_animal/hostile/vore/large/dragon/FindTarget()
	. = ..()
	if(.)
		custom_emote(1,"snaps at [.]")