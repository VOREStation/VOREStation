/*
jittery process - wiggles the mob's pixel offset over time
*/

/datum/component/jittery_shake
	var/mob/owner
	var/jitteriness

/datum/component/jittery_shake/Initialize()
	if (!ismob(parent))
		return COMPONENT_INCOMPATIBLE
	owner = parent
	RegisterSignal(owner, COMSIG_LIVING_LIFE, PROC_REF(process_life))
	RegisterSignal(owner, COMSIG_MOB_DEATH, PROC_REF(mob_death))
	addtimer(CALLBACK(src, PROC_REF(handle_tick)), 1, TIMER_DELETE_ME) // Needs to be a LOT faster than life ticks

/datum/component/jittery_shake/proc/process_life()
	SIGNAL_HANDLER

	if(QDELETED(parent))
		return

	//Resting
	if(owner.resting)
		jitteriness -= 15
	else
		jitteriness -= 3

	// Handle jitters
	if(jitteriness <= 0)
		qdel(src)
		return

/datum/component/jittery_shake/proc/handle_tick()
	if(QDELETED(parent))
		return

	// Handle jitters
	if(jitteriness <= 0)
		qdel(src)
		return

	// Shakey shakey
	if(jitteriness > 100)
		var/amplitude = min(4, jitteriness / 100)
		owner.pixel_x = owner.old_x + rand(-amplitude, amplitude)
		owner.pixel_y = owner.old_y + rand(-amplitude/3, amplitude/3)

	addtimer(CALLBACK(src, PROC_REF(handle_tick)), 1, TIMER_DELETE_ME)

/datum/component/jittery_shake/proc/mob_death()
	SIGNAL_HANDLER
	jitteriness = 0
	qdel(src)

/datum/component/jittery_shake/Destroy(force = FALSE)
	UnregisterSignal(owner, COMSIG_LIVING_LIFE)
	UnregisterSignal(owner, COMSIG_MOB_DEATH)
	// Reset the pixel offsets to zero
	owner.pixel_x = owner.old_x
	owner.pixel_y = owner.old_y
	owner = null
	. = ..()




/* jitteriness
value of jittery ranges from 0 to 1000
below 100 is not jittery
*/
/mob/proc/AdjustJittery(var/amount)
	if(amount < 0 && get_jittery() == 0) // If removing, check if we're already empty!
		return
	var/datum/component/jittery_shake/JC = LoadComponent(/datum/component/jittery_shake);
	JC.jitteriness = max(min(1000, JC.jitteriness + amount),0)	// store what will be new value
																// clamped to max 1000

/mob/proc/clear_jittery()
	qdel(GetComponent(/datum/component/jittery_shake))

/mob/proc/get_jittery()
	var/datum/component/jittery_shake/JC = GetComponent(/datum/component/jittery_shake);
	if(!JC)
		return 0
	return max(JC.jitteriness,0)
