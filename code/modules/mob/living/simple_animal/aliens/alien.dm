/mob/living/simple_animal/hostile/alien
	name = "alien hunter"
	desc = "Hiss!"
	icon = 'icons/mob/alien.dmi'
	icon_state = "alienh_running"
	icon_living = "alienh_running"
	icon_dead = "alien_l"
	icon_gib = "syndicate_gib"
	icon_rest = "alienh_sleep"

	faction = "xeno"
	intelligence_level = SA_HUMANOID
	cooperative = 1
	run_at_them = 0

	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"

	maxHealth = 100
	health = 100
	speed = -1

	harm_intent_damage = 5
	melee_damage_lower = 25
	melee_damage_upper = 25

	attacktext = "slashed"
	attack_sound = 'sound/weapons/bladeslice.ogg'
	a_intent = I_HURT

	environment_smash = 2
	status_flags = CANPUSH

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	heat_damage_per_tick = 20
	unsuitable_atoms_damage = 15

	meat_type = /obj/item/weapon/reagent_containers/food/snacks/xenomeat

/mob/living/simple_animal/hostile/alien/drone
	name = "alien drone"
	icon_state = "aliend_running"
	icon_living = "aliend_running"
	icon_dead = "aliend_l"
	icon_rest = "aliend_sleep"
	health = 60
	melee_damage_lower = 15
	melee_damage_upper = 15

/mob/living/simple_animal/hostile/alien/sentinel
	name = "alien sentinel"
	icon_state = "aliens_running"
	icon_living = "aliens_running"
	icon_dead = "aliens_l"
	icon_rest = "aliens_sleep"
	health = 120
	melee_damage_lower = 15
	melee_damage_upper = 15
	ranged = 1
	projectiletype = /obj/item/projectile/energy/neurotoxin/toxic
	projectilesound = 'sound/weapons/pierce.ogg'

/mob/living/simple_animal/hostile/alien/sentinel/praetorian
	name = "alien praetorian"
	icon = 'icons/mob/64x64.dmi'
	icon_state = "prat_s"
	icon_living = "prat_s"
	icon_dead = "prat_dead"
	icon_rest = "prat_sleep"
	move_to_delay = 5
	maxHealth = 200
	health = 200

	pixel_x = -16
	old_x = -16
	meat_amount = 5

/mob/living/simple_animal/hostile/alien/queen
	name = "alien queen"
	icon_state = "alienq_running"
	icon_living = "alienq_running"
	icon_dead = "alienq_l"
	icon_rest = "alienq_sleep"
	health = 250
	maxHealth = 250
	melee_damage_lower = 15
	melee_damage_upper = 15
	ranged = 1
	move_to_delay = 3
	projectiletype = /obj/item/projectile/energy/neurotoxin/toxic
	projectilesound = 'sound/weapons/pierce.ogg'
	rapid = 1
	status_flags = 0

/mob/living/simple_animal/hostile/alien/queen/empress
	name = "alien empress"
	icon = 'icons/mob/64x64.dmi'
	icon_state = "queen_s"
	icon_living = "queen_s"
	icon_dead = "queen_dead"
	icon_rest = "queen_sleep"
	move_to_delay = 4
	maxHealth = 400
	health = 400
	meat_amount = 5
	speed = 1

	pixel_x = -16
	old_x = -16

/mob/living/simple_animal/hostile/alien/queen/empress/mother
	name = "alien mother"
	icon = 'icons/mob/96x96.dmi'
	icon_state = "empress_s"
	icon_living = "empress_s"
	icon_dead = "empress_dead"
	icon_rest = "empress_rest"
	maxHealth = 600
	health = 600
	meat_amount = 10
	melee_damage_lower = 15
	melee_damage_upper = 25
	speed = 2

	pixel_x = -32
	old_x = -32

/mob/living/simple_animal/hostile/alien/death()
	..()
	visible_message("[src] lets out a waning guttural screech, green blood bubbling from its maw...")
	playsound(src, 'sound/voice/hiss6.ogg', 100, 1)

// Xenoarch aliens.
/mob/living/simple_animal/hostile/samak
	name = "samak"
	desc = "A fast, armoured predator accustomed to hiding and ambushing in cold terrain."
	faction = "samak"
	icon_state = "samak"
	icon_living = "samak"
	icon_dead = "samak_dead"
	icon = 'icons/jungle.dmi'

	faction = "samak"

	maxHealth = 125
	health = 125
	speed = 2
	move_to_delay = 2

	melee_damage_lower = 5
	melee_damage_upper = 15

	attacktext = "mauled"
	cold_damage_per_tick = 0

	speak_chance = 5
	speak = list("Hruuugh!","Hrunnph")
	emote_see = list("paws the ground","shakes its mane","stomps")
	emote_hear = list("snuffles")

/mob/living/simple_animal/hostile/diyaab
	name = "diyaab"
	desc = "A small pack animal. Although omnivorous, it will hunt meat on occasion."
	faction = "diyaab"
	icon_state = "diyaab"
	icon_living = "diyaab"
	icon_dead = "diyaab_dead"
	icon = 'icons/jungle.dmi'

	faction = "diyaab"
	cooperative = 1

	maxHealth = 25
	health = 25
	speed = 1
	move_to_delay = 1

	melee_damage_lower = 1
	melee_damage_upper = 8

	attacktext = "gouged"
	cold_damage_per_tick = 0

	speak_chance = 5
	speak = list("Awrr?","Aowrl!","Worrl")
	emote_see = list("sniffs the air cautiously","looks around")
	emote_hear = list("snuffles")

/mob/living/simple_animal/hostile/shantak
	name = "shantak"
	desc = "A piglike creature with a bright iridiscent mane that sparkles as though lit by an inner light. Don't be fooled by its beauty though."
	faction = "shantak"
	icon_state = "shantak"
	icon_living = "shantak"
	icon_dead = "shantak_dead"
	icon = 'icons/jungle.dmi'

	faction = "shantak"

	maxHealth = 75
	health = 75
	speed = 1
	move_to_delay = 1

	melee_damage_lower = 3
	melee_damage_upper = 12

	attacktext = "gouged"
	cold_damage_per_tick = 0

	speak_chance = 5
	speak = list("Shuhn","Shrunnph?","Shunpf")
	emote_see = list("scratches the ground","shakes out it's mane","tinkles gently")

/mob/living/simple_animal/yithian
	name = "yithian"
	desc = "A friendly creature vaguely resembling an oversized snail without a shell."
	icon_state = "yithian"
	icon_living = "yithian"
	icon_dead = "yithian_dead"
	icon = 'icons/jungle.dmi'

	faction = "yithian"

/mob/living/simple_animal/tindalos
	name = "tindalos"
	desc = "It looks like a large, flightless grasshopper."
	icon_state = "tindalos"
	icon_living = "tindalos"
	icon_dead = "tindalos_dead"
	icon = 'icons/jungle.dmi'

	faction = "tindalos"
