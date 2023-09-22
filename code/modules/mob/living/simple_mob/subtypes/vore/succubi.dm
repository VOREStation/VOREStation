/mob/living/simple_mob/vore/succubus
	name = "succubus"
	desc = "She's giving you the 'come hither' look."
	tt_desc = "Homo paramour"

	icon_state = "succubus"
	icon = 'icons/mob/vore.dmi'

	harm_intent_damage = 5
	melee_damage_lower = 2
	melee_damage_upper = 5

	response_help = "strokes"
	response_disarm = "pushes"
	response_harm = "bites"

	attacktext = list("swatted","bapped")

	say_list_type = /datum/say_list/succubus
	ai_holder_type = /datum/ai_holder/simple_mob/retaliate

	var/random_skin = 1
	var/list/skins = list(
		"succubus",
		"succubusbob",
		"succubusginger",
		"succubusclothed",
		"succubusbobclothed",
		"succubusgingerclothed"
	)

	faction = "succubus"

/mob/living/simple_mob/vore/succubus/New()
	..()
	if(random_skin)
		icon_living = pick(skins)
		icon_rest = "[icon_living]asleep"
		icon_dead = "[icon_living]-dead"
		update_icon()

// Activate Noms!
/mob/living/simple_mob/vore/succubus
	vore_active = 1
	vore_bump_chance = 100
	vore_pounce_chance = 50
	vore_standing_too = 1
	vore_ignores_undigestable = 0
	vore_default_mode = DM_DRAIN // They just want to drain you!
	vore_digest_chance = 25 // But don't you dare try to escape...
	vore_icons = SA_ICON_LIVING | SA_ICON_REST

/datum/say_list/succubus
	speak = list("Come here cutie!","Let me get a good look at you!","Want to spend a little quality time together?","I don't bite. Much.","Like what you see?","Feel free to sample the goods.")
	emote_hear = list("makes a kissing sound","giggles","lets out a needy whine")
	emote_see = list("gestures for you to come over","winks","smiles","stretches")

/mob/living/simple_mob/vore/succubus/init_vore()
	..()
	var/obj/belly/B = vore_selected
	B.name = "stomach"
	B.desc = "You find yourself tightly compressed into the stomach of the succubus, with immense pressure squeezing down on you from every direction. The wrinkled walls of the gut knead over you, like a swelteringly hot, wet massage. You can feel movement from the outside, as though the demoness is running her hands over your form with delight. The world around you groans and gurgles, but the fluids that ooze into this place don't seem harmful, yet. Instead, you feel your very energy being steadily depleted, much to the joy of the woman who's claiming it all for herself."
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

