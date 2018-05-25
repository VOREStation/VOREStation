/mob/living/simple_animal/hostile/tree
	name = "pine tree"
	desc = "A pissed off tree-like alien. It seems annoyed with the festivities..."
	tt_desc = "X Festivus tyrannus"
	icon = 'icons/obj/flora/pinetrees.dmi'
	icon_state = "pine_1"
	icon_living = "pine_1"
	icon_dead = "pine_1"
	icon_gib = "pine_1"
	intelligence_level = SA_PLANT

	faction = "carp" //Trees can be carp friends?
	maxHealth = 250
	health = 250
	speed = -1

	turns_per_move = 5

	response_help = "brushes"
	response_disarm = "pushes"
	response_harm = "hits"

	harm_intent_damage = 5
	melee_damage_lower = 8
	melee_damage_upper = 12
	attacktext = list("bitten")
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

	meat_type = /obj/item/weapon/reagent_containers/food/snacks/carpmeat

	pixel_x = -16

/mob/living/simple_animal/hostile/tree/FindTarget()
	. = ..()
	if(.)
		audible_emote("growls at [.]")

/mob/living/simple_animal/hostile/tree/PunchTarget()
	. =..()
	var/mob/living/L = .
	if(istype(L))
		if(prob(15))
			L.Weaken(3)
			L.visible_message("<span class='danger'>\the [src] knocks down \the [L]!</span>")

/mob/living/simple_animal/hostile/tree/death()
	..(null,"is hacked into pieces!")
	playsound(loc, 'sound/effects/woodcutting.ogg', 100, 1)
	new /obj/item/stack/material/wood(loc)
	qdel(src)