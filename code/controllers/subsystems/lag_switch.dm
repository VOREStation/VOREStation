/// The subsystem for controlling drastic performance enhancements aimed at reducing server load for a smoother albeit slightly duller gaming experience
SUBSYSTEM_DEF(lag_switch)
	name = "Lag Switch"
	flags = SS_NO_FIRE

	/// List of bools corresponding to code/__DEFINES/lag_switch.dm
	var/static/list/measures[MEASURES_AMOUNT]

/datum/controller/subsystem/lag_switch/Initialize()
	for(var/i in 1 to measures.len)
		measures[i] = FALSE
	return SS_INIT_SUCCESS

/// Handle the state change for individual measures
/datum/controller/subsystem/lag_switch/proc/set_measure(measure_key, state)
	if(isnull(measure_key) || isnull(state))
		stack_trace("SSlag_switch.set_measure() was called with a null arg")
		return FALSE
	if(isnull(LAZYACCESS(measures, measure_key)))
		stack_trace("SSlag_switch.set_measure() was called with a measure_key not in the list of measures")
		return FALSE
	if(measures[measure_key] == state)
		return TRUE

	measures[measure_key] = state

	switch(measure_key)
		if(DISABLE_DEAD_KEYLOOP)
			if(state)
				for(var/mob/user as anything in GLOB.player_list)
					if(user.stat == DEAD && !user.client?.holder)
						GLOB.keyloop_list -= user
				//deadchat_broadcast(span_big("To increase performance Observer freelook is now disabled. Please use Orbit, Teleport, and Jump to look around."), message_type = DEADCHAT_ANNOUNCEMENT)
			else
				GLOB.keyloop_list |= GLOB.player_list
				//deadchat_broadcast("Observer freelook has been re-enabled. Enjoy your wooshing.", message_type = DEADCHAT_ANNOUNCEMENT)
		if (DISABLE_FOOTSTEPS)
			if (state)
				to_chat(world, span_boldannounce("Footstep sounds have been disabled for performance concerns."))
			else
				to_chat(world, span_boldannounce("Footstep sounds have been re-enabled."))

	return TRUE

/// Helper to loop over all measures for mass changes
/datum/controller/subsystem/lag_switch/proc/set_all_measures(state, automatic = FALSE)
	if(isnull(state))
		stack_trace("SSlag_switch.set_all_measures() was called with a null state arg")
		return FALSE

	/*
	if(automatic)
		message_admins("Lag Switch enabling automatic measures now.")
		log_admin("Lag Switch enabling automatic measures now.")
		veto_timer_id = null
		for(var/i in 1 to auto_measures.len)
			set_measure(auto_measures[i], state)
		return TRUE
	*/

	for(var/i in 1 to measures.len)
		set_measure(i, state)
	return TRUE
