/obj/item/device/cataloguer/compact
	name = "compact cataloguer"
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "tricorder"
	action_button_name = "Toggle Cataloguer"
	var/deployed = TRUE
	scan_range = 1
	toolspeed = 1.2

/obj/item/device/cataloguer/compact/update_icon()
	if(busy)
		icon_state = "[initial(icon_state)]_s"
	else
		icon_state = initial(icon_state)

/obj/item/device/cataloguer/compact/ui_action_click()
	toggle()

/obj/item/device/cataloguer/compact/verb/toggle()
	set name = "Toggle Cataloguer"
	set category = "Object"

	if(busy)
		to_chat(usr, span("warning", "\The [src] is currently scanning something."))
		return
	deployed = !(deployed)
	if(deployed)
		w_class = ITEMSIZE_NORMAL
		icon_state = "[initial(icon_state)]"
		to_chat(usr, span("notice", "You flip open \the [src]."))
	else
		w_class = ITEMSIZE_SMALL
		icon_state = "[initial(icon_state)]_closed"
		to_chat(usr, span("notice", "You close \the [src]."))

	if (ismob(usr))
		var/mob/M = usr
		M.update_action_buttons()

/obj/item/device/cataloguer/compact/afterattack(atom/target, mob/user, proximity_flag)
	if(!deployed)
		to_chat(user, span("warning", "\The [src] is closed."))
		return
	return ..()

/obj/item/device/cataloguer/compact/pulse_scan(mob/user)
	if(!deployed)
		to_chat(user, span("warning", "\The [src] is closed."))
		return
	return ..()

/obj/item/device/cataloguer/compact/pathfinder
	name = "pathfinder's cataloguer"
	icon_state = "tricorder_med"
	scan_range = 3
	toolspeed = 1
