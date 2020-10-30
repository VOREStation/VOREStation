
/mob/living/simple_mob
	// Assoc list of items that can be given to a mob to befriend it, and the percent success.
	var/list/tame_items
	// List of mobs who are 'friends'.
	var/list/tamers

/mob/living/simple_mob/IIsAlly(mob/living/L)
	. = ..()

	if(!. && LAZYLEN(tamers))
		listclearnulls(tamers)
		if(L in tamers)
			return TRUE

/mob/living/simple_mob/proc/can_tame(var/obj/O, var/mob/user)
	if(!LAZYLEN(tame_items))
		return FALSE

	if(!user)
		return FALSE

	if(!O)
		return FALSE

	for(var/path in tame_items)
		if(istype(O, path) && unique_tame_check(O,user))
			return TRUE

	return FALSE

/mob/living/simple_mob/proc/unique_tame_check(var/obj/O, var/mob/user)
	if(do_after(user, 0.5 SECONDS, src))
		return TRUE
	return FALSE

/mob/living/simple_mob/proc/tame_prob(var/obj/O, var/mob/user)
	for(var/path in tame_items)
		if(istype(O, path))
			if(prob(tame_items[path]))
				return TRUE
	return FALSE

/mob/living/simple_mob/proc/do_tame(var/obj/O, var/mob/user)
	if(!user)
		return

	if(!LAZYLEN(tamers))
		tamers = list()

	handle_tame_item(O, user)

	tamers |= user
	ai_holder.forget_everything()

/mob/living/simple_mob/proc/handle_tame_item(var/obj/O, var/mob/user)
	user.drop_from_inventory(O)
	qdel(O)

/mob/living/simple_mob/proc/fail_tame(var/obj/O, var/mob/user)
	user.drop_from_inventory(O)
	qdel(O)
