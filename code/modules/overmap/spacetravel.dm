//Space stragglers go here
/obj/effect/overmap/visitable/sector/temporary
	name = "Deep Space"
	invisibility = 101
	known = FALSE
	in_space = TRUE

/obj/effect/overmap/visitable/sector/temporary/Initialize()
	if(!istype(loc, /turf/unsimulated/map))
		CRASH("Attempt to create deepspace which is not on overmap: [log_info_line(loc)]")
	// Tell sector initializer where are is where we want to be.
	start_x = loc.x
	start_y = loc.y
	// But pick an empty z level to use
	map_z += global.using_map.get_empty_zlevel()
	. = ..()
	if(!map_z[1])
		log_and_message_admins("Could not create empty sector at [x], [y]. No available z levels to allocate.")
		return INITIALIZE_HINT_QDEL
	testing("Temporary sector at [x],[y],[z] was created, corresponding zlevel is [english_list(map_z)].")

/obj/effect/overmap/visitable/sector/temporary/Destroy()
	for(var/zlevel in map_z)
		using_map.cache_empty_zlevel(zlevel)
	testing("Temporary sector at [x],[y] was destroyed, returning empty zlevel [map_z[1]] to map datum.")
	return ..()

/obj/effect/overmap/visitable/sector/temporary/find_z_levels()
	LAZYADD(map_z, global.using_map.get_empty_zlevel())

/obj/effect/overmap/visitable/sector/temporary/proc/is_empty(var/mob/observer)
	if(!LAZYLEN(map_z))
		log_and_message_admins("CANARY: [src] tried to check is_empty, but map_z is `[map_z || "null"]`")
		return TRUE
	testing("Checking if sector at [map_z[1]] has no players.")
	for(var/mob/M in global.player_list)
		if(M != observer && (M.z in map_z))
			testing("There are people on it.")
			return FALSE
	return TRUE

/obj/effect/overmap/visitable/sector/temporary/cleanup()
	if(is_empty())
		qdel(src)

/proc/get_deepspace(x,y)
	var/turf/unsimulated/map/overmap_turf = locate(x,y,global.using_map.overmap_z)
	if(!istype(overmap_turf))
		CRASH("Attempt to get deepspace at ([x],[y]) which is not on overmap: [overmap_turf]")
	var/obj/effect/overmap/visitable/sector/temporary/res = locate() in overmap_turf
	if(istype(res))
		return res
	res = new /obj/effect/overmap/visitable/sector/temporary(overmap_turf)
	if(QDELETED(res))
		res = null
	return res

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
	if(!istype(TM))
		TM = get_deepspace(M.x,M.y)
	if(!istype(TM))
		return
	nz = pick(TM.get_space_zlevels())

	testing("spacetravel chose [nz],[ny],[nz] in sector [TM] @ ([TM.x],[TM.y],[TM.z])")

	var/turf/dest = locate(nx,ny,nz)
	if(istype(dest))
		A.forceMove(dest)
		if(ismob(A))
			var/mob/D = A
			if(D.pulling)
				D.pulling.forceMove(dest)
	else
		to_world("CANARY: Could not move [A] to [nx], [ny], [nz]: [dest ? "[dest]" : "null"]")

	M.cleanup()
