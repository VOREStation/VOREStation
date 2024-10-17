/obj/machinery/camera
	name = "security camera"
	desc = "It's used to monitor rooms."
	icon = 'icons/obj/monitors_vr.dmi' //VOREStation Edit - New Icons
	icon_state = "camera"
	use_power = USE_POWER_ACTIVE
	idle_power_usage = 5
	active_power_usage = 10
	plane = MOB_PLANE
	layer = ABOVE_MOB_LAYER

	var/list/network = list(NETWORK_DEFAULT)
	var/c_tag = null
	var/c_tag_order = 999
	var/status = 1
	anchored = TRUE
	var/invuln = 0
	var/bugged = 0
	var/obj/item/camera_assembly/assembly = null

	var/toughness = 5 //sorta fragile

	// WIRES
	var/datum/wires/camera/wires = null // Wires datum

	//OTHER

	var/view_range = 7
	var/short_range = 2

	var/light_disabled = 0
	var/in_use_lights = 0 // TO BE IMPLEMENTED - LIES.
	var/alarm_on = 0
	var/busy = 0

	var/on_open_network = 0
	var/always_visible = FALSE //Visable from any map, good for entertainment network cameras

	var/affected_by_emp_until = 0

	var/client_huds = list()

	var/list/camera_computers_using_this = list()

/obj/machinery/camera/New()
	wires = new(src)
	assembly = new(src)
	assembly.state = 4
	client_huds |= global_hud.whitense

	/* // Use this to look for cameras that have the same c_tag.
	for(var/obj/machinery/camera/C in cameranet.cameras)
		var/list/tempnetwork = C.network&src.network
		if(C != src && C.c_tag == src.c_tag && tempnetwork.len)
			to_world_log("[src.c_tag] [src.x] [src.y] [src.z] conflicts with [C.c_tag] [C.x] [C.y] [C.z]")
	*/
	if(!src.network || src.network.len < 1)
		if(loc)
			error("[src.name] in [get_area(src)] (x:[src.x] y:[src.y] z:[src.z] has errored. [src.network?"Empty network list":"Null network list"]")
		else
			error("[src.name] in [get_area(src)]has errored. [src.network?"Empty network list":"Null network list"]")
		ASSERT(src.network)
		ASSERT(src.network.len > 0)
	// VOREStation Edit Start - Make mapping with cameras easier
	if(!c_tag)
		var/area/A = get_area(src)
		c_tag = "[A ? A.name : "Unknown"] #[rand(111,999)]"
	..()
	// VOREStation Edit End

/obj/machinery/camera/Destroy()
	if(isMotion())
		unsense_proximity(callback = /atom/proc/HasProximity)
	deactivate(null, 0) //kick anyone viewing out
	if(assembly)
		qdel(assembly)
		assembly = null
	qdel(wires)
	wires = null
	return ..()

/obj/machinery/camera/process()
	if((stat & EMPED) && world.time >= affected_by_emp_until)
		stat &= ~EMPED
		cancelCameraAlarm()
		update_icon()
		update_coverage()
	return internal_process()

/obj/machinery/camera/proc/internal_process()
	return

/obj/machinery/camera/emp_act(severity)
	if(!isEmpProof() && prob(100/severity))
		if(!affected_by_emp_until || (world.time > affected_by_emp_until))
			affected_by_emp_until = max(affected_by_emp_until, world.time + (90 SECONDS / severity))
			stat |= EMPED
			set_light(0)
			triggerCameraAlarm()
			update_icon()
			update_coverage()
			START_PROCESSING(SSobj, src)

/obj/machinery/camera/bullet_act(var/obj/item/projectile/P)
	take_damage(P.get_structure_damage())

/obj/machinery/camera/ex_act(severity)
	if(src.invuln)
		return

	//camera dies if an explosion touches it!
	if(severity <= 2 || prob(50))
		destroy()

	..() //and give it the regular chance of being deleted outright

/obj/machinery/camera/blob_act()
	if((stat & BROKEN) || invuln)
		return
	destroy()

/obj/machinery/camera/hitby(AM as mob|obj)
	..()
	if (istype(AM, /obj))
		var/obj/O = AM
		if (O.throwforce >= src.toughness)
			visible_message(span_boldwarning("[src] was hit by [O]."))
		take_damage(O.throwforce)

/obj/machinery/camera/proc/setViewRange(var/num = 7)
	src.view_range = num
	cameranet.updateVisibility(src, 0)

/obj/machinery/camera/attack_hand(mob/living/carbon/human/user as mob)
	if(!istype(user))
		return

	if(user.species.can_shred(user))
		set_status(0)
		user.do_attack_animation(src)
		user.setClickCooldown(user.get_attack_speed())
		visible_message(span_warning("\The [user] slashes at [src]!"))
		playsound(src, 'sound/weapons/slash.ogg', 100, 1)
		add_hiddenprint(user)
		destroy()

/obj/machinery/camera/attack_generic(mob/user as mob)
	if(isanimal(user))
		var/mob/living/simple_mob/S = user
		set_status(0)
		S.do_attack_animation(src)
		S.setClickCooldown(user.get_attack_speed())
		visible_message(span_warning("\The [user] [pick(S.attacktext)] \the [src]!"))
		playsound(src, S.attack_sound, 100, 1)
		add_hiddenprint(user)
		destroy()
	..()

/obj/machinery/camera/attackby(obj/item/W as obj, mob/living/user as mob)
	update_coverage()
	// DECONSTRUCTION
	if(W.has_tool_quality(TOOL_SCREWDRIVER))
		//to_chat(user, span_notice("You start to [panel_open ? "close" : "open"] the camera's panel."))
		//if(toggle_panel(user)) // No delay because no one likes screwdrivers trying to be hip and have a duration cooldown
		panel_open = !panel_open
		user.visible_message(span_warning("[user] screws the camera's panel [panel_open ? "open" : "closed"]!"),
		span_notice("You screw the camera's panel [panel_open ? "open" : "closed"]."))
		playsound(src, W.usesound, 50, 1)

	else if((W.has_tool_quality(TOOL_WIRECUTTER) || istype(W, /obj/item/multitool)) && panel_open)
		interact(user)

	else if(W.has_tool_quality(TOOL_WELDER) && (wires.CanDeconstruct() || (stat & BROKEN)))
		if(weld(W, user))
			if(assembly)
				assembly.loc = src.loc
				assembly.anchored = TRUE
				assembly.camera_name = c_tag
				assembly.camera_network = english_list(network, NETWORK_DEFAULT, ",", ",")
				assembly.update_icon()
				assembly.dir = src.dir
				if(stat & BROKEN)
					assembly.state = 2
					to_chat(user, span_notice("You repaired \the [src] frame."))
				else
					assembly.state = 1
					to_chat(user, span_notice("You cut \the [src] free from the wall."))
					new /obj/item/stack/cable_coil(src.loc, length=2)
				assembly = null //so qdel doesn't eat it.
			qdel(src)

	// OTHER
	else if (can_use() && (istype(W, /obj/item/paper) || istype(W, /obj/item/pda)) && isliving(user))
		var/mob/living/U = user
		var/obj/item/paper/X = null
		var/obj/item/pda/P = null

		var/itemname = ""
		var/info = ""
		if(istype(W, /obj/item/paper))
			X = W
			itemname = X.name
			info = X.info
		else
			P = W
			itemname = P.name
			var/datum/data/pda/app/notekeeper/N = P.find_program(/datum/data/pda/app/notekeeper)
			if(N)
				info = N.notehtml
		to_chat(U, "You hold \a [itemname] up to the camera ...")
		for(var/mob/living/silicon/ai/O in living_mob_list)
			if(!O.client)
				continue
			if(U.name == "Unknown")
				to_chat(O, span_infoplain(span_bold("[U]") + " holds \a [itemname] up to one of your cameras ..."))
			else
				to_chat(O, span_infoplain(span_bold("<a href='byond://?src=\ref[O];track2=\ref[O];track=\ref[U];trackname=[U.name]'>[U]</a>") + " holds \a [itemname] up to one of your cameras ..."))
			O << browse(text("<HTML><HEAD><TITLE>[]</TITLE></HEAD><BODY><TT>[]</TT></BODY></HTML>", itemname, info), text("window=[]", itemname))

	else if (istype(W, /obj/item/camera_bug))
		if (!src.can_use())
			to_chat(user, span_warning("Camera non-functional."))
			return
		if (src.bugged)
			to_chat(user, span_notice("Camera bug removed."))
			src.bugged = 0
		else
			to_chat(user, span_notice("Camera bugged."))
			src.bugged = 1

	else if(W.damtype == BRUTE || W.damtype == BURN) //bashing cameras
		user.setClickCooldown(user.get_attack_speed(W))
		if (W.force >= src.toughness)
			user.do_attack_animation(src)
			visible_message(span_boldwarning("[src] has been [LAZYLEN(W.attack_verb) ? pick(W.attack_verb) : "attacked"] with [W] by [user]!"))
			if (istype(W, /obj/item)) //is it even possible to get into attackby() with non-items?
				var/obj/item/I = W
				if (I.hitsound)
					playsound(src, I.hitsound, 50, 1, -1)
		take_damage(W.force)

	else
		..()

/obj/machinery/camera/proc/deactivate(user as mob, var/choice = 1)
	// The only way for AI to reactivate cameras are malf abilities, this gives them different messages.
	if(istype(user, /mob/living/silicon/ai))
		user = null

	if(choice != 1)
		return

	set_status(!src.status)
	if (!(src.status))
		if(user)
			visible_message(span_notice(" [user] has deactivated [src]!"))
		else
			visible_message(span_notice(" [src] clicks and shuts down. "))
		playsound(src, 'sound/items/Wirecutter.ogg', 100, 1)
		icon_state = "[initial(icon_state)]1"
		add_hiddenprint(user)
	else
		if(user)
			visible_message(span_notice(" [user] has reactivated [src]!"))
		else
			visible_message(span_notice(" [src] clicks and reactivates itself. "))
		playsound(src, 'sound/items/Wirecutter.ogg', 100, 1)
		icon_state = initial(icon_state)
		add_hiddenprint(user)

/obj/machinery/camera/take_damage(var/force, var/message)
	//prob(25) gives an average of 3-4 hits
	if (force >= toughness && (force > toughness*4 || prob(25)))
		destroy()

//Used when someone breaks a camera
/obj/machinery/camera/proc/destroy()
	stat |= BROKEN
	wires.cut_all()

	triggerCameraAlarm()
	update_icon()
	update_coverage()

	//sparks
	var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
	spark_system.set_up(5, 0, loc)
	spark_system.start()
	playsound(src, "sparks", 50, 1)

/obj/machinery/camera/proc/set_status(var/newstatus)
	if (status != newstatus)
		status = newstatus
		update_coverage()

/obj/machinery/camera/check_eye(mob/user)
	if(!can_use()) return -1
	if(isXRay()) return SEE_TURFS|SEE_MOBS|SEE_OBJS
	return 0

/obj/machinery/camera/update_icon()
	if (!status || (stat & BROKEN))
		icon_state = "[initial(icon_state)]1"
	else if (stat & EMPED)
		icon_state = "[initial(icon_state)]emp"
	else
		icon_state = initial(icon_state)

/obj/machinery/camera/proc/triggerCameraAlarm(var/duration = 0)
	alarm_on = 1
	camera_alarm.triggerAlarm(loc, src, duration)

/obj/machinery/camera/proc/cancelCameraAlarm()
	if(wires.is_cut(WIRE_CAM_ALARM))
		return

	alarm_on = 0
	camera_alarm.clearAlarm(loc, src)

//if false, then the camera is listed as DEACTIVATED and cannot be used
/obj/machinery/camera/proc/can_use()
	if(!status)
		return 0
	if(stat & (EMPED|BROKEN))
		return 0
	return 1

/obj/machinery/camera/proc/can_see()
	var/list/see = null
	var/turf/pos = get_turf(src)
	if(!pos)
		return list()

	if(isXRay())
		see = range(view_range, pos)
	else
		see = hear(view_range, pos)
	return see

/atom/proc/auto_turn()
	//Automatically turns based on nearby walls.
	var/turf/simulated/wall/T = null
	for(var/i = 1, i <= 8; i += i)
		T = get_ranged_target_turf(src, i, 1)
		if(istype(T))
			//If someone knows a better way to do this, let me know. -Giacom
			switch(i)
				if(NORTH)
					src.set_dir(SOUTH)
				if(SOUTH)
					src.set_dir(NORTH)
				if(WEST)
					src.set_dir(EAST)
				if(EAST)
					src.set_dir(WEST)
			break

//Return a working camera that can see a given mob
//or null if none
/proc/seen_by_camera(var/mob/M)
	for(var/obj/machinery/camera/C in oview(4, M))
		if(C.can_use())	// check if camera disabled
			return C
	return null

/proc/near_range_camera(var/mob/M)

	for(var/obj/machinery/camera/C in range(4, M))
		if(C.can_use())	// check if camera disabled
			return C

	return null

/obj/machinery/camera/proc/weld(var/obj/item/weldingtool/WT, var/mob/user)
	WT = WT.get_welder()

	if(busy)
		return 0
	if(!WT.isOn())
		return 0

	// Do after stuff here
	to_chat(user, span_notice("You start to weld [src].."))
	playsound(src, WT.usesound, 50, 1)
	WT.eyecheck(user)
	busy = 1
	if(do_after(user, 100 * WT.toolspeed))
		busy = 0
		if(!WT.isOn())
			return 0
		return 1
	busy = 0
	return 0

/obj/machinery/camera/interact(mob/living/user as mob)
	if(!panel_open || istype(user, /mob/living/silicon/ai))
		return

	if(stat & BROKEN)
		to_chat(user, span_warning("\The [src] is broken."))
		return

	user.set_machine(src)
	wires.Interact(user)

/obj/machinery/camera/proc/add_network(var/network_name)
	add_networks(list(network_name))

/obj/machinery/camera/proc/remove_network(var/network_name)
	remove_networks(list(network_name))

/obj/machinery/camera/proc/add_networks(var/list/networks)
	var/network_added
	network_added = 0
	for(var/network_name in networks)
		if(!(network_name in src.network))
			network += network_name
			network_added = 1

	if(network_added)
		update_coverage(1)

/obj/machinery/camera/proc/remove_networks(var/list/networks)
	var/network_removed
	network_removed = 0
	for(var/network_name in networks)
		if(network_name in src.network)
			network -= network_name
			network_removed = 1

	if(network_removed)
		update_coverage(1)

/obj/machinery/camera/proc/replace_networks(var/list/networks)
	if(networks.len != network.len)
		network = networks
		update_coverage(1)
		return

	for(var/new_network in networks)
		if(!(new_network in network))
			network = networks
			update_coverage(1)
			return

/obj/machinery/camera/proc/clear_all_networks()
	if(network.len)
		network.Cut()
		update_coverage(1)

/obj/machinery/camera/proc/tgui_structure()
	var/cam[0]
	cam["name"] = sanitize(c_tag)
	cam["deact"] = !can_use()
	cam["camera"] = "\ref[src]"
	cam["omni"] = always_visible
	cam["x"] = x
	cam["y"] = y
	cam["z"] = z
	return cam

/obj/machinery/camera/proc/update_coverage(var/network_change = 0)
	if(network_change)
		var/list/open_networks = difflist(network, restricted_camera_networks)
		// Add or remove camera from the camera net as necessary
		if(on_open_network && !open_networks.len)
			cameranet.removeCamera(src)
		else if(!on_open_network && open_networks.len)
			on_open_network = 1
			cameranet.addCamera(src)
	else
		cameranet.updateVisibility(src, 0)

// Resets the camera's wires to fully operational state. Used by one of Malfunction abilities.
/obj/machinery/camera/proc/reset_wires()
	if(!wires)
		return
	if (stat & BROKEN) // Fix the camera
		stat &= ~BROKEN
	wires.repair()
	update_icon()
	update_coverage()
