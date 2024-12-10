
/**********************Ore box**************************/
/obj/structure/ore_box
	icon = 'icons/obj/mining.dmi'
	icon_state = "orebox0"
	name = "ore box"
	desc = "A heavy box used for storing ore."
	density = TRUE
	var/last_update = 0
	var/list/stored_ore = list(
		ORE_SAND = 0,
		ORE_HEMATITE = 0,
		ORE_CARBON = 0,
		ORE_COPPER = 0,
		ORE_TIN = 0,
		ORE_VOPAL = 0,
		ORE_PAINITE = 0,
		ORE_QUARTZ = 0,
		ORE_BAUXITE = 0,
		ORE_PHORON = 0,
		ORE_SILVER = 0,
		ORE_GOLD = 0,
		ORE_MARBLE = 0,
		ORE_URANIUM = 0,
		ORE_DIAMOND = 0,
		ORE_PLATINUM = 0,
		ORE_LEAD = 0,
		ORE_MHYDROGEN = 0,
		ORE_VERDANTIUM = 0,
		ORE_RUTILE = 0)


/obj/structure/ore_box/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/ore))
		var/obj/item/ore/ore = W
		stored_ore[ore.material]++
		user.remove_from_mob(W)
		qdel(ore)

	else if (istype(W, /obj/item/storage/bag/ore))
		var/obj/item/storage/bag/ore/S = W
		S.hide_from(user)
		for(var/ore in S.stored_ore)
			if(S.stored_ore[ore] > 0)
				var/ore_amount = S.stored_ore[ore]	// How many ores does the satchel have?
				stored_ore[ore] += ore_amount 		// Add the ore to the machine.
				S.stored_ore[ore] = 0 				// Set the value of the ore in the satchel to 0.
				S.current_capacity = 0				// Set the amount of ore in the satchel  to 0.
		to_chat(user, span_notice("You empty the satchel into the box."))

	return

/*
/obj/structure/ore_box/proc/update_ore_count() //OLD way of storing ore. Comment this out once done.

	stored_ore = list()

	for(var/obj/item/ore/O in contents)

		if(stored_ore[O.name])
			stored_ore[O.name]++
		else
			stored_ore[O.name] = 1
*/
/obj/structure/ore_box/examine(mob/user)
	. = ..()

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
//		to_chat(usr, span_warning("You are physically incapable of emptying the ore box."))
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
//		to_chat(usr, span_warning("The ore box is empty."))
//		return
//
//	for (var/obj/item/ore/O in contents)
//		contents -= O
//		O.loc = src.loc
//	to_chat(usr, span_notice("You empty the ore box."))
//
//	return

/obj/structure/ore_box/ex_act(severity)
	if(severity == 1.0 || (severity == 2.0 && prob(50)))
		qdel(src)
		return
