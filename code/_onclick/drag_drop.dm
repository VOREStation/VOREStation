/atom/proc/CanMouseDrop(atom/over, var/mob/user = usr)
	if(!user || !over)
		return FALSE
	if(user.incapacitated())
		return FALSE
	if(!src.Adjacent(user) || !over.Adjacent(user))
		return FALSE // should stop you from dragging through windows
	return TRUE

/*
	MouseDrop:

	Called on the atom you're dragging.  In a lot of circumstances we want to use the
	receiving object instead, so that's the default action.  This allows you to drag
	almost anything into a trash can.
*/
/atom/MouseDrop(atom/over, src_location, over_location, src_control, over_control, params)
	//SHOULD_NOT_OVERRIDE(TRUE) TODO: This should be on in the future!

	if(!usr || !over)
		return

	if(!Adjacent(usr) || !over.Adjacent(usr))
		return // should stop you from dragging through windows
	if(is_incorporeal(usr))
		return

	INVOKE_ASYNC(over, TYPE_PROC_REF(/atom, MouseDrop_T), src, usr, src_location, over_location, src_control, over_control, params)
	mouse_drop_dragged(over, usr, src_location, over_location, params)

/atom/proc/MouseDrop_T(atom/dropping, mob/user, src_location, over_location, src_control, over_control, params)
	return

/// The proc that should be overridden by subtypes to handle mouse drop. Called on the atom being dragged
/atom/proc/mouse_drop_dragged(atom/over, mob/user, src_location, over_location, params)
	PROTECTED_PROC(TRUE)

	return

/client/MouseUp(object, location, control, params)
	if(SEND_SIGNAL(src, COMSIG_CLIENT_MOUSEUP, object, location, control, params) & COMPONENT_CLIENT_MOUSEUP_INTERCEPT)
		click_intercept_time = world.time
	if(mouse_up_icon)
		mouse_pointer_icon = mouse_up_icon
	selected_target[1] = null
