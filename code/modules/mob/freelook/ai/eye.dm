// AI EYE
//
// A mob that the AI controls to look around the station with.
// It streams chunks as it moves around, which will show it what the AI can and cannot see.

/mob/observer/eye/aiEye
	name = "Inactive AI Eye"
	icon_state = "AI-eye"

/mob/observer/eye/aiEye/Initialize()
	. = ..()
	visualnet = cameranet

/mob/observer/eye/aiEye/Destroy()
	if(owner)
		var/mob/living/silicon/ai/ai = owner
		ai.all_eyes -= src
		owner = null
	. = ..()

/mob/observer/eye/aiEye/setLoc(var/T, var/cancel_tracking = 1)
	if(owner)
		T = get_turf(T)
		loc = T

		var/mob/living/silicon/ai/ai = owner
		if(cancel_tracking)
			ai.ai_cancel_tracking()

		if(use_static)
			ai.camera_visibility(src)

		if(ai.client && !ai.multicam_on)
			ai.client.eye = src

		if(ai.master_multicam)
			ai.master_multicam.refresh_view()

		if(ai.holo)
			if(ai.hologram_follow)
				ai.holo.move_hologram(ai)

		return 1

// AI MOVEMENT

// The AI's "eye". Described on the top of the page.

/mob/living/silicon/ai
	var/obj/machinery/hologram/holopad/holo = null

/mob/living/silicon/ai/proc/destroy_eyeobj(var/atom/new_eye)
	if(!eyeobj) return
	if(!new_eye)
		new_eye = src
	eyeobj.owner = null
	qdel(eyeobj) // No AI, no Eye
	eyeobj = null
	if(client)
		client.eye = new_eye

/mob/living/silicon/ai/proc/create_eyeobj(var/newloc)
	if(eyeobj)
		destroy_eyeobj()
	if(!newloc)
		newloc = src.loc
	eyeobj = new /mob/observer/eye/aiEye(newloc)
	all_eyes += eyeobj
	eyeobj.owner = src
	eyeobj.name = "[src.name] (AI Eye)" // Give it a name
	if(client)
		client.eye = eyeobj
	SetName(src.name)

/mob/living/silicon/ai/Destroy()
	destroy_eyeobj()
	return ..()

/atom/proc/move_camera_by_click()
	if(istype(usr, /mob/living/silicon/ai))
		var/mob/living/silicon/ai/AI = usr
		if(AI.eyeobj && (AI.multicam_on || (AI.client.eye == AI.eyeobj)))
			var/turf/T = get_turf(src)
			if(T)
				AI.eyeobj.setLoc(T)

/mob/living/silicon/ai/proc/view_core()
	camera = null
	unset_machine()

	if(!src.eyeobj)
		return

	if(client && client.eye)
		client.eye = src
	for(var/datum/chunk/c in eyeobj.visibleChunks)
		c.remove(eyeobj)
	src.eyeobj.setLoc(src)

/mob/living/silicon/ai/proc/toggle_acceleration()
	set category = "AI Settings"
	set name = "Toggle Camera Acceleration"

	if(!eyeobj)
		return

	eyeobj.acceleration = !eyeobj.acceleration
	to_chat(usr, "Camera acceleration has been toggled [eyeobj.acceleration ? "on" : "off"].")
