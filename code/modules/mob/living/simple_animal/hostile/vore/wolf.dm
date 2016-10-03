/mob/living/simple_animal/hostile/vore/wolf
	name = "white wolf"
	desc = "These gluttonous little bastards used to be regular lizards that were mutated by long-term exposure to phoron!"
	icon_dead = "wolf-dead"
	icon_living = "wolf"
	icon_state = "dino"
	icon = 'icons/mob/vore.dmi'
	var/capacity = 1 // Zero is infinite. Do not set higher than you have icons to update.
	var/max_size = 1 // Max: 2
	var/min_size = 0.25 // Min: 0.25
	var/picky = 1 // Won't eat undigestable prey by default
	var/fullness = 0
	swallowTime = 1 // Hungry little bastards.

	// By default, this is what most vore mobs are capable of.
	response_help = "pets"
	response_disarm = "gently pushes aside"
	response_harm = "hits"
	speed = 4
	harm_intent_damage = 5
	melee_damage_lower = 10
	melee_damage_upper = 25
	attacktext = "bitten"
	attack_sound = 'sound/weapons/bite.ogg'
	min_oxy = 5
	max_oxy = 0
	min_tox = 0
	max_tox = 1
	min_co2 = 0
	max_co2 = 5
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 200
	maxbodytemp = 370
	heat_damage_per_tick = 15
	cold_damage_per_tick = 10
	unsuitable_atoms_damage = 10