/mob/living/simple_animal/hostile/carp/large/huge
	name = "great white carp"
	desc = "You're going to need a bigger ship."
	icon = 'icons/mob/vore64x64.dmi'
	icon_dead = "megacarp-dead"
	icon_living = "megacarp"
	icon_state = "megacarp"

	maxHealth = 600 // Boss
	health = 600
	speed = 3

	meat_amount = 10

	melee_damage_lower = 10
	melee_damage_upper = 25
	old_x = -16
	old_y = -16
	default_pixel_x = -16
	default_pixel_y = -16
	pixel_x = -16
	pixel_y = -16
	vore_capacity = 2

// Activate Noms!
/mob/living/simple_animal/hostile/carp/large
	icon = 'icons/mob/vore64x64.dmi'
	vore_active = 1
	vore_pounce_chance = 50
	vore_capacity = 1
	vore_max_size = RESIZE_HUGE
	vore_icons = SA_ICON_LIVING
