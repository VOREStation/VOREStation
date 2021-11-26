/mob/living/simple_mob/animal/space/shafra
	name = "Shafra"
	desc = "A Bogani Hunting Dog"

	icon = 'icons/mob/Shafra.dmi'
	icon_state = "shafra"
	icon_living = "shafra"
	icon_dead = "shafra_dead"

	response_help  = "pets"
	response_disarm = "shoves"
	response_harm   = "kicks"

	movement_cooldown = 5
	maxHealth = 100
	health = 100

	harm_intent_damage = 10
	melee_damage_lower = 5
	melee_damage_upper = 15
	melee_miss_chance = 10

	attacktext = list("mauls and claws with all its might!")
	friendly = list("slobberlicks", "nuzzles it's head on")


	say_list_type = /datum/say_list/shafra
	ai_holder_type = /datum/ai_holder/simple_mob/retaliate

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

/datum/say_list/shafra
	speak = list("Hark!","Rrreh!","Huuuugh!","Aruuu!","Arrugh?")
	emote_hear = list("snarls","slathers","grumbles")
	emote_see = list("shakes it's head about searching","growls and snarls","scans the room","stretches it's talons","sniffs the air for scents")

// This thing doesn't have much health, so this should help somewhat
/mob/living/simple_mob/animal/space/shafra/handle_special()
	if((get_AI_stance() in list(STANCE_APPROACH, STANCE_FIGHT)) && !is_AI_busy() && isturf(loc))
		if(health <= (maxHealth * 0.5)) // At half health, and fighting someone currently.
			berserk()

// Ditto same as above, but now for folks to use too for a little bit of help against other creatures.
/mob/living/simple_mob/animal/space/shafra/verb/berserk()
	set name = "Berserk"
	set desc = "Enrage and become vastly stronger for a period of time, however you will be weaker afterwards."
	set category = "Abilities"

	add_modifier(/datum/modifier/berserk, 30 SECONDS)