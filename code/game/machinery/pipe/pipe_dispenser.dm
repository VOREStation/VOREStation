/obj/machinery/pipedispenser
	name = "Pipe Dispenser"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "pipe_d"
	density = 1
	anchored = 1
	var/unwrenched = 0
	var/wait = 0
	var/p_layer = PIPING_LAYER_REGULAR

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
			// Stupid hack. Fix someday. So tired right now.
			lines += "<a class='[p_layer == PIPING_LAYER_REGULAR ? "linkOn" : "linkOff"]' href='?src=\ref[src];setlayer=[PIPING_LAYER_REGULAR]'>Regular</a> "
			lines += "<a class='[p_layer == PIPING_LAYER_SUPPLY ? "linkOn" : "linkOff"]' href='?src=\ref[src];setlayer=[PIPING_LAYER_SUPPLY]'>Supply</a> "
			lines += "<a class='[p_layer == PIPING_LAYER_SCRUBBER ? "linkOn" : "linkOff"]' href='?src=\ref[src];setlayer=[PIPING_LAYER_SCRUBBER]'>Scrubber</a> "
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
		usr << "<span class='notice'>You put [W] back to [src].</span>"
		user.drop_item()
		qdel(W)
		return
	else if(W.is_wrench())
		if (unwrenched==0)
			playsound(src, W.usesound, 50, 1)
			user << "<span class='notice'>You begin to unfasten \the [src] from the floor...</span>"
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
			user << "<span class='notice'>You begin to fasten \the [src] to the floor...</span>"
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

/obj/machinery/pipedispenser/disposal/attack_hand(user as mob)
	if(..())
		return

///// Z-Level stuff
	var/dat = {"<b>Disposal Pipes</b><br><br>
<A href='?src=\ref[src];dmake=0'>Pipe</A><BR>
<A href='?src=\ref[src];dmake=1'>Bent Pipe</A><BR>
<A href='?src=\ref[src];dmake=2'>Junction</A><BR>
<A href='?src=\ref[src];dmake=3'>Y-Junction</A><BR>
<A href='?src=\ref[src];dmake=4'>Trunk</A><BR>
<A href='?src=\ref[src];dmake=5'>Bin</A><BR>
<A href='?src=\ref[src];dmake=6'>Outlet</A><BR>
<A href='?src=\ref[src];dmake=7'>Chute</A><BR>
<A href='?src=\ref[src];dmake=21'>Upwards</A><BR>
<A href='?src=\ref[src];dmake=22'>Downwards</A><BR>
<A href='?src=\ref[src];dmake=8'>Sorting</A><BR>
<A href='?src=\ref[src];dmake=9'>Sorting (Wildcard)</A><BR>
<A href='?src=\ref[src];dmake=10'>Sorting (Untagged)</A><BR>
<A href='?src=\ref[src];dmake=11'>Tagger</A><BR>
<A href='?src=\ref[src];dmake=12'>Tagger (Partial)</A><BR>
"}
///// Z-Level stuff

	user << browse("<HEAD><TITLE>[src]</TITLE></HEAD><TT>[dat]</TT>", "window=pipedispenser")
	return

// 0=straight, 1=bent, 2=junction-j1, 3=junction-j2, 4=junction-y, 5=trunk


/obj/machinery/pipedispenser/disposal/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	src.add_fingerprint(usr)
	if(href_list["dmake"])
		if(unwrenched || !usr.canmove || usr.stat || usr.restrained() || !in_range(loc, usr))
			usr << browse(null, "window=pipedispenser")
			return
		if(!wait)
			var/p_type = text2num(href_list["dmake"])
			var/obj/structure/disposalconstruct/C = new (src.loc)
			switch(p_type)
				if(0)
					C.ptype = 0
				if(1)
					C.ptype = 1
				if(2)
					C.ptype = 2
				if(3)
					C.ptype = 4
				if(4)
					C.ptype = 5
				if(5)
					C.ptype = 6
					C.density = 1
				if(6)
					C.ptype = 7
					C.density = 1
				if(7)
					C.ptype = 8
					C.density = 1
				if(8)
					C.ptype = 9
					C.subtype = 0
				if(9)
					C.ptype = 9
					C.subtype = 1
				if(10)
					C.ptype = 9
					C.subtype = 2
				if(11)
					C.ptype = 13
				if(12)
					C.ptype = 14
///// Z-Level stuff
				if(21)
					C.ptype = 11
				if(22)
					C.ptype = 12
///// Z-Level stuff
			C.add_fingerprint(usr)
			C.update()
			wait = 1
			spawn(15)
				wait = 0
	return

// adding a pipe dispensers that spawn unhooked from the ground
/obj/machinery/pipedispenser/orderable
	anchored = 0
	unwrenched = 1

/obj/machinery/pipedispenser/disposal/orderable
	anchored = 0
	unwrenched = 1
