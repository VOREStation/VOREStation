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
	vis_height = 64

	faction = "virgo3b"
	maxHealth = 100
	health = 100
	movement_cooldown = 4

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

/mob/living/simple_mob/animal/passive/gaslamp/init_vore()
	..()
	var/obj/belly/B = vore_selected
	B.name = "internal chamber"
	B.desc = "Having been too slow to disentangle yourself from the gaslamp's tentacles, the alien creature eventually winds enough of them around your body to lift you up off of the ground. Struggle as you might now, it is too late to deny the jellyfish-esque scavenger its lucky catch; inch by inch, the gaslamp tugs you upwards into its equivalent of a stomach, the transition between the cool-to-frigid atmosphere on the outside to its surprising internal heat something you can feel through any outer wear you possess. Minutes pass, soon resulting in the gentle creature's body sporting a rounded, bulging swell, an indistinct shadow shifting and twitching inside it as you squirm about. Be it to escape or simply to get settled, you might want to take care, however. The gaslamp's internal chamber is slick and squishy instead of overly oppressive, yet, each wave of warmth that pulses over you leaves you feeling weaker than the last..."

	B.emote_lists[DM_HOLD] = list(
		"The gaslamp gently bobs up and down as it lazily drifts elsewhere, the movement hardly enough to disturb the shadowy, indistinct figure curled up within it: you.",
		"The fungal creature’s inner walls tenderly ripple and squeeze about your form for a few moments, squelching softly... until another wave of warmth pulses through the chamber.",
		"You attempt to shift into another, more comfortable position, only for the alien’s innards to more thoroughly squish inwards; both encouraging you to stay still, and to do the reorienting for you.",
		"Occasionally, a soft glow mutedly shines through the gaslamp and into its prey-filled insides, whenever it drifts close to something bright... yet, it always fades back into warm, slick darkness.",
		"The surrounding slimy walls suddenly knead and squish you about more thoroughly than before, massaging a stronger heat into your body... before easing, leaving you feeling pleasantly loose.",
		"Every undulation of the gaslamp’s insides leaves you feeling weaker than the last, more relaxed... and evermore tempted to oblige its passive possessiveness, letting it shelter you from the elements.")

	B.emote_lists[DM_ABSORB] = list(
		"As the gaslamp slowly drifts off somewhere, its inner chamber grips and squeezes over its indistinct, shadowy filling with a lazily increasing fervor, that bump gradually shrinking!",
		"The fungal creature’s pseudo-stomach slimily squelches about your form, every tight clench and the following burst of heat draining your energy... as the walls grow squishier, almost molten!",
		"You attempt to push out against those kneading, steadily encroaching insides, yet the doughy flesh accepts the advance with ease... and, on the outside, your effort makes a faint bulge at most!",
		"Light occasionally filters down through the gaslamp’s various membranes, but it is becoming hard to notice, your eyelids feeling leaden, weighed down as the looming creature comes ever closer to claiming you!",
		"The gaslamp’s rhythmically undulating innards abruptly squish and massage down into your curled-up body, each squeeze bringing another brief increase to the heat already sinking deep into you... making it harder to tell where you end, and it begins!",
		"Every moment longer spent trapped within the gaslamp drains evermore energy out of you, squelching away your will to resist its possessive advances… and as its innards force submission into you, the swell you make visibly softens away!")
