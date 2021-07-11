/mob/living/simple_mob/vore/weretiger
	name = "weretiger"
	desc = "A big scary, albino were-tiger! At least they seem decently mannered..."
	tt_desc = "Tigris Thropus Album"

	icon_state = "bigcat"
	icon_living = "bigcat"
	icon_dead = "bigcat_dead"
	icon_rest = null
	icon = 'icons/mob/bigcat.dmi'

	faction = "panther"
	maxHealth = 150
	health = 150
	movement_cooldown = 2

	response_help = "pats"
	response_disarm = "gently pushes aside"
	response_harm = "hits"

	harm_intent_damage = 15
	melee_damage_lower = 10
	melee_damage_upper = 20
	attacktext = list("mauled")

	say_list_type = /datum/say_list/weretiger
	ai_holder_type = /datum/ai_holder/simple_mob/retaliate

	pixel_x = -16
	default_pixel_x = -16

	has_hands = 1

// Nomnomn
/mob/living/simple_mob/vore/weretiger
	vore_active = 1
	vore_bump_chance = 10
	vore_bump_emote	= "sneaks up on"
	vore_pounce_chance = 50
	vore_default_mode = DM_HOLD
	vore_icons = SA_ICON_LIVING

/datum/say_list/weretiger
	speak = list("Gruff.","ROAR!","Growl.")
	emote_hear = list("growls!","grunts.")
	emote_see = list("pads around noisily.","scratches the floor thoroughly.")
