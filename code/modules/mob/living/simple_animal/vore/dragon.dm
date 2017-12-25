/mob/living/simple_animal/hostile/dragon
	name = "red dragon"
	desc = "Here to pillage stations and kidnap princesses, and there probably aren't any princesses."
	icon = 'icons/mob/vore64x64.dmi'
	icon_dead = "reddragon-dead"
	icon_living = "reddragon"
	icon_state = "reddragon"

	faction = "dragon"
	maxHealth = 500 // Boss
	health = 500

	melee_damage_lower = 10
	melee_damage_upper = 60

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

	old_x = -16
	old_y = 0
	pixel_x = -16
	pixel_y = 0

/mob/living/simple_animal/hostile/dragon/Process_Spacemove(var/check_drift = 0)
	return 1	//No drifting in space for space dragons!

/mob/living/simple_animal/hostile/dragon/FindTarget()
	. = ..()
	if(.)
		custom_emote(1,"snaps at [.]")

// Activate Noms!
/mob/living/simple_animal/hostile/dragon
	vore_active = 1
	vore_capacity = 2
	vore_pounce_chance = 0 // Beat them into crit before eating.
	vore_icons = SA_ICON_LIVING

/mob/living/simple_animal/hostile/dragon/virgo3b
	maxHealth = 200
	health = 200
	faction = "virgo3b"
