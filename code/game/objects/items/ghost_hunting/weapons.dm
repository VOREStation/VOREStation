/obj/item/ghost_catcher
	name = "Photon rifle" //Legally distinct proton rifle.
	desc = "A hand-held device, used for 'catching ghosts'"
	//description_info = "TODO"
	icon = 'icons/obj/device.dmi'
	icon_state = "cataloguer"
	w_class = ITEMSIZE_NORMAL
	force = 0
	slot_flags = SLOT_BELT
	var/grab_range = 5 // How many tiles away it can grab. Changing this also changes the box size.
	/// Stops multiple grabbs if set to TRUE
	var/busy = FALSE
	/// The entity we are currently grabbing.
	var/datum/weakref/grabbed_entity
	/// How far we can move an entity in one go!
	var/max_move_distance = 3

	//TODO:
	// Make ghosts/phased entities slow when grabbed
	// Make it so it searches in an AOE and grabs thing.

/obj/item/ghost_catcher/Destroy()
	grabbed_entity = null
	return ..()

/obj/item/ghost_catcher/update_icon()
	if(busy)
		icon_state = "[initial(icon_state)]_active"
	else
		icon_state = initial(icon_state)

/obj/item/ghost_catcher/afterattack(atom/target, mob/user, proximity_flag)
	if(isturf(target) && (!target.incorporeal_grab()))
		var/turf/T = target
		if(!busy)
			for(var/atom/movable/A in range(3, T))
				if(A.incorporeal_grab())
					target = A
					break
		else
			if(grabbed_entity)
				var/atom/movable/entity = grabbed_entity.resolve()
				if(get_dist(T, entity) > max_move_distance)
					to_chat(user, span_warning("\The [src] is unable to pull the entity that far!"))
					return
				entity.forceMove(T)
				return
	// Things that invalidate the scan immediately.
	if(busy)
		to_chat(user, span_warning("\The [src] is already grabbing an entity!"))
		return

	if(!target.incorporeal_grab(user)) // This will tell the user what is wrong.
		return

	if(get_dist(target, user) > grab_range)
		to_chat(user, span_warning("You are too far away from \the [target] to catalogue it. Get closer."))
		return

	// Get how long the delay will be.
	var/scan_delay = target.get_catalogue_delay() * toolspeed

	// Start the special effects.
	busy = TRUE
	update_icon()
	var/datum/beam/scan_beam = user.Beam(target, icon_state = "rped_upgrade", time = scan_delay)
	var/filter = filter(type = "outline", size = 1, color = "#ff0000")
	target.filters += filter
	var/list/box_segments = list()
	if(user.client)
		box_segments = draw_box(target, grab_range, user.client)
		color_box(box_segments, "#ff3939", scan_delay)

	playsound(src, 'sound/machines/beep.ogg', 50)
	grabbed_entity = WEAKREF(target)

	// The delay, and test for if the scan succeeds or not.
	if(do_after(user, 60 SECONDS, target, timed_action_flags = IGNORE_USER_LOC_CHANGE|IGNORE_TARGET_LOC_CHANGE, max_distance = grab_range))
		to_chat(user, span_warning("With a buzz, \the [src] flashes red, the beam on \the [target] has broken!"))
		playsound(src, 'sound/machines/buzz-two.ogg', 50)
		color_box(box_segments, "#FF0000", 3)
	busy = FALSE

	// Now clean up the effects.
	update_icon()
	QDEL_NULL(scan_beam)
	if(target)
		target.filters -= filter
	if(user.client) // If for some reason they logged out mid-scan the box will be gone anyways.
		delete_box(box_segments, user.client)

/atom/proc/incorporeal_grab(mob/user)
	if(is_incorporeal())
		return TRUE
	return FALSE

/mob/observer/dead/incorporeal_grab(mob/user) // Dead mobs can't be scanned.
	if(admin_ghosted || !interact_with_world)
		to_chat(user, span_notice("No entity detected!")) //The goggles ARE listed as unreliable. You could just be seeing static.
		return FALSE
	return ..()
