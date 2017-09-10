/mob/living/simple_animal/hostile/scarybat
	name = "space bats"
	desc = "A swarm of cute little blood sucking bats that looks pretty upset."
	icon = 'icons/mob/bats.dmi'
	icon_state = "bat"
	icon_living = "bat"
	icon_dead = "bat_dead"
	icon_gib = "bat_dead"

	faction = "scarybat"
	intelligence_level = SA_ANIMAL

	maxHealth = 20
	health = 20
	turns_per_move = 3
	speed = 4

	response_help = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"

	harm_intent_damage = 10
	melee_damage_lower = 3
	melee_damage_upper = 3
	environment_smash = 1

	attacktext = "bites"
	attack_sound = 'sound/weapons/bite.ogg'

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	has_langs = list("Mouse")

	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat

	var/mob/living/owner

/mob/living/simple_animal/hostile/scarybat/New(loc, mob/living/L as mob)
	..()
	if(istype(L))
		owner = L

/mob/living/simple_animal/hostile/scarybat/Process_Spacemove(var/check_drift = 0)
	return ..()

/mob/living/simple_animal/hostile/scarybat/set_target()
	. = ..()
	if(.)
		emote("flutters towards [.]")

/mob/living/simple_animal/hostile/scarybat/ListTargets()
	. = ..()
	if(owner)
		return . - owner

/mob/living/simple_animal/hostile/scarybat/PunchTarget()
	. =..()
	var/mob/living/L = .
	if(istype(L))
		if(prob(15))
			L.Stun(1)
			L.visible_message("<span class='danger'>\the [src] scares \the [L]!</span>")

/mob/living/simple_animal/hostile/scarybat/cult
	faction = "cult"
	supernatural = 1

/mob/living/simple_animal/hostile/scarybat/cult/cultify()
	return

/mob/living/simple_animal/hostile/scarybat/cult/Life()
	..()
	check_horde()
