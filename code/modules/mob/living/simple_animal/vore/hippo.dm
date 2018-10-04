/mob/living/simple_animal/retaliate/hippo
	name = "hippo"
	desc = "Mostly know for the spectacular hit of the live action movie Hungry Hungry Hippos."
	tt_desc = "Hippopotamus amphibius"
	icon = 'icons/mob/vore64x64.dmi'
	icon_state = "hippo"
	icon_living = "hippo"
	icon_dead = "hippo_dead"
	icon_gib = "hippo_gib"
	intelligence_level = SA_ANIMAL

	maxHealth = 200
	health = 200
	turns_per_move = 5
	see_in_dark = 3
	stop_when_pulled = 1
	speed = 5
	armor = list(
		"melee" = 15,//They thick as fuck boi
		"bullet" = 15,
		"laser" = 15,
		"energy" = 0,
		"bomb" = 0,
		"bio" = 0,
		"rad" = 0)

	response_help = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"
	attacktext = list("bit")
	retaliate = 1

	melee_damage_upper = 25
	melee_damage_lower = 15
	attack_sharp = 1

	old_x = -16
	old_y = 0
	default_pixel_x = -16
	pixel_x = -16
	pixel_y = 0

	speak_chance = 0.1
	speak = list("UUUUUUH")
	speak_emote = list("grunts","groans", "roars", "snorts")
	emote_hear = list("groan")
	emote_see = list("shakes its head")

	meat_amount = 10 //Infinite meat!
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat

// Activate Noms!
/mob/living/simple_animal/retaliate/hippo //I don't know why it's in a seperate line but everyone does it so i do it
	vore_active = 1
	vore_capacity = 1
	vore_bump_chance = 15
	vore_bump_emote = "lazily wraps its tentacles around"
	vore_standing_too = 1 
	vore_ignores_undigestable = 0
	vore_default_mode = DM_HOLD
	vore_digest_chance = 10
	vore_escape_chance = 20
	vore_pounce_chance = 35 //it's hippo sized it doesn't care it just eats you
	vore_stomach_name = "paunch"
	vore_stomach_flavor	= "You are squeezed into the tight embrace of the alien creature's warm and cozy insides."
	vore_icons = SA_ICON_LIVING
