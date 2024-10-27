
//Presets for item actions
/datum/action/item_action
	check_flags = AB_CHECK_RESTRAINED|AB_CHECK_STUNNED|AB_CHECK_LYING|AB_CHECK_CONSCIOUS
	// If you want to override the normal icon being the item
	// then change this to an icon state
	button_icon_state = null

/datum/action/item_action/New(Target)
	. = ..()

	// If our button state is null, use the target's icon instead
	if(target && isnull(button_icon_state))
		AddComponent(/datum/component/action_item_overlay, target)

/datum/action/item_action/vv_edit_var(var_name, var_value)
	. = ..()
	if(!. || !target)
		return

	if(var_name == NAMEOF(src, button_icon_state))
		// If someone vv's our icon either add or remove the component
		if(isnull(var_name))
			AddComponent(/datum/component/action_item_overlay, target)
		else
			qdel(GetComponent(/datum/component/action_item_overlay))

/datum/action/item_action/Trigger(trigger_flags)
	if(!..())
		return 0
	if(target)
		var/obj/item/item_target = target
		item_target.ui_action_click(owner, src.type)
	return 1

/datum/action/item_action/hands_free
	check_flags = AB_CHECK_CONSCIOUS
