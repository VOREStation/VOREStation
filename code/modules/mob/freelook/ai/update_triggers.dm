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

/obj/machinery/camera/deactivate(user as mob, choice = 1)
	..(user, choice)
	if(src.can_use())
		SScameras.add_camera_to_chunk(src)
	else
		src.set_light(0)
		SScameras.remove_camera_from_chunk(src)

/obj/machinery/camera/Initialize(mapload)
	. = ..()
	//Camera must be added to global list of all cameras no matter what...
	SScameras.add_camera_to_chunk(src)
	update_coverage(1)

/obj/machinery/camera/Destroy()
	clear_all_networks()
	SScameras.cameras -= src
	return ..()

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
