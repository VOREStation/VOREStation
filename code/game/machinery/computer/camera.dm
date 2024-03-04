//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/machinery/computer/security
	name = "security camera monitor"
	desc = "Used to access the various cameras on the station."

	icon_keyboard = "security_key"
	icon_screen = "cameras"
	light_color = "#a91515"
	circuit = /obj/item/weapon/circuitboard/security

	var/mapping = 0//For the overview file, interesting bit of code.
	var/list/network = list()

	var/datum/tgui_module/camera/camera
	var/camera_datum_type = /datum/tgui_module/camera

/obj/machinery/computer/security/Initialize()
	. = ..()
	if(!LAZYLEN(network))
		network = get_default_networks()
	camera = new camera_datum_type(src, network)

/obj/machinery/computer/security/proc/get_default_networks()
	. = using_map.station_networks.Copy()

/obj/machinery/computer/security/Destroy()
	QDEL_NULL(camera)
	return ..()

/obj/machinery/computer/security/tgui_interact(mob/user, datum/tgui/ui = null)
	camera.tgui_interact(user, ui)

/obj/machinery/computer/security/attack_hand(mob/user)
	add_fingerprint(user)
	if(stat & (BROKEN|NOPOWER))
		return
	tgui_interact(user)

/obj/machinery/computer/security/attack_robot(mob/user)
	if(isrobot(user))
		var/mob/living/silicon/robot/R = user
		if(!R.shell)
			return attack_hand(user)
	..()

/obj/machinery/computer/security/attack_ai(mob/user)
	if(isAI(user))
		to_chat(user, "<span class='notice'>You realise its kind of stupid to access a camera console when you have the entire camera network at your metaphorical fingertips</span>")
		return
	attack_hand(user)

/obj/machinery/computer/security/proc/set_network(list/new_network)
	network = new_network
	camera.network = network
	camera.access_based = FALSE

//Camera control: arrow keys.
/obj/machinery/computer/security/telescreen
	name = "Telescreen"
	desc = "Used for watching an empty arena."
	icon_state = "wallframe"
	layer = ABOVE_WINDOW_LAYER
	icon_keyboard = null
	icon_screen = null
	light_range_on = 0
	network = list(NETWORK_THUNDER)
	density = FALSE
	circuit = null

GLOBAL_LIST_EMPTY(entertainment_screens)
/obj/machinery/computer/security/telescreen/entertainment
	name = "entertainment monitor"
	desc = "Damn, why do they never have anything interesting on these things? (Alt-click to toggle the display)"
	icon = 'icons/obj/entertainment_monitor.dmi'
	icon_state = "screen"
	icon_screen = null
	light_color = "#FFEEDB"
	light_range_on = 2
	network = list(NETWORK_THUNDER)
	circuit = /obj/item/weapon/circuitboard/security/telescreen/entertainment
	camera_datum_type = /datum/tgui_module/camera/bigscreen

	var/obj/item/device/radio/radio = null
	var/obj/effect/overlay/vis/pinboard
	var/datum/weakref/showing

	var/enabled = TRUE // on or off

/obj/machinery/computer/security/telescreen/entertainment/Initialize()
	GLOB.entertainment_screens += src

	var/static/icon/mask = icon('icons/obj/entertainment_monitor.dmi', "mask")

	add_overlay("glass")

	pinboard = new()
	pinboard.icon = icon
	pinboard.icon_state = "pinboard"
	pinboard.layer = 0.1
	pinboard.vis_flags = VIS_UNDERLAY|VIS_INHERIT_ID|VIS_INHERIT_PLANE
	pinboard.appearance_flags = KEEP_TOGETHER
	pinboard.add_filter("screen cutter", 1, alpha_mask_filter(icon = mask))
	vis_contents += pinboard

	. = ..()

	radio = new(src)
	radio.listening = TRUE
	radio.broadcasting = FALSE
	radio.set_frequency(ENT_FREQ)
	radio.canhear_range = world.view // Same as default sight range.
	power_change()

/obj/machinery/computer/security/telescreen/entertainment/Destroy()
	if(showing)
		stop_showing()
	vis_contents.Cut()
	qdel_null(pinboard)
	qdel_null(radio)
	return ..()

/obj/machinery/computer/security/telescreen/entertainment/proc/toggle()
	enabled = !enabled
	if(!enabled)
		stop_showing()
		radio?.on = FALSE
	else if(operable())
		radio?.on = TRUE

/obj/machinery/computer/security/telescreen/entertainment/Click(location, control, params)
	var/list/modifiers = params2list(params)
	if(modifiers["alt"])
		if(isliving(usr) && Adjacent(usr) && !usr.incapacitated())
			toggle()
			visible_message("<b>[usr]</b> toggles [src] [enabled ? "on" : "off"].","You toggle [src] [enabled ? "on" : "off"].", runemessage = "click")
	else
		attack_hand(usr)

/obj/machinery/computer/security/telescreen/entertainment/update_icon()
	return // NUH

/obj/machinery/computer/security/telescreen/entertainment/proc/show_thing(atom/thing)
	if(!enabled)
		return
	if(showing)
		stop_showing()
	if(stat & NOPOWER)
		return
	showing = WEAKREF(thing)
	pinboard.vis_contents = list(thing)

/obj/machinery/computer/security/telescreen/entertainment/proc/stop_showing()
	// Reverse of the above
	pinboard.vis_contents = null
	showing = null

/obj/machinery/computer/security/telescreen/entertainment/proc/maybe_stop_showing(datum/weakref/thingref)
	if(showing == thingref)
		stop_showing()

/obj/machinery/computer/security/telescreen/entertainment/power_change()
	..()
	if(stat & NOPOWER)
		radio?.on = FALSE
		stop_showing()
	else if(enabled)
		radio?.on = TRUE

/obj/machinery/computer/security/wooden_tv
	name = "security camera monitor"
	desc = "An old TV hooked into the station's camera network."
	icon_state = "television"
	icon_keyboard = null
	icon_screen = "detective_tv"
	circuit = /obj/item/weapon/circuitboard/security/tv
	light_color = "#3848B3"
	light_power_on = 0.5

/obj/machinery/computer/security/mining
	name = "outpost camera monitor"
	desc = "Used to watch over mining operations."
	icon_keyboard = "mining_key"
	icon_screen = "mining"
	network = list("Mining Outpost")
	circuit = /obj/item/weapon/circuitboard/security/mining
	light_color = "#F9BBFC"

/obj/machinery/computer/security/engineering
	name = "engineering camera monitor"
	desc = "Used to monitor fires and breaches."
	icon_keyboard = "power_key"
	icon_screen = "engie_cams"
	circuit = /obj/item/weapon/circuitboard/security/engineering
	light_color = "#FAC54B"

/obj/machinery/computer/security/engineering/get_default_networks()
	. = engineering_networks.Copy()

/obj/machinery/computer/security/nuclear
	name = "head mounted camera monitor"
	desc = "Used to access the built-in cameras in helmets."
	icon_state = "syndicam"
	network = list(NETWORK_MERCENARY)
	circuit = null
	req_access = list(150)
