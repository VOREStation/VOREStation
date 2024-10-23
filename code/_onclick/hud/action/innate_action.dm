//Preset for general and toggled actions
/datum/action/innate
	check_flags = NONE
	/// Whether we're active or not, if we're a innate - toggle action.
	var/active = 0

/datum/action/innate/Trigger(trigger_flags)
	if(!..())
		return 0
	if(!active)
		Activate()
	else
		Deactivate()
	return 1

/datum/action/innate/proc/Activate()
	return

/datum/action/innate/proc/Deactivate()
	return
