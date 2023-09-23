/mob/living/simple_mob/vore/peasant
	name = "peasant"
	desc = "They're just about getting by."
	tt_desc = "Homo Sapiens"

	icon_state = "peasantfa"
	icon = 'icons/mob/vore.dmi'

	harm_intent_damage = 2
	melee_damage_lower = 1
	melee_damage_upper = 2

	response_help = "pats"
	response_disarm = "pushes"
	response_harm = "punches"

	attacktext = list("punched","kicked")

	say_list_type = /datum/say_list/peasant
	ai_holder_type = /datum/ai_holder/simple_mob/retaliate

	var/random_skin = 1
	var/list/skins = list(
		"peasantfa",
		"peasantfb",
		"peasantfc",
		"peasantma",
		"peasantmb"
	)

	faction = "peasant"

/mob/living/simple_mob/vore/peasant/New()
	..()
	if(random_skin)
		icon_living = pick(skins)
		icon_rest = "[icon_living]asleep"
		icon_dead = "[icon_living]-dead"
		update_icon()

// Activate Noms!
/mob/living/simple_mob/vore/peasant
	vore_active = 1
	vore_bump_chance = 10
	vore_pounce_chance = 20
	vore_standing_too = 1
	vore_ignores_undigestable = 0
	vore_default_mode = DM_HOLD
	vore_digest_chance = 25 // But don't you dare try to escape...
	vore_icons = SA_ICON_LIVING | SA_ICON_REST

/datum/say_list/peasant
	speak = list("Fine day!","What was I doing again? Oh yeah, nothing.","How are ya?","I sure do love bread.","Where did I leave my scraps of cloth?","Sure is a good time to exist, I guess.")
	emote_hear = list("yawns","'s stomach grumbles","shuffles")
	emote_see = list("exists","just stands there","smiles","looks around")

/mob/living/simple_mob/vore/peasant/init_vore()
	..()
	var/obj/belly/B = vore_selected
	B.name = "stomach"
	B.desc = "You've somehow managed to get yourself eaten by one of the local peasants. After jamming you down into their stomach, you find yourself cramped up tight in a space that clearly shouldn't be able to accept you. They let out a relieved sigh as they heft around their new found weight, giving it a hearty pat, clearly content to get a good meal for once. The world around you groans and grumbles, but the gut is far from harmful to you right now, even as the walls clench down on your body."
	B.mode_flags = DM_FLAG_THICKBELLY
	B.belly_fullscreen = "yet_another_tumby"
	B.digest_brute = 1
	B.digest_burn = 1
	B.digest_oxy = 0
	B.digestchance = 25
	B.absorbchance = 0
	B.escapechance = 15
	B.selective_preference = DM_HOLD
	B.escape_stun = 5

