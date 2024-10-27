/mob/living/simple_mob/animal/sif/fluffy
	name = "Fluffy"
	desc = "It's a pink Diyaab! It seems to be very tame and quiet."
	tt_desc = "S Choeros hirtus"
	catalogue_data = list(/datum/category_item/catalogue/fauna/diyaab)

	icon_state = "fluffy"
	icon_living = "fluffy"
	icon_dead = "fluffy_dead"
	icon_rest = "fluffy_sleep"
	icon = 'icons/mob/animal_vr.dmi'

	maxHealth = 20 //don't want Fluff to die on a missclick
	health = 20

	movement_cooldown = 1.5
	makes_dirt = 0

	see_in_dark = 5
	mob_size = MOB_TINY
	makes_dirt = FALSE	// No more dirt
	mob_bump_flag = 0

	response_help  = "scritches"
	response_disarm = "bops"
	response_harm   = "kicks"

	min_oxy = 16 			//Require atleast 16kPA oxygen
	minbodytemp = 223		//Below -50 Degrees Celcius
	maxbodytemp = 323		//Above 50 Degrees Celcius

	meat_amount = 1
	meat_type = /obj/item/reagent_containers/food/snacks/meat

	say_list_type = /datum/say_list/fluffy_vr
	ai_holder_type = /datum/ai_holder/simple_mob/passive

/datum/say_list/fluffy_vr
	speak = list("Squee","Arf arf","Awoo","Squeak")
	emote_hear = list("howls","squeals","squeaks", "barks")
	emote_see = list("puffs its fur out", "shakes its fur", "stares directly at you")

/mob/living/simple_mob/animal/sif/fluffy/silky
	name = "Silky"
	desc = "It's a blue Diyaab! It seems to be very tame and quiet."

	icon_state = "diyaab"
	icon_living = "diyaab"
	icon_dead = "diyaab_dead"
	icon = 'icons/jungle.dmi'
