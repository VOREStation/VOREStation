/mob/living/simple_animal/hostile/creature
	name = "creature"
	desc = "A sanity-destroying otherthing."
	icon = 'icons/mob/critter.dmi'
	icon_state = "otherthing"
	icon_living = "otherthing"
	icon_dead = "otherthing-dead"

	faction = "creature"
	intelligence_level = SA_ANIMAL
	maxHealth = 40
	health = 40
	speed = 8

	harm_intent_damage = 8

	melee_damage_lower = 8
	melee_damage_upper = 15
	attack_armor_pen = 5	//It's a horror from beyond, I ain't gotta explain 5 AP
	attack_sharp = 1
	attack_edge = 1

	attacktext = list("chomped")
	attack_sound = 'sound/weapons/bite.ogg'

	speak_emote = list("gibbers")

/mob/living/simple_animal/hostile/creature/cult
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

/mob/living/simple_animal/hostile/creature/cult/cultify()
	return

/mob/living/simple_animal/hostile/creature/cult/Life()
	..()
	check_horde()

/mob/living/simple_animal/hostile/creature/strong
	maxHealth = 160
	health = 160

	harm_intent_damage = 5
	melee_damage_lower = 13
	melee_damage_upper = 25

/mob/living/simple_animal/hostile/creature/strong/cult
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

/mob/living/simple_animal/hostile/creature/cult/cultify()
	return

/mob/living/simple_animal/hostile/creature/cult/Life()
	..()
	check_horde()
