
/**********************Ore box**************************/
/obj/structure/ore_box
	icon = 'icons/obj/mining.dmi'
	icon_state = "orebox0"
	name = "ore box"
	desc = "A heavy box used for storing ore."
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

	var/list/contained_resources = list() //A list of the ore inside. This is done to reduce lag.


/obj/structure/ore_box/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/ore))
		var/obj/item/weapon/ore/ore = W
		stored_ore[ore.material]++
		qdel(ore)

	else if (istype(W, /obj/item/weapon/storage/bag/ore))
		var/obj/item/weapon/storage/bag/ore/S = W
		S.hide_from(user)
		for(var/ore in S.stored_ore)
			if(S.stored_ore[ore] > 0)
				var/ore_amount = S.stored_ore[ore]	// How many ores does the satchel have?
				stored_ore[ore] += ore_amount 		// Add the ore to the machine.
				S.stored_ore[ore] = 0 				// Set the value of the ore in the satchel to 0.
		to_chat(user, "<span class='notice'>You empty the satchel into the box.</span>")

	return

/*
/obj/structure/ore_box/proc/update_ore_count() //OLD way of storing ore. Comment this out once done.

	stored_ore = list()

	for(var/obj/item/weapon/ore/O in contents)

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
