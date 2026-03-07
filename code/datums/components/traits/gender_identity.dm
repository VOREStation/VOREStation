/datum/component/gender_identity
	var/identifying_gender = NEUTER

/datum/component/gender_identity/Initialize(set_gender)
	identifying_gender = set_gender
	if(ismob(parent)) // Allow mobs to change this as desired
		var/mob/our_mob = parent
		add_verb(our_mob,/mob/proc/toggle_gender_identity_vr)

/// Sets the gender identity of an atom to a specific gender key, such as PLURAL, MALE, FEMALE, PLURAL, or any extended gender that byond does not regularly support. If this is done without a /datum/component/gender_identity component, only the base byond genders will be applied. Returns TRUE if the gender assigned is different to what it was previously.
/atom/proc/change_gender_identity(new_gender)
	var/datum/component/gender_identity/comp = GetComponent(/datum/component/gender_identity)
	if(comp)
		if(comp.identifying_gender != new_gender)
			comp.identifying_gender = new_gender
			return TRUE
		return FALSE
	// Lets try to give it support for complex genders then
	AddComponent(/datum/component/gender_identity, new_gender)
	return gender != new_gender

/// Used to get the gender identity of an atom. Byond does not support gender keys other than PLURAL, MALE, FEMALE, PLURAL. So it must have a /datum/component/gender_identity component if extended genders are going to be used.
/atom/proc/get_gender_identity()
	var/datum/component/gender_identity/comp = GetComponent(/datum/component/gender_identity)
	if(comp) // We use complex genders
		return comp.identifying_gender
	return gender // Assume byond genders

/// Transfers the gender identity of one atom to another. By default, if the destination does not support complex genders(and a complex gender is in use!), it will be given the component to do so.
/atom/proc/exchange_gender(atom/destination, force_complex_gender = TRUE)
	var/datum/component/gender_identity/comp = GetComponent(/datum/component/gender_identity)
	var/datum/component/gender_identity/destcomp = destination.GetComponent(/datum/component/gender_identity)

	// If neither of us support, just exchange byond gender
	if(!comp && !destcomp)
		destination.gender = gender
		return TRUE

	// Both support, easy!
	if(comp && destcomp)
		destcomp.identifying_gender = comp.identifying_gender
		destination.gender = PLURAL // make sure the complex gender can be assigned to the byond gender, if not assume plural
		if((comp.identifying_gender in byond_genders_define_list))
			destination.gender = comp.identifying_gender
		return TRUE

	// Our destination doesn't support complex genders...
	if(comp && !destcomp)
		if(!(comp.identifying_gender in byond_genders_define_list))
			if(force_complex_gender)
				// ... give em the component and assign it!
				destination.AddComponent(/datum/component/gender_identity, comp.identifying_gender)
			else
				// ... fallback to plural if we need to
				destination.gender = PLURAL
			return TRUE
		destination.gender = comp.identifying_gender
		return TRUE

	// We don't support complex genders, use our base gender when setting theirs! No safety here as we can only have byond safe genders anyway
	if(destcomp && !comp)
		destcomp.identifying_gender = gender
		destcomp.gender = gender
		return TRUE

	// Otherwise we failed somehow?
	return FALSE

/// Allows gender identity to be assigned at player's discretion, added as a verb when the /datum/component/gender_identity is added to a mob
/mob/proc/toggle_gender_identity_vr()
	set name = "Set Gender Identity"
	set desc = "Sets the pronouns when examined and performing an emote."
	set category = "IC.Settings"
	var/new_gender_identity = tgui_input_list(src, "Please select a gender Identity:", "Set Gender Identity", all_genders_define_list)
	if(!new_gender_identity)
		return FALSE
	change_gender_identity(new_gender_identity)
	return TRUE
