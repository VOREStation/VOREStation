/mob/living/simple_animal/hostile/savik
	name = "savik"
	desc = "A fast, armoured predator accustomed to hiding and ambushing in cold terrain."
	faction = "savik"
	icon_state = "savik"
	icon_living = "savik"
	icon_dead = "savik_dead"
	icon = 'icons/jungle.dmi'

	faction = "savik"

	maxHealth = 125
	health = 125
	speed = 2
	move_to_delay = 2

	melee_damage_lower = 15
	melee_damage_upper = 35
	attack_armor_pen = 15
	attack_sharp = 1
	attack_edge = 1

	attacktext = list("mauled")
	cold_damage_per_tick = 0

	speak_chance = 5
	speak = list("Hruuugh!","Hrunnph")
	emote_see = list("paws the ground","shakes its mane","stomps")
	emote_hear = list("snuffles")

/mob/living/simple_animal/hostile/savik/handle_stance(var/new_stance)
	..(new_stance)
	if(stance == STANCE_ATTACK || stance == STANCE_ATTACKING)
		if((health / maxHealth) <= 0.5) // At half health, and fighting someone currently.
			add_modifier(/datum/modifier/berserk, 30 SECONDS)