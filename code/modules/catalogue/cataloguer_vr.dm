/obj/item/cataloguer
	credit_sharing_range = 280

/obj/item/cataloguer/compact
	name = "compact cataloguer"
	desc = "A compact hand-held device, used for compiling information about an object by scanning it. \
	Alt+click to highlight scannable objects around you."
	icon = 'icons/obj/device_vr.dmi'
	icon_state = "compact"
	action_button_name = "Toggle Cataloguer"
	var/deployed = TRUE
	scan_range = 1
	toolspeed = 1.2

/obj/item/cataloguer/compact/update_icon()
	if(busy)
		icon_state = "[initial(icon_state)]_s"
	else
		icon_state = initial(icon_state)

/obj/item/cataloguer/compact/ui_action_click()
	toggle()

/obj/item/cataloguer/compact/verb/toggle()
	set name = "Toggle Cataloguer"
	set category = "Object"

	if(busy)
		to_chat(usr, span("warning", "\The [src] is currently scanning something."))
		return
	deployed = !(deployed)
	if(deployed)
		w_class = ITEMSIZE_NORMAL
		icon_state = "[initial(icon_state)]"
		to_chat(usr, span("notice", "You flick open \the [src]."))
	else
		w_class = ITEMSIZE_SMALL
		icon_state = "[initial(icon_state)]_closed"
		to_chat(usr, span("notice", "You close \the [src]."))

	if (ismob(usr))
		var/mob/M = usr
		M.update_action_buttons()

/obj/item/cataloguer/compact/afterattack(atom/target, mob/user, proximity_flag)
	if(!deployed)
		to_chat(user, span("warning", "\The [src] is closed."))
		return
	return ..()

/obj/item/cataloguer/compact/pulse_scan(mob/user)
	if(!deployed)
		to_chat(user, span("warning", "\The [src] is closed."))
		return
	return ..()

/obj/item/cataloguer/compact/pathfinder
	name = "pathfinder's cataloguer"
	desc = "A compact hand-held device, used for compiling information about an object by scanning it. \
	Alt+click to highlight scannable objects around you."
	icon = 'icons/obj/device_vr.dmi'
	icon_state = "pathcat"
	scan_range = 3
	toolspeed = 1

/obj/item/cataloguer
	desc = "A hand-held device, used for compiling information about an object by scanning it. \
	Alt+click to highlight scannable objects around you."
	icon = 'icons/obj/device_vr.dmi'
	icon_state = "cataloguer"
