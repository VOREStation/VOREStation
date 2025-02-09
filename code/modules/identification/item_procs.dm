// This is on the base /item so badmins can play with it by calling hide_identity().
/obj/item
	var/datum/identification/identity = null
	var/identity_type = /datum/identification
	var/init_hide_identity = FALSE // Set to true to automatically obscure the object on initialization.

/obj/item/Initialize(mapload)
	if(init_hide_identity)
		identity = new identity_type(src)
	return ..()

/obj/item/Destroy()
	if(identity)
		QDEL_NULL(identity)
	return ..()

/obj/item/proc/hide_identity() // Mostly for admins to make things secret.
	if(!identity)
		identity = new identity_type(src)
	else
		identity.unidentify()

/obj/item/proc/identify(identity_type = IDENTITY_FULL, mob/user)
	if(identity)
		identity.identify(identity_type, user)

/obj/item/proc/is_identified(identity_type = IDENTITY_FULL)
	if(!identity) // No identification datum means nothing to hide.
		return TRUE
	return identity_type & identity.identified
