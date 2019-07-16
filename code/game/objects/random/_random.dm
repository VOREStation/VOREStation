/obj/random
	name = "random object"
	desc = "This item type is used to spawn random objects at round-start"
	icon = 'icons/misc/mark.dmi'
	icon_state = "rup"
	var/spawn_nothing_percentage = 0 // this variable determines the likelyhood that this random object will not spawn anything
	var/drop_get_turf = TRUE

// creates a new object and deletes itself
/obj/random/Initialize()
	. = ..()
	if (!prob(spawn_nothing_percentage))
		spawn_item()
	Random_SafeDestroy(0)

// This function should, theoretically, guarantee the deletion of the random object. Not all of them destroy themselves for some reason, especially if created through non-standard means.
/obj/random/proc/Random_SafeDestroy(var/recursion_level)
	set waitfor = FALSE
	sleep(30)
	qdel(src)
	if(src && recursion_level < 5)
		Random_SafeDestroy(recursion_level + 1)

// this function should return a specific item to spawn
/obj/random/proc/item_to_spawn()
	return 0

/obj/random/drop_location()
	return drop_get_turf? get_turf(src) : ..()

// creates the random item
/obj/random/proc/spawn_item()
	var/build_path = item_to_spawn()

	var/atom/A = new build_path(drop_location())
	if(pixel_x || pixel_y)
		A.pixel_x = pixel_x
		A.pixel_y = pixel_y

var/list/random_junk_
var/list/random_useful_
/proc/get_random_useful_type()
	if(!random_useful_)
		random_useful_ = subtypesof(/obj/item/weapon/pen/crayon)
		random_useful_ += /obj/item/weapon/pen
		random_useful_ += /obj/item/weapon/pen/blue
		random_useful_ += /obj/item/weapon/pen/red
		random_useful_ += /obj/item/weapon/pen/multi
		random_useful_ += /obj/item/weapon/storage/box/matches
		random_useful_ += /obj/item/stack/material/cardboard
	return pick(random_useful_)

/proc/get_random_junk_type()
	if(prob(20)) // Misc. clutter
		return /obj/effect/decal/cleanable/generic
	if(prob(70)) // Misc. junk
		if(!random_junk_)
			random_junk_ = subtypesof(/obj/item/trash)
			random_junk_ += typesof(/obj/item/weapon/cigbutt)
			random_junk_ += /obj/effect/decal/cleanable/spiderling_remains
			random_junk_ += /obj/effect/decal/remains/mouse
			random_junk_ += /obj/effect/decal/remains/robot
			random_junk_ += /obj/item/weapon/paper/crumpled
			random_junk_ += /obj/item/inflatable/torn
			random_junk_ += /obj/effect/decal/cleanable/molten_item
			random_junk_ += /obj/item/weapon/material/shard

			random_junk_ -= /obj/item/trash/plate
			random_junk_ -= /obj/item/trash/snack_bowl
			random_junk_ -= /obj/item/trash/syndi_cakes
			random_junk_ -= /obj/item/trash/tray
		return pick(random_junk_)
	// Misc. actually useful stuff
	return get_random_useful_type()

/////////////////////////////////////////////////////////////////////////

/obj/random/single
	name = "randomly spawned object"
	desc = "This item type is used to randomly spawn a given object at round-start"
	icon_state = "x3"
	var/spawn_object = null

/obj/random/single/item_to_spawn()
	return ispath(spawn_object) ? spawn_object : text2path(spawn_object)

//Multiple Object Spawn

/obj/random/multiple

/obj/random/multiple/spawn_item()
	var/list/things_to_make = item_to_spawn()
	for(var/new_type in things_to_make)
		new new_type(src.loc)

/*
//	Multi Point Spawn
//	Selects one spawn point out of a group of points with the same ID and asks it to generate its items
*/
var/list/multi_point_spawns

/obj/random_multi
	name = "random object spawn point"
	desc = "This item type is used to spawn random objects at round-start. Only one spawn point for a given group id is selected."
	icon = 'icons/misc/mark.dmi'
	icon_state = "x3"
	invisibility = INVISIBILITY_MAXIMUM
	var/id     // Group id
	var/weight // Probability weight for this spawn point

/obj/random_multi/Initialize()
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