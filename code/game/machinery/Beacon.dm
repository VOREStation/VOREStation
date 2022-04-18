/obj/machinery/bluespace_beacon
	icon = 'icons/obj/objects.dmi'
	icon_state = "floor_beaconf"
	name = "Bluespace Gigabeacon"
	desc = "A device that draws power from bluespace and creates a permanent tracking beacon."
	level = 1		// underfloor
	layer = UNDER_JUNK_LAYER
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 0
	var/obj/item/radio/beacon/Beacon

/obj/machinery/bluespace_beacon/New()
	..()
	var/turf/T = src.loc
	Beacon = new /obj/item/radio/beacon
	Beacon.invisibility = INVISIBILITY_MAXIMUM
	Beacon.loc = T

	hide(!T.is_plating())

/obj/machinery/bluespace_beacon/Destroy()
	if(Beacon)
		qdel(Beacon)
	..()

// update the invisibility and icon
/obj/machinery/bluespace_beacon/hide(var/intact)
	invisibility = intact ? 101 : 0
	updateicon()

// update the icon_state
/obj/machinery/bluespace_beacon/proc/updateicon()
	var/state="floor_beacon"

	if(invisibility)
		icon_state = "[state]f"
	else
		icon_state = "[state]"

/obj/machinery/bluespace_beacon/process()
	if(!Beacon)
		var/turf/T = src.loc
		Beacon = new /obj/item/radio/beacon
		Beacon.invisibility = INVISIBILITY_MAXIMUM
		Beacon.loc = T
	if(Beacon)
		if(Beacon.loc != src.loc)
			Beacon.loc = src.loc

	updateicon()