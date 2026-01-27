/datum/trait/glowing_eyes
	name = "Glowing Eyes"
	desc = "Your eyes show up above darkness. SPOOKY! And kinda edgey too."
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL
	var_changes = list("has_glowing_eyes" = 1)
	has_preferences = list("has_glowing_eyes" = list(TRAIT_PREF_TYPE_BOOLEAN, "Glowing on spawn", TRAIT_VAREDIT_TARGET_SPECIES))

	// Traitgenes Made into a genetrait
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="Your eyes feel brighter."
	primitive_expression_messages=list("eyes twinkle.")

/datum/trait/glowing_eyes/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	add_verb(H, /mob/living/carbon/human/proc/toggle_eye_glow)

// Traitgenes Made into a genetrait
/datum/trait/glowing_eyes/unapply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	if(!(/mob/living/carbon/human/proc/toggle_eye_glow in S.inherent_verbs))
		remove_verb(H,/mob/living/carbon/human/proc/toggle_eye_glow)
