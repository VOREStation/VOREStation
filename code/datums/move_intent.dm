/decl/move_intent
	var/name
	var/move_delay = 1
	var/hud_icon_state
	var/flags = 0

// Walking
/decl/move_intent/walk
	name = "Walk"
	hud_icon_state = "walking"
	flags = MOVEMENT_INTENT_WALKING

/decl/move_intent/walk/Initialize()
	. = ..()
	move_delay = config.walk_speed

// Running
/decl/move_intent/run
	name = "Run"
	hud_icon_state = "running"
	flags = MOVEMENT_INTENT_RUNNING

/decl/move_intent/run/Initialize()
	. = ..()
	move_delay = config.run_speed

// Simplemob movement intents.
/decl/move_intent/animal_walk
	name = "Walk"
	hud_icon_state = "walking"
	flags = MOVEMENT_INTENT_WALKING

/decl/move_intent/animal_walk/Initialize()
	. = ..()
	move_delay = config.animal_delay + 1

/decl/move_intent/animal_run
	name = "Run"
	hud_icon_state = "running"
	flags = MOVEMENT_INTENT_RUNNING

/decl/move_intent/animal_run/Initialize()
	. = ..()
	move_delay = config.animal_delay

// Ghost movement intent.
/decl/move_intent/no_delay
	name = "Move"
	hud_icon_state = "running"
	flags = MOVEMENT_INTENT_WALKING | MOVEMENT_INTENT_RUNNING
	move_delay = 0

// Robot movement intents.
/decl/move_intent/walk/robot/Initialize()
	. = ..()
	move_delay += config.robot_delay

/decl/move_intent/run/robot/Initialize()
	. = ..()
	move_delay += config.robot_delay
