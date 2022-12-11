/obj/item/storage/bag/ore
	name = "mining satchel"
	desc = "A handy-dandy container for your rock collection. Gneiss."
	icon = 'icons/obj/mining.dmi'
	icon_state = "satchel"
	slot_flags = SLOT_BELT | SLOT_POCKET
	w_class = ITEMSIZE_NORMAL
	max_storage_space = ITEMSIZE_COST_NORMAL * 25
	max_w_class = ITEMSIZE_NORMAL
	can_hold = list(/obj/item/ore)

	/// Rebuild stored_ore if true. Becomes true when contents changes.
	var/stored_ore_dirty

	/// The current ore contents of the bag formatted by english_list.
	var/stored_ore


/obj/item/storage/bag/ore/examine(mob/user)
	. = ..()
	if (!Adjacent(user) && !isobserver(user))
		return
	if (isliving(user))
		add_fingerprint(user)
	if (stored_ore_dirty)
		stored_ore_dirty = FALSE
		stored_ore = null
		var/list/ores = list()
		for (var/obj/item/ore/ore in contents)
			++ores[ore.name]
		var/list/chunks = list()
		for (var/name in ores)
			chunks += "[ores[name]] [name]"
		if (length(chunks))
			var/full = length(contents) >= max_storage_space
			stored_ore = "[full ? "It is <b>full</b>! " : ""]It contains [english_list(chunks)]"
	. += SPAN_ITALIC(stored_ore || "It is empty.")


/obj/item/storage/bag/ore/equipped(mob/living/user, into_slot)
	..()
	switch (into_slot)
		if (slot_wear_suit, slot_l_hand, slot_r_hand, slot_belt)
			GLOB.moved_event.register(user, src, /obj/item/storage/bag/ore/proc/autoload, user)


/obj/item/storage/bag/ore/dropped(mob/living/user)
	..()
	switch (user.get_inventory_slot(src))
		if (slot_wear_suit, slot_l_hand, slot_r_hand, slot_belt)
			. = . //noop
		else
			GLOB.moved_event.unregister(user, src)


/obj/item/storage/bag/ore/remove_from_storage(obj/item/item, atom/into)
	if (!istype(item))
		return FALSE
	if (isloc(into))
		if (ismob(loc))
			item.dropped(usr)
		if (ismob(into))
			item.hud_layerise()
		else
			item.reset_plane_and_layer()
	else
		item.forceMove(get_turf(src))
	item.on_exit_storage(src)
	stored_ore_dirty = TRUE
	update_icon()
	return TRUE


/obj/item/storage/bag/ore/gather_all(turf/from, mob/living/user, silent, autoload)
	var/obj/structure/ore_box/box = user.pulling
	if (istype(box))
		var/gathered = length(contents)
		if (gathered)
			box.contents += contents
			stored_ore_dirty = TRUE
		for (var/obj/item/ore/ore in from)
			box.contents += ore
			++gathered
		if (gathered)
			box.stored_ore_dirty = TRUE
			if (!silent)
				to_chat(user, SPAN_ITALIC("You collect all the ore into \the [box]."))
		return
	if (length(contents) >= max_storage_space)
		if (!autoload && !silent)
			to_chat(user, SPAN_WARNING("\The [src] is full."))
		return
	var/gathered = 0
	var/available_space = max_storage_space - length(contents)
	for (var/obj/item/ore/ore in from)
		contents += ore
		if (--available_space < 1)
			if (!silent)
				to_chat(user, SPAN_ITALIC("You completely fill \the [src] with ore."))
			return
		++gathered
	if (gathered)
		stored_ore_dirty = TRUE
		if (!silent)
			to_chat(user, SPAN_ITALIC("You collect all the ore with \the [src]."))
	else if (!autoload && !silent)
		to_chat(user, SPAN_WARNING("There's no ore there to collect."))


/obj/item/storage/bag/ore/open(mob/living/user)
	user.examinate(src)


/obj/item/storage/bag/ore/proc/autoload(mob/living/user)
	gather_all(get_turf(src), user, FALSE, TRUE)
