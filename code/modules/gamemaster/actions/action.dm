/datum/gm_action
	var/name = "no name"				// Simple name, for organization.
	var/enabled = TRUE					// If not enabled, this action is never taken.
	var/departments = list()			// What kinds of departments are affected by this action.  Multiple departments can be listed.
	var/chaotic = 0						// A number showing how chaotic the action may be.  If danger is high, the GM will avoid it.
	var/reusable = FALSE				// If true, the event does not become disabled upon being used.  Should be used sparingly.
	var/observers_used = FALSE			// Determines if the GM should check if ghosts are available before using this.
	var/length = 0						// Determines how long the event lasts, until end() is called.
	var/datum/game_master/gm = null
	var/severity = 1					// The severity of the action. This is here to prevent continued future defining of this var on actions, un-used.

/datum/gm_action/proc/set_up()
	return

/datum/gm_action/proc/get_weight()
	return

/datum/gm_action/proc/start()
	if(!reusable)
		enabled = FALSE
	return

/datum/gm_action/proc/end()
	return

/datum/gm_action/proc/announce()
	return