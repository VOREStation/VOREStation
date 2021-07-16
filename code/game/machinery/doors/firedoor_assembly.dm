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
			to_chat(user, "<span class='warning'>You need one length of coil to wire \the [src].</span>")
			return
		user.visible_message("[user] wires \the [src].", "You start to wire \the [src].")
		if(do_after(user, 40) && !wired && anchored)
			if (cable.use(1))
				wired = 1
				to_chat(user, "<span class='notice'>You wire \the [src].</span>")

	else if(C.is_wirecutter() && wired )
		playsound(src, C.usesound, 100, 1)
		user.visible_message("[user] cuts the wires from \the [src].", "You start to cut the wires from \the [src].")

		if(do_after(user, 40))
			if(!src) return
			to_chat(user, "<span class='notice'>You cut the wires!</span>")
			new/obj/item/stack/cable_coil(src.loc, 1)
			wired = 0

	else if(istype(C, /obj/item/weapon/circuitboard/airalarm) && wired)
		if(anchored)
			playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
			user.visible_message("<span class='warning'>[user] has inserted a circuit into \the [src]!</span>",
								  "You have inserted the circuit into \the [src]!")
			if(glass)
				new /obj/machinery/door/firedoor/glass(loc)
			else
				new /obj/machinery/door/firedoor(loc)
			qdel(C)
			qdel(src)
		else
			to_chat(user, "<span class='warning'>You must secure \the [src] first!</span>")
	else if(C.is_wrench())
		anchored = !anchored
		playsound(src, C.usesound, 50, 1)
		user.visible_message("<span class='warning'>[user] has [anchored ? "" : "un" ]secured \the [src]!</span>",
							  "You have [anchored ? "" : "un" ]secured \the [src]!")
		update_icon()
	else if((glass || !anchored) && istype(C, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = C
		if(WT.remove_fuel(0, user))
			playsound(src, WT.usesound, 50, 1)
			if(glass)
				user.visible_message("<span class='warning'>[user] welds the glass panel out of \the [src].</span>",
									"<span class='notice'>You start to weld the glass panel out of \the [src].</span>")
				if(do_after(user, 40 * WT.toolspeed, src) && WT.isOn())
					to_chat(user, "<span class='notice'>You welded the glass panel out!</span>")
					new /obj/item/stack/material/glass/reinforced(drop_location())
					glass = FALSE
					update_icon()
				return
			if(!anchored)
				user.visible_message("<span class='warning'>[user] dissassembles \the [src].</span>", "You start to dissassemble \the [src].")
				if(do_after(user, 40 * WT.toolspeed, src) && WT.isOn())
					user.visible_message("<span class='warning'>[user] has dissassembled \the [src].</span>",
										"You have dissassembled \the [src].")
					new /obj/item/stack/material/steel(drop_location(), 2)
					qdel(src)
				return
		else
			to_chat(user, "<span class='notice'>You need more welding fuel.</span>")
	else if(istype(C, /obj/item/stack/material) && C.get_material_name() == "rglass" && !glass)
		var/obj/item/stack/S = C
		if (S.get_amount() >= 1)
			playsound(src, 'sound/items/Crowbar.ogg', 100, 1)
			user.visible_message("<span class='info'>[user] adds [S.name] to \the [src].</span>",
								"<span class='notice'>You start to install [S.name] into \the [src].</span>")
			if(do_after(user, 40, src) && !glass && S.use(1))
				to_chat(user, "<span class='notice'>You installed reinforced glass windows into \the [src].</span>")
				glass = TRUE
				update_icon()

	else
		..(C, user)
