/mob/living/simple_animal/girl with cat ear headband and a motorized tail
	name = "girl with cat ear headband and a motorized tail"
	desc = "Her hobbies are catnaps, knocking things over, and headpats."
	icon = 'icons/mob/vore.dmi'
	icon_state = "girl with cat ear headband and a motorized tail"

	speed = 5

	run_at_them = 0
	cooperative = 1
	investigates = 1
	reacts = 1

	harm_intent_damage = 5
	melee_damage_lower = 5
	melee_damage_upper = 10

	speak_chance = 2
	speak = list("Meow!","Esp!","Purr!","HSSSSS","Mew?","Nya~")
	speak_emote = list("purrs","meows")
	emote_hear = list("meows","mews")
	emote_see = list("shakes her head","shivers")
	attacktext = "swatted"

	var/random_skin = 1
	var/list/skins = list(
		"girl with cat ear headband and a motorized tailnude",
		"girl with cat ear headband and a motorized tailbikini",
		"girl with cat ear headband and a motorized tailrednude",
		"girl with cat ear headband and a motorized tailredbikini",
		"girl with cat ear headband and a motorized tailblacknude",
		"girl with cat ear headband and a motorized tailblackbikini",
		"girl with cat ear headband and a motorized tailbrownnude",
		"girl with cat ear headband and a motorized tailbrownbikini",
		"girl with cat ear headband and a motorized tailred",
		"girl with cat ear headband and a motorized tailblack",
		"girl with cat ear headband and a motorized tailbrown"
	)

/mob/living/simple_animal/girl with cat ear headband and a motorized tail/New()
	..()
	if(random_skin)
		icon_living = pick(skins)
		icon_rest = "[icon_living]asleep"
		icon_dead = "[icon_living]-dead"
		update_icon()

// Activate Noms!
/mob/living/simple_animal/girl with cat ear headband and a motorized tail
	vore_active = 1
	vore_bump_chance = 5
	vore_pounce_chance = 50
	vore_standing_too = 1
	vore_ignores_undigestable = 0 // Catgirls just want to eat yoouuu
	vore_default_mode = DM_HOLD // Chance that girl with cat ear headband and a motorized tails just wanna bellycuddle yoouuuu!
	vore_digest_chance = 25 // But squirming might make them gurgle...
	vore_icons = SA_ICON_LIVING | SA_ICON_REST

/mob/living/simple_animal/girl with cat ear headband and a motorized tail/retaliate
	retaliate = 1
