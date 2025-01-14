////////////////////////////////
///// Construction datums //////
////////////////////////////////

/datum/construction/mecha/custom_action(step, obj/item/I, mob/user)
	if(I.has_tool_quality(TOOL_WELDER))
		var/obj/item/weldingtool/W = I.get_welder()
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
		var/obj/item/weldingtool/W = I.get_welder()
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
	user.visible_message(span_infoplain("[user] has connected [I] to [holder]."), span_infoplain("You connect [I] to [holder]"))
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
					 list("key"=/obj/item/circuitboard/mecha/ripley/peripherals,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="Central control module is secured"),
					 //9
					 list("key"=IS_SCREWDRIVER,
					 		"backkey"=IS_CROWBAR,
					 		"desc"="Central control module is installed"),
					 //10
					 list("key"=/obj/item/circuitboard/mecha/ripley/main,
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
			user.visible_message(span_infoplain("[user] connects [holder] hydraulic systems"), span_infoplain("You connect [holder] hydraulic systems."))
			holder.icon_state = "ripley1"
		if(13)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] activates [holder] hydraulic systems."), span_infoplain("You activate [holder] hydraulic systems."))
				holder.icon_state = "ripley2"
			else
				user.visible_message(span_infoplain("[user] disconnects [holder] hydraulic systems"), span_infoplain("You disconnect [holder] hydraulic systems."))
				holder.icon_state = "ripley0"
		if(12)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] adds the wiring to [holder]."), span_infoplain("You add the wiring to [holder]."))
				holder.icon_state = "ripley3"
			else
				user.visible_message(span_infoplain("[user] deactivates [holder] hydraulic systems."), span_infoplain("You deactivate [holder] hydraulic systems."))
				holder.icon_state = "ripley1"
		if(11)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] adjusts the wiring of [holder]."), span_infoplain("You adjust the wiring of [holder]."))
				holder.icon_state = "ripley4"
			else
				user.visible_message(span_infoplain("[user] removes the wiring from [holder]."), span_infoplain("You remove the wiring from [holder]."))
				new /obj/item/stack/cable_coil(get_turf(holder), 4)
				holder.icon_state = "ripley2"
		if(10)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] installs the central control module into [holder]."), span_infoplain("You install the central computer mainboard into [holder]."))
				qdel(I)
				holder.icon_state = "ripley5"
			else
				user.visible_message(span_infoplain("[user] disconnects the wiring of [holder]."), span_infoplain("You disconnect the wiring of [holder]."))
				holder.icon_state = "ripley3"
		if(9)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] secures the mainboard."), span_infoplain("You secure the mainboard."))
				holder.icon_state = "ripley6"
			else
				user.visible_message(span_infoplain("[user] removes the central control module from [holder]."), span_infoplain("You remove the central computer mainboard from [holder]."))
				new /obj/item/circuitboard/mecha/ripley/main(get_turf(holder))
				holder.icon_state = "ripley4"
		if(8)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] installs the peripherals control module into [holder]."), span_infoplain("You install the peripherals control module into [holder]."))
				qdel(I)
				holder.icon_state = "ripley7"
			else
				user.visible_message(span_infoplain("[user] unfastens the mainboard."), span_infoplain("You unfasten the mainboard."))
				holder.icon_state = "ripley5"
		if(7)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] secures the peripherals control module."), span_infoplain("You secure the peripherals control module."))
				holder.icon_state = "ripley8"
			else
				user.visible_message(span_infoplain("[user] removes the peripherals control module from [holder]."), span_infoplain("You remove the peripherals control module from [holder]."))
				new /obj/item/circuitboard/mecha/ripley/peripherals(get_turf(holder))
				holder.icon_state = "ripley6"
		if(6)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] installs internal armor layer to [holder]."), span_infoplain("You install internal armor layer to [holder]."))
				holder.icon_state = "ripley9"
			else
				user.visible_message(span_infoplain("[user] unfastens the peripherals control module."), span_infoplain("You unfasten the peripherals control module."))
				holder.icon_state = "ripley7"
		if(5)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] secures internal armor layer."), span_infoplain("You secure internal armor layer."))
				holder.icon_state = "ripley10"
			else
				user.visible_message(span_infoplain("[user] pries internal armor layer from [holder]."), span_infoplain("You prie internal armor layer from [holder]."))
				new /obj/item/stack/material/steel(get_turf(holder), 5)
				holder.icon_state = "ripley8"
		if(4)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] welds internal armor layer to [holder]."), span_infoplain("You weld the internal armor layer to [holder]."))
				holder.icon_state = "ripley11"
			else
				user.visible_message(span_infoplain("[user] unfastens the internal armor layer."), span_infoplain("You unfasten the internal armor layer."))
				holder.icon_state = "ripley9"
		if(3)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] installs external reinforced armor layer to [holder]."), span_infoplain("You install external reinforced armor layer to [holder]."))
				holder.icon_state = "ripley12"
			else
				user.visible_message(span_infoplain("[user] cuts internal armor layer from [holder]."), span_infoplain("You cut the internal armor layer from [holder]."))
				holder.icon_state = "ripley10"
		if(2)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] secures external armor layer."), span_infoplain("You secure external reinforced armor layer."))
				holder.icon_state = "ripley13"
			else
				user.visible_message(span_infoplain("[user] pries external armor layer from [holder]."), span_infoplain("You prie external armor layer from [holder]."))
				new /obj/item/stack/material/plasteel(get_turf(holder), 5)
				holder.icon_state = "ripley11"
		if(1)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] welds external armor layer to [holder]."), span_infoplain("You weld external armor layer to [holder]."))
			else
				user.visible_message(span_infoplain("[user] unfastens the external armor layer."), span_infoplain("You unfasten the external armor layer."))
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
	user.visible_message(span_infoplain("[user] has connected [I] to [holder]."), span_infoplain("You connect [I] to [holder]"))
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
					 list("key"=/obj/item/stock_parts/capacitor/adv,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="Advanced scanner module is secured"),
					 //9
					 list("key"=IS_SCREWDRIVER,
					 		"backkey"=IS_CROWBAR,
					 		"desc"="Advanced scanner module is installed"),
					 //10
					 list("key"=/obj/item/stock_parts/scanning_module/adv,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="Targeting module is secured"),
					 //11
					 list("key"=IS_SCREWDRIVER,
					 		"backkey"=IS_CROWBAR,
					 		"desc"="Targeting module is installed"),
					 //12
					 list("key"=/obj/item/circuitboard/mecha/gygax/targeting,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="Peripherals control module is secured"),
					 //13
					 list("key"=IS_SCREWDRIVER,
					 		"backkey"=IS_CROWBAR,
					 		"desc"="Peripherals control module is installed"),
					 //14
					 list("key"=/obj/item/circuitboard/mecha/gygax/peripherals,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="Central control module is secured"),
					 //15
					 list("key"=IS_SCREWDRIVER,
					 		"backkey"=IS_CROWBAR,
					 		"desc"="Central control module is installed"),
					 //16
					 list("key"=/obj/item/circuitboard/mecha/gygax/main,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="The wiring is adjusted"),
					 //17
					 list("key"=IS_WIRECUTTER,
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
			user.visible_message(span_infoplain("[user] connects [holder] hydraulic systems"), span_infoplain("You connect [holder] hydraulic systems."))
			holder.icon_state = "gygax1"
		if(19)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] activates [holder] hydraulic systems."), span_infoplain("You activate [holder] hydraulic systems."))
				holder.icon_state = "gygax2"
			else
				user.visible_message(span_infoplain("[user] disconnects [holder] hydraulic systems"), span_infoplain("You disconnect [holder] hydraulic systems."))
				holder.icon_state = "gygax0"
		if(18)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] adds the wiring to [holder]."), span_infoplain("You add the wiring to [holder]."))
				holder.icon_state = "gygax3"
			else
				user.visible_message(span_infoplain("[user] deactivates [holder] hydraulic systems."), span_infoplain("You deactivate [holder] hydraulic systems."))
				holder.icon_state = "gygax1"
		if(17)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] adjusts the wiring of [holder]."), span_infoplain("You adjust the wiring of [holder]."))
				holder.icon_state = "gygax4"
			else
				user.visible_message(span_infoplain("[user] removes the wiring from [holder]."), span_infoplain("You remove the wiring from [holder]."))
				new /obj/item/stack/cable_coil(get_turf(holder), 4)
				holder.icon_state = "gygax2"
		if(16)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] installs the central control module into [holder]."), span_infoplain("You install the central computer mainboard into [holder]."))
				qdel(I)
				holder.icon_state = "gygax5"
			else
				user.visible_message(span_infoplain("[user] disconnects the wiring of [holder]."), span_infoplain("You disconnect the wiring of [holder]."))
				holder.icon_state = "gygax3"
		if(15)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] secures the mainboard."), span_infoplain("You secure the mainboard."))
				holder.icon_state = "gygax6"
			else
				user.visible_message(span_infoplain("[user] removes the central control module from [holder]."), span_infoplain("You remove the central computer mainboard from [holder]."))
				new /obj/item/circuitboard/mecha/gygax/main(get_turf(holder))
				holder.icon_state = "gygax4"
		if(14)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] installs the peripherals control module into [holder]."), span_infoplain("You install the peripherals control module into [holder]."))
				qdel(I)
				holder.icon_state = "gygax7"
			else
				user.visible_message(span_infoplain("[user] unfastens the mainboard."), span_infoplain("You unfasten the mainboard."))
				holder.icon_state = "gygax5"
		if(13)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] secures the peripherals control module."), span_infoplain("You secure the peripherals control module."))
				holder.icon_state = "gygax8"
			else
				user.visible_message(span_infoplain("[user] removes the peripherals control module from [holder]."), span_infoplain("You remove the peripherals control module from [holder]."))
				new /obj/item/circuitboard/mecha/gygax/peripherals(get_turf(holder))
				holder.icon_state = "gygax6"
		if(12)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] installs the weapon control module into [holder]."), span_infoplain("You install the weapon control module into [holder]."))
				qdel(I)
				holder.icon_state = "gygax9"
			else
				user.visible_message(span_infoplain("[user] unfastens the peripherals control module."), span_infoplain("You unfasten the peripherals control module."))
				holder.icon_state = "gygax7"
		if(11)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] secures the weapon control module."), span_infoplain("You secure the weapon control module."))
				holder.icon_state = "gygax10"
			else
				user.visible_message(span_infoplain("[user] removes the weapon control module from [holder]."), span_infoplain("You remove the weapon control module from [holder]."))
				new /obj/item/circuitboard/mecha/gygax/targeting(get_turf(holder))
				holder.icon_state = "gygax8"
		if(10)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] installs advanced scanner module to [holder]."), span_infoplain("You install advanced scanner module to [holder]."))
				qdel(I)
				holder.icon_state = "gygax11"
			else
				user.visible_message(span_infoplain("[user] unfastens the weapon control module."), span_infoplain("You unfasten the weapon control module."))
				holder.icon_state = "gygax9"
		if(9)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] secures the advanced scanner module."), span_infoplain("You secure the advanced scanner module."))
				holder.icon_state = "gygax12"
			else
				user.visible_message(span_infoplain("[user] removes the advanced scanner module from [holder]."), span_infoplain("You remove the advanced scanner module from [holder]."))
				new /obj/item/stock_parts/scanning_module/adv(get_turf(holder))
				holder.icon_state = "gygax10"
		if(8)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] installs advanced capacitor to [holder]."), span_infoplain("You install advanced capacitor to [holder]."))
				qdel(I)
				holder.icon_state = "gygax13"
			else
				user.visible_message(span_infoplain("[user] unfastens the advanced scanner module."), span_infoplain("You unfasten the advanced scanner module."))
				holder.icon_state = "gygax11"
		if(7)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] secures the advanced capacitor."), span_infoplain("You secure the advanced capacitor."))
				holder.icon_state = "gygax14"
			else
				user.visible_message(span_infoplain("[user] removes the advanced capacitor from [holder]."), span_infoplain("You remove the advanced capacitor from [holder]."))
				new /obj/item/stock_parts/capacitor/adv(get_turf(holder))
				holder.icon_state = "gygax12"
		if(6)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] installs internal armor layer to [holder]."), span_infoplain("You install internal armor layer to [holder]."))
				holder.icon_state = "gygax15"
			else
				user.visible_message(span_infoplain("[user] unfastens the advanced capacitor."), span_infoplain("You unfasten the advanced capacitor."))
				holder.icon_state = "gygax13"
		if(5)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] secures internal armor layer."), span_infoplain("You secure internal armor layer."))
				holder.icon_state = "gygax16"
			else
				user.visible_message(span_infoplain("[user] pries internal armor layer from [holder]."), span_infoplain("You prie internal armor layer from [holder]."))
				new /obj/item/stack/material/steel(get_turf(holder), 5)
				holder.icon_state = "gygax14"
		if(4)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] welds internal armor layer to [holder]."), span_infoplain("You weld the internal armor layer to [holder]."))
				holder.icon_state = "gygax17"
			else
				user.visible_message(span_infoplain("[user] unfastens the internal armor layer."), span_infoplain("You unfasten the internal armor layer."))
				holder.icon_state = "gygax15"
		if(3)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] installs Gygax Armour Plates to [holder]."), span_infoplain("You install Gygax Armour Plates to [holder]."))
				qdel(I)
				holder.icon_state = "gygax18"
			else
				user.visible_message(span_infoplain("[user] cuts internal armor layer from [holder]."), span_infoplain("You cut the internal armor layer from [holder]."))
				holder.icon_state = "gygax16"
		if(2)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] secures Gygax Armour Plates."), span_infoplain("You secure Gygax Armour Plates."))
				holder.icon_state = "gygax19"
			else
				user.visible_message(span_infoplain("[user] pries Gygax Armour Plates from [holder]."), span_infoplain("You prie Gygax Armour Plates from [holder]."))
				new /obj/item/mecha_parts/part/gygax_armour(get_turf(holder))
				holder.icon_state = "gygax17"
		if(1)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] welds Gygax Armour Plates to [holder]."), span_infoplain("You weld Gygax Armour Plates to [holder]."))
			else
				user.visible_message(span_infoplain("[user] unfastens Gygax Armour Plates."), span_infoplain("You unfasten Gygax Armour Plates."))
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
	user.visible_message(span_infoplain("[user] has connected [I] to [holder]."), span_infoplain("You connect [I] to [holder]"))
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
					 list("key"=/obj/item/stock_parts/capacitor/adv,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="Advanced scanner module is secured"),
					 //9
					 list("key"=IS_SCREWDRIVER,
					 		"backkey"=IS_CROWBAR,
					 		"desc"="Advanced scanner module is installed"),
					 //10
					 list("key"=/obj/item/stock_parts/scanning_module/adv,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="Medical module is secured"),
					 //11
					 list("key"=IS_SCREWDRIVER,
					 		"backkey"=IS_CROWBAR,
					 		"desc"="Medical module is installed"),
					 //12
					 list("key"=/obj/item/circuitboard/mecha/gygax/medical,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="Peripherals control module is secured"),
					 //13
					 list("key"=IS_SCREWDRIVER,
					 		"backkey"=IS_CROWBAR,
					 		"desc"="Peripherals control module is installed"),
					 //14
					 list("key"=/obj/item/circuitboard/mecha/gygax/peripherals,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="Central control module is secured"),
					 //15
					 list("key"=IS_SCREWDRIVER,
					 		"backkey"=IS_CROWBAR,
					 		"desc"="Central control module is installed"),
					 //16
					 list("key"=/obj/item/circuitboard/mecha/gygax/main,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="The wiring is adjusted"),
					 //17
					 list("key"=IS_WIRECUTTER,
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
			user.visible_message(span_infoplain("[user] connects [holder] hydraulic systems"), span_infoplain("You connect [holder] hydraulic systems."))
			holder.icon_state = "gygax1"
		if(19)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] activates [holder] hydraulic systems."), span_infoplain("You activate [holder] hydraulic systems."))
				holder.icon_state = "gygax2"
			else
				user.visible_message(span_infoplain("[user] disconnects [holder] hydraulic systems"), span_infoplain("You disconnect [holder] hydraulic systems."))
				holder.icon_state = "gygax0"
		if(18)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] adds the wiring to [holder]."), span_infoplain("You add the wiring to [holder]."))
				holder.icon_state = "gygax3"
			else
				user.visible_message(span_infoplain("[user] deactivates [holder] hydraulic systems."), span_infoplain("You deactivate [holder] hydraulic systems."))
				holder.icon_state = "gygax1"
		if(17)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] adjusts the wiring of [holder]."), span_infoplain("You adjust the wiring of [holder]."))
				holder.icon_state = "gygax4"
			else
				user.visible_message(span_infoplain("[user] removes the wiring from [holder]."), span_infoplain("You remove the wiring from [holder]."))
				new /obj/item/stack/cable_coil(get_turf(holder), 4)
				holder.icon_state = "gygax2"
		if(16)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] installs the central control module into [holder]."), span_infoplain("You install the central computer mainboard into [holder]."))
				qdel(I)
				holder.icon_state = "gygax5"
			else
				user.visible_message(span_infoplain("[user] disconnects the wiring of [holder]."), span_infoplain("You disconnect the wiring of [holder]."))
				holder.icon_state = "gygax3"
		if(15)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] secures the mainboard."), span_infoplain("You secure the mainboard."))
				holder.icon_state = "gygax6"
			else
				user.visible_message(span_infoplain("[user] removes the central control module from [holder]."), span_infoplain("You remove the central computer mainboard from [holder]."))
				new /obj/item/circuitboard/mecha/gygax/main(get_turf(holder))
				holder.icon_state = "gygax4"
		if(14)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] installs the peripherals control module into [holder]."), span_infoplain("You install the peripherals control module into [holder]."))
				qdel(I)
				holder.icon_state = "gygax7"
			else
				user.visible_message(span_infoplain("[user] unfastens the mainboard."), span_infoplain("You unfasten the mainboard."))
				holder.icon_state = "gygax5"
		if(13)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] secures the peripherals control module."), span_infoplain("You secure the peripherals control module."))
				holder.icon_state = "gygax8"
			else
				user.visible_message(span_infoplain("[user] removes the peripherals control module from [holder]."), span_infoplain("You remove the peripherals control module from [holder]."))
				new /obj/item/circuitboard/mecha/gygax/peripherals(get_turf(holder))
				holder.icon_state = "gygax6"
		if(12)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] installs the medical control module into [holder]."), span_infoplain("You install the medical control module into [holder]."))
				qdel(I)
				holder.icon_state = "gygax9"
			else
				user.visible_message(span_infoplain("[user] unfastens the peripherals control module."), span_infoplain("You unfasten the peripherals control module."))
				holder.icon_state = "gygax7"
		if(11)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] secures the medical control module."), span_infoplain("You secure the medical control module."))
				holder.icon_state = "gygax10"
			else
				user.visible_message(span_infoplain("[user] removes the medical control module from [holder]."), span_infoplain("You remove the medical control module from [holder]."))
				new /obj/item/circuitboard/mecha/gygax/medical(get_turf(holder))
				holder.icon_state = "gygax8"
		if(10)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] installs advanced scanner module to [holder]."), span_infoplain("You install advanced scanner module to [holder]."))
				qdel(I)
				holder.icon_state = "gygax11"
			else
				user.visible_message(span_infoplain("[user] unfastens the medical control module."), span_infoplain("You unfasten the medical control module."))
				holder.icon_state = "gygax9"
		if(9)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] secures the advanced scanner module."), span_infoplain("You secure the advanced scanner module."))
				holder.icon_state = "gygax12"
			else
				user.visible_message(span_infoplain("[user] removes the advanced scanner module from [holder]."), span_infoplain("You remove the advanced scanner module from [holder]."))
				new /obj/item/stock_parts/scanning_module/adv(get_turf(holder))
				holder.icon_state = "gygax10"
		if(8)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] installs advanced capacitor to [holder]."), span_infoplain("You install advanced capacitor to [holder]."))
				qdel(I)
				holder.icon_state = "gygax13"
			else
				user.visible_message(span_infoplain("[user] unfastens the advanced scanner module."), span_infoplain("You unfasten the advanced scanner module."))
				holder.icon_state = "gygax11"
		if(7)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] secures the advanced capacitor."), span_infoplain("You secure the advanced capacitor."))
				holder.icon_state = "gygax14"
			else
				user.visible_message(span_infoplain("[user] removes the advanced capacitor from [holder]."), span_infoplain("You remove the advanced capacitor from [holder]."))
				new /obj/item/stock_parts/capacitor/adv(get_turf(holder))
				holder.icon_state = "gygax12"
		if(6)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] installs internal armor layer to [holder]."), span_infoplain("You install internal armor layer to [holder]."))
				holder.icon_state = "gygax15"
			else
				user.visible_message(span_infoplain("[user] unfastens the advanced capacitor."), span_infoplain("You unfasten the advanced capacitor."))
				holder.icon_state = "gygax13"
		if(5)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] secures internal armor layer."), span_infoplain("You secure internal armor layer."))
				holder.icon_state = "gygax16"
			else
				user.visible_message(span_infoplain("[user] pries internal armor layer from [holder]."), span_infoplain("You pry the internal armor layer from [holder]."))
				new /obj/item/stack/material/steel(get_turf(holder), 5)
				holder.icon_state = "gygax14"
		if(4)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] welds internal armor layer to [holder]."), span_infoplain("You weld the internal armor layer to [holder]."))
				holder.icon_state = "gygax17"
			else
				user.visible_message(span_infoplain("[user] unfastens the internal armor layer."), span_infoplain("You unfasten the internal armor layer."))
				holder.icon_state = "gygax15"
		if(3)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] installs the external armor layer to [holder]."), span_infoplain("You install the external armor layer to [holder]."))
				holder.icon_state = "gygax18"
			else
				user.visible_message(span_infoplain("[user] cuts internal armor layer from [holder]."), span_infoplain("You cut the internal armor layer from [holder]."))
				holder.icon_state = "gygax16"
		if(2)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] secures the external armor layer."), span_infoplain("You secure the external armor layer."))
				holder.icon_state = "gygax19-s"
			else
				user.visible_message(span_infoplain("[user] pries the external armor layer from [holder]."), span_infoplain("You pry the external armor layer from [holder]."))
				new /obj/item/stack/material/plasteel(get_turf(holder), 5) // Fixes serenity giving Gygax Armor Plates for the reverse action...
				holder.icon_state = "gygax17"
		if(1)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] welds the external armor layer to [holder]."), span_infoplain("You weld the external armor layer to [holder]."))
			else
				user.visible_message(span_infoplain("[user] unfastens the external armor layer."), span_infoplain("You unfasten the external armor layer."))
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
	user.visible_message(span_infoplain("[user] has connected [I] to [holder]."), span_infoplain("You connect [I] to [holder]"))
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
					 list("key"=/obj/item/circuitboard/mecha/ripley/peripherals,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="Central control module is secured"),
					 //10
					 list("key"=IS_SCREWDRIVER,
					 		"backkey"=IS_CROWBAR,
					 		"desc"="Central control module is installed"),
					 //11
					 list("key"=/obj/item/circuitboard/mecha/ripley/main,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="The wiring is adjusted"),
					 //12
					 list("key"=IS_WIRECUTTER,
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
			user.visible_message(span_infoplain("[user] connects [holder] hydraulic systems"), span_infoplain("You connect [holder] hydraulic systems."))
			holder.icon_state = "fireripley1"
		if(14)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] activates [holder] hydraulic systems."), span_infoplain("You activate [holder] hydraulic systems."))
				holder.icon_state = "fireripley2"
			else
				user.visible_message(span_infoplain("[user] disconnects [holder] hydraulic systems"), span_infoplain("You disconnect [holder] hydraulic systems."))
				holder.icon_state = "fireripley0"
		if(13)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] adds the wiring to [holder]."), span_infoplain("You add the wiring to [holder]."))
				holder.icon_state = "fireripley3"
			else
				user.visible_message(span_infoplain("[user] deactivates [holder] hydraulic systems."), span_infoplain("You deactivate [holder] hydraulic systems."))
				holder.icon_state = "fireripley1"
		if(12)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] adjusts the wiring of [holder]."), span_infoplain("You adjust the wiring of [holder]."))
				holder.icon_state = "fireripley4"
			else
				user.visible_message(span_infoplain("[user] removes the wiring from [holder]."), span_infoplain("You remove the wiring from [holder]."))
				new /obj/item/stack/cable_coil(get_turf(holder), 4)
				holder.icon_state = "fireripley2"
		if(11)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] installs the central control module into [holder]."), span_infoplain("You install the central computer mainboard into [holder]."))
				qdel(I)
				holder.icon_state = "fireripley5"
			else
				user.visible_message(span_infoplain("[user] disconnects the wiring of [holder]."), span_infoplain("You disconnect the wiring of [holder]."))
				holder.icon_state = "fireripley3"
		if(10)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] secures the mainboard."), span_infoplain("You secure the mainboard."))
				holder.icon_state = "fireripley6"
			else
				user.visible_message(span_infoplain("[user] removes the central control module from [holder]."), span_infoplain("You remove the central computer mainboard from [holder]."))
				new /obj/item/circuitboard/mecha/ripley/main(get_turf(holder))
				holder.icon_state = "fireripley4"
		if(9)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] installs the peripherals control module into [holder]."), span_infoplain("You install the peripherals control module into [holder]."))
				qdel(I)
				holder.icon_state = "fireripley7"
			else
				user.visible_message(span_infoplain("[user] unfastens the mainboard."), span_infoplain("You unfasten the mainboard."))
				holder.icon_state = "fireripley5"
		if(8)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] secures the peripherals control module."), span_infoplain("You secure the peripherals control module."))
				holder.icon_state = "fireripley8"
			else
				user.visible_message(span_infoplain("[user] removes the peripherals control module from [holder]."), span_infoplain("You remove the peripherals control module from [holder]."))
				new /obj/item/circuitboard/mecha/ripley/peripherals(get_turf(holder))
				holder.icon_state = "fireripley6"
		if(7)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] installs internal armor layer to [holder]."), span_infoplain("You install internal armor layer to [holder]."))
				holder.icon_state = "fireripley9"
			else
				user.visible_message(span_infoplain("[user] unfastens the peripherals control module."), span_infoplain("You unfasten the peripherals control module."))
				holder.icon_state = "fireripley7"
		if(6)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] secures internal armor layer."), span_infoplain("You secure internal armor layer."))
				holder.icon_state = "fireripley10"
			else
				user.visible_message(span_infoplain("[user] pries internal armor layer from [holder]."), span_infoplain("You prie internal armor layer from [holder]."))
				new /obj/item/stack/material/plasteel(get_turf(holder), 5)
				holder.icon_state = "fireripley8"
		if(5)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] welds internal armor layer to [holder]."), span_infoplain("You weld the internal armor layer to [holder]."))
				holder.icon_state = "fireripley11"
			else
				user.visible_message(span_infoplain("[user] unfastens the internal armor layer."), span_infoplain("You unfasten the internal armor layer."))
				holder.icon_state = "fireripley9"
		if(4)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] starts to install the external armor layer to [holder]."), span_infoplain("You start to install the external armor layer to [holder]."))
				holder.icon_state = "fireripley12"
			else
				user.visible_message(span_infoplain("[user] cuts internal armor layer from [holder]."), span_infoplain("You cut the internal armor layer from [holder]."))
				holder.icon_state = "fireripley10"
		if(3)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] installs external reinforced armor layer to [holder]."), span_infoplain("You install external reinforced armor layer to [holder]."))
				holder.icon_state = "fireripley13"
			else
				user.visible_message(span_infoplain("[user] removes the external armor from [holder]."), span_infoplain("You remove the external armor from [holder]."))
				new /obj/item/stack/material/plasteel(get_turf(holder), 5)
				holder.icon_state = "fireripley11"
		if(2)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] secures external armor layer."), span_infoplain("You secure external reinforced armor layer."))
				holder.icon_state = "fireripley14"
			else
				user.visible_message(span_infoplain("[user] pries external armor layer from [holder]."), span_infoplain("You prie external armor layer from [holder]."))
				new /obj/item/stack/material/plasteel(get_turf(holder), 5)
				holder.icon_state = "fireripley12"
		if(1)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] welds external armor layer to [holder]."), span_infoplain("You weld external armor layer to [holder]."))
			else
				user.visible_message(span_infoplain("[user] unfastens the external armor layer."), span_infoplain("You unfasten the external armor layer."))
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
	user.visible_message(span_infoplain("[user] has connected [I] to [holder]."), span_infoplain("You connect [I] to [holder]"))
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
					 list("key"=/obj/item/stock_parts/capacitor/adv,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="Advanced scanner module is secured"),
					 //9
					 list("key"=IS_SCREWDRIVER,
					 		"backkey"=IS_CROWBAR,
					 		"desc"="Advanced scanner module is installed"),
					 //10
					 list("key"=/obj/item/stock_parts/scanning_module/adv,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="Targeting module is secured"),
					 //11
					 list("key"=IS_SCREWDRIVER,
					 		"backkey"=IS_CROWBAR,
					 		"desc"="Targeting module is installed"),
					 //12
					 list("key"=/obj/item/circuitboard/mecha/durand/targeting,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="Peripherals control module is secured"),
					 //13
					 list("key"=IS_SCREWDRIVER,
					 		"backkey"=IS_CROWBAR,
					 		"desc"="Peripherals control module is installed"),
					 //14
					 list("key"=/obj/item/circuitboard/mecha/durand/peripherals,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="Central control module is secured"),
					 //15
					 list("key"=IS_SCREWDRIVER,
					 		"backkey"=IS_CROWBAR,
					 		"desc"="Central control module is installed"),
					 //16
					 list("key"=/obj/item/circuitboard/mecha/durand/main,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="The wiring is adjusted"),
					 //17
					 list("key"=IS_WIRECUTTER,
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
			user.visible_message(span_infoplain("[user] connects [holder] hydraulic systems"), span_infoplain("You connect [holder] hydraulic systems."))
			holder.icon_state = "durand1"
		if(19)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] activates [holder] hydraulic systems."), span_infoplain("You activate [holder] hydraulic systems."))
				holder.icon_state = "durand2"
			else
				user.visible_message(span_infoplain("[user] disconnects [holder] hydraulic systems"), span_infoplain("You disconnect [holder] hydraulic systems."))
				holder.icon_state = "durand0"
		if(18)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] adds the wiring to [holder]."), span_infoplain("You add the wiring to [holder]."))
				holder.icon_state = "durand3"
			else
				user.visible_message(span_infoplain("[user] deactivates [holder] hydraulic systems."), span_infoplain("You deactivate [holder] hydraulic systems."))
				holder.icon_state = "durand1"
		if(17)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] adjusts the wiring of [holder]."), span_infoplain("You adjust the wiring of [holder]."))
				holder.icon_state = "durand4"
			else
				user.visible_message(span_infoplain("[user] removes the wiring from [holder]."), span_infoplain("You remove the wiring from [holder]."))
				new /obj/item/stack/cable_coil(get_turf(holder), 4)
				holder.icon_state = "durand2"
		if(16)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] installs the central control module into [holder]."), span_infoplain("You install the central computer mainboard into [holder]."))
				qdel(I)
				holder.icon_state = "durand5"
			else
				user.visible_message(span_infoplain("[user] disconnects the wiring of [holder]."), span_infoplain("You disconnect the wiring of [holder]."))
				holder.icon_state = "durand3"
		if(15)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] secures the mainboard."), span_infoplain("You secure the mainboard."))
				holder.icon_state = "durand6"
			else
				user.visible_message(span_infoplain("[user] removes the central control module from [holder]."), span_infoplain("You remove the central computer mainboard from [holder]."))
				new /obj/item/circuitboard/mecha/durand/main(get_turf(holder))
				holder.icon_state = "durand4"
		if(14)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] installs the peripherals control module into [holder]."), span_infoplain("You install the peripherals control module into [holder]."))
				qdel(I)
				holder.icon_state = "durand7"
			else
				user.visible_message(span_infoplain("[user] unfastens the mainboard."), span_infoplain("You unfasten the mainboard."))
				holder.icon_state = "durand5"
		if(13)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] secures the peripherals control module."), span_infoplain("You secure the peripherals control module."))
				holder.icon_state = "durand8"
			else
				user.visible_message(span_infoplain("[user] removes the peripherals control module from [holder]."), span_infoplain("You remove the peripherals control module from [holder]."))
				new /obj/item/circuitboard/mecha/durand/peripherals(get_turf(holder))
				holder.icon_state = "durand6"
		if(12)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] installs the weapon control module into [holder]."), span_infoplain("You install the weapon control module into [holder]."))
				qdel(I)
				holder.icon_state = "durand9"
			else
				user.visible_message(span_infoplain("[user] unfastens the peripherals control module."), span_infoplain("You unfasten the peripherals control module."))
				holder.icon_state = "durand7"
		if(11)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] secures the weapon control module."), span_infoplain("You secure the weapon control module."))
				holder.icon_state = "durand10"
			else
				user.visible_message(span_infoplain("[user] removes the weapon control module from [holder]."), span_infoplain("You remove the weapon control module from [holder]."))
				new /obj/item/circuitboard/mecha/durand/targeting(get_turf(holder))
				holder.icon_state = "durand8"
		if(10)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] installs advanced scanner module to [holder]."), span_infoplain("You install advanced scanner module to [holder]."))
				qdel(I)
				holder.icon_state = "durand11"
			else
				user.visible_message(span_infoplain("[user] unfastens the weapon control module."), span_infoplain("You unfasten the weapon control module."))
				holder.icon_state = "durand9"
		if(9)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] secures the advanced scanner module."), span_infoplain("You secure the advanced scanner module."))
				holder.icon_state = "durand12"
			else
				user.visible_message(span_infoplain("[user] removes the advanced scanner module from [holder]."), span_infoplain("You remove the advanced scanner module from [holder]."))
				new /obj/item/stock_parts/scanning_module/adv(get_turf(holder))
				holder.icon_state = "durand10"
		if(8)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] installs advanced capacitor to [holder]."), span_infoplain("You install advanced capacitor to [holder]."))
				qdel(I)
				holder.icon_state = "durand13"
			else
				user.visible_message(span_infoplain("[user] unfastens the advanced scanner module."), span_infoplain("You unfasten the advanced scanner module."))
				holder.icon_state = "durand11"
		if(7)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] secures the advanced capacitor."), span_infoplain("You secure the advanced capacitor."))
				holder.icon_state = "durand14"
			else
				user.visible_message(span_infoplain("[user] removes the advanced capacitor from [holder]."), span_infoplain("You remove the advanced capacitor from [holder]."))
				new /obj/item/stock_parts/capacitor/adv(get_turf(holder))
				holder.icon_state = "durand12"
		if(6)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] installs internal armor layer to [holder]."), span_infoplain("You install internal armor layer to [holder]."))
				holder.icon_state = "durand15"
			else
				user.visible_message(span_infoplain("[user] unfastens the advanced capacitor."), span_infoplain("You unfasten the advanced capacitor."))
				holder.icon_state = "durand13"
		if(5)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] secures internal armor layer."), span_infoplain("You secure internal armor layer."))
				holder.icon_state = "durand16"
			else
				user.visible_message(span_infoplain("[user] pries internal armor layer from [holder]."), span_infoplain("You prie internal armor layer from [holder]."))
				new /obj/item/stack/material/steel(get_turf(holder), 5)
				holder.icon_state = "durand14"
		if(4)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] welds internal armor layer to [holder]."), span_infoplain("You weld the internal armor layer to [holder]."))
				holder.icon_state = "durand17"
			else
				user.visible_message(span_infoplain("[user] unfastens the internal armor layer."), span_infoplain("You unfasten the internal armor layer."))
				holder.icon_state = "durand15"
		if(3)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] installs Durand Armour Plates to [holder]."), span_infoplain("You install Durand Armour Plates to [holder]."))
				qdel(I)
				holder.icon_state = "durand18"
			else
				user.visible_message(span_infoplain("[user] cuts internal armor layer from [holder]."), span_infoplain("You cut the internal armor layer from [holder]."))
				holder.icon_state = "durand16"
		if(2)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] secures Durand Armour Plates."), span_infoplain("You secure Durand Armour Plates."))
				holder.icon_state = "durand19"
			else
				user.visible_message(span_infoplain("[user] pries Durand Armour Plates from [holder]."), span_infoplain("You prie Durand Armour Plates from [holder]."))
				new /obj/item/mecha_parts/part/durand_armour(get_turf(holder))
				holder.icon_state = "durand17"
		if(1)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] welds Durand Armour Plates to [holder]."), span_infoplain("You weld Durand Armour Plates to [holder]."))
			else
				user.visible_message(span_infoplain("[user] unfastens Durand Armour Plates."), span_infoplain("You unfasten Durand Armour Plates."))
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
	user.visible_message(span_infoplain("[user] has connected [I] to [holder]."), span_infoplain("You connect [I] to [holder]"))
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
					 list("key"=/obj/item/circuitboard/mecha/odysseus/peripherals,
					 		"backkey"=IS_SCREWDRIVER,
					 		"desc"="Central control module is secured"),
					 //9
					 list("key"=IS_SCREWDRIVER,
					 		"backkey"=IS_CROWBAR,
					 		"desc"="Central control module is installed"),
					 //10
					 list("key"=/obj/item/circuitboard/mecha/odysseus/main,
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

/datum/construction/reversible/mecha/odysseus/action(obj/item/I,mob/user as mob)
	return check_step(I,user)

/datum/construction/reversible/mecha/odysseus/custom_action(index, diff, obj/item/I, mob/user)
	if(!..())
		return 0

	//TODO: better messages.
	switch(index)
		if(14)
			user.visible_message(span_infoplain("[user] connects [holder] hydraulic systems"), span_infoplain("You connect [holder] hydraulic systems."))
			holder.icon_state = "odysseus1"
		if(13)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] activates [holder] hydraulic systems."), span_infoplain("You activate [holder] hydraulic systems."))
				holder.icon_state = "odysseus2"
			else
				user.visible_message(span_infoplain("[user] disconnects [holder] hydraulic systems"), span_infoplain("You disconnect [holder] hydraulic systems."))
				holder.icon_state = "odysseus0"
		if(12)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] adds the wiring to [holder]."), span_infoplain("You add the wiring to [holder]."))
				holder.icon_state = "odysseus3"
			else
				user.visible_message(span_infoplain("[user] deactivates [holder] hydraulic systems."), span_infoplain("You deactivate [holder] hydraulic systems."))
				holder.icon_state = "odysseus1"
		if(11)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] adjusts the wiring of [holder]."), span_infoplain("You adjust the wiring of [holder]."))
				holder.icon_state = "odysseus4"
			else
				user.visible_message(span_infoplain("[user] removes the wiring from [holder]."), span_infoplain("You remove the wiring from [holder]."))
				new /obj/item/stack/cable_coil(get_turf(holder), 4)
				holder.icon_state = "odysseus2"
		if(10)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] installs the central control module into [holder]."), span_infoplain("You install the central computer mainboard into [holder]."))
				qdel(I)
				holder.icon_state = "odysseus5"
			else
				user.visible_message(span_infoplain("[user] disconnects the wiring of [holder]."), span_infoplain("You disconnect the wiring of [holder]."))
				holder.icon_state = "odysseus3"
		if(9)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] secures the mainboard."), span_infoplain("You secure the mainboard."))
				holder.icon_state = "odysseus6"
			else
				user.visible_message(span_infoplain("[user] removes the central control module from [holder]."), span_infoplain("You remove the central computer mainboard from [holder]."))
				new /obj/item/circuitboard/mecha/odysseus/main(get_turf(holder))
				holder.icon_state = "odysseus4"
		if(8)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] installs the peripherals control module into [holder]."), span_infoplain("You install the peripherals control module into [holder]."))
				qdel(I)
				holder.icon_state = "odysseus7"
			else
				user.visible_message(span_infoplain("[user] unfastens the mainboard."), span_infoplain("You unfasten the mainboard."))
				holder.icon_state = "odysseus5"
		if(7)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] secures the peripherals control module."), span_infoplain("You secure the peripherals control module."))
				holder.icon_state = "odysseus8"
			else
				user.visible_message(span_infoplain("[user] removes the peripherals control module from [holder]."), span_infoplain("You remove the peripherals control module from [holder]."))
				new /obj/item/circuitboard/mecha/odysseus/peripherals(get_turf(holder))
				holder.icon_state = "odysseus6"
		if(6)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] installs internal armor layer to [holder]."), span_infoplain("You install internal armor layer to [holder]."))
				holder.icon_state = "odysseus9"
			else
				user.visible_message(span_infoplain("[user] unfastens the peripherals control module."), span_infoplain("You unfasten the peripherals control module."))
				holder.icon_state = "odysseus7"
		if(5)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] secures internal armor layer."), span_infoplain("You secure internal armor layer."))
				holder.icon_state = "odysseus10"
			else
				user.visible_message(span_infoplain("[user] pries internal armor layer from [holder]."), span_infoplain("You prie internal armor layer from [holder]."))
				new /obj/item/stack/material/steel(get_turf(holder), 5)
				holder.icon_state = "odysseus8"
		if(4)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] welds internal armor layer to [holder]."), span_infoplain("You weld the internal armor layer to [holder]."))
				holder.icon_state = "odysseus11"
			else
				user.visible_message(span_infoplain("[user] unfastens the internal armor layer."), span_infoplain("You unfasten the internal armor layer."))
				holder.icon_state = "odysseus9"
		if(3)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] installs [I] layer to [holder]."), span_infoplain("You install external reinforced armor layer to [holder]."))
				holder.icon_state = "odysseus12"
			else
				user.visible_message(span_infoplain("[user] cuts internal armor layer from [holder]."), span_infoplain("You cut the internal armor layer from [holder]."))
				holder.icon_state = "odysseus10"
		if(2)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] secures external armor layer."), span_infoplain("You secure external reinforced armor layer."))
				holder.icon_state = "odysseus13"
			else
				new /obj/item/stack/material/plasteel(get_turf(holder), 5)
				user.visible_message(span_infoplain("[user] pries the plasteel from [holder]."), span_infoplain("You prie the plasteel from [holder]."))
				holder.icon_state = "odysseus11"
		if(1)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] welds external armor layer to [holder]."), span_infoplain("You weld external armor layer to [holder]."))
				holder.icon_state = "odysseus14"
			else
				user.visible_message(span_infoplain("[user] unfastens the external armor layer."), span_infoplain("You unfasten the external armor layer."))
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
	user.visible_message(span_infoplain("[user] has connected [I] to [holder]."), span_infoplain("You connect [I] to [holder]"))
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
					list("key"=/obj/item/hand_tele,
							"backkey"=IS_SCREWDRIVER,
							"desc"="SMES coil is secured"),
					//9
					list("key"=IS_SCREWDRIVER,
							"backkey"=IS_CROWBAR,
							"desc"="SMES coil is installed"),
					//10
					list("key"=/obj/item/smes_coil/super_capacity,
							"backkey"=IS_SCREWDRIVER,
							"desc"="Targeting module is secured"),
					//11
					list("key"=IS_SCREWDRIVER,
							"backkey"=IS_CROWBAR,
							"desc"="Targeting module is installed"),
					//12
					list("key"=/obj/item/circuitboard/mecha/phazon/targeting,
							"backkey"=IS_SCREWDRIVER,
							"desc"="Peripherals control module is secured"),
					//13
					list("key"=IS_SCREWDRIVER,
							"backkey"=IS_CROWBAR,
							"desc"="Peripherals control module is installed"),
					//14
					list("key"=/obj/item/circuitboard/mecha/phazon/peripherals,
							"backkey"=IS_SCREWDRIVER,
							"desc"="Central control module is secured"),
					//15
					list("key"=IS_SCREWDRIVER,
							"backkey"=IS_CROWBAR,
							"desc"="Central control module is installed"),
					//16
					list("key"=/obj/item/circuitboard/mecha/phazon/main,
							"backkey"=IS_SCREWDRIVER,
							"desc"="The wiring is adjusted"),
					//17
					list("key"=IS_WIRECUTTER,
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
			user.visible_message(span_infoplain("[user] connects [holder] hydraulic systems"), span_infoplain("You connect [holder] hydraulic systems."))
			holder.icon_state = "phazon1"
		if(19)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] activates [holder] hydraulic systems."), span_infoplain("You activate [holder] hydraulic systems."))
				holder.icon_state = "phazon2"
			else
				user.visible_message(span_infoplain("[user] disconnects [holder] hydraulic systems"), span_infoplain("You disconnect [holder] hydraulic systems."))
				holder.icon_state = "phazon0"
		if(18)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] adds the wiring to [holder]."), span_infoplain("You add the wiring to [holder]."))
				holder.icon_state = "phazon3"
			else
				user.visible_message(span_infoplain("[user] deactivates [holder] hydraulic systems."), span_infoplain("You deactivate [holder] hydraulic systems."))
				holder.icon_state = "phazon1"
		if(17)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] adjusts the wiring of [holder]."), span_infoplain("You adjust the wiring of [holder]."))
				holder.icon_state = "phazon4"
			else
				user.visible_message(span_infoplain("[user] removes the wiring from [holder]."), span_infoplain("You remove the wiring from [holder]."))
				new /obj/item/stack/cable_coil(get_turf(holder), 4)
				holder.icon_state = "phazon2"
		if(16)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] installs the central control module into [holder]."), span_infoplain("You install the central computer mainboard into [holder]."))
				qdel(I)
				holder.icon_state = "phazon5"
			else
				user.visible_message(span_infoplain("[user] disconnects the wiring of [holder]."), span_infoplain("You disconnect the wiring of [holder]."))
				holder.icon_state = "phazon3"
		if(15)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] secures the mainboard."), span_infoplain("You secure the mainboard."))
				holder.icon_state = "phazon6"
			else
				user.visible_message(span_infoplain("[user] removes the central control module from [holder]."), span_infoplain("You remove the central computer mainboard from [holder]."))
				new /obj/item/circuitboard/mecha/phazon/main(get_turf(holder))
				holder.icon_state = "phazon4"
		if(14)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] installs the peripherals control module into [holder]."), span_infoplain("You install the peripherals control module into [holder]."))
				qdel(I)
				holder.icon_state = "phazon7"
			else
				user.visible_message(span_infoplain("[user] unfastens the mainboard."), span_infoplain("You unfasten the mainboard."))
				holder.icon_state = "phazon5"
		if(13)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] secures the peripherals control module."), span_infoplain("You secure the peripherals control module."))
				holder.icon_state = "phazon8"
			else
				user.visible_message(span_infoplain("[user] removes the peripherals control module from [holder]."), span_infoplain("You remove the peripherals control module from [holder]."))
				new /obj/item/circuitboard/mecha/phazon/peripherals(get_turf(holder))
				holder.icon_state = "phazon6"
		if(12)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] installs the weapon control module into [holder]."), span_infoplain("You install the weapon control module into [holder]."))
				qdel(I)
				holder.icon_state = "phazon9"
			else
				user.visible_message(span_infoplain("[user] unfastens the peripherals control module."), span_infoplain("You unfasten the peripherals control module."))
				holder.icon_state = "phazon7"
		if(11)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] secures the weapon control module."), span_infoplain("You secure the weapon control module."))
				holder.icon_state = "phazon10"
			else
				user.visible_message(span_infoplain("[user] removes the weapon control module from [holder]."), span_infoplain("You remove the weapon control module from [holder]."))
				new /obj/item/circuitboard/mecha/phazon/targeting(get_turf(holder))
				holder.icon_state = "phazon8"
		if(10)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] installs the SMES coil to [holder]."), span_infoplain("You install the SMES coil to [holder]."))
				qdel(I)
				holder.icon_state = "phazon11"
			else
				user.visible_message(span_infoplain("[user] unfastens the weapon control module."), span_infoplain("You unfasten the weapon control module."))
				holder.icon_state = "phazon9"
		if(9)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] secures the SMES coil."), span_infoplain("You secure the SMES coil."))
				holder.icon_state = "phazon12"
			else
				user.visible_message(span_infoplain("[user] removes the SMES coil from [holder]."), span_infoplain("You remove the SMES coil from [holder]."))
				new /obj/item/smes_coil/super_capacity(get_turf(holder))
				holder.icon_state = "phazon10"
		if(8)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] installs the hand teleporter to [holder]."), span_infoplain("You install the hand teleporter to [holder]."))
				qdel(I)
				holder.icon_state = "phazon13"
			else
				user.visible_message(span_infoplain("[user] unfastens the SMES coil."), span_infoplain("You unfasten the SMES coil."))
				holder.icon_state = "phazon11"
		if(7)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] secures the hand teleporter."), span_infoplain("You secure the hand teleporter."))
				holder.icon_state = "phazon14"
			else
				user.visible_message(span_infoplain("[user] removes the hand teleporter from [holder]."), span_infoplain("You remove the hand teleporter from [holder]."))
				new /obj/item/hand_tele(get_turf(holder))
				holder.icon_state = "phazon12"
		if(6)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] installs the internal armor layer to [holder]."), span_infoplain("You install the internal armor layer to [holder]."))
				holder.icon_state = "phazon19"
			else
				user.visible_message(span_infoplain("[user] unfastens the hand teleporter."), span_infoplain("You unfasten the hand teleporter."))
				holder.icon_state = "phazon13"
		if(5)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] secures the internal armor layer."), span_infoplain("You secure the internal armor layer."))
				holder.icon_state = "phazon20"
			else
				user.visible_message(span_infoplain("[user] pries the internal armor layer from [holder]."), span_infoplain("You pry the internal armor layer from [holder]."))
				new /obj/item/stack/material/steel(get_turf(holder), 5)
				holder.icon_state = "phazon14"
		if(4)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] welds the internal armor layer to [holder]."), span_infoplain("You weld the internal armor layer to [holder]."))
				holder.icon_state = "phazon21"
			else
				user.visible_message(span_infoplain("[user] unfastens the internal armor layer."), span_infoplain("You unfasten the internal armor layer."))
				holder.icon_state = "phazon19"
		if(3)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] installs the external reinforced armor layer to [holder]."), span_infoplain("You install the external reinforced armor layer to [holder]."))
				holder.icon_state = "phazon22"
			else
				user.visible_message(span_infoplain("[user] cuts internal armor layer from [holder]."), span_infoplain("You cut the internal armor layer from [holder]."))
				holder.icon_state = "phazon20"
		if(2)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] secures external armor layer."), span_infoplain("You secure external reinforced armor layer."))
				holder.icon_state = "phazon23"
			else
				user.visible_message(span_infoplain("[user] pries the external armor layer from [holder]."), span_infoplain("You pry external armor layer from [holder]."))
				new /obj/item/stack/material/plasteel(get_turf(holder), 5)
				holder.icon_state = "phazon21"
		if(1)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] welds the external armor layer to [holder]."), span_infoplain("You weld the external armor layer to [holder]."))
			else
				user.visible_message(span_infoplain("[user] unfastens the external armor layer."), span_infoplain("You unfasten the external armor layer."))
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
	user.visible_message(span_infoplain("[user] has connected [I] to [holder]."), span_infoplain("You connect [I] to [holder]"))
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
					list("key"=/obj/item/circuitboard/mecha/durand/peripherals,
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
					list("key"=/obj/item/circuitboard/mecha/gygax/peripherals,
							"backkey"=IS_SCREWDRIVER,
							"desc"="Targeting module is secured"),
					//13
					list("key"=IS_SCREWDRIVER,
							"backkey"=IS_CROWBAR,
							"desc"="Targeting module is installed"),
					//14
					list("key"=/obj/item/circuitboard/mecha/imperion/targeting,
							"backkey"=IS_SCREWDRIVER,
							"desc"="Peripherals control module is secured"),
					//15
					list("key"=IS_SCREWDRIVER,
							"backkey"=IS_CROWBAR,
							"desc"="Peripherals control module is installed"),
					//16
					list("key"=/obj/item/circuitboard/mecha/imperion/peripherals,
							"backkey"=IS_SCREWDRIVER,
							"desc"="Central control module is secured"),
					//17
					list("key"=IS_SCREWDRIVER,
							"backkey"=IS_CROWBAR,
							"desc"="Central control module is installed"),
					//18
					list("key"=/obj/item/circuitboard/mecha/imperion/main,
							"backkey"=IS_SCREWDRIVER,
							"desc"="The wiring is adjusted"),
					//19
					list("key"=IS_WIRECUTTER,
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
			user.visible_message(span_infoplain("[user] connects [holder] hydraulic systems"), span_infoplain("You connect [holder] hydraulic systems."))
			holder.icon_state = "janus1"
		if(21)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] activates [holder] hydraulic systems."), span_infoplain("You activate [holder] hydraulic systems."))
				holder.icon_state = "janus2"
			else
				user.visible_message(span_infoplain("[user] disconnects [holder] hydraulic systems"), span_infoplain("You disconnect [holder] hydraulic systems."))
				holder.icon_state = "janus0"
		if(20)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] adds the wiring to [holder]."), span_infoplain("You add the wiring to [holder]."))
				holder.icon_state = "janus3"
			else
				user.visible_message(span_infoplain("[user] deactivates [holder] hydraulic systems."), span_infoplain("You deactivate [holder] hydraulic systems."))
				holder.icon_state = "janus1"
		if(19)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] adjusts the wiring of [holder]."), span_infoplain("You adjust the wiring of [holder]."))
				holder.icon_state = "janus4"
			else
				user.visible_message(span_infoplain("[user] removes the wiring from [holder]."), span_infoplain("You remove the wiring from [holder]."))
				new /obj/item/stack/cable_coil(get_turf(holder), 4)
				holder.icon_state = "janus2"
		if(18)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] installs the central control module into [holder]."), span_infoplain("You install the central computer mainboard into [holder]."))
				qdel(I)
				holder.icon_state = "janus5"
			else
				user.visible_message(span_infoplain("[user] disconnects the wiring of [holder]."), span_infoplain("You disconnect the wiring of [holder]."))
				holder.icon_state = "janus3"
		if(17)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] secures the mainboard."), span_infoplain("You secure the mainboard."))
				holder.icon_state = "janus6"
			else
				user.visible_message(span_infoplain("[user] removes the central control module from [holder]."), span_infoplain("You remove the central computer mainboard from [holder]."))
				new /obj/item/circuitboard/mecha/imperion/main(get_turf(holder))
				holder.icon_state = "janus4"
		if(16)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] installs the peripherals control module into [holder]."), span_infoplain("You install the peripherals control module into [holder]."))
				qdel(I)
				holder.icon_state = "janus7"
			else
				user.visible_message(span_infoplain("[user] unfastens the mainboard."), span_infoplain("You unfasten the mainboard."))
				holder.icon_state = "janus5"
		if(15)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] secures the peripherals control module."), span_infoplain("You secure the peripherals control module."))
				holder.icon_state = "janus8"
			else
				user.visible_message(span_infoplain("[user] removes the peripherals control module from [holder]."), span_infoplain("You remove the peripherals control module from [holder]."))
				new /obj/item/circuitboard/mecha/imperion/peripherals(get_turf(holder))
				holder.icon_state = "janus6"
		if(14)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] installs the weapon control module into [holder]."), span_infoplain("You install the weapon control module into [holder]."))
				qdel(I)
				holder.icon_state = "janus9"
			else
				user.visible_message(span_infoplain("[user] unfastens the peripherals control module."), span_infoplain("You unfasten the peripherals control module."))
				holder.icon_state = "janus7"
		if(13)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] secures the weapon control module."), span_infoplain("You secure the weapon control module."))
				holder.icon_state = "janus10"
			else
				user.visible_message(span_infoplain("[user] removes the weapon control module from [holder]."), span_infoplain("You remove the weapon control module from [holder]."))
				new /obj/item/circuitboard/mecha/imperion/targeting(get_turf(holder))
				holder.icon_state = "janus8"
		if(12)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] installs the Gygax control module into [holder]."), span_infoplain("You install the Gygax control module into [holder]."))
				qdel(I)
				holder.icon_state = "janus11"
			else
				user.visible_message(span_infoplain("[user] unfastens the Gygax control module."), span_infoplain("You unfasten the Gygax control module."))
				holder.icon_state = "janus9"
		if(11)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] secures the Gygax control module."), span_infoplain("You secure the Gygax control module."))
				holder.icon_state = "janus12"
			else
				user.visible_message(span_infoplain("[user] removes the Gygax control module from [holder]."), span_infoplain("You remove the Gygax control module from [holder]."))
				new /obj/item/circuitboard/mecha/gygax/peripherals(get_turf(holder))
				holder.icon_state = "janus10"
		if(10)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] installs the phase coil into [holder]."), span_infoplain("You install the phase coil into [holder]."))
				qdel(I)
				holder.icon_state = "janus13"
			else
				user.visible_message(span_infoplain("[user] unfastens the Gygax control module."), span_infoplain("You unfasten the Gygax control module."))
				holder.icon_state = "janus11"
		if(9)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] secures the phase coil."), span_infoplain("You secure the phase coil."))
				holder.icon_state = "janus14"
			else
				user.visible_message(span_infoplain("[user] removes the phase coil from [holder]."), span_infoplain("You remove the phase coil from [holder]."))
				new /obj/item/prop/alien/phasecoil(get_turf(holder))
				holder.icon_state = "janus12"
		if(8)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] installs the Durand control module into [holder]."), span_infoplain("You install the Durand control module into [holder]."))
				qdel(I)
				holder.icon_state = "janus15"
			else
				user.visible_message(span_infoplain("[user] unfastens the phase coil."), span_infoplain("You unfasten the phase coil."))
				holder.icon_state = "janus13"
		if(7)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] secures the Durand control module."), span_infoplain("You secure the Durand control module."))
				holder.icon_state = "janus16"
			else
				user.visible_message(span_infoplain("[user] removes the Durand control module from [holder]."), span_infoplain("You remove the Durand control module from [holder]."))
				new /obj/item/circuitboard/mecha/durand/peripherals(get_turf(holder))
				holder.icon_state = "janus14"
		if(6)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] installs the internal armor layer to [holder]."), span_infoplain("You install the internal armor layer to [holder]."))
				holder.icon_state = "janus17"
			else
				user.visible_message(span_infoplain("[user] unfastens the Durand control module."), span_infoplain("You unfasten the Durand control module."))
				holder.icon_state = "janus15"
		if(5)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] secures the internal armor layer."), span_infoplain("You secure the internal armor layer."))
				holder.icon_state = "janus18"
			else
				user.visible_message(span_infoplain("[user] pries the internal armor layer from [holder]."), span_infoplain("You pry the internal armor layer from [holder]."))
				new /obj/item/stack/material/durasteel(get_turf(holder), 5)
				holder.icon_state = "janus16"
		if(4)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] welds the internal armor layer to [holder]."), span_infoplain("You weld the internal armor layer to [holder]."))
				holder.icon_state = "janus19"
			else
				user.visible_message(span_infoplain("[user] unfastens the internal armor layer."), span_infoplain("You unfasten the internal armor layer."))
				holder.icon_state = "janus17"
		if(3)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] installs the external reinforced armor layer to [holder]."), span_infoplain("You install the external reinforced armor layer to [holder]."))
				holder.icon_state = "janus20"
			else
				user.visible_message(span_infoplain("[user] cuts internal armor layer from [holder]."), span_infoplain("You cut the internal armor layer from [holder]."))
				holder.icon_state = "janus18"
		if(2)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] secures external armor layer."), span_infoplain("You secure external reinforced armor layer."))
				holder.icon_state = "janus21"
			else
				user.visible_message(span_infoplain("[user] pries the external armor layer from [holder]."), span_infoplain("You pry external armor layer from [holder]."))
				new /obj/item/stack/material/morphium(get_turf(holder), 5)
				holder.icon_state = "janus19"
		if(1)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] welds the external armor layer to [holder]."), span_infoplain("You weld the external armor layer to [holder]."))
			else
				user.visible_message(span_infoplain("[user] unfastens the external armor layer."), span_infoplain("You unfasten the external armor layer."))
				holder.icon_state = "janus20"
	return 1

/datum/construction/reversible/mecha/janus/spawn_result()
	..()
	feedback_inc("mecha_janus_created",1)
	return

//Fighters

//////////////////////
//		Pinnace
//////////////////////
/datum/construction/mecha/fighter/pinnace_chassis
	result = "/obj/mecha/combat/fighter/pinnace"
	steps = list(list("key"=/obj/item/mecha_parts/fighter/part/pinnace_core),//1
					 list("key"=/obj/item/mecha_parts/fighter/part/pinnace_cockpit),//2
					 list("key"=/obj/item/mecha_parts/fighter/part/pinnace_main_engine),//3
					 list("key"=/obj/item/mecha_parts/fighter/part/pinnace_left_engine),//4
					 list("key"=/obj/item/mecha_parts/fighter/part/pinnace_right_engine),//5
					 list("key"=/obj/item/mecha_parts/fighter/part/pinnace_left_wing),//6
					 list("key"=/obj/item/mecha_parts/fighter/part/pinnace_right_wing)//final
					)

/datum/construction/mecha/fighter/pinnace_chassis/custom_action(step, obj/item/I, mob/user)
	user.visible_message(span_infoplain("[user] has connected [I] to [holder]."), span_infoplain("You connect [I] to [holder]"))
	holder.add_overlay("[I.icon_state]+o")
	qdel(I)
	return 1

/datum/construction/mecha/fighter/pinnace_chassis/action(obj/item/I,mob/user as mob)
	return check_all_steps(I,user)

/datum/construction/mecha/fighter/pinnace_chassis/spawn_result()
	var/obj/item/mecha_parts/chassis/const_holder = holder
	const_holder.construct = new /datum/construction/reversible/mecha/fighter/pinnace(const_holder)
	const_holder.icon = 'icons/mecha/fighters_construction64x64.dmi'
	const_holder.icon_state = "pinnace0"
	const_holder.density = 1
	spawn()
		qdel(src)
	return

/datum/construction/reversible/mecha/fighter/pinnace
	result = "/obj/mecha/combat/fighter/pinnace"
	steps = list(
					//1
					list("key"=IS_WELDER,
							"backkey"=IS_WRENCH,
							"desc"="External armor is bolted into place."),
					//2
					list("key"=IS_WRENCH,
							"backkey"=IS_CROWBAR,
							"desc"="External armor is installed."),
					//3
					list("key"=/obj/item/stack/material/plasteel,
							"backkey"=IS_WELDER,
							"desc"="The internal armor is welded into place."),
					//4
					list("key"=IS_WELDER,
							"backkey"=IS_WRENCH,
							"desc"="The internal armor is bolted into place."),
					//5
					list("key"=IS_WRENCH,
							"backkey"=IS_CROWBAR,
							"desc"="The internal armor is installed."),
					//6
					list("key"=/obj/item/stack/material/steel,
							"backkey"=IS_SCREWDRIVER,
							"desc"="The manual flight control instruments are secured."),
					//7
					list("key"=IS_SCREWDRIVER,
							"backkey"=IS_CROWBAR,
							"desc"="The manual flight control instruments are installed."),
					//8
					list("key"=/obj/item/circuitboard/mecha/fighter/pinnace/cockpitboard,
							"backkey"=IS_SCREWDRIVER,
							"desc"="The advanced capacitor is secured."),
					//9
					list("key"=IS_SCREWDRIVER,
							"backkey"=IS_CROWBAR,
							"desc"="The advanced capacitor is installed."),
					//10
					list("key"=/obj/item/stock_parts/capacitor/adv,
							"backkey"=IS_SCREWDRIVER,
							"desc"="The targeting module is secured."),
					//11
					list("key"=IS_SCREWDRIVER,
							"backkey"=IS_CROWBAR,
							"desc"="The targeting module is installed."),
					//12
					list("key"=/obj/item/circuitboard/mecha/fighter/pinnace/targeting,
							"backkey"=IS_SCREWDRIVER,
							"desc"="The flight control module is secured."),
					//13
					list("key"=IS_SCREWDRIVER,
							"backkey"=IS_CROWBAR,
							"desc"="The flight control module is installed."),
					//14
					list("key"=/obj/item/circuitboard/mecha/fighter/pinnace/flight,
							"backkey"=IS_SCREWDRIVER,
							"desc"="The central control module is secured."),
					//15
					list("key"=IS_SCREWDRIVER,
							"backkey"=IS_CROWBAR,
							"desc"="The central control module is installed."),
					//16
					list("key"=/obj/item/circuitboard/mecha/fighter/pinnace/main,
							"backkey"=IS_SCREWDRIVER,
							"desc"="The internal wiring is adjusted."),
					//17
					list("key"=IS_WIRECUTTER,
							"backkey"=IS_SCREWDRIVER,
							"desc"="The internal wiring is added."),
					//18
					list("key"=/obj/item/stack/cable_coil,
							"backkey"=IS_SCREWDRIVER,
							"desc"="The hydraulic landing gear are deployed."),
					//19
					list("key"=IS_SCREWDRIVER,
							"backkey"=IS_WRENCH,
							"desc"="The hydraulic landing gear are attached."),
					//20
					list("key"=IS_WRENCH,
							"desc"="The hydraulic landing gear are detached.")
					)

/datum/construction/reversible/mecha/fighter/pinnace/action(obj/item/I,mob/user as mob)
	return check_step(I,user)

/datum/construction/reversible/mecha/fighter/pinnace/custom_action(index, diff, obj/item/I, mob/user)
	if(!..())
		return 0

	switch(index)
		if(20)
			user.visible_message(span_infoplain("[user] attaches [holder]'s hydraulic landing gear."), span_infoplain("You attach [holder]'s hydraulic landing gear."))
			holder.icon_state = "pinnace1"
		if(19)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] deploys [holder]'s hydraulic landing gear."), span_infoplain("You deploy [holder]'s hydraulic landing gear."))
				holder.icon_state = "pinnace2"
			else
				user.visible_message(span_infoplain("[user] removes [holder]'s hydraulic landing gear."), span_infoplain("You remove [holder]'s hydraulic landing gear."))
				holder.icon_state = "pinnace0"
		if(18)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] adds the internal wiring to [holder]."), span_infoplain("You add the internal wiring to [holder]."))
				holder.icon_state = "pinnace3"
			else
				user.visible_message(span_infoplain("[user] retracts [holder]'s hydraulic landing gear."), span_infoplain("You retract [holder]'s hydraulic landing gear."))
				holder.icon_state = "pinnace1"
		if(17)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] adjusts the internal wiring of [holder]."), span_infoplain("You adjust the internal wiring of [holder]."))
				holder.icon_state = "pinnace4"
			else
				user.visible_message(span_infoplain("[user] removes the internal wiring from [holder]."), span_infoplain("You remove the internal wiring from [holder]."))
				var/obj/item/stack/cable_coil/coil = new /obj/item/stack/cable_coil(get_turf(holder))
				coil.amount = 4
				holder.icon_state = "pinnace2"
		if(16)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] installs the central control module into [holder]."), span_infoplain("You install the central control module into [holder]."))
				qdel(I)
				holder.icon_state = "pinnace5"
			else
				user.visible_message(span_infoplain("[user] disconnects the wiring of [holder]."), span_infoplain("You disconnect the wiring of [holder]."))
				holder.icon_state = "pinnace3"
		if(15)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] secures the central control module."), span_infoplain("You secure the central control module."))
				holder.icon_state = "pinnace6"
			else
				user.visible_message(span_infoplain("[user] removes the central control module from [holder]."), span_infoplain("You remove the central control module from [holder]."))
				new /obj/item/circuitboard/mecha/fighter/pinnace/main(get_turf(holder))
				holder.icon_state = "pinnace4"
		if(14)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] installs the flight control module into [holder]."), span_infoplain("You install the flight control module into [holder]."))
				qdel(I)
				holder.icon_state = "pinnace7"
			else
				user.visible_message(span_infoplain("[user] unfastens the central control module."), span_infoplain("You unfasten the central control module."))
				holder.icon_state = "pinnace5"
		if(13)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] secures the flight control module."), span_infoplain("You secure the flight control module."))
				holder.icon_state = "pinnace8"
			else
				user.visible_message(span_infoplain("[user] removes the flight control module from [holder]."), span_infoplain("You remove the flight control module from [holder]."))
				new /obj/item/circuitboard/mecha/fighter/pinnace/flight(get_turf(holder))
				holder.icon_state = "pinnace6"
		if(12)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] installs the targeting control module into [holder]."), span_infoplain("You install the targeting control module into [holder]."))
				qdel(I)
				holder.icon_state = "pinnace9"
			else
				user.visible_message(span_infoplain("[user] unfastens the peripherals control module."), span_infoplain("You unfasten the peripherals control module."))
				holder.icon_state = "pinnace7"
		if(11)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] secures the targeting control module."), span_infoplain("You secure the targeting control module."))
				holder.icon_state = "pinnace10"
			else
				user.visible_message(span_infoplain("[user] removes the targeting control module from [holder]."), span_infoplain("You remove the targeting control module from [holder]."))
				new /obj/item/circuitboard/mecha/fighter/pinnace/targeting(get_turf(holder))
				holder.icon_state = "pinnace8"
		if(10)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] installs the advanced capacitor into [holder]."), span_infoplain("You install the advanced capacitor into [holder]."))
				qdel(I)
				holder.icon_state = "pinnace11"
			else
				user.visible_message(span_infoplain("[user] unfastens the targeting control module."), span_infoplain("You unfasten the targeting control module."))
				holder.icon_state = "pinnace9"
		if(9)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] secures the advanced capacitor."), span_infoplain("You secure the advanced capacitor."))
				holder.icon_state = "pinnace12"
			else
				user.visible_message(span_infoplain("[user] removes the advanced capacitor from [holder]."), span_infoplain("You remove the advanced capacitor from [holder]."))
				new /obj/item/stock_parts/capacitor/adv(get_turf(holder))
				holder.icon_state = "pinnace10"
		if(8)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] installs the manual flight controls to [holder]."), span_infoplain("You install the manual flight controls to [holder]."))
				qdel(I)
				holder.icon_state = "pinnace13"
			else
				user.visible_message(span_infoplain("[user] unfastens the advanced capacitor."), span_infoplain("You unfasten the advanced capacitor."))
				holder.icon_state = "pinnace11"
		if(7)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] secures the manual flight controls."), span_infoplain("You secure the manual flight controls."))
				holder.icon_state = "pinnace14"
			else
				user.visible_message(span_infoplain("[user] removes the manual flight controls from [holder]."), span_infoplain("You remove the manual flight controls from [holder]."))
				new /obj/item/circuitboard/mecha/fighter/pinnace/cockpitboard(get_turf(holder))
				holder.icon_state = "pinnace12"
		if(6)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] installs the internal armor layer to [holder]."), span_infoplain("You install the internal armor layer to [holder]."))
				holder.icon_state = "pinnace19"
			else
				user.visible_message(span_infoplain("[user] unfastens the manual flight controls."), span_infoplain("You unfasten the manual flight controls."))
				holder.icon_state = "pinnace13"
		if(5)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] bolts the internal armor layer."), span_infoplain("You bolt the internal armor layer."))
				holder.icon_state = "pinnace20"
			else
				user.visible_message(span_infoplain("[user] pries the internal armor layer from [holder]."), span_infoplain("You pry the internal armor layer from [holder]."))
				var/obj/item/stack/material/steel/MS = new /obj/item/stack/material/steel(get_turf(holder))
				MS.amount = 5
				holder.icon_state = "pinnace14"
		if(4)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] welds the internal armor layer into place on [holder]."), span_infoplain("You weld the internal armor layer into place on [holder]."))
				holder.icon_state = "pinnace21"
			else
				user.visible_message(span_infoplain("[user] unbolt the internal armor layer."), span_infoplain("You unbolt the internal armor layer."))
				holder.icon_state = "pinnace19"
		if(3)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] installs the external reinforced armor layer to [holder]."), span_infoplain("You install the external reinforced armor layer to [holder]."))
				holder.icon_state = "pinnace22"
			else
				user.visible_message(span_infoplain("[user] cuts internal armor layer from [holder]."), span_infoplain("You cut the internal armor layer from [holder]."))
				holder.icon_state = "pinnace20"
		if(2)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] bolts external armor layer."), span_infoplain("You bolt external reinforced armor layer."))
				holder.icon_state = "pinnace23"
			else
				user.visible_message(span_infoplain("[user] pries the external armor layer from [holder]."), span_infoplain("You pry external armor layer from [holder]."))
				var/obj/item/stack/material/plasteel/MS = new /obj/item/stack/material/plasteel(get_turf(holder))
				MS.amount = 5
				holder.icon_state = "pinnace21"
		if(1)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] welds the external armor layer to [holder]."), span_infoplain("You weld the external armor layer to [holder]."))
			else
				user.visible_message(span_infoplain("[user] unbolts the external armor layer."), span_infoplain("You unbolt the external armor layer."))
				holder.icon_state = "pinnace22"
	return 1

/datum/construction/reversible/mecha/fighter/pinnace/spawn_result()
	..()
	feedback_inc("mecha_fighter_pinnace_created",1)
	return

//////////////////////
//		Baron
//////////////////////
/datum/construction/mecha/fighter/baron_chassis
	result = "/obj/mecha/combat/fighter/baron"
	steps = list(list("key"=/obj/item/mecha_parts/fighter/part/baron_core),//1
					 list("key"=/obj/item/mecha_parts/fighter/part/baron_cockpit),//2
					 list("key"=/obj/item/mecha_parts/fighter/part/baron_main_engine),//3
					 list("key"=/obj/item/mecha_parts/fighter/part/baron_left_engine),//4
					 list("key"=/obj/item/mecha_parts/fighter/part/baron_right_engine),//5
					 list("key"=/obj/item/mecha_parts/fighter/part/baron_left_wing),//6
					 list("key"=/obj/item/mecha_parts/fighter/part/baron_right_wing)//final
					)

/datum/construction/mecha/fighter/baron_chassis/custom_action(step, obj/item/I, mob/user)
	user.visible_message(span_infoplain("[user] has connected [I] to [holder]."), span_infoplain("You connect [I] to [holder]"))
	holder.add_overlay("[I.icon_state]+o")
	qdel(I)
	return 1

/datum/construction/mecha/fighter/baron_chassis/action(obj/item/I,mob/user as mob)
	return check_all_steps(I,user)

/datum/construction/mecha/fighter/baron_chassis/spawn_result()
	var/obj/item/mecha_parts/chassis/const_holder = holder
	const_holder.construct = new /datum/construction/reversible/mecha/fighter/baron(const_holder)
	const_holder.icon = 'icons/mecha/fighters_construction64x64.dmi'
	const_holder.icon_state = "baron0"
	const_holder.density = 1
	spawn()
		qdel(src)
	return

/datum/construction/reversible/mecha/fighter/baron
	result = "/obj/mecha/combat/fighter/baron"
	steps = list(
					//1
					list("key"=IS_WELDER,
							"backkey"=IS_WRENCH,
							"desc"="External armor is bolted into place."),
					//2
					list("key"=IS_WRENCH,
							"backkey"=IS_CROWBAR,
							"desc"="External armor is installed."),
					//3
					list("key"=/obj/item/stack/material/plasteel,
							"backkey"=IS_WELDER,
							"desc"="The internal armor is welded into place."),
					//4
					list("key"=IS_WELDER,
							"backkey"=IS_WRENCH,
							"desc"="The internal armor is bolted into place."),
					//5
					list("key"=IS_WRENCH,
							"backkey"=IS_CROWBAR,
							"desc"="The internal armor is installed."),
					//6
					list("key"=/obj/item/stack/material/steel,
							"backkey"=IS_SCREWDRIVER,
							"desc"="The manual flight control instruments are secured."),
					//7
					list("key"=IS_SCREWDRIVER,
							"backkey"=IS_CROWBAR,
							"desc"="The manual flight control instruments are installed."),
					//8
					list("key"=/obj/item/circuitboard/mecha/fighter/baron/cockpitboard,
							"backkey"=IS_SCREWDRIVER,
							"desc"="The advanced capacitor is secured."),
					//9
					list("key"=IS_SCREWDRIVER,
							"backkey"=IS_CROWBAR,
							"desc"="The advanced capacitor is installed."),
					//10
					list("key"=/obj/item/stock_parts/capacitor/adv,
							"backkey"=IS_SCREWDRIVER,
							"desc"="The targeting module is secured."),
					//11
					list("key"=IS_SCREWDRIVER,
							"backkey"=IS_CROWBAR,
							"desc"="The targeting module is installed."),
					//12
					list("key"=/obj/item/circuitboard/mecha/fighter/baron/targeting,
							"backkey"=IS_SCREWDRIVER,
							"desc"="The flight control module is secured."),
					//13
					list("key"=IS_SCREWDRIVER,
							"backkey"=IS_CROWBAR,
							"desc"="The flight control module is installed."),
					//14
					list("key"=/obj/item/circuitboard/mecha/fighter/baron/flight,
							"backkey"=IS_SCREWDRIVER,
							"desc"="The central control module is secured."),
					//15
					list("key"=IS_SCREWDRIVER,
							"backkey"=IS_CROWBAR,
							"desc"="The central control module is installed."),
					//16
					list("key"=/obj/item/circuitboard/mecha/fighter/baron/main,
							"backkey"=IS_SCREWDRIVER,
							"desc"="The internal wiring is adjusted."),
					//17
					list("key"=IS_WIRECUTTER,
							"backkey"=IS_SCREWDRIVER,
							"desc"="The internal wiring is added."),
					//18
					list("key"=/obj/item/stack/cable_coil,
							"backkey"=IS_SCREWDRIVER,
							"desc"="The hydraulic landing gear are deployed."),
					//19
					list("key"=IS_SCREWDRIVER,
							"backkey"=IS_WRENCH,
							"desc"="The hydraulic landing gear are attached."),
					//20
					list("key"=IS_WRENCH,
							"desc"="The hydraulic landing gear are detached.")
					)

/datum/construction/reversible/mecha/fighter/baron/action(obj/item/I,mob/user as mob)
	return check_step(I,user)

/datum/construction/reversible/mecha/fighter/baron/custom_action(index, diff, obj/item/I, mob/user)
	if(!..())
		return 0

	switch(index)
		if(20)
			user.visible_message(span_infoplain("[user] attaches [holder]'s hydraulic landing gear."), span_infoplain("You attach [holder]'s hydraulic landing gear."))
			holder.icon_state = "baron1"
		if(19)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] deploys [holder]'s hydraulic landing gear."), span_infoplain("You deploy [holder]'s hydraulic landing gear."))
				holder.icon_state = "baron2"
			else
				user.visible_message(span_infoplain("[user] removes [holder]'s hydraulic landing gear."), span_infoplain("You remove [holder]'s hydraulic landing gear."))
				holder.icon_state = "baron0"
		if(18)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] adds the internal wiring to [holder]."), span_infoplain("You add the internal wiring to [holder]."))
				holder.icon_state = "baron3"
			else
				user.visible_message(span_infoplain("[user] retracts [holder]'s hydraulic landing gear."), span_infoplain("You retract [holder]'s hydraulic landing gear."))
				holder.icon_state = "baron1"
		if(17)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] adjusts the internal wiring of [holder]."), span_infoplain("You adjust the internal wiring of [holder]."))
				holder.icon_state = "baron4"
			else
				user.visible_message(span_infoplain("[user] removes the internal wiring from [holder]."), span_infoplain("You remove the internal wiring from [holder]."))
				var/obj/item/stack/cable_coil/coil = new /obj/item/stack/cable_coil(get_turf(holder))
				coil.amount = 4
				holder.icon_state = "baron2"
		if(16)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] installs the central control module into [holder]."), span_infoplain("You install the central control module into [holder]."))
				qdel(I)
				holder.icon_state = "baron5"
			else
				user.visible_message(span_infoplain("[user] disconnects the wiring of [holder]."), span_infoplain("You disconnect the wiring of [holder]."))
				holder.icon_state = "baron3"
		if(15)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] secures the central control module."), span_infoplain("You secure the central control module."))
				holder.icon_state = "baron6"
			else
				user.visible_message(span_infoplain("[user] removes the central control module from [holder]."), span_infoplain("You remove the central control module from [holder]."))
				new /obj/item/circuitboard/mecha/fighter/baron/main(get_turf(holder))
				holder.icon_state = "baron4"
		if(14)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] installs the flight control module into [holder]."), span_infoplain("You install the flight control module into [holder]."))
				qdel(I)
				holder.icon_state = "baron7"
			else
				user.visible_message(span_infoplain("[user] unfastens the central control module."), span_infoplain("You unfasten the central control module."))
				holder.icon_state = "baron5"
		if(13)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] secures the flight control module."), span_infoplain("You secure the flight control module."))
				holder.icon_state = "baron8"
			else
				user.visible_message(span_infoplain("[user] removes the flight control module from [holder]."), span_infoplain("You remove the flight control module from [holder]."))
				new /obj/item/circuitboard/mecha/fighter/baron/flight(get_turf(holder))
				holder.icon_state = "baron6"
		if(12)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] installs the targeting control module into [holder]."), span_infoplain("You install the targeting control module into [holder]."))
				qdel(I)
				holder.icon_state = "baron9"
			else
				user.visible_message(span_infoplain("[user] unfastens the peripherals control module."), span_infoplain("You unfasten the peripherals control module."))
				holder.icon_state = "baron7"
		if(11)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] secures the targeting control module."), span_infoplain("You secure the targeting control module."))
				holder.icon_state = "baron10"
			else
				user.visible_message(span_infoplain("[user] removes the targeting control module from [holder]."), span_infoplain("You remove the targeting control module from [holder]."))
				new /obj/item/circuitboard/mecha/fighter/baron/targeting(get_turf(holder))
				holder.icon_state = "baron8"
		if(10)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] installs the advanced capacitor into [holder]."), span_infoplain("You install the advanced capacitor into [holder]."))
				qdel(I)
				holder.icon_state = "baron11"
			else
				user.visible_message(span_infoplain("[user] unfastens the targeting control module."), span_infoplain("You unfasten the targeting control module."))
				holder.icon_state = "baron9"
		if(9)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] secures the advanced capacitor."), span_infoplain("You secure the advanced capacitor."))
				holder.icon_state = "baron12"
			else
				user.visible_message(span_infoplain("[user] removes the advanced capacitor from [holder]."), span_infoplain("You remove the advanced capacitor from [holder]."))
				new /obj/item/stock_parts/capacitor/adv(get_turf(holder))
				holder.icon_state = "baron10"
		if(8)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] installs the manual flight controls to [holder]."), span_infoplain("You install the manual flight controls to [holder]."))
				qdel(I)
				holder.icon_state = "baron13"
			else
				user.visible_message(span_infoplain("[user] unfastens the advanced capacitor."), span_infoplain("You unfasten the advanced capacitor."))
				holder.icon_state = "baron11"
		if(7)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] secures the manual flight controls."), span_infoplain("You secure the manual flight controls."))
				holder.icon_state = "baron14"
			else
				user.visible_message(span_infoplain("[user] removes the manual flight controls from [holder]."), span_infoplain("You remove the manual flight controls from [holder]."))
				new /obj/item/circuitboard/mecha/fighter/baron/cockpitboard(get_turf(holder))
				holder.icon_state = "baron12"
		if(6)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] installs the internal armor layer to [holder]."), span_infoplain("You install the internal armor layer to [holder]."))
				holder.icon_state = "baron19"
			else
				user.visible_message(span_infoplain("[user] unfastens the manual flight controls."), span_infoplain("You unfasten the manual flight controls."))
				holder.icon_state = "baron13"
		if(5)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] bolts the internal armor layer."), span_infoplain("You bolt the internal armor layer."))
				holder.icon_state = "baron20"
			else
				user.visible_message(span_infoplain("[user] pries the internal armor layer from [holder]."), span_infoplain("You pry the internal armor layer from [holder]."))
				var/obj/item/stack/material/steel/MS = new /obj/item/stack/material/steel(get_turf(holder))
				MS.amount = 5
				holder.icon_state = "baron14"
		if(4)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] welds the internal armor layer into place on [holder]."), span_infoplain("You weld the internal armor layer into place on [holder]."))
				holder.icon_state = "baron21"
			else
				user.visible_message(span_infoplain("[user] unbolt the internal armor layer."), span_infoplain("You unbolt the internal armor layer."))
				holder.icon_state = "baron19"
		if(3)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] installs the external reinforced armor layer to [holder]."), span_infoplain("You install the external reinforced armor layer to [holder]."))
				holder.icon_state = "baron22"
			else
				user.visible_message(span_infoplain("[user] cuts internal armor layer from [holder]."), span_infoplain("You cut the internal armor layer from [holder]."))
				holder.icon_state = "baron20"
		if(2)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] bolts external armor layer."), span_infoplain("You bolt external reinforced armor layer."))
				holder.icon_state = "baron23"
			else
				user.visible_message(span_infoplain("[user] pries the external armor layer from [holder]."), span_infoplain("You pry external armor layer from [holder]."))
				var/obj/item/stack/material/plasteel/MS = new /obj/item/stack/material/plasteel(get_turf(holder))
				MS.amount = 5
				holder.icon_state = "baron21"
		if(1)
			if(diff==FORWARD)
				user.visible_message(span_infoplain("[user] welds the external armor layer to [holder]."), span_infoplain("You weld the external armor layer to [holder]."))
			else
				user.visible_message(span_infoplain("[user] unbolts the external armor layer."), span_infoplain("You unbolt the external armor layer."))
				holder.icon_state = "baron22"
	return 1

/datum/construction/reversible/mecha/fighter/baron/spawn_result()
	..()
	feedback_inc("mecha_fighter_baron_created",1)
	return
