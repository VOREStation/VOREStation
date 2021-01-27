/mob/living/simple_mob/animal/passive/raccoon
	name = "raccoon"
	desc = "A raccoon, also known as a trash panda."
	tt_desc = "E purgamentum raccoonus"

	icon_state = "raccoon"
	icon = 'icons/mob/animal_ch.dmi'
	icon_state = "raccoon"
	icon_living = "raccoon"
	icon_dead = "raccoon_dead"

	see_in_dark = 25 // These are nocturnal after all, best to let them see in the dark to scour for all sorts of trash.

	harm_intent_damage = 5
	melee_damage_lower = 2
	melee_damage_upper = 1

	response_help = "pets"
	response_disarm = "gently pushes aside"
	response_harm = "punts"

	attacktext = list("theives","nibbles")

	vore_active = 1
	vore_capacity = 1
	vore_bump_chance = 15
	vore_pounce_chance = 35


	say_list_type = /datum/say_list/raccon
	ai_holder_type = /datum/ai_holder/simple_mob/animal/passive/raccoon


/datum/say_list/raccoon
	speak = list("HSSSS!","REEER!")
	emote_hear = list("hisses","whines","chitters")
	emote_see = list("shakes their head sniffing the air", "shuffles around looking for food","pauses to groom itself", "nibbles on some trash")

/datum/ai_holder/simple_mob/animal/passive/raccoon
	base_wander_delay = 8
