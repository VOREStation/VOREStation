var/static/icon/ingame_hud_vr = icon('icons/mob/hud_vr.dmi')
var/static/icon/ingame_hud_med_vr = icon('icons/mob/hud_med_vr.dmi')

/mob/living/carbon/human/make_hud_overlays()
	. = ..()
	hud_list[HEALTH_VR_HUD]   = gen_hud_image(ingame_hud_med_vr, src, "100", plane = PLANE_CH_HEALTH_VR)
	hud_list[STATUS_R_HUD]    = gen_hud_image(ingame_hud_vr, src, plane = PLANE_CH_STATUS_R)
	hud_list[BACKUP_HUD]      = gen_hud_image(ingame_hud_vr, src, plane = PLANE_CH_BACKUP)
	hud_list[VANTAG_HUD]      = gen_hud_image(ingame_hud_vr, src, plane = PLANE_CH_VANTAG)

/mob/living/carbon/human/proc/remove_marking(var/datum/sprite_accessory/marking/mark_datum)
	if (!mark_datum)
		return FALSE
	var/successful = FALSE
	for(var/BP in mark_datum.body_parts)
		var/obj/item/organ/external/O = organs_by_name[BP]
		if(O)
			successful = O.markings.Remove(mark_datum.name) || successful
	if (successful)
		markings_len -= 1
		update_dna()
		update_icons_body()
		return TRUE
	return FALSE

/mob/living/carbon/human/proc/add_marking(var/datum/sprite_accessory/marking/mark_datum, var/mark_color = "#000000")
	if (!mark_datum)
		return FALSE
	var/success = FALSE
	for(var/BP in mark_datum.body_parts)
		var/obj/item/organ/external/O = organs_by_name[BP]
		if(O)
			success = TRUE
			O.markings[mark_datum.name] = list("color" = mark_color, "datum" = mark_datum, "priority" = markings_len + 1)
	if (success)
		markings_len += 1
		update_dna()
		update_icons_body()
	return success

/mob/living/carbon/human/proc/change_priority_of_marking(var/datum/sprite_accessory/marking/mark_datum, var/move_down, var/swap = TRUE) //move_down should be true/false
	if (!mark_datum)
		return FALSE
	var/change = move_down ? 1 : -1
	var/success = FALSE
	for(var/BP in mark_datum.body_parts)
		var/obj/item/organ/external/O = organs_by_name[BP]
		if(O)
			var/index = O.markings.Find(mark_datum.name)
			if (!index)
				continue
			var/change_from = O.markings[mark_datum.name]["priority"]
			if (change_from == clamp(change_from + change, 1, markings_len))
				continue
			if (!success)
				success = TRUE
				change_priority_marking_to_priority(change_from + change, change_from)
			O.markings[mark_datum.name]["priority"] = clamp(change_from + change, 1, markings_len)
			if ((move_down && index == O.markings.len) || (!move_down && index == 1))
				continue
			if (O.markings[O.markings[index + change]]["priority"] == change_from)
				moveElement(O.markings, index, index+(move_down ? 2 : -1))
	if (success)
		update_dna()
		update_icons_body()
	return TRUE

/mob/living/carbon/human/proc/change_priority_marking_to_priority(var/priority, var/to_priority)
	for (var/obj/item/organ/external/O in organs)
		for (var/marking in O.markings)
			if (O.markings[marking]["priority"] == priority)
				O.markings[marking]["priority"] = to_priority

/mob/living/carbon/human/proc/change_marking_color(var/datum/sprite_accessory/marking/mark_datum, var/mark_color = "#000000")
	if (!mark_datum)
		return FALSE
	var/success = FALSE
	for(var/BP in mark_datum.body_parts)
		var/obj/item/organ/external/O = organs_by_name[BP]
		if(O && O.markings[mark_datum.name] && O.markings[mark_datum.name]["color"] != mark_color)
			success = TRUE
			O.markings[mark_datum.name]["color"] = mark_color
	if (success)
		update_dna()
		update_icons_body()
	return success

/mob/living/carbon/human/proc/get_prioritised_markings()
	var/list/markings = list()
	var/list/priorities = list()
	for(var/obj/item/organ/external/O in organs)
		if(O.markings?.len)
			for (var/marking in O.markings)
				var/priority = num2text(O.markings[marking]["priority"])
				if (markings[priority])
					markings[priority] |= list("[marking]" = O.markings[marking]["color"]) //yes I know technically you could have a limb that was attached that has the same marking as another limb with a different color but I'm too tired
				else
					priorities |= O.markings[marking]["priority"]
					markings[priority] = list("[marking]" = O.markings[marking]["color"])
	var/list/sorted = list()
	while (priorities.len > 0)
		var/priority = min(priorities)
		priorities.Remove(priority)
		priority = num2text(priority)
		for (var/marking in markings[priority])
			if (!(marking in sorted))
				sorted[marking] = markings[priority][marking]
	del(markings)
	del(priorities)
	markings_len = sorted.len
	//todo - add an autofixing thing for having markings with the same priorities as another, and for having markings that should have the same priorities across bodyparts, but don't
	//does not really need to happen, that kinda thing will only happen when putting another person's limb onto your own body
	return sorted









