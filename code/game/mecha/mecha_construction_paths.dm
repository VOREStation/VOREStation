////////////////////////////////
///// Construction datums //////
////////////////////////////////

/datum/construction/mecha/custom_action(step, obj/item/I, mob/user)
	if(I.has_tool_quality(TOOL_WELDER))
		var/obj/item/weapon/weldingtool/W = I.get_welder()
		if(W.remove_fuel(0, user))
			playsound(holder, 'sound/items/Welder2.ogg', 50, 1)
		else
			return 0
	else if(I.has_tool_quality(TOOL_WRENCH))
		playsound(holder, 'sound/items/Ratchet.ogg', 50, 1)

	else if(I.has_tool_quality(TOOL_SCREWDRIVER))
		playsound(holder, 'sound/items/Screwdriver.ogg', 50, 1)

	else if(I.has_tool_quality(TOOL_WIRECUTTER))
		playsound(holder, 'sound/items/Wirecutter.ogg', 50, 1)

	else if(istype(I, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/C = I
		if(C.use(4))
			playsound(holder, 'sound/items/Deconstruct.ogg', 50, 1)
		else
			to_chat(user, "There's not enough cable to finish the task.")
			return 0
	else if(istype(I, /obj/item/stack))
		var/obj/item/stack/S = I
		if(S.get_amount() < 5)
			to_chat(user, "There's not enough material in this stack.")
			return 0
		else
			S.use(5)
	return 1

/datum/construction/reversible/mecha/custom_action(index as num, diff as num, obj/item/I, mob/user as mob)
	if(I.has_tool_quality(TOOL_WELDER))
		var/obj/item/weapon/weldingtool/W = I.get_welder()
		if(W.remove_fuel(0, user))
			playsound(holder, 'sound/items/Welder2.ogg', 50, 1)
		else
			return 0
	else if(I.has_tool_quality(TOOL_WRENCH))
		playsound(holder, 'sound/items/Ratchet.ogg', 50, 1)

	else if(I.has_tool_quality(TOOL_SCREWDRIVER))
		playsound(holder, 'sound/items/Screwdriver.ogg', 50, 1)

	else if(I.has_tool_quality(TOOL_WIRECUTTER))
		playsound(holder, 'sound/items/Wirecutter.ogg', 50, 1)

	else if(istype(I, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/C = I
		if(C.use(4))
			playsound(holder, 'sound/items/Deconstruct.ogg', 50, 1)
		else
			to_chat(user, "There's not enough cable to finish the task.")
			return 0
	else if(istype(I, /obj/item/stack))
		var/obj/item/stack/S = I
		if(S.get_amount() < 5)
			to_chat(user, "There's not enough material in this stack.")
			return 0
		else
			S.use(5)
	return 1

//////////////////////
//		Ripley
//////////////////////
/datum/construction/mecha/ripley_chassis
	steps = list(list("key"=/obj/item/mecha_parts/part/ripley_torso),//1
					 list("key"=/obj/item/mecha_parts/part/ripley_left_arm),//2
					 list("key"=/obj/item/mecha_parts/part/ripley_right_arm),//3
					 list("key"=/obj/item/mecha_parts/part/ripley_left_leg),//4
					 list("key"=/obj/item/mecha_parts/part/ripley_right_leg)//5
					)

/datum/construction/mecha/ripley_chassis/custom_action(step, obj/item/I, mob/user)
	user.visible_message("[user] has connected [I] to [holder].", "You connect [I] to [holder]")
	holder.add_overlay(I.icon_state+"+o")
	qdel(I)
	return 1

/datum/construction/mecha/ripley_chassis/action(obj/item/I,mob/user as mob)
	return check_all_steps(I,user)

/datum/construction/mecha/ripley_chassis/spawn_result()
	var/obj/item/mecha_parts/chassis/const_holder = holder
	const_holder.construct = new /datum/construction/reversible/mecha/ripley(const_holder)
	const_holder.icon = 'icons/mecha/mech_construction.dmi'
	const_holder.icon_state = "ripley0"
	const_holder.density = TRUE
	const_holder.overlays.len = 0
	spawn()
		qdel(src)
	return


/datum/construction/reversible/mecha/ripley
	result = "/obj/mecha/working/ripley"
	steps = list(
					//1
					list("key"=IS_WELDER,
							"backkey"=IS_WRENCH,
							"desc"="External armor is wrenched."),
					//2
					 list("key"=IS_WRENCH,
					 		"backkey"=IS_CROWBAR,
					 		"desc"="External armor is installed."),
					 //3
					 list("key"=/obj/item/stack/material/plasteel,
					 		"backkey"=IS_WELDER,
					 		"desc"="Internal armor is welded."),
					 //4
					 list("key"=IS_WELDER,
					 		"backkey"=IS_WRENCH,
					 		"desc"="Internal armor is wrenched"),
					 //5
					 list("key"=IS_WRENCH,
					 		"backkey"=IS_CROWBAR,
					 		"desc"="Internal armor is installed"),
					 //6
					 list("key"=/obj/item/stack/material/steel,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="Peripherals control module is secured"),
					 //7
					 list("key"=IS_SCREWDRIVER,
					 		"backkey"=IS_CROWBAR,
					 		"desc"="Peripherals control module is installed"),
					 //8
					 list("key"=/obj/item/weapon/circuitboard/mecha/ripley/peripherals,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="Central control module is secured"),
					 //9
					 list("key"=IS_SCREWDRIVER,
					 		"backkey"=IS_CROWBAR,
					 		"desc"="Central control module is installed"),
					 //10
					 list("key"=/obj/item/weapon/circuitboard/mecha/ripley/main,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="The wiring is adjusted"),
					 //11
					 list("key"=IS_WIRECUTTER,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="The wiring is added"),
					 //12
					 list("key"=/obj/item/stack/cable_coil,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="The hydraulic systems are active."),
					 //13
					 list("key"=IS_SCREWDRIVER,
					 		"backkey"=IS_WRENCH,
					 		"desc"="The hydraulic systems are connected."),
					 //14
					 list("key"=IS_WRENCH,
					 		"desc"="The hydraulic systems are disconnected.")
					)

/datum/construction/reversible/mecha/ripley/action(obj/item/I,mob/user as mob)
	return check_step(I,user)

/datum/construction/reversible/mecha/ripley/custom_action(index, diff, obj/item/I, mob/user)
	if(!..())
		return 0

	//TODO: better messages.
	switch(index)
		if(14)
			user.visible_message("[user] connects [holder] hydraulic systems", "You connect [holder] hydraulic systems.")
			holder.icon_state = "ripley1"
		if(13)
			if(diff==FORWARD)
				user.visible_message("[user] activates [holder] hydraulic systems.", "You activate [holder] hydraulic systems.")
				holder.icon_state = "ripley2"
			else
				user.visible_message("[user] disconnects [holder] hydraulic systems", "You disconnect [holder] hydraulic systems.")
				holder.icon_state = "ripley0"
		if(12)
			if(diff==FORWARD)
				user.visible_message("[user] adds the wiring to [holder].", "You add the wiring to [holder].")
				holder.icon_state = "ripley3"
			else
				user.visible_message("[user] deactivates [holder] hydraulic systems.", "You deactivate [holder] hydraulic systems.")
				holder.icon_state = "ripley1"
		if(11)
			if(diff==FORWARD)
				user.visible_message("[user] adjusts the wiring of [holder].", "You adjust the wiring of [holder].")
				holder.icon_state = "ripley4"
			else
				user.visible_message("[user] removes the wiring from [holder].", "You remove the wiring from [holder].")
				new /obj/item/stack/cable_coil(get_turf(holder), 4)
				holder.icon_state = "ripley2"
		if(10)
			if(diff==FORWARD)
				user.visible_message("[user] installs the central control module into [holder].", "You install the central computer mainboard into [holder].")
				qdel(I)
				holder.icon_state = "ripley5"
			else
				user.visible_message("[user] disconnects the wiring of [holder].", "You disconnect the wiring of [holder].")
				holder.icon_state = "ripley3"
		if(9)
			if(diff==FORWARD)
				user.visible_message("[user] secures the mainboard.", "You secure the mainboard.")
				holder.icon_state = "ripley6"
			else
				user.visible_message("[user] removes the central control module from [holder].", "You remove the central computer mainboard from [holder].")
				new /obj/item/weapon/circuitboard/mecha/ripley/main(get_turf(holder))
				holder.icon_state = "ripley4"
		if(8)
			if(diff==FORWARD)
				user.visible_message("[user] installs the peripherals control module into [holder].", "You install the peripherals control module into [holder].")
				qdel(I)
				holder.icon_state = "ripley7"
			else
				user.visible_message("[user] unfastens the mainboard.", "You unfasten the mainboard.")
				holder.icon_state = "ripley5"
		if(7)
			if(diff==FORWARD)
				user.visible_message("[user] secures the peripherals control module.", "You secure the peripherals control module.")
				holder.icon_state = "ripley8"
			else
				user.visible_message("[user] removes the peripherals control module from [holder].", "You remove the peripherals control module from [holder].")
				new /obj/item/weapon/circuitboard/mecha/ripley/peripherals(get_turf(holder))
				holder.icon_state = "ripley6"
		if(6)
			if(diff==FORWARD)
				user.visible_message("[user] installs internal armor layer to [holder].", "You install internal armor layer to [holder].")
				holder.icon_state = "ripley9"
			else
				user.visible_message("[user] unfastens the peripherals control module.", "You unfasten the peripherals control module.")
				holder.icon_state = "ripley7"
		if(5)
			if(diff==FORWARD)
				user.visible_message("[user] secures internal armor layer.", "You secure internal armor layer.")
				holder.icon_state = "ripley10"
			else
				user.visible_message("[user] pries internal armor layer from [holder].", "You prie internal armor layer from [holder].")
				new /obj/item/stack/material/steel(get_turf(holder), 5)
				holder.icon_state = "ripley8"
		if(4)
			if(diff==FORWARD)
				user.visible_message("[user] welds internal armor layer to [holder].", "You weld the internal armor layer to [holder].")
				holder.icon_state = "ripley11"
			else
				user.visible_message("[user] unfastens the internal armor layer.", "You unfasten the internal armor layer.")
				holder.icon_state = "ripley9"
		if(3)
			if(diff==FORWARD)
				user.visible_message("[user] installs external reinforced armor layer to [holder].", "You install external reinforced armor layer to [holder].")
				holder.icon_state = "ripley12"
			else
				user.visible_message("[user] cuts internal armor layer from [holder].", "You cut the internal armor layer from [holder].")
				holder.icon_state = "ripley10"
		if(2)
			if(diff==FORWARD)
				user.visible_message("[user] secures external armor layer.", "You secure external reinforced armor layer.")
				holder.icon_state = "ripley13"
			else
				user.visible_message("[user] pries external armor layer from [holder].", "You prie external armor layer from [holder].")
				new /obj/item/stack/material/plasteel(get_turf(holder), 5)
				holder.icon_state = "ripley11"
		if(1)
			if(diff==FORWARD)
				user.visible_message("[user] welds external armor layer to [holder].", "You weld external armor layer to [holder].")
			else
				user.visible_message("[user] unfastens the external armor layer.", "You unfasten the external armor layer.")
				holder.icon_state = "ripley12"
	return 1

/datum/construction/reversible/mecha/ripley/spawn_result()
	..()
	feedback_inc("mecha_ripley_created",1)
	return

//////////////////////
//		Gygax
//////////////////////
/datum/construction/mecha/gygax_chassis
	steps = list(list("key"=/obj/item/mecha_parts/part/gygax_torso),//1
					 list("key"=/obj/item/mecha_parts/part/gygax_left_arm),//2
					 list("key"=/obj/item/mecha_parts/part/gygax_right_arm),//3
					 list("key"=/obj/item/mecha_parts/part/gygax_left_leg),//4
					 list("key"=/obj/item/mecha_parts/part/gygax_right_leg),//5
					 list("key"=/obj/item/mecha_parts/part/gygax_head)
					)

/datum/construction/mecha/gygax_chassis/custom_action(step, obj/item/I, mob/user)
	user.visible_message("[user] has connected [I] to [holder].", "You connect [I] to [holder]")
	holder.add_overlay(I.icon_state+"+o")
	qdel(I)
	return 1

/datum/construction/mecha/gygax_chassis/action(obj/item/I,mob/user as mob)
	return check_all_steps(I,user)

/datum/construction/mecha/gygax_chassis/spawn_result()
	var/obj/item/mecha_parts/chassis/const_holder = holder
	const_holder.construct = new /datum/construction/reversible/mecha/gygax(const_holder)
	const_holder.icon = 'icons/mecha/mech_construction.dmi'
	const_holder.icon_state = "gygax0"
	const_holder.density = TRUE
	spawn()
		qdel(src)
	return


/datum/construction/reversible/mecha/gygax
	result = "/obj/mecha/combat/gygax"
	steps = list(
					//1
					list("key"=IS_WELDER,
							"backkey"=IS_WRENCH,
							"desc"="External armor is wrenched."),
					 //2
					 list("key"=IS_WRENCH,
					 		"backkey"=IS_CROWBAR,
					 		"desc"="External armor is installed."),
					 //3
					 list("key"=/obj/item/mecha_parts/part/gygax_armour,
					 		"backkey"=IS_WELDER,
					 		"desc"="Internal armor is welded."),
					 //4
					 list("key"=IS_WELDER,
					 		"backkey"=IS_WRENCH,
					 		"desc"="Internal armor is wrenched"),
					 //5
					 list("key"=IS_WRENCH,
					 		"backkey"=IS_CROWBAR,
					 		"desc"="Internal armor is installed"),
					 //6
					 list("key"=/obj/item/stack/material/steel,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="Advanced capacitor is secured"),
					 //7
					 list("key"=IS_SCREWDRIVER,
					 		"backkey"=IS_CROWBAR,
					 		"desc"="Advanced capacitor is installed"),
					 //8
					 list("key"=/obj/item/weapon/stock_parts/capacitor/adv,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="Advanced scanner module is secured"),
					 //9
					 list("key"=IS_SCREWDRIVER,
					 		"backkey"=IS_CROWBAR,
					 		"desc"="Advanced scanner module is installed"),
					 //10
					 list("key"=/obj/item/weapon/stock_parts/scanning_module/adv,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="Targeting module is secured"),
					 //11
					 list("key"=IS_SCREWDRIVER,
					 		"backkey"=IS_CROWBAR,
					 		"desc"="Targeting module is installed"),
					 //12
					 list("key"=/obj/item/weapon/circuitboard/mecha/gygax/targeting,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="Peripherals control module is secured"),
					 //13
					 list("key"=IS_SCREWDRIVER,
					 		"backkey"=IS_CROWBAR,
					 		"desc"="Peripherals control module is installed"),
					 //14
					 list("key"=/obj/item/weapon/circuitboard/mecha/gygax/peripherals,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="Central control module is secured"),
					 //15
					 list("key"=IS_SCREWDRIVER,
					 		"backkey"=IS_CROWBAR,
					 		"desc"="Central control module is installed"),
					 //16
					 list("key"=/obj/item/weapon/circuitboard/mecha/gygax/main,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="The wiring is adjusted"),
					 //17
					 list("key"=/obj/item/weapon/tool/wirecutters,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="The wiring is added"),
					 //18
					 list("key"=/obj/item/stack/cable_coil,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="The hydraulic systems are active."),
					 //19
					 list("key"=IS_SCREWDRIVER,
					 		"backkey"=IS_WRENCH,
					 		"desc"="The hydraulic systems are connected."),
					 //20
					 list("key"=IS_WRENCH,
					 		"desc"="The hydraulic systems are disconnected.")
					)

/datum/construction/reversible/mecha/gygax/action(obj/item/I,mob/user as mob)
	return check_step(I,user)

/datum/construction/reversible/mecha/gygax/custom_action(index, diff, obj/item/I, mob/user)
	if(!..())
		return 0

	//TODO: better messages.
	switch(index)
		if(20)
			user.visible_message("[user] connects [holder] hydraulic systems", "You connect [holder] hydraulic systems.")
			holder.icon_state = "gygax1"
		if(19)
			if(diff==FORWARD)
				user.visible_message("[user] activates [holder] hydraulic systems.", "You activate [holder] hydraulic systems.")
				holder.icon_state = "gygax2"
			else
				user.visible_message("[user] disconnects [holder] hydraulic systems", "You disconnect [holder] hydraulic systems.")
				holder.icon_state = "gygax0"
		if(18)
			if(diff==FORWARD)
				user.visible_message("[user] adds the wiring to [holder].", "You add the wiring to [holder].")
				holder.icon_state = "gygax3"
			else
				user.visible_message("[user] deactivates [holder] hydraulic systems.", "You deactivate [holder] hydraulic systems.")
				holder.icon_state = "gygax1"
		if(17)
			if(diff==FORWARD)
				user.visible_message("[user] adjusts the wiring of [holder].", "You adjust the wiring of [holder].")
				holder.icon_state = "gygax4"
			else
				user.visible_message("[user] removes the wiring from [holder].", "You remove the wiring from [holder].")
				new /obj/item/stack/cable_coil(get_turf(holder), 4)
				holder.icon_state = "gygax2"
		if(16)
			if(diff==FORWARD)
				user.visible_message("[user] installs the central control module into [holder].", "You install the central computer mainboard into [holder].")
				qdel(I)
				holder.icon_state = "gygax5"
			else
				user.visible_message("[user] disconnects the wiring of [holder].", "You disconnect the wiring of [holder].")
				holder.icon_state = "gygax3"
		if(15)
			if(diff==FORWARD)
				user.visible_message("[user] secures the mainboard.", "You secure the mainboard.")
				holder.icon_state = "gygax6"
			else
				user.visible_message("[user] removes the central control module from [holder].", "You remove the central computer mainboard from [holder].")
				new /obj/item/weapon/circuitboard/mecha/gygax/main(get_turf(holder))
				holder.icon_state = "gygax4"
		if(14)
			if(diff==FORWARD)
				user.visible_message("[user] installs the peripherals control module into [holder].", "You install the peripherals control module into [holder].")
				qdel(I)
				holder.icon_state = "gygax7"
			else
				user.visible_message("[user] unfastens the mainboard.", "You unfasten the mainboard.")
				holder.icon_state = "gygax5"
		if(13)
			if(diff==FORWARD)
				user.visible_message("[user] secures the peripherals control module.", "You secure the peripherals control module.")
				holder.icon_state = "gygax8"
			else
				user.visible_message("[user] removes the peripherals control module from [holder].", "You remove the peripherals control module from [holder].")
				new /obj/item/weapon/circuitboard/mecha/gygax/peripherals(get_turf(holder))
				holder.icon_state = "gygax6"
		if(12)
			if(diff==FORWARD)
				user.visible_message("[user] installs the weapon control module into [holder].", "You install the weapon control module into [holder].")
				qdel(I)
				holder.icon_state = "gygax9"
			else
				user.visible_message("[user] unfastens the peripherals control module.", "You unfasten the peripherals control module.")
				holder.icon_state = "gygax7"
		if(11)
			if(diff==FORWARD)
				user.visible_message("[user] secures the weapon control module.", "You secure the weapon control module.")
				holder.icon_state = "gygax10"
			else
				user.visible_message("[user] removes the weapon control module from [holder].", "You remove the weapon control module from [holder].")
				new /obj/item/weapon/circuitboard/mecha/gygax/targeting(get_turf(holder))
				holder.icon_state = "gygax8"
		if(10)
			if(diff==FORWARD)
				user.visible_message("[user] installs advanced scanner module to [holder].", "You install advanced scanner module to [holder].")
				qdel(I)
				holder.icon_state = "gygax11"
			else
				user.visible_message("[user] unfastens the weapon control module.", "You unfasten the weapon control module.")
				holder.icon_state = "gygax9"
		if(9)
			if(diff==FORWARD)
				user.visible_message("[user] secures the advanced scanner module.", "You secure the advanced scanner module.")
				holder.icon_state = "gygax12"
			else
				user.visible_message("[user] removes the advanced scanner module from [holder].", "You remove the advanced scanner module from [holder].")
				new /obj/item/weapon/stock_parts/scanning_module/adv(get_turf(holder))
				holder.icon_state = "gygax10"
		if(8)
			if(diff==FORWARD)
				user.visible_message("[user] installs advanced capacitor to [holder].", "You install advanced capacitor to [holder].")
				qdel(I)
				holder.icon_state = "gygax13"
			else
				user.visible_message("[user] unfastens the advanced scanner module.", "You unfasten the advanced scanner module.")
				holder.icon_state = "gygax11"
		if(7)
			if(diff==FORWARD)
				user.visible_message("[user] secures the advanced capacitor.", "You secure the advanced capacitor.")
				holder.icon_state = "gygax14"
			else
				user.visible_message("[user] removes the advanced capacitor from [holder].", "You remove the advanced capacitor from [holder].")
				new /obj/item/weapon/stock_parts/capacitor/adv(get_turf(holder))
				holder.icon_state = "gygax12"
		if(6)
			if(diff==FORWARD)
				user.visible_message("[user] installs internal armor layer to [holder].", "You install internal armor layer to [holder].")
				holder.icon_state = "gygax15"
			else
				user.visible_message("[user] unfastens the advanced capacitor.", "You unfasten the advanced capacitor.")
				holder.icon_state = "gygax13"
		if(5)
			if(diff==FORWARD)
				user.visible_message("[user] secures internal armor layer.", "You secure internal armor layer.")
				holder.icon_state = "gygax16"
			else
				user.visible_message("[user] pries internal armor layer from [holder].", "You prie internal armor layer from [holder].")
				new /obj/item/stack/material/steel(get_turf(holder), 5)
				holder.icon_state = "gygax14"
		if(4)
			if(diff==FORWARD)
				user.visible_message("[user] welds internal armor layer to [holder].", "You weld the internal armor layer to [holder].")
				holder.icon_state = "gygax17"
			else
				user.visible_message("[user] unfastens the internal armor layer.", "You unfasten the internal armor layer.")
				holder.icon_state = "gygax15"
		if(3)
			if(diff==FORWARD)
				user.visible_message("[user] installs Gygax Armour Plates to [holder].", "You install Gygax Armour Plates to [holder].")
				qdel(I)
				holder.icon_state = "gygax18"
			else
				user.visible_message("[user] cuts internal armor layer from [holder].", "You cut the internal armor layer from [holder].")
				holder.icon_state = "gygax16"
		if(2)
			if(diff==FORWARD)
				user.visible_message("[user] secures Gygax Armour Plates.", "You secure Gygax Armour Plates.")
				holder.icon_state = "gygax19"
			else
				user.visible_message("[user] pries Gygax Armour Plates from [holder].", "You prie Gygax Armour Plates from [holder].")
				new /obj/item/mecha_parts/part/gygax_armour(get_turf(holder))
				holder.icon_state = "gygax17"
		if(1)
			if(diff==FORWARD)
				user.visible_message("[user] welds Gygax Armour Plates to [holder].", "You weld Gygax Armour Plates to [holder].")
			else
				user.visible_message("[user] unfastens Gygax Armour Plates.", "You unfasten Gygax Armour Plates.")
				holder.icon_state = "gygax18"
	return 1

/datum/construction/reversible/mecha/gygax/spawn_result()
	..()
	feedback_inc("mecha_gygax_created",1)
	return


 //////////////////////
//		Serenity
//////////////////////
/datum/construction/mecha/serenity_chassis
	steps = list(list("key"=/obj/item/mecha_parts/part/gygax_torso),//1
					 list("key"=/obj/item/mecha_parts/part/gygax_left_arm),//2
					 list("key"=/obj/item/mecha_parts/part/gygax_right_arm),//3
					 list("key"=/obj/item/mecha_parts/part/gygax_left_leg),//4
					 list("key"=/obj/item/mecha_parts/part/gygax_right_leg),//5
					 list("key"=/obj/item/mecha_parts/part/gygax_head)
					)

/datum/construction/mecha/serenity_chassis/custom_action(step, obj/item/I, mob/user)
	user.visible_message("[user] has connected [I] to [holder].", "You connect [I] to [holder]")
	holder.add_overlay(I.icon_state+"+o")
	qdel(I)
	return 1

/datum/construction/mecha/serenity_chassis/action(obj/item/I,mob/user as mob)
	return check_all_steps(I,user)

/datum/construction/mecha/serenity_chassis/spawn_result()
	var/obj/item/mecha_parts/chassis/const_holder = holder
	const_holder.construct = new /datum/construction/reversible/mecha/serenity(const_holder)
	const_holder.icon = 'icons/mecha/mech_construction.dmi'
	const_holder.icon_state = "gygax0"
	const_holder.density = TRUE
	spawn()
		qdel(src)
	return


/datum/construction/reversible/mecha/serenity
	result = "/obj/mecha/combat/gygax/serenity"
	steps = list(
					//1
					list("key"=IS_WELDER,
							"backkey"=IS_WRENCH,
							"desc"="External armor is wrenched."),
					 //2
					 list("key"=IS_WRENCH,
					 		"backkey"=IS_CROWBAR,
					 		"desc"="External armor is installed."),
					 //3
					 list("key"=/obj/item/stack/material/plasteel,
					 		"backkey"=IS_WELDER,
					 		"desc"="Internal armor is welded."),
					 //4
					 list("key"=IS_WELDER,
					 		"backkey"=IS_WRENCH,
					 		"desc"="Internal armor is wrenched"),
					 //5
					 list("key"=IS_WRENCH,
					 		"backkey"=IS_CROWBAR,
					 		"desc"="Internal armor is installed"),
					 //6
					 list("key"=/obj/item/stack/material/steel,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="Advanced capacitor is secured"),
					 //7
					 list("key"=IS_SCREWDRIVER,
					 		"backkey"=IS_CROWBAR,
					 		"desc"="Advanced capacitor is installed"),
					 //8
					 list("key"=/obj/item/weapon/stock_parts/capacitor/adv,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="Advanced scanner module is secured"),
					 //9
					 list("key"=IS_SCREWDRIVER,
					 		"backkey"=IS_CROWBAR,
					 		"desc"="Advanced scanner module is installed"),
					 //10
					 list("key"=/obj/item/weapon/stock_parts/scanning_module/adv,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="Medical module is secured"),
					 //11
					 list("key"=IS_SCREWDRIVER,
					 		"backkey"=IS_CROWBAR,
					 		"desc"="Medical module is installed"),
					 //12
					 list("key"=/obj/item/weapon/circuitboard/mecha/gygax/medical,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="Peripherals control module is secured"),
					 //13
					 list("key"=IS_SCREWDRIVER,
					 		"backkey"=IS_CROWBAR,
					 		"desc"="Peripherals control module is installed"),
					 //14
					 list("key"=/obj/item/weapon/circuitboard/mecha/gygax/peripherals,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="Central control module is secured"),
					 //15
					 list("key"=IS_SCREWDRIVER,
					 		"backkey"=IS_CROWBAR,
					 		"desc"="Central control module is installed"),
					 //16
					 list("key"=/obj/item/weapon/circuitboard/mecha/gygax/main,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="The wiring is adjusted"),
					 //17
					 list("key"=/obj/item/weapon/tool/wirecutters,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="The wiring is added"),
					 //18
					 list("key"=/obj/item/stack/cable_coil,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="The hydraulic systems are active."),
					 //19
					 list("key"=IS_SCREWDRIVER,
					 		"backkey"=IS_WRENCH,
					 		"desc"="The hydraulic systems are connected."),
					 //20
					 list("key"=IS_WRENCH,
					 		"desc"="The hydraulic systems are disconnected.")
					)

/datum/construction/reversible/mecha/serenity/action(obj/item/I,mob/user as mob)
	return check_step(I,user)

/datum/construction/reversible/mecha/serenity/custom_action(index, diff, obj/item/I, mob/user)
	if(!..())
		return 0

 	//TODO: better messages.
	switch(index)
		if(20)
			user.visible_message("[user] connects [holder] hydraulic systems", "You connect [holder] hydraulic systems.")
			holder.icon_state = "gygax1"
		if(19)
			if(diff==FORWARD)
				user.visible_message("[user] activates [holder] hydraulic systems.", "You activate [holder] hydraulic systems.")
				holder.icon_state = "gygax2"
			else
				user.visible_message("[user] disconnects [holder] hydraulic systems", "You disconnect [holder] hydraulic systems.")
				holder.icon_state = "gygax0"
		if(18)
			if(diff==FORWARD)
				user.visible_message("[user] adds the wiring to [holder].", "You add the wiring to [holder].")
				holder.icon_state = "gygax3"
			else
				user.visible_message("[user] deactivates [holder] hydraulic systems.", "You deactivate [holder] hydraulic systems.")
				holder.icon_state = "gygax1"
		if(17)
			if(diff==FORWARD)
				user.visible_message("[user] adjusts the wiring of [holder].", "You adjust the wiring of [holder].")
				holder.icon_state = "gygax4"
			else
				user.visible_message("[user] removes the wiring from [holder].", "You remove the wiring from [holder].")
				new /obj/item/stack/cable_coil(get_turf(holder), 4)
				holder.icon_state = "gygax2"
		if(16)
			if(diff==FORWARD)
				user.visible_message("[user] installs the central control module into [holder].", "You install the central computer mainboard into [holder].")
				qdel(I)
				holder.icon_state = "gygax5"
			else
				user.visible_message("[user] disconnects the wiring of [holder].", "You disconnect the wiring of [holder].")
				holder.icon_state = "gygax3"
		if(15)
			if(diff==FORWARD)
				user.visible_message("[user] secures the mainboard.", "You secure the mainboard.")
				holder.icon_state = "gygax6"
			else
				user.visible_message("[user] removes the central control module from [holder].", "You remove the central computer mainboard from [holder].")
				new /obj/item/weapon/circuitboard/mecha/gygax/main(get_turf(holder))
				holder.icon_state = "gygax4"
		if(14)
			if(diff==FORWARD)
				user.visible_message("[user] installs the peripherals control module into [holder].", "You install the peripherals control module into [holder].")
				qdel(I)
				holder.icon_state = "gygax7"
			else
				user.visible_message("[user] unfastens the mainboard.", "You unfasten the mainboard.")
				holder.icon_state = "gygax5"
		if(13)
			if(diff==FORWARD)
				user.visible_message("[user] secures the peripherals control module.", "You secure the peripherals control module.")
				holder.icon_state = "gygax8"
			else
				user.visible_message("[user] removes the peripherals control module from [holder].", "You remove the peripherals control module from [holder].")
				new /obj/item/weapon/circuitboard/mecha/gygax/peripherals(get_turf(holder))
				holder.icon_state = "gygax6"
		if(12)
			if(diff==FORWARD)
				user.visible_message("[user] installs the medical control module into [holder].", "You install the medical control module into [holder].")
				qdel(I)
				holder.icon_state = "gygax9"
			else
				user.visible_message("[user] unfastens the peripherals control module.", "You unfasten the peripherals control module.")
				holder.icon_state = "gygax7"
		if(11)
			if(diff==FORWARD)
				user.visible_message("[user] secures the medical control module.", "You secure the medical control module.")
				holder.icon_state = "gygax10"
			else
				user.visible_message("[user] removes the medical control module from [holder].", "You remove the medical control module from [holder].")
				new /obj/item/weapon/circuitboard/mecha/gygax/medical(get_turf(holder))
				holder.icon_state = "gygax8"
		if(10)
			if(diff==FORWARD)
				user.visible_message("[user] installs advanced scanner module to [holder].", "You install advanced scanner module to [holder].")
				qdel(I)
				holder.icon_state = "gygax11"
			else
				user.visible_message("[user] unfastens the medical control module.", "You unfasten the medical control module.")
				holder.icon_state = "gygax9"
		if(9)
			if(diff==FORWARD)
				user.visible_message("[user] secures the advanced scanner module.", "You secure the advanced scanner module.")
				holder.icon_state = "gygax12"
			else
				user.visible_message("[user] removes the advanced scanner module from [holder].", "You remove the advanced scanner module from [holder].")
				new /obj/item/weapon/stock_parts/scanning_module/adv(get_turf(holder))
				holder.icon_state = "gygax10"
		if(8)
			if(diff==FORWARD)
				user.visible_message("[user] installs advanced capacitor to [holder].", "You install advanced capacitor to [holder].")
				qdel(I)
				holder.icon_state = "gygax13"
			else
				user.visible_message("[user] unfastens the advanced scanner module.", "You unfasten the advanced scanner module.")
				holder.icon_state = "gygax11"
		if(7)
			if(diff==FORWARD)
				user.visible_message("[user] secures the advanced capacitor.", "You secure the advanced capacitor.")
				holder.icon_state = "gygax14"
			else
				user.visible_message("[user] removes the advanced capacitor from [holder].", "You remove the advanced capacitor from [holder].")
				new /obj/item/weapon/stock_parts/capacitor/adv(get_turf(holder))
				holder.icon_state = "gygax12"
		if(6)
			if(diff==FORWARD)
				user.visible_message("[user] installs internal armor layer to [holder].", "You install internal armor layer to [holder].")
				holder.icon_state = "gygax15"
			else
				user.visible_message("[user] unfastens the advanced capacitor.", "You unfasten the advanced capacitor.")
				holder.icon_state = "gygax13"
		if(5)
			if(diff==FORWARD)
				user.visible_message("[user] secures internal armor layer.", "You secure internal armor layer.")
				holder.icon_state = "gygax16"
			else
				user.visible_message("[user] pries internal armor layer from [holder].", "You pry the internal armor layer from [holder].")
				new /obj/item/stack/material/steel(get_turf(holder), 5)
				holder.icon_state = "gygax14"
		if(4)
			if(diff==FORWARD)
				user.visible_message("[user] welds internal armor layer to [holder].", "You weld the internal armor layer to [holder].")
				holder.icon_state = "gygax17"
			else
				user.visible_message("[user] unfastens the internal armor layer.", "You unfasten the internal armor layer.")
				holder.icon_state = "gygax15"
		if(3)
			if(diff==FORWARD)
				user.visible_message("[user] installs the external armor layer to [holder].", "You install the external armor layer to [holder].")
				holder.icon_state = "gygax18"
			else
				user.visible_message("[user] cuts internal armor layer from [holder].", "You cut the internal armor layer from [holder].")
				holder.icon_state = "gygax16"
		if(2)
			if(diff==FORWARD)
				user.visible_message("[user] secures the external armor layer.", "You secure the external armor layer.")
				holder.icon_state = "gygax19-s"
			else
				user.visible_message("[user] pries the external armor layer from [holder].", "You pry the external armor layer from [holder].")
				new /obj/item/stack/material/plasteel(get_turf(holder), 5) // Fixes serenity giving Gygax Armor Plates for the reverse action...
				holder.icon_state = "gygax17"
		if(1)
			if(diff==FORWARD)
				user.visible_message("[user] welds the external armor layer to [holder].", "You weld the external armor layer to [holder].")
			else
				user.visible_message("[user] unfastens the external armor layer.", "You unfasten the external armor layer.")
				holder.icon_state = "gygax18"
	return 1

/datum/construction/reversible/mecha/serenity/spawn_result()
	..()
	feedback_inc("mecha_serenity_created",1)
	return



////////////////////////
//		Firefighter
////////////////////////
/datum/construction/mecha/firefighter_chassis
	steps = list(list("key"=/obj/item/mecha_parts/part/ripley_torso),//1
					 list("key"=/obj/item/mecha_parts/part/ripley_left_arm),//2
					 list("key"=/obj/item/mecha_parts/part/ripley_right_arm),//3
					 list("key"=/obj/item/mecha_parts/part/ripley_left_leg),//4
					 list("key"=/obj/item/mecha_parts/part/ripley_right_leg),//5
					 list("key"=/obj/item/clothing/suit/fire)//6
					)

/datum/construction/mecha/firefighter_chassis/custom_action(step, obj/item/I, mob/user)
	user.visible_message("[user] has connected [I] to [holder].", "You connect [I] to [holder]")
	holder.add_overlay(I.icon_state+"+o")
	user.drop_item()
	qdel(I)
	return 1

/datum/construction/mecha/firefighter_chassis/action(obj/item/I,mob/user as mob)
	return check_all_steps(I,user)

/datum/construction/mecha/firefighter_chassis/spawn_result()
	var/obj/item/mecha_parts/chassis/const_holder = holder
	const_holder.construct = new /datum/construction/reversible/mecha/firefighter(const_holder)
	const_holder.icon = 'icons/mecha/mech_construction.dmi'
	const_holder.icon_state = "fireripley0"
	const_holder.density = TRUE
	spawn()
		qdel(src)
	return


/datum/construction/reversible/mecha/firefighter
	result = "/obj/mecha/working/ripley/firefighter"
	steps = list(
					//1
					list("key"=IS_WELDER,
							"backkey"=IS_WRENCH,
							"desc"="External armor is wrenched."),
					//2
					 list("key"=IS_WRENCH,
					 		"backkey"=IS_CROWBAR,
					 		"desc"="External armor is installed."),
					 //3
					 list("key"=/obj/item/stack/material/plasteel,
					 		"backkey"=IS_CROWBAR,
					 		"desc"="External armor is being installed."),
					 //4
					 list("key"=/obj/item/stack/material/plasteel,
					 		"backkey"=IS_WELDER,
					 		"desc"="Internal armor is welded."),
					 //5
					 list("key"=IS_WELDER,
					 		"backkey"=IS_WRENCH,
					 		"desc"="Internal armor is wrenched"),
					 //6
					 list("key"=IS_WRENCH,
					 		"backkey"=IS_CROWBAR,
					 		"desc"="Internal armor is installed"),
					 //7
					 list("key"=/obj/item/stack/material/plasteel,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="Peripherals control module is secured"),
					 //8
					 list("key"=IS_SCREWDRIVER,
					 		"backkey"=IS_CROWBAR,
					 		"desc"="Peripherals control module is installed"),
					 //9
					 list("key"=/obj/item/weapon/circuitboard/mecha/ripley/peripherals,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="Central control module is secured"),
					 //10
					 list("key"=IS_SCREWDRIVER,
					 		"backkey"=IS_CROWBAR,
					 		"desc"="Central control module is installed"),
					 //11
					 list("key"=/obj/item/weapon/circuitboard/mecha/ripley/main,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="The wiring is adjusted"),
					 //12
					 list("key"=/obj/item/weapon/tool/wirecutters,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="The wiring is added"),
					 //13
					 list("key"=/obj/item/stack/cable_coil,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="The hydraulic systems are active."),
					 //14
					 list("key"=IS_SCREWDRIVER,
					 		"backkey"=IS_WRENCH,
					 		"desc"="The hydraulic systems are connected."),
					 //15
					 list("key"=IS_WRENCH,
					 		"desc"="The hydraulic systems are disconnected.")
					)

/datum/construction/reversible/mecha/firefighter/action(obj/item/I,mob/user as mob)
	return check_step(I,user)

/datum/construction/reversible/mecha/firefighter/custom_action(index, diff, obj/item/I, mob/user)
	if(!..())
		return 0

	//TODO: better messages.
	switch(index)
		if(15)
			user.visible_message("[user] connects [holder] hydraulic systems", "You connect [holder] hydraulic systems.")
			holder.icon_state = "fireripley1"
		if(14)
			if(diff==FORWARD)
				user.visible_message("[user] activates [holder] hydraulic systems.", "You activate [holder] hydraulic systems.")
				holder.icon_state = "fireripley2"
			else
				user.visible_message("[user] disconnects [holder] hydraulic systems", "You disconnect [holder] hydraulic systems.")
				holder.icon_state = "fireripley0"
		if(13)
			if(diff==FORWARD)
				user.visible_message("[user] adds the wiring to [holder].", "You add the wiring to [holder].")
				holder.icon_state = "fireripley3"
			else
				user.visible_message("[user] deactivates [holder] hydraulic systems.", "You deactivate [holder] hydraulic systems.")
				holder.icon_state = "fireripley1"
		if(12)
			if(diff==FORWARD)
				user.visible_message("[user] adjusts the wiring of [holder].", "You adjust the wiring of [holder].")
				holder.icon_state = "fireripley4"
			else
				user.visible_message("[user] removes the wiring from [holder].", "You remove the wiring from [holder].")
				new /obj/item/stack/cable_coil(get_turf(holder), 4)
				holder.icon_state = "fireripley2"
		if(11)
			if(diff==FORWARD)
				user.visible_message("[user] installs the central control module into [holder].", "You install the central computer mainboard into [holder].")
				qdel(I)
				holder.icon_state = "fireripley5"
			else
				user.visible_message("[user] disconnects the wiring of [holder].", "You disconnect the wiring of [holder].")
				holder.icon_state = "fireripley3"
		if(10)
			if(diff==FORWARD)
				user.visible_message("[user] secures the mainboard.", "You secure the mainboard.")
				holder.icon_state = "fireripley6"
			else
				user.visible_message("[user] removes the central control module from [holder].", "You remove the central computer mainboard from [holder].")
				new /obj/item/weapon/circuitboard/mecha/ripley/main(get_turf(holder))
				holder.icon_state = "fireripley4"
		if(9)
			if(diff==FORWARD)
				user.visible_message("[user] installs the peripherals control module into [holder].", "You install the peripherals control module into [holder].")
				qdel(I)
				holder.icon_state = "fireripley7"
			else
				user.visible_message("[user] unfastens the mainboard.", "You unfasten the mainboard.")
				holder.icon_state = "fireripley5"
		if(8)
			if(diff==FORWARD)
				user.visible_message("[user] secures the peripherals control module.", "You secure the peripherals control module.")
				holder.icon_state = "fireripley8"
			else
				user.visible_message("[user] removes the peripherals control module from [holder].", "You remove the peripherals control module from [holder].")
				new /obj/item/weapon/circuitboard/mecha/ripley/peripherals(get_turf(holder))
				holder.icon_state = "fireripley6"
		if(7)
			if(diff==FORWARD)
				user.visible_message("[user] installs internal armor layer to [holder].", "You install internal armor layer to [holder].")
				holder.icon_state = "fireripley9"
			else
				user.visible_message("[user] unfastens the peripherals control module.", "You unfasten the peripherals control module.")
				holder.icon_state = "fireripley7"
		if(6)
			if(diff==FORWARD)
				user.visible_message("[user] secures internal armor layer.", "You secure internal armor layer.")
				holder.icon_state = "fireripley10"
			else
				user.visible_message("[user] pries internal armor layer from [holder].", "You prie internal armor layer from [holder].")
				new /obj/item/stack/material/plasteel(get_turf(holder), 5)
				holder.icon_state = "fireripley8"
		if(5)
			if(diff==FORWARD)
				user.visible_message("[user] welds internal armor layer to [holder].", "You weld the internal armor layer to [holder].")
				holder.icon_state = "fireripley11"
			else
				user.visible_message("[user] unfastens the internal armor layer.", "You unfasten the internal armor layer.")
				holder.icon_state = "fireripley9"
		if(4)
			if(diff==FORWARD)
				user.visible_message("[user] starts to install the external armor layer to [holder].", "You start to install the external armor layer to [holder].")
				holder.icon_state = "fireripley12"
			else
				user.visible_message("[user] cuts internal armor layer from [holder].", "You cut the internal armor layer from [holder].")
				holder.icon_state = "fireripley10"
		if(3)
			if(diff==FORWARD)
				user.visible_message("[user] installs external reinforced armor layer to [holder].", "You install external reinforced armor layer to [holder].")
				holder.icon_state = "fireripley13"
			else
				user.visible_message("[user] removes the external armor from [holder].", "You remove the external armor from [holder].")
				new /obj/item/stack/material/plasteel(get_turf(holder), 5)
				holder.icon_state = "fireripley11"
		if(2)
			if(diff==FORWARD)
				user.visible_message("[user] secures external armor layer.", "You secure external reinforced armor layer.")
				holder.icon_state = "fireripley14"
			else
				user.visible_message("[user] pries external armor layer from [holder].", "You prie external armor layer from [holder].")
				new /obj/item/stack/material/plasteel(get_turf(holder), 5)
				holder.icon_state = "fireripley12"
		if(1)
			if(diff==FORWARD)
				user.visible_message("[user] welds external armor layer to [holder].", "You weld external armor layer to [holder].")
			else
				user.visible_message("[user] unfastens the external armor layer.", "You unfasten the external armor layer.")
				holder.icon_state = "fireripley13"
	return 1

/datum/construction/reversible/mecha/firefighter/spawn_result()
	..()
	feedback_inc("mecha_firefighter_created",1)
	return

//////////////////////
//		Durand
//////////////////////
/datum/construction/mecha/durand_chassis
	steps = list(list("key"=/obj/item/mecha_parts/part/durand_torso),//1
					 list("key"=/obj/item/mecha_parts/part/durand_left_arm),//2
					 list("key"=/obj/item/mecha_parts/part/durand_right_arm),//3
					 list("key"=/obj/item/mecha_parts/part/durand_left_leg),//4
					 list("key"=/obj/item/mecha_parts/part/durand_right_leg),//5
					 list("key"=/obj/item/mecha_parts/part/durand_head)
					)

/datum/construction/mecha/durand_chassis/custom_action(step, obj/item/I, mob/user)
	user.visible_message("[user] has connected [I] to [holder].", "You connect [I] to [holder]")
	holder.add_overlay(I.icon_state+"+o")
	qdel(I)
	return 1

/datum/construction/mecha/durand_chassis/action(obj/item/I,mob/user as mob)
	return check_all_steps(I,user)

/datum/construction/mecha/durand_chassis/spawn_result()
	var/obj/item/mecha_parts/chassis/const_holder = holder
	const_holder.construct = new /datum/construction/reversible/mecha/durand(const_holder)
	const_holder.icon = 'icons/mecha/mech_construction.dmi'
	const_holder.icon_state = "durand0"
	const_holder.density = TRUE
	spawn()
		qdel(src)
	return


/datum/construction/reversible/mecha/durand
	result = "/obj/mecha/combat/durand"
	steps = list(
					//1
					list("key"=IS_WELDER,
							"backkey"=IS_WRENCH,
							"desc"="External armor is wrenched."),
					 //2
					 list("key"=IS_WRENCH,
					 		"backkey"=IS_CROWBAR,
					 		"desc"="External armor is installed."),
					 //3
					 list("key"=/obj/item/mecha_parts/part/durand_armour,
					 		"backkey"=IS_WELDER,
					 		"desc"="Internal armor is welded."),
					 //4
					 list("key"=IS_WELDER,
					 		"backkey"=IS_WRENCH,
					 		"desc"="Internal armor is wrenched"),
					 //5
					 list("key"=IS_WRENCH,
					 		"backkey"=IS_CROWBAR,
					 		"desc"="Internal armor is installed"),
					 //6
					 list("key"=/obj/item/stack/material/steel,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="Advanced capacitor is secured"),
					 //7
					 list("key"=IS_SCREWDRIVER,
					 		"backkey"=IS_CROWBAR,
					 		"desc"="Advanced capacitor is installed"),
					 //8
					 list("key"=/obj/item/weapon/stock_parts/capacitor/adv,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="Advanced scanner module is secured"),
					 //9
					 list("key"=IS_SCREWDRIVER,
					 		"backkey"=IS_CROWBAR,
					 		"desc"="Advanced scanner module is installed"),
					 //10
					 list("key"=/obj/item/weapon/stock_parts/scanning_module/adv,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="Targeting module is secured"),
					 //11
					 list("key"=IS_SCREWDRIVER,
					 		"backkey"=IS_CROWBAR,
					 		"desc"="Targeting module is installed"),
					 //12
					 list("key"=/obj/item/weapon/circuitboard/mecha/durand/targeting,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="Peripherals control module is secured"),
					 //13
					 list("key"=IS_SCREWDRIVER,
					 		"backkey"=IS_CROWBAR,
					 		"desc"="Peripherals control module is installed"),
					 //14
					 list("key"=/obj/item/weapon/circuitboard/mecha/durand/peripherals,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="Central control module is secured"),
					 //15
					 list("key"=IS_SCREWDRIVER,
					 		"backkey"=IS_CROWBAR,
					 		"desc"="Central control module is installed"),
					 //16
					 list("key"=/obj/item/weapon/circuitboard/mecha/durand/main,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="The wiring is adjusted"),
					 //17
					 list("key"=/obj/item/weapon/tool/wirecutters,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="The wiring is added"),
					 //18
					 list("key"=/obj/item/stack/cable_coil,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="The hydraulic systems are active."),
					 //19
					 list("key"=IS_SCREWDRIVER,
					 		"backkey"=IS_WRENCH,
					 		"desc"="The hydraulic systems are connected."),
					 //20
					 list("key"=IS_WRENCH,
					 		"desc"="The hydraulic systems are disconnected.")
					)


/datum/construction/reversible/mecha/durand/action(obj/item/I,mob/user as mob)
	return check_step(I,user)

/datum/construction/reversible/mecha/durand/custom_action(index, diff, obj/item/I, mob/user)
	if(!..())
		return 0

	//TODO: better messages.
	switch(index)
		if(20)
			user.visible_message("[user] connects [holder] hydraulic systems", "You connect [holder] hydraulic systems.")
			holder.icon_state = "durand1"
		if(19)
			if(diff==FORWARD)
				user.visible_message("[user] activates [holder] hydraulic systems.", "You activate [holder] hydraulic systems.")
				holder.icon_state = "durand2"
			else
				user.visible_message("[user] disconnects [holder] hydraulic systems", "You disconnect [holder] hydraulic systems.")
				holder.icon_state = "durand0"
		if(18)
			if(diff==FORWARD)
				user.visible_message("[user] adds the wiring to [holder].", "You add the wiring to [holder].")
				holder.icon_state = "durand3"
			else
				user.visible_message("[user] deactivates [holder] hydraulic systems.", "You deactivate [holder] hydraulic systems.")
				holder.icon_state = "durand1"
		if(17)
			if(diff==FORWARD)
				user.visible_message("[user] adjusts the wiring of [holder].", "You adjust the wiring of [holder].")
				holder.icon_state = "durand4"
			else
				user.visible_message("[user] removes the wiring from [holder].", "You remove the wiring from [holder].")
				new /obj/item/stack/cable_coil(get_turf(holder), 4)
				holder.icon_state = "durand2"
		if(16)
			if(diff==FORWARD)
				user.visible_message("[user] installs the central control module into [holder].", "You install the central computer mainboard into [holder].")
				qdel(I)
				holder.icon_state = "durand5"
			else
				user.visible_message("[user] disconnects the wiring of [holder].", "You disconnect the wiring of [holder].")
				holder.icon_state = "durand3"
		if(15)
			if(diff==FORWARD)
				user.visible_message("[user] secures the mainboard.", "You secure the mainboard.")
				holder.icon_state = "durand6"
			else
				user.visible_message("[user] removes the central control module from [holder].", "You remove the central computer mainboard from [holder].")
				new /obj/item/weapon/circuitboard/mecha/durand/main(get_turf(holder))
				holder.icon_state = "durand4"
		if(14)
			if(diff==FORWARD)
				user.visible_message("[user] installs the peripherals control module into [holder].", "You install the peripherals control module into [holder].")
				qdel(I)
				holder.icon_state = "durand7"
			else
				user.visible_message("[user] unfastens the mainboard.", "You unfasten the mainboard.")
				holder.icon_state = "durand5"
		if(13)
			if(diff==FORWARD)
				user.visible_message("[user] secures the peripherals control module.", "You secure the peripherals control module.")
				holder.icon_state = "durand8"
			else
				user.visible_message("[user] removes the peripherals control module from [holder].", "You remove the peripherals control module from [holder].")
				new /obj/item/weapon/circuitboard/mecha/durand/peripherals(get_turf(holder))
				holder.icon_state = "durand6"
		if(12)
			if(diff==FORWARD)
				user.visible_message("[user] installs the weapon control module into [holder].", "You install the weapon control module into [holder].")
				qdel(I)
				holder.icon_state = "durand9"
			else
				user.visible_message("[user] unfastens the peripherals control module.", "You unfasten the peripherals control module.")
				holder.icon_state = "durand7"
		if(11)
			if(diff==FORWARD)
				user.visible_message("[user] secures the weapon control module.", "You secure the weapon control module.")
				holder.icon_state = "durand10"
			else
				user.visible_message("[user] removes the weapon control module from [holder].", "You remove the weapon control module from [holder].")
				new /obj/item/weapon/circuitboard/mecha/durand/targeting(get_turf(holder))
				holder.icon_state = "durand8"
		if(10)
			if(diff==FORWARD)
				user.visible_message("[user] installs advanced scanner module to [holder].", "You install advanced scanner module to [holder].")
				qdel(I)
				holder.icon_state = "durand11"
			else
				user.visible_message("[user] unfastens the weapon control module.", "You unfasten the weapon control module.")
				holder.icon_state = "durand9"
		if(9)
			if(diff==FORWARD)
				user.visible_message("[user] secures the advanced scanner module.", "You secure the advanced scanner module.")
				holder.icon_state = "durand12"
			else
				user.visible_message("[user] removes the advanced scanner module from [holder].", "You remove the advanced scanner module from [holder].")
				new /obj/item/weapon/stock_parts/scanning_module/adv(get_turf(holder))
				holder.icon_state = "durand10"
		if(8)
			if(diff==FORWARD)
				user.visible_message("[user] installs advanced capacitor to [holder].", "You install advanced capacitor to [holder].")
				qdel(I)
				holder.icon_state = "durand13"
			else
				user.visible_message("[user] unfastens the advanced scanner module.", "You unfasten the advanced scanner module.")
				holder.icon_state = "durand11"
		if(7)
			if(diff==FORWARD)
				user.visible_message("[user] secures the advanced capacitor.", "You secure the advanced capacitor.")
				holder.icon_state = "durand14"
			else
				user.visible_message("[user] removes the advanced capacitor from [holder].", "You remove the advanced capacitor from [holder].")
				new /obj/item/weapon/stock_parts/capacitor/adv(get_turf(holder))
				holder.icon_state = "durand12"
		if(6)
			if(diff==FORWARD)
				user.visible_message("[user] installs internal armor layer to [holder].", "You install internal armor layer to [holder].")
				holder.icon_state = "durand15"
			else
				user.visible_message("[user] unfastens the advanced capacitor.", "You unfasten the advanced capacitor.")
				holder.icon_state = "durand13"
		if(5)
			if(diff==FORWARD)
				user.visible_message("[user] secures internal armor layer.", "You secure internal armor layer.")
				holder.icon_state = "durand16"
			else
				user.visible_message("[user] pries internal armor layer from [holder].", "You prie internal armor layer from [holder].")
				new /obj/item/stack/material/steel(get_turf(holder), 5)
				holder.icon_state = "durand14"
		if(4)
			if(diff==FORWARD)
				user.visible_message("[user] welds internal armor layer to [holder].", "You weld the internal armor layer to [holder].")
				holder.icon_state = "durand17"
			else
				user.visible_message("[user] unfastens the internal armor layer.", "You unfasten the internal armor layer.")
				holder.icon_state = "durand15"
		if(3)
			if(diff==FORWARD)
				user.visible_message("[user] installs Durand Armour Plates to [holder].", "You install Durand Armour Plates to [holder].")
				qdel(I)
				holder.icon_state = "durand18"
			else
				user.visible_message("[user] cuts internal armor layer from [holder].", "You cut the internal armor layer from [holder].")
				holder.icon_state = "durand16"
		if(2)
			if(diff==FORWARD)
				user.visible_message("[user] secures Durand Armour Plates.", "You secure Durand Armour Plates.")
				holder.icon_state = "durand19"
			else
				user.visible_message("[user] pries Durand Armour Plates from [holder].", "You prie Durand Armour Plates from [holder].")
				new /obj/item/mecha_parts/part/durand_armour(get_turf(holder))
				holder.icon_state = "durand17"
		if(1)
			if(diff==FORWARD)
				user.visible_message("[user] welds Durand Armour Plates to [holder].", "You weld Durand Armour Plates to [holder].")
			else
				user.visible_message("[user] unfastens Durand Armour Plates.", "You unfasten Durand Armour Plates.")
				holder.icon_state = "durand18"
	return 1

/datum/construction/reversible/mecha/durand/spawn_result()
	..()
	feedback_inc("mecha_durand_created",1)
	return

////////////////////////
//		Odysseus
////////////////////////
/datum/construction/mecha/odysseus_chassis
	steps = list(list("key"=/obj/item/mecha_parts/part/odysseus_torso),//1
					 list("key"=/obj/item/mecha_parts/part/odysseus_head),//2
					 list("key"=/obj/item/mecha_parts/part/odysseus_left_arm),//3
					 list("key"=/obj/item/mecha_parts/part/odysseus_right_arm),//4
					 list("key"=/obj/item/mecha_parts/part/odysseus_left_leg),//5
					 list("key"=/obj/item/mecha_parts/part/odysseus_right_leg)//6
					)

/datum/construction/mecha/odysseus_chassis/custom_action(step, obj/item/I, mob/user)
	user.visible_message("[user] has connected [I] to [holder].", "You connect [I] to [holder]")
	holder.add_overlay(I.icon_state+"+o")
	qdel(I)
	return 1

/datum/construction/mecha/odysseus_chassis/action(obj/item/I,mob/user as mob)
	return check_all_steps(I,user)

/datum/construction/mecha/odysseus_chassis/spawn_result()
	var/obj/item/mecha_parts/chassis/const_holder = holder
	const_holder.construct = new /datum/construction/reversible/mecha/odysseus(const_holder)
	const_holder.icon = 'icons/mecha/mech_construction.dmi'
	const_holder.icon_state = "odysseus0"
	const_holder.density = TRUE
	spawn()
		qdel(src)
	return


/datum/construction/reversible/mecha/odysseus
	result = "/obj/mecha/medical/odysseus"
	steps = list(
					//1
					list("key"=IS_WELDER,
							"backkey"=IS_WRENCH,
							"desc"="External armor is wrenched."),
					//2
					 list("key"=IS_WRENCH,
					 		"backkey"=IS_CROWBAR,
					 		"desc"="External armor is installed."),
					 //3
					 list("key"=/obj/item/stack/material/plasteel,
					 		"backkey"=IS_WELDER,
					 		"desc"="Internal armor is welded."),
					 //4
					 list("key"=IS_WELDER,
					 		"backkey"=IS_WRENCH,
					 		"desc"="Internal armor is wrenched"),
					 //5
					 list("key"=IS_WRENCH,
					 		"backkey"=IS_CROWBAR,
					 		"desc"="Internal armor is installed"),
					 //6
					 list("key"=/obj/item/stack/material/steel,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="Peripherals control module is secured"),
					 //7
					 list("key"=IS_SCREWDRIVER,
					 		"backkey"=IS_CROWBAR,
					 		"desc"="Peripherals control module is installed"),
					 //8
					 list("key"=/obj/item/weapon/circuitboard/mecha/odysseus/peripherals,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="Central control module is secured"),
					 //9
					 list("key"=IS_SCREWDRIVER,
					 		"backkey"=IS_CROWBAR,
					 		"desc"="Central control module is installed"),
					 //10
					 list("key"=/obj/item/weapon/circuitboard/mecha/odysseus/main,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="The wiring is adjusted"),
					 //11
					 list("key"=/obj/item/weapon/tool/wirecutters,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="The wiring is added"),
					 //12
					 list("key"=/obj/item/stack/cable_coil,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="The hydraulic systems are active."),
					 //13
					 list("key"=IS_SCREWDRIVER,
					 		"backkey"=IS_WRENCH,
					 		"desc"="The hydraulic systems are connected."),
					 //14
					 list("key"=IS_WRENCH,
					 		"desc"="The hydraulic systems are disconnected.")
					)

/datum/construction/reversible/mecha/odysseus/action(obj/item/I,mob/user as mob)
	return check_step(I,user)

/datum/construction/reversible/mecha/odysseus/custom_action(index, diff, obj/item/I, mob/user)
	if(!..())
		return 0

	//TODO: better messages.
	switch(index)
		if(14)
			user.visible_message("[user] connects [holder] hydraulic systems", "You connect [holder] hydraulic systems.")
			holder.icon_state = "odysseus1"
		if(13)
			if(diff==FORWARD)
				user.visible_message("[user] activates [holder] hydraulic systems.", "You activate [holder] hydraulic systems.")
				holder.icon_state = "odysseus2"
			else
				user.visible_message("[user] disconnects [holder] hydraulic systems", "You disconnect [holder] hydraulic systems.")
				holder.icon_state = "odysseus0"
		if(12)
			if(diff==FORWARD)
				user.visible_message("[user] adds the wiring to [holder].", "You add the wiring to [holder].")
				holder.icon_state = "odysseus3"
			else
				user.visible_message("[user] deactivates [holder] hydraulic systems.", "You deactivate [holder] hydraulic systems.")
				holder.icon_state = "odysseus1"
		if(11)
			if(diff==FORWARD)
				user.visible_message("[user] adjusts the wiring of [holder].", "You adjust the wiring of [holder].")
				holder.icon_state = "odysseus4"
			else
				user.visible_message("[user] removes the wiring from [holder].", "You remove the wiring from [holder].")
				new /obj/item/stack/cable_coil(get_turf(holder), 4)
				holder.icon_state = "odysseus2"
		if(10)
			if(diff==FORWARD)
				user.visible_message("[user] installs the central control module into [holder].", "You install the central computer mainboard into [holder].")
				qdel(I)
				holder.icon_state = "odysseus5"
			else
				user.visible_message("[user] disconnects the wiring of [holder].", "You disconnect the wiring of [holder].")
				holder.icon_state = "odysseus3"
		if(9)
			if(diff==FORWARD)
				user.visible_message("[user] secures the mainboard.", "You secure the mainboard.")
				holder.icon_state = "odysseus6"
			else
				user.visible_message("[user] removes the central control module from [holder].", "You remove the central computer mainboard from [holder].")
				new /obj/item/weapon/circuitboard/mecha/odysseus/main(get_turf(holder))
				holder.icon_state = "odysseus4"
		if(8)
			if(diff==FORWARD)
				user.visible_message("[user] installs the peripherals control module into [holder].", "You install the peripherals control module into [holder].")
				qdel(I)
				holder.icon_state = "odysseus7"
			else
				user.visible_message("[user] unfastens the mainboard.", "You unfasten the mainboard.")
				holder.icon_state = "odysseus5"
		if(7)
			if(diff==FORWARD)
				user.visible_message("[user] secures the peripherals control module.", "You secure the peripherals control module.")
				holder.icon_state = "odysseus8"
			else
				user.visible_message("[user] removes the peripherals control module from [holder].", "You remove the peripherals control module from [holder].")
				new /obj/item/weapon/circuitboard/mecha/odysseus/peripherals(get_turf(holder))
				holder.icon_state = "odysseus6"
		if(6)
			if(diff==FORWARD)
				user.visible_message("[user] installs internal armor layer to [holder].", "You install internal armor layer to [holder].")
				holder.icon_state = "odysseus9"
			else
				user.visible_message("[user] unfastens the peripherals control module.", "You unfasten the peripherals control module.")
				holder.icon_state = "odysseus7"
		if(5)
			if(diff==FORWARD)
				user.visible_message("[user] secures internal armor layer.", "You secure internal armor layer.")
				holder.icon_state = "odysseus10"
			else
				user.visible_message("[user] pries internal armor layer from [holder].", "You prie internal armor layer from [holder].")
				new /obj/item/stack/material/steel(get_turf(holder), 5)
				holder.icon_state = "odysseus8"
		if(4)
			if(diff==FORWARD)
				user.visible_message("[user] welds internal armor layer to [holder].", "You weld the internal armor layer to [holder].")
				holder.icon_state = "odysseus11"
			else
				user.visible_message("[user] unfastens the internal armor layer.", "You unfasten the internal armor layer.")
				holder.icon_state = "odysseus9"
		if(3)
			if(diff==FORWARD)
				user.visible_message("[user] installs [I] layer to [holder].", "You install external reinforced armor layer to [holder].")
				holder.icon_state = "odysseus12"
			else
				user.visible_message("[user] cuts internal armor layer from [holder].", "You cut the internal armor layer from [holder].")
				holder.icon_state = "odysseus10"
		if(2)
			if(diff==FORWARD)
				user.visible_message("[user] secures external armor layer.", "You secure external reinforced armor layer.")
				holder.icon_state = "odysseus13"
			else
				new /obj/item/stack/material/plasteel(get_turf(holder), 5)
				user.visible_message("[user] pries the plasteel from [holder].", "You prie the plasteel from [holder].")
				holder.icon_state = "odysseus11"
		if(1)
			if(diff==FORWARD)
				user.visible_message("[user] welds external armor layer to [holder].", "You weld external armor layer to [holder].")
				holder.icon_state = "odysseus14"
			else
				user.visible_message("[user] unfastens the external armor layer.", "You unfasten the external armor layer.")
				holder.icon_state = "odysseus12"
	return 1

/datum/construction/reversible/mecha/odysseus/spawn_result()
	..()
	feedback_inc("mecha_odysseus_created",1)
	return

//////////////////////
//		Phazon
//////////////////////
/datum/construction/mecha/phazon_chassis
	result = "/obj/mecha/combat/phazon"
	steps = list(list("key"=/obj/item/mecha_parts/part/phazon_torso),//1
					 list("key"=/obj/item/mecha_parts/part/phazon_left_arm),//2
					 list("key"=/obj/item/mecha_parts/part/phazon_right_arm),//3
					 list("key"=/obj/item/mecha_parts/part/phazon_left_leg),//4
					 list("key"=/obj/item/mecha_parts/part/phazon_right_leg),//5
					 list("key"=/obj/item/mecha_parts/part/phazon_head)
					)

/datum/construction/mecha/phazon_chassis/custom_action(step, obj/item/I, mob/user)
	user.visible_message("[user] has connected [I] to [holder].", "You connect [I] to [holder]")
	holder.add_overlay(I.icon_state+"+o")
	qdel(I)
	return 1

/datum/construction/mecha/phazon_chassis/action(obj/item/I,mob/user as mob)
	return check_all_steps(I,user)

/datum/construction/mecha/phazon_chassis/spawn_result()
	var/obj/item/mecha_parts/chassis/const_holder = holder
	const_holder.construct = new /datum/construction/reversible/mecha/phazon(const_holder)
	const_holder.icon = 'icons/mecha/mech_construction.dmi'
	const_holder.icon_state = "phazon0"
	const_holder.density = TRUE
	spawn()
		qdel(src)
	return

/datum/construction/reversible/mecha/phazon
	result = "/obj/mecha/combat/phazon"
	steps = list(
					//1
					list("key"=IS_WELDER,
							"backkey"=IS_WRENCH,
							"desc"="External armor is wrenched."),
					//2
					list("key"=IS_WRENCH,
							"backkey"=IS_CROWBAR,
							"desc"="External armor is installed."),
					//3
					list("key"=/obj/item/stack/material/plasteel,
							"backkey"=IS_WELDER,
							"desc"="Internal armor is welded."),
					//4
					list("key"=IS_WELDER,
							"backkey"=IS_WRENCH,
							"desc"="Internal armor is wrenched"),
					//5
					list("key"=IS_WRENCH,
							"backkey"=IS_CROWBAR,
							"desc"="Internal armor is installed"),
					//6
					list("key"=/obj/item/stack/material/steel,
							"backkey"=IS_SCREWDRIVER,
							"desc"="Hand teleporter is secured"),
					//7
					list("key"=IS_SCREWDRIVER,
							"backkey"=IS_CROWBAR,
							"desc"="Hand teleporter is installed"),
					//8
					list("key"=/obj/item/weapon/hand_tele,
							"backkey"=IS_SCREWDRIVER,
							"desc"="SMES coil is secured"),
					//9
					list("key"=IS_SCREWDRIVER,
							"backkey"=IS_CROWBAR,
							"desc"="SMES coil is installed"),
					//10
					list("key"=/obj/item/weapon/smes_coil/super_capacity,
							"backkey"=IS_SCREWDRIVER,
							"desc"="Targeting module is secured"),
					//11
					list("key"=IS_SCREWDRIVER,
							"backkey"=IS_CROWBAR,
							"desc"="Targeting module is installed"),
					//12
					list("key"=/obj/item/weapon/circuitboard/mecha/phazon/targeting,
							"backkey"=IS_SCREWDRIVER,
							"desc"="Peripherals control module is secured"),
					//13
					list("key"=IS_SCREWDRIVER,
							"backkey"=IS_CROWBAR,
							"desc"="Peripherals control module is installed"),
					//14
					list("key"=/obj/item/weapon/circuitboard/mecha/phazon/peripherals,
							"backkey"=IS_SCREWDRIVER,
							"desc"="Central control module is secured"),
					//15
					list("key"=IS_SCREWDRIVER,
							"backkey"=IS_CROWBAR,
							"desc"="Central control module is installed"),
					//16
					list("key"=/obj/item/weapon/circuitboard/mecha/phazon/main,
							"backkey"=IS_SCREWDRIVER,
							"desc"="The wiring is adjusted"),
					//17
					list("key"=/obj/item/weapon/tool/wirecutters,
							"backkey"=IS_SCREWDRIVER,
							"desc"="The wiring is added"),
					//18
					list("key"=/obj/item/stack/cable_coil,
							"backkey"=IS_SCREWDRIVER,
							"desc"="The hydraulic systems are active."),
					//19
					list("key"=IS_SCREWDRIVER,
							"backkey"=IS_WRENCH,
							"desc"="The hydraulic systems are connected."),
					//20
					list("key"=IS_WRENCH,
							"desc"="The hydraulic systems are disconnected.")
					)

/datum/construction/reversible/mecha/phazon/action(obj/item/I,mob/user as mob)
	return check_step(I,user)

/datum/construction/reversible/mecha/phazon/custom_action(index, diff, obj/item/I, mob/user)
	if(!..())
		return 0

	switch(index)
		if(20)
			user.visible_message("[user] connects [holder] hydraulic systems", "You connect [holder] hydraulic systems.")
			holder.icon_state = "phazon1"
		if(19)
			if(diff==FORWARD)
				user.visible_message("[user] activates [holder] hydraulic systems.", "You activate [holder] hydraulic systems.")
				holder.icon_state = "phazon2"
			else
				user.visible_message("[user] disconnects [holder] hydraulic systems", "You disconnect [holder] hydraulic systems.")
				holder.icon_state = "phazon0"
		if(18)
			if(diff==FORWARD)
				user.visible_message("[user] adds the wiring to [holder].", "You add the wiring to [holder].")
				holder.icon_state = "phazon3"
			else
				user.visible_message("[user] deactivates [holder] hydraulic systems.", "You deactivate [holder] hydraulic systems.")
				holder.icon_state = "phazon1"
		if(17)
			if(diff==FORWARD)
				user.visible_message("[user] adjusts the wiring of [holder].", "You adjust the wiring of [holder].")
				holder.icon_state = "phazon4"
			else
				user.visible_message("[user] removes the wiring from [holder].", "You remove the wiring from [holder].")
				new /obj/item/stack/cable_coil(get_turf(holder), 4)
				holder.icon_state = "phazon2"
		if(16)
			if(diff==FORWARD)
				user.visible_message("[user] installs the central control module into [holder].", "You install the central computer mainboard into [holder].")
				qdel(I)
				holder.icon_state = "phazon5"
			else
				user.visible_message("[user] disconnects the wiring of [holder].", "You disconnect the wiring of [holder].")
				holder.icon_state = "phazon3"
		if(15)
			if(diff==FORWARD)
				user.visible_message("[user] secures the mainboard.", "You secure the mainboard.")
				holder.icon_state = "phazon6"
			else
				user.visible_message("[user] removes the central control module from [holder].", "You remove the central computer mainboard from [holder].")
				new /obj/item/weapon/circuitboard/mecha/phazon/main(get_turf(holder))
				holder.icon_state = "phazon4"
		if(14)
			if(diff==FORWARD)
				user.visible_message("[user] installs the peripherals control module into [holder].", "You install the peripherals control module into [holder].")
				qdel(I)
				holder.icon_state = "phazon7"
			else
				user.visible_message("[user] unfastens the mainboard.", "You unfasten the mainboard.")
				holder.icon_state = "phazon5"
		if(13)
			if(diff==FORWARD)
				user.visible_message("[user] secures the peripherals control module.", "You secure the peripherals control module.")
				holder.icon_state = "phazon8"
			else
				user.visible_message("[user] removes the peripherals control module from [holder].", "You remove the peripherals control module from [holder].")
				new /obj/item/weapon/circuitboard/mecha/phazon/peripherals(get_turf(holder))
				holder.icon_state = "phazon6"
		if(12)
			if(diff==FORWARD)
				user.visible_message("[user] installs the weapon control module into [holder].", "You install the weapon control module into [holder].")
				qdel(I)
				holder.icon_state = "phazon9"
			else
				user.visible_message("[user] unfastens the peripherals control module.", "You unfasten the peripherals control module.")
				holder.icon_state = "phazon7"
		if(11)
			if(diff==FORWARD)
				user.visible_message("[user] secures the weapon control module.", "You secure the weapon control module.")
				holder.icon_state = "phazon10"
			else
				user.visible_message("[user] removes the weapon control module from [holder].", "You remove the weapon control module from [holder].")
				new /obj/item/weapon/circuitboard/mecha/phazon/targeting(get_turf(holder))
				holder.icon_state = "phazon8"
		if(10)
			if(diff==FORWARD)
				user.visible_message("[user] installs the SMES coil to [holder].", "You install the SMES coil to [holder].")
				qdel(I)
				holder.icon_state = "phazon11"
			else
				user.visible_message("[user] unfastens the weapon control module.", "You unfasten the weapon control module.")
				holder.icon_state = "phazon9"
		if(9)
			if(diff==FORWARD)
				user.visible_message("[user] secures the SMES coil.", "You secure the SMES coil.")
				holder.icon_state = "phazon12"
			else
				user.visible_message("[user] removes the SMES coil from [holder].", "You remove the SMES coil from [holder].")
				new /obj/item/weapon/smes_coil/super_capacity(get_turf(holder))
				holder.icon_state = "phazon10"
		if(8)
			if(diff==FORWARD)
				user.visible_message("[user] installs the hand teleporter to [holder].", "You install the hand teleporter to [holder].")
				qdel(I)
				holder.icon_state = "phazon13"
			else
				user.visible_message("[user] unfastens the SMES coil.", "You unfasten the SMES coil.")
				holder.icon_state = "phazon11"
		if(7)
			if(diff==FORWARD)
				user.visible_message("[user] secures the hand teleporter.", "You secure the hand teleporter.")
				holder.icon_state = "phazon14"
			else
				user.visible_message("[user] removes the hand teleporter from [holder].", "You remove the hand teleporter from [holder].")
				new /obj/item/weapon/hand_tele(get_turf(holder))
				holder.icon_state = "phazon12"
		if(6)
			if(diff==FORWARD)
				user.visible_message("[user] installs the internal armor layer to [holder].", "You install the internal armor layer to [holder].")
				holder.icon_state = "phazon19"
			else
				user.visible_message("[user] unfastens the hand teleporter.", "You unfasten the hand teleporter.")
				holder.icon_state = "phazon13"
		if(5)
			if(diff==FORWARD)
				user.visible_message("[user] secures the internal armor layer.", "You secure the internal armor layer.")
				holder.icon_state = "phazon20"
			else
				user.visible_message("[user] pries the internal armor layer from [holder].", "You pry the internal armor layer from [holder].")
				new /obj/item/stack/material/steel(get_turf(holder), 5)
				holder.icon_state = "phazon14"
		if(4)
			if(diff==FORWARD)
				user.visible_message("[user] welds the internal armor layer to [holder].", "You weld the internal armor layer to [holder].")
				holder.icon_state = "phazon21"
			else
				user.visible_message("[user] unfastens the internal armor layer.", "You unfasten the internal armor layer.")
				holder.icon_state = "phazon19"
		if(3)
			if(diff==FORWARD)
				user.visible_message("[user] installs the external reinforced armor layer to [holder].", "You install the external reinforced armor layer to [holder].")
				holder.icon_state = "phazon22"
			else
				user.visible_message("[user] cuts internal armor layer from [holder].", "You cut the internal armor layer from [holder].")
				holder.icon_state = "phazon20"
		if(2)
			if(diff==FORWARD)
				user.visible_message("[user] secures external armor layer.", "You secure external reinforced armor layer.")
				holder.icon_state = "phazon23"
			else
				user.visible_message("[user] pries the external armor layer from [holder].", "You pry external armor layer from [holder].")
				new /obj/item/stack/material/plasteel(get_turf(holder), 5)
				holder.icon_state = "phazon21"
		if(1)
			if(diff==FORWARD)
				user.visible_message("[user] welds the external armor layer to [holder].", "You weld the external armor layer to [holder].")
			else
				user.visible_message("[user] unfastens the external armor layer.", "You unfasten the external armor layer.")
				holder.icon_state = "phazon22"
	return 1

/datum/construction/reversible/mecha/phazon/spawn_result()
	..()
	feedback_inc("mecha_phazon_created",1)
	return

//////////////////////
//		Janus
//////////////////////
/datum/construction/mecha/janus_chassis
	result = "/obj/mecha/combat/phazon/janus"
	steps = list(list("key"=/obj/item/mecha_parts/part/janus_torso),//1
					 list("key"=/obj/item/mecha_parts/part/janus_left_arm),//2
					 list("key"=/obj/item/mecha_parts/part/janus_right_arm),//3
					 list("key"=/obj/item/mecha_parts/part/janus_left_leg),//4
					 list("key"=/obj/item/mecha_parts/part/janus_right_leg),//5
					 list("key"=/obj/item/mecha_parts/part/janus_head)
					)

/datum/construction/mecha/janus_chassis/custom_action(step, obj/item/I, mob/user)
	user.visible_message("[user] has connected [I] to [holder].", "You connect [I] to [holder]")
	holder.add_overlay(I.icon_state+"+o")
	qdel(I)
	return 1

/datum/construction/mecha/janus_chassis/action(obj/item/I,mob/user as mob)
	return check_all_steps(I,user)

/datum/construction/mecha/janus_chassis/spawn_result()
	var/obj/item/mecha_parts/chassis/const_holder = holder
	const_holder.construct = new /datum/construction/reversible/mecha/janus(const_holder)
	const_holder.icon = 'icons/mecha/mech_construction.dmi'
	const_holder.icon_state = "janus0"
	const_holder.density = TRUE
	spawn()
		qdel(src)
	return

/datum/construction/reversible/mecha/janus
	result = "/obj/mecha/combat/phazon/janus"
	steps = list(
					//1
					list("key"=IS_WELDER,
							"backkey"=IS_CROWBAR,
							"desc"="External armor is installed."),
					//2
					list("key"=IS_WRENCH,
							"backkey"=IS_CROWBAR,
							"desc"="External armor is attached."),
					//3
					list("key"=/obj/item/stack/material/morphium,
							"backkey"=IS_WELDER,
							"desc"="Internal armor is welded"),
					//4
					list("key"=IS_WELDER,
							"backkey"=IS_CROWBAR,
							"desc"="Internal armor is wrenched"),
					//5
					list("key"=IS_WRENCH,
							"backkey"=IS_CROWBAR,
							"desc"="Internal armor is attached."),
					//6
					list("key"=/obj/item/stack/material/durasteel,
							"backkey"=IS_SCREWDRIVER,
							"desc"="Durand auxiliary board is secured."),
					//7
					list("key"=IS_SCREWDRIVER,
							"backkey"=IS_CROWBAR,
							"desc"="Durand auxiliary board is installed"),
					//8
					list("key"=/obj/item/weapon/circuitboard/mecha/durand/peripherals,
							"backkey"=IS_SCREWDRIVER,
							"desc"="Phase coil is secured"),
					//9
					list("key"=IS_SCREWDRIVER,
							"backkey"=IS_CROWBAR,
							"desc"="Phase coil is installed"),
					//10
					list("key"=/obj/item/prop/alien/phasecoil,
							"backkey"=IS_SCREWDRIVER,
							"desc"="Gygax balance system secured"),
					//11
					list("key"=IS_SCREWDRIVER,
							"backkey"=IS_CROWBAR,
							"desc"="Gygax balance system installed"),
					//12
					list("key"=/obj/item/weapon/circuitboard/mecha/gygax/peripherals,
							"backkey"=IS_SCREWDRIVER,
							"desc"="Targeting module is secured"),
					//13
					list("key"=IS_SCREWDRIVER,
							"backkey"=IS_CROWBAR,
							"desc"="Targeting module is installed"),
					//14
					list("key"=/obj/item/weapon/circuitboard/mecha/imperion/targeting,
							"backkey"=IS_SCREWDRIVER,
							"desc"="Peripherals control module is secured"),
					//15
					list("key"=IS_SCREWDRIVER,
							"backkey"=IS_CROWBAR,
							"desc"="Peripherals control module is installed"),
					//16
					list("key"=/obj/item/weapon/circuitboard/mecha/imperion/peripherals,
							"backkey"=IS_SCREWDRIVER,
							"desc"="Central control module is secured"),
					//17
					list("key"=IS_SCREWDRIVER,
							"backkey"=IS_CROWBAR,
							"desc"="Central control module is installed"),
					//18
					list("key"=/obj/item/weapon/circuitboard/mecha/imperion/main,
							"backkey"=IS_SCREWDRIVER,
							"desc"="The wiring is adjusted"),
					//19
					list("key"=/obj/item/weapon/tool/wirecutters,
							"backkey"=IS_SCREWDRIVER,
							"desc"="The wiring is added"),
					//20
					list("key"=/obj/item/stack/cable_coil,
							"backkey"=IS_SCREWDRIVER,
							"desc"="The hydraulic systems are active."),
					//21
					list("key"=IS_SCREWDRIVER,
							"backkey"=IS_WRENCH,
							"desc"="The hydraulic systems are connected."),
					//22
					list("key"=IS_WRENCH,
							"desc"="The hydraulic systems are disconnected.")
					)

/datum/construction/reversible/mecha/janus/action(obj/item/I,mob/user as mob)
	return check_step(I,user)

/datum/construction/reversible/mecha/janus/custom_action(index, diff, obj/item/I, mob/user)
	if(!..())
		return 0

	switch(index)
		if(22)
			user.visible_message("[user] connects [holder] hydraulic systems", "You connect [holder] hydraulic systems.")
			holder.icon_state = "janus1"
		if(21)
			if(diff==FORWARD)
				user.visible_message("[user] activates [holder] hydraulic systems.", "You activate [holder] hydraulic systems.")
				holder.icon_state = "janus2"
			else
				user.visible_message("[user] disconnects [holder] hydraulic systems", "You disconnect [holder] hydraulic systems.")
				holder.icon_state = "janus0"
		if(20)
			if(diff==FORWARD)
				user.visible_message("[user] adds the wiring to [holder].", "You add the wiring to [holder].")
				holder.icon_state = "janus3"
			else
				user.visible_message("[user] deactivates [holder] hydraulic systems.", "You deactivate [holder] hydraulic systems.")
				holder.icon_state = "janus1"
		if(19)
			if(diff==FORWARD)
				user.visible_message("[user] adjusts the wiring of [holder].", "You adjust the wiring of [holder].")
				holder.icon_state = "janus4"
			else
				user.visible_message("[user] removes the wiring from [holder].", "You remove the wiring from [holder].")
				new /obj/item/stack/cable_coil(get_turf(holder), 4)
				holder.icon_state = "janus2"
		if(18)
			if(diff==FORWARD)
				user.visible_message("[user] installs the central control module into [holder].", "You install the central computer mainboard into [holder].")
				qdel(I)
				holder.icon_state = "janus5"
			else
				user.visible_message("[user] disconnects the wiring of [holder].", "You disconnect the wiring of [holder].")
				holder.icon_state = "janus3"
		if(17)
			if(diff==FORWARD)
				user.visible_message("[user] secures the mainboard.", "You secure the mainboard.")
				holder.icon_state = "janus6"
			else
				user.visible_message("[user] removes the central control module from [holder].", "You remove the central computer mainboard from [holder].")
				new /obj/item/weapon/circuitboard/mecha/imperion/main(get_turf(holder))
				holder.icon_state = "janus4"
		if(16)
			if(diff==FORWARD)
				user.visible_message("[user] installs the peripherals control module into [holder].", "You install the peripherals control module into [holder].")
				qdel(I)
				holder.icon_state = "janus7"
			else
				user.visible_message("[user] unfastens the mainboard.", "You unfasten the mainboard.")
				holder.icon_state = "janus5"
		if(15)
			if(diff==FORWARD)
				user.visible_message("[user] secures the peripherals control module.", "You secure the peripherals control module.")
				holder.icon_state = "janus8"
			else
				user.visible_message("[user] removes the peripherals control module from [holder].", "You remove the peripherals control module from [holder].")
				new /obj/item/weapon/circuitboard/mecha/imperion/peripherals(get_turf(holder))
				holder.icon_state = "janus6"
		if(14)
			if(diff==FORWARD)
				user.visible_message("[user] installs the weapon control module into [holder].", "You install the weapon control module into [holder].")
				qdel(I)
				holder.icon_state = "janus9"
			else
				user.visible_message("[user] unfastens the peripherals control module.", "You unfasten the peripherals control module.")
				holder.icon_state = "janus7"
		if(13)
			if(diff==FORWARD)
				user.visible_message("[user] secures the weapon control module.", "You secure the weapon control module.")
				holder.icon_state = "janus10"
			else
				user.visible_message("[user] removes the weapon control module from [holder].", "You remove the weapon control module from [holder].")
				new /obj/item/weapon/circuitboard/mecha/imperion/targeting(get_turf(holder))
				holder.icon_state = "janus8"
		if(12)
			if(diff==FORWARD)
				user.visible_message("[user] installs the Gygax control module into [holder].", "You install the Gygax control module into [holder].")
				qdel(I)
				holder.icon_state = "janus11"
			else
				user.visible_message("[user] unfastens the Gygax control module.", "You unfasten the Gygax control module.")
				holder.icon_state = "janus9"
		if(11)
			if(diff==FORWARD)
				user.visible_message("[user] secures the Gygax control module.", "You secure the Gygax control module.")
				holder.icon_state = "janus12"
			else
				user.visible_message("[user] removes the Gygax control module from [holder].", "You remove the Gygax control module from [holder].")
				new /obj/item/weapon/circuitboard/mecha/gygax/peripherals(get_turf(holder))
				holder.icon_state = "janus10"
		if(10)
			if(diff==FORWARD)
				user.visible_message("[user] installs the phase coil into [holder].", "You install the phase coil into [holder].")
				qdel(I)
				holder.icon_state = "janus13"
			else
				user.visible_message("[user] unfastens the Gygax control module.", "You unfasten the Gygax control module.")
				holder.icon_state = "janus11"
		if(9)
			if(diff==FORWARD)
				user.visible_message("[user] secures the phase coil.", "You secure the phase coil.")
				holder.icon_state = "janus14"
			else
				user.visible_message("[user] removes the phase coil from [holder].", "You remove the phase coil from [holder].")
				new /obj/item/prop/alien/phasecoil(get_turf(holder))
				holder.icon_state = "janus12"
		if(8)
			if(diff==FORWARD)
				user.visible_message("[user] installs the Durand control module into [holder].", "You install the Durand control module into [holder].")
				qdel(I)
				holder.icon_state = "janus15"
			else
				user.visible_message("[user] unfastens the phase coil.", "You unfasten the phase coil.")
				holder.icon_state = "janus13"
		if(7)
			if(diff==FORWARD)
				user.visible_message("[user] secures the Durand control module.", "You secure the Durand control module.")
				holder.icon_state = "janus16"
			else
				user.visible_message("[user] removes the Durand control module from [holder].", "You remove the Durand control module from [holder].")
				new /obj/item/weapon/circuitboard/mecha/durand/peripherals(get_turf(holder))
				holder.icon_state = "janus14"
		if(6)
			if(diff==FORWARD)
				user.visible_message("[user] installs the internal armor layer to [holder].", "You install the internal armor layer to [holder].")
				holder.icon_state = "janus17"
			else
				user.visible_message("[user] unfastens the Durand control module.", "You unfasten the Durand control module.")
				holder.icon_state = "janus15"
		if(5)
			if(diff==FORWARD)
				user.visible_message("[user] secures the internal armor layer.", "You secure the internal armor layer.")
				holder.icon_state = "janus18"
			else
				user.visible_message("[user] pries the internal armor layer from [holder].", "You pry the internal armor layer from [holder].")
				new /obj/item/stack/material/durasteel(get_turf(holder), 5)
				holder.icon_state = "janus16"
		if(4)
			if(diff==FORWARD)
				user.visible_message("[user] welds the internal armor layer to [holder].", "You weld the internal armor layer to [holder].")
				holder.icon_state = "janus19"
			else
				user.visible_message("[user] unfastens the internal armor layer.", "You unfasten the internal armor layer.")
				holder.icon_state = "janus17"
		if(3)
			if(diff==FORWARD)
				user.visible_message("[user] installs the external reinforced armor layer to [holder].", "You install the external reinforced armor layer to [holder].")
				holder.icon_state = "janus20"
			else
				user.visible_message("[user] cuts internal armor layer from [holder].", "You cut the internal armor layer from [holder].")
				holder.icon_state = "janus18"
		if(2)
			if(diff==FORWARD)
				user.visible_message("[user] secures external armor layer.", "You secure external reinforced armor layer.")
				holder.icon_state = "janus21"
			else
				user.visible_message("[user] pries the external armor layer from [holder].", "You pry external armor layer from [holder].")
				new /obj/item/stack/material/morphium(get_turf(holder), 5)
				holder.icon_state = "janus19"
		if(1)
			if(diff==FORWARD)
				user.visible_message("[user] welds the external armor layer to [holder].", "You weld the external armor layer to [holder].")
			else
				user.visible_message("[user] unfastens the external armor layer.", "You unfasten the external armor layer.")
				holder.icon_state = "janus20"
	return 1

/datum/construction/reversible/mecha/janus/spawn_result()
	..()
	feedback_inc("mecha_janus_created",1)
	return
