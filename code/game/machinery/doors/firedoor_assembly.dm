/obj/structure/firedoor_assembly
	name = "\improper emergency shutter assembly"
	desc = "It can save lives."
	icon = 'icons/obj/doors/DoorHazard.dmi'
	icon_state = "door_construction"
	anchored = FALSE
	opacity = 0
	density = TRUE
	var/wired = 0
	var/glass = FALSE

/obj/structure/firedoor_assembly/update_icon()
	if(glass)
		icon = 'icons/obj/doors/DoorHazardGlass.dmi'
	else
		icon = 'icons/obj/doors/DoorHazard.dmi'
	if(anchored)
		icon_state = "door_anchored"
	else
		icon_state = "door_construction"

/obj/structure/firedoor_assembly/attackby(obj/item/C, mob/user as mob)
	if(istype(C, /obj/item/stack/cable_coil) && !wired && anchored)
		var/obj/item/stack/cable_coil/cable = C
		if (cable.get_amount() < 1)
			to_chat(user, span_warning("You need one length of coil to wire \the [src]."))
			return
		user.visible_message("[user] wires \the [src].", "You start to wire \the [src].")
		if(do_after(user, 40) && !wired && anchored)
			if (cable.use(1))
				wired = 1
				to_chat(user, span_notice("You wire \the [src]."))

	else if(C.has_tool_quality(TOOL_WIRECUTTER) && wired )
		playsound(src, C.usesound, 100, 1)
		user.visible_message("[user] cuts the wires from \the [src].", "You start to cut the wires from \the [src].")

		if(do_after(user, 40))
			if(!src) return
			to_chat(user, span_notice("You cut the wires!"))
			new/obj/item/stack/cable_coil(src.loc, 1)
			wired = 0

	else if(istype(C, /obj/item/circuitboard/airalarm) && wired)
		if(anchored)
			playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
			user.visible_message(span_warning("[user] has inserted a circuit into \the [src]!"),
								  "You have inserted the circuit into \the [src]!")
			if(glass)
				new /obj/machinery/door/firedoor/glass(loc)
			else
				new /obj/machinery/door/firedoor(loc)
			qdel(C)
			qdel(src)
		else
			to_chat(user, span_warning("You must secure \the [src] first!"))
	else if(C.has_tool_quality(TOOL_WRENCH))
		anchored = !anchored
		playsound(src, C.usesound, 50, 1)
		user.visible_message(span_warning("[user] has [anchored ? "" : "un" ]secured \the [src]!"),
							  "You have [anchored ? "" : "un" ]secured \the [src]!")
		update_icon()
	else if((glass || !anchored) && C.has_tool_quality(TOOL_WELDER))
		var/obj/item/weldingtool/WT = C.get_welder()
		if(WT.remove_fuel(0, user))
			playsound(src, WT.usesound, 50, 1)
			if(glass)
				user.visible_message(span_warning("[user] welds the glass panel out of \the [src]."),
									span_notice("You start to weld the glass panel out of \the [src]."))
				if(do_after(user, 40 * WT.toolspeed, src) && WT.isOn())
					to_chat(user, span_notice("You welded the glass panel out!"))
					new /obj/item/stack/material/glass/reinforced(drop_location())
					glass = FALSE
					update_icon()
				return
			if(!anchored)
				user.visible_message(span_warning("[user] dissassembles \the [src]."), "You start to dissassemble \the [src].")
				if(do_after(user, 40 * WT.toolspeed, src) && WT.isOn())
					user.visible_message(span_warning("[user] has dissassembled \the [src]."),
										"You have dissassembled \the [src].")
					new /obj/item/stack/material/steel(drop_location(), 2)
					qdel(src)
				return
		else
			to_chat(user, span_notice("You need more welding fuel."))
	else if(istype(C, /obj/item/stack/material) && C.get_material_name() == MAT_RGLASS && !glass)
		var/obj/item/stack/S = C
		if (S.get_amount() >= 1)
			playsound(src, 'sound/items/Crowbar.ogg', 100, 1)
			user.visible_message(span_info("[user] adds [S.name] to \the [src]."),
								span_notice("You start to install [S.name] into \the [src]."))
			if(do_after(user, 40, src) && !glass && S.use(1))
				to_chat(user, span_notice("You installed reinforced glass windows into \the [src]."))
				glass = TRUE
				update_icon()

	else
		..(C, user)
