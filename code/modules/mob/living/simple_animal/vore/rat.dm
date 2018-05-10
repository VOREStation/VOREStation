/mob/living/simple_animal/hostile/rat
	name = "giant rat"
	desc = "In what passes for a hierarchy among verminous rodents, this one is king."
	tt_desc = "Mus muscular"
	icon = 'icons/mob/vore64x32.dmi'
	icon_state = "rous"
	icon_living = "rous"
	icon_dead = "rous-dead"
	icon_rest = "rous_rest"
	faction = "mouse"

	maxHealth = 150
	health = 150

	investigates = TRUE
	melee_damage_lower = 5
	melee_damage_upper = 15
	grab_resist = 100

	speak_chance = 4
	speak = list("Squeek!","SQUEEK!","Squeek?")
	speak_emote = list("squeeks","squeeks","squiks")
	emote_hear = list("squeeks","squeaks","squiks")
	emote_see = list("runs in a circle", "shakes", "scritches at something")
	say_maybe_target = list("Squeek?")
	say_got_target = list("SQUEEK!")
	response_help = "pets the"
	response_disarm = "bops the"
	response_harm = "hits the"
	attacktext = list("ravaged")
	friendly = list("nuzzles", "licks", "noses softly at", "noseboops", "headbumps against", "leans on", "nibbles affectionately on")

	old_x = -16
	old_y = 0
	default_pixel_x = -16
	pixel_x = -16
	pixel_y = 0

	vore_active = TRUE
	vore_capacity = 1
	vore_pounce_chance = 45
	vore_icons = SA_ICON_LIVING | SA_ICON_REST

/mob/living/simple_animal/hostile/rat/death()
	playsound(src, 'sound/effects/mouse_squeak_loud.ogg', 50, 1)
	..()
