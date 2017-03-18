/mob/living/simple_animal/fluffy
	name = "Fluffy"
	desc = "It's a pink Diyaab! It seems to be very tame and quiet."
	icon = 'icons/mob/animal_vr.dmi'
	icon_state = "fluffy"
	icon_living = "fluffy"
	icon_dead = "fluffy_dead"
	icon_rest = "fluffy_sleep"

	turns_per_move = 10
	see_in_dark = 5
	mob_size = MOB_TINY

	response_help  = "scritches"
	response_disarm = "bops"
	response_harm   = "kicks"

	min_oxy = 16 			//Require atleast 16kPA oxygen
	minbodytemp = 223		//Below -50 Degrees Celcius
	maxbodytemp = 323		//Above 50 Degrees Celcius

	speak_chance = 1
	speak = list("Squee","Arf arf","Awoo","Squeak")
	speak_emote = list("squeaks", "barks")
	emote_hear = list("howls","squeals")
	emote_see = list("puffs its fur out", "shakes its fur", "stares directly at you")

	meat_amount = 1
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat

/mob/living/simple_animal/fluffy/Life()
	. = ..()
	if(!. || ai_inactive) return

	if(prob(0.5))
		lay_down()

	if(resting && prob(5))
		audible_emote("snuffles.")
