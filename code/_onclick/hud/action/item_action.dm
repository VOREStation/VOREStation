
//Presets for item actions
/datum/action/item_action
	check_flags = AB_CHECK_RESTRAINED|AB_CHECK_STUNNED|AB_CHECK_LYING|AB_CHECK_CONSCIOUS
	button_icon_state = null
	// If you want to override the normal icon being the item
	// then change this to an icon state

/datum/action/item_action/Trigger(trigger_flags)
	if(!..())
		return 0
	if(target)
		var/obj/item/I = target
		I.ui_action_click(owner, src.type)
	return 1

/datum/action/item_action/ApplyIcon(obj/screen/movable/action_button/current_button, force)
	var/obj/item/item_target = target
	if(button_icon && button_icon_state)
		// If set, use the custom icon that we set instead
		// of the item appearence
		return ..()
	else if(item_target && ((current_button.appearance_cache != item_target.appearance) || force))
		var/mutable_appearance/ma = new(item_target.appearance)
		ma.plane = FLOAT_PLANE
		ma.layer = FLOAT_LAYER
		ma.pixel_x = 0
		ma.pixel_y = 0

		current_button.cut_overlays()
		current_button.add_overlay(ma)
		current_button.appearance_cache = item_target.appearance

/datum/action/item_action/hands_free
	check_flags = AB_CHECK_CONSCIOUS
