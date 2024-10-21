/datum/action
	var/name = "Generic Action"
	var/desc = null

	var/atom/movable/target = null

	var/check_flags = 0
	var/processing = 0

	var/obj/screen/movable/action_button/button = null

	var/button_icon = 'icons/mob/actions.dmi'
	var/background_icon_state = "bg_default"
	var/buttontooltipstyle = ""

	var/icon_icon = 'icons/mob/actions.dmi'
	var/button_icon_state = "default"

	var/mob/owner

/datum/action/New(Target)
	target = Target
	button = new
	button.linked_action = src
	button.name = name
	button.actiontooltipstyle = buttontooltipstyle
	if(desc)
		button.desc = desc

/datum/action/Destroy()
	if(owner)
		Remove(owner)
	target = null
	QDEL_NULL(button)
	return ..()

/datum/action/proc/Grant(mob/M)
	if(M)
		if(owner)
			if(owner == M)
				return
			Remove(owner)
		owner = M
		LAZYADD(M.actions, src)
		if(M.client)
			M.client.screen += button
			// button.locked = M.client.prefs.buttons_locked
		M.update_action_buttons(TRUE)
	else
		Remove(owner)

/datum/action/proc/Remove(mob/M)
	if(M)
		if(M.client)
			M.client.screen -= button
		button.moved = FALSE
		LAZYREMOVE(M.actions, src)
		M.update_action_buttons(TRUE)
	owner = null
	button.moved = FALSE //so the button appears in its normal position when given to another owner.
	button.locked = FALSE

/datum/action/proc/Trigger()
	if(!IsAvailable())
		return 0
	return 1

/datum/action/process()
	return

/datum/action/proc/IsAvailable()
	if(!owner)
		return 0
	if(check_flags & AB_CHECK_RESTRAINED)
		if(owner.restrained())
			return 0
	if(check_flags & AB_CHECK_STUNNED)
		if(owner.stunned)
			return 0
	if(check_flags & AB_CHECK_LYING)
		if(owner.lying)
			return 0
	if(check_flags & AB_CHECK_CONSCIOUS)
		if(owner.stat)
			return 0
	return 1

/datum/action/proc/UpdateButtonIcon(status_only = FALSE)
	if(button)
		if(!status_only)
			button.name = name
			button.desc = desc

			// if(owner && owner.hud_used && background_icon_state == ACTION_BUTTON_DEFAULT_BACKGROUND)
			// 	var/list/settings = owner.hud_used.get_action_buttons_icons()
			// 	if(button.icon != settings["bg_icon"])
			// 		button.icon = settings["bg_icon"]
			// 	if(button.icon_state != settings["bg_state"])
			// 		button.icon_state = settings["bg_state"]
			// else

			if(button.icon != button_icon)
				button.icon = button_icon
			if(button.icon_state != background_icon_state)
				button.icon_state = background_icon_state

			ApplyIcon(button)

		if(!IsAvailable())
			button.color = rgb(128, 0, 0, 128)
		else
			button.color = rgb(255, 255, 255, 255)
			return TRUE

/datum/action/proc/ApplyIcon(obj/screen/movable/action_button/current_button)
	if(icon_icon && button_icon_state && current_button.button_icon_state != button_icon_state)
		current_button.cut_overlays(TRUE)
		current_button.add_overlay(mutable_appearance(icon_icon, button_icon_state))
		current_button.button_icon_state = button_icon_state

//Presets for item actions
/datum/action/item_action
	check_flags = AB_CHECK_RESTRAINED|AB_CHECK_STUNNED|AB_CHECK_LYING|AB_CHECK_CONSCIOUS
	button_icon_state = null
	// If you want to override the normal icon being the item
	// then change this to an icon state

/datum/action/item_action/New(Target)
	. = ..()
	var/obj/item/I = target
	LAZYADD(I.actions, src)

/datum/action/item_action/Destroy()
	var/obj/item/I = target
	LAZYREMOVE(I.actions, src)
	return ..()

/datum/action/item_action/Trigger()
	if(!..())
		return 0
	if(target)
		var/obj/item/I = target
		I.ui_action_click(owner, src.type)
	return 1

/datum/action/item_action/ApplyIcon(obj/screen/movable/action_button/current_button)
	if(button_icon && button_icon_state)
		// If set, use the custom icon that we set instead
		// of the item appearence
		return ..(current_button)
	else if(target && current_button.appearance_cache != target.appearance)
		var/mutable_appearance/ma = new(target.appearance)
		ma.plane = FLOAT_PLANE
		ma.layer = FLOAT_LAYER
		ma.pixel_x = 0
		ma.pixel_y = 0

		current_button.cut_overlays()
		current_button.add_overlay(ma)
		current_button.appearance_cache = target.appearance

/datum/action/item_action/hands_free
	check_flags = AB_CHECK_CONSCIOUS


/datum/action/innate
	check_flags = 0
	var/active = 0

/datum/action/innate/Trigger()
	if(!..())
		return 0
	if(!active)
		Activate()
	else
		Deactivate()
	return 1

/datum/action/innate/proc/Activate()
	return

/datum/action/innate/proc/Deactivate()
	return

//Preset for action that call specific procs (consider innate).
/datum/action/generic
	check_flags = 0
	var/procname

/datum/action/generic/Trigger()
	if(!..())
		return 0
	if(target && procname)
		call(target, procname)(usr)
	return 1
