/obj/machinery/suspension_gen
	name = "suspension field generator"
	desc = "It has stubby legs bolted up against it's body for stabilising."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "suspension2"
	density = 1
	req_access = list(access_research)
	var/obj/item/weapon/cell/cell
	var/locked = TRUE
	var/power_use = 5
	var/obj/effect/suspension_field/suspension_field

/obj/machinery/suspension_gen/Initialize()
	. = ..()
	cell = new /obj/item/weapon/cell/high(src)

/obj/machinery/suspension_gen/process()
	if(suspension_field)
		if(cell.use(power_use))
			var/turf/T = get_turf(suspension_field)
			for(var/mob/living/M in T)
				if(cell.use(power_use))
					M.Weaken(3)
					if(prob(5))
						to_chat(M, "<span class='warning'>[pick("You feel tingly","You feel like floating","It is hard to speak","You can barely move")].</span>")
				else
					deactivate()

			for(var/obj/item/I in T)
				if(!suspension_field.contents.len)
					suspension_field.icon_state = "energynet"
					suspension_field.overlays += "shield2"
				I.forceMove(suspension_field)
		else
			deactivate()

/obj/machinery/suspension_gen/attack_hand(var/mob/user)
	if(panel_open)
		if(cell)
			to_chat(user, "<span class='notice'>You remove [cell].</span>")
			cell.forceMove(loc)
			cell.add_fingerprint(user)
			cell.update_icon()

			icon_state = "suspension0"
			cell = null
		return

	tgui_interact(user)

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
						to_chat(usr, "<span class='warning'>You are unable to activate [src] until it is properly secured on the ground.</span>")
			else
				deactivate()
			return TRUE

		if("lock")
			if(allowed(usr))
				locked = !locked
				return TRUE

/obj/machinery/suspension_gen/attackby(obj/item/W, mob/user)
	if(!locked && !suspension_field && default_deconstruction_screwdriver(user, W))
		return
	else if(W.is_wrench())
		if(!suspension_field)
			if(anchored)
				anchored = 0
			else
				anchored = 1
			playsound(src, W.usesound, 50, 1)
			to_chat(user, "<span class='notice'>You wrench the stabilising legs [anchored ? "into place" : "up against the body"].</span>")
			if(anchored)
				desc = "It is resting securely on four stubby legs."
			else
				desc = "It has stubby legs bolted up against it's body for stabilising."
		else
			to_chat(user, "<span class='warning'>You are unable to unsecure [src] while it is active!</span>")
	else if(istype(W, /obj/item/weapon/cell))
		if(panel_open)
			if(cell)
				to_chat(user, "<span class='warning'>There is a power cell already installed.</span>")
				return
			if(user.unEquip(W))
				W.forceMove(src)
				cell = W
				to_chat(user, "<span class='notice'>You insert [cell].</span>")
				icon_state = "suspension1"
	else if(istype(W, /obj/item/weapon/card/emag))
		return W.resolve_attackby(src, user)
	else
		if(check_access(W))
			locked = !locked
			to_chat(user, "<span class='notice'>You [locked ? "lock" : "unlock"] [src].</span>")
		else
			to_chat(user, "<span class='warning'>[src] flashes \'<i>Access denied.</i>\'</span>")
		return

/obj/machinery/suspension_gen/emag_act(var/remaining_charges, var/mob/user)
	if(locked)
		locked = FALSE
		return 1

//checks for whether the machine can be activated or not should already have occurred by this point
/obj/machinery/suspension_gen/proc/activate()
	var/turf/T = get_turf(get_step(src,dir))
	var/collected = 0

	for(var/mob/living/M in T)
		M.Weaken(5)
		M.visible_message("<span class='notice'>[bicon(M)] [M] begins to float in the air!</span>","You feel tingly and light, but it is difficult to move.")

	suspension_field = new(T)
	visible_message("<span class='notice'>[bicon(src)] [src] activates with a low hum.</span>")
	icon_state = "suspension3"

	for(var/obj/item/I in T)
		I.loc = suspension_field
		collected++

	if(collected)
		suspension_field.icon_state = "energynet"
		suspension_field.overlays += "shield2"
		visible_message("<span class='notice'>[bicon(suspension_field)] [suspension_field] gently absconds [collected > 1 ? "something" : "several things"].</span>")
	else
		if(istype(T,/turf/simulated/mineral) || istype(T,/turf/simulated/wall))
			suspension_field.icon_state = "shieldsparkles"
		else
			suspension_field.icon_state = "shield2"

/obj/machinery/suspension_gen/proc/deactivate()
	//drop anything we picked up
	var/turf/T = get_turf(suspension_field)

	for(var/mob/living/M in T)
		to_chat(M, "<span class='notice'>You no longer feel like floating.</span>")
		M.Weaken(3)

	visible_message("<span class='notice'>[bicon(src)] [src] deactivates with a gentle shudder.</span>")
	qdel(suspension_field)
	suspension_field = null
	icon_state = "suspension2"

/obj/machinery/suspension_gen/Destroy()
	deactivate()
	..()

/obj/machinery/suspension_gen/verb/rotate_counterclockwise()
	set src in view(1)
	set name = "Rotate suspension gen Counterclockwise"
	set category = "Object"

	if(anchored)
		to_chat(usr, "<span class='warning'>You cannot rotate [src], it has been firmly fixed to the floor.</span>")
		return
	set_dir(turn(dir, 90))

/obj/machinery/suspension_gen/verb/rotate_clockwise()
	set src in view(1)
	set name = "Rotate suspension gen Clockwise"
	set category = "Object"

	if(anchored)
		to_chat(usr, "<span class='warning'>You cannot rotate [src], it has been firmly fixed to the floor.</span>")
		return
	set_dir(turn(dir, 270))

/obj/effect/suspension_field
	name = "energy field"
	icon = 'icons/effects/effects.dmi'
	anchored = 1
	density = 1

/obj/effect/suspension_field/Destroy()
	for(var/atom/movable/I in src)
		I.dropInto(loc)
	return ..()
