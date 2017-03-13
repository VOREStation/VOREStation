/mob/living/simple_animal/hostile/vore/alien
	name = "alien hunter"
	desc = "Hiss!"
	icon_state = "xenohunter"
	icon_living = "xenohunter"
	icon_dead = "xenohunter-dead"
	icon_gib = "gibbed-a"
	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"
	speed = -1
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/xenomeat
	maxHealth = 100
	health = 100
	harm_intent_damage = 5
	melee_damage_lower = 25
	melee_damage_upper = 25
	attacktext = "slashed"
	a_intent = "harm"
	attack_sound = 'sound/weapons/bladeslice.ogg'
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	unsuitable_atoms_damage = 15
	faction = "alien"
	environment_smash = 1
	status_flags = CANPUSH
	minbodytemp = 0
	heat_damage_per_tick = 20
	capacity = 1


/mob/living/simple_animal/hostile/vore/alien/drone
	name = "alien drone"
	icon_state = "xenodrone"
	icon_living = "xenodrone"
	icon_dead = "xenodrone-dead"
	health = 60
	melee_damage_lower = 15
	melee_damage_upper = 15

/mob/living/simple_animal/hostile/vore/alien/sentinel
	name = "alien sentinel"
	icon_state = "xenosentinel"
	icon_living = "xenosentinel"
	icon_dead = "xenosentinel-dead"
	health = 120
	melee_damage_lower = 30 // Buffed from 15 since vore doesn't work for ranged mobs.
	melee_damage_upper = 30
//	ranged = 1
//	projectiletype = /obj/item/projectile/neurotox
//	projectilesound = 'sound/weapons/pierce.ogg'


/mob/living/simple_animal/hostile/vore/alien/queen
	name = "alien queen"
	icon_state = "xenoqueen"
	icon_living = "xenoqueen"
	icon_dead = "xenoqueen-dead"
	maxHealth = 250
	melee_damage_lower = 30 // Buffed from 15 since vore doesn't work for ranged mobs.
	melee_damage_upper = 30
//	ranged = 1
	move_to_delay = 3
//	projectiletype = /obj/item/projectile/neurotox
//	projectilesound = 'sound/weapons/pierce.ogg'
//	rapid = 1
	status_flags = 0

/mob/living/simple_animal/hostile/vore/alien/queen/large
	name = "alien empress"
	icon = 'icons/mob/vore64x64.dmi'
	icon_state = "queen_s"
	icon_living = "queen_s"
	icon_dead = "queen_dead"
	faction = "alien"
	move_to_delay = 4
	maxHealth = 400
	health = 400
	old_x = -16
	old_y = 0
	pixel_x = -16
	pixel_y = 0
	capacity = 3
	pouncechance = 75

/obj/item/projectile/neurotox
	damage = 30
	icon_state = "toxin"

/mob/living/simple_animal/hostile/vore/alien/death()
	..()
	visible_message("[src] lets out a waning guttural screech, green blood bubbling from its maw...")
	playsound(src, 'sound/voice/hiss6.ogg', 100, 1)
	invisibility = 25 // To reset invisibility to be visible.