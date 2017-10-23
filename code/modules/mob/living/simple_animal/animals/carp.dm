/mob/living/simple_animal/hostile/carp
	name = "space carp"
	desc = "A ferocious, fang-bearing creature that resembles a fish."
	icon_state = "carp"
	icon_living = "carp"
	icon_dead = "carp_dead"
	icon_gib = "carp_gib"

	faction = "carp"
	intelligence_level = SA_ANIMAL
	maxHealth = 25
	health = 25
	speed = 4
	turns_per_move = 5

	response_help = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"

	harm_intent_damage = 8
	melee_damage_lower = 15
	melee_damage_upper = 15
	attacktext = "bitten"
	attack_sound = 'sound/weapons/bite.ogg'

	//Space carp aren't affected by atmos.
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	meat_type = /obj/item/weapon/reagent_containers/food/snacks/carpmeat

/mob/living/simple_animal/hostile/carp/large
	name = "elder carp"
	desc = "An older, more matured carp. Few survive to this age due to their aggressiveness."
	icon = 'icons/mob/64x32.dmi'
	icon_state = "shark"
	icon_living = "shark"
	icon_dead = "shark_dead"
	turns_per_move = 2
	move_to_delay = 2
	mob_size = MOB_LARGE

	pixel_x = -16
	old_x = -16

	health = 50
	maxHealth = 50


/mob/living/simple_animal/hostile/carp/large/huge
	name = "great white carp"
	desc = "A very rare breed of carp- and a very aggressive one."
	icon = 'icons/mob/64x64.dmi'
	icon_dead = "megacarp_dead"
	icon_living = "megacarp"
	icon_state = "megacarp"
	maxHealth = 230
	health = 230
	attack_same = 1
	speed = 1

	meat_amount = 10

	melee_damage_lower = 15
	melee_damage_upper = 25
	old_y = -16
	pixel_y = -16

/mob/living/simple_animal/hostile/carp/Process_Spacemove(var/check_drift = 0)
	return 1	//No drifting in space for space carp!	//original comments do not steal

/mob/living/simple_animal/hostile/carp/set_target()
	. = ..()
	if(.)
		custom_emote(1,"nashes at [.]")

/mob/living/simple_animal/hostile/carp/PunchTarget()
	. =..()
	var/mob/living/L = .
	if(istype(L))
		if(prob(15))
			L.Weaken(3)
			L.visible_message("<span class='danger'>\the [src] knocks down \the [L]!</span>")

