//a trunk joining to a disposal bin or outlet on the same turf
/obj/structure/disposalpipe/trunk
	icon_state = "pipe-t"

/obj/structure/disposalpipe/trunk/Initialize(mapload)
	..()
	dpdir = dir
	return INITIALIZE_HINT_LATELOAD

/obj/structure/disposalpipe/trunk/LateInitialize()
	update()

// Override attackby so we disallow trunkremoval when somethings ontop
/obj/structure/disposalpipe/trunk/attackby(obj/item/I, mob/user)
	//Disposal constructors
	var/turf/T = get_turf(src)
	var/obj/structure/disposalconstruct/C = locate() in T
	if(C && C.anchored)
		return

	if(!T.is_plating())
		return		// prevent interaction with T-scanner revealed pipes
	add_fingerprint(user)
	if(I.has_tool_quality(TOOL_WELDER))
		var/obj/item/weldingtool/W = I.get_welder()

		if(W.remove_fuel(0,user))
			playsound(src, W.usesound, 100, 1)
			to_chat(user, "Slicing the disposal pipe.")
			if(do_after(user, 3 SECONDS * W.toolspeed, target = src))
				if(!src || !W.isOn()) return
				welded()
			else
				to_chat(user, "You must stay still while welding the pipe.")
		else
			to_chat(user, "You need more welding fuel to cut the pipe.")

// would transfer to next pipe segment, but we are in a trunk
// if not entering from disposal bin,
// transfer to linked object (outlet or bin)
/obj/structure/disposalpipe/trunk/transfer(obj/structure/disposalholder/H)
	if(H.dir == DOWN)		// we just entered from a disposer
		return ..()		// so do base transfer proc

	// Find a disposal handler component. First come first serve.
	var/transfered = FALSE
	var/turf/T = get_turf(src)
	for(var/obj/O in T)
		if(SEND_SIGNAL(O,COMSIG_DISPOSAL_RECEIVING,H))
			transfered = TRUE
			break
	if(!transfered) // Check if anything handled it, will be deleted if so.
		expel(H, T, 0) // expel at turf if nothing handled it

	return null

// nextdir
/obj/structure/disposalpipe/trunk/nextdir(fromdir)
	if(fromdir == DOWN)
		return dir
	else
		return 0
