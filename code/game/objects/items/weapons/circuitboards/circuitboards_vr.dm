#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

// VOREStation specific circuit boards!

// Our own board so deconstructing and reconstructing gets the same machine back...
/obj/item/weapon/circuitboard/jukebox/vore
	name = T_BOARD("VORE jukebox")
	build_path = /obj/machinery/media/jukebox/vore
