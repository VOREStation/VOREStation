/datum/hud/proc/position_action(obj/screen/movable/action_button/button, position)
	if(button.location != SCRN_OBJ_DEFAULT)
		hide_action(button)
	switch(position)
		if(SCRN_OBJ_DEFAULT) // Reset to the default
			button.dump_save() // Nuke any existing saves
			position_action(button, button.linked_action.default_button_position)
			return
		if(SCRN_OBJ_IN_LIST)
			listed_actions.insert_action(button)
		if(SCRN_OBJ_IN_PALETTE)
			palette_actions.insert_action(button)
		else // If we don't have it as a define, this is a screen_loc, and we should be floating
			floating_actions += button
			button.screen_loc = position
			position = SCRN_OBJ_FLOATING

	button.location = position

/datum/hud/proc/position_action_relative(obj/screen/movable/action_button/button, obj/screen/movable/action_button/relative_to)
	if(button.location != SCRN_OBJ_DEFAULT)
		hide_action(button)
	switch(relative_to.location)
		if(SCRN_OBJ_IN_LIST)
			listed_actions.insert_action(button, listed_actions.index_of(relative_to))
		if(SCRN_OBJ_IN_PALETTE)
			palette_actions.insert_action(button, palette_actions.index_of(relative_to))
		if(SCRN_OBJ_FLOATING) // If we don't have it as a define, this is a screen_loc, and we should be floating
			floating_actions += button
			var/client/our_client = mymob.client
			if(!our_client)
				position_action(button, button.linked_action.default_button_position)
				return
			button.screen_loc = get_valid_screen_location(relative_to.screen_loc, world.icon_size, our_client.view) // Asks for a location adjacent to our button that won't overflow the map

	button.location = relative_to.location

/// Removes the passed in action from its current position on the screen
/datum/hud/proc/hide_action(obj/screen/movable/action_button/button)
	switch(button.location)
		if(SCRN_OBJ_DEFAULT) // Invalid
			CRASH("We just tried to hide an action buttion that somehow has the default position as its location, you done fucked up")
		if(SCRN_OBJ_FLOATING)
			floating_actions -= button
		if(SCRN_OBJ_IN_LIST)
			listed_actions.remove_action(button)
		if(SCRN_OBJ_IN_PALETTE)
			palette_actions.remove_action(button)
	button.screen_loc = null
