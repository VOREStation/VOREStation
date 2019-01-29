/mob/living/simple_mob/vore/giant_snake
	name = "giant snake"
	desc = "Snakes. Why did it have to be snakes?"

	icon_dead = "snake-dead"
	icon_living = "snake"
	icon_state = "snake"
	icon = 'icons/mob/vore64x64.dmi'

	faction = "snake"
	maxHealth = 200
	health = 200

	melee_damage_lower = 10
	melee_damage_upper = 25

	old_x = -16
	old_y = -16
	default_pixel_x = -16
	default_pixel_y = -16
	pixel_x = -16
	pixel_y = -16

	ai_holder_type = /datum/ai_holder/simple_mob/melee/hit_and_run

// Activate Noms!
/mob/living/simple_mob/vore/giant_snake
	vore_active = 1
	vore_pounce_chance = 25
	vore_icons = SA_ICON_LIVING
	swallowTime = 2 SECONDS // Hungry little bastards.
