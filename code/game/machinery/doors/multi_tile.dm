//Terribly sorry for the code doubling, but things go derpy otherwise.
/obj/machinery/door/airlock/multi_tile
	width = 2
	appearance_flags = 0
	var/obj/machinery/filler_object/filler1
	var/obj/machinery/filler_object/filler2
	open_sound_powered = 'sound/machines/door/WideOpen.ogg'
	close_sound_powered = 'sound/machines/door/WideClose.ogg'

/obj/machinery/door/airlock/multi_tile/Initialize()
	. = ..()
	SetBounds()
	RegisterSignal(src, COMSIG_MOVABLE_MOVED, .proc/SetBounds)
	apply_opacity_to_my_turfs(opacity)

/obj/machinery/door/airlock/multi_tile/set_opacity()
	. = ..()
	apply_opacity_to_my_turfs(opacity)

/obj/machinery/door/airlock/multi_tile/proc/apply_opacity_to_my_turfs(new_opacity)
	for(var/turf/T in locs)
		T.set_opacity(new_opacity)
	update_nearby_tiles()

/obj/machinery/door/airlock/multi_tile/Destroy()
	UnregisterSignal(src, COMSIG_MOVABLE_MOVED)
	return ..()

/obj/machinery/door/airlock/multi_tile/proc/SetBounds()
	if(dir in list(EAST, WEST))
		bound_width = width * world.icon_size
		bound_height = world.icon_size
	else
		bound_width = world.icon_size
		bound_height = width * world.icon_size

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

/obj/machinery/door/airlock/multi_tile/metal/mait
	icon = 'icons/obj/doors/Door2x1_Maint.dmi'
	//req_one_access = list(access_maint_tunnels) //VOREStaiton Edit - Maintenance is open access