//Space stragglers go here
/obj/effect/overmap/visitable/sector/temporary
	name = "Deep Space"
	invisibility = 101
	known = FALSE
	in_space = TRUE

/obj/effect/overmap/visitable/sector/temporary/New(var/nx, var/ny)
	loc = locate(nx, ny, global.using_map.overmap_z)
	x = nx
	y = ny
	var/emptyz = global.using_map.get_empty_zlevel()
	map_z += emptyz
	map_sectors["[emptyz]"] = src
	testing("Temporary sector at [x],[y] was created, corresponding zlevel is [emptyz].")

/obj/effect/overmap/visitable/sector/temporary/Destroy()
	for(var/zlevel in map_z)
		using_map.cache_empty_zlevel(zlevel)
	testing("Temporary sector at [x],[y] was destroyed, returning empty zlevel [map_z[1]] to map datum.")
	return ..()

/obj/effect/overmap/visitable/sector/temporary/proc/can_die(var/mob/observer)
	testing("Checking if sector at [map_z[1]] can die.")
	for(var/mob/M in global.player_list)
		if(M != observer && (M.z in map_z))
			testing("There are people on it.")
			return 0
	return 1

/obj/effect/overmap/visitable/sector/temporary/cleanup()
	if(can_die())
		qdel(src)

/proc/get_deepspace(x,y)
	var/turf/unsimulated/map/overmap_turf = locate(x,y,global.using_map.overmap_z)
	if(!istype(overmap_turf))
		CRASH("Attempt to get deepspace at ([x],[y]) which is not on overmap: [overmap_turf]")
	var/obj/effect/overmap/visitable/sector/temporary/res = locate() in overmap_turf
	if(istype(res))
		return res
	return new /obj/effect/overmap/visitable/sector/temporary(x, y)

/atom/movable/proc/lost_in_space()
	for(var/atom/movable/AM in contents)
		if(!AM.lost_in_space())
			return FALSE
	if(has_buckled_mobs())
		for(var/mob/M in buckled_mobs)
			if(!M.lost_in_space())
				return FALSE

	return TRUE

/obj/item/device/uav/lost_in_space()
	if(state == 1)
		return FALSE
	return ..()

/obj/machinery/power/supermatter/lost_in_space()
	return FALSE

/obj/singularity/lost_in_space()
	return FALSE

/obj/vehicle/lost_in_space()
	if(load && !load.lost_in_space())
		return FALSE
	return ..()

/mob/lost_in_space()
	return isnull(client)

/mob/living/carbon/human/lost_in_space()
	return FALSE
	// return isnull(client) && !key && stat == DEAD // Allows bodies that players have ghosted from to be deleted - Ater

/proc/overmap_spacetravel(var/turf/space/T, var/atom/movable/A)
	if (!T || !A)
		return

	var/obj/effect/overmap/visitable/M = get_overmap_sector(T.z)
	if (!M)
		return

	// Is the landmark still on the map.
	if(!isturf(M.loc))
		return

	// Don't let AI eyes yeet themselves off the map
	if(istype(A, /mob/observer/eye))
		return

	if(A.lost_in_space())
		if(!QDELETED(A))
			qdel(A)
		return


	var/nx = 1
	var/ny = 1
	var/nz = 1

	if(T.x <= TRANSITIONEDGE)
		nx = world.maxx - TRANSITIONEDGE - 2
		ny = rand(TRANSITIONEDGE + 2, world.maxy - TRANSITIONEDGE - 2)

	else if (A.x >= (world.maxx - TRANSITIONEDGE - 1))
		nx = TRANSITIONEDGE + 2
		ny = rand(TRANSITIONEDGE + 2, world.maxy - TRANSITIONEDGE - 2)

	else if (T.y <= TRANSITIONEDGE)
		ny = world.maxy - TRANSITIONEDGE -2
		nx = rand(TRANSITIONEDGE + 2, world.maxx - TRANSITIONEDGE - 2)

	else if (A.y >= (world.maxy - TRANSITIONEDGE - 1))
		ny = TRANSITIONEDGE + 2
		nx = rand(TRANSITIONEDGE + 2, world.maxx - TRANSITIONEDGE - 2)

	testing("[A] spacemoving from [M] ([M.x], [M.y]).")

	var/turf/map = locate(M.x,M.y,global.using_map.overmap_z)
	var/obj/effect/overmap/visitable/TM
	for(var/obj/effect/overmap/visitable/O in map)
		if(O != M && O.in_space && prob(50))
			TM = O
			break
	if(!TM)
		TM = get_deepspace(M.x,M.y)
	nz = pick(TM.get_space_zlevels())

	var/turf/dest = locate(nx,ny,nz)
	if(istype(dest))
		A.forceMove(dest)
		if(ismob(A))
			var/mob/D = A
			if(D.pulling)
				D.pulling.forceMove(dest)

	M.cleanup()
