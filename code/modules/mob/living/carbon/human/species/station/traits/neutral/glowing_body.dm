/datum/trait/glowing_body
	name = "Glowing Body"
	desc = "Your body glows about as much as a PDA light! Settable color and toggle in Abilities tab ingame."
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL
	has_preferences = list("glow_toggle" = list(TRAIT_PREF_TYPE_BOOLEAN, "Glowing on spawn", TRAIT_VAREDIT_TARGET_MOB, FALSE), \
							"glow_color" = list(TRAIT_PREF_TYPE_COLOR, "Glow color", TRAIT_VAREDIT_TARGET_MOB))

	// Traitgenes Made into a genetrait
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="You feel enlightened."
	primitive_expression_messages=list("shines and sparkles.")

/datum/trait/glowing_body/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	add_verb(H, /mob/living/proc/glow_toggle)
	add_verb(H, /mob/living/proc/glow_color)

// Traitgenes Made into a genetrait
/datum/trait/glowing_body/unapply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	if(!(/mob/living/proc/glow_toggle in S.inherent_verbs))
		remove_verb(H,/mob/living/proc/glow_toggle)
	if(!(/mob/living/proc/glow_color in S.inherent_verbs))
		remove_verb(H,/mob/living/proc/glow_color)
