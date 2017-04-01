/mob/living/simple_animal/hostile/russian
	name = "russian"
	desc = "For the Motherland!"
	icon_state = "russianmelee"
	icon_living = "russianmelee"
	icon_dead = "russianmelee_dead"
	icon_gib = "syndicate_gib"

	faction = "russian"
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
	status_flags = CANPUSH

	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"

	harm_intent_damage = 5
	melee_damage_lower = 15
	melee_damage_upper = 15
	attacktext = "punched"

	min_oxy = 5
	max_oxy = 0
	min_tox = 0
	max_tox = 1
	min_co2 = 0
	max_co2 = 5
	min_n2 = 0
	max_n2 = 0
	unsuitable_atoms_damage = 15

	loot_list = list(/obj/item/weapon/material/knife = 100)

	var/corpse = /obj/effect/landmark/mobcorpse/russian

/mob/living/simple_animal/hostile/russian/ranged
	icon_state = "russianranged"
	icon_living = "russianranged"

	ranged = 1
	projectiletype = /obj/item/projectile/bullet
	casingtype = /obj/item/ammo_casing/spent
	projectilesound = 'sound/weapons/Gunshot.ogg'

	loot_list = list(/obj/item/weapon/gun/projectile/revolver/mateba = 100)

	corpse = /obj/effect/landmark/mobcorpse/russian/ranged

/mob/living/simple_animal/hostile/russian/death()
	..()
	if(corpse)
		new corpse (src.loc)
	qdel(src)
	return
