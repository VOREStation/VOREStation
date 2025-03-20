/mob/living/simple_mob/vore/bat
	name = "giant bat"
	desc = "Blimey, that's a big sky fox."
	tt_desc = "Homo paramour"

	icon_state = "bat"
	icon = 'icons/mob/vore.dmi'
	icon_living = "bat"
	icon_rest = "batasleep"
	icon_dead = "bat-dead"

	harm_intent_damage = 5
	melee_damage_lower = 2
	melee_damage_upper = 5

	response_help = "nuzzles"
	response_disarm = "flaps at"
	response_harm = "bites"

	attacktext = list("bites","scratches")

	say_list_type = /datum/say_list/bat
	ai_holder_type = /datum/ai_holder/simple_mob/retaliate/edible

	faction = FACTION_VAMPIRE

	allow_mind_transfer = TRUE

// Activate Noms!
/mob/living/simple_mob/vore/bat
	vore_active = 1
	vore_bump_chance = 50
	vore_pounce_chance = 50
	vore_standing_too = 1
	vore_ignores_undigestable = 0
	vore_default_mode = DM_DRAIN // They just want to drain you!
	vore_digest_chance = 25 // But don't you dare try to escape...
	vore_icons = SA_ICON_LIVING | SA_ICON_REST

/datum/say_list/bat
	speak = list("Chirp!")
	emote_hear = list("chirps","pings","clicks")
	emote_see = list("flaps","grooms itself")

/mob/living/simple_mob/vore/bat/init_vore()
	if(!voremob_loaded)
		return
	if(LAZYLEN(vore_organs))
		return
	. = ..()
	var/obj/belly/B = vore_selected
	B.name = "stomach"
	B.desc = "The giant bat has managed to swallow you alive, which is particularly impressive given that it's still a rather small creature. It's belly bulges out as you're squeezed into the oppressively tight stomach, and it lands to manage the weight, wings curling over your form beneath. The body groans under your strain, burbling and growling as it gets to work on it's feed. However, at least for now, it seems to do you no physical harm. Instead, the damp walls that squelch across your body try to leech out your energy through some less direct means."
	B.mode_flags = DM_FLAG_THICKBELLY
	B.belly_fullscreen = "yet_another_tumby"
	B.digest_brute = 2
	B.digest_burn = 2
	B.digest_oxy = 1
	B.digestchance = 25
	B.absorbchance = 0
	B.escapechance = 15
	B.selective_preference = DM_DRAIN
	B.escape_stun = 5
