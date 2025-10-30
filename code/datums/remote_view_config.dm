/datum/remote_view_config
	// Base configs
	var/forbid_movement = TRUE
	var/relay_movement = FALSE
	// Interuptions
	var/will_stun = TRUE
	var/will_weaken = TRUE
	var/will_paralyze = TRUE
	var/will_sleep = TRUE
	var/will_blind = TRUE

/datum/remote_view_config/allow_movement
	forbid_movement = FALSE

/datum/remote_view_config/relay_movement
	relay_movement = TRUE
