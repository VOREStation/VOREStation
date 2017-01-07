/mob/living/simple_animal/fluffy
	name = "\improper Fluffy"
	desc = "It's a pink Diyaab! It seems to be very tame and quiet."
	icon = 'icons/jungle_vr.dmi'
	icon_state = "fluffy"
	icon_living = "fluffy"
	icon_dead = "fluffy_dead"
	speak = list("Squee","Arf arf","Awoo","Squeak")
	speak_emote = list("squeaks", "barks")
	emote_hear = list("howls","squeals")
	emote_see = list("puffs its fur out", "shakes its fur", "stares directly at you")
	speak_chance = 1
	move_to_delay = 1
	maxHealth = 100
	health = 50
	speed = 1
	see_in_dark = 6
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat/fox
	response_help = "scritches"
	response_disarm = "gently pushes aside"
	response_harm = "kicks"
	var/turns_since_scan = 0
	var/mob/living/simple_animal/mouse/movement_target
	var/mob/flee_target
	min_oxy = 16 			//Require atleast 16kPA oxygen
	minbodytemp = 223		//Below -50 Degrees Celcius
	maxbodytemp = 323		//Above 50 Degrees Celcius
	mob_size = MOB_TINY

	can_pull_size = ITEMSIZE_TINY
	can_pull_mobs = MOB_PULL_NONE

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

/mob/living/simple_animal/fluffy/lay_down() //Simply turns sprite into sleeping and back upon using "Rest".
	..()
	icon_state = resting ? "fluffy_sleep" : "fluffy"