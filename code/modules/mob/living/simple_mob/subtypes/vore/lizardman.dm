/mob/living/simple_mob/vore/aggressive/lizardman
	name = "lizardman"
	desc = "That is one buff, angry lizard."
	tt_desc = "E Anolis cuvieri muscular"

	icon = 'icons/mob/vore32x64.dmi'
	icon_state = "lizardman"
	icon_living = "lizardman"
	icon_dead = "lizardman-dead"
	faction = "lizard"


	maxHealth = 50
	health = 50

	melee_damage_lower = 5
	melee_damage_upper = 15
	grab_resist = 100
	see_in_dark = 8

	response_help = "pets"
	response_disarm = "bops"
	response_harm = "hits"
	attacktext = list("ravaged")
	friendly = list("nuzzles", "licks", "noses softly at", "noseboops", "headbumps against", "leans on", "nibbles affectionately on")


	vore_active = TRUE
	vore_capacity = 1
	vore_pounce_chance = 20
	vore_icons = SA_ICON_LIVING

	say_list_type = /datum/say_list/lizardman
	ai_holder_type = /datum/ai_holder/simple_mob/melee

	can_be_drop_prey = FALSE
	allow_mind_transfer = TRUE


/datum/say_list/lizardman
	speak = list("Gwar!","Rawr!","Hiss.")
	emote_hear = list("hisses", "yawns", "growls")
	emote_see = list("licks their maw", "stretches", "yawns", "noodles")
	say_maybe_target = list("Rawr?")
	say_got_target = list("GWAR!!")
