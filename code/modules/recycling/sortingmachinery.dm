/obj/machinery/disposal/deliveryChute
	name = "Delivery chute"
	desc = "A chute for big and small packages alike!"
	density = TRUE
	icon_state = "intake"
	stat_tracking = FALSE
	var/c_mode = FALSE

/obj/machinery/disposal/deliveryChute/interact()
	return

/obj/machinery/disposal/deliveryChute/update_icon()
	return

/obj/machinery/disposal/deliveryChute/click_alt(mob/user) //No flushing the chute
	return

/obj/machinery/disposal/deliveryChute/Bumped(var/atom/movable/AM) //Go straight into the chute
	if(QDELETED(AM) || istype(AM, /obj/item/projectile) || istype(AM, /obj/effect) || istype(AM, /obj/mecha))	return
	switch(dir)
		if(NORTH)
			if(AM.loc.y != src.loc.y+1) return
		if(EAST)
			if(AM.loc.x != src.loc.x+1) return
		if(SOUTH)
			if(AM.loc.y != src.loc.y-1) return
		if(WEST)
			if(AM.loc.x != src.loc.x-1) return

	if(isobj(AM) || ismob(AM))
		AM.forceMove(src)
	flush()

/obj/machinery/disposal/deliveryChute/hitby(atom/movable/source, datum/thrownthing/throwingdatum)
	if(!QDELETED(source) || (isitem(source) || isliving(source)) && !istype(source, /obj/item/projectile))
		switch(dir)
			if(NORTH)
				if(source.loc.y != src.loc.y+1) return ..()
			if(EAST)
				if(source.loc.x != src.loc.x+1) return ..()
			if(SOUTH)
				if(source.loc.y != src.loc.y-1) return ..()
			if(WEST)
				if(source.loc.x != src.loc.x-1) return ..()
		source.forceMove(src)
		flush()

/obj/machinery/disposal/deliveryChute/attackby(var/obj/item/I, var/mob/user)
	if(!I || !user)
		return

	if(I.has_tool_quality(TOOL_SCREWDRIVER))
		c_mode = !c_mode
		playsound(src, I.usesound, 50, 1)
		to_chat(user, "You [c_mode ? "remove" : "attach"] the screws around the power connection.")
		return
	if(I.has_tool_quality(TOOL_WELDER) && c_mode == TRUE)
		var/obj/item/weldingtool/W = I.get_welder()
		if(!W.remove_fuel(0,user))
			to_chat(user, "You need more welding fuel to complete this task.")
			return
		playsound(src, W.usesound, 50, 1)
		to_chat(user, "You start slicing the floorweld off the delivery chute.")
		if(do_after(user, 2 SECONDS * W.toolspeed, target = src))
			if(!src || !W.isOn()) return
			to_chat(user, "You sliced the floorweld off the delivery chute.")
			var/obj/structure/disposalconstruct/C = new (src.loc)
			C.ptype = 8 // 8 =  Delivery chute
			C.update()
			C.anchored = TRUE
			C.density = TRUE
			qdel(src)
		return
