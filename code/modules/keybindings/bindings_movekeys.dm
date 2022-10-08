// TODO - Optimize this into numerics if this ends up working out
var/global/list/MOVE_KEY_MAPPINGS = list(
	"North" = NORTH_KEY,
	"South" = SOUTH_KEY,
	"East" = EAST_KEY,
	"West" = WEST_KEY,
	"W" = W_KEY,
	"A" = A_KEY,
	"S" = S_KEY,
	"D" = D_KEY,
	"Shift" = SHIFT_KEY,
	"Ctrl" = CTRL_KEY,
	"Alt" = ALT_KEY,
)

// These verbs are called for all movemen key press and release events
/client/verb/moveKeyDown(movekeyName as text)
	set instant = TRUE
	set hidden = TRUE
	// set name = ".movekeydown"
	set name = "KeyDown"

	// Map text sent by skin.dmf to our numeric codes. (This can be optimized away once we update skin.dmf)
	var/movekey = MOVE_KEY_MAPPINGS[movekeyName]

	// Validate input.  Must be one (and only one) of the key codes)
	if(isnull(movekey) || (movekey & ~0xFFF) || (movekey & (movekey - 1)))
		log_debug("Client [ckey] sent an illegal movement key down: [movekeyName] ([movekey])")
		return

	// Record that we are now holding the key!
	move_keys_held |= (movekey & 0x0FF)
	mod_keys_held |= (movekey & 0xF00)

	// If we were NOT holding at the start of this move cycle and pressed it, remember that.
	var/movement = MOVEMENT_KEYS_TO_DIR(movekey)
	if(movement && !(next_move_dir_sub & movement) && !(mod_keys_held & CTRL_KEY)) // TODO-LESHANA - Possibly not holding Alt either
		DEBUG_INPUT("Saving [dirs2text(movement)] into next_move_dir_ADD")
		next_move_dir_add |= movement

	#ifdef CARDINAL_INPUT_ONLY
	if(movement)
		DEBUG_INPUT("set last=[dirs2text(movement)]")
		last_move_dir_pressed = movement
	#endif

	mob.focus?.key_down(movekey, src)

/client/verb/moveKeyUp(movekeyName as text)
	set instant = TRUE
	set hidden = TRUE
	// set name = ".movekeyup"
	set name = "KeyUp"

	// Map text sent by skin.dmf to our numeric codes. (This can be optimized away once we update skin.dmf)
	var/movekey = MOVE_KEY_MAPPINGS[movekeyName]
<<<<<<< HEAD
	
=======

>>>>>>> c463104999a... Ports Diagonal Movement (#8199)
	// Validate input.  Must be one (and only one) of the key codes)
	if(isnull(movekey) || (movekey & ~0xFFF) || (movekey & (movekey - 1)))
		log_debug("Client [ckey] sent an illegal movement key up: [movekeyName] ([movekey])")
		return
<<<<<<< HEAD
	
=======

>>>>>>> c463104999a... Ports Diagonal Movement (#8199)
	// Clear bit indicating we were holding the key
	move_keys_held &= ~movekey
	mod_keys_held &= ~movekey

	// If we were holding at the start of this move cycle and now relased it, remember that.
	var/movement = MOVEMENT_KEYS_TO_DIR(movekey)
	if(movement && !(next_move_dir_add & movement))
		DEBUG_INPUT("Saving [dirs2text(movement)] into next_move_dir_SUB")
		next_move_dir_sub |= movement

	mob.focus?.key_up(movekey, src)

// Called every game tick
/client/keyLoop()
<<<<<<< HEAD
	mob.focus?.keyLoop(src)
=======
	mob.focus?.keyLoop(src)
>>>>>>> c463104999a... Ports Diagonal Movement (#8199)
