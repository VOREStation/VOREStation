/mob/living/simple_animal/hostile/vore/creature
	name = "creature"
	desc = "A sanity-destroying otherthing."
	icon = 'icons/mob/critter.dmi'
	speak_emote = list("gibbers")
	icon_state = "otherthing"
	icon_living = "otherthing"
	icon_dead = "otherthing-dead"
	health = 80
	maxHealth = 80
	melee_damage_lower = 25
	melee_damage_upper = 50
	attacktext = "chomped"
	attack_sound = 'sound/weapons/bite.ogg'
	faction = "creature"
	speed = 4
	capacity = 0
	max_size = 2 // Max: 2
	min_size = 0.25 // Min: 0.25
	pouncechance = 0 // Only pounces if you're crit.
	escapable = 0 // As such, if you're a dibshit who feeds yourself to it, you're staying down.

/mob/living/simple_animal/hostile/vore/creature/cult
	faction = "cult"

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	supernatural = 1

/mob/living/simple_animal/hostile/vore/creature/cult/cultify()
	return

/mob/living/simple_animal/hostile/vore/creature/cult/Life()
	..()
	check_horde()
