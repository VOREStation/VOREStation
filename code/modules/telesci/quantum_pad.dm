/obj/machinery/power/quantumpad
	name = "quantum pad"
	desc = "A bluespace quantum-linked telepad used for teleporting objects to other quantum pads."
	icon = 'icons/obj/telescience.dmi'
	icon_state = "qpad"
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 200
	active_power_usage = 5000
	circuit = /obj/item/circuitboard/quantumpad
	var/teleport_cooldown = 400 //30 seconds base due to base parts
	var/teleport_speed = 50
	var/last_teleport //to handle the cooldown
	var/teleporting = 0 //if it's in the process of teleporting
	var/power_efficiency = 1
	var/boosted = 0 // do we teleport mecha?
	var/obj/machinery/power/quantumpad/linked_pad

	//mapping
	var/static/list/mapped_quantum_pads = list()
	var/map_pad_id = "" as text //what's my name
	var/map_pad_link_id = "" as text //who's my friend

/obj/machinery/power/quantumpad/Initialize()
	. = ..()
	default_apply_parts()
	connect_to_network()
	if(map_pad_id)
		mapped_quantum_pads[map_pad_id] = src
	update_icon()

/obj/machinery/power/quantumpad/Destroy()
	mapped_quantum_pads -= map_pad_id
	return ..()

/obj/machinery/power/quantumpad/examine(mob/user)
	. = ..()
	. += "<span class='notice'>It is [linked_pad ? "currently" : "not"] linked to another pad.</span>"
	if(world.time < last_teleport + teleport_cooldown)
		. += "<span class='warning'>[src] is recharging power. A timer on the side reads <b>[round((last_teleport + teleport_cooldown - world.time)/10)]</b> seconds.</span>"
	if(boosted)
		. += SPAN_NOTICE("There appears to be a booster haphazardly jammed into the side of [src]. That looks unsafe.")
	if(!panel_open)
		. += "<span class='notice'>The panel is <i>screwed</i> in, obstructing the linking device.</span>"
	else
		. += "<span class='notice'>The <i>linking</i> device is now able to be <i>scanned</i> with a multitool.</span>"

/obj/machinery/power/quantumpad/RefreshParts()
	var/E = 0
	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		E += M.rating
	power_efficiency = E

	E = 0
	for(var/obj/item/stock_parts/capacitor/C in component_parts)
		E += C.rating

	teleport_speed = initial(teleport_speed)
	teleport_speed = max(15, (teleport_speed - (E * 10)))
	teleport_cooldown = initial(teleport_cooldown)
	teleport_cooldown = max(50, (teleport_cooldown - (E * 100)))

/obj/machinery/power/quantumpad/attackby(obj/item/I, mob/user, params)
	if(default_deconstruction_screwdriver(user, I))
		return

	if(istype(I, /obj/item/multitool))
		//VOREStation Addition Start
		if(istype(get_area(src), /area/shuttle))
			to_chat(user, "<span class='warning'>This is too unstable a platform for \the [src] to operate on!</span>")
			return
		//VOREStation Addition End
		if(panel_open)
			var/obj/item/multitool/M = I
			M.connectable = src
			to_chat(user, "<span class='notice'>You save the data in [I]'s buffer.</span>")
			return 1
		else
			var/obj/item/multitool/M = I
			if(istype(M.connectable, /obj/machinery/power/quantumpad))
				linked_pad = M.connectable
				to_chat(user, "<span class='notice'>You link [src] to the one in [I]'s buffer.</span>")
				update_icon()
				return 1

	if(istype(I, /obj/item/quantum_pad_booster))
		var/obj/item/quantum_pad_booster/booster = I
		visible_message("[user] violently jams [booster] into the side of [src]. [src] beeps, quietly.", \
		"You hear the sound of a device being improperly installed in sensitive machinery, then subsequent beeping.", runemessage = "beep!")
		playsound(src, 'sound/items/rped.ogg', 25, 1)
		boosted = TRUE
		qdel(I)

	if(default_part_replacement(user, I))
		return

	if(default_deconstruction_crowbar(user, I))
		return

	return ..()

/obj/machinery/power/quantumpad/update_icon()
	. = ..()

	cut_overlays()
	if(panel_open)
		add_overlay("qpad-panel")

	if(inoperable() || panel_open || !powernet)
		icon_state = "[initial(icon_state)]-o"
	else if (!linked_pad)
		icon_state = "[initial(icon_state)]-b"
	else
		icon_state = initial(icon_state)

// Panel flips retry power cable connections so you don't have to decon the whole thing
/obj/machinery/power/quantumpad/default_deconstruction_screwdriver(var/mob/user, var/obj/item/S)
	if((. = ..()))
		var/original_powernet = powernet
		if(powernet)
			disconnect_from_network()
		connect_to_network()
		if(powernet != original_powernet)
			update_icon()

/obj/machinery/power/quantumpad/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(panel_open)
		to_chat(user, "<span class='warning'>The panel must be closed before operating this machine!</span>")
		return

	if(istype(get_area(src), /area/shuttle))
		to_chat(user, "<span class='warning'>This is too unstable a platform for \the [src] to operate on!</span>")
		//VOREStation Addition Start
		if(linked_pad)
			linked_pad.linked_pad = null
		//VOREStation Addition End
		return

	if(!powernet)
		to_chat(user, "<span class='warning'>[src] is not attached to a powernet!</span>")
		return

	if(!linked_pad || QDELETED(linked_pad))
		if(!map_pad_link_id || !initMappedLink())
			to_chat(user, "<span class='warning'>There is no linked pad!</span>")
			return

	if(world.time < last_teleport + teleport_cooldown)
		to_chat(user, "<span class='warning'>[src] is recharging power. Please wait [round((last_teleport + teleport_cooldown - world.time)/10)] seconds.</span>")
		return

	if(teleporting)
		to_chat(user, "<span class='warning'>[src] is charging up. Please wait.</span>")
		return

	if(linked_pad.teleporting)
		to_chat(user, "<span class='warning'>Linked pad is busy. Please wait.</span>")
		return

	if(linked_pad.inoperable())
		to_chat(user, "<span class='warning'>Linked pad is not responding to ping.</span>")
		return
	src.add_fingerprint(user)
	doteleport(user)

/obj/machinery/power/quantumpad/proc/sparks()
	var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
	sparks.set_up(5, 1, get_turf(src))
	sparks.start()

/obj/machinery/power/quantumpad/attack_ghost(mob/observer/dead/ghost)
	. = ..()
	if(.)
		return
	if(!linked_pad && map_pad_link_id)
		initMappedLink()
	if(linked_pad && !QDELETED(linked_pad))
		ghost.forceMove(get_turf(linked_pad))

/obj/machinery/power/quantumpad/proc/doteleport(mob/user)
	update_icon()
	if(!linked_pad)
		return
	//VOREStation Addition Start
	if(istype(get_area(src), /area/shuttle))
		to_chat(user, "<span class='warning'>This is too unstable a platform for \the [src] to operate on!</span>")
		return
	//VOREStation Addition End
	playsound(src, 'sound/weapons/flash.ogg', 25, 1)
	teleporting = 1

	spawn(teleport_speed)
		// We gone
		if(!src || QDELETED(src))
			teleporting = 0
			return
		// Broken or whatever
		if(inoperable())
			to_chat(user, "<span class='warning'>[src] is nonfunctional!</span>")
			teleporting = 0
			return
		// Linked pad or not, we can always re-scatter people
		if(!can_traverse_gateway())
			teleporting = 0
			last_teleport = world.time
			gateway_scatter(user)
			return
		// Nothing to teleport to
		if(!linked_pad || QDELETED(linked_pad) || linked_pad.inoperable())
			to_chat(user, "<span class='warning'>Linked pad is not responding to ping. Teleport aborted.</span>")
			teleporting = 0
			return
		// Insufficient power
		if(!use_teleport_power())
			to_chat(user, "<span class='warning'>Power is not sufficient to complete a teleport. Teleport aborted.</span>")
			teleporting = 0
			return

		teleporting = 0
		last_teleport = world.time

		sparks()
		linked_pad.sparks()

		flick("qpad-beam-out", src)
		playsound(src, 'sound/weapons/emitter2.ogg', 25, 1, extrarange = 3, falloff = 5)
		flick("qpad-beam-in", linked_pad)
		playsound(linked_pad, 'sound/weapons/emitter2.ogg', 25, 1, extrarange = 3, falloff = 5)

		transport_objects(get_turf(linked_pad))

/obj/machinery/power/quantumpad/proc/initMappedLink()
	. = FALSE
	var/obj/machinery/power/quantumpad/link = mapped_quantum_pads[map_pad_link_id]
	if(link)
		linked_pad = link
		update_icon()
		. = TRUE

/obj/machinery/power/quantumpad/proc/use_teleport_power()
	var/area/A = get_area(src)
	// Well, I guess you can do it!
	if(!A?.requires_power)
		return TRUE

	// Otherwise we'll need a powernet
	var/power_to_use = 10000 / power_efficiency
	if(boosted)
		power_to_use *= 5
	if(draw_power(power_to_use) != power_to_use)
		return FALSE
	return TRUE

/obj/machinery/power/quantumpad/proc/transport_objects(turf/destination)
	for(var/atom/movable/ROI in get_turf(src))
		// if is anchored, don't let through
		if(ROI.anchored && !ismecha(ROI))
			if(ismecha(ROI))
				if(boosted)
					continue
			if(isliving(ROI))
				var/mob/living/L = ROI
				if(L.buckled)
					// TP people on office chairs
					if(L.buckled.anchored)
						continue
				else
					continue
			else if(!isobserver(ROI) && !isEye(ROI))
				continue
		do_teleport(ROI, destination, local = FALSE)

/obj/machinery/power/quantumpad/proc/can_traverse_gateway()
	// Well, if there's no gateway map we're definitely not on it
	if(!GLOB.gateway_away)
		return TRUE

	// Traverse!
	if(GLOB.gateway_away.calibrated)
		return TRUE

	var/list/gateway_zs = GetConnectedZlevels(GLOB.gateway_away.z)
	if(z in gateway_zs)
		return FALSE // It's not calibrated and we're in a connected z

	return TRUE

/obj/machinery/power/quantumpad/proc/gateway_scatter(mob/user)
	var/obj/effect/landmark/dest = pick(awaydestinations)
	if(!dest)
		to_chat(user, "<span class='warning'>Nothing happens... maybe there's no signal to the remote pad?</span>")
		return
	// Insufficient power
	if(!use_teleport_power())
		to_chat(user, "<span class='warning'>Power is not sufficient to complete a teleport. Teleport aborted.</span>")
		return

	sparks()
	to_chat(user, "<span class='warning'>You feel yourself pulled in different directions, before ending up not far from where you started.</span>")
	flick("qpad-beam-out", src)
	transport_objects(get_turf(dest))

/obj/item/quantum_pad_booster
	icon = 'icons/obj/device_vr.dmi'
	name = "quantum pad particle booster"
	desc = "A deceptively simple interface for increasing the mass of objects a quantum pad is capable of teleporting, at the cost of increased power draw."
	description_info = "The three prongs at the base of the tool are not, in fact, for show."
	force = 9
	sharp = TRUE
	item_state = "analyzer"
	icon_state = "hacktool"
