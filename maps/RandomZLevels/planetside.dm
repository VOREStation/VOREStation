///// Areas /////

/area/awaymission/planetside
	name = "\improper Strange Location"
	icon_state = "white"
	requires_power = 0
	lighting_use_dynamic = 0

/area/awaymission/planetside/indoors
	icon_state = "unknown"
	requires_power = 0
	lighting_use_dynamic = 1

/area/awaymission/planetside/indoors/spaceport
	name = "Nanotrasen Virgo-Prime Spaceport"
	icon_state = "bluenew"

/area/awaymission/planetside/marketplace
	name = "Marketplace"
	icon_state = "dk_yellow"

///// Turfs /////

/turf/unsimulated/planetside
	name = "desert"
	icon = 'code/WorkInProgress/Susan/desert.dmi'
	icon_state = "desert"
	luminosity = 5
	lighting_lumcount = 8

	New()
		icon_state = "desert[rand(0,4)]"

/turf/unsimulated/planetside/edge/Entered(atom/movable/O)
	..()
	if(istype(O, /mob/living/))
		var/mob/living/M = O
		M << "\red You feel like you should turn back. There's nothing but harsh deserts ahead."

///// Props /////

/obj/machinery/computer/prop/laptop // Does nothing but look pretty.
	name = "\improper Nanotrasen-brand Laptop"
	desc = "An overpriced Spacebook browser."
	icon_state = "medlaptop"
	circuit = "/obj/item/weapon/circuitboard/laptop"
	density = 0

/obj/item/weapon/circuitboard/laptop
	name = "laptop motherboard"
	build_path = "/obj/machinery/computer/prop"
	origin_tech = "programming=2"

/obj/machinery/computer/prop/shuttle
	name = "terminal"
	icon_state = "shuttle"