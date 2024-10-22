/datum/action
	var/name = "Generic Action"
	var/desc = null

	var/atom/movable/target = null

	var/check_flags = NONE
	var/processing = FALSE

	var/obj/screen/movable/action_button/button = null

	var/button_icon = 'icons/mob/actions.dmi'
	var/background_icon_state = "bg_default"
	var/buttontooltipstyle = ""
	var/transparent_when_unavailable = TRUE

	var/icon_icon = 'icons/mob/actions.dmi'
	var/button_icon_state = "default"

	var/mob/owner

/datum/action/New(Target)
	link_to(Target)
	button = new
	button.linked_action = src
	button.name = name
	button.actiontooltipstyle = buttontooltipstyle
	if(desc)
		button.desc = desc

/datum/action/proc/link_to(Target)
	target = Target
	RegisterSignal(Target, COMSIG_ATOM_UPDATED_ICON, .proc/OnUpdatedIcon)

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


		// button id generation
		var/counter = 0
		var/bitfield = 0
		for(var/datum/action/A as anything in M.actions)
			if(A.name == name && A.button.id)
				counter += 1
				bitfield |= A.button.id
		bitfield = !bitfield
		var/bitflag = 1
		for(var/i in 1 to (counter + 1))
			if(bitfield & bitflag)
				button.id = bitflag
				break
			bitflag *= 2

		LAZYADD(M.actions, src)
		if(M.client)
			M.client.screen += button
			button.locked = /* M.client.prefs.buttons_locked  || */ button.id ? LAZYACCESS(M.client.prefs.action_button_screen_locs, "[name]_[button.id]") : FALSE //even if its not defaultly locked we should remember we locked it before
			button.moved = button.id ? LAZYACCESS(M.client.prefs.action_button_screen_locs, "[name]_[button.id]") : FALSE
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
	button.id = null

/datum/action/proc/Trigger()
	if(!IsAvailable())
		return FALSE
	if(SEND_SIGNAL(src, COMSIG_ACTION_TRIGGER, src) & COMPONENT_ACTION_BLOCK_TRIGGER)
		return FALSE
	return TRUE

/datum/action/proc/IsAvailable()
	if(!owner)
		return FALSE
	if(check_flags & AB_CHECK_RESTRAINED)
		if(owner.restrained())
			return FALSE
	if(check_flags & AB_CHECK_STUNNED)
		if(owner.stunned)
			return FALSE
	if(check_flags & AB_CHECK_LYING)
		if(owner.lying)
			return FALSE
	if(check_flags & AB_CHECK_CONSCIOUS)
		if(owner.stat)
			return FALSE
	return TRUE

/datum/action/proc/UpdateButtonIcon(status_only = FALSE, force = FALSE)
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

			ApplyIcon(button, force)

		if(!IsAvailable())
			button.color = transparent_when_unavailable ? rgb(128, 0, 0, 128) : rgb(128, 0, 0)
		else
			button.color = rgb(255, 255, 255, 255)
			return TRUE

/datum/action/proc/ApplyIcon(obj/screen/movable/action_button/current_button, force = FALSE)
	if(icon_icon && button_icon_state && ((current_button.button_icon_state != button_icon_state) || force))
		current_button.cut_overlays(TRUE)
		current_button.add_overlay(mutable_appearance(icon_icon, button_icon_state))
		current_button.button_icon_state = button_icon_state

// Currently never triggered
/datum/action/proc/OnUpdatedIcon()
	SIGNAL_HANDLER
	UpdateButtonIcon()

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

/datum/action/item_action/ApplyIcon(obj/screen/movable/action_button/current_button, force)
	if(button_icon && button_icon_state)
		// If set, use the custom icon that we set instead
		// of the item appearence
		return ..()
	else if(target && ((current_button.appearance_cache != target.appearance) || force))
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
	check_flags = NONE
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

//Preset for an action with a cooldown
/datum/action/cooldown
	check_flags = NONE
	transparent_when_unavailable = FALSE
	var/cooldown_time = 0
	var/next_use_time = 0

/datum/action/cooldown/New()
	..()
	button.maptext = ""
	button.maptext_x = 8
	button.maptext_y = 0
	button.maptext_width = 24
	button.maptext_height = 12

/datum/action/cooldown/IsAvailable()
	return next_use_time <= world.time

/datum/action/cooldown/proc/StartCooldown()
	next_use_time = world.time + cooldown_time
	button.maptext = span_maptext(span_bold("[round(cooldown_time/10, 0.1)]"))
	UpdateButtonIcon()
	START_PROCESSING(SSfastprocess, src)

/datum/action/cooldown/process()
	if(!owner)
		button.maptext = ""
		STOP_PROCESSING(SSfastprocess, src)
	var/timeleft = max(next_use_time - world.time, 0)
	if(timeleft == 0)
		button.maptext = ""
		UpdateButtonIcon()
		STOP_PROCESSING(SSfastprocess, src)
	else
		button.maptext = span_maptext(span_bold("[round(timeleft/10, 0.1)]"))

/datum/action/cooldown/Grant(mob/M)
	..()
	if(owner)
		UpdateButtonIcon()
		if(next_use_time > world.time)
			START_PROCESSING(SSfastprocess, src)
