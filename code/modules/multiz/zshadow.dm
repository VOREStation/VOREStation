/mob  // TODO: rewrite as obj.
	var/mob/zshadow/shadow

/mob/zshadow
	plane = OVER_OPENSPACE_PLANE
	name = "shadow"
	desc = "Z-level shadow"
	status_flags = GODMODE
	anchored = 1
	unacidable = 1
	density = 0
	opacity = 0					// Don't trigger lighting recalcs gah! TODO - consider multi-z lighting.
	//auto_init = FALSE 			// We do not need to be initialize()d
	var/mob/owner = null		// What we are a shadow of.

/mob/zshadow/can_fall()
	return FALSE

INITIALIZE_IMMEDIATE(/mob/zshadow)
/mob/zshadow/Initialize(var/ml, var/mob/L)
	. = ..()
	if(!istype(L))
		return INITIALIZE_HINT_QDEL
	owner = L
	sync_icon(L)

/mob/zshadow/Destroy()
	owner.shadow = null
	owner = null
	..() //But we don't return because the hint is wrong
	return QDEL_HINT_QUEUE

/mob/Destroy()
	QDEL_NULL(shadow)
	. = ..()

/mob/zshadow/examine(mob/user, distance, infix, suffix)
	if(!owner)
	 	// The only time we should have a null owner is if we are in nullspace. Help figure out why we were examined.
		crash_with("[src] ([type]) @ [log_info_line()] was examined by [user] @ [global.log_info_line(user)]")
		return list()
	return owner.examine(user, distance, infix, suffix)

// Relay some stuff they hear
/mob/zshadow/hear_say(var/list/message_pieces, var/verb = "says", var/italics = 0, var/mob/speaker = null, var/sound/speech_sound, var/sound_vol)
	if(speaker && speaker.z != src.z)
		return // Only relay speech on our acutal z, otherwise we might relay sounds that were themselves relayed up!
	if(isliving(owner))
		verb += " from above"
	return owner.hear_say(message_pieces, verb, italics, speaker, speech_sound, sound_vol)

/mob/zshadow/proc/sync_icon(var/mob/M)
	name = M.name
	icon = M.icon
	icon_state = M.icon_state
	//color = M.color
	color = "#848484"
	overlays = M.overlays
	transform = M.transform
	dir = M.dir
	invisibility = M.invisibility
	if(shadow)
		shadow.sync_icon(src)

/mob/living/Moved()
	. = ..()
	check_shadow()

/mob/living/forceMove()
	. = ..()
	check_shadow()

/mob/living/on_mob_jump()
	// We're about to be admin-jumped.
	// Unfortuantely loc isn't set until after this proc is called. So we must spawn() so check_shadow executes with the new loc.
	. = ..()
	if(shadow)
		spawn(0)
			check_shadow()

/mob/living/proc/check_shadow()
	var/mob/M = src
	if(isturf(M.loc))
		var/turf/simulated/open/OS = GetAbove(src)
		while(OS && istype(OS))
			if(!M.shadow)
				M.shadow = new /mob/zshadow(null, M)
			M.shadow.forceMove(OS)
			M = M.shadow
			OS = GetAbove(M)
	// The topmost level does not need a shadow!
	if(M.shadow)
		qdel(M.shadow)
		M.shadow = null

//
// Handle cases where the owner mob might have changed its icon or overlays.
//

/mob/living/update_icons()
	. = ..()
	if(shadow)
		shadow.sync_icon(src)

// WARNING - the true carbon/human/update_icons does not call ..(), therefore we must sideways override this.
// But be careful, we don't want to screw with that proc.  So lets be cautious about what we do here.
/mob/living/carbon/human/update_icons()
	. = ..()
	if(shadow)
		shadow.sync_icon(src)

/mob/set_dir(new_dir)
	. = ..()
	if(shadow)
		shadow.set_dir(new_dir)

/mob/zshadow/set_typing_indicator(var/state)
	if(!typing_indicator)
		init_typing_indicator("typing")
	if(state && !typing)
		overlays += typing_indicator
		typing = 1
	else if(!state && typing)
		overlays -= typing_indicator
		typing = 0
	if(shadow)
		shadow.set_typing_indicator(state)
