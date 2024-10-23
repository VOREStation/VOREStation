/datum/action
	var/name = "Generic Action"
	var/desc

	var/datum/target

	var/check_flags = NONE
	var/processing = FALSE

	var/buttontooltipstyle = ""
	var/transparent_when_unavailable = TRUE
	/// Where any buttons we create should be by default. Accepts screen_loc and location defines
	var/default_button_position = SCRN_OBJ_IN_LIST

	var/button_icon = 'icons/mob/actions.dmi'
	var/background_icon_state = "bg_default"

	var/icon_icon = 'icons/mob/actions.dmi'
	var/button_icon_state = "default"

	var/mob/owner
	/// List of all mobs that are viewing our action button -> A unique movable for them to view.
	var/list/viewers = list()

/datum/action/New(Target)
	link_to(Target)

/datum/action/proc/link_to(Target)
	target = Target
	RegisterSignal(Target, COMSIG_ATOM_UPDATED_ICON, PROC_REF(OnUpdatedIcon))
	RegisterSignal(target, COMSIG_PARENT_QDELETING, PROC_REF(clear_ref), override = TRUE)

/datum/action/Destroy()
	if(owner)
		Remove(owner)
	target = null
	QDEL_LIST_ASSOC_VAL(viewers)
	return ..()

/datum/action/proc/Grant(mob/M)
	if(!M)
		Remove(owner)
		return

	if(owner)
		if(owner == M)
			return
		Remove(owner)
	owner = M
	RegisterSignal(owner, COMSIG_PARENT_QDELETING, PROC_REF(clear_ref), override = TRUE)

	GiveAction(M)

/datum/action/proc/clear_ref(datum/ref)
	SIGNAL_HANDLER
	if(ref == owner)
		Remove(owner)
	if(ref == target)
		qdel(src)

/datum/action/proc/Remove(mob/M)
	for(var/datum/hud/hud in viewers)
		if(!hud.mymob)
			continue
		HideFrom(hud.mymob)
	LAZYREMOVE(M.actions, src) // We aren't always properly inserted into the viewers list, gotta make sure that action's cleared
	viewers = list()

	if(owner)
		UnregisterSignal(owner, COMSIG_PARENT_QDELETING)
		if(target == owner)
			RegisterSignal(target, COMSIG_PARENT_QDELETING, PROC_REF(clear_ref))
		owner = null

/datum/action/proc/Trigger(trigger_flags)
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

/datum/action/proc/UpdateButtons(status_only, force)
	for(var/datum/hud/hud in viewers)
		var/obj/screen/movable/action_button/button = viewers[hud]
		UpdateButton(button, status_only, force)

/datum/action/proc/UpdateButton(obj/screen/movable/action_button/button, status_only = FALSE, force = FALSE)
	if(!button)
		return
	if(!status_only)
		button.name = name
		button.desc = desc
		// if(owner?.hud_used && background_icon_state == ACTION_BUTTON_DEFAULT_BACKGROUND)
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
	UpdateButtons()

// Give our action button to the player
/datum/action/proc/GiveAction(mob/viewer)
	var/datum/hud/our_hud = viewer.hud_used
	if(viewers[our_hud]) // Already have a copy of us? go away
		return

	LAZYOR(viewer.actions, src) // Move this in
	ShowTo(viewer)

/datum/action/proc/ShowTo(mob/viewer)
	var/datum/hud/our_hud = viewer.hud_used
	if(!our_hud || viewers[our_hud]) // There's no point in this if you have no hud in the first place
		return

	var/obj/screen/movable/action_button/button = CreateButton()
	SetId(button, viewer)

	button.our_hud = our_hud
	viewers[our_hud] = button
	if(viewer.client)
		viewer.client.screen += button

	button.load_position(viewer)
	viewer.update_action_buttons()

//Removes our action button from the screen of a player
/datum/action/proc/HideFrom(mob/viewer)
	var/datum/hud/our_hud = viewer.hud_used
	var/obj/screen/movable/action_button/button = viewers[our_hud]
	LAZYREMOVE(viewer.actions, src)
	if(button)
		qdel(button)

/datum/action/proc/CreateButton()
	var/obj/screen/movable/action_button/button = new()
	button.linked_action = src
	button.name = name
	button.actiontooltipstyle = buttontooltipstyle
	if(desc)
		button.desc = desc
	return button

/datum/action/proc/SetId(obj/screen/movable/action_button/our_button, mob/owner)
	//button id generation
	var/bitfield = 0
	for(var/datum/action/action in owner.actions)
		if(action == src) // This could be us, which is dumb
			continue
		var/obj/screen/movable/action_button/button = action.viewers[owner.hud_used]
		if(action.name == name && button.id)
			bitfield |= button.id

	bitfield = ~bitfield // Flip our possible ids, so we can check if we've found a unique one
	for(var/i in 0 to 23) // We get 24 possible bitflags in dm
		var/bitflag = 1 << i // Shift us over one
		if(bitfield & bitflag)
			our_button.id = bitflag
			return

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


/datum/action/innate
	check_flags = NONE
	var/active = 0

/datum/action/innate/Trigger(trigger_flags)
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
