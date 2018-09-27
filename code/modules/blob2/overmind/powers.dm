/mob/observer/blob/proc/can_buy(cost = 15)
	if(blob_points < cost)
		to_chat(src, "<span class='warning'>You cannot afford this, you need at least [cost] resources!</span>")
		return FALSE
	add_points(-cost)
	return TRUE

/mob/observer/blob/verb/transport_core()
	set category = "Blob"
	set name = "Jump to Core"
	set desc = "Move your camera to your core."

	if(blob_core)
		forceMove(blob_core.loc)

/mob/observer/blob/proc/createSpecial(price, blobType, nearEquals, needsNode, turf/T)
	if(!T)
		T = get_turf(src)
	var/obj/structure/blob/B = (locate(/obj/structure/blob) in T)

	if(!B)
		to_chat(src, "<span class='warning'>There is no blob here!</span>")
		return

	if(!istype(B, /obj/structure/blob/normal))
		to_chat(src, "<span class='warning'>Unable to use this blob, find a normal one.</span>")
		return

	if(nearEquals)
		for(var/obj/structure/blob/L in orange(nearEquals, T))
			if(L.type == blobType)
				to_chat(src, "<span class='warning'>There is a similar blob nearby, move more than [nearEquals] tiles away from it!</span>")
				return

	if(!can_buy(price))
		return

	var/obj/structure/blob/N = B.change_to(blobType, src)
	return N

/mob/observer/blob/verb/create_shield_power()
	set category = "Blob"
	set name = "Create Shield Blob (15)"
	set desc = "Create a shield blob, which is hard to kill."
	create_shield()

/mob/observer/blob/proc/create_shield(turf/T)
	createSpecial(15, blob_type.shield_type, 0, 0, T)

/mob/observer/blob/verb/create_resource()
	set category = "Blob"
	set name = "Create Resource Blob (40)"
	set desc = "Create a resource tower which will generate resources for you."

	if(!blob_type.can_build_resources)
		return FALSE

	createSpecial(40, blob_type.resource_type, 4, 1)

/mob/observer/blob/verb/auto_resource()
	set category = "Blob"
	set name = "Auto Resource Blob (40)"
	set desc = "Automatically places a resource tower near a node or your core, at a sufficent distance."

	if(!blob_type.can_build_resources)
		return FALSE

	var/obj/structure/blob/B = null
	var/list/potential_blobs = blobs.Copy()
	while(potential_blobs.len)
		var/obj/structure/blob/temp = pick(potential_blobs)
		if(!(locate(/obj/structure/blob/node) in range(temp, BLOB_NODE_PULSE_RANGE) ) && !(locate(/obj/structure/blob/core) in range(temp, BLOB_CORE_PULSE_RANGE) ))
			potential_blobs -= temp // Can't be pulsed.
		else if(locate(/obj/structure/blob/resource) in range(temp, 4) )
			potential_blobs -= temp // Too close to another resource blob.
		else if(locate(/obj/structure/blob/core) in range(temp, 1) )
			potential_blobs -= temp // Don't take up the core's shield spot.
		else if(!istype(temp, /obj/structure/blob/normal))
			potential_blobs -= temp // Not a normal blob.
		else
			B = temp
			break

		CHECK_TICK // Iterating over a list containing hundreds of blobs can get taxing.

	if(B)
		forceMove(B.loc)
		return createSpecial(40, blob_type.resource_type, 4, 1, B.loc)


/mob/observer/blob/verb/create_factory()
	set category = "Blob"
	set name = "Create Factory Blob (60)"
	set desc = "Create a spore tower that will spawn spores to harass your enemies."

	if(!blob_type.can_build_factories)
		return FALSE

	createSpecial(60, blob_type.factory_type, 7, 1)

/mob/observer/blob/verb/auto_factory()
	set category = "Blob"
	set name = "Auto Factory Blob (60)"
	set desc = "Automatically places a resource tower near a node or your core, at a sufficent distance."

	if(!blob_type.can_build_factories)
		return FALSE

	var/obj/structure/blob/B = null
	var/list/potential_blobs = blobs.Copy()
	while(potential_blobs.len)
		var/obj/structure/blob/temp = pick(potential_blobs)
		if(!(locate(/obj/structure/blob/node) in range(temp, BLOB_NODE_PULSE_RANGE) ) && !(locate(/obj/structure/blob/core) in range(temp, BLOB_CORE_PULSE_RANGE) ))
			potential_blobs -= temp // Can't be pulsed.
		else if(locate(/obj/structure/blob/factory) in range(temp, 7) )
			potential_blobs -= temp // Too close to another factory blob.
		else if(locate(/obj/structure/blob/core) in range(temp, 1) )
			potential_blobs -= temp // Don't take up the core's shield spot.
		else if(!istype(temp, /obj/structure/blob/normal))
			potential_blobs -= temp // Not a normal blob.
		else
			B = temp
			break

		CHECK_TICK

	if(B)
		forceMove(B.loc)
		return createSpecial(60, blob_type.factory_type, 7, 1, B.loc)



/mob/observer/blob/verb/create_node()
	set category = "Blob"
	set name = "Create Node Blob (100)"
	set desc = "Create a node, which will expand blobs around it, and power nearby factory and resource blobs."

	if(!blob_type.can_build_nodes)
		return FALSE

	createSpecial(100, blob_type.node_type, 5, 0)

/mob/observer/blob/verb/auto_node()
	set category = "Blob"
	set name = "Auto Node Blob (100)"
	set desc = "Automatically places a node blob at a sufficent distance."

	if(!blob_type.can_build_nodes)
		return FALSE

	var/obj/structure/blob/B = null
	var/list/potential_blobs = blobs.Copy()
	while(potential_blobs.len)
		var/obj/structure/blob/temp = pick(potential_blobs)
		if(locate(/obj/structure/blob/node) in range(temp, 5) )
			potential_blobs -= temp
		else if(locate(/obj/structure/blob/core) in range(temp, 5) )
			potential_blobs -= temp
		else if(!istype(temp, /obj/structure/blob/normal))
			potential_blobs -= temp
		else
			B = temp
			break

		CHECK_TICK

	if(B)
		forceMove(B.loc)
		return createSpecial(100, blob_type.node_type, 5, 0, B.loc)



/mob/observer/blob/verb/expand_blob_power()
	set category = "Blob"
	set name = "Expand/Attack Blob (4)"
	set desc = "Attempts to create a new blob in this tile. If the tile isn't clear, instead attacks it, damaging mobs and objects."
	var/turf/T = get_turf(src)
	expand_blob(T)

/mob/observer/blob/proc/expand_blob(turf/T)
	var/obj/structure/blob/B = null
	var/turf/other_T = null
	for(var/direction in cardinal)
		other_T = get_step(T, direction)
		if(other_T)
			B = locate(/obj/structure/blob) in other_T
			if(B)
				break

	if(!B)
		to_chat(src, "<span class='warning'>There is no blob cardinally adjacent to the target tile!</span>")
		return

	if(!can_buy(4))
		return

	B.expand(T)

/mob/observer/blob/verb/auto_attack()
	set category = "Blob"
	set name = "Auto Attack (4)"
	set desc = "Automatically tries to kill whatever's attacking you."

	transport_core() // In-case the overmind wandered off somewhere else.

	var/list/potential_targets = list()
	for(var/mob/living/L in view(src))
		if(L.stat == DEAD)
			continue // Already dying or dead.
		if(L.faction == "blob")
			continue // No friendly fire.
		if(locate(/obj/structure/blob) in L.loc)
			continue // Already has a blob over them.

		var/obj/structure/blob/B = null
		for(var/direction in cardinal)
			var/turf/T = get_step(L, direction)
			B = locate(/obj/structure/blob) in T
			if(B)
				break
		if(!B)
			continue

		potential_targets += L

	if(potential_targets.len)
		var/mob/living/victim = pick(potential_targets)
		var/turf/T = get_turf(victim)
		expand_blob(T)
