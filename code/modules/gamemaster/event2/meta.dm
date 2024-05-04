// The 'meta' object contains information about its assigned 'action' object, like what departments it will affect.
// It is directly held inside the Game Master Event System.

// The code for actually executing an event should go inside the event object instead.
/datum/event2/meta
	// Name used for organization, shown in the debug verb for the GM system.
	// If null, the meta event will be discarded when the GM system initializes, so it is safe to use nameless subtypes for inheritence.
	var/name = null

	// If FALSE, the GM system won't pick this.
	// Some events set this to FALSE after running, to avoid running twice.
	var/enabled = TRUE

	// What departments the event attached might affect.
	var/list/departments = list(DEPARTMENT_EVERYONE)

	// A guess on how disruptive to a round the event might be. If the action is chosen, the GM's
	// 'danger' score is increased by this number.
	// Negative numbers could be used to signify helpful events.
	var/chaos = 0

	// A threshold the GM will use alongside its 'danger' score, to determine if it should pass
	// over the event associated with this object. The decision is based on
	var/chaotic_threshold = null

	// If true, the event won't have it's `enabled` var set to FALSE when ran by the GM system.
	var/reusable = FALSE

	// A string used to identify a 'class' of similar events.
	// If the event is not reusable, than all events sharing the same class are disabled.
	// Useful if you only ever want one event per round while having a lot of different subtypes of the event.
	var/event_class = null

	// Counter for how many times this event has been picked by the GM.
	// Can be used to make event repeats discouraged but not forbidden by adjusting the weight based on it.
	var/times_ran = 0

	// The type path to the event associated with this meta object.
	// When the GM chooses this event, a new instance is made.
	// Seperate instances allow for multiple concurrent events without sharing state, e.g. two blobs.
	var/event_type = null


// Called by the GM system to actually start an event.
/datum/event2/meta/proc/make_event()
	var/datum/event2/event/E = new event_type()
	E.execute()
	return E

// Returns a TRUE or FALSE for if the GM system should be able to pick this event.
// Can be extended to check for more than just `enabled` later.
/datum/event2/meta/proc/can_pick()
	return enabled

/*
 * Procs to Override
 */

// Returns a number that determines how likely it is for the event to be picked over others.
// Individual events should override this for their own weights.
/datum/event2/meta/proc/get_weight()
	return 0


/datum/event2/meta/Topic(href, href_list)
	if(..())
		return

	if(!check_rights(R_ADMIN|R_EVENT|R_DEBUG))
		message_admins("[usr] has attempted to manipulate an event without sufficent privilages.")
		return

	if(href_list["force"])
		// SSevent_ticker.start_event(event_type)  // VOREStation Edit - We don't use SSgame_master yet.
		message_admins("Event '[name]' was forced by [usr.key].")

	if(href_list["toggle"])
		enabled = !enabled
		message_admins("Event '[name]' was toggled [enabled ? "on" : "off"] by [usr.key].")

	// SSgame_master.interact(usr) // To refresh the UI.  // VOREStation Edit - We don't use SSgame_master yet.