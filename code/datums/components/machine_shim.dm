/**
 *
 * THIS IS A SHIM. IT SHOULD NOT BE INCLUDED IN FUTURE CODE.
 *
 * This is used to replace the machine var in mob, it is a holdover of pre-tgui code.
 * This component operates similar to how the machine var did previous, but better contained.
 * Any uses of set_machine() should eventually be removed in favor of tgui handling instead.
 *
 */

/datum/component/using_machine_shim
	var/mob/host_mob
	var/obj/machinery/linked_machine

/datum/component/using_machine_shim/Initialize(obj/machinery/machine)
	// Mob
	host_mob = parent
	RegisterSignal(host_mob, COMSIG_LIVING_LIFE, PROC_REF(on_mob_life))
	RegisterSignal(host_mob, COMSIG_OBSERVER_MOVED, PROC_REF(on_mob_move))

	// Machine
	linked_machine = machine
	RegisterSignal(linked_machine, COMSIG_QDELETING, PROC_REF(on_machine_qdelete))
	linked_machine.in_use = TRUE

	// Lets complain if an object uses TGUI but is still setting the machine.
	if(length(linked_machine.tgui_data()))
		log_runtime(EXCEPTION("[machine.type] implements tgui_data(), and has likely been ported to tgui already. It should no longer use set_machine()."))

/datum/component/using_machine_shim/Destroy(force)
	. = ..()
	// Machine
	UnregisterSignal(linked_machine, COMSIG_QDELETING)
	linked_machine.remove_visual(host_mob)
	linked_machine.in_use = FALSE
	linked_machine = null
	// Mob
	UnregisterSignal(host_mob, COMSIG_OBSERVER_MOVED)
	UnregisterSignal(host_mob, COMSIG_LIVING_LIFE)
	host_mob.reset_perspective() // Required, because our machine may have been operating a remote view
	host_mob = null

/datum/component/using_machine_shim/proc/on_mob_move()
	if(!host_mob.Adjacent(linked_machine) || linked_machine.check_eye(host_mob) < 0)
		qdel(src)

/datum/component/using_machine_shim/proc/on_mob_life()
	if(!host_mob.Adjacent(linked_machine) || linked_machine.check_eye(host_mob) < 0)
		qdel(src)

/datum/component/using_machine_shim/proc/on_machine_qdelete()
	qdel(src)



/////////////////////////////////////////////////////////////////////////////////
// To be removed helper procs
/////////////////////////////////////////////////////////////////////////////////
/mob/proc/get_current_machine()
	RETURN_TYPE(/obj)
	var/datum/component/using_machine_shim/shim = GetComponent(/datum/component/using_machine_shim)
	if(!shim)
		return
	return shim.linked_machine

/mob/proc/check_current_machine(var/obj/checking)
	var/datum/component/using_machine_shim/shim = GetComponent(/datum/component/using_machine_shim)
	if(!shim)
		return FALSE
	return shim.linked_machine == checking

/mob/proc/unset_machine()
	var/datum/component/using_machine_shim/shim = GetComponent(/datum/component/using_machine_shim)
	if(shim)
		qdel(shim)

/mob/proc/set_machine(var/obj/O)
	var/datum/component/using_machine_shim/shim = GetComponent(/datum/component/using_machine_shim)
	if(shim)
		if(shim.linked_machine == O) // Already in use
			return
		qdel(shim)
		return
	AddComponent(/datum/component/using_machine_shim, O)

/// return flags that should be added to the viewer's sight var. Otherwise return a negative number to indicate that the view should be cancelled.
/atom/proc/check_eye(user as mob)
	if (isAI(user)) // WHYYYY
		return 0
	return -1
