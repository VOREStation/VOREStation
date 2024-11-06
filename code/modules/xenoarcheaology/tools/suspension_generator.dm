/obj/machinery/suspension_gen
	name = "suspension field generator"
	desc = "It has stubby bolts up against it's treads for stabilising."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "suspension"
	density = 1
	req_access = list(access_research)
	var/obj/item/cell/cell
	var/obj/item/card/id/auth_card
	var/locked = 1
	var/power_use = 5
	var/obj/effect/suspension_field/suspension_field

/obj/machinery/suspension_gen/Initialize()
	. = ..()
	cell = new /obj/item/cell/high(src)

/obj/machinery/suspension_gen/process()
	if(suspension_field)
		cell.charge -= power_use

		var/turf/T = get_turf(suspension_field)
		for(var/mob/living/M in T)
			M.Weaken(3)
			cell.charge -= power_use
			if(prob(5))
				to_chat(M, span_warning("[pick("You feel tingly","You feel like floating","It is hard to speak","You can barely move")]."))

		for(var/obj/item/I in T)
			if(!suspension_field.contents.len)
				suspension_field.icon_state = "energynet"
				suspension_field.add_overlay("shield2")
			I.forceMove(suspension_field)

		if(cell.charge <= 0)
			deactivate()

/obj/machinery/suspension_gen/attack_hand(var/mob/user)
	if(!panel_open)
		tgui_interact(user)
	else if(cell)
		cell.loc = loc
		cell.add_fingerprint(user)
		cell.update_icon()

		icon_state = "suspension"
		cell = null
		to_chat(user, span_info("You remove the power cell"))

/obj/machinery/suspension_gen/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "XenoarchSuspension", name)
		ui.open()

/obj/machinery/suspension_gen/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	data["cell"] = cell
	data["cellCharge"] = cell?.charge
	data["cellMaxCharge"] = cell?.maxcharge

	data["locked"] = locked
	data["suspension_field"] = suspension_field

	return data

/obj/machinery/suspension_gen/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	switch(action)
		if("toggle_field")
			if(locked)
				return
			if(!suspension_field)
				if(cell.charge > 0)
					if(anchored)
						activate()
					else
						to_chat(usr, span_warning("You are unable to activate [src] until it is properly secured on the ground."))
			else
				deactivate()
			return TRUE

		if("lock")
			if(allowed(usr))
				locked = !locked
				return TRUE

/obj/machinery/suspension_gen/attackby(obj/item/W as obj, mob/user as mob)
	if(!locked && !suspension_field && default_deconstruction_screwdriver(user, W))
		return
	else if(W.has_tool_quality(TOOL_WRENCH))
		if(!suspension_field)
			if(anchored)
				anchored = 0
			else
				anchored = 1
			playsound(src, W.usesound, 50, 1)
			to_chat(user, span_info("You wrench the stabilising bolts [anchored ? "into place" : "loose"]."))
			if(anchored)
				desc = "Its tracks are held firmly in place with securing bolts."
				icon_state = "suspension_wrenched"
			else
				desc = "It has stubby bolts aligned along it's tracks for stabilising."
				icon_state = "suspension"
			playsound(loc, 'sound/items/Ratchet.ogg', 40)
			update_icon()
		else
			to_chat(user, span_warning("You are unable to secure [src] while it is active!"))
	else if (istype(W, /obj/item/cell))
		if(panel_open)
			if(cell)
				to_chat(user, span_warning("There is a power cell already installed."))
			else
				user.drop_item()
				W.loc = src
				cell = W
				to_chat(user, span_info("You insert the power cell."))
				icon_state = "suspension"
	else if(istype(W, /obj/item/card))
		var/obj/item/card/I = W
		if(!auth_card)
			if(attempt_unlock(I, user))
				to_chat(user, span_info("You swipe [I], the console flashes \'<i>Access granted.</i>\'"))
			else
				to_chat(user, span_warning("You swipe [I], console flashes \'<i>Access denied.</i>\'"))
		else
			to_chat(user, span_warning("Remove [auth_card] first."))

/obj/machinery/suspension_gen/proc/attempt_unlock(var/obj/item/card/C, var/mob/user)
	if(!panel_open)
		if(istype(C, /obj/item/card/emag))
			C.resolve_attackby(src, user)
		else if(istype(C, /obj/item/card/id) && check_access(C))
			locked = 0
		if(!locked)
			return 1

/obj/machinery/suspension_gen/emag_act(var/remaining_charges, var/mob/user)
	if(cell.charge > 0 && locked)
		locked = 0
		return 1

//checks for whether the machine can be activated or not should already have occurred by this point
/obj/machinery/suspension_gen/proc/activate()
	var/turf/T = get_turf(get_step(src,dir))
	var/collected = 0

	for(var/mob/living/M in T)
		M.Weaken(5)
		M.visible_message(span_blue("[icon2html(M,viewers(M))] [M] begins to float in the air!"),"You feel tingly and light, but it is difficult to move.")

	suspension_field = new(T)
	visible_message(span_blue("[icon2html(src,viewers(src))] [src] activates with a low hum."))
	icon_state = "suspension_on"
	playsound(loc, 'sound/machines/quiet_beep.ogg', 40)
	update_icon()

	for(var/obj/item/I in T)
		I.loc = suspension_field
		collected++

	if(collected)
		suspension_field.icon_state = "energynet"
		add_overlay("shield2")
		visible_message(span_blue("[icon2html(suspension_field,viewers(src))] [suspension_field] gently absconds [collected > 1 ? "something" : "several things"]."))
	else
		if(istype(T,/turf/simulated/mineral) || istype(T,/turf/simulated/wall))
			suspension_field.icon_state = "shieldsparkles"
		else
			suspension_field.icon_state = "shield2"

/obj/machinery/suspension_gen/proc/deactivate()
	//drop anything we picked up
	var/turf/T = get_turf(suspension_field)

	for(var/mob/living/M in T)
		to_chat(M, span_info("You no longer feel like floating."))
		M.Weaken(3)

	visible_message(span_blue("[icon2html(src,viewers(src))] [src] deactivates with a gentle shudder."))
	qdel(suspension_field)
	suspension_field = null
	icon_state = "suspension_wrenched"
	playsound(loc, 'sound/machines/quiet_beep.ogg', 40)
	update_icon()

/obj/machinery/suspension_gen/Destroy()
	deactivate()
	..()

/obj/machinery/suspension_gen/verb/rotate_counterclockwise()
	set src in view(1)
	set name = "Rotate suspension gen Counterclockwise"
	set category = "Object"

	if(anchored)
		to_chat(usr, span_red("You cannot rotate [src], it has been firmly fixed to the floor."))
		return
	set_dir(turn(dir, 90))

/obj/machinery/suspension_gen/verb/rotate_clockwise()
	set src in view(1)
	set name = "Rotate suspension gen Clockwise"
	set category = "Object"

	if(anchored)
		to_chat(usr, span_red("You cannot rotate [src], it has been firmly fixed to the floor."))
		return
	set_dir(turn(dir, 270))

/obj/machinery/suspension_gen/update_icon()
	cut_overlays()
	if(panel_open)
		add_overlay("suspension_panel")
	else
		cut_overlay("suspension_panel")
	. = ..()

/obj/effect/suspension_field
	name = "energy field"
	icon = 'icons/effects/effects.dmi'
	anchored = 1
	density = 1

/obj/effect/suspension_field/Destroy()
	for(var/atom/movable/I in src)
		I.dropInto(loc)
	return ..()
