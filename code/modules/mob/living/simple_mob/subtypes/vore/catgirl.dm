/mob/living/simple_mob/vore/catgirl
	name = "catgirl"
	desc = "Her hobbies are catnaps, knocking things over, and headpats."
	tt_desc = "Homo felinus"

	icon_state = "catgirl"
	icon = 'icons/mob/vore.dmi'

	harm_intent_damage = 5
	melee_damage_lower = 2
	melee_damage_upper = 5

	response_help = "pets"
	response_disarm = "gently baps"
	response_harm = "hits"

	attacktext = list("swatted","bapped")

	say_list_type = /datum/say_list/catgirl
	ai_holder_type = /datum/ai_holder/simple_mob/passive/catgirl

	var/random_skin = 1
	var/list/skins = list(
		"catgirl",
		"catgirlnude",
		"catgirlbikini",
		"catgirlrednude",
		"catgirlredbikini",
		"catgirlblacknude",
		"catgirlblackbikini",
		"catgirlbrownnude",
		"catgirlbrownbikini",
		"catgirlred",
		"catgirlblack",
		"catgirlbrown"
	)

	faction = FACTION_CATGIRL

/mob/living/simple_mob/vore/catgirl/New()
	..()
	if(random_skin)
		icon_living = pick(skins)
		icon_rest = "[icon_living]asleep"
		icon_dead = "[icon_living]-dead"
		update_icon()

// Activate Noms!
/mob/living/simple_mob/vore/catgirl
	vore_active = 1
	vore_bump_chance = 5
	vore_pounce_chance = 50
	vore_standing_too = 1
	vore_ignores_undigestable = 0 // Catgirls just want to eat yoouuu
	vore_default_mode = DM_HOLD // Chance that catgirls just wanna bellycuddle yoouuuu!
	vore_digest_chance = 25 // But squirming might make them gurgle...
	vore_icons = SA_ICON_LIVING | SA_ICON_REST

/datum/say_list/catgirl
	speak = list("Meow!","Esp!","Purr!","HSSSSS","Mew?","Nya~")
	emote_hear = list("meows","mews","purrs")
	emote_see = list("shakes her head","shivers","stretches","grooms herself")

/datum/ai_holder/simple_mob/passive/catgirl
	base_wander_delay = 8
