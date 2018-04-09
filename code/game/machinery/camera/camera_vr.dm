/obj/machinery/camera
	layer = BELOW_MOB_LAYER

/obj/machinery/camera/New()
	..()
	if (dir == NORTH)
		layer = ABOVE_MOB_LAYER