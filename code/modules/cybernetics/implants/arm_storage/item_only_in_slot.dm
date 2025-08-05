/*
General component bound to an item and "user". the item can only ever be in the home obj or the user
*/

/datum/component/bind_to_hand
	var/atom/home_ref = null
	var/mob/living/carbon/secondary_ref = null
	var/sound_to_play = null
	var/check_parent = TRUE
	var/message_to_display = "XYZ returns home!"
	var/datum/callback/message_updater = null
	var/left_handed = TRUE //false for right

	var/obj/item/us

	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS

/datum/component/bind_to_hand/Destroy(force)
	home_ref = null
	secondary_ref = null
	us = null

	if(message_updater)
		qdel(message_updater)

	. = ..()

/datum/component/bind_to_hand/Initialize(
	home_ref = null,
	secondary_ref = null,
	sound_to_play = null,
	check_parent = TRUE,
	message_to_display = "",
	message_updater = null,
	left_handed = TRUE
)
	if(!isitem(parent)) return COMPONENT_INCOMPATIBLE
	if(!home_ref) return COMPONENT_INCOMPATIBLE

	src.home_ref = home_ref
	src.secondary_ref = secondary_ref

	src.check_parent = check_parent
	src.message_to_display = message_to_display
	src.sound_to_play = sound_to_play
	src.left_handed = left_handed
	src.message_updater = message_updater
	us = parent

/datum/component/bind_to_hand/InheritComponent(
	datum/component/bind_to_hand/new_comp,
	original,
	home_ref,
	secondary_ref,
	sound_to_play,
	check_parent,
	message_to_display,
	message_updater,
	left_handed
)
	if(!original) return
	if(!isnull(home_ref))
		src.home_ref = home_ref
	if(!isnull(secondary_ref))
		src.secondary_ref = secondary_ref
	if(!isnull(sound_to_play))
		src.sound_to_play = sound_to_play
	if(!isnull(check_parent))
		src.check_parent = check_parent
	if(!isnull(message_to_display))
		src.message_to_display = message_to_display
	if(!isnull(message_updater))
		src.message_updater = message_updater


/datum/component/bind_to_hand/RegisterWithParent()
	RegisterSignal(parent,COMSIG_ATOM_ENTERING,PROC_REF(on_change))
	//RegisterSignal(parent,COMSIG_MOVABLE_MOVED,PROC_REF(on_change))

/datum/component/bind_to_hand/UnregisterFromParent()
	UnregisterSignal(parent,COMSIG_ATOM_ENTERING)
//	UnregisterSignal(parent,COMSIG_MOVABLE_MOVED)

/datum/component/bind_to_hand/proc/on_change(datum/source, atom/newloc, atom/oldloc)
	SIGNAL_HANDLER
	addtimer(CALLBACK(src, PROC_REF(do_hand_check)), 0) //this saves a massive amount of headache.

/datum/component/bind_to_hand/proc/do_hand_check()
	var/atom/newloc = us.loc
	if(newloc == home_ref)
		return
	if(newloc == secondary_ref)
		if(left_handed)
			if(secondary_ref.l_hand == us) return
			if(secondary_ref.r_hand == us)
				secondary_ref.drop_r_hand()
				return //we'll run again upon dropping
		else
			if(secondary_ref.r_hand == us) return
			if(secondary_ref.l_hand == us)
				secondary_ref.drop_l_hand()
				return

	if(check_parent)
		if(newloc == home_ref.loc)return

	if(message_updater)
		message_to_display = message_updater.Invoke(us,secondary_ref)
	us.visible_message(message_to_display)
	us.forceMove(home_ref)
