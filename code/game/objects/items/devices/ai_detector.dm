#define PROXIMITY_OFF_CAMERANET		"_no_camera"
#define PROXIMITY_NONE				""
#define PROXIMITY_NEAR				"_yellow"
#define PROXIMITY_ON_SCREEN			"_red"
#define PROXIMITY_TRACKING			"_tracking"
#define PROXIMITY_TRACKING_FAIL		"_tracking_fail"

// This is another syndie-multitool, except this one detects when the AI and/or Security is peeping on the holder.

/obj/item/device/multitool/ai_detector
	var/range_alert = 7			// Will turn red if the AI can observe its holder.
	var/range_warning = 14		// Will turn yellow if the AI's eye is near the holder.
	var/detect_state = PROXIMITY_NONE
	origin_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2, TECH_ILLEGAL = 2)

/obj/item/device/multitool/ai_detector/New()
	// It's really really unlikely for the view range to change.  But why not be futureproof anyways?
	range_alert = world.view
	range_warning = world.view * 2
	START_PROCESSING(SSobj, src)
	..()

/obj/item/device/multitool/ai_detector/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/device/multitool/ai_detector/process()
	var/old_detect_state = detect_state
	var/new_detect_state = detect_ai()
	detect_state = new_detect_state
	update_icon()
	update_warning(old_detect_state, new_detect_state)
	return

// This also detects security using cameras.
/obj/item/device/multitool/ai_detector/proc/detect_ai()
	var/mob/living/carrier = isliving(loc) ? loc : null

	// First, let's check if any AIs are actively tracking them.
	for(var/mob/living/silicon/ai/AI in silicon_mob_list)
		if(carrier && AI.cameraFollow == carrier)
			if(!carrier.tracking_status()) // Successful tracking returns a 0, so we need to invert it.
				return PROXIMITY_TRACKING
			else
				return PROXIMITY_TRACKING_FAIL

	// If there's no turf then cameras won't do anything anyways.
	var/turf/T = get_turf(src)
	if(!T)
		return PROXIMITY_OFF_CAMERANET

	// Security is also a concern, so we need to see if any cameras are in use.
	// Note that this will trigger upon the security console being used, regardless if someone is actually watching,
	// because there isn't a nice way to test if someone is actually looking.  Probably better that way too.
	var/list/our_local_area = range(range_alert, T)
	for(var/obj/machinery/camera/C in our_local_area)
		if(C.camera_computers_using_this.len) // Only check cameras actively being used.
			var/list/their_local_area = C.can_see(range_alert)
			if(T in their_local_area)
				return PROXIMITY_ON_SCREEN

	// Now for the somewhat harder AI cameranet checks.

	// Check if we are even on the cameranet.
	if(!cameranet.checkVis(T))
		return PROXIMITY_OFF_CAMERANET

	var/datum/chunk/chunk = cameranet.getChunk(T.x, T.y, T.z)
	if(!chunk)
		return PROXIMITY_OFF_CAMERANET

	// Check if the AI eye is able to see us, or if it's almost able to.
	if(chunk.seenby.len)
		for(var/mob/observer/eye/aiEye/A in chunk.seenby)
			var/turf/detect_turf = get_turf(A)
			if(get_dist(T, detect_turf) <= range_alert)
				return PROXIMITY_ON_SCREEN
			if(get_dist(T, detect_turf) <= range_warning)
				return PROXIMITY_NEAR

	// If we reach this point, AI or sec isn't near us.
	return PROXIMITY_NONE

/obj/item/device/multitool/ai_detector/update_icon()
	icon_state = "[initial(icon_state)][detect_state]"

/obj/item/device/multitool/ai_detector/proc/update_warning(var/old_state, var/new_state)
	var/mob/living/carrier = isliving(loc) ? loc : null

	// Now to warn our holder, if the state changes.
	if(!carrier)
		return

	if(new_state != old_state)
		switch(new_state)
			if(PROXIMITY_OFF_CAMERANET)
				to_chat(carrier, "<span class='notice'>\icon[src] Now outside of camera network.</span>")
				carrier << 'sound/machines/defib_failed.ogg'
			if(PROXIMITY_NONE)
				to_chat(carrier, "<span class='notice'>\icon[src] Now within camera network, AI and cameras unfocused.</span>")
				carrier << 'sound/machines/defib_safetyOff.ogg'
			if(PROXIMITY_NEAR)
				to_chat(carrier, "<span class='warning'>\icon[src] Warning: AI focus at nearby location.</span>")
				carrier << 'sound/machines/defib_SafetyOn.ogg'
			if(PROXIMITY_ON_SCREEN)
				to_chat(carrier, "<font size='3'><span class='danger'>\icon[src] Alert: AI or camera focused at current location!</span></font>")
				carrier <<'sound/machines/defib_ready.ogg'
			if(PROXIMITY_TRACKING)
				to_chat(carrier, "<font size='3'><span class='danger'>\icon[src] Danger: AI is actively tracking you!</span></font>")
				carrier << 'sound/machines/defib_success.ogg'
			if(PROXIMITY_TRACKING_FAIL)
				to_chat(carrier, "<font size='3'><span class='danger'>\icon[src] Danger: AI is attempting to actively track you, but you are outside of the camera network!</span></font>")
				carrier <<'sound/machines/defib_ready.ogg'


#undef PROXIMITY_OFF_CAMERANET
#undef PROXIMITY_NONE
#undef PROXIMITY_NEAR
#undef PROXIMITY_ON_SCREEN
#undef PROXIMITY_TRACKING
#undef PROXIMITY_TRACKING_FAIL