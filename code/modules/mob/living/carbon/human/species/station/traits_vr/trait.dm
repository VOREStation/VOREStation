/datum/trait
	var/name
	var/desc = "Contact a developer if you see this trait."

	var/cost = 0
	var/sort = TRAIT_SORT_NORMAL	// Sort order, 1 before 2 before 3 etc. Alphabetical is used for same-group traits.
	var/category = TRAIT_TYPE_NEUTRAL	// What category this trait is. -1 is Negative, 0 is Neutral, 1 is Positive
	var/list/var_changes			// A list to apply to the custom species vars.
	var/list/var_changes_pref		// A list to apply to the preference vars.
	var/list/excludes				// Store a list of paths of traits to exclude, but done automatically if they change the same vars.
	var/can_take = ORGANICS|SYNTHETICS	// Can freaking synths use those.
	var/list/banned_species			// A list of species that can't take this trait
	var/list/allowed_species		// VORESTATION EDIT:chomp port. A list of species that CAN take this trait, use this if only a few species can use it. -shark
	var/custom_only = TRUE			// Trait only available for custom species
	var/varchange_type = TRAIT_VARCHANGE_ALWAYS_OVERRIDE	//Mostly used for non-custom species.

//Proc can be overridden lower to include special changes, make sure to call up though for the vars changes
/datum/trait/proc/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	ASSERT(S)
	if(var_changes)
		for(var/V in var_changes)
			if((category == TRAIT_TYPE_POSITIVE && ((varchange_type == TRAIT_VARCHANGE_LESS_BETTER && var_changes[V] > S.vars[V]) || (varchange_type == TRAIT_VARCHANGE_MORE_BETTER && var_changes[V] < S.vars[V]))) || (category == TRAIT_TYPE_NEGATIVE && ((varchange_type == TRAIT_VARCHANGE_LESS_BETTER && var_changes[V] < S.vars[V]) || (varchange_type == TRAIT_VARCHANGE_MORE_BETTER && var_changes[V] > S.vars[V]))))
				continue
			S.vars[V] = var_changes[V]
	return

//Applying trait to preferences rather than just us.
/datum/trait/proc/apply_pref(var/datum/preferences/P)
	ASSERT(P)
	if(var_changes_pref)
		for(var/V in var_changes_pref)
			P.vars[V] = var_changes_pref[V]
	return

//Similar to the above, but for removing. Probably won't be called often/ever.
/datum/trait/proc/remove(var/datum/species/S)
	ASSERT(S)
	return

//Similar to the above, but for removing.
/datum/trait/proc/remove_pref(var/datum/preferences/P)
	ASSERT(P)
	if(var_changes_pref)
		for(var/V in var_changes_pref)
			P.vars[V] = initial(P.vars[V])
	return
