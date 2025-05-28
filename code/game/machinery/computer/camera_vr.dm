/obj/machinery/computer/security/abductor
	name = "camera uplink"
	desc = "Used for hacking into camera networks"
	icon = 'icons/obj/abductor.dmi'
	icon_state = "camera"
	network = list(	"Mercenary",
					"Cargo",
					"Circuits",
					"Civilian",
					"Command",
					"Engine",
					"Engineering",
					"Exploration",
					"Medical",
					"Mining Outpost",
					"Outside",
					"Research",
					"Research Outpost",
					"Robots",
					"Security",
					"Telecommunications",
					"Tether",
					"TalonShip",
					"Entertainment",
					"Communicators"
					)

/obj/machinery/computer/security/xenobio
	name = "xenobiology camera monitor"
	desc = "Used to access the xenobiology cell cameras."
	icon_keyboard = "mining_key"
	icon_screen = "mining"
	network = list(NETWORK_XENOBIO)
	circuit = /obj/item/circuitboard/security/xenobio
	light_color = "#F9BBFC"
