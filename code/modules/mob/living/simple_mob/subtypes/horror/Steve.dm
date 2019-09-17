/mob/living/simple_mob/horror/Steve
	name = "???"
	desc = "A formless blob of flesh with one, giant, everblinking eye. It has a large machine gun and a watercooler stuck stright into its skin."

	icon_state = "Steve"
	icon_living = "Steve"
	icon_dead = "sg_head"
	icon_rest = "Steve"
	faction = "horror"
	icon = 'icons/mob/horror_show/GHPS.dmi'
	icon_gib = "generic_gib"

	attack_sound = 'sound/h_sounds/mumble.ogg'

	maxHealth = 175
	health = 175

	melee_damage_lower = 25
	melee_damage_upper = 35
	grab_resist = 100

	projectiletype = /obj/item/projectile/bullet/pistol/medium
	projectilesound = 'sound/weapons/Gunshot_light.ogg'

	needs_reload = TRUE
	base_attack_cooldown = 5 // Two attacks a second or so.
	reload_max = 20

	response_help = "pets the"
	response_disarm = "bops the"
	response_harm = "hits the"
	attacktext = list("amashes")
	friendly = list("nuzzles", "boops", "bumps against", "leans on")


	say_list_type = /datum/say_list/Steve
	ai_holder_type = /datum/ai_holder/simple_mob/horror

/mob/living/simple_mob/horror/Steve/death()
	playsound(src, 'sound/h_sounds/holla.ogg', 50, 1)
	..()

/mob/living/simple_mob/horror/Steve/bullet_act()
    playsound(src, 'sound/h_sounds/holla.ogg', 50, 1)
    ..()

/mob/living/simple_mob/horror/Steve/attack_hand()
    playsound(src, 'sound/h_sounds/holla.ogg', 50, 1)
    ..()

/mob/living/simple_mob/horror/Steve/hitby()
    playsound(src, 'sound/h_sounds/holla.ogg', 50, 1)
    ..()

/mob/living/simple_mob/horror/Steve/attackby()
    playsound(src, 'sound/h_sounds/holla.ogg', 50, 1)
    ..()

/datum/say_list/Steve
	speak = list("Uuurrgh?","Aauuugghh...", "AAARRRGH!")
	emote_hear = list("shrieks horrifically", "groans in pain", "cries", "whines")
	emote_see = list("blinks aggressively at", "shakes violently in place", "stares aggressively")
	say_maybe_target = list("Uuurrgghhh?")
	say_got_target = list("AAAHHHHH!")