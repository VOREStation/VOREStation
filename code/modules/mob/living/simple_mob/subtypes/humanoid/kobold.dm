/mob/living/simple_mob/humanoid/kobold
	name = "kobold"
	desc = "A small, rat-like creature."
	icon = 'icons/mob/mob.dmi'
	icon_state = "kobold_idle"
	icon_living = "kobold_idle"
	icon_dead = "kobold_dead"

	health = 45
	maxHealth = 45

	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"

	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat/monkey

	ai_holder_type = /datum/ai_holder/simple_mob/retaliate/cooperative

	say_list_type = /datum/say_list/kobold

/mob/living/simple_mob/humanoid/kobold/Life()
	. = ..()
	if(!.) return

	if(prob(5))
		flick("kobold_act",src)

/mob/living/simple_mob/humanoid/kobold/Move(var/dir)
	..()
	if(!stat)
		flick("kobold_walk",src)


/datum/say_list/kobold
	speak = list("You no take candle!","Ooh, pretty shiny.","Me take?","Where gold here...","Me likey.")
	emote_see = list("looks around suspiciously.", "scratches it's arm.","putters around a bit.")
	emote_hear = list("mutters.","hisses.", "mutters under it's breath.","grumbles.", "yips!")