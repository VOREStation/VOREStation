/obj/item/tvcamera
	name = "press camera drone"
	desc = "A Ward-Takahashi EyeBuddy media streaming hovercam. Weapon of choice for war correspondents and reality show cameramen."
	icon = 'icons/obj/device.dmi'
	icon_state = "camcorder"
	item_state = "camcorder"
	w_class = ITEMSIZE_LARGE
	slot_flags = SLOT_BELT
	var/channel = "NCS Northern Star News Feed"
	var/obj/machinery/camera/network/thunder/camera
	var/obj/item/radio/radio
	var/datum/weakref/showing
	var/showing_name
	pickup_sound = 'sound/items/pickup/device.ogg'
	drop_sound = 'sound/items/drop/device.ogg'

/obj/item/tvcamera/New()
	..()
	listening_objects += src

/obj/item/tvcamera/Destroy()
	listening_objects -= src
	qdel(camera)
	qdel(radio)
	camera = null
	radio = null
	..()

/obj/item/tvcamera/examine()
	. = ..()
	. += "Video feed is [camera.status ? "on" : "off"]"
	. += "Audio feed is [radio.broadcasting ? "on" : "off"]"

/obj/item/tvcamera/Initialize(mapload)
	. = ..()
	camera = new(src)
	camera.c_tag = channel
	camera.status = FALSE
	radio = new(src)
	radio.listening = FALSE
	radio.set_frequency(ENT_FREQ)
	radio.icon = src.icon
	radio.icon_state = src.icon_state
	update_icon()

/obj/item/tvcamera/hear_talk(mob/M, list/message_pieces, verb)
	radio.hear_talk(M, message_pieces, verb)
	. = ..()

/obj/item/tvcamera/attack_self(mob/user)
	add_fingerprint(user)
	user.set_machine(src)
	show_ui(user)

/obj/item/tvcamera/proc/show_ui(mob/user)
	var/dat = list()
	dat += "Channel name is: <a href='byond://?src=\ref[src];channel=1'>[channel ? channel : "unidentified broadcast"]</a><br>"
	dat += "Video streaming is <a href='byond://?src=\ref[src];video=1'>[camera.status ? "on" : "off"]</a><br>"
	if(camera.status && showing_name)
		dat += "- You're showing [showing_name] to your viewers.<br>"
	dat += "Mic is <a href='byond://?src=\ref[src];sound=1'>[radio.broadcasting ? "on" : "off"]</a><br>"
	dat += "Sound is being broadcasted on frequency [format_frequency(radio.frequency)] ([get_frequency_name(radio.frequency)])<br>"
	var/datum/browser/popup = new(user, "Hovercamera", "Eye Buddy", 300, 390, src)
	popup.set_content(jointext(dat,null))
	popup.open()

/obj/item/tvcamera/Topic(bred, href_list, state = GLOB.tgui_physical_state)
	if(..())
		return 1
	if(href_list["channel"])
		var/nc = tgui_input_text(usr, "Channel name", "Select new channel name", channel, MAX_NAME_LEN)
		nc = sanitize(nc,MAX_NAME_LEN)
		if(nc)
			channel = nc
			camera.c_tag = channel
			to_chat(usr, span_notice("New channel name - '[channel]' is set"))
	if(href_list["video"])
		camera.set_status(!camera.status)
		if(camera.status)
			to_chat(usr,span_notice("Video streaming activated. Broadcasting on channel '[channel]'"))
			show_tvs(loc)
		else
			to_chat(usr,span_notice("Video streaming deactivated."))
			hide_tvs()
			for(var/obj/machinery/computer/security/telescreen/entertainment/ES as anything in GLOB.entertainment_screens)
				ES.stop_showing()
		update_icon()
	if(href_list["sound"])
		radio.ToggleBroadcast()
		if(radio.broadcasting)
			to_chat(usr,span_notice("Audio streaming activated. Broadcasting on frequency [format_frequency(radio.frequency)]."))
		else
			to_chat(usr,span_notice("Audio streaming deactivated."))
	if(!href_list["close"])
		attack_self(usr)

/obj/item/tvcamera/proc/show_tvs(atom/thing)
	if(showing)
		hide_tvs(showing)

	showing = WEAKREF(thing)
	showing_name = "[thing]"
	for(var/obj/machinery/computer/security/telescreen/entertainment/ES as anything in GLOB.entertainment_screens)
		ES.show_thing(thing)

	START_PROCESSING(SSobj, src)

/obj/item/tvcamera/proc/hide_tvs()
	if(!showing)
		return
	for(var/obj/machinery/computer/security/telescreen/entertainment/ES as anything in GLOB.entertainment_screens)
		ES.maybe_stop_showing(showing)
	STOP_PROCESSING(SSobj, src)
	showing = null
	showing_name = null

/obj/item/tvcamera/Moved(atom/old_loc, direction, forced = FALSE, movetime)
	. = ..()
	if(camera.status && loc != old_loc)
		show_tvs(loc)

/obj/item/tvcamera/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(camera.status && !isturf(target))
		show_tvs(target)
		user.visible_message(span_infoplain(span_bold("[user]") + " aims [src] at [target]."), span_info("You aim [src] at [target]."))
		if(user.machine == src)
			show_ui(user) // refresh the UI

/obj/item/tvcamera/process()
	if(!showing)
		return PROCESS_KILL

	var/atom/A = showing.resolve()
	if(!A || QDELETED(A))
		show_tvs(loc)

	if(get_dist(get_turf(src), get_turf(A)) > 0) // No realtime updates
		show_tvs(loc)
		update_feed()

/obj/item/tvcamera/update_icon()
	..()
	if(camera.status)
		icon_state = "camcorder_on"
		item_state = "camcorder_on"
	else
		icon_state = "camcorder"
		item_state = "camcorder"
	var/mob/living/carbon/human/H = loc
	if(istype(H))
		H.update_inv_r_hand()
		H.update_inv_l_hand()
		H.update_inv_belt()

/obj/item/tvcamera/proc/update_feed()
	if(camera.status)
		SEND_SIGNAL(camera, COMSIG_OBSERVER_MOVED) // Forward the movement signal

//Assembly by roboticist

/obj/item/robot_parts/head/attackby(var/obj/item/assembly/S, mob/user as mob)
	if(!istype(S, /obj/item/assembly/infra))
		..()
		return
	var/obj/item/TVAssembly/A = new(user)
	qdel(S)
	user.put_in_hands(A)
	to_chat(user, span_notice("You add the infrared sensor to the robot head."))
	user.drop_from_inventory(src)
	qdel(src)


/obj/item/TVAssembly
	name = "\improper TV Camera Assembly"
	desc = "A robotic head with an infrared sensor inside."
	icon = 'icons/obj/robot_parts.dmi'
	icon_state = "head"
	item_state = "head"
	var/buildstep = 0
	w_class = ITEMSIZE_LARGE

/obj/item/TVAssembly/attackby(W, mob/user)
	switch(buildstep)
		if(0)
			if(istype(W, /obj/item/robot_parts/robot_component/camera))
				var/obj/item/robot_parts/robot_component/camera/CA = W
				to_chat(user, span_notice("You add the camera module to [src]"))
				user.drop_item()
				qdel(CA)
				desc = "This TV camera assembly has a camera module."
				buildstep++
		if(1)
			if(istype(W, /obj/item/taperecorder))
				var/obj/item/taperecorder/T = W
				user.drop_item()
				qdel(T)
				buildstep++
				to_chat(user, span_notice("You add the tape recorder to [src]"))
		if(2)
			if(istype(W, /obj/item/stack/cable_coil))
				var/obj/item/stack/cable_coil/C = W
				if(!C.use(3))
					to_chat(user, span_notice("You need six cable coils to wire the devices."))
					..()
					return
				C.use(3)
				buildstep++
				to_chat(user, span_notice("You wire the assembly"))
				desc = "This TV camera assembly has wires sticking out"
				return
		if(3)
			if(istype(W, /obj/item/tool/wirecutters))
				to_chat(user, span_notice(" You trim the wires."))
				buildstep++
				desc = "This TV camera assembly needs casing."
				return
		if(4)
			if(istype(W, /obj/item/stack/material/steel))
				var/obj/item/stack/material/steel/S = W
				buildstep++
				S.use(1)
				to_chat(user, span_notice("You encase the assembly in a Ward-Takeshi casing."))
				var/turf/T = get_turf(src)
				new /obj/item/tvcamera(T)
				user.drop_from_inventory(src)
				qdel(src)
				return

	..()
