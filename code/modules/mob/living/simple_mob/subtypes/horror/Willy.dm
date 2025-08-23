/mob/living/simple_mob/horror/Willy
	name = "???"
	desc = "It looks like a giant mascot costume made of flesh and fabric. The two bulging eyes aren't comforting to look at either. At least it smells like a burger and fries."

	icon_state = "Willy"
	icon_living = "Willy"
	icon_dead = "w_head"
	icon_rest = "Willy"
	faction = "horror"
	icon = 'icons/mob/horror_show/GHPS.dmi'
	icon_gib = "generic_gib"

	attack_sound = 'sound/h_sounds/negative.ogg'

	maxHealth = 175
	health = 175

	melee_damage_lower = 25
	melee_damage_upper = 35
	grab_resist = 100

	response_help = "pets the"
	response_disarm = "bops the"
	response_harm = "hits the"
	attacktext = list("smashed")
	friendly = list("nuzzles", "boops", "bumps against", "leans on")


	say_list_type = /datum/say_list/Willy
	ai_holder_type = /datum/ai_holder/simple_mob/horror

/mob/living/simple_mob/horror/Willy/death()
	playsound(src, 'sound/h_sounds/sampler.ogg', 50, 1)
	..()

/mob/living/simple_mob/horror/Willy/bullet_act()
	playsound(src, 'sound/h_sounds/holla.ogg', 50, 1)
	..()

/mob/living/simple_mob/horror/Willy/attack_hand()
	playsound(src, 'sound/h_sounds/holla.ogg', 50, 1)
	..()

/mob/living/simple_mob/horror/Willy/hitby()
	playsound(src, 'sound/h_sounds/holla.ogg', 50, 1)
	..()

/mob/living/simple_mob/horror/Willy/attackby()
	playsound(src, 'sound/h_sounds/holla.ogg', 50, 1)
	..()

/datum/say_list/Willy
	speak = list("Uuurrgh?","Aauuugghh...", "AAARRRGH!")
	emote_hear = list("shrieks horrifically", "groans in pain", "cries", "whines")
	emote_see = list("headbobs", "shakes violently in place", "stares aggressively")
	say_maybe_target = list("Uuurrgghhh?")
	say_got_target = list("AAAHHHHH!")
