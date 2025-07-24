/*
dizzy process - wiggles the client's pixel offset over time
*/

/datum/component/dizzy_shake
	var/mob/owner
	var/dizziness

/datum/component/dizzy_shake/Initialize()
	if (!ismob(parent))
		return COMPONENT_INCOMPATIBLE
	owner = parent
	RegisterSignal(owner, COMSIG_LIVING_LIFE, PROC_REF(process_life))
	RegisterSignal(owner, COMSIG_MOB_DEATH, PROC_REF(mob_death))
	addtimer(CALLBACK(src, PROC_REF(handle_tick)), 1, TIMER_DELETE_ME) // Needs to be a LOT faster than life ticks

/datum/component/dizzy_shake/proc/process_life()
	SIGNAL_HANDLER

	if(QDELETED(parent))
		return

	//Resting
	if(owner.resting)
		dizziness -= 15
	else
		dizziness -= 3

	// Handle jitters
	if(dizziness <= 0)
		qdel(src)
		return

/datum/component/dizzy_shake/proc/handle_tick()
	if(QDELETED(parent))
		return

	// Handle wobbles
	if(dizziness <= 0)
		qdel(src)
		return

	if(dizziness > 100 && owner.client)
		var/amplitude = dizziness*(sin(dizziness * 0.044 * world.time) + 1) / 70
		owner.client.pixel_x = amplitude * sin(0.008 * dizziness * world.time)
		owner.client.pixel_y = amplitude * cos(0.008 * dizziness * world.time)

	addtimer(CALLBACK(src, PROC_REF(handle_tick)), 1, TIMER_DELETE_ME)

/datum/component/dizzy_shake/proc/mob_death()
	SIGNAL_HANDLER
	dizziness = 0
	qdel(src)

/datum/component/dizzy_shake/Destroy(force = FALSE)
	UnregisterSignal(owner, COMSIG_LIVING_LIFE)
	UnregisterSignal(owner, COMSIG_MOB_DEATH)
	// Reset the pixel offsets to zero
	if(owner.client)
		owner.client.pixel_x = 0
		owner.client.pixel_y = 0
	owner = null
	. = ..()



/* Dizzy
value of dizziness ranges from 0 to 1000
below 100 is not dizzy
*/
/mob/proc/AdjustDizzy(var/amount)
	if(amount < 0 && get_dizzy() == 0) // If removing, check if we're already empty!
		return
	var/datum/component/dizzy_shake/DC = LoadComponent(/datum/component/dizzy_shake);
	DC.dizziness = max(min(1000, DC.dizziness + amount),0)	// store what will be new value
															// clamped to max 1000

/mob/proc/clear_dizzy()
	qdel(GetComponent(/datum/component/dizzy_shake))

/mob/proc/get_dizzy()
	var/datum/component/dizzy_shake/DC = GetComponent(/datum/component/dizzy_shake);
	if(!DC)
		return 0
	return max(DC.dizziness,0)
