/obj/machinery/computer/security/abductor
	name = "camera uplink"
	desc = "Used for hacking into camera networks"
	icon = 'icons/obj/abductor.dmi'
	icon_state = "camera"
	network = list(NETWORK_MERCENARY,
					NETWORK_CARGO,
					NETWORK_CIRCUITS,
					NETWORK_CIVILIAN,
					NETWORK_COMMAND,
					NETWORK_ENGINE,
					NETWORK_ENGINEERING,
					NETWORK_EXPLORATION,
					NETWORK_MEDICAL,
					NETWORK_MINE,
					NETWORK_OUTSIDE,
					NETWORK_RESEARCH,
					NETWORK_RESEARCH_OUTPOST,
					NETWORK_ROBOTS,
					NETWORK_SECURITY,
					NETWORK_TELECOM,
					NETWORK_TETHER,
					NETWORK_TALON_SHIP,
					NETWORK_THUNDER,
					NETWORK_COMMUNICATORS
					)

/obj/machinery/computer/security/xenobio
	name = "xenobiology camera monitor"
	desc = "Used to access the xenobiology cell cameras."
	icon_keyboard = "mining_key"
	icon_screen = "mining"
	network = list(NETWORK_XENOBIO)
	circuit = /obj/item/circuitboard/security/xenobio
	light_color = "#F9BBFC"
