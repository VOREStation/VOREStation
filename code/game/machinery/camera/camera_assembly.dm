/obj/item/camera_assembly
	name = "camera assembly"
	desc = "A pre-fabricated security camera kit, ready to be assembled and mounted to a surface."
	icon = 'icons/obj/monitors_vr.dmi' //VOREStation Edit - New Icons
	icon_state = "cameracase"
	w_class = ITEMSIZE_SMALL
	anchored = FALSE

	matter = list(MAT_STEEL = 700,MAT_GLASS = 300)

	//	Motion, EMP-Proof, X-Ray
	var/list/obj/item/possible_upgrades = list(/obj/item/assembly/prox_sensor, /obj/item/stack/material/osmium, /obj/item/stock_parts/scanning_module)
	var/list/upgrades = list()
	var/camera_name
	var/camera_network
	var/state = 0
	var/busy = 0
	/*
				0 = Nothing done to it
				1 = Wrenched in place
				2 = Welded in place
				3 = Wires attached to it (you can now attach/dettach upgrades)
				4 = Screwdriver panel closed and is fully built (you cannot attach upgrades)
	*/

/obj/item/camera_assembly/attackby(obj/item/W as obj, mob/living/user as mob)

	switch(state)

		if(0)
			// State 0
			if(W.has_tool_quality(TOOL_WRENCH) && isturf(src.loc))
				playsound(src, W.usesound, 50, 1)
				to_chat(user, "You wrench the assembly into place.")
				anchored = TRUE
				state = 1
				update_icon()
				auto_turn()
				return

		if(1)
			// State 1
			if(W.has_tool_quality(TOOL_WELDER))
				if(weld(W, user))
					to_chat(user, "You weld the assembly securely into place.")
					anchored = TRUE
					state = 2
				return

			else if(W.has_tool_quality(TOOL_WRENCH))
				playsound(src, W.usesound, 50, 1)
				to_chat(user, "You unattach the assembly from its place.")
				anchored = FALSE
				update_icon()
				state = 0
				return

		if(2)
			// State 2
			if(istype(W, /obj/item/stack/cable_coil))
				var/obj/item/stack/cable_coil/C = W
				if(C.use(2))
					to_chat(user, span_notice("You add wires to the assembly."))
					state = 3
				else
					to_chat(user, span_warning("You need 2 coils of wire to wire the assembly."))
				return

			else if(W.has_tool_quality(TOOL_WELDER))

				if(weld(W, user))
					to_chat(user, "You unweld the assembly from its place.")
					state = 1
					anchored = TRUE
				return


		if(3)
			// State 3
			if(W.has_tool_quality(TOOL_SCREWDRIVER))
				playsound(src, W.usesound, 50, 1)

				var/input = sanitize(tgui_input_text(user, "Which networks would you like to connect this camera to? Separate networks with a comma. No Spaces!\nFor example: "+using_map.station_short+",Security,Secret ", "Set Network", camera_network ? camera_network : NETWORK_DEFAULT))
				if(!input)
					to_chat(user, "No input found please hang up and try your call again.")
					return

				var/list/tempnetwork = splittext(input, ",")
				if(tempnetwork.len < 1)
					to_chat(user, "No network found please hang up and try your call again.")
					return

				var/area/camera_area = get_area(src)
				var/temptag = "[sanitize(camera_area.name)] ([rand(1, 999)])"
				input = sanitizeSafe(tgui_input_text(user, "How would you like to name the camera?", "Set Camera Name", camera_name ? camera_name : temptag), MAX_NAME_LEN)

				state = 4
				var/obj/machinery/camera/C = new(src.loc)
				src.loc = C
				C.assembly = src

				C.auto_turn()

				C.replace_networks(uniqueList(tempnetwork))

				C.c_tag = input

				for(var/i = 5; i >= 0; i -= 1)
					var/direct = tgui_input_list(user, "Direction?", "Assembling Camera", list("NORTH", "EAST", "SOUTH", "WEST", "LEAVE IT"))
					if(direct != "LEAVE IT")
						C.dir = text2dir(direct)
					if(i != 0)
						var/confirm = tgui_alert(user, "Is this what you want? Chances Remaining: [i]", "Confirmation", list("Yes", "No"))
						if(confirm == "Yes")
							break
				return

			else if(W.has_tool_quality(TOOL_WIRECUTTER))

				new/obj/item/stack/cable_coil(get_turf(src), 2)
				playsound(src, W.usesound, 50, 1)
				to_chat(user, "You cut the wires from the circuits.")
				state = 2
				return

	// Upgrades!
	if(is_type_in_list(W, possible_upgrades) && !is_type_in_list(W, upgrades)) // Is a possible upgrade and isn't in the camera already.
		to_chat(user, "You attach \the [W] into the assembly inner circuits.")
		upgrades += W
		user.remove_from_mob(W)
		W.loc = src
		return

	// Taking out upgrades
	else if(W.has_tool_quality(TOOL_CROWBAR) && upgrades.len)
		var/obj/U = locate(/obj) in upgrades
		if(U)
			to_chat(user, "You unattach an upgrade from the assembly.")
			playsound(src, W.usesound, 50, 1)
			U.loc = get_turf(src)
			upgrades -= U
		return

	..()

/obj/item/camera_assembly/update_icon()
	if(anchored)
		icon_state = "camera1"
	else
		icon_state = "cameracase"

/obj/item/camera_assembly/attack_hand(mob/user as mob)
	if(!anchored)
		..()

/obj/item/camera_assembly/proc/weld(var/obj/item/weldingtool/WT, var/mob/user)
	WT = WT.get_welder()

	if(busy)
		return 0
	if(!WT.isOn())
		return 0

	to_chat(user, span_notice("You start to weld the [src].."))
	playsound(src, WT.usesound, 50, 1)
	WT.eyecheck(user)
	busy = 1
	if(do_after(user, 20 * WT.toolspeed))
		busy = 0
		if(!WT.isOn())
			return 0
		return 1
	busy = 0
	return 0
