/mob/living/silicon/robot/platform/death(gibbed, deathmessage, show_dead_message)

	if(gibbed)

		if(recharging)
			var/obj/item/recharging_atom = recharging.resolve()
			if(istype(recharging_atom) && !QDELETED(recharging_atom) && recharging_atom.loc == src)
				recharging_atom.dropInto(loc)
				recharging_atom.throw_at(get_edge_target_turf(src,pick(GLOB.alldirs)),rand(1,3),30)
			recharging = null

		if(length(stored_atoms))
			for(var/datum/weakref/stored_ref in stored_atoms)
				var/atom/movable/dropping = stored_ref.resolve()
				if(istype(dropping) && !QDELETED(dropping) && dropping.loc == src)
					dropping.dropInto(loc)
					dropping.throw_at(get_edge_target_turf(src,pick(GLOB.alldirs)),rand(1,3),30)
			stored_atoms = null

	. = ..()

/mob/living/silicon/robot/platform/proc/can_store_atom(var/atom/movable/storing, var/mob/user)

	if(!istype(storing))
		var/storing_target = (user == src) ? "yourself" : "\the [src]"
		to_chat(user, span_warning("You cannot store that inside [storing_target]."))
		return FALSE

	if(!isturf(storing.loc))
		return FALSE

	if(storing.anchored || !storing.simulated)
		to_chat(user, span_warning("\The [storing] won't budge!"))
		return FALSE

	if(storing == src)
		var/storing_target = (user == src) ? "yourself" : "\the [src]"
		to_chat(user, span_warning("You cannot store [storing_target] inside [storing_target]!"))
		return FALSE

	if(length(stored_atoms) >= max_stored_atoms)
		var/storing_target = (user == src) ? "Your" : "\The [src]'s"
		to_chat(user, span_warning("[storing_target] cargo compartment is full."))
		return FALSE

	if(ismob(storing))
		var/mob/M = storing
		if(M.mob_size >= mob_size)
			var/storing_target = (user == src) ? "your storage compartment" : "\the [src]"
			to_chat(user, span_warning("\The [storing] is too big for [storing_target]."))
			return FALSE

	for(var/store_type in can_store_types)
		if(istype(storing, store_type))
			. = TRUE
			break

	if(.)
		for(var/store_type in cannot_store_types)
			if(istype(storing, store_type))
				. = FALSE
				break
	if(!.)
		var/storing_target = (user == src) ? "yourself" : "\the [src]"
		to_chat(user, span_warning("You cannot store \the [storing] inside [storing_target]."))

/mob/living/silicon/robot/platform/proc/store_atom(var/atom/movable/storing, var/mob/user)
	if(istype(storing))
		storing.forceMove(src)
		LAZYDISTINCTADD(stored_atoms, WEAKREF(storing))

/mob/living/silicon/robot/platform/proc/drop_stored_atom(var/atom/movable/ejecting, var/mob/user)

	if(!ejecting && length(stored_atoms))
		var/datum/weakref/stored_ref = stored_atoms[1]
		if(!istype(stored_ref))
			LAZYREMOVE(stored_atoms, stored_ref)
		else
			ejecting = stored_ref?.resolve()

	LAZYREMOVE(stored_atoms, WEAKREF(ejecting))
	if(istype(ejecting) && !QDELETED(ejecting) && ejecting.loc == src)
		ejecting.dropInto(loc)
		if(user == src)
			visible_message("<b>\The [src]</b> ejects \the [ejecting] from its cargo compartment.")
		else
			user.visible_message("<b>\The [user]</b> pulls \the [ejecting] from \the [src]'s cargo compartment.")

/mob/living/silicon/robot/platform/attack_ai(mob/user)
	if(isrobot(user) && user.Adjacent(src))
		return try_remove_cargo(user)
	return ..()

/mob/living/silicon/robot/platform/proc/try_remove_cargo(var/mob/user)
	if(!length(stored_atoms) || !istype(user))
		return FALSE
	var/datum/weakref/remove_ref = stored_atoms[length(stored_atoms)]
	var/atom/movable/removing = remove_ref?.resolve()
	if(!istype(removing) || QDELETED(removing) || removing.loc != src)
		LAZYREMOVE(stored_atoms, remove_ref)
	else
		user.visible_message("<b>\The [user]</b> begins unloading \the [removing] from \the [src]'s cargo compartment.")
		if(do_after(user, 3 SECONDS, src) && !QDELETED(removing) && removing.loc == src)
			drop_stored_atom(removing, user)
	return TRUE

/mob/living/silicon/robot/platform/verb/drop_stored_atom_verb()
	set name = "Eject Cargo"
	set category = "Robot Commands"
	set desc = "Drop something from your internal storage."

	if(incapacitated())
		to_chat(src, span_warning("You are not in any state to do that."))
		return

	if(length(stored_atoms))
		drop_stored_atom(user = src)
	else
		to_chat(src, span_warning("You have nothing in your cargo compartment."))

/mob/living/silicon/robot/platform/MouseDrop_T(atom/movable/dropping, mob/living/user)
	if(!istype(user) || !istype(dropping) || user.incapacitated())
		return FALSE
	if(!can_mouse_drop(dropping, user) || !can_store_atom(dropping, user))
		return FALSE
	if(user == src)
		visible_message("<b>\The [src]</b> begins loading \the [dropping] into its cargo compartment.")
	else
		user.visible_message("<b>\The [user]</b> begins loading \the [dropping] into \the [src]'s cargo compartment.")
	if(do_after(user, 3 SECONDS, src) && can_mouse_drop(dropping, user) && can_store_atom(dropping, user))
		store_atom(dropping, user)
	return FALSE

/mob/living/silicon/robot/platform/proc/can_mouse_drop(var/atom/dropping, var/mob/user)
	if(!istype(user) || !istype(dropping) || QDELETED(dropping) || QDELETED(user) || QDELETED(src))
		return FALSE
	if(user.incapacitated() || !Adjacent(user) || !dropping.Adjacent(user))
		return FALSE
	return TRUE
