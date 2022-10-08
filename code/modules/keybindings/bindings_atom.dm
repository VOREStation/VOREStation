// You might be wondering why this isn't client level. If focus is null, we don't want you to move.
// Only way to do that is to tie the behavior into the focus's keyLoop().

// THE TRADITIONAL STYLE FROM /TG (modified)

/atom/movable/keyLoop(client/user)
<<<<<<< HEAD
	// Bail out if the user is holding the "face direction" key (Maybe?)
	// TODO - I think this breaks non-hotkeys WASD movement, so maybe adopt the /tg solution)
	if(user.mod_keys_held & CTRL_KEY)
		return

=======
>>>>>>> c463104999a... Ports Diagonal Movement (#8199)
	var/must_call_move = FALSE
	var/movement_dir = MOVEMENT_KEYS_TO_DIR(user.move_keys_held)
	if(user.next_move_dir_add)
		must_call_move = TRUE // So that next_move_dir_add gets cleared if its time.
		movement_dir |= user.next_move_dir_add
	if(user.next_move_dir_sub)
		DEBUG_INPUT("[(user.next_move_dir_sub & movement_dir) ? "Actually" : "Want to"] subtract [dirs2text(user.next_move_dir_sub)] from [dirs2text(movement_dir)]")
		must_call_move = TRUE // So that next_move_dir_sub gets cleared if its time.
		movement_dir &= ~user.next_move_dir_sub

	// Sanity checks in case you hold left and right and up to make sure you only go up
	if((movement_dir & (NORTH|SOUTH)) == (NORTH|SOUTH))
		movement_dir &= ~(NORTH|SOUTH)
	if((movement_dir & (EAST|WEST)) == (EAST|WEST))
		movement_dir &= ~(EAST|WEST)

	#ifdef CARDINAL_INPUT_ONLY
	if(movement_dir & user.last_move_dir_pressed)
		movement_dir = user.last_move_dir_pressed
	else if (movement_dir == NORTHEAST || movement_dir == NORTHWEST)
		DEBUG_INPUT("overriding to NORTH: movement_dir=[dirs2text(movement_dir)] last=[dirs2text(user.last_move_dir_pressed)]")
		movement_dir = NORTH
	else if (movement_dir == SOUTHEAST || movement_dir == SOUTHWEST)
		DEBUG_INPUT("overriding to SOUTH: movement_dir=[dirs2text(movement_dir)] last=[dirs2text(user.last_move_dir_pressed)]")
		movement_dir = SOUTH
	#endif

	// Compensate for client camera spinning (client.dir) so our movement still makes sense I guess.
	if(movement_dir) // Only compensate if non-zero, as byond will auto-fill dir otherwise
		movement_dir = turn(movement_dir, -dir2angle(user.dir))

	// Move, but only if we actually are planing to move, or we need to clear the next move vars
	if(movement_dir || must_call_move)
		user.Move(get_step(src, movement_dir), movement_dir)
