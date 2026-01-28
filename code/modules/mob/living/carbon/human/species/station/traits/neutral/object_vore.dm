
/datum/trait/trashcan
	name = "Trash Can"
	desc = "Allows you to dispose of some garbage on the go instead of having to look for a bin or littering like an animal."
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL
	var_changes = list("trashcan" = 1)

	// Traitgenes made into a genetrait
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="Your stomach feels strange."
	primitive_expression_messages=list("eats something off the ground.")

/datum/trait/trashcan/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	add_verb(H, /mob/living/proc/eat_trash)
	add_verb(H, /mob/living/proc/toggle_trash_catching)

// Traitgenes made into a genetrait
/datum/trait/trashcan/unapply(datum/species/S, mob/living/carbon/human/H, trait_prefs)
	..()
	if(!(/mob/living/proc/eat_trash in S.inherent_verbs))
		remove_verb(H,/mob/living/proc/eat_trash)
	if(!(/mob/living/proc/toggle_trash_catching in S.inherent_verbs))
		remove_verb(H,/mob/living/proc/toggle_trash_catching)
