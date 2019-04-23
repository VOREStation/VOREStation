/*
LORE:
Gaslamps are a phoron-based life form endemic to the world of Virgo-3B. They are
a sort of fungal organism with physical ties to Diona and Vox, deriving energy
for movement from a gentle combustion-like reaction in their bodies using
atmospheric phoron, carefully filtered trace oxygen, and captured meat products.
Over-exposure to oxygen causes their insides to burn too hot and eventually
kills them.

TODO: Make them light up and heat the air when exposed to oxygen.
*/

/datum/category_item/catalogue/fauna/gaslamp		//TODO: VIRGO_LORE_WRITING_WIP
	name = "Virgo 3b Fauna - Gaslamp"
	desc = ""
	value = CATALOGUER_REWARD_TRIVIAL

/mob/living/simple_mob/animal/passive/gaslamp
	name = "gaslamp"
	desc = "Some sort of floaty alien with a warm glow. This creature is endemic to Virgo-3B."
	tt_desc = "Semaeostomeae virginus"
	catalogue_data = list(/datum/category_item/catalogue/fauna/gaslamp)

	icon_state = "gaslamp"
	icon_living = "gaslamp"
	icon_dead = "gaslamp-dead"
	icon = 'icons/mob/vore32x64.dmi'

	faction = "virgo3b"
	maxHealth = 100
	health = 100
	movement_cooldown = 12

	say_list_type = /datum/say_list/gaslamp
	ai_holder_type = /datum/ai_holder/simple_mob/gaslamp

	//speed = 2 not sure what this is, guessing animation, but it conflicts with new system.

	melee_damage_lower = 15 // Because fuck anyone who hurts this sweet, innocent creature.
	melee_damage_upper = 15
	attacktext = list("thrashed")
	friendly = "caressed"

	response_help   = "brushes"	// If clicked on help intent
	response_disarm = "pushes" // If clicked on disarm intent
	response_harm   = "swats"	// If clicked on harm intent

	minbodytemp = 0
	maxbodytemp = 350

	min_oxy = 0
	max_oxy = 5 // Does not like oxygen very much.
	min_tox = 1 // Needs phoron to survive.
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0

/datum/say_list/gaslamp
	emote_see = list("looms", "sways gently")

/datum/ai_holder/simple_mob/gaslamp
	hostile = FALSE // The majority of simplemobs are hostile, gaslamps are nice.
	cooperative = FALSE
	retaliate = TRUE //so the monster can attack back
	returns_home = FALSE
	can_flee = FALSE
	speak_chance = 1
	wander = TRUE
	base_wander_delay = 9

// Activate Noms!
/mob/living/simple_mob/animal/passive/gaslamp
	vore_active = 1
	vore_capacity = 2
	vore_bump_chance = 90 //they're frickin' jellyfish anenome filterfeeders, get tentacled
	vore_bump_emote = "lazily wraps its tentacles around"
	vore_standing_too = 1 // Defaults to trying to give you that big tentacle hug.
	vore_ignores_undigestable = 0 // they absorb rather than digest, you're going in either way
	vore_default_mode = DM_HOLD
	vore_digest_chance = 0			// Chance to switch to digest mode if resisted
	vore_absorb_chance = 20			// BECOME A PART OF ME.
	vore_pounce_chance = 5 // Small chance to punish people who abuse their nomming behaviour to try and kite them forever with repeated melee attacks.
	vore_stomach_name = "internal chamber"
	vore_stomach_flavor	= "You are squeezed into the tight embrace of the alien creature's warm and cozy insides."
	vore_icons = SA_ICON_LIVING
