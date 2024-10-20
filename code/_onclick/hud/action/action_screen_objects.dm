
/obj/screen/movable/action_button
	var/datum/action/linked_action
	screen_loc = null

/obj/screen/movable/action_button/Click(location,control,params)
	var/list/modifiers = params2list(params)
	if(modifiers["shift"])
		moved = FALSE
		usr.update_action_buttons()
		return 1
	if(!usr.checkClickCooldown())
		return
	linked_action.Trigger()
	return 1
//Hide/Show Action Buttons ... Button
/obj/screen/movable/action_button/hide_toggle
	name = "Hide Buttons"
	icon = 'icons/mob/actions.dmi'
	icon_state = "bg_default"
	var/hidden = 0

/obj/screen/movable/action_button/hide_toggle/Click()
	usr.hud_used.action_buttons_hidden = !usr.hud_used.action_buttons_hidden

	hidden = usr.hud_used.action_buttons_hidden
	if(hidden)
		name = "Show Buttons"
	else
		name = "Hide Buttons"
	UpdateIcon()
	usr.update_action_buttons()

/obj/screen/movable/action_button/hide_toggle/proc/InitialiseIcon(var/mob/living/user)
	if(isalien(user))
		icon_state = "bg_alien"
	else
		icon_state = "bg_default"
	UpdateIcon()

/obj/screen/movable/action_button/hide_toggle/proc/UpdateIcon()
	cut_overlays()
	var/image/img = image(icon, src, hidden ? "show" : "hide")
	add_overlay(img)

/obj/screen/movable/action_button/MouseEntered(location, control, params)
	openToolTip(usr, src, params, title = name, content = desc)

/obj/screen/movable/action_button/MouseExited(location, control, params)
	closeToolTip(usr)

//used to update the buttons icon.
/mob/proc/update_action_buttons_icon()
	return

/mob/living/update_action_buttons_icon()
	for(var/X in actions)
		var/datum/action/A = X
		A.UpdateButtonIcon()

//This is the proc used to update all the action buttons. Properly defined in /mob/living/
/mob/proc/update_action_buttons(reload_screen)
	return

/mob/living/update_action_buttons(reload_screen)
	if(!hud_used || !client)
		return

	if(!hud_used.hud_shown)	//Hud toggled to minimal
		return

	var/button_number = 0

	if(hud_used.action_buttons_hidden)
		for(var/datum/action/A in actions)
			A.button.screen_loc = null
			if(reload_screen)
				client.screen += A.button
	else
		for(var/datum/action/A in actions)
			button_number++
			A.UpdateButtonIcon()
			var/obj/screen/movable/action_button/B = A.button
			if(!B.moved)
				B.screen_loc = hud_used.ButtonNumberToScreenCoords(button_number)
			else
				B.screen_loc = B.moved
			if(reload_screen)
				client.screen += B

		if(!button_number)
			hud_used.hide_actions_toggle?.screen_loc = null
			return

	// not exactly sure how this happens but it does
	if(hud_used.hide_actions_toggle)
		if(!hud_used.hide_actions_toggle.moved)
			hud_used.hide_actions_toggle.screen_loc = hud_used.ButtonNumberToScreenCoords(button_number+1)
		else
			hud_used.hide_actions_toggle.screen_loc = hud_used.hide_actions_toggle.moved
		if(reload_screen)
			client.screen += hud_used.hide_actions_toggle

#define AB_WEST_OFFSET 4
#define AB_NORTH_OFFSET 26
#define AB_MAX_COLUMNS 10

/datum/hud/proc/ButtonNumberToScreenCoords(var/number) // TODO : Make this zero-indexed for readabilty
	var/row = round((number-1)/AB_MAX_COLUMNS)
	var/col = ((number - 1)%(AB_MAX_COLUMNS)) + 1

	var/coord_col = "+[col-1]"
	var/coord_col_offset = AB_WEST_OFFSET+2*col

	var/coord_row = "[-1 - row]"
	var/coord_row_offset = AB_NORTH_OFFSET

	return "WEST[coord_col]:[coord_col_offset],NORTH[coord_row]:[coord_row_offset]"

/datum/hud/proc/SetButtonCoords(var/obj/screen/button,var/number)
	var/row = round((number-1)/AB_MAX_COLUMNS)
	var/col = ((number - 1)%(AB_MAX_COLUMNS)) + 1
	var/x_offset = 32*(col-1) + AB_WEST_OFFSET + 2*col
	var/y_offset = -32*(row+1) + AB_NORTH_OFFSET

	var/matrix/M = matrix()
	M.Translate(x_offset,y_offset)
	button.transform = M

#undef AB_WEST_OFFSET
#undef AB_NORTH_OFFSET
#undef AB_MAX_COLUMNS
