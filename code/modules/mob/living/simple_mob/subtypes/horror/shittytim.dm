/mob/living/simple_mob/horror/BigTim
	name = "Shitty Tim"
	desc = "A tall figure wearing ripped clothes. Its eyes are placed on the bulb of skin that's folded over the front of its face. He has a gold clock hanging on a gold chain around his neck, and he has a gold and diamond bracelet on his wrist."

	icon_state = "shitty_tim"
	icon_living = "shitty_tim"
	icon_dead = "tst_head"
	icon_rest = "shitty_tim"
	faction = "horror"
	icon = 'icons/mob/horror_show/tallhorror.dmi'
	vis_height = 64
	icon_gib = "generic_gib"

	attack_sound = 'sound/h_sounds/youknowwhoitis.ogg'

	maxHealth = 250
	health = 250

	melee_damage_lower = 35
	melee_damage_upper = 45
	grab_resist = 100

	response_help = "pets the"
	response_disarm = "bops the"
	response_harm = "hits the"
	attacktext = list("mutilate")
	friendly = list("nuzzles", "boops", "headbumps against", "leans on")


	say_list_type = /datum/say_list/BigTim
	ai_holder_type = /datum/ai_holder/simple_mob/horror

/mob/living/simple_mob/horror/BigTim/death()
	playsound(src, 'sound/h_sounds/shitty_tim.ogg', 50, 1)
	..()

/mob/living/simple_mob/horror/BigTim/bullet_act()
    playsound(src, 'sound/h_sounds/holla.ogg', 50, 1)
    ..()

/mob/living/simple_mob/horror/BigTim/attack_hand()
    playsound(src, 'sound/h_sounds/holla.ogg', 50, 1)
    ..()

/mob/living/simple_mob/horror/BigTim/hitby()
    playsound(src, 'sound/h_sounds/holla.ogg', 50, 1)
    ..()

/mob/living/simple_mob/horror/BigTim/attackby()
    playsound(src, 'sound/h_sounds/holla.ogg', 50, 1)
    ..()

/datum/say_list/BigTim
	speak = list("Wuuuuuhhuuhhhhh?","Urk! Aaaaahaaa!", "Yuhyuhyuhyuh...")
	emote_hear = list("shrieks", "groans in pain", "flaps", "gnashes its teeth")
	emote_see = list("jiggles its teeth", "shakes violently", "stares aggressively")
	say_maybe_target = list("Uuurrgghhh?")
	say_got_target = list("AAAHHHHH!")