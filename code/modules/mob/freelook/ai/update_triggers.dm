// ROBOT MOVEMENT

// Update the portable camera everytime the Robot moves.
// This might be laggy, comment it out if there are problems.
/mob/living/silicon/var/updating = 0

/mob/living/silicon/robot/Moved(atom/old_loc, direction, forced = FALSE)
	. = ..()
	if(!provides_camera_vision())
		return
	if(!updating)
		if(old_loc != src.loc)
			SScameras.add_camera_to_chunk(src.camera)

/mob/living/silicon/ai/Moved(atom/old_loc, direction, forced = FALSE)
	. = ..()
	if(!provides_camera_vision())
		return
	if(!updating)
		if(old_loc != src.loc)
			SScameras.update_visibility(old_loc)
			SScameras.update_visibility(loc)

// CAMERA

// An addition to deactivate which removes/adds the camera from the chunk list based on if it works or not.

// Mobs
/mob/living/silicon/ai/rejuvenate()
	var/was_dead = stat == DEAD
	..()
	if(was_dead && stat != DEAD)
		// Arise!
		SScameras.update_visibility(src)

/mob/living/silicon/ai/death(gibbed)
	if(..())
		// If true, the mob went from living to dead (assuming everyone has been overriding as they should...)
		SScameras.update_visibility(src)
