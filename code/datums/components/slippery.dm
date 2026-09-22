/datum/component/slippery
	var/force_drop_items = TRUE
	var/weaken_time = 0
	var/slip_dist = 0
	var/stun_time = 0
	var/lube_flags
	var/datum/callback/callback

/datum/component/slippery/Initialize(_weaken, _lube_flags = NONE, _slip_dist = 0, datum/callback/_callback, _stun = 0, _force_drop = TRUE)
	. = ..()
	weaken_time = max(_weaken, 0)
	stun_time = max(_stun, 0)
	slip_dist = max(_slip_dist, 0)
	force_drop_items = _force_drop
	lube_flags = _lube_flags
	callback = _callback

/datum/component/slippery/RegisterWithParent()
	RegisterSignals(parent, list(COMSIG_MOVABLE_CROSSED, COMSIG_ATOM_ENTERED), PROC_REF(Slip))

/datum/component/slippery/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_MOVABLE_CROSSED, COMSIG_ATOM_ENTERED))

/datum/component/slippery/proc/Slip(datum/source, atom/movable/AM)
	SIGNAL_HANDLER
	var/mob/victim = AM
	if(istype(victim) && victim.slip(weaken_time, source, lube_flags, slip_dist, stun_time, force_drop_items) && callback)
		callback.Invoke(victim)
