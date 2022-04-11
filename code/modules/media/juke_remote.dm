/obj/item/device/juke_remote
	name = "\improper BoomTown cordless speaker"
	desc = "Once paired with a jukebox, this speaker can relay the tunes elsewhere!"

	description_fluff = "The BoomTown cordless speaker is capable of maintaining a high-quality 49kbps audio stream from a stationary jukebox and relaying the sound locally. It's like magic!"
	description_info = "Hit it on a jukebox to pair, then set it down to play tunes. Does nothing while held, it has to be stationary, visible in the world. Keep in mind music is done by AREA, not within a certain range. You will need more than one to cover a department."

	icon = 'icons/obj/device_vr.dmi'
	icon_state = "bspeaker"

	var/obj/machinery/media/jukebox/paired_juke
	var/area/our_area

/*
/obj/item/device/juke_remote/Initialize()
	. = ..()
	flags |= NOBLUDGEON
*/
// Pairing
/obj/item/device/juke_remote/proc/pair_juke(obj/machinery/media/jukebox/juke, mob/user)
	if(paired_juke)
		to_chat(user, "<span class='warning'>The [src] is already paired to [paired_juke == juke ? "that" : "a different"] jukebox.</span>")
		return
	paired_juke = juke
	LAZYDISTINCTADD(paired_juke.remotes, src)
	to_chat(user, "<span class='notice'>You pair the [src] to the [juke].</span>")
	icon_state = "[initial(icon_state)]_ready"

/obj/item/device/juke_remote/proc/unpair_juke(mob/user)
	if(!paired_juke)
		to_chat(user, "<span class='warning'>The [src] isn't paired to anything.</span>")
		return
	LAZYREMOVE(paired_juke.remotes, src)
	paired_juke = null
	icon_state = initial(icon_state)
	unanchor()
	detach_area()
	to_chat(user, "<span class='notice'>You unpair the [src].</span>")
	icon_state = "[initial(icon_state)]"

/obj/item/device/juke_remote/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(istype(target, /obj/machinery/media/jukebox))
		pair_juke(target, user)
		return
	return ..()

/obj/item/device/juke_remote/verb/reset()
	set name = "Reset Pairing"
	set desc = "Unpair this speaker from a jukebox."

	unpair_juke(usr)

// Deploying
/obj/item/device/juke_remote/Moved(atom/old_loc, direction, forced)
	. = ..()
	if(paired_juke && !anchored && isturf(loc))
		anchor()

/obj/item/device/juke_remote/attack_hand(mob/living/user)
	if(anchored)
		unanchor()
	return ..()

/obj/item/device/juke_remote/proc/anchor()
	if(anchored)
		return
	anchored = TRUE
	if(attach_area())
		visible_message("[src] attaches to the nearest surface and bounces happily, ready to pump tunes.", runemessage = "clank")
		if(paired_juke) // we were able to claim the area
			icon_state = "[initial(icon_state)]_playing"
		else
			icon_state = "[initial(icon_state)]"

/obj/item/device/juke_remote/proc/unanchor()
	detach_area()
	anchored = FALSE
	visible_message("[src] detaches from it's mounting surface, able to be moved once again.", runemessage = "clunk")
	if(paired_juke)
		icon_state = "[initial(icon_state)]_ready"
	else
		icon_state = "[initial(icon_state)]"

// Area handling
/obj/item/device/juke_remote/proc/attach_area()
	var/area/A = get_area(src)
	if(!A || !paired_juke)
		error("Jukebox remote at [x],[y],[z] without paired juke tried to bind to an area.")
		return FALSE
	if(A.media_source)
		return FALSE // Already has a media source, won't overpower it with porta speaker
	our_area = A
	A.media_source = paired_juke
	update_music()
	return TRUE
	
/obj/item/device/juke_remote/proc/detach_area()
	if(!our_area || (paired_juke && our_area.media_source != paired_juke))
		return
	our_area.media_source = null
	update_music()
	our_area = null

// Music handling
/obj/item/device/juke_remote/proc/update_music()
	if(!our_area || !paired_juke)
		return
	// Send update to clients.
	for(var/mob/M in mobs_in_area(our_area))
		if(M?.client)
			M.update_music()