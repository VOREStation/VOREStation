/atom
	var/catalogue_delay = 5 SECONDS // How long it take to scan.
	// List of types of /datum/category_item/catalogue that should be 'unlocked' when scanned by a Cataloguer.
	// It is null by default to save memory by not having everything hold onto empty lists. Use macros like LAZYLEN() to check.
	// Also you should use get_catalogue_data() to access this instead of doing so directly, so special behavior can be enabled.
	var/list/catalogue_data = null

/mob
	catalogue_delay = 10 SECONDS

// Tests if something can be catalogued.
// If something goes wrong and a mob was supplied, the mob will be told why they can't catalogue it.
/atom/proc/can_catalogue(mob/user)
	// First check if anything is even on here.
	var/list/data = get_catalogue_data()
	if(!LAZYLEN(data))
		to_chat(user, span_warning("\The [src] is not interesting enough to catalogue."))
		return FALSE
	else
		// Check if this has nothing new on it.
		var/has_new_data = FALSE
		for(var/t in data)
			var/datum/category_item/catalogue/item = GLOB.catalogue_data.resolve_item(t)
			if(!item.visible)
				has_new_data = TRUE
				break

		if(!has_new_data)
			to_chat(user, span_warning("Scanning \the [src] would provide no new information."))
			return FALSE

	return TRUE

/mob/living/can_catalogue(mob/user) // Dead mobs can't be scanned.
	if(stat >= DEAD)
		to_chat(user, span_warning("Entities must be alive for a comprehensive scan."))
		return FALSE
	return ..()

/obj/item/can_catalogue(mob/user) // Items must be identified to be scanned.
	if(!is_identified())
		to_chat(user, span_warning("The properties of this object has not been determined. Identify it first."))
		return FALSE
	return ..()

/atom/proc/get_catalogue_delay()
	return catalogue_delay

// Override for special behaviour.
// Should return a list with one or more "/datum/category_item/catalogue" types, or null.
// If overriding, it may be wise to call the super and get the results in order to merge the base result and the special result, if appropiate.
/atom/proc/get_catalogue_data()
	return catalogue_data

/mob/living/carbon/human/get_catalogue_data()
	var/list/data = list()
	// First, handle robot-ness.
	var/beep_boop = get_FBP_type()
	switch(beep_boop)
		if(FBP_CYBORG)
			data += /datum/category_item/catalogue/technology/cyborgs
		if(FBP_POSI)
			data += /datum/category_item/catalogue/technology/positronics
		if(FBP_DRONE)
			data += /datum/category_item/catalogue/technology/drone/drones
	// Now for species.
	if(!(beep_boop in list(FBP_POSI, FBP_DRONE))) // Don't give the species entry if they are a posi or drone.
		if(species && LAZYLEN(species.catalogue_data))
			data += species.catalogue_data
	return data

/mob/living/silicon/robot/get_catalogue_data()
	var/list/data = list()
	switch(braintype)
		if(BORG_BRAINTYPE_CYBORG)
			data += /datum/category_item/catalogue/technology/cyborgs
		if(BORG_BRAINTYPE_POSI)
			data += /datum/category_item/catalogue/technology/positronics
		if(BORG_BRAINTYPE_DRONE)
			data += /datum/category_item/catalogue/technology/drone/drones
	return data
