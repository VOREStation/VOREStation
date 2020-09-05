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

/obj/machinery/computer/security/Initialize()
	. = ..()
	if(!LAZYLEN(network))
		network = get_default_networks()
	camera = new(src, network)

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
	plane = TURF_PLANE
	layer = ABOVE_TURF_LAYER
	icon_keyboard = null
	icon_screen = null
	light_range_on = 0
	network = list(NETWORK_THUNDER)
	density = 0
	circuit = null

/obj/machinery/computer/security/telescreen/entertainment
	name = "entertainment monitor"
	desc = "Damn, why do they never have anything interesting on these things?"
	icon = 'icons/obj/status_display.dmi'
	icon_screen = "entertainment"
	light_color = "#FFEEDB"
	light_range_on = 2
	network = list(NETWORK_THUNDER)
	circuit = /obj/item/weapon/circuitboard/security/telescreen/entertainment
	var/obj/item/device/radio/radio = null

/obj/machinery/computer/security/telescreen/entertainment/Initialize()
	. = ..()
	radio = new(src)
	radio.listening = TRUE
	radio.broadcasting = FALSE
	radio.set_frequency(ENT_FREQ)
	radio.canhear_range = 7 // Same as default sight range.
	power_change()

/obj/machinery/computer/security/telescreen/entertainment/power_change()
	..()
	if(radio)
		if(stat & NOPOWER)
			radio.on = FALSE
		else
			radio.on = TRUE

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
