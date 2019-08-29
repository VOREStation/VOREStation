var/list/blob_cores = list()

/obj/structure/blob/core
	name = "blob core"
	base_name = "core"
	icon = 'icons/mob/blob.dmi'
	icon_state = "blank_blob"
	desc = "A huge, pulsating yellow mass."
	density = TRUE //bandaid fix for PolarisSS13/6173
	max_integrity = 150
	point_return = -1
	health_regen = 0 //we regen in Life() instead of when pulsed
	var/datum/blob_type/desired_blob_type = null // If this is set, the core always creates an overmind possessing this blob type.
	var/difficulty_threshold = null // Otherwise if this is set, it picks a random blob_type that is equal or lower in difficulty.
	var/core_regen = 2
	var/overmind_get_delay = 0 //we don't want to constantly try to find an overmind, this var tracks when we'll try to get an overmind again
	var/resource_delay = 0
	var/point_rate = 2
	var/ai_controlled = TRUE

// Spawn this if you want a ghost to be able to play as the blob.
/obj/structure/blob/core/player
	ai_controlled = FALSE

// Spawn these if you want a semi-random blob.
/obj/structure/blob/core/random_easy
	difficulty_threshold = BLOB_DIFFICULTY_EASY

/obj/structure/blob/core/random_medium
	difficulty_threshold = BLOB_DIFFICULTY_MEDIUM

/obj/structure/blob/core/random_hard
	difficulty_threshold = BLOB_DIFFICULTY_HARD

// Spawn these if you want a specific blob.
/obj/structure/blob/core/blazing_oil
	desired_blob_type = /datum/blob_type/blazing_oil

/obj/structure/blob/core/grey_goo
	desired_blob_type = /datum/blob_type/grey_goo

/obj/structure/blob/core/fabrication_swarm
	desired_blob_type = /datum/blob_type/fabrication_swarm

/obj/structure/blob/core/electromagnetic_web
	desired_blob_type = /datum/blob_type/electromagnetic_web

/obj/structure/blob/core/fungal_bloom
	desired_blob_type = /datum/blob_type/fungal_bloom

/obj/structure/blob/core/fulminant_organism
	desired_blob_type = /datum/blob_type/fulminant_organism

/obj/structure/blob/core/reactive_spines
	desired_blob_type = /datum/blob_type/reactive_spines

/obj/structure/blob/core/synchronous_mesh
	desired_blob_type = /datum/blob_type/synchronous_mesh

/obj/structure/blob/core/shifting_fragments
	desired_blob_type = /datum/blob_type/shifting_fragments

/obj/structure/blob/core/cryogenic_goo
	desired_blob_type = /datum/blob_type/cryogenic_goo

/obj/structure/blob/core/energized_jelly
	desired_blob_type = /datum/blob_type/energized_jelly

/obj/structure/blob/core/explosive_lattice
	desired_blob_type = /datum/blob_type/explosive_lattice

/obj/structure/blob/core/pressurized_slime
	desired_blob_type = /datum/blob_type/pressurized_slime

/obj/structure/blob/core/radioactive_ooze
	desired_blob_type = /datum/blob_type/radioactive_ooze

/obj/structure/blob/core/volatile_alluvium
	desired_blob_type = /datum/blob_type/volatile_alluvium

/obj/structure/blob/core/classic
	desired_blob_type = /datum/blob_type/classic

/obj/structure/blob/core/New(var/newloc, var/client/new_overmind = null, new_rate = 2, placed = 0)
	..(newloc)
	blob_cores += src
	START_PROCESSING(SSobj, src)
	update_icon() //so it atleast appears
	if(!placed && !overmind)
		create_overmind(new_overmind)
	if(overmind)
		update_icon()
	point_rate = new_rate

/obj/structure/blob/core/Destroy()
	blob_cores -= src
	if(overmind)
		overmind.blob_core = null
		qdel(overmind)
	overmind = null
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/structure/blob/core/update_icon()
	overlays.Cut()
	color = null
	var/mutable_appearance/blob_overlay = mutable_appearance('icons/mob/blob.dmi', "blob")
	if(overmind)
		blob_overlay.color = overmind.blob_type.color
		name = "[overmind.blob_type.name] [base_name]"
	overlays += blob_overlay
	overlays += mutable_appearance('icons/mob/blob.dmi', "blob_core_overlay")

/obj/structure/blob/core/process()
	set waitfor = FALSE
	if(QDELETED(src))
		return
	if(!overmind)
		spawn(0)
			create_overmind()
	else
		if(resource_delay <= world.time)
			resource_delay = world.time + 1 SECOND
			overmind.add_points(point_rate)
	integrity = min(max_integrity, integrity + core_regen)
//	if(overmind)
//		overmind.update_health_hud()
	pulse_area(overmind, 15, BLOB_CORE_PULSE_RANGE, BLOB_CORE_EXPAND_RANGE)
	for(var/obj/structure/blob/normal/B in range(1, src))
		if(prob(5))
			B.change_to(/obj/structure/blob/shield/core, overmind)

/obj/structure/blob/core/proc/create_overmind(client/new_overmind, override_delay)
	if(overmind_get_delay > world.time && !override_delay)
		return
	if(!ai_controlled) // Do we want a bona fide player blob?
		overmind_get_delay = world.time + 15 SECONDS //if this fails, we'll try again in 15 seconds

		if(overmind)
			qdel(overmind)


		var/client/C = null
		if(!new_overmind)
			var/datum/ghost_query/Q = new /datum/ghost_query/blob()
			var/list/winner = Q.query()
			if(winner.len)
				var/mob/observer/dead/D = winner[1]
				C = D.client

		else
			C = new_overmind

		if(C)
			if(!desired_blob_type && !isnull(difficulty_threshold))
				desired_blob_type = get_random_blob_type()
			var/mob/observer/blob/B = new(loc, TRUE, 60, desired_blob_type)
			B.key = C.key
			B.blob_core = src
			src.overmind = B
			update_icon()
			if(B.mind && !B.mind.special_role)
				B.mind.special_role = "Blob Overmind"
			return TRUE
		return FALSE

	else // An AI opponent.
		if(!desired_blob_type && !isnull(difficulty_threshold))
			desired_blob_type = get_random_blob_type()
		var/mob/observer/blob/B = new(loc, TRUE, 60, desired_blob_type)
		overmind = B
		B.blob_core = src
		B.ai_controlled = TRUE
		update_icon()
		return TRUE

/obj/structure/blob/core/proc/get_random_blob_type()
	if(!difficulty_threshold)
		return
	var/list/valid_types = list()
	for(var/thing in subtypesof(/datum/blob_type))
		var/datum/blob_type/BT = thing
		if(initial(BT.difficulty) > difficulty_threshold)
			continue
		valid_types += BT
	return pick(valid_types)