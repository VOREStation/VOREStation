/mob/living/simple_animal/redpanda
	name = "red panda"
	desc = "It's a wah! Beware of doom pounce!"
	tt_desc = "Ailurus fulgens"
	icon = 'icons/mob/vore.dmi'
	icon_state = "wah"
	icon_living = "wah"
	icon_dead = "wah_dead"
	icon_rest = "wah_rest"

	faction = "wah"
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
	speak = list("Wah!",
				"Wah?",
				"Waaaah.")
	emote_hear = list("wahs!","chitters.")
	emote_see = list("trundles around","rears up onto their hind legs and pounces a bug")

// Activate Noms!
/mob/living/simple_animal/redpanda
	vore_active = 1
	vore_bump_chance = 10
	vore_bump_emote	= "playfully lunges at"
	vore_pounce_chance = 40
	vore_default_mode = DM_HOLD // above will only matter if someone toggles it anyway
	vore_icons = SA_ICON_LIVING

/mob/living/simple_animal/redpanda/fae
	name = "dark wah"
	desc = "Ominous, but still cute!"
	tt_desc = "Ailurus brattus"

	icon_state = "wah_fae"
	icon_living = "wah_fae"
	icon_dead = "wah_fae_dead"
	icon_rest = "wah_fae_rest"

	vore_ignores_undigestable = 0	// wah don't care you're edible or not, you still go in
	vore_digest_chance = 0			// instead of digesting if you struggle...
	vore_absorb_chance = 20			// you get to become adorable purple wahpudge.
	vore_bump_chance = 75
	maxHealth = 100
	health = 100
	melee_damage_lower = 10
	melee_damage_upper = 20
