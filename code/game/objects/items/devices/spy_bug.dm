/obj/item/device/camerabug
	name = "mobile camera pod"
	desc = "A camera pod used by tactical operators. Must be linked to a camera scanner unit."
	icon = 'icons/obj/grenade.dmi'
	icon_state = "camgrenade"
	item_state = "empgrenade"
	w_class = ITEMSIZE_SMALL
	force = 0
	throwforce = 5.0
	throw_range = 15
	throw_speed = 3
	origin_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	var/obj/item/device/bug_monitor/linkedmonitor
	var/brokentype = /obj/item/brokenbug

//	var/obj/item/device/radio/bug/radio
	var/obj/machinery/camera/bug/camera
	var/camtype = /obj/machinery/camera/bug

/obj/item/device/camerabug/New()
	..()
//	radio = new(src)
	camera = new camtype(src)

/obj/item/device/camerabug/attack_self(mob/user)
	if(user.a_intent == I_HURT)
		to_chat(user, "<span class='notice'>You crush the [src] under your foot, breaking it.</span>")
		visible_message("[user.name] crushes the [src] under their foot, breaking it!</span>")
		new brokentype(get_turf(src))
		spawn(0)
		qdel(src)
/*	else
		user.set_machine(radio)
		radio.interact(user)
*/
/obj/item/device/camerabug/verb/reset()
	set name = "Reset camera bug"
	set category = "Object"
	if(linkedmonitor)
		linkedmonitor.unpair(src)
	linkedmonitor = null
	qdel(camera)
	camera = new camtype(src)
	to_chat(usr, "<span class='notice'>You turn the [src] off and on again, delinking it from any monitors.")

/obj/item/brokenbug
	name = "broken mobile camera pod"
	desc = "A camera pod formerly used by tactical operators. The lens is smashed, and the circuits are damaged beyond repair."
	icon = 'icons/obj/grenade.dmi'
	icon_state = "camgrenadebroken"
	item_state = "empgrenade"
	force = 5.0
	w_class = ITEMSIZE_SMALL
	throwforce = 5.0
	throw_range = 15
	throw_speed = 3
	origin_tech = list(TECH_ENGINEERING = 1)

/obj/item/brokenbug/spy
	name = "broken bug"
	desc = ""	//Even when it's broken it's inconspicuous
	icon = 'icons/obj/weapons.dmi'
	icon_state = "eshield"
	item_state = "nothing"
	layer = TURF_LAYER+0.2
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_EARS
	origin_tech = list(TECH_ENGINEERING = 1, TECH_ILLEGAL = 3) //crush it and you lose the data
	force = 0
	throwforce = 5.0
	throw_range = 15
	throw_speed = 3

/obj/item/device/camerabug/spy
	name = "bug"
	desc = ""	//Nothing to see here
	icon = 'icons/obj/weapons.dmi'
	icon_state = "eshield"
	item_state = "nothing"
	layer = TURF_LAYER+0.2
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_EARS
	origin_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1, TECH_ILLEGAL = 3)
	camtype = /obj/machinery/camera/bug/spy

/obj/item/device/camerabug/examine(mob/user)
	. = ..()
	if(get_dist(user, src) == 0)
		. += "It has a tiny camera inside. Needs to be both configured and brought in contact with monitor device to be fully functional."

/obj/item/device/camerabug/update_icon()
	..()

	if(anchored)	// Standard versions are relatively obvious if not hidden in a container. Anchoring them is advised, to disguise them.
		alpha = 50
	else
		alpha = 255

/obj/item/device/camerabug/attackby(obj/item/W as obj, mob/living/user as mob)
	if(istype(W, /obj/item/device/bug_monitor))
		var/obj/item/device/bug_monitor/SM = W
		if(!linkedmonitor)
			to_chat(user, "<span class='notice'>\The [src] has been paired with \the [SM].</span>")
			SM.pair(src)
			linkedmonitor = SM
		else if (linkedmonitor == SM)
			to_chat(user, "<span class='notice'>\The [src] has been unpaired from \the [SM].</span>")
			linkedmonitor.unpair(src)
			linkedmonitor = null
		else
			to_chat(user, "Error: The device is linked to another monitor.")

	else if(W.has_tool_quality(TOOL_WRENCH) && user.a_intent != I_HURT)
		if(isturf(loc))
			anchored = !anchored

			to_chat(user, "<span class='notice'>You [anchored ? "" : "un"]secure \the [src].</span>")

			update_icon()
			return
	else
		if(W.force >= 5)
			visible_message("\The [src] lens shatters!")
			new brokentype(get_turf(src))
			if(linkedmonitor)
				linkedmonitor.unpair(src)
			linkedmonitor = null
			spawn(0)
			qdel(src)
		..()

/obj/item/device/camerabug/bullet_act()
	visible_message("The [src] lens shatters!")
	new brokentype(get_turf(src))
	if(linkedmonitor)
		linkedmonitor.unpair(src)
	linkedmonitor = null
	spawn(0)
	qdel(src)

/obj/item/device/camerabug/Destroy()
	if(linkedmonitor)
		linkedmonitor.unpair(src)
	linkedmonitor = null
	..()

/obj/item/device/bug_monitor
	name = "mobile camera pod monitor"
	desc = "A portable camera console designed to work with mobile camera pods."
	icon = 'icons/obj/device.dmi'
	icon_state = "forensic0"
	item_state = "electronic"
	w_class  = ITEMSIZE_SMALL
	origin_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)

	var/operating = 0
//	var/obj/item/device/radio/bug/radio
	var/obj/machinery/camera/bug/selected_camera
	var/list/obj/machinery/camera/bug/cameras = new()
/*
/obj/item/device/bug_monitor/New()
	radio = new(src)
*/
/obj/item/device/bug_monitor/attack_self(mob/user)
	if(operating)
		return

//	radio.attack_self(user)
	view_cameras(user)

/obj/item/device/bug_monitor/attackby(obj/item/W as obj, mob/living/user as mob)
	if(istype(W, /obj/item/device/camerabug))
		W.attackby(src, user)
	else
		return ..()

/obj/item/device/bug_monitor/proc/unpair(var/obj/item/device/camerabug/SB)
	if(SB.camera in cameras)
		cameras -= SB.camera

/obj/item/device/bug_monitor/proc/pair(var/obj/item/device/camerabug/SB)
	cameras += SB.camera

/obj/item/device/bug_monitor/proc/view_cameras(mob/user)
	if(!can_use_cam(user))
		return

	selected_camera = cameras[1]
	user.reset_view(selected_camera)
	view_camera(user)

	operating = 1
	while(selected_camera && Adjacent(user))
		selected_camera = tgui_input_list(usr, "Select camera to view.", "Camera Choice", cameras)
	selected_camera = null
	operating = 0

/obj/item/device/bug_monitor/proc/view_camera(mob/user)
	spawn(0)
		while(selected_camera && Adjacent(user))
			var/turf/T = get_turf(selected_camera)
			if(!T || !is_on_same_plane_or_station(T.z, user.z) || !selected_camera.can_use())
				user.unset_machine()
				user.reset_view(null)
				to_chat(user, "<span class='notice'>Link to [selected_camera] has been lost.</span>")
				src.unpair(selected_camera.loc)
				sleep(90)
			else
				user.set_machine(selected_camera)
				user.reset_view(selected_camera)
			sleep(10)
		user.unset_machine()
		user.reset_view(null)

/obj/item/device/bug_monitor/proc/can_use_cam(mob/user)
	if(operating)
		return

	if(!cameras.len)
		to_chat(user, "<span class='warning'>No paired cameras detected!</span>")
		to_chat(user, "<span class='warning'>Bring a camera in contact with this device to pair the camera.</span>")
		return

	return 1

/obj/item/device/bug_monitor/spy
	name = "\improper PDA"
	desc = "A portable microcomputer by Thinktronic Systems, LTD. Functionality determined by a preprogrammed ROM cartridge."
	icon = 'icons/obj/pda.dmi'
	icon_state = "pda"
	item_state = "electronic"
	origin_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1, TECH_ILLEGAL = 3)

/obj/item/device/bug_monitor/spy/examine(mob/user)
	. = ..()
	if(Adjacent(user))
		. += "The time '12:00' is blinking in the corner of the screen and \the [src] looks very cheaply made."

/obj/machinery/camera/bug/check_eye(var/mob/user as mob)
	return 0

/obj/machinery/camera/bug
	network = list(NETWORK_SECURITY)

/obj/machinery/camera/bug/New()
	..()
	name = "Camera #[rand(1000,9999)]"
	c_tag = name

/obj/machinery/camera/bug/spy
	// These cheap toys are accessible from the mercenary camera console as well - only the antag ones though!
	network = list(NETWORK_MERCENARY)

/obj/machinery/camera/bug/spy/New()
	..()
	name = "DV-136ZB #[rand(1000,9999)]"
	c_tag = name

/* //These were originally supposed to have radios in them. Doesn't work.
/obj/item/device/radio/bug
	listening = 0 //turn it on first
	frequency = 1359 //sec comms
	broadcasting = 0
	canhear_range = 1
	name = "camera bug device"
	icon_state = "syn_cypherkey"

/obj/item/device/radio/bug/spy
	listening = 0
	frequency = 1473
	broadcasting = 0
	canhear_range = 1
	name = "spy device"
	icon_state = "syn_cypherkey"
	*/