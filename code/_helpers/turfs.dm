// Returns the atom sitting on the turf.
// For example, using this on a disk, which is in a bag, on a mob, will return the mob because it's on the turf.
/proc/get_atom_on_turf(var/atom/movable/M)
	var/atom/mloc = M
	while(mloc && mloc.loc && !istype(mloc.loc, /turf/))
		mloc = mloc.loc
	return mloc

/proc/iswall(turf/T)
	return (istype(T, /turf/simulated/wall) || istype(T, /turf/unsimulated/wall) || istype(T, /turf/simulated/shuttle/wall))

/proc/isfloor(turf/T)
	return (istype(T, /turf/simulated/floor) || istype(T, /turf/unsimulated/floor) || istype(T, /turf/simulated/shuttle/floor))

/proc/turf_clear(turf/T)
	for(var/atom/A in T)
		if(A.simulated)
			return 0
	return 1

// Picks a turf without a mob from the given list of turfs, if one exists.
// If no such turf exists, picks any random turf from the given list of turfs.
/proc/pick_mobless_turf_if_exists(var/list/start_turfs)
	if(!start_turfs.len)
		return null

	var/list/available_turfs = list()
	for(var/start_turf in start_turfs)
		var/mob/M = locate() in start_turf
		if(!M)
			available_turfs += start_turf
	if(!available_turfs.len)
		available_turfs = start_turfs
	return pick(available_turfs)

// Picks a turf that is clearance tiles away from the map edge given by dir, on z-level Z
/proc/pick_random_edge_turf(var/dir, var/Z, var/clearance = TRANSITIONEDGE + 1)
	if(!dir)
		return
	switch(dir)
		if(NORTH)
			return locate(rand(clearance, world.maxx - clearance), world.maxy - clearance, Z)
		if(SOUTH)
			return locate(rand(clearance, world.maxx - clearance), clearance, Z)
		if(EAST)
			return locate(world.maxx - clearance, rand(clearance, world.maxy - clearance), Z)
		if(WEST)
			return locate(clearance, rand(clearance, world.maxy - clearance), Z)

/proc/is_below_sound_pressure(var/turf/T)
	var/datum/gas_mixture/environment = T ? T.return_air() : null
	var/pressure =  environment ? environment.return_pressure() : 0
	if(pressure < SOUND_MINIMUM_PRESSURE)
		return TRUE
	return FALSE

/*
	Turf manipulation
*/

//Returns an assoc list that describes how turfs would be changed if the
//turfs in turfs_src were translated by shifting the src_origin to the dst_origin
/proc/get_turf_translation(turf/src_origin, turf/dst_origin, list/turfs_src)
	var/list/turf_map = list()
	for(var/turf/source in turfs_src)
		var/x_pos = (source.x - src_origin.x)
		var/y_pos = (source.y - src_origin.y)
		var/z_pos = (source.z - src_origin.z)

		var/turf/target = locate(dst_origin.x + x_pos, dst_origin.y + y_pos, dst_origin.z + z_pos)
		if(!target)
			error("Null turf in translation @ ([dst_origin.x + x_pos], [dst_origin.y + y_pos], [dst_origin.z + z_pos])")
		turf_map[source] = target //if target is null, preserve that information in the turf map

	return turf_map

/proc/translate_turfs(var/list/translation, var/area/base_area = null, var/turf/base_turf)
	for(var/turf/source in translation)

		var/turf/target = translation[source]

		if(target)
			if(base_area) ChangeArea(target, get_area(source))
			var/leave_turf = base_turf ? base_turf : get_base_turf_by_area(base_area ? base_area : source)
			translate_turf(source, target, leave_turf)
			if(base_area) ChangeArea(source, base_area)

	//change the old turfs (Currently done by translate_turf for us)
	//for(var/turf/source in translation)
	//	source.ChangeTurf(base_turf ? base_turf : get_base_turf_by_area(source), 1, 1)

// Parmaters for stupid historical reasons are:
// T - Origin
// B - Destination
/proc/translate_turf(var/turf/T, var/turf/B, var/turftoleave = null)

	//You can stay, though.
	if(istype(T,/turf/space))
		error("Tried to translate a space turf: src=[log_info_line(T)] dst=[log_info_line(B)]")
		return FALSE // TODO - Is this really okay to do nothing?

	var/turf/X //New Destination Turf

	//Are we doing shuttlework? Just to save another type check later.
	var/shuttlework = 0

	T.pre_translate_A(B)
	B.pre_translate_B(T)

	//Shuttle turfs handle their own fancy moving.
	if(istype(T,/turf/simulated/shuttle))
		shuttlework = 1
		var/turf/simulated/shuttle/SS = T
		if(!SS.landed_holder) SS.landed_holder = new(SS)
		X = SS.landed_holder.land_on(B)

	//Generic non-shuttle turf move.
	else
		var/old_dir1 = T.dir
		var/old_icon_state1 = T.icon_state
		var/old_icon1 = T.icon
		var/old_decals = T.decals ? T.decals.Copy() : null

		B.Destroy()
		X = B.ChangeTurf(T.type)
		X.set_dir(old_dir1)
		X.icon_state = old_icon_state1
		X.icon = old_icon1
		X.copy_overlays(T, TRUE)
		X.decals = old_decals

	//Move the air from source to dest
	var/turf/simulated/ST = T
	if(istype(ST) && ST.zone)
		var/turf/simulated/SX = X
		if(!SX.air)
			SX.make_air()
		SX.air.copy_from(ST.zone.air)
		ST.zone.remove(ST)

	var/z_level_change = FALSE
	if(T.z != X.z)
		z_level_change = TRUE

	//Move the objects. Not forceMove because the object isn't "moving" really, it's supposed to be on the "same" turf.
	for(var/obj/O in T)
		if(O.simulated)
			O.loc = X
			O.update_light()
			if(z_level_change) // The objects still need to know if their z-level changed.
				O.onTransitZ(T.z, X.z)

	//Move the mobs unless it's an AI eye or other eye type.
	for(var/mob/M in T)
		if(isEye(M)) continue // If we need to check for more mobs, I'll add a variable
		M.loc = X

		if(z_level_change) // Same goes for mobs.
			M.onTransitZ(T.z, X.z)

	if(shuttlework)
		var/turf/simulated/shuttle/SS = T
		SS.landed_holder.leave_turf(turftoleave)
	else if(turftoleave)
		T.ChangeTurf(turftoleave)
	else
		T.ChangeTurf(get_base_turf_by_area(T))

	T.post_translate_A(B)
	B.post_translate_B(T)

	return TRUE

//Used for border objects. This returns true if this atom is on the border between the two specified turfs
//This assumes that the atom is located inside the target turf
/atom/proc/is_between_turfs(var/turf/origin, var/turf/target)
	if (flags & ON_BORDER)
		var/testdir = get_dir(target, origin)
		return (dir & testdir)
	return TRUE
