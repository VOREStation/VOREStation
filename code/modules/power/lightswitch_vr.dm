//
// Lightswitch Construction
// Note: This does not use the normal frame.dm approach becuase:
// 1) That requires circuits, and I don't want a circuit board instance in every lightswitch.
// 2) This is an experiment in modernizing construction steps and examine tabs.

// The frame item in hand
/obj/item/frame/lightswitch
	name = "light switch frame"
	desc = "Used for building light switches."
	icon = 'icons/obj/power_vr.dmi'
	icon_state = "lightswitch-s1"
	build_machine_type = /obj/structure/construction/lightswitch
	refund_amt = 2

// The under construction light switch
/obj/structure/construction/lightswitch
	name = "light switch frame"
	desc = "A light switch under construction."
	icon = 'icons/obj/power_vr.dmi'
	icon_state = "lightswitch-s1"
	base_icon = "lightswitch-s"
	build_machine_type = /obj/machinery/light_switch
	x_offset = 26
	y_offset = 26

// Attackby on the lightswitch for deconstruction steps.
/obj/machinery/light_switch/attackby(obj/item/W, mob/user, params)
	src.add_fingerprint(user)
	if(default_deconstruction_screwdriver(user, W))
		return
	if(default_deconstruction_crowbar(user, W))
		return
	return ..()

/obj/machinery/light_switch/dismantle()
	playsound(src, 'sound/items/Crowbar.ogg', 50, 1)
	var/obj/structure/construction/lightswitch/A = new(src.loc, src.dir)
	A.stage = FRAME_WIRED
	A.pixel_x = pixel_x
	A.pixel_y = pixel_y
	A.update_icon()
	qdel(src)
	return 1

//
// Simple Construction Frame - Simpler than the full frame system for circuitless construction.
// If this works out well for light switches we can use it for other lightweight constructables.
//

/obj/structure/construction
	name = "simple frame prototype"
	desc = "This is a prototype object and you should not see it, report to a developer"
	anchored = TRUE
	var/base_icon = "something"
	var/stage = FRAME_UNFASTENED
	var/build_machine_type = null
	var/x_offset = 26
	var/y_offset = 26

/obj/structure/construction/Initialize(var/mapload, var/ndir, var/building = FALSE)
	. = ..()
	if(ndir)
		set_dir(ndir)
	if(x_offset)
		pixel_x = (dir & 3) ? 0 : (dir == EAST ? -x_offset : x_offset)
	if(y_offset)
		pixel_y = (dir & 3) ? (dir == NORTH ? -y_offset : y_offset) : 0

/obj/structure/construction/examine(mob/user)
	. = ..()
	if(get_dist(user, src) <= 2)
		switch(stage)
			if(FRAME_UNFASTENED)
				. += "It's an empty frame."
			if(FRAME_FASTENED)
				. += "It's fixed to the wall."
			if(FRAME_WIRED)
				. += "It's wired."

/obj/structure/construction/update_icon()
	icon_state = "[base_icon][stage]"

/obj/structure/construction/attackby(obj/item/weapon/W as obj, mob/user as mob)
	add_fingerprint(user)
	if(W.has_tool_quality(TOOL_WELDER))
		if(stage == FRAME_UNFASTENED)
			var/obj/item/weapon/weldingtool/WT = W.get_welder()
			if(!WT.remove_fuel(0, user))
				to_chat(user, "<span class='warning'>\The [src] must be on to complete this task.</span>")
				return
			playsound(src, WT.usesound, 50, 1)
			user.visible_message( \
				"<span class='warning'>\The [user] begins deconstructing \the [src].</span>", \
				"<span class='notice'>You start deconstructing \the [src].</span>")
			if(do_after(user, 20 * WT.toolspeed, target = src) && WT.isOn())
				new /obj/item/stack/material/steel(get_turf(src), 2)
				user.visible_message( \
					"<span class='warning'>\The [user] has deconstructed \the [src].</span>", \
					"<span class='notice'>You deconstruct \the [src].</span>")
				playsound(src, 'sound/items/Deconstruct.ogg', 75, 1)
				qdel(src)
		else if (stage == FRAME_FASTENED)
			to_chat(user, "You have to unscrew the case first.")
		else if (stage == FRAME_WIRED)
			to_chat(user, "You have to remove the wires first.")
		return

	else if(W.has_tool_quality(TOOL_WIRECUTTER))
		if (stage == FRAME_WIRED)
			stage = FRAME_FASTENED
			user.update_examine_panel(src)
			new /obj/item/stack/cable_coil(get_turf(src), 1, "red")
			user.visible_message("\The [user] removes the wiring from \the [src].", \
				"You remove the wiring from \the [src].", "You hear a snip.")
			playsound(src, W.usesound, 50, 1)
			update_icon()
		return

	else if(istype(W, /obj/item/stack/cable_coil))
		if (stage == FRAME_FASTENED)
			var/obj/item/stack/cable_coil/coil = W
			if (coil.use(1))
				stage = FRAME_WIRED
				user.update_examine_panel(src)
				user.visible_message("\The [user] adds wires to \the [src].", \
					"You add wires to \the [src].", "You hear a noise.")
				playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
				update_icon()
		return

	else if(W.has_tool_quality(TOOL_SCREWDRIVER))
		if (stage == FRAME_UNFASTENED)
			stage = FRAME_FASTENED
			user.update_examine_panel(src)
			user.visible_message("\The [user] screws \the [src] i nplace.", \
				"You screw \the [src] in place.", "You hear a noise.")
			playsound(src, W.usesound, 75, 1)
			update_icon()
		else if (stage == FRAME_FASTENED)
			stage = FRAME_UNFASTENED
			user.update_examine_panel(src)
			user.visible_message("\The [user] unscrews \the [src].", \
				"You unscrew \the [src].", "You hear a noise.")
			playsound(src, W.usesound, 75, 1)
			update_icon()
		else if (stage == FRAME_WIRED)
			user.visible_message("\The [user] closes \the [src]'s casing.", \
				"You close \the [src]'s casing.", "You hear a click.")
			playsound(src, W.usesound, 75, 1)
			var/obj/newmachine = new build_machine_type(get_turf(src), src.dir)
			newmachine.pixel_x = pixel_x
			newmachine.pixel_y = pixel_y
			transfer_fingerprints_to(newmachine)
			qdel(src)
		return
	. = ..()

/obj/structure/construction/get_description_interaction()
	. = list()
	switch(stage)
		if(FRAME_UNFASTENED)
			. += list(
				"[desc_panel_image("screwdriver")]to continue construction.",
				"[desc_panel_image("welder")]to deconstruct.")
		if(FRAME_FASTENED)
			. += list(
				"[desc_panel_image("cable coil")]to continue construction.",
				"[desc_panel_image("screwdriver")]to reverse construction.")
		if(FRAME_WIRED)
			. += list(
				"[desc_panel_image("screwdriver")]to finish construction.",
				"[desc_panel_image("wirecutters")]to reverse construction.")
