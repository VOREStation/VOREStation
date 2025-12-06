/datum/component/tethered_item
	VAR_PRIVATE/obj/item/host_item
	VAR_PRIVATE/held_path
	VAR_PRIVATE/obj/item/hand_held

/datum/component/tethered_item/Initialize(handheld_item_path)
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE
	held_path = handheld_item_path
	host_item = parent
	host_item.verbs += /obj/item/proc/toggle_tethered_handheld
	host_item.actions_types += list(/datum/action/item_action/swap_tethered_item) // AddComponent for this must be called before . = ..() in Initilize()
	RegisterSignal(host_item, COMSIG_ITEM_ATTACK_SELF, PROC_REF(on_attackself))
	RegisterSignal(host_item, COMSIG_ATOM_ATTACKBY, PROC_REF(on_attackby))
	RegisterSignal(host_item, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved))
	// Link handheld
	make_handheld()

/datum/component/tethered_item/Destroy()
	UnregisterSignal(host_item, COMSIG_ITEM_ATTACK_SELF)
	UnregisterSignal(host_item, COMSIG_ATOM_ATTACKBY)
	UnregisterSignal(host_item, COMSIG_MOVABLE_MOVED)
	host_item.verbs -= /obj/item/proc/toggle_tethered_handheld
	host_item = null
	QDEL_NULL(hand_held)
	. = ..()

// Signal handling
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// !!!! IMPORTANT NOTE !!!!
// Attackself signal is used by ui action hud buttons. As it calls attack_self() directly.
// Anything that uses this component must intercept attack_hand() and emit COMSIG_ITEM_ATTACK_SELF.
// This stops you from removing the item from your backpack slot while trying to take the handheld item out.
// There's no way to block the item pickup code, so it has to be done this way. Unfortunately.
// Will return COMPONENT_CANCEL_ATTACK_CHAIN if the component handled the action. Otherwise attack_hand() should resolve normally.
/datum/component/tethered_item/proc/on_attackself(obj/item/source, mob/living/carbon/human/user)
	SIGNAL_HANDLER
	if(hand_held.loc != host_item)
		reattach_handheld()
		return COMPONENT_CANCEL_ATTACK_CHAIN
	//Detach the handset into the user's hands
	if(!slot_check())
		if(ismob(host_item.loc))
			to_chat(user, span_warning("You need to equip \the [host_item] before taking out \the [hand_held]."))
		return
	if(!user.put_in_hands(hand_held))
		to_chat(user, span_warning("You need a free hand to hold the \the [hand_held]!"))
		return
	host_item.update_icon()
	hand_held.update_icon()
	to_chat(user,span_notice("You remove \the [hand_held] from \the [host_item]."))
	return COMPONENT_CANCEL_ATTACK_CHAIN

// Signal registry for handheld item
/datum/component/tethered_item/proc/make_handheld()
	// Not directly a signal handler, but putting this anywhere else makes this way more confusing.
	if(hand_held)
		return
	hand_held = new held_path(host_item)
	hand_held.tethered_host_item = host_item
	RegisterSignal(hand_held, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved))
	RegisterSignal(hand_held, COMSIG_QDELETING, PROC_REF(on_qdelete_handheld))

/datum/component/tethered_item/proc/on_qdelete_handheld()
	SIGNAL_HANDLER
	// Safely unregister signals from handheld when it is deleted, then make a new one
	UnregisterSignal(hand_held, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(hand_held, COMSIG_QDELETING)
	hand_held.tethered_host_item = null
	hand_held = null
	// We normally want to remake our handheld item if it gets destroyed, but not if our host is deleting
	if(!QDELETED(host_item))
		make_handheld()
		host_item.update_icon()
		hand_held.update_icon()

// Absolutely illegal to be anywhere else except in the slot you were allowed to remove it from
/datum/component/tethered_item/proc/on_moved(atom/source, atom/oldloc, direction, forced, list/old_locs, momentum_change)
	SIGNAL_HANDLER
	if(hand_held.loc == host_item) // handheld item is safely inside us
		return
	if(slot_check() && hand_held.loc == host_item.loc) // We are safely worn by our mob, and handheld item is safely inside our mob
		return
	// PANIC
	reattach_handheld()

// Putting the handset back into our host
/datum/component/tethered_item/proc/on_attackby(obj/item/source, obj/item/W, mob/user, params)
	SIGNAL_HANDLER
	if(W == hand_held)
		reattach_handheld()
		return COMPONENT_CANCEL_ATTACK_CHAIN

// Helpers
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/component/tethered_item/proc/reattach_handheld()
	// Retracts back to host
	var/mob/handheld_mob = hand_held.loc
	if(istype(handheld_mob))
		to_chat(handheld_mob,span_notice("\The [hand_held] retracts back into \the [host_item]."))
		handheld_mob.drop_from_inventory(hand_held, host_item)
	else
		hand_held.forceMove(host_item)
	host_item.update_icon()
	hand_held.update_icon()

// Some objects need to communicate the state of the handheld item back to the host
/datum/component/tethered_item/proc/get_handheld()
	return hand_held

// By default this expects to be worn on your back
/datum/component/tethered_item/proc/slot_check()
	var/mob/M = host_item.loc
	if(!istype(M))
		return FALSE
	if((host_item.slot_flags & SLOT_BACK) && M.get_equipped_item(slot_back) == host_item)
		return TRUE
	if((host_item.slot_flags & SLOT_BELT) && M.get_equipped_item(slot_belt) == host_item)
		return TRUE
	if(M.get_equipped_item(slot_s_store) == host_item) // There is no flag for this, just a whitelist on the suits themselves
		return TRUE
	return FALSE

// Helper verbs
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/obj/item/proc/toggle_tethered_handheld()
	set name = "Remove/Replace Handset"
	set category = "Object"

	// May only remove tethered while in the usr's direct inventory
	if(src.loc != usr)
		return
	SEND_SIGNAL(src, COMSIG_ITEM_ATTACK_SELF, usr)
