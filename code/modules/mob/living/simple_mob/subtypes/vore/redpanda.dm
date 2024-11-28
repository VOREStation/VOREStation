/mob/living/simple_mob/vore/redpanda
	name = "red panda"
	desc = "It's a wah! Beware of doom pounce!"
	tt_desc = "Ailurus fulgens"

	icon_state = "wah"
	icon_living = "wah"
	icon_dead = "wah_dead"
	icon_rest = "wah_rest"
	icon = 'icons/mob/vore.dmi'

	faction = FACTION_REDPANDA
	maxHealth = 30
	health = 30

	meat_amount = 2
	meat_type = /obj/item/reagent_containers/food/snacks/meat

	response_help = "pats"
	response_disarm = "gently pushes aside"
	response_harm = "hits"

	harm_intent_damage = 3
	melee_damage_lower = 3
	melee_damage_upper = 1
	attacktext = list("bapped")

	say_list_type = /datum/say_list/redpanda
	ai_holder_type = /datum/ai_holder/simple_mob/passive

	allow_mind_transfer = TRUE

// Activate Noms!
/mob/living/simple_mob/vore/redpanda
	vore_active = 1
	vore_bump_chance = 10
	vore_bump_emote	= "playfully lunges at"
	vore_pounce_chance = 40
	vore_default_mode = DM_HOLD // above will only matter if someone toggles it anyway
	vore_icons = SA_ICON_LIVING

/mob/living/simple_mob/vore/redpanda/fae
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

/mob/living/simple_mob/vore/redpanda/blue
	name = "blue wah"
	desc = "Blue, but still cute!"
	tt_desc = "Ailurus tribotum"

	icon_state = "wah_bloo"
	icon_living = "wah_bloo"
	icon_dead = "wah_bloo_dead"
	icon_rest = "wah_bloo_rest"

	vore_ignores_undigestable = 0	// wah don't care you're edible or not, you still go in
	vore_digest_chance = 0			// instead of digesting if you struggle...
	vore_absorb_chance = 20			// you get to become adorable purple wahpudge.
	vore_bump_chance = 75
	maxHealth = 100
	health = 100
	melee_damage_lower = 10
	melee_damage_upper = 20

/datum/say_list/redpanda
	speak = list("Wah!","Wah?","Waaaah.")
	emote_hear = list("wahs!","chitters.")
	emote_see = list("trundles around","rears up onto their hind legs and pounces a bug")
