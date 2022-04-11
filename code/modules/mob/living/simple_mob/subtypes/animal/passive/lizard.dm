/mob/living/simple_mob/animal/passive/lizard
	name = "lizard"
	desc = "A cute, tiny lizard."
	tt_desc = "E Anolis cuvieri"

	icon_state = "lizard"
	icon_living = "lizard"
	icon_dead = "lizard_dead"

	health = 5
	maxHealth = 5
	mob_size = MOB_MINISCULE

	response_help  = "pets"
	response_disarm = "shoos"
	response_harm   = "stomps on"

	attacktext = list("bitten")
	melee_damage_lower = 1
	melee_damage_upper = 2

	speak_emote = list("hisses")

	say_list_type = /datum/say_list/lizard

	meat_amount = 1

/mob/living/simple_mob/animal/passive/lizard/large
	desc = "A cute, big lizard."
	maxHealth = 20
	health = 20

	melee_damage_lower = 5
	melee_damage_upper = 15

	attack_sharp = TRUE

/mob/living/simple_mob/animal/passive/lizard/large/Initialize()
	. = ..()
	adjust_scale(rand(12, 20) / 10)

/mob/living/simple_mob/animal/passive/lizard/large/defensive
	maxHealth = 30
	health = 30

	ai_holder_type = /datum/ai_holder/simple_mob/retaliate/cooperative
