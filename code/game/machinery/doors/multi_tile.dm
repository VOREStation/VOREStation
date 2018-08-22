//Terribly sorry for the code doubling, but things go derpy otherwise.
/obj/machinery/door/airlock/multi_tile
	width = 2
	appearance_flags = 0
	var/obj/machinery/filler_object/filler1
	var/obj/machinery/filler_object/filler2

/obj/machinery/door/airlock/multi_tile/New()
	..()
	SetBounds()
	if(opacity)
		create_fillers()

/obj/machinery/door/airlock/multi_tile/Destroy()
	QDEL_NULL(filler1)
	QDEL_NULL(filler2)
	return ..()

/obj/machinery/door/airlock/multi_tile/Move()
	. = ..()
	SetBounds()

/obj/machinery/door/airlock/multi_tile/open()
	. = ..()

	if(filler1)
		filler1.set_opacity(opacity)
		if(filler2)
			filler2.set_opacity(opacity)

	return .

/obj/machinery/door/airlock/multi_tile/close()
	. = ..()

	if(filler1)
		filler1.set_opacity(opacity)
		if(filler2)
			filler2.set_opacity(opacity)

	return .

/obj/machinery/door/airlock/multi_tile/proc/SetBounds()
	if(dir in list(EAST, WEST))
		bound_width = width * world.icon_size
		bound_height = world.icon_size
	else
		bound_width = world.icon_size
		bound_height = width * world.icon_size

/obj/machinery/door/airlock/multi_tile/proc/create_fillers()
	if(src.dir > 3)
		filler1 = new/obj/machinery/filler_object (src.loc)
		filler2 = new/obj/machinery/filler_object (get_step(src,EAST))
	else
		filler1 = new/obj/machinery/filler_object (src.loc)
		filler2 = new/obj/machinery/filler_object (get_step(src,NORTH))
	filler1.density = 0
	filler2.density = 0
	filler1.set_opacity(opacity)
	filler2.set_opacity(opacity)

/obj/machinery/door/airlock/multi_tile/glass
	name = "Glass Airlock"
	icon = 'icons/obj/doors/Door2x1glass.dmi'
	opacity = 0
	glass = 1
	assembly_type = /obj/structure/door_assembly/multi_tile

/obj/machinery/door/airlock/multi_tile/metal
	name = "Airlock"
	icon = 'icons/obj/doors/Door2x1metal.dmi'
	assembly_type = /obj/structure/door_assembly/multi_tile

/obj/machinery/filler_object
	name = ""
	icon = 'icons/obj/doors/rapid_pdoor.dmi'
	icon_state = ""
	density = 0

/obj/machinery/door/airlock/multi_tile/metal/mait
	icon = 'icons/obj/doors/Door2x1_Maint.dmi'
