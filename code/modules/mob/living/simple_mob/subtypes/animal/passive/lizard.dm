/mob/living/simple_mob/animal/passive/lizard
	name = "lizard"
	desc = "A cute, tiny lizard."
	tt_desc = "E Anolis cuvieri"

	icon_state = "lizard_green"
	icon_living = "lizard_green"
	icon_dead = "lizard_green_dead"

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

	var/body_color			// Green, red, orange, yellow or cyan. Keep blank for random (including rare redblue)

/mob/living/simple_mob/animal/passive/lizard/Initialize()
	.=..()

	if(!body_color)
		if(rand(1,1000) == 1)
			body_color = "redblue"
		else
			body_color = pick(list("green","red","orange","yellow","cyan"))
	icon_state = "lizard_[body_color]"
	item_state = "lizard_[body_color]"
	icon_living = "lizard_[body_color]"
	icon_dead = "lizard_[body_color]_dead"
	if(body_color == "redblue")
		desc = "A cute, tiny, red lizard with distinctive blueish markings on its tiny limbs. Seems rare!"
	else
		desc = "A cute, tiny, [body_color] lizard."

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
