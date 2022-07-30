/datum/category_item/catalogue/fauna/rabbit		//TODO: VIRGO_LORE_WRITING_WIP
	name = "Wildlife - Rabbit"
	desc = ""
	value = CATALOGUER_REWARD_TRIVIAL

/mob/living/simple_mob/vore/rabbit
	name = "rabbit"
	desc = "It's a fluffy, smol bunny! Adorable!"
	tt_desc = "Oryctolagus cuniculus domesticus"

	icon_state = "rabbit_brown"
	icon_living = "rabbit_brown"
	icon_dead = "rabbit_brown_dead"
	icon_rest = "rabbit_brown_rest"
	icon = 'icons/mob/vore.dmi'

	faction = "rabbit"
	maxHealth = 30
	health = 30

	response_help = "pats"
	response_disarm = "gently pushes aside"
	response_harm = "hits"

	harm_intent_damage = 5
	melee_damage_lower = 1
	melee_damage_upper = 3
	attacktext = list("nipped")

	movement_cooldown = 3

	say_list_type = /datum/say_list/rabbit
	ai_holder_type = /datum/ai_holder/simple_mob/passive

	meat_amount = 3
	meat_type = /obj/item/reagent_containers/food/snacks/meat

	// Vore vars
	vore_active = 1
	vore_bump_emote	= "playfully lunges at"
	vore_pounce_chance = 40
	vore_pounce_maxhealth = 100 // They won't pounce by default, as they're passive. This is just so the nom check succeeds. :u
	vore_default_mode = DM_HOLD
	vore_icons = SA_ICON_LIVING

	var/body_color 				//brown, black and white, leave blank for random

	var/grumpiness = 0 			// This determines how grumpy we are. Pet us to increase it, leave us alone to decrease.
	var/last_pet				// This tracks the last time someone patted us.
	var/grump_decay = 5 SECONDS // This is how quickly our grumpiness decays.

/mob/living/simple_mob/vore/rabbit/New()
	. = ..()

	if(!body_color)
		body_color = pick( list("brown","black","white") )
	icon_state = "rabbit_[body_color]"
	item_state = "rabbit_[body_color]"
	icon_living = "rabbit_[body_color]"
	icon_dead = "rabbit_[body_color]_dead"
	icon_rest = "rabbit_[body_color]_rest"

/mob/living/simple_mob/vore/rabbit/Life()
	. = ..()

	if(grumpiness > 0 && last_pet > (world.time + grump_decay))
		grumpiness = max(0, grumpiness-rand(5,10)) // Subtract grumpiness randomly in a range of 5-10 if we've not been PAT in the last 5 seconds.

/mob/living/simple_mob/vore/rabbit/examine(mob/user)
	. = ..()

	switch(grumpiness)
		if(-INFINITY to 25)
			. += "They appear calm."
		if(26 to 50)
			. += "They seem slightly annoyed."
		if(51 to 75)
			. += "They seem very annoyed, perhaps you should stop petting them."
		if(75 to INFINITY)
			. += "They are very angry. Petting them will likely result in unpleasant things."

/mob/living/simple_mob/vore/rabbit/attack_hand(mob/user)
	. = ..()

	if(user.a_intent == I_HELP) // only patpet on help. :p
		grumpiness = CLAMP(grumpiness + rand(5, 10), 0, 120)
		last_pet = world.time

	if(grumpiness > 90) // Annoyed bunbun :U
		var/pounce_chance = CanPounceTarget(user)
		if(pounce_chance)
			PounceTarget(user, pounce_chance)

/datum/say_list/rabbit
	speak = list("chrrrs.")
	emote_hear = list("screms.")
	emote_see = list("earflicks","wiggles its tail", "wiggles its nose")

/mob/living/simple_mob/vore/rabbit/black
	icon_state = "rabbit_black"
	icon_living = "rabbit_black"
	icon_dead = "rabbit_black_dead"
	icon_rest = "rabbit_black_rest"
	body_color = "black"

/mob/living/simple_mob/vore/rabbit/white
	icon_state = "rabbit_white"
	icon_living = "rabbit_white"
	icon_dead = "rabbit_white_dead"
	icon_rest = "rabbit_white_rest"
	body_color = "white"

/mob/living/simple_mob/vore/rabbit/brown
	icon_state = "rabbit_brown"
	icon_living = "rabbit_brown"
	icon_dead = "rabbit_brown_dead"
	icon_rest = "rabbit_brown_rest"
	body_color = "brown"

/mob/living/simple_mob/vore/rabbit/white/lennie
	name = "Lennie"
	desc = "A large but somewhat dumb-looking rabbit. Has a little collar that says 'Lennie'!"

/mob/living/simple_mob/vore/rabbit/brown/george
	name = "George"
	desc = "A small and quick bunny with a restless expression in its eyes. Has a little collar that says 'George'!"

/mob/living/simple_mob/vore/rabbit/killer
	tt_desc = "Oryctolagus cuniculus homicidam"

	icon_state = "rabbit_killer"
	icon_living = "rabbit_killer"
	icon_dead = "rabbit_killer_dead"
	icon_rest = "rabbit_killer_rest"

	maxHealth = 2000
	health = 2000
	harm_intent_damage = 5
	melee_damage_lower = 1
	melee_damage_upper = 3
	attacktext = list("nipped")

	movement_cooldown = 0.5 // very fast bunbun.

	vore_bump_chance = 10
	vore_pounce_chance = 100
	vore_pounce_falloff = 0.2

	body_color = "killer" // Set this so New() doesn't try to randomize us.

	say_list_type = /datum/say_list/rabbit
	ai_holder_type = /datum/ai_holder/simple_mob/melee/evasive

/mob/living/simple_mob/vore/rabbit/killer/ex_act()
	gib()
