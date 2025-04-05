/datum/trait
	var/name
	var/desc = "Contact a developer if you see this trait."
	var/tutorial = "This trait has no detailed tutorial yet. Suggest one at #Dev-Suggestions on the discord!" //Use <br> for newlines, NOT \n

	var/cost = 0
	var/sort = TRAIT_SORT_NORMAL	// Sort order, 1 before 2 before 3 etc. Alphabetical is used for same-group traits.
	var/category = TRAIT_TYPE_NEUTRAL	// What category this trait is. -1 is Negative, 0 is Neutral, 1 is Positive
	var/list/var_changes			// A list to apply to the custom species vars.
	var/list/var_changes_pref		// A list to apply to the preference vars.
	var/list/excludes				// Store a list of paths of traits to exclude, but done automatically if they change the same vars.
	var/can_take = ORGANICS|SYNTHETICS	// Can freaking synths use those.
	var/list/banned_species			// A list of species that can't take this trait
	var/list/allowed_species		// A list of species that CAN take this trait, use this if only a few species can use it. -shark
	var/custom_only = TRUE			// Trait only available for custom species
	var/varchange_type = TRAIT_VARCHANGE_ALWAYS_OVERRIDE	//Mostly used for non-custom species.
	var/has_preferences //if set, should be a list of the preferences for this trait in the format: list("identifier/name of var to edit" = list(typeofpref, "text to display in prefs", TRAIT_NO_VAREDIT_TARGET/TRAIT_VAREDIT_TARGET_SPECIES/etc, (optional: default value)), etc) typeofpref should follow the defines in _traits.dm (eg. TRAIT_PREF_TYPE_BOOLEAN)
	var/special_env = FALSE




	// Traitgenes Traits can toggle mutations and disabilities

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// IMPORTANT - in 99% of situations you should NOT need to edit gene code when adding a new traitgene. Genes only handle the on/off state of traits, traits control the changes and behaviors!
	// Just keep pretending genecode doesn't exist and you should be fine. Traitgenes were made with that in mind, and are not intended to be something you need to edit every time you add a traitgene.
	// Traitgenes only require that your trait has both an apply() and unapply() if it does anything like adding verbs. Otherwise, you don't even need to add trait exceptions. traitgenes handle it automatically.
	// You probably shouldn't mark traits as traitgenes if they are custom species only, species locked, or species banned traits however... - Willbird
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	var/is_genetrait = FALSE // When their trait's datum is init, it will be added to the library of genes a carbon can be mutated to have or not have
	var/list/activity_bounds = DNA_DEFAULT_BOUNDS // Activation requirement for trait to turn on/off. Dna is automatically configured for this when first spawned
	var/hidden = FALSE  // If a trait does not show on the list, only useful for genetics only traits that cannot be taken at character creation
	var/mutation = 0 	// Mutation to give (or 0)
	var/disability = 0 	// Disability to give (or 0)
	var/sdisability = 0 // SDisability to give (or 0)
	var/activation_message = null // If not null, shows a message when activated as a gene
	var/deactivation_message = null // If not null, shows a message when deactivated as a gene
	var/list/primitive_expression_messages=list() // Monkey's custom emote when they have this gene!

	var/datum/gene/trait/linked_gene = null // Internal use, do not assign.




//Proc can be overridden lower to include special changes, make sure to call up though for the vars changes
/datum/trait/proc/apply(var/datum/species/S,var/mob/living/carbon/human/H, var/trait_prefs = null)
	ASSERT(S)
	if(var_changes)
		for(var/V in var_changes)
			if(V == "flags") // Is bitflag, implimentation means traits can only GIVE you flags, not remove them.
				S.vars[V] |= var_changes[V]
			else
				S.vars[V] = var_changes[V]
	if (trait_prefs)
		for (var/trait in trait_prefs)
			switch(has_preferences[trait][3])
				if(TRAIT_NO_VAREDIT_TARGET)
					continue
				if(TRAIT_VAREDIT_TARGET_SPECIES)
					S.vars[trait] = trait_prefs[trait]
				if(TRAIT_VAREDIT_TARGET_MOB)
					H.vars[trait] = trait_prefs[trait]
	// Traitgenes Traits can toggle mutations and disabilities
	if(mutation)
		if(!(mutation in H.mutations))
			H.mutations.Add(mutation)
	if(disability)
		H.disabilities |= disability // bitflag
	if(sdisability)
		H.sdisabilities |= sdisability // bitflag
	add_verb(H, /mob/living/carbon/human/proc/trait_tutorial)
	if(special_env)
		S.env_traits += src
	return

// Traitgenes Disabling traits, genes can be turned off after all!
/datum/trait/proc/unapply(var/datum/species/S,var/mob/living/carbon/human/H, var/trait_prefs = null)
	ASSERT(S)
	if(var_changes)
		for(var/V in var_changes)
			if(V == "flags") // Is bitflag, this assumes traits can only ever GIVE you flags.
				if(!(initial(S.vars[V]) & var_changes[V]))
					S.vars[V] &= ~var_changes[V]
			else
				S.vars[V] = initial(S.vars[V])
	if (trait_prefs)
		for (var/trait in trait_prefs)
			switch(has_preferences[trait][3])
				if(TRAIT_NO_VAREDIT_TARGET)
					continue
				if(TRAIT_VAREDIT_TARGET_SPECIES)
					S.vars[trait] = initial(S.vars[trait])
				if(TRAIT_VAREDIT_TARGET_MOB)
					H.vars[trait] = initial(H.vars[trait])
	if(mutation)
		H.mutations.Remove(mutation)
	if(disability)
		H.disabilities &= ~disability // bitflag
	if(sdisability)
		H.sdisabilities &= ~sdisability // bitflag
	if(special_env)
		S.env_traits -= src
	return

/datum/trait/proc/send_message(var/mob/living/carbon/human/H, var/enabled)
	if(enabled)
		if(!activation_message)
			return
		to_chat(H,activation_message)
	else
		if(!deactivation_message)
			return
		to_chat(H,deactivation_message)
// Traitgenes edit end

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

/datum/trait/proc/get_default_prefs()
	if (!LAZYLEN(has_preferences))
		return null
	var/prefs = list()
	for (var/j in has_preferences)
		var/default = default_value_for_pref(j)
		prefs[j] = default
	return prefs

/datum/trait/proc/default_value_for_pref(var/pref)
	if (length(has_preferences[pref]) > 3) //custom default
		return has_preferences[pref][4]
	switch(has_preferences[pref][1])
		if(TRAIT_PREF_TYPE_BOOLEAN) //boolean
			return TRUE
		if(TRAIT_PREF_TYPE_COLOR) //color
			return "#ffffff"
		if(TRAIT_PREF_TYPE_STRING) //string
			return ""
	return

/datum/trait/proc/apply_sanitization_to_string(var/pref, var/input)
	if (has_preferences[pref][1] != TRAIT_PREF_TYPE_STRING || length(input) <= 0)
		return default_value_for_pref(pref)
	input = sanitizeSafe(input, MAX_NAME_LEN)
	if (length(input) <= 0)
		return default_value_for_pref(pref)
	return input

/datum/trait/proc/handle_environment_special(var/mob/living/carbon/human/H)
	return
