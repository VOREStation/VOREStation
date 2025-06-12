/*
 * A component given to holographic objects to make them glitch out when passed through
 */
#define GLITCH_DURATION 0.45 SECONDS
#define GLITCH_REMOVAL_DURATION 0.25 SECONDS

/datum/component/holographic_nature
	///cooldown before we can glitch out again
	COOLDOWN_DECLARE(glitch_cooldown)
	///list of signals we apply to our turf
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(on_entered),
	)

/datum/component/holographic_nature/Initialize()
	if(!ismovable(parent))
		return COMPONENT_INCOMPATIBLE

/datum/component/holographic_nature/RegisterWithParent()
	AddComponent(/datum/component/connect_loc_behalf, parent, loc_connections)

/datum/component/holographic_nature/proc/on_entered(atom/movable/source, atom/movable/thing)
	SIGNAL_HANDLER
	var/atom/movable/movable_parent = parent
	if(!isturf(movable_parent.loc))
		return
	if(thing.density || thing.throwing)
		apply_effects()

/datum/component/holographic_nature/proc/apply_effects()
	if(!COOLDOWN_FINISHED(src, glitch_cooldown))
		return
	COOLDOWN_START(src, glitch_cooldown, GLITCH_DURATION + GLITCH_REMOVAL_DURATION)
	apply_wibbly_filters(parent)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(remove_wibbly_filters), parent, GLITCH_REMOVAL_DURATION), GLITCH_DURATION)

#undef GLITCH_DURATION
#undef GLITCH_REMOVAL_DURATION
