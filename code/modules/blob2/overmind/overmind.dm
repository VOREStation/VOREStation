var/list/overminds = list()

/mob/observer/blob
	name = "Blob Overmind"
	real_name = "Blob Overmind"
	desc = "The overmind. It controls the blob."
	icon = 'icons/mob/blob.dmi'
	icon_state = "marker"
	mouse_opacity = 1
	see_in_dark = 8
	invisibility = INVISIBILITY_OBSERVER

	faction = "blob"
	var/obj/structure/blob/core/blob_core = null // The blob overmind's core
	var/blob_points = 0
	var/max_blob_points = 200
	var/last_attack = 0
	var/datum/blob_type/blob_type = null
	var/list/blob_mobs = list()
	var/list/resource_blobs = list()
	var/placed = 0
	var/base_point_rate = 2 //for blob core placement
	var/ai_controlled = TRUE
	var/auto_pilot = FALSE // If true, and if a client is attached, the AI routine will continue running.

/mob/observer/blob/New(var/newloc, pre_placed = 0, starting_points = 60, desired_blob_type = null)
	blob_points = starting_points
	if(pre_placed) //we already have a core!
		placed = 1

	overminds += src
	var/new_name = "[initial(name)] ([rand(1, 999)])"
	name = new_name
	real_name = new_name
	if(desired_blob_type)
		blob_type = new desired_blob_type()
	else
		var/datum/blob_type/BT = pick(subtypesof(/datum/blob_type))
		blob_type = new BT()
	color = blob_type.complementary_color
	if(blob_core)
		blob_core.update_icon()
		level_seven_blob_announcement(blob_core)

	..(newloc)

/mob/observer/blob/Destroy()
	for(var/BL in blobs)
		var/obj/structure/blob/B = BL
		if(B && B.overmind == src)
			B.overmind = null
			B.update_icon() //reset anything that was ours

	for(var/BLO in blob_mobs)
		var/mob/living/simple_mob/blob/spore/BM = BLO
		if(BM)
			BM.overmind = null
			BM.update_icons()

	overminds -= src
	return ..()

/mob/observer/blob/Stat()
	..()
	if(statpanel("Status"))
		if(blob_core)
			stat(null, "Core Health: [blob_core.integrity]")
		stat(null, "Power Stored: [blob_points]/[max_blob_points]")
		stat(null, "Total Blobs: [blobs.len]")

/mob/observer/blob/Move(NewLoc, Dir = 0)
	if(placed)
		var/obj/structure/blob/B = locate() in range("3x3", NewLoc)
		if(B)
			forceMove(NewLoc)
			return TRUE
		else
			return FALSE
	else
		var/area/A = get_area(NewLoc)
		if(istype(NewLoc, /turf/space) || istype(A, /area/shuttle)) //if unplaced, can't go on shuttles or space tiles
			return FALSE
		forceMove(NewLoc)
		return TRUE

/mob/observer/blob/proc/add_points(points)
	blob_points = between(0, blob_points + points, max_blob_points)

/mob/observer/blob/Life()
	if(ai_controlled && (!client || auto_pilot))
		if(prob(blob_type.ai_aggressiveness))
			auto_attack()

		if(blob_points >= 100)
			if(!auto_factory() && !auto_resource())
				auto_node()
