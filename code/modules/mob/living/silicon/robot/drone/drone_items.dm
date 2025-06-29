//TODO: Matter decompiler.
/obj/item/matter_decompiler

	name = "matter decompiler"
	desc = "Eating trash, bits of glass, or other debris will replenish your stores."
	icon = 'icons/obj/device.dmi'
	icon_state = "decompiler"

	//Metal, glass, wood, plastic.
	var/datum/matter_synth/metal = null
	var/datum/matter_synth/glass = null
	var/datum/matter_synth/wood = null
	var/datum/matter_synth/plastic = null

/obj/item/matter_decompiler/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	return

/obj/item/matter_decompiler/afterattack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, proximity, params)

	if(!proximity) return //Not adjacent.

	//We only want to deal with using this on turfs. Specific items aren't important.
	var/turf/T = get_turf(target)
	if(!istype(T))
		return

	//Used to give the right message.
	var/grabbed_something = 0

	for(var/mob/M in T)
		if(istype(M,/mob/living/simple_mob/animal/passive/lizard) || istype(M,/mob/living/simple_mob/animal/passive/mouse))
			src.loc.visible_message(span_danger("[src.loc] sucks [M] into its decompiler. There's a horrible crunching noise."),span_danger("It's a bit of a struggle, but you manage to suck [M] into your decompiler. It makes a series of visceral crunching noises."))
			new/obj/effect/decal/cleanable/blood/splatter(get_turf(src))
			qdel(M)
			if(wood)
				wood.add_charge(2000)
			if(plastic)
				plastic.add_charge(2000)
			return

		else if(istype(M,/mob/living/silicon/robot/drone) && !M.client)

			var/mob/living/silicon/robot/D = src.loc

			if(!istype(D))
				return

			to_chat(D, span_danger("You begin decompiling [M]."))

			if(!do_after(D,50))
				to_chat(D, span_danger("You need to remain still while decompiling such a large object."))
				return

			if(!M || !D) return

			to_chat(D, span_danger("You carefully and thoroughly decompile [M], storing as much of its resources as you can within yourself."))
			qdel(M)
			new/obj/effect/decal/cleanable/blood/oil(get_turf(src))

			if(metal)
				metal.add_charge(15000)
			if(glass)
				glass.add_charge(15000)
			if(wood)
				wood.add_charge(2000)
			if(plastic)
				plastic.add_charge(1000)
			return
		else
			continue

	for(var/obj/W in T)
		//Different classes of items give different commodities.
		if(istype(W,/obj/item/trash/cigbutt))
			if(plastic)
				plastic.add_charge(500)
		else if(istype(W,/obj/effect/spider/spiderling))
			if(wood)
				wood.add_charge(2000)
			if(plastic)
				plastic.add_charge(2000)
		else if(istype(W,/obj/item/light))
			var/obj/item/light/L = W
			if(L.status >= 2) //In before someone changes the inexplicably local defines. ~ Z
				if(metal)
					metal.add_charge(250)
				if(glass)
					glass.add_charge(250)
			else
				continue
		else if(istype(W,/obj/effect/decal/remains/robot))
			if(metal)
				metal.add_charge(2000)
			if(plastic)
				plastic.add_charge(2000)
			if(glass)
				glass.add_charge(1000)
		else if(istype(W,/obj/item/trash))
			if(metal)
				metal.add_charge(1000)
			if(plastic)
				plastic.add_charge(3000)
		else if(istype(W,/obj/effect/decal/cleanable/blood/gibs/robot))
			if(metal)
				metal.add_charge(2000)
			if(glass)
				glass.add_charge(2000)
		else if(istype(W,/obj/item/ammo_casing))
			if(metal)
				metal.add_charge(1000)
		else if(istype(W,/obj/item/material/shard/shrapnel))
			if(metal)
				metal.add_charge(1000)
		else if(istype(W,/obj/item/material/shard))
			if(glass)
				glass.add_charge(1000)
		else if(istype(W,/obj/item/reagent_containers/food/snacks/grown))
			if(wood)
				wood.add_charge(4000)
		else if(istype(W,/obj/item/pipe))
			pass() // This allows drones and engiborgs to clear pipe assemblies from floors.
		else
			continue

		qdel(W)
		grabbed_something = 1

	if(grabbed_something)
		to_chat(user, span_notice("You deploy your decompiler and clear out the contents of \the [T]."))
	else
		to_chat(user, span_danger("Nothing on \the [T] is useful to you."))
	return

//PRETTIER TOOL LIST.
// /mob/living/silicon/robot/drone/installed_modules()

// 	if(weapon_lock)
// 		to_chat(src, span_danger("Weapon lock active, unable to use modules! Count:[weaponlock_time]"))
// 		return

// 	if(!module)
// 		module = new /obj/item/robot_module/drone(src)

// 	var/dat = "<HEAD><TITLE>Drone modules</TITLE></HEAD><BODY>\n"
// 	dat += {"
// 	<B>Activated Modules</B>
// 	<BR>
// 	Module 1: [module_state_1 ? "<A HREF='byond://?src=\ref[src];mod=\ref[module_state_1]'>[module_state_1]<A>" : "No Module"]<BR>
// 	Module 2: [module_state_2 ? "<A HREF='byond://?src=\ref[src];mod=\ref[module_state_2]'>[module_state_2]<A>" : "No Module"]<BR>
// 	Module 3: [module_state_3 ? "<A HREF='byond://?src=\ref[src];mod=\ref[module_state_3]'>[module_state_3]<A>" : "No Module"]<BR>
// 	<BR>
// 	<B>Installed Modules</B><BR><BR>"}


// 	var/tools = span_bold("Tools and devices") + "<BR>"
// 	var/resources = "<BR>" + span_bold("Resources") + "<BR>"

// 	for (var/O in module.modules)

// 		var/module_string = ""

// 		if (!O)
// 			module_string += span_bold("Resource depleted") + "<BR>"
// 		else if(activated(O))
// 			module_string += text("[O]: <B>Activated</B><BR>")
// 		else
// 			module_string += text("[O]: <A HREF='byond://?src=\ref[src];act=\ref[O]'>Activate</A><BR>")

// 		if((istype(O,/obj/item) || istype(O,/obj/item)) && !(istype(O,/obj/item/stack/cable_coil)))
// 			tools += module_string
// 		else
// 			resources += module_string

// 	if (emagged)
// 		for (var/O in module.emag)

// 			var/module_string = ""

// 			if (!O)
// 				module_string += span_bold("Resource depleted") + "<BR>"
// 			else if(activated(O))
// 				module_string += text("[O]: <B>Activated</B><BR>")
// 			else
// 				module_string += text("[O]: <A HREF='byond://?src=\ref[src];act=\ref[O]'>Activate</A><BR>")

// 			if((istype(O,/obj/item) || istype(O,/obj/item)) && !(istype(O,/obj/item/stack/cable_coil)))
// 				tools += module_string
// 			else
// 				resources += module_string

// 	dat += tools

// 	dat += resources

// 	src << browse("<html>[dat]</html>", "window=robotmod")
