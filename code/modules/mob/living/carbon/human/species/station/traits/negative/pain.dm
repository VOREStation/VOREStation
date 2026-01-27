/datum/trait/pain_intolerance_basic
	name = "Pain Intolerance"
	desc = "You are frail and sensitive to pain. You experience 25% more pain from all sources."
	cost = -2
	var_changes = list("pain_mod" = 1.2)
	category = TRAIT_TYPE_NEGATIVE


/datum/trait/pain_intolerance_advanced
	name = "Pain Intolerance, Major"
	desc = "You are highly sensitive to all sources of pain, and experience 50% more pain."
	cost = -3
	var_changes = list("pain_mod" = 1.5) //this makes you extremely vulnerable to most sources of pain, a stunbaton bop or shotgun beanbag will do around 90 agony, almost enough to drop you in one hit.

	//Traitgenes
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="You feel as though the airflow around you is painful..."
	primitive_expression_messages=list("bumps their toe, screaming in pain")
	category = TRAIT_TYPE_NEGATIVE


/datum/trait/synth_pain
	name = "Obligate Pain Simulation"
	desc = "Due to a structural flaw, hard-coding, or other inherent weakness, your body can feel pain, and you can't turn it off."
	cost = -4
	custom_only = FALSE
	can_take = SYNTHETICS
	excludes = list(/datum/trait/neutral/synth_cosmetic_pain)
	category = TRAIT_TYPE_NEGATIVE


/datum/trait/synth_pain/apply(datum/species/S, mob/living/carbon/human/H, trait_prefs)
	H.synth_cosmetic_pain = TRUE
	. = ..()
