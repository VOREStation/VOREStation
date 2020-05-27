/obj/machinery/pipedispenser
	name = "Pipe Dispenser"
	desc = "A large machine that can rapidly dispense pipes."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "pipe_d"
	density = 1
	anchored = 1
	var/unwrenched = 0
	var/wait = 0
	var/p_layer = PIPING_LAYER_REGULAR
	var/static/list/pipe_layers = list(
		"Regular" = PIPING_LAYER_REGULAR,
		"Supply" = PIPING_LAYER_SUPPLY,
		"Scrubber" = PIPING_LAYER_SCRUBBER,
		"Fuel" = PIPING_LAYER_FUEL,
		"Aux" = PIPING_LAYER_AUX
	)

// TODO - Its about time to make this NanoUI don't we think?
/obj/machinery/pipedispenser/attack_hand(var/mob/user as mob)
	if((. = ..()))
		return
	src.interact(user)

/obj/machinery/pipedispenser/interact(mob/user)
	user.set_machine(src)

	var/list/lines = list()
	for(var/category in atmos_pipe_recipes)
		lines += "<b>[category]:</b><BR>"
		if(category == "Pipes")
			for(var/pipename in pipe_layers)
				var/pipelayer = pipe_layers[pipename]
				lines += "<a class='[p_layer == pipelayer ? "linkOn" : "linkOff"]' href='?src=\ref[src];setlayer=[pipelayer]'>[pipename]</a> "
				lines += "<br>"
		for(var/datum/pipe_recipe/PI in atmos_pipe_recipes[category])
			lines += PI.Render(src)
	var/dat = lines.Join()
	var/datum/browser/popup = new(user, "pipedispenser", name, 300, 800, src)
	popup.set_content("<TT>[dat]</TT>")
	popup.open()
	return

/obj/machinery/pipedispenser/Topic(href, href_list)
	if(..())
		return
	if(unwrenched || !usr.canmove || usr.stat || usr.restrained() || !in_range(loc, usr))
		usr << browse(null, "window=pipedispenser")
		usr.unset_machine(src)
		return
	usr.set_machine(src)
	src.add_fingerprint(usr)
	if(href_list["setlayer"])
		var/new_pipe_layer = text2num(href_list["setlayer"])
		if(isnum(new_pipe_layer))
			p_layer = new_pipe_layer
			updateDialog()
	else if(href_list["makepipe"])
		if(!wait)
			var/obj/machinery/atmospherics/p_type = text2path(href_list["makepipe"])
			var/p_dir = text2num(href_list["dir"])
			var/pi_type = initial(p_type.construction_type)
			var/obj/item/pipe/P = new pi_type(src.loc, p_type, p_dir)
			P.setPipingLayer(p_layer)
			P.add_fingerprint(usr)
			wait = 1
			spawn(10)
				wait = 0
	else if(href_list["makemeter"])
		if(!wait)
			new /obj/item/pipe_meter(/*usr.loc*/ src.loc)
			wait = 1
			spawn(15)
				wait = 0
	return

/obj/machinery/pipedispenser/attackby(var/obj/item/W as obj, var/mob/user as mob)
	src.add_fingerprint(usr)
	if (istype(W, /obj/item/pipe) || istype(W, /obj/item/pipe_meter))
		to_chat(usr, "<span class='notice'>You put [W] back to [src].</span>")
		user.drop_item()
		qdel(W)
		return
	else if(W.is_wrench())
		if (unwrenched==0)
			playsound(src, W.usesound, 50, 1)
			to_chat(user, "<span class='notice'>You begin to unfasten \the [src] from the floor...</span>")
			if (do_after(user, 40 * W.toolspeed))
				user.visible_message( \
					"<span class='notice'>[user] unfastens \the [src].</span>", \
					"<span class='notice'>You have unfastened \the [src]. Now it can be pulled somewhere else.</span>", \
					"You hear ratchet.")
				src.anchored = 0
				src.stat |= MAINT
				src.unwrenched = 1
				if (usr.machine==src)
					usr << browse(null, "window=pipedispenser")
		else /*if (unwrenched==1)*/
			playsound(src, W.usesound, 50, 1)
			to_chat(user, "<span class='notice'>You begin to fasten \the [src] to the floor...</span>")
			if (do_after(user, 20 * W.toolspeed))
				user.visible_message( \
					"<span class='notice'>[user] fastens \the [src].</span>", \
					"<span class='notice'>You have fastened \the [src]. Now it can dispense pipes.</span>", \
					"You hear ratchet.")
				src.anchored = 1
				src.stat &= ~MAINT
				src.unwrenched = 0
				power_change()
	else
		return ..()

/obj/machinery/pipedispenser/disposal
	name = "Disposal Pipe Dispenser"
	desc = "A large machine that can rapidly dispense pipes. This one seems to dispsense disposal pipes."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "pipe_d"
	density = 1
	anchored = 1.0

/*
//Allow you to push disposal pipes into it (for those with density 1)
/obj/machinery/pipedispenser/disposal/Crossed(var/obj/structure/disposalconstruct/pipe as obj)
	if(istype(pipe) && !pipe.anchored)
		qdel(pipe)

Nah
*/

//Allow you to drag-drop disposal pipes into it
/obj/machinery/pipedispenser/disposal/MouseDrop_T(var/obj/structure/disposalconstruct/pipe as obj, mob/usr as mob)
	if(!usr.canmove || usr.stat || usr.restrained())
		return

	if (!istype(pipe) || get_dist(usr, src) > 1 || get_dist(src,pipe) > 1 )
		return

	if (pipe.anchored)
		return

	qdel(pipe)

/obj/machinery/pipedispenser/disposal/interact(mob/user)
	user.set_machine(src)

	var/list/lines = list()
	for(var/category in disposal_pipe_recipes)
		lines += "<b>[category]:</b><BR>"
		for(var/datum/pipe_recipe/PI in disposal_pipe_recipes[category])
			lines += PI.Render(src)
	var/dat = lines.Join()
	var/datum/browser/popup = new(user, "pipedispenser", name, 300, 500, src)
	popup.set_content("<TT>[dat]</TT>")
	popup.open()
	return

/obj/machinery/pipedispenser/disposal/Topic(href, href_list)
	if(href_list["makepipe"] || href_list["setlayer"] || href_list["makemeter"])	// Asking the disposal machine to do atmos stuff?
		return 																		// That's a no no.
	if((. = ..()))
		return
	if(href_list["dmake"])
		if(unwrenched || !usr.canmove || usr.stat || usr.restrained() || !in_range(loc, usr))
			usr << browse(null, "window=pipedispenser")
			return
		if(!wait)
			var/ptype = text2num(href_list["dmake"])
			var/pdir = (href_list["dir"] ? text2num(href_list["dir"]) : NORTH)
			var/psub = (href_list["sort"] ? text2num(href_list["sort"]) : 0)
			var/obj/structure/disposalconstruct/C = new (src.loc, ptype, pdir, 0, psub)

			C.add_fingerprint(usr)
			C.update()
			wait = 1
			VARSET_IN(src, wait, FALSE, 15)
	return

// adding a pipe dispensers that spawn unhooked from the ground
/obj/machinery/pipedispenser/orderable
	anchored = 0
	unwrenched = 1

/obj/machinery/pipedispenser/disposal/orderable
	anchored = 0
	unwrenched = 1
