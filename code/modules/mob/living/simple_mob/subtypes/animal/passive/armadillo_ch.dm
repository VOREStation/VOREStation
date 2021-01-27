//Straight import from Mexico and a direct hit to your heart
/mob/living/simple_mob/animal/passive/armadillo
	name = "Armadillo"
	desc = "It's a small armored mammal. Seems to enjoy rolling around and sleep as a ball."
	tt_desc = "Dasypus novemcinctus"
	faction = "mexico" //They are from Mexico.

	icon = 'icons/mob/animal_ch.dmi'
	icon_state = "armadillo"
	item_state = "armadillo_rest"
	icon_living = "armadillo"
	icon_rest = "armadillo_rest"
	icon_dead = "armadillo_dead"

	health = 30
	maxHealth = 30

	mob_size = MOB_SMALL
	pass_flags = PASSTABLE
	can_pull_size = ITEMSIZE_TINY
	can_pull_mobs = MOB_PULL_NONE
	layer = MOB_LAYER
	density = 0
	movement_cooldown = 0.75 //roughly a bit faster than a person

	response_help  = "pets"
	response_disarm = "rolls aside"
	response_harm   = "stomps"

	melee_damage_lower = 2
	melee_damage_upper = 1
	attacktext = list("nips", "bumps", "scratches")

	vore_taste = "Sand"

	min_oxy = 16 //Require atleast 16kPA oxygen
	minbodytemp = 223		//Below -50 Degrees Celcius
	maxbodytemp = 523	//Above 80 Degrees Celcius
	heat_damage_per_tick = 3
	cold_damage_per_tick = 3

	meat_amount = 2
	ai_holder_type = /datum/ai_holder/simple_mob/armadillo

	speak_emote = list("rumbles", "chirr?", "churr")

	say_list_type = /datum/say_list/armadillo

/datum/say_list/armadillo

	speak = list("Churr","Rumble!","Chirr?")
	emote_hear = list("churrs","rubmles","chirrs")
	emote_see = list("rolls in place", "shuffles", "scritches at something")

