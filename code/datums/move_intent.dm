/decl/move_intent
	var/name
	var/move_delay = 1
	var/hud_icon_state

// Walking
/decl/move_intent/walk
	name = "Walk"
	hud_icon_state = "walking"

/decl/move_intent/walk/Initialize()
	. = ..()
	move_delay = config.walk_speed

// Running
/decl/move_intent/run
	name = "Run"
	hud_icon_state = "running"

/decl/move_intent/run/Initialize()
	. = ..()
	move_delay = config.run_speed
