// These verbs are called for all movemen key press and release events
/client/verb/moveKeyDown(movekeyName as text)
	set instant = TRUE
	set hidden = TRUE
	// set name = ".movekeydown"
	set name = "KeyDown"

	client_keysend_amount += 1

	var/cache = client_keysend_amount

	if(keysend_tripped && next_keysend_trip_reset <= world.time)
		keysend_tripped = FALSE

	if(next_keysend_reset <= world.time)
		client_keysend_amount = 0
		next_keysend_reset = world.time + (1 SECONDS)

	//The "tripped" system is to confirm that flooding is still happening after one spike
	//not entirely sure how byond commands interact in relation to lag
	//don't want to kick people if a lag spike results in a huge flood of commands being sent
	if(cache >= MAX_KEYPRESS_AUTOKICK)
		if(!keysend_tripped)
			keysend_tripped = TRUE
			next_keysend_trip_reset = world.time + (2 SECONDS)
		else
			to_chat(src, span_userdanger("Flooding keysends! This could have been caused by lag, or due to a plugged-in game controller. You have been disconnected from the server automatically."))
			log_admin("Client [ckey] was just autokicked for flooding keysends; likely abuse but potentially lagspike.")
			message_admins("Client [ckey] was just autokicked for flooding keysends; likely abuse but potentially lagspike.")
			qdel(src)
			return

	///Check if the key is short enough to even be a real key
	if(LAZYLEN(movekeyName) > MAX_KEYPRESS_COMMANDLENGTH)
		to_chat(src, span_userdanger("Invalid KeyDown detected! You have been disconnected from the server automatically."))
		log_admin("Client [ckey] just attempted to send an invalid keypress. Keymessage was over [MAX_KEYPRESS_COMMANDLENGTH] characters, autokicking due to likely abuse.")
		message_admins("Client [ckey] just attempted to send an invalid keypress. Keymessage was over [MAX_KEYPRESS_COMMANDLENGTH] characters, autokicking due to likely abuse.")
		qdel(src)
		return

	// Map text sent by skin.dmf to our numeric codes. (This can be optimized away once we update skin.dmf)
	var/movekey = GLOB.MOVE_KEY_MAPPINGS[movekeyName]

	// Validate input.  Must be one (and only one) of the key codes)
	if(isnull(movekey) || (movekey & ~0xFFF) || (movekey & (movekey - 1)))
		keys_held[movekey] = world.time
		if(length(keys_held) >= HELD_KEY_BUFFER_LENGTH && !keys_held[movekey])
			moveKeyUp(keys_held[1]) //We are going over the number of possible held keys, so let's remove the first one.

		//the time a key was pressed isn't actually used anywhere (as of 2019-9-10) but this allows easier access usage/checking
		keys_held[movekeyName] = world.time

		// Client-level keybindings are ones anyone should be able to do at any time
		// Things like taking screenshots, hitting tab, and adminhelps.
		var/AltMod = keys_held["Alt"] ? "Alt" : ""
		var/CtrlMod = keys_held["Ctrl"] ? "Ctrl" : ""
		var/ShiftMod = keys_held["Shift"] ? "Shift" : ""
		var/full_key
		switch(movekeyName)
			if("Alt", "Ctrl", "Shift")
				full_key = "[AltMod][CtrlMod][ShiftMod]"
			else
				if(AltMod || CtrlMod || ShiftMod)
					full_key = "[AltMod][CtrlMod][ShiftMod][movekeyName]"
					key_combos_held[movekeyName] = full_key
				else
					full_key = movekeyName
		mob.focus?.key_down(movekey, src, full_key)
		// og_debug("Client [ckey] sent an illegal movement key down: [movekeyName] ([movekey])") // We forward tgui keys nowadays
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
	var/movekey = GLOB.MOVE_KEY_MAPPINGS[movekeyName]

	// Validate input.  Must be one (and only one) of the key codes)
	if(isnull(movekey) || (movekey & ~0xFFF) || (movekey & (movekey - 1)))
		// log_debug("Client [ckey] sent an illegal movement key up: [movekeyName] ([movekey])")  // We forward tgui keys nowadays
		var/key_combo = key_combos_held[movekeyName]
		if(key_combo)
			key_combos_held -= movekeyName
			moveKeyUp(key_combo)

		if(!keys_held[movekeyName])
			return

		keys_held -= movekeyName
		return

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
	mob.focus?.keyLoop(src)
