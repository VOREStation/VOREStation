//IPC-face object for FPB.
/obj/item/clothing/mask/monitor

	name = "display monitor"
	desc = "A rather clunky old CRT-style display screen, fit for mounting on an optical output."
	body_parts_covered = FACE
	dir = SOUTH

	icon = 'icons/mob/monitor_icons.dmi'
	icon_override = 'icons/mob/monitor_icons.dmi'
	icon_state = "monitor"

	var/monitor_state_index = "blank"
	var/global/list/monitor_states = list()

/obj/item/clothing/mask/monitor/set_dir()
	dir = SOUTH
	return

/obj/item/clothing/mask/monitor/equipped()
	..()
	var/mob/living/carbon/human/H = loc
	if(istype(H) && H.wear_mask == src)
		var/obj/item/organ/external/E = H.organs_by_name[BP_HEAD]
		var/datum/robolimb/robohead = all_robolimbs[E.model]
		canremove = FALSE
		if(robohead.monitor_styles)
			monitor_states = params2list(robohead.monitor_styles)
			icon_state = monitor_states[monitor_state_index]
			to_chat(H, span_notice("\The [src] connects to your display output."))

/obj/item/clothing/mask/monitor/dropped()
	canremove = TRUE
	return ..()

/obj/item/clothing/mask/monitor/mob_can_equip(var/mob/living/carbon/human/user, var/slot, disable_warning = FALSE)
	if (!..())
		return 0
	if(istype(user))
		var/obj/item/organ/external/E = user.organs_by_name[BP_HEAD]
		var/datum/robolimb/robohead = all_robolimbs[E.model]
		if(istype(E) && (E.robotic >= ORGAN_ROBOT) && robohead.monitor_styles)
			return 1
		to_chat(user, span_warning("You must have a compatible robotic head to install this upgrade."))
	return 0

/obj/item/clothing/mask/monitor/verb/set_monitor_state()
	set name = "Set Monitor State"
	set desc = "Choose an icon for your monitor."
	set category = "IC"

	set src in usr
	var/mob/living/carbon/human/H = loc
	if(!istype(H) || H != usr)
		return
	if(H.wear_mask != src)
		to_chat(usr, span_warning("You have not installed \the [src] yet."))
		return
	var/choice = tgui_input_list(usr, "Select a screen icon:", "Head Monitor Choice", monitor_states)
	if(choice)
		monitor_state_index = choice
		update_icon()

/obj/item/clothing/mask/monitor/update_icon()
	if(!(monitor_state_index in monitor_states))
		monitor_state_index = initial(monitor_state_index)
	icon_state = monitor_states[monitor_state_index]
	var/mob/living/carbon/human/H = loc
	if(istype(H)) H.update_inv_wear_mask()
