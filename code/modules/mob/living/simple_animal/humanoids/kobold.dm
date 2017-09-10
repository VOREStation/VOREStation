//kobold
/mob/living/simple_animal/kobold
	name = "kobold"
	desc = "A small, rat-like creature."
	icon = 'icons/mob/mob.dmi'
	icon_state = "kobold_idle"
	icon_living = "kobold_idle"
	icon_dead = "kobold_dead"
	intelligence_level = SA_HUMANOID

	run_at_them = 0
	cooperative = 1

	turns_per_move = 5
	see_in_dark = 6

	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"

	min_oxy = 16 //Require atleast 16kPA oxygen
	minbodytemp = 223		//Below -50 Degrees Celcius
	maxbodytemp = 323	//Above 50 Degrees Celcius

	speak_chance = 5
	speak = list("You no take candle!","Ooh, pretty shiny.","Me take?","Where gold here...","Me likey.")
	speak_emote = list("mutters","hisses","grumbles")
	emote_hear = list("mutters under it's breath.","grumbles.", "yips!")
	emote_see = list("looks around suspiciously.", "scratches it's arm.","putters around a bit.")

	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat/monkey

/mob/living/simple_animal/kobold/Life()
	. = ..()
	if(!.) return

	if(prob(5))
		flick("kobold_act",src)

/mob/living/simple_animal/kobold/Move(var/dir)
	..()
	if(!stat)
		flick("kobold_walk",src)
