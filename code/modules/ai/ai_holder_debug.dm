// Contains settings to make it easier to debug things.

/datum/ai_holder
	var/path_display = FALSE						// Displays a visual path when A* is being used.
	var/path_icon = 'icons/misc/debug_group.dmi'	// What icon to use for the overlay
	var/path_icon_state = "red"						// What state to use for the overlay
	var/image/path_overlay							// A reference to the overlay

	var/last_turf_display = FALSE					// Similar to above, but shows the target's last known turf visually.
	var/last_turf_icon_state = "green"				// A seperate icon_state from the previous.
	var/image/last_turf_overlay						// Another reference for an overlay.

	var/stance_coloring = FALSE						// Colors the mob depending on its stance.

	var/debug_ai = AI_LOG_OFF						// The level of debugging information to display to people who can see log_debug().

/datum/ai_holder/New()
	..()
	path_overlay = new(path_icon,path_icon_state)
	last_turf_overlay = new(path_icon, last_turf_icon_state)

/datum/ai_holder/Destroy()
	path_overlay = null
	last_turf_overlay = null
	return ..()

//For debug purposes!
/datum/ai_holder/proc/ai_log_output(var/msg = "missing message", var/ver = AI_LOG_INFO)
	var/span_type
	switch(ver)
		if(AI_LOG_OFF)
			return
		if(AI_LOG_ERROR)
			span_type = "debug_error"
		if(AI_LOG_WARNING)
			span_type = "debug_warning"
		if(AI_LOG_INFO)
			span_type = "debug_info"
		if(AI_LOG_DEBUG)
			span_type = "debug_debug" // RAS syndrome at work.
		if(AI_LOG_TRACE)
			span_type = "debug_trace"
	if(ver <= debug_ai)
		log_debug("<span class='[span_type]'>AI: ([holder]:\ref[holder] | [holder.x],[holder.y],[holder.z])(@[world.time]): [msg] </span>")

// Colors the mob based on stance, to visually tell what stance it is for debugging.
// Probably not something you want for regular use.
/datum/ai_holder/proc/stance_color()
	var/new_color = null
	switch(stance)
		if(STANCE_SLEEP)
			new_color = "#FFFFFF" // White
		if(STANCE_IDLE)
			new_color = "#00FF00" // Green
		if(STANCE_ALERT)
			new_color = "#FFFF00" // Yellow
		if(STANCE_APPROACH)
			new_color = "#FF9933" // Orange
		if(STANCE_FIGHT)
			new_color = "#FF0000" // Red
		if(STANCE_MOVE)
			new_color = "#0000FF" // Blue
		if(STANCE_REPOSITION)
			new_color = "#FF00FF" // Purple
		if(STANCE_FOLLOW)
			new_color = "#00FFFF" // Cyan
		if(STANCE_FLEE)
			new_color = "#666666" // Grey
		if(STANCE_DISABLED)
			new_color = "#000000" // Black
	holder.color = new_color

// Turns on all the debugging stuff.
/datum/ai_holder/proc/debug()
	stance_coloring = TRUE
	path_display = TRUE
	last_turf_display = TRUE
	debug_ai = AI_LOG_INFO

/datum/ai_holder/hostile/debug
	wander = FALSE
	conserve_ammo = FALSE
	intelligence_level = AI_SMART

	stance_coloring = TRUE
	path_display = TRUE
	last_turf_display = TRUE
	debug_ai = AI_LOG_INFO

