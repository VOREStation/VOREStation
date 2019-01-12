/mob/living/simple_animal/hostile/carp/pike
	name = "space pike"
	desc = "A bigger, angrier cousin of the space carp."
	icon = 'icons/mob/spaceshark.dmi'
	icon_state = "shark"
	icon_living = "shark"
	icon_dead = "shark_dead"

	maxHealth = 150
	health = 150
	speed = 0
	move_to_delay = 2

	turns_per_move = 2
	mob_size = MOB_LARGE

	harm_intent_damage = 5
	melee_damage_lower = 20
	melee_damage_upper = 25

	meat_amount = 10

	old_x = -16
	pixel_x = -16

	vore_icons = 0 //No custom icons yet

/mob/living/simple_animal/hostile/carp/pike/weak
	maxHealth = 75
	health = 75

/mob/living/simple_animal/hostile/carp/strong
	maxHealth = 50
	health = 50
