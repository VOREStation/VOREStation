/datum/action
	var/name = "Generic Action"
	var/atom/movable/target = null
	var/check_flags = 0
	var/processing = 0
	var/obj/screen/movable/action_button/button = null
	var/button_icon = 'icons/mob/actions.dmi'
	var/button_icon_state = "default"
	var/background_icon_state = "bg_default"
	var/mob/living/owner

/datum/action/New(Target)
	target = Target
	button = new
	button.linked_action = src
	button.name = name

/datum/action/Destroy()
	if(owner)
		Remove(owner)
	target = null
	QDEL_NULL(button)
	return ..()

/datum/action/proc/Grant(mob/living/L)
	if(owner)
		if(owner == L)
			return
		Remove(owner)
	owner = L
	L.actions += src
	if(L.client)
		L.client.screen += button
	L.update_action_buttons(TRUE)

/datum/action/proc/Remove(mob/living/L)
	if(L.client)
		L.client.screen -= button
	button.moved = FALSE
	L.actions -= src
	L.update_action_buttons(TRUE)
	owner = null

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

/datum/action/proc/UpdateButtonIcon()
	if(button)
		button.icon = button_icon
		button.icon_state = background_icon_state

		ApplyIcon(button)

		if(!IsAvailable())
			button.color = rgb(128, 0, 0, 128)
		else
			button.color = rgb(255, 255, 255, 255)
			return 1

/datum/action/proc/ApplyIcon(obj/screen/movable/action_button/current_button)
	current_button.cut_overlays()
	if(button_icon && button_icon_state)
		var/image/img
		img = image(button_icon, current_button, button_icon_state)
		img.pixel_x = 0
		img.pixel_y = 0
		current_button.add_overlay(img)

//Presets for item actions
/datum/action/item_action
	check_flags = AB_CHECK_RESTRAINED|AB_CHECK_STUNNED|AB_CHECK_LYING|AB_CHECK_CONSCIOUS

/datum/action/item_action/New(Target)
	. = ..()
	var/obj/item/I = target
	I.actions += src

/datum/action/item_action/Destroy()
	var/obj/item/I = target
	I.actions -= src
	return ..()

/datum/action/item_action/Trigger()
	if(!..())
		return 0
	if(target)
		var/obj/item/I = target
		I.ui_action_click(owner, src.type)
	return 1

/datum/action/item_action/ApplyIcon(obj/screen/movable/action_button/current_button)
	current_button.cut_overlays()
	if(target)
		var/mutable_appearance/ma = new(target.appearance)
		ma.plane = FLOAT_PLANE
		ma.layer = FLOAT_LAYER
		ma.pixel_x = 0
		ma.pixel_y = 0
		current_button.add_overlay(ma)

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
