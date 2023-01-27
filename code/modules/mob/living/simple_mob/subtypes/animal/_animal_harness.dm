/obj/item/storage/internal/animal_harness
	abstract_type = /obj/item/storage/internal/animal_harness
	name = "animal harness"
	color = COLOR_BEASTY_BROWN
	max_w_class = ITEMSIZE_LARGE
	max_storage_space = INVENTORY_STANDARD_SPACE

	/// Null, or a list of (/obj/item/foo = "item key"), or (/path = ("item key", proc/handler)).
	var/list/attachable_types

	/// Null, or a list of ("item key" = null|Instance)
	var/list/attached_items

	/// The time it takes for the wearer to adjust this harness' attachments.
	var/self_attach_delay = 5 SECONDS

	/// The time it takes for someone else to adjust this harness' attachments.
	var/other_attach_delay = 3 SECONDS


/obj/item/storage/internal/animal_harness/Destroy()
	var/mob/living/simple_mob/animal/wearer = loc
	if (istype(wearer) && wearer.harness == src)
		wearer.harness = null
	for (var/key in attached_items)
		var/obj/item/item = attached_items[key]
		qdel(item)
	LAZYCLEARLIST(attached_items)
	attachable_types = null
	return ..()


/obj/item/storage/internal/animal_harness/Initialize()
	. = ..()
	if (!attachable_types)
		return
	attached_items = list()
	for (var/path in attachable_types)
		var/key = attachable_types[path]
		attached_items[key] = null
	CreateAttachments()


/obj/item/storage/internal/animal_harness/LateInitializeName()
	return


/obj/item/storage/internal/animal_harness/attackby(obj/item/item, mob/living/user, silent)
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


/obj/item/storage/internal/animal_harness/proc/GetAttachedKeys()
	var/list/obj/item/result = list()
	for (var/key in attached_items)
		if (attached_items[key])
			result += key
	return result


/obj/item/storage/internal/animal_harness/proc/GetAttachedItems()
	var/list/obj/item/result = list()
	for (var/key in attached_items)
		var/obj/item/item = attached_items[key]
		if (item)
			result += item
	return result


/obj/item/storage/internal/animal_harness/proc/RemoveAttachment(obj/item/attachment)
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


/obj/item/storage/internal/animal_harness/proc/CreateAttachments()
	return


/mob/living/simple_mob/animal
	var/obj/item/storage/internal/animal_harness/harness


/mob/living/simple_mob/animal/Destroy()
	if (istype(harness))
		QDEL_NULL(harness)
	return ..()


/mob/living/simple_mob/animal/Initialize()
	. = ..()
	if (ispath(harness))
		harness = new harness (src)
		verbs += /mob/living/simple_mob/animal/proc/RemoveAttachmentVerb


/mob/living/simple_mob/animal/examine(mob/living/user)
	. = ..()
	if (harness)
		. += "\The [src] is wearing \a [harness]."
		for (var/obj/item/item in harness.GetAttachedItems())
			. += "There is \a [item] attached."

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
