/obj/machinery/computer/security/telescreen/bodycamera
	name = "bodycamera monitor"
	desc = "Damn, why do they never have anything interesting on these things? (Alt-click to toggle the display)"
	icon = 'icons/obj/entertainment_monitor.dmi'
	icon_state = "screen"
	icon_screen = null
	light_color = "#FFEEDB"
	light_range_on = 2
	network = list(NETWORK_BODYCAM)
	circuit = /obj/item/circuitboard/security/telescreen/bodycamera
	camera_datum_type = /datum/tgui_module/camera/bigscreen

	var/obj/item/radio/bradio = null
	var/obj/effect/overlay/vis/bpinboard
	var/datum/weakref/showing
	var/datum/weakref/the_camera

	var/enabled = TRUE // on or off

/obj/machinery/computer/security/telescreen/bodycamera/Initialize(mapload)
	GLOB.bodycamera_screens += src

	var/static/icon/mask = icon('icons/obj/entertainment_monitor.dmi', "mask")

	add_overlay("glass")

	bpinboard = SSvis_overlays.add_vis_overlay(src, icon = icon, iconstate = "pinboard", layer = 0.1, add_appearance_flags = KEEP_TOGETHER, add_vis_flags = VIS_INHERIT_ID|VIS_INHERIT_PLANE, unique = TRUE)
	bpinboard.add_filter("screen cutter", 1, alpha_mask_filter(icon = mask))
	vis_contents += bpinboard
	/*
	bpinboard = new()
	bpinboard.icon = icon
	bpinboard.icon_state = "pinboard"
	bpinboard.layer = 0.1
	bpinboard.vis_flags = VIS_UNDERLAY|VIS_INHERIT_ID|VIS_INHERIT_PLANE
	bpinboard.appearance_flags = KEEP_TOGETHER
	bpinboard.add_filter("screen cutter", 1, alpha_mask_filter(icon = mask))
	vis_contents += bpinboard
	*/

	. = ..()

	bradio = new(src)
	bradio.listening = TRUE
	bradio.broadcasting = FALSE
	bradio.set_frequency(BDCM_FREQ)
	bradio.canhear_range = world.view // Same as default sight range.
	power_change()

/obj/machinery/computer/security/telescreen/bodycamera/Destroy()
	if(showing)
		stop_showing()
	vis_contents.Cut()
	QDEL_NULL(bpinboard)
	QDEL_NULL(bradio)
	return ..()

/obj/machinery/computer/security/telescreen/bodycamera/proc/bodycam_toggle()
	enabled = !enabled
	if(!enabled)
		stop_showing()
		bradio?.on = FALSE
	else if(operable())
		bradio?.on = TRUE

/obj/machinery/computer/security/telescreen/bodycamera/Click(location, control, params)
	var/list/modifiers = params2list(params)
	if(modifiers["alt"])
		if(isliving(usr) && Adjacent(usr) && !usr.incapacitated())
			bodycam_toggle()
			visible_message(span_bold("[usr]") + " toggles [src] [enabled ? "on" : "off"].","You toggle [src] [enabled ? "on" : "off"].", runemessage = "click")
	//Changing click to only come into play when shift or alt clicking. These things are ANNOYING.
			return
	if(modifiers["shift"])
		attack_hand(usr)
		return
	..()

/obj/machinery/computer/security/telescreen/bodycamera/update_icon()
	return // NUH

/obj/machinery/computer/security/telescreen/bodycamera/process()
	if(!showing || !the_camera)
		stop_showing()
		return
	var/atom/them = showing.resolve()
	var/obj/item/clothing/accessory/bodycam/bo_cam = the_camera.resolve()
	var/turf/here = get_turf(them)
	var/turf/there = get_turf(bo_cam)
	if(here != there)
		stop_showing()

/obj/machinery/computer/security/telescreen/bodycamera/proc/show_thing(atom/thing, obj/item/clothing/accessory/bodycam/other_thing)
	if(!enabled)
		return
	if(showing)
		stop_showing()
	if(stat & NOPOWER)
		return
	if(!thing || !other_thing)
		return
	the_camera = WEAKREF(other_thing)
	var/tries = 10
	var/atom/recursive_loc = thing
	while(--tries)
		recursive_loc = thing.loc
		if(!istype(recursive_loc, /atom/movable))
			break
	thing = recursive_loc // should get the topmost atom, which *should* be a mob, or a locker, or something that isnt just ~clothes~
	showing = WEAKREF(thing)
	if(bpinboard)
		bpinboard.vis_contents = list(thing)

/obj/machinery/computer/security/telescreen/bodycamera/proc/stop_showing()
	// Reverse of the above
	if(bpinboard)
		bpinboard.vis_contents = null
	showing = null
	the_camera = null

/obj/machinery/computer/security/telescreen/bodycamera/proc/maybe_stop_showing(datum/weakref/thingref)
	if(showing == thingref)
		stop_showing()

/obj/machinery/computer/security/telescreen/bodycamera/power_change()
	..()
	if(stat & NOPOWER)
		bradio?.on = FALSE
		stop_showing()
	else if(enabled)
		bradio?.on = TRUE
