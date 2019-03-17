/obj/machinery/door/firedoor/glass/hidden
	name = "\improper Emergency Shutter System"
	desc = "Emergency air-tight shutter, capable of sealing off breached areas. This model fits flush with the walls, and has a panel in the floor for maintenance."
	icon = 'icons/obj/doors/DoorHazardHidden.dmi'
	plane = TURF_PLANE

/obj/machinery/door/firedoor/glass/hidden/open()
	. = ..()
	plane = TURF_PLANE

/obj/machinery/door/firedoor/glass/hidden/close()
	. = ..()
	plane = OBJ_PLANE

/obj/machinery/door/firedoor/glass/hidden/steel
	name = "\improper Emergency Shutter System"
	desc = "Emergency air-tight shutter, capable of sealing off breached areas. This model fits flush with the walls, and has a panel in the floor for maintenance."
	icon = 'icons/obj/doors/DoorHazardHidden_steel.dmi'
