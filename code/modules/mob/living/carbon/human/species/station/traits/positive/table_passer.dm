/datum/trait/table_passer
	name = "Table Passer"
	desc = "You move over or under tables with ease of a Teshari."
	cost = 2

	// Traitgenes Replacement for /datum/trait/superpower_midget, made into a genetrait
	is_genetrait = TRUE
	hidden = FALSE
	activation_message="Your skin feels rubbery."

	has_preferences = list("pass_table" = list(TRAIT_PREF_TYPE_BOOLEAN, "On spawn", TRAIT_NO_VAREDIT_TARGET, TRUE))
	category = TRAIT_TYPE_POSITIVE

/datum/trait/table_passer/apply(var/datum/species/S,var/mob/living/carbon/human/H, var/list/trait_prefs)
	..()
	if(trait_prefs?["pass_table"] || !trait_prefs)
		H.pass_flags |= PASSTABLE
	add_verb(H,/mob/living/proc/toggle_pass_table)

// Traitgenes All genetraits need an unapply proc if they do anything special
/datum/trait/table_passer/unapply(datum/species/S, mob/living/carbon/human/H)
	. = ..()
	if (H.pass_flags & PASSTABLE)
		H.pass_flags ^= PASSTABLE
	if(!(/mob/living/proc/toggle_pass_table in S.inherent_verbs)) // Teshari shouldn't lose agility
		remove_verb(H,/mob/living/proc/toggle_pass_table)
