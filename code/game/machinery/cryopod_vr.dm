//Overrides!

/obj/machinery/cryopod/robot/door/gateway
	name = "public teleporter"
	desc = "The short-range teleporter you might've came in from. You could leave easily using this."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "tele0"
	base_icon_state = "tele0"
	occupied_icon_state = "tele1"
	on_store_message = "has departed via short-range teleport."
	on_enter_occupant_message = "The teleporter activates, and you step into the swirling portal."

/obj/machinery/computer/cryopod/gateway
	name = "teleport oversight console"
	desc = "An interface between visitors and the teleport oversight systems tasked with keeping track of all visitors who enter or exit from the teleporters."

/obj/machinery/cryopod/robot/door/dorms
	desc = "A small elevator that goes down to the residential district."
	on_enter_occupant_message = "The elevator door closes slowly, ready to bring you down to the residential district."

/obj/machinery/computer/cryopod/dorms
	name = "residential oversight console"
	desc = "An interface between visitors and the residential oversight systems tasked with keeping track of all visitors in the residential district."