/**
 * THIS IS A SHIM. IT SHOULD NOT BE INCLUDED IN FUTURE CODE. DEPRECATED, DO NOT USE.
 *
 * This is used to replace the machine var in mob, it is a holdover of pre-tgui code.
 * This component operates similar to how the machine var did previous, but better contained.
 * Any uses of set_machine() should eventually be removed in favor of tgui handling instead.
 *
 * All this does is ensure that the mob releases the machine when they leave it.
 */
/datum/component/using_machine_shim
	var/mob/host_mob
	var/obj/machinery/linked_machine

/datum/component/using_machine_shim/Initialize(obj/machinery/machine)
	// Mob
	host_mob = parent
	RegisterSignal(host_mob, COMSIG_LIVING_LIFE, PROC_REF(on_mob_action))
	RegisterSignal(host_mob, COMSIG_MOVABLE_MOVED, PROC_REF(on_mob_action))
	RegisterSignal(host_mob, COMSIG_MOB_LOGOUT, PROC_REF(on_mob_logout))

	// Machine
	linked_machine = machine
	RegisterSignal(linked_machine, COMSIG_QDELETING, PROC_REF(on_machine_qdelete))
	linked_machine.in_use = TRUE

	// Lets complain if an object uses TGUI but is still setting the machine.
	if(length(linked_machine.tgui_data()))
		log_world("## ERROR [machine.type] implements tgui_data(), and has likely been ported to tgui already. It should no longer use set_machine().")

/datum/component/using_machine_shim/Destroy(force)
	. = ..()
	// Machine
	UnregisterSignal(linked_machine, COMSIG_QDELETING)
	linked_machine.in_use = FALSE
	linked_machine = null
	// Mob
	UnregisterSignal(host_mob, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(host_mob, COMSIG_LIVING_LIFE)
	UnregisterSignal(host_mob, COMSIG_MOB_LOGOUT)
	host_mob.reset_perspective() // Required, because our machine may have been operating a remote view
	host_mob = null

/datum/component/using_machine_shim/proc/on_mob_action()
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE)
	SIGNAL_HANDLER
	if(host_mob.stat == DEAD || !host_mob.client || !host_mob.Adjacent(linked_machine))
		qdel(src)

/datum/component/using_machine_shim/proc/on_machine_qdelete()
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE)
	SIGNAL_HANDLER
	qdel(src)

/datum/component/using_machine_shim/proc/on_mob_logout()
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE)
	SIGNAL_HANDLER
	qdel(src)

/////////////////////////////////////////////////////////////////////////////////
// To be removed helper procs
/////////////////////////////////////////////////////////////////////////////////
/// deprecated, do not use
/mob/proc/get_current_machine()
	RETURN_TYPE(/obj)
	var/datum/component/using_machine_shim/shim = GetComponent(/datum/component/using_machine_shim)
	if(!shim)
		return
	return shim.linked_machine

/// deprecated, do not use
/mob/proc/check_current_machine(var/obj/checking)
	var/datum/component/using_machine_shim/shim = GetComponent(/datum/component/using_machine_shim)
	if(!shim)
		return FALSE
	return (shim.linked_machine == checking)

/// deprecated, do not use
/mob/proc/unset_machine()
	var/datum/component/using_machine_shim/shim = GetComponent(/datum/component/using_machine_shim)
	if(shim)
		qdel(shim)

/// deprecated, do not use
/mob/proc/set_machine(var/obj/O)
	var/datum/component/using_machine_shim/shim = GetComponent(/datum/component/using_machine_shim)
	if(shim)
		if(shim.linked_machine == O) // Already in use
			return
		qdel(shim)
		return
	AddComponent(/datum/component/using_machine_shim, O)

/// deprecated, do not use
/obj/item/proc/updateSelfDialog()
	var/mob/M = src.loc
	if(istype(M) && M.client && M.check_current_machine(src))
		src.attack_self(M)

/// deprecated, do not use
/obj/proc/updateUsrDialog(mob/user)
	if(in_use)
		var/is_in_use = 0
		var/list/nearby = viewers(1, src)
		for(var/mob/M in nearby)
			if ((M.client && M.check_current_machine(src)))
				is_in_use = 1
				src.attack_hand(M)
		if (isAI(user) || isrobot(user))
			if (!(user in nearby))
				if (user.client && user.check_current_machine(src)) // && M.machine == src is omitted because if we triggered this by using the dialog, it doesn't matter if our machine changed in between triggering it and this - the dialog is probably still supposed to refresh.
					is_in_use = 1
					src.attack_ai(user)

		// check for TK users

		if (ishuman(user))
			var/mob/living/carbon/human/H = user
			if(H.get_type_in_hands(/obj/item/tk_grab))
				if(!(H in nearby))
					if(H.client && H.check_current_machine(src))
						is_in_use = 1
						src.attack_hand(H)
		in_use = is_in_use

/// deprecated, do not use
/obj/proc/updateDialog()
	// Check that people are actually using the machine. If not, don't update anymore.
	if(in_use)
		var/list/nearby = viewers(1, src)
		var/is_in_use = 0
		for(var/mob/M in nearby)
			if ((M.client && M.check_current_machine(src)))
				is_in_use = 1
				src.interact(M)
		var/ai_in_use = AutoUpdateAI(src)

		if(!ai_in_use && !is_in_use)
			in_use = 0

/// deprecated, do not use
/obj/machinery/CouldUseTopic(var/mob/user)
	..()
	user.set_machine(src)

/// deprecated, do not use
/obj/machinery/CouldNotUseTopic(var/mob/user)
	user.unset_machine()
