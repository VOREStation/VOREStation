/mob/living/simple_animal/hostile/deathclaw
	name = "deathclaw"
	desc = "Big! Big! The size of three men! Claws as long as my forearm! Ripped apart! Ripped apart!"
	icon = 'icons/mob/vore64x64.dmi'
	icon_dead = "deathclaw-dead"
	icon_living = "deathclaw"
	icon_state = "deathclaw"

	attacktext = "mauled"

	faction = "deathclaw"

	maxHealth = 200
	health = 200

	melee_damage_lower = 10
	melee_damage_upper = 60

	old_x = -16
	old_y = 0
	pixel_x = -16
	pixel_y = 0

// Activate Noms!
/mob/living/simple_animal/hostile/deathclaw
	vore_active = 1
	vore_capacity = 2
	vore_max_size = RESIZE_HUGE
	vore_min_size = RESIZE_SMALL
	vore_pounce_chance = 0 // Beat them into crit before eating.
	vore_icons = SA_ICON_LIVING
