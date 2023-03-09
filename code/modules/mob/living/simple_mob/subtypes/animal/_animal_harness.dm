/obj/item/storage/animal_harness
	abstract_type = /obj/item/storage/animal_harness
	name = "animal harness"
	color = COLOR_BEASTY_BROWN
	max_w_class = ITEMSIZE_LARGE
	max_storage_space = INVENTORY_STANDARD_SPACE
	icon_state = "harness"
	icon = 'icons/mob/drake_harness.dmi'
	preserve_item = TRUE

	// keys for animal_harness/attachable_type
	var/const/ATTACHED_GPS =   "gps"
	var/const/ATTACHED_RADIO = "radio"
	var/const/ATTACHED_ARMOR = "armor plate"
	var/const/ATTACHED_LIGHT = "light"
	var/const/ATTACHED_ID =    "access card"

	/// Contains valid types that the harness will attach to.
	var/list/harnessable_types

	/// Null, or a list of (/obj/item/foo = "item key"), or (/path = ("item key", proc/handler)).
	var/list/attachable_types

	/// Null, or a list of ("item key" = null|Instance)
	var/list/attached_items

	/// The time it takes for the wearer to adjust this harness' attachments.
	var/self_attach_delay = 5 SECONDS

	/// The time it takes for someone else to adjust this harness' attachments.
	var/other_attach_delay = 3 SECONDS


/obj/item/storage/animal_harness/Destroy()
	var/mob/living/simple_mob/animal/wearer = loc
	if (istype(wearer) && wearer.harness == src)
		wearer.clear_harness()
	for (var/key in attached_items)
		var/obj/item/item = attached_items[key]
		qdel(item)
	LAZYCLEARLIST(attached_items)
	attachable_types = null
	return ..()


/obj/item/storage/animal_harness/Initialize()
	. = ..()
	if (!attachable_types)
		return
	attached_items = list()
	for (var/path in attachable_types)
		var/key = attachable_types[path]
		attached_items[key] = null
	CreateAttachments()


/obj/item/storage/animal_harness/GetIdCard()
	return attached_items[ATTACHED_ID]


/obj/item/storage/animal_harness/LateInitializeName()
	return


/obj/item/storage/animal_harness/attackby(obj/item/item, mob/living/user, silent)
	. = TRUE
	if (user == loc) // Animals can only shove stuff in their storage.
		return ..()
	for (var/path in attachable_types)
		if (!istype(item, path))
			continue
		var/key = attachable_types[path]
		var/handler
		if (islist(key))
			handler = key[2]
			key = key[1]
		if (attached_items[key])
			if (!silent)
				var/datum/gender/gender
				if (ismob(loc))
					var/mob/living/simple_mob/animal/owner = loc
					gender = gender_datums[owner.get_visible_gender()]
				to_chat(user, SPAN_WARNING("\The [loc] already has \a [key] attached to [gender ? gender.his : "its"] harness."))
			return
		if (!user.unEquip(item, target = loc))
			return
		if (!silent)
			user.visible_message(SPAN_NOTICE("\The [user] attaches \the [item] to \the [loc]'s harness."))
		attached_items[key] = item
		if (handler)
			call(src, handler)(item)
		return
	return ..()


/obj/item/storage/animal_harness/proc/GetAttachedKeys()
	var/list/obj/item/result = list()
	for (var/key in attached_items)
		if (attached_items[key])
			result += key
	return result


/obj/item/storage/animal_harness/proc/GetAttachedItems()
	var/list/obj/item/result = list()
	for (var/key in attached_items)
		var/obj/item/item = attached_items[key]
		if (item)
			result += item
	return result


/obj/item/storage/animal_harness/proc/RemoveAttachment(obj/item/attachment)
	if (istext(attachment))
		var/obj/item/item = attached_items[attachment]
		if (!item)
			return
		item.dropInto(get_turf(src))
		attached_items[attachment] = null
		return item
	for (var/key in attached_items)
		if (attached_items[key] == attachment)
			attachment.dropInto(get_turf(src))
			attached_items[key] = null
			return attachment


/obj/item/storage/animal_harness/proc/CreateAttachments()
	return


/mob/living/simple_mob/animal
	var/obj/item/storage/animal_harness/harness


/mob/living/simple_mob/animal/attackby(obj/item/O, mob/user)
	if(istype(O, /obj/item/storage/animal_harness))
		if(harness)
			to_chat(user, SPAN_WARNING("\The [src] is already wearing \the [harness]."))
			return TRUE
		var/obj/item/storage/animal_harness/new_harness = O
		if(!is_type_in_list(src, new_harness.harnessable_types))
			to_chat(user, SPAN_WARNING("\The [new_harness] does not fit on \the [src]."))
			return TRUE
		if(user.unEquip(new_harness, src))
			set_harness(new_harness)
			user.visible_message(SPAN_NOTICE("\The [user] slips \the [harness] over \the [src] and buckles it securely."))
			update_icon()
			return TRUE
	return ..()


/mob/living/simple_mob/animal/Destroy()
	if (istype(harness))
		QDEL_NULL(harness)
	return ..()


/mob/living/simple_mob/animal/Initialize()
	. = ..()
	if(harness)
		if(ispath(harness))
			set_harness(new harness(src))
		else if(!istype(harness))
			clear_harness()

/mob/living/simple_mob/animal/proc/clear_harness()
	if(!harness)
		return FALSE
	if(istype(harness))
		var/turf/drop_loc = get_turf(src)
		for (var/key in harness.attached_items)
			var/obj/item/item = harness.attached_items[key]
			if(item)
				harness.RemoveAttachment(item)
				item.dropInto(drop_loc)
		harness.dropInto(drop_loc)
	harness = null
	verbs -= /mob/living/simple_mob/animal/proc/RemoveAttachmentVerb
	verbs -= /mob/living/simple_mob/animal/proc/RemoveHarnessVerb
	update_icon()
	return TRUE

/mob/living/simple_mob/animal/proc/set_harness(var/obj/item/storage/animal_harness/new_harness)
	if(!istype(new_harness) || new_harness == harness)
		return FALSE
	if(istype(harness))
		QDEL_NULL(harness)
	harness = new_harness
	if(istype(harness))
		harness.forceMove(src)
		verbs |= /mob/living/simple_mob/animal/proc/RemoveAttachmentVerb
		verbs |= /mob/living/simple_mob/animal/proc/RemoveHarnessVerb
	else
		verbs -= /mob/living/simple_mob/animal/proc/RemoveAttachmentVerb
		verbs -= /mob/living/simple_mob/animal/proc/RemoveHarnessVerb
	update_icon()
	return TRUE

/mob/living/simple_mob/animal/examine(mob/living/user)
	. = ..()
	if (harness)
		. += "\The [src] is wearing \a [harness]."
		for (var/obj/item/item in harness.GetAttachedItems())
			. += "There is \a [item] attached."

/mob/living/simple_mob/animal/proc/RemoveHarnessVerb()
	set name = "Remove Harness"
	set category = "IC"
	set src in view(1)

	var/mob/living/user = usr
	if (!istype(user))
		return
	if (!Adjacent(user) || user.incapacitated())
		to_chat(user, SPAN_WARNING("You are in no condition to do that."))
		return
	if (!user.check_dexterity(MOB_DEXTERITY_SIMPLE_MACHINES))
		return
	if(user == src)
		to_chat(usr, SPAN_WARNING("You cannot remove your own harness!"))
		return

	var/removing_harness = harness
	user.visible_message(SPAN_NOTICE("\The [user] begins unbuckling \the [harness] from \the [src]."))
	if(!do_after(user, 3 SECONDS, src) || removing_harness != harness || !Adjacent(user) || user.incapacitated())
		return
	user.visible_message(SPAN_NOTICE("\The [user] unbuckles and removes \the [harness] from \the [src]."))
	harness.forceMove(get_turf(src))
	clear_harness()

/mob/living/simple_mob/animal/proc/RemoveAttachmentVerb()
	set name = "Remove Harness Attachment"
	set category = "IC"
	set src in view(1)
	var/mob/living/user = usr
	if (!istype(user))
		return
	if (!Adjacent(user) || user.incapacitated())
		to_chat(user, SPAN_WARNING("You are in no condition to do that."))
		return
	if (!user.check_dexterity(MOB_DEXTERITY_SIMPLE_MACHINES))
		return
	var/list/attached = harness.GetAttachedKeys()
	var/datum/gender/gender = gender_datums[get_visible_gender()]
	if (!length(attached))
		to_chat(user, SPAN_WARNING("\The [src] has nothing attached to [gender.his] [harness.name]."))
		return
	var/obj/item/response = input(user, "Select attachment to remove:") as null | anything in attached
	if (!response)
		return
	if (!(response in harness.GetAttachedKeys()))
		to_chat(user, SPAN_WARNING("\The [response] is already missing from \the [harness]."))
		return
	if (!Adjacent(user) || user.incapacitated())
		to_chat(user, SPAN_WARNING("You are in no condition to do that."))
		return
	user.visible_message(
		SPAN_ITALIC("\The [user] begins to remove \a [response] from [(user == src) ? "[gender.his]" : "\the [src]'s"] harness."),
		SPAN_ITALIC("You begin to remove \the [response] from [(user == src) ? "your" : "\the [src]'s"] harness."),
		range = 5
	)
	if (!do_after(user, (user == src) ? harness.self_attach_delay : harness.other_attach_delay, loc))
		return
	if (QDELETED(harness))
		return
	if (!(response in harness.GetAttachedKeys()))
		to_chat(user, SPAN_WARNING("\The [response] is already missing from \the [src]."))
		return
	var/obj/item/removed = harness.RemoveAttachment(response)
	user.put_in_hands(removed)

// The below logic is adapted from /obj/item/storage/internal.
/obj/item/storage/animal_harness/attack_hand(mob/user)
	if(isanimal(loc))
		var/mob/living/simple_mob/animal/critter = loc
		if(critter.harness == src)
			if(loc == user)
				add_fingerprint(user)
				open(user)
				return FALSE
			if(user.Adjacent(loc))
				add_fingerprint(user)
				open(user)
				return FALSE
			for(var/mob/M in range(1, get_turf(loc)))
				if (M.s_active == src)
					src.close(M)
			return TRUE
	return ..()

/obj/item/storage/animal_harness/Adjacent(var/atom/neighbor)
	if(isanimal(loc))
		var/mob/living/simple_mob/animal/critter = loc
		if(critter.harness == src)
			return critter.Adjacent(neighbor)
	return ..()
