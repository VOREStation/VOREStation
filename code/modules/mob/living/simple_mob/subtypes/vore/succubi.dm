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
	ai_holder_type = /datum/ai_holder/simple_mob/retaliate/edible

	var/random_skin = 1
	var/list/skins = list(
		"succubus",
		"succubusbob",
		"succubusginger",
		"succubusclothed",
		"succubusbobclothed",
		"succubusgingerclothed"
	)

	faction = FACTION_SUCCUBUS

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
	vore_digest_chance = 0 // But don't you dare try to escape...
	vore_icons = SA_ICON_LIVING | SA_ICON_REST

/datum/say_list/succubus
	speak = list("Come here cutie!","Let me get a good look at you!","Want to spend a little quality time together?","I don't bite. Much.","Like what you see?","Feel free to sample the goods.")
	emote_hear = list("makes a kissing sound","giggles","lets out a needy whine")
	emote_see = list("gestures for you to come over","winks","smiles","stretches")

/mob/living/simple_mob/vore/succubus/init_vore()
	if(!voremob_loaded)
		return
	. = ..()
	var/obj/belly/B = vore_selected
	B.name = "stomach"
	B.desc = "You find yourself tightly compressed into the stomach of the succubus, with immense pressure squeezing down on you from every direction. The wrinkled walls of the gut knead over you, like a swelteringly hot, wet massage. You can feel movement from the outside, as though the demoness is running her hands over your form with delight. The world around you groans and gurgles, but the fluids that ooze into this place don't seem harmful, yet. Instead, you feel your very energy being steadily depleted, much to the joy of the woman who's claiming it all for herself."
	B.mode_flags = DM_FLAG_THICKBELLY
	B.belly_fullscreen = "yet_another_tumby"
	B.digest_brute = 2
	B.digest_burn = 2
	B.digest_oxy = 1
	B.selectchance = 25
	B.digestchance = 0
	B.absorbchance = 0
	B.escapechance = 15
	B.selective_preference = DM_DIGEST
	B.escape_stun = 5
	B.transferlocation_absorb = "curves"

	var/obj/belly/curves = new /obj/belly(src)
	curves.immutable = TRUE
	curves.name = "curves"
	curves.desc = "Your entire being is cast adrift, no longer tight as it was in the succubus's gut but still inexorably bound, a sensation of warmth surrounding your entire being - it's pleasantly comfortable, relaxing even, as though lulling you, tempting you into simply allowing yourself to drift off. It's difficult to focus on yourself at all, any sense of your own position having abandoned you - instead, you can simply feel an odd, gentle sensation of being occasionally rubbed, stroked, squeezed, your captor eager to enjoy her prize. Even trying to move seems to elicit a satisfied chuckle, almost as though she knows that, at least on some level, some part of you wanted to give yourself to her - and she seemingly has little intention of giving you back."
	curves.digest_mode = DM_HOLD // like, shes got you already, doesn't need to get you more
	curves.mode_flags = DM_FLAG_FORCEPSAY
	curves.escapable = TRUE // good luck
	curves.escapechance = 40 // high chance of STARTING a successful escape attempt
	curves.escapechance_absorbed = 5 // m i n e
	curves.vore_verb = "soak"
	curves.count_absorbed_prey_for_sprite = FALSE
	curves.absorbed_struggle_messages_inside = list(
		"You try and push free from %pred's %belly, but can't seem to will yourself to move.",
		"Your fruitless mental struggles only cause %pred to chuckle lightly.",
		"You can't make any progress freeing yourself from %pred's %belly.")
	curves.escape_attempt_absorbed_messages_owner = list(
		"%prey is attempting to free themselves from your %belly!")

	curves.escape_attempt_absorbed_messages_prey = list(
		"You try to force yourself out of %pred's %belly.",
		"You strain and push, attempting to reach out of %pred's %belly.",
		"You work up the will to try and force yourself free of %pred's clutches.")

	curves.escape_absorbed_messages_owner = list(
		"%prey forces themselves free of your %belly!")

	curves.escape_absorbed_messages_prey = list(
		"You finally manage to wrest yourself free from %pred's %belly, re-asserting your more usual form.",
		"You heave and push, eventually spilling out from %pred's %belly, eliciting an amused smile from your former captor.")

	curves.escape_absorbed_messages_outside = list(
		"%prey suddenly forces themselves free of %pred's %belly!")

	curves.escape_fail_absorbed_messages_owner = list(
		"%prey's attempt to escape form your %belly has failed!")

	curves.escape_fail_absorbed_messages_prey = list(
		"Before you manage to reach freedom, you feel yourself getting dragged back into %pred's %belly!",
		"%pred laughs lightly, simply pressing your wrigging form back into her %belly before you get anywhere.",
		"%pred gently rubs a finger over her %belly, the gentle pressure breaking your concentration and sending you sinking back into her form.",
		"Try as you might, you barely make an impression before %pred simply clenches with the most minimal effort, binding you back into her %belly.",
		"Unfortunately, %pred seems to have absolutely no intention of letting you go, and your futile effort goes nowhere.",
		"Strain as you might, you can't keep up the effort long enough before you sink back into %pred's %belly.")
