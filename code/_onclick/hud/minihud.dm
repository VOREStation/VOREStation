/datum/mini_hud
	var/datum/hud/main_hud
	var/list/screenobjs
	var/needs_processing = FALSE

/datum/mini_hud/New(var/datum/hud/other)
	apply_to_hud(other)
	if(needs_processing)
		START_PROCESSING(SSprocessing, src)

/datum/mini_hud/Destroy()
	unapply_to_hud()
	if(needs_processing)
		STOP_PROCESSING(SSprocessing, src)
	QDEL_NULL_LIST(screenobjs)
	return ..()

// Apply to a real /datum/hud
/datum/mini_hud/proc/apply_to_hud(var/datum/hud/other)
	if(main_hud)
		unapply_to_hud(main_hud)
	main_hud = other
	main_hud.apply_minihud(src)

// Remove from a real /datum/hud
/datum/mini_hud/proc/unapply_to_hud()
	main_hud?.remove_minihud(src)
	main_hud = null

// Update the hud
/datum/mini_hud/process()
	return PROCESS_KILL // You shouldn't be here!

// Return a list of screen objects we use
/datum/mini_hud/proc/get_screen_objs(var/mob/M)
	return screenobjs.Copy()
