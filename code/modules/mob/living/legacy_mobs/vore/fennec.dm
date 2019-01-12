/mob/living/simple_animal/fennec
	name = "fennec"
	desc = "It's a dusty big-eared sandfox! Adorable!"
	tt_desc = "Vulpes zerda"
	icon = 'icons/mob/vore.dmi'
	icon_state = "fennec"
	icon_living = "fennec"
	icon_dead = "fennec_dead"
	icon_rest = "fennec_rest"

	faction = "fennec"
	maxHealth = 30
	health = 30

	response_help = "pats the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"

	harm_intent_damage = 5
	melee_damage_lower = 5
	melee_damage_upper = 2
	attacktext = list("bapped")

	speak_chance = 1
	speak = list("SKREEEE!",
				"Chrp?",
				"Ararrrararr.")
	emote_hear = list("screEEEEeeches!","chirps.")
	emote_see = list("earflicks","sniffs at the ground")

// Activate Noms!
/mob/living/simple_animal/fennec
	vore_active = 1
	vore_bump_chance = 10
	vore_bump_emote	= "playfully lunges at"
	vore_pounce_chance = 40
	vore_default_mode = DM_HOLD
	vore_icons = SA_ICON_LIVING
