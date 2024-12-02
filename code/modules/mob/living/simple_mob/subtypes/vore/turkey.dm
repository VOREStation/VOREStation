/mob/living/simple_mob/vore/turkey
	name = "turkey"
	desc = "A large turkey, all ready for stuffing."
	tt_desc = "Meleagris gallopavo"

	icon_state = "turkey"
	icon_living = "turkey"
	icon_dead = "turkeydead"
	icon_rest = "turkeyrest"
	icon = 'icons/mob/vore.dmi'

	faction = FACTION_TURKEY
	maxHealth = 25
	health = 25

	meat_amount = 1
	meat_type = /obj/item/reagent_containers/food/snacks/rawturkey
	name_the_meat = FALSE

	response_help = "pats"
	response_disarm = "gently pushes aside"
	response_harm = "hits"

	harm_intent_damage = 3
	melee_damage_lower = 3
	melee_damage_upper = 1
	attacktext = list("pecked")

	say_list_type = /datum/say_list/turkey
	ai_holder_type = /datum/ai_holder/simple_mob/passive

	allow_mind_transfer = TRUE

	vore_active = 1
	vore_bump_chance = 10
	vore_bump_emote	= "greedily leaps at"
	vore_default_mode = DM_HOLD
	vore_icons = SA_ICON_LIVING

/datum/say_list/turkey
	speak = list("GOBBLEGOBBLE!","Gobble?","Gobblegobble...")
	emote_hear = list("gobbles!")
	emote_see = list("flaps its wings","pecks something on the floor","puffs up its feathers")
