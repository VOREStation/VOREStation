
/obj/structure/ore_box
	name = "ore box"
	desc = "A heavy box used for storing ore."
<<<<<<< HEAD
	density = TRUE
	var/last_update = 0
	var/list/stored_ore = list(
		"sand" = 0,
		"hematite" = 0,
		"carbon" = 0,
		"raw copper" = 0,
		"raw tin" = 0,
		"void opal" = 0,
		"painite" = 0,
		"quartz" = 0,
		"raw bauxite" = 0,
		"phoron" = 0,
		"silver" = 0,
		"gold" = 0,
		"marble" = 0,
		"uranium" = 0,
		"diamond" = 0,
		"platinum" = 0,
		"lead" = 0,
		"mhydrogen" = 0,
		"verdantium" = 0,
		"rutile" = 0)


/obj/structure/ore_box/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/ore))
		var/obj/item/weapon/ore/ore = W
		stored_ore[ore.material]++
		user.remove_from_mob(W)
		qdel(ore)

	else if (istype(W, /obj/item/weapon/storage/bag/ore))
		var/obj/item/weapon/storage/bag/ore/S = W
		S.hide_from(user)
		for(var/ore in S.stored_ore)
			if(S.stored_ore[ore] > 0)
				var/ore_amount = S.stored_ore[ore]	// How many ores does the satchel have?
				stored_ore[ore] += ore_amount 		// Add the ore to the machine.
				S.stored_ore[ore] = 0 				// Set the value of the ore in the satchel to 0.
				S.current_capacity = 0				// Set the amount of ore in the satchel  to 0.
		to_chat(user, "<span class='notice'>You empty the satchel into the box.</span>")

	return

/*
/obj/structure/ore_box/proc/update_ore_count() //OLD way of storing ore. Comment this out once done.
=======
	icon = 'icons/obj/mining.dmi'
	icon_state = "orebox0"
	density = TRUE
>>>>>>> 6ae04e1d641... Merge pull request #8840 from Spookerton/spkrtn/cng/rock-and-stone

	/// Rebuild stored_ore if true. Becomes true when contents changes.
	var/stored_ore_dirty

<<<<<<< HEAD
	for(var/obj/item/weapon/ore/O in contents)

		if(stored_ore[O.name])
			stored_ore[O.name]++
		else
			stored_ore[O.name] = 1
*/
=======
	/// The current ore contents of the bag formatted by english_list.
	var/stored_ore


>>>>>>> 6ae04e1d641... Merge pull request #8840 from Spookerton/spkrtn/cng/rock-and-stone
/obj/structure/ore_box/examine(mob/user)
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
			stored_ore = "It contains [english_list(chunks)]"
	. += SPAN_ITALIC(stored_ore || "It is empty.")


/obj/structure/ore_box/attackby(obj/item/item, mob/living/user)
	if (istype(item, /obj/item/ore))
		user.remove_from_mob(item, src)
		stored_ore_dirty = TRUE
		return TRUE
	var/obj/item/storage/storage = item
	if (istype(storage))
		. = TRUE
		var/length = length(storage.contents)
		if (!length)
			to_chat(user, SPAN_WARNING("\The [storage] is empty."))
			return
		var/gathered
		var/obj/item/storage/bag/ore/bag = item
		if (istype(bag))
			bag.stored_ore_dirty = TRUE
			contents += bag.contents
			gathered = TRUE
		else
			for (var/obj/item/ore/ore in storage)
				storage.remove_from_storage(ore, src)
				++gathered
		if (gathered)
			to_chat(user, SPAN_ITALIC("You empty \the [storage] into \the [src]."))
			stored_ore_dirty = TRUE
		else
			to_chat(user, SPAN_WARNING("\The [storage] contained no ore."))

<<<<<<< HEAD
	if(!Adjacent(user)) //Can only check the contents of ore boxes if you can physically reach them.
		return .

	add_fingerprint(user)

	. += "It holds:"
	var/has_ore = 0
	for(var/ore in stored_ore)
		if(stored_ore[ore] > 0)
			. += "- [stored_ore[ore]] [ore]"
			has_ore = 1
	if(!has_ore)
		. += "Nothing."

// /obj/structure/ore_box/verb/empty_box() //Servercrash.mov
//	set name = "Empty Ore Box"
//	set category = "Object"
//	set src in view(1)
//
//	if(!ishuman(usr) && !isrobot(usr)) //Only living, intelligent creatures with gripping aparatti can empty ore boxes.
//		to_chat(usr, "<span class='warning'>You are physically incapable of emptying the ore box.</span>")
//		return
//	if(usr.stat || usr.restrained())
//		return
//
//	if(!Adjacent(usr)) //You can only empty the box if you can physically reach it
//		to_chat(usr, "You cannot reach the ore box.")
//		return
//
//	add_fingerprint(usr)
//
//	if(contents.len < 1)
//		to_chat(usr, "<span class='warning'>The ore box is empty.</span>")
//		return
//
//	for (var/obj/item/weapon/ore/O in contents)
//		contents -= O
//		O.loc = src.loc
//	to_chat(usr, "<span class='notice'>You empty the ore box.</span>")
//
//	return

/obj/structure/ore_box/ex_act(severity)
	if(severity == 1.0 || (severity == 2.0 && prob(50)))
		qdel(src)
		return
=======

/obj/structure/ore_box/ex_act(severity)
	var/turf/turf = get_turf(src)
	switch (severity)
		if (1)
			if (turf == loc)
				turf.contents += contents
			qdel(src)
		if (2)
			if (prob(50))
				return
			if (turf == loc)
				turf.contents += contents
			qdel(src)


/obj/structure/ore_box/verb/empty_box()
	set name = "Empty Ore Box"
	set category = "Object"
	set src in view(1)
	var/mob/living/user = usr
	if (!(ishuman(user) || isrobot(user)))
		to_chat(user, SPAN_WARNING("You're not dextrous enough to do that."))
		return
	if (!Adjacent(user))
		return
	if (user.stat || user.restrained())
		to_chat(user, SPAN_WARNING("You're in no condition to do that."))
		return
	add_fingerprint(user)
	if (!length(contents))
		to_chat(user, SPAN_WARNING("\The [src] is empty."))
		return
	user.visible_message(
		SPAN_ITALIC("\The [user] empties \a [src]."),
		SPAN_ITALIC("You empty \the [src]."),
		range = 5
	)
	loc.contents += contents
>>>>>>> 6ae04e1d641... Merge pull request #8840 from Spookerton/spkrtn/cng/rock-and-stone
