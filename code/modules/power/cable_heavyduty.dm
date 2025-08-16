/obj/item/stack/cable_coil/heavyduty
	name = "heavy cable coil"
	icon = 'icons/obj/power.dmi'
	icon_state = "wire"

/obj/structure/cable/heavyduty
	icon = 'icons/obj/power_cond_heavy.dmi'
	name = "large power cable"
	desc = "This cable is tough. It cannot be cut with simple hand tools."
	plane = PLATING_PLANE
	layer = PIPES_LAYER - 0.05 //Just below pipes
	color = null
	var/static/allow_cutting = TRUE // Allows heavy cables to be cut by welder, up to server preference or admin vv during round. Changing it on one changes them all!

/obj/structure/cable/heavyduty/attackby(obj/item/W, mob/user)

	var/turf/T = src.loc
	if(!T.is_plating())
		return

	if(W.has_tool_quality(TOOL_WIRECUTTER))
		to_chat(user, span_notice("These cables are too tough to be cut with those [W.name]."))
		return
	else if(W.has_tool_quality(TOOL_WELDER))
		if(!allow_cutting)
			to_chat(user, span_warning("Something in these cables make them too strong to cut!"))
			return

		var/obj/item/weldingtool/WT = W.get_welder()
		if(!WT.remove_fuel(2, user)) // Takes lots of fuel and time...
			to_chat(user, span_infoplain("The welding tool must be on to complete this task."))
			return

		playsound(src, WT.usesound, 50, 1)
		if(do_after(user, 250 * WT.toolspeed)) // Meant to be an obnoxiously long time due to these being intended as "mapper placed indestructable cables". However explosions can already break them if they turf change.
			var/obj/item/stack/cable_coil/heavyduty/CC
			if(src.d1)	// 0-X cables are 1 unit, X-X cables are 2 units long
				CC = new/obj/item/stack/cable_coil/heavyduty(T, 2, color)
			else
				CC = new/obj/item/stack/cable_coil/heavyduty(T, 1, color)

			src.add_fingerprint(user)
			src.transfer_fingerprints_to(CC)
			for(var/mob/O in viewers(src, null))
				O.show_message(span_warning("[user] cuts the cable."), 1)

			qdel(src)
		return
	else if(istype(W, /obj/item/stack/cable_coil) && !istype(W, /obj/item/stack/cable_coil/heavyduty))
		to_chat(user, span_notice("You will need heavier cables to connect to these."))
		return
	else
		..()

/obj/item/stack/cable_coil/heavyduty/turf_place(turf/simulated/F, mob/user)
	if(istype(F, /turf/simulated/open))
		to_chat(user, span_infoplain("\The [src] isn't flexible enough to do this!"))
		return
	. = ..()

/obj/structure/cable/heavyduty/cableColor(var/colorC)
	return
