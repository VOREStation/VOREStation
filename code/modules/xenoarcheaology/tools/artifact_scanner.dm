/obj/machinery/artifact_scanpad
	name = "Anomaly Scanner Pad"
	desc = "Place things here for scanning."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "tele0"
	anchored = TRUE
	density = FALSE
	circuit = /obj/item/circuitboard/artifact_scanpad

/obj/machinery/artifact_scanpad/attackby(var/obj/I as obj, var/mob/user as mob)
	if(default_deconstruction_screwdriver(user, I))
		return
	if(default_deconstruction_crowbar(user, I))
		return
	if(default_part_replacement(user, I))
		return

/obj/machinery/artifact_scanpad/Initialize(mapload)
	. = ..()
	default_apply_parts()
	update_icon()
