/datum/category_item/catalogue/fauna/fennec		//TODO: VIRGO_LORE_WRITING_WIP
	name = "Wildlife - Fennec"
	desc = "A small, dusty, big-eared sandfox, native to Virgo 4. It looks like a Zorren that's on all fours, \
	and it's easy to see the resemblance to the little dunefox-like critters the Zorren are. However, the fennecs \
	lack the sentience the Zorren have, and are therefore naught more than cute little critters, with a hungry \
	attitude, willing to eat damn near anything they come across or can bump into. Bapping them will make them stop."
	value = CATALOGUER_REWARD_TRIVIAL

/mob/living/simple_mob/vore/fennec
	name = "fennec" //why isn't this in the fox file, fennecs are foxes silly.
	desc = "It's a dusty big-eared sandfox! Adorable!"
	tt_desc = "Vulpes zerda"

	icon_state = "fennec"
	icon_living = "fennec"
	icon_dead = "fennec_dead"
	icon_rest = "fennec_rest"
	icon = 'icons/mob/vore.dmi'

	faction = "fennec"
	maxHealth = 30
	health = 30

	response_help = "pats"
	response_disarm = "gently pushes aside"
	response_harm = "hits"

	harm_intent_damage = 5
	melee_damage_lower = 1
	melee_damage_upper = 3
	attacktext = list("bapped")

	say_list_type = /datum/say_list/fennec
	ai_holder_type = /datum/ai_holder/simple_mob/passive

// Activate Noms!
/mob/living/simple_mob/vore/fennec
	vore_active = 1
	vore_bump_chance = 10
	vore_bump_emote	= "playfully lunges at"
	vore_pounce_chance = 40
	vore_default_mode = DM_HOLD
	vore_icons = SA_ICON_LIVING

/datum/say_list/fennec
	speak = list("SKREEEE!","Chrp?","Ararrrararr.")
	emote_hear = list("screEEEEeeches!","chirps.")
	emote_see = list("earflicks","sniffs at the ground")
