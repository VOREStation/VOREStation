/obj/random
	name = "random object"
	desc = "This item type is used to spawn random objects at round-start"
	icon = 'icons/misc/random_spawners.dmi'
	icon_state = "generic"
	var/spawn_nothing_percentage = 0 // this variable determines the likelyhood that this random object will not spawn anything
	var/drop_get_turf = TRUE


/obj/random/Initialize(mapload)
	. = INITIALIZE_HINT_QDEL
	..()
	if (prob(spawn_nothing_percentage))
		return
	try_spawn_item()


/obj/random/proc/try_spawn_item()
	var/atom/result = spawn_item()
	if(istype(result) && !QDELETED(result))
		apply_adjustments(result)
	else if(islist(result))
		for(var/atom/A in result)
			if(!QDELETED(A))
				apply_adjustments(A)

// this function should return a specific item to spawn
/obj/random/proc/item_to_spawn()
	return

/obj/random/proc/apply_adjustments(atom/A)
	if(istype(A))
		A.pixel_x = pixel_x
		A.pixel_y = pixel_y
		A.set_dir(dir)

/obj/random/drop_location()
	return drop_get_turf ? get_turf(src) : ..()

// creates the random item
/obj/random/proc/spawn_item()
	var/build_path = item_to_spawn()
	return new build_path(drop_location())

/proc/get_random_useful_type()
	if(!LAZYLEN(GLOB.random_useful_))
		GLOB.random_useful_ = subtypesof(/obj/item/pen/crayon)
		GLOB.random_useful_ += /obj/item/pen
		GLOB.random_useful_ += /obj/item/pen/blue
		GLOB.random_useful_ += /obj/item/pen/red
		GLOB.random_useful_ += /obj/item/pen/multi
		GLOB.random_useful_ += /obj/item/storage/box/matches
		GLOB.random_useful_ += /obj/item/stack/material/cardboard
	return pick(GLOB.random_useful_)

/proc/get_random_junk_type()
	if(prob(20)) // Misc. clutter
		return /obj/effect/decal/cleanable/generic
	if(prob(70)) // Misc. junk
		if(!LAZYLEN(GLOB.random_junk_))
			GLOB.random_junk_ = subtypesof(/obj/item/trash)
			GLOB.random_junk_ += /obj/effect/decal/cleanable/bug_remains
			GLOB.random_junk_ += /obj/effect/decal/remains/mouse
			GLOB.random_junk_ += /obj/effect/decal/remains/robot
			GLOB.random_junk_ += /obj/item/paper/crumpled
			GLOB.random_junk_ += /obj/item/inflatable/torn
			GLOB.random_junk_ += /obj/effect/decal/cleanable/molten_item
			GLOB.random_junk_ += /obj/item/material/shard

			GLOB.random_junk_ -= /obj/item/trash/plate
			GLOB.random_junk_ -= /obj/item/trash/snack_bowl
			GLOB.random_junk_ -= /obj/item/trash/syndi_cakes
			GLOB.random_junk_ -= /obj/item/trash/tray
		return pick(GLOB.random_junk_)
	// Misc. actually useful stuff
	return get_random_useful_type()

/////////////////////////////////////////////////////////////////////////

/obj/random/single
	name = "randomly spawned object"
	desc = "This item type is used to randomly spawn a given object at round-start"
	icon_state = "generic"
	var/spawn_object = null

/obj/random/single/item_to_spawn()
	return ispath(spawn_object) ? spawn_object : text2path(spawn_object)

//Multiple Object Spawn

/obj/random/multiple

/obj/random/multiple/spawn_item()
	var/list/things_to_make = item_to_spawn()
	for(var/new_type in things_to_make)
		LAZYADD(., new new_type(src.loc))

/*
//	Multi Point Spawn
//	Selects one spawn point out of a group of points with the same ID and asks it to generate its items
*/
var/list/multi_point_spawns

/obj/random_multi
	name = "random object spawn point"
	desc = "This item type is used to spawn random objects at round-start. Only one spawn point for a given group id is selected."
	icon = 'icons/misc/random_spawners.dmi'
	icon_state = "generic_3"
	invisibility = INVISIBILITY_MAXIMUM
	var/id     // Group id
	var/weight // Probability weight for this spawn point

/obj/random_multi/Initialize(mapload)
	. = ..()
	weight = max(1, round(weight))

	if(!multi_point_spawns)
		multi_point_spawns = list()
	var/list/spawnpoints = multi_point_spawns[id]
	if(!spawnpoints)
		spawnpoints = list()
		multi_point_spawns[id] = spawnpoints
	spawnpoints[src] = weight

/obj/random_multi/Destroy()
	var/list/spawnpoints = multi_point_spawns[id]
	spawnpoints -= src
	if(!spawnpoints.len)
		multi_point_spawns -= id
	. = ..()

/obj/random_multi/proc/generate_items()
	return

/obj/random_multi/single_item
	var/item_path  // Item type to spawn

/obj/random_multi/single_item/generate_items()
	new item_path(loc)

/hook/roundstart/proc/generate_multi_spawn_items()
	for(var/id in multi_point_spawns)
		var/list/spawn_points = multi_point_spawns[id]
		var/obj/random_multi/rm = pickweight(spawn_points)
		rm.generate_items()
		for(var/entry in spawn_points)
			qdel(entry)
	return 1
