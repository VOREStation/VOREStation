/mob/living/simple_animal/hostile/pirate
	name = "Pirate"
	desc = "Does what he wants cause a pirate is free."
	icon_state = "piratemelee"
	icon_living = "piratemelee"
	icon_dead = "piratemelee_dead"
	intelligence_level = SA_HUMANOID

	faction = "pirate"
	maxHealth = 100
	health = 100
	speed = 4

	run_at_them = 0
	cooperative = 1
	investigates = 1
	firing_lines = 1
	returns_home = 1
	reacts = 1

	turns_per_move = 5
	stop_when_pulled = 0

	response_help = "pushes"
	response_disarm = "shoves"
	response_harm = "hits"

	harm_intent_damage = 5
	melee_damage_lower = 30
	melee_damage_upper = 30
	attack_armor_pen = 50
	attack_sharp = 1
	attack_edge = 1

	attacktext = list("slashed")
	attack_sound = 'sound/weapons/bladeslice.ogg'

	min_oxy = 5
	max_oxy = 0
	min_tox = 0
	max_tox = 1
	min_co2 = 0
	max_co2 = 5
	min_n2 = 0
	max_n2 = 0
	unsuitable_atoms_damage = 15

	loot_list = list(/obj/item/weapon/melee/energy/sword/pirate = 100)

	var/corpse = /obj/effect/landmark/mobcorpse/pirate

/mob/living/simple_animal/hostile/pirate/ranged
	name = "Pirate Gunner"
	icon_state = "pirateranged"
	icon_living = "pirateranged"
	icon_dead = "piratemelee_dead"

	ranged = 1
	projectiletype = /obj/item/projectile/beam
	projectilesound = 'sound/weapons/laser.ogg'

	loot_list = list(/obj/item/weapon/gun/energy/laser = 100)

	corpse = /obj/effect/landmark/mobcorpse/pirate/ranged

/mob/living/simple_animal/hostile/pirate/death()
	..()
	if(corpse)
		new corpse (src.loc)
	qdel(src)
	return