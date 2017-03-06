/mob/living/simple_animal/fluffy
	name = "Fluffy"
	desc = "It's a pink Diyaab! It seems to be very tame and quiet."
	icon = 'icons/mob/animal_vr.dmi'
	icon_state = "fluffy"
	icon_living = "fluffy"
	icon_dead = "fluffy_dead"
	icon_rest = "fluffy_sleep"
	speak = list("Squee","Arf arf","Awoo","Squeak")
	speak_emote = list("squeaks", "barks")
	emote_hear = list("howls","squeals")
	emote_see = list("puffs its fur out", "shakes its fur", "stares directly at you")
	speak_chance = 1
	turns_per_move = 10
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat
	meat_amount = 1
	response_help  = "scritches"
	response_disarm = "bops"
	response_harm   = "kicks"
	see_in_dark = 5
	mob_size = MOB_TINY
	min_oxy = 16 			//Require atleast 16kPA oxygen
	minbodytemp = 223		//Below -50 Degrees Celcius
	maxbodytemp = 323		//Above 50 Degrees Celcius

/mob/living/simple_animal/fluffy/Life()
	..()

	if(!ckey && stat == CONSCIOUS && prob(0.5))
		stat = UNCONSCIOUS
		icon_state = "fluffy_sleep"
		wander = 0
		speak_chance = 0
		//snuffles
	else if(stat == UNCONSCIOUS)
		if(ckey || prob(1))
			stat = CONSCIOUS
			icon_state = "fluffy"
			wander = 1
		else if(prob(5))
			audible_emote("snuffles.")

/mob/living/simple_animal/fluffy/lay_down()
	..()
	if(icon_rest)
		icon_state = resting ? icon_rest : icon_living
