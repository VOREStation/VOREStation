/mob/living/simple_mob/vore/fennix
	name = "Fennix"
	desc = "A feral fennix, Warm to the touch"
	tt_desc = "Incaendium Faeles Vulpes"

	icon_state = "fennix"
	icon_living = "fennix"
	icon_dead = "fennix_dead"
	icon = 'icons/mob/vore.dmi'

	faction = "fennec" // Will protec other fenfens
	maxHealth = 60
	health = 60

	response_help = "pats the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"

	harm_intent_damage = 20
	melee_damage_lower = 1
	melee_damage_upper = 3
	attacktext = list("Bites")

	say_list_type = /datum/say_list/fennix
	ai_holder_type = /datum/ai_holder/simple_mob/retaliate/cooperative

/datum/say_list/fennix
	speak = list("SQUEL!","SQEL?","Skree.")
	emote_hear = list("Screeeeecheeeeessss!","Chirrup.")
	emote_see = list("earflicks","pats at the ground")
