/obj/machinery/camera
	layer = 4

/obj/machinery/camera/New()
	..()
	if (dir == 1) // idk why the fuck dir is not 2
		layer = 5