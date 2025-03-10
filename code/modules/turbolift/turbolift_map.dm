// Map object.
/obj/turbolift_map_holder
	name = "turbolift map placeholder"
	icon = 'icons/obj/turbolift_preview_3x3.dmi'
	dir = SOUTH			// Direction of the holder determines the placement of the lift control panel and doors.
	var/depth = 1		// Number of floors to generate, including the initial floor.
	var/lift_size_x = 2 // Number of turfs on each axis to generate in addition to the first
	var/lift_size_y = 2 // ie. a 3x3 lift would have a value of 2 in each of these variables.

	// Various turf and door types used when generating the turbolift floors.
	var/wall_type = /turf/simulated/wall/elevator
	var/floor_type = /turf/simulated/floor/tiled/dark
	var/door_type = /obj/machinery/door/airlock/lift

	var/list/areas_to_use = list()

/obj/turbolift_map_holder/Destroy()
	turbolifts -= src
	return ..()

/obj/turbolift_map_holder/Initialize(mapload)
	..()
	turbolifts += src
	return INITIALIZE_HINT_LATELOAD

/obj/turbolift_map_holder/LateInitialize()
	. = ..()
	// Create our system controller.
	var/datum/turbolift/lift = new()

	// Holder values since we're moving this object to null ASAP.
	var/ux = x
	var/uy = y
	var/uz = z
	var/udir = dir
	moveToNullspace()

	// These modifiers are used in relation to the origin
	// to place the system control panels and doors.
	var/make_walls = isnull(wall_type) ? FALSE : TRUE	//VOREStation addition: Wall-less elevator
	var/int_panel_x
	var/int_panel_y
	var/ext_panel_x
	var/ext_panel_y
	var/door_x1
	var/door_y1
	var/door_x2
	var/door_y2
	var/light_x1
	var/light_x2
	var/light_y1
	var/light_y2

	var/az = 1
	var/ex = (ux+lift_size_x)
	var/ey = (uy+lift_size_y)
	var/ez = (uz+(depth-1))

	switch(dir)

		if(NORTH)

			int_panel_x = ux + FLOOR(lift_size_x/2, 1)
			int_panel_y = uy + (make_walls ? 1 : 0)	//VOREStation edit: Wall-less elevator
			ext_panel_x = ux
			ext_panel_y = ey + 2

			door_x1 = ux + 1
			door_y1 = ey + (make_walls ? 0 : 1)	//VOREStation edit: Wall-less elevator
			door_x2 = ex - 1
			door_y2 = ey + 1

			light_x1 = ux + (make_walls ? 1 : 0)	//VOREStation edit: Wall-less elevator
			light_y1 = uy + (make_walls ? 1 : 0)	//VOREStation edit: Wall-less elevator
			light_x2 = ux + lift_size_x - (make_walls ? 1 : 0)	//VOREStation edit: Wall-less elevator
			light_y2 = uy + (make_walls ? 1 : 0)	//VOREStation edit: Wall-less elevator

		if(SOUTH)

			int_panel_x = ux + FLOOR(lift_size_x/2, 1)
			int_panel_y = ey - (make_walls ? 1 : 0)	//VOREStation edit: Wall-less elevator
			ext_panel_x = ex
			ext_panel_y = uy - 2

			door_x1 = ux + 1
			door_y1 = uy - 1
			door_x2 = ex - 1
			door_y2 = uy - (make_walls ? 0 : 1)	//VOREStation edit: Wall-less elevator

			light_x1 = ux + (make_walls ? 1 : 0)	//VOREStation edit: Wall-less elevator
			light_y1 = uy + (make_walls ? 2 : 1)	//VOREStation edit: Wall-less elevator
			light_x2 = ux + lift_size_x - (make_walls ? 1 : 0)	//VOREStation edit: Wall-less elevator
			light_y2 = uy + lift_size_y - (make_walls ? 1 : 0)	//VOREStation edit: Wall-less elevator

		if(EAST)

			int_panel_x = ux+(make_walls ? 1 : 0)	//VOREStation edit: Wall-less elevator
			int_panel_y = uy + FLOOR(lift_size_y/2, 1)
			ext_panel_x = ex+2
			ext_panel_y = ey

			door_x1 = ex + (make_walls ? 0 : 1)	//VOREStation edit: Wall-less elevator
			door_y1 = uy + 1
			door_x2 = ex + 1
			door_y2 = ey - 1

			light_x1 = ux + (make_walls ? 1 : 0)	//VOREStation edit: Wall-less elevator
			light_y1 = uy + (make_walls ? 1 : 0)	//VOREStation edit: Wall-less elevator
			light_x2 = ux + (make_walls ? 1 : 0)	//VOREStation edit: Wall-less elevator
			light_y2 = uy + lift_size_x - (make_walls ? 1 : 0)	//VOREStation edit: Wall-less elevator

		if(WEST)

			int_panel_x = ex-(make_walls ? 1 : 0)	//VOREStation edit: Wall-less elevator
			int_panel_y = uy + FLOOR(lift_size_y/2, 1)
			ext_panel_x = ux-2
			ext_panel_y = uy

			door_x1 = ux - 1
			door_y1 = uy + 1
			door_x2 = ux - (make_walls ? 0 : 1)	//VOREStation edit: Wall-less elevator
			door_y2 = ey - 1

			light_x1 = ux + lift_size_x - (make_walls ? 1 : 0)	//VOREStation edit: Wall-less elevator
			light_y1 = uy + (make_walls ? 1 : 0)	//VOREStation edit: Wall-less elevator
			light_x2 = ux + lift_size_x - (make_walls ? 1 : 0)	//VOREStation edit: Wall-less elevator
			light_y2 = uy + lift_size_y - (make_walls ? 1 : 0)	//VOREStation edit: Wall-less elevator

	// Generate each floor and store it in the controller datum.
	for(var/cz = uz;cz<=ez;cz++)

		var/datum/turbolift_floor/cfloor = new()
		lift.floors += cfloor

		var/list/floor_turfs = list()
		// Update the appropriate turfs.
		for(var/tx = ux to ex)
			for(var/ty = uy to ey)

				var/turf/checking = locate(tx,ty,cz)

				if(!istype(checking))
					log_debug("[name] cannot find a component turf at [tx],[ty] on floor [cz]. Aborting.")
					qdel(src)
					return

				// Update path appropriately if needed.
				var/swap_to = /turf/simulated/open
				if(cz == uz)                                                                       // Elevator.
					if(wall_type && (tx == ux || ty == uy || tx == ex || ty == ey) && !(tx >= door_x1 && tx <= door_x2 && ty >= door_y1 && ty <= door_y2))	//VOREStation edit: Wall-less elevator
						swap_to = wall_type
					else
						swap_to = floor_type

				if(checking.type != swap_to)
					checking.ChangeTurf(swap_to)
					// Let's make absolutely sure that we have the right turf.
					checking = locate(tx,ty,cz)

				// Clear out contents.
				for(var/atom/movable/thing in checking.contents)
					if(thing.simulated)
						qdel(thing)

				if(tx >= ux && tx <= ex && ty >= uy && ty <= ey)
					floor_turfs += checking

		// Place exterior doors.
		for(var/tx = door_x1 to door_x2)
			for(var/ty = door_y1 to door_y2)
				var/turf/checking = locate(tx,ty,cz)
				var/internal = 1
				if(!(checking in floor_turfs))
					internal = 0
					if(checking.type != floor_type)
						checking.ChangeTurf(floor_type)
						checking = locate(tx,ty,cz)
					for(var/atom/movable/thing in checking.contents)
						if(thing.simulated)
							qdel(thing)
				if(checking.type == floor_type) // Don't build over empty space on lower levels.
					var/obj/machinery/door/airlock/lift/newdoor = new door_type(checking)
					if(internal)
						lift.doors += newdoor
						newdoor.lift = cfloor
					else
						cfloor.doors += newdoor
						newdoor.floor = cfloor

		// Place exterior control panel.
		var/turf/placing = locate(ext_panel_x, ext_panel_y, cz)
		var/obj/structure/lift/button/panel_ext = new(placing, lift)
		panel_ext.floor = cfloor
		panel_ext.set_dir(udir)
		cfloor.ext_panel = panel_ext

		// Place lights
		var/turf/placing1 = locate(light_x1, light_y1, cz)
		var/turf/placing2 = locate(light_x2, light_y2, cz)
		var/obj/machinery/light/light1 = new(placing1, light)
		var/obj/machinery/light/light2 = new(placing2, light)
		if(udir == NORTH || udir == SOUTH)
			light1.set_dir(WEST)
			light2.set_dir(EAST)
		else
			light1.set_dir(SOUTH)
			light2.set_dir(NORTH)

		// Update area.
		if(az > areas_to_use.len)
			log_debug("Insufficient defined areas in turbolift datum, aborting.")
			qdel(src)
			return

		var/area_path = areas_to_use[az]
		for(var/thing in floor_turfs)
			new area_path(thing)
		var/area/A = locate(area_path)
		cfloor.set_area_ref("\ref[A]")
		az++

	// Place lift panel.
	var/turf/T = locate(int_panel_x, int_panel_y, uz)
	lift.control_panel_interior = new(T, lift)
	lift.control_panel_interior.set_dir(udir)
	lift.current_floor = lift.floors[1]

	lift.open_doors()

	qdel(src) // We're done.
