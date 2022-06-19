/datum/admin_secret_item/admin_secret/jump_shuttle
	name = "Jump a Shuttle"

/datum/admin_secret_item/admin_secret/jump_shuttle/can_execute(var/mob/user)
	if(!SSshuttles) return 0
	return ..()

/datum/admin_secret_item/admin_secret/jump_shuttle/execute(var/mob/user)
	. = ..()
	if(!.)
		return
	var/shuttle_tag = tgui_input_list(user, "Which shuttle do you want to jump?", "Shuttle Choice", SSshuttles.shuttles)
	if (!shuttle_tag) return

	var/datum/shuttle/S = SSshuttles.shuttles[shuttle_tag]
	
	var/list/area_choices = return_areas()
	var/origin_area = tgui_input_list(user, "Which area is the shuttle at now? (MAKE SURE THIS IS CORRECT OR THINGS WILL BREAK)", "Area Choice", area_choices)
	if (!origin_area) return

	var/destination_area = tgui_input_list(user, "Which area is the shuttle at now? (MAKE SURE THIS IS CORRECT OR THINGS WILL BREAK)", "Area Choice", area_choices)
	if (!destination_area) return

	var/long_jump = tgui_alert(user, "Is there a transition area for this jump?","Transition?", list("Yes","No"))
	if (long_jump == "Yes")
		var/transition_area = tgui_input_list(user, "Which area is the transition area? (MAKE SURE THIS IS CORRECT OR THINGS WILL BREAK)", "Area Choice", area_choices)
		if (!transition_area) return

		var/move_duration = tgui_input_number(user, "How many seconds will this jump take?")

		S.long_jump(area_choices[origin_area], area_choices[destination_area], area_choices[transition_area], move_duration)
		message_admins("<span class='notice'>[key_name_admin(user)] has initiated a jump from [origin_area] to [destination_area] lasting [move_duration] seconds for the [shuttle_tag] shuttle</span>", 1)
		log_admin("[key_name_admin(user)] has initiated a jump from [origin_area] to [destination_area] lasting [move_duration] seconds for the [shuttle_tag] shuttle")
	else
		S.short_jump(area_choices[origin_area], area_choices[destination_area])
		message_admins("<span class='notice'>[key_name_admin(user)] has initiated a jump from [origin_area] to [destination_area] for the [shuttle_tag] shuttle</span>", 1)
		log_admin("[key_name_admin(user)] has initiated a jump from [origin_area] to [destination_area] for the [shuttle_tag] shuttle")
