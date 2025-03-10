/////////////////////////////////////////////
//Time Clock Terminal////////////////////////
/////////////////////////////////////////////

//
// Timeclock terminal machine itself
//
/obj/machinery/computer/timeclock
	name = "timeclock terminal"
	icon = 'icons/obj/machines/timeclock_vr.dmi'
	icon_state = "timeclock"
	icon_keyboard = null
	light_color = "#0099ff"
	light_power_on = 0.5
	layer = ABOVE_WINDOW_LAYER
	density = FALSE
	circuit = /obj/item/circuitboard/timeclock
	clicksound = null
	var/channel = "Common" //Radio channel to announce on

	var/obj/item/card/id/card // Inserted Id card
	var/obj/item/radio/intercom/announce	// Integreated announcer


/obj/machinery/computer/timeclock/Initialize(mapload)
	. = ..()
	announce = new /obj/item/radio/intercom(src)

/obj/machinery/computer/timeclock/Destroy()
	if(card)
		card.forceMove(get_turf(src))
		card = null
	. = ..()

/obj/machinery/computer/timeclock/update_icon()
	if(inoperable())
		icon_state = "[initial(icon_state)]_off"
	else if(card)
		icon_state = "[initial(icon_state)]_card"
	else
		icon_state = "[initial(icon_state)]"

/obj/machinery/computer/timeclock/power_change()
	var/old_stat = stat
	. = ..()
	if(old_stat != stat)
		update_icon()
	if(stat & NOPOWER)
		set_light(0)
	else
		set_light(light_range_on, light_power_on)

/obj/machinery/computer/timeclock/attackby(obj/I, mob/user)
	if(istype(I, /obj/item/card/id))
		if(!card && user.unEquip(I))
			I.forceMove(src)
			card = I
			SStgui.update_uis(src)
			update_icon()
		else if(card)
			to_chat(user, span_warning("There is already ID card inside."))
		return
	. = ..()

/obj/machinery/computer/timeclock/attack_hand(var/mob/user as mob)
	if(..())
		return
	user.set_machine(src)
	tgui_interact(user)

/obj/machinery/computer/timeclock/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TimeClock", name)
		ui.open()

/obj/machinery/computer/timeclock/tgui_data(mob/user)
	var/list/data = ..()

	// Okay, data for showing the user's OWN PTO stuff
	if(user.client)
		data["department_hours"] = SANITIZE_LIST(user.client.department_hours)
	data["user_name"] = "[user]"

	// Data about the card that we put into it.
	data["card"] = null
	data["assignment"] = null
	data["job_datum"] = null
	data["allow_change_job"] = null
	data["job_choices"] = null
	if(card)
		data["card"] = "[card]"
		data["assignment"] = card.assignment
		data["card_cooldown"] = getCooldown()
		var/datum/job/job = job_master.GetJob(card.rank)
		if(job)
			data["job_datum"] = list(
				"title" = job.title,
				"departments" = english_list(job.departments),
				"selection_color" = job.selection_color,
				"economic_modifier" = job.economic_modifier,
				"timeoff_factor" = job.timeoff_factor,
				"pto_department" = job.pto_type
			)
		if(CONFIG_GET(flag/time_off) && CONFIG_GET(flag/pto_job_change))
			data["allow_change_job"] = TRUE
			if(job && job.timeoff_factor < 0) // Currently are Off Duty, so gotta lookup what on-duty jobs are open
				data["job_choices"] = getOpenOnDutyJobs(user, job.pto_type)

	return data

/obj/machinery/computer/timeclock/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	add_fingerprint(ui.user)

	switch(action)
		if("id")
			if(card)
				ui.user.put_in_hands(card)
				card = null
			else
				var/obj/item/I = ui.user.get_active_hand()
				if (istype(I, /obj/item/card/id) && ui.user.unEquip(I))
					I.forceMove(src)
					card = I
			update_icon()
			return TRUE
		if("switch-to-onduty-rank")
			if(checkFace(ui.user))
				if(checkCardCooldown(ui.user))
					makeOnDuty(params["switch-to-onduty-rank"], params["switch-to-onduty-assignment"], ui.user)
					ui.user.put_in_hands(card)
					card = null
			update_icon()
			return TRUE
		if("switch-to-offduty")
			if(checkFace(ui.user))
				if(checkCardCooldown(ui.user))
					makeOffDuty(ui.user)
					ui.user.put_in_hands(card)
					card = null
			update_icon()
			return TRUE

/obj/machinery/computer/timeclock/proc/getOpenOnDutyJobs(var/mob/user, var/department)
	var/list/available_jobs = list()
	for(var/datum/job/job in job_master.occupations)
		if(isOpenOnDutyJob(user, department, job))
			available_jobs[job.title] = list(job.title)
			if(job.alt_titles)
				for(var/alt_job in job.alt_titles)
					if(alt_job != job.title)
						available_jobs[job.title] += alt_job
	return available_jobs

/obj/machinery/computer/timeclock/proc/isOpenOnDutyJob(var/mob/user, var/department, var/datum/job/job)
	return job \
		   && job.is_position_available() \
		   && !job.whitelist_only \
		   && !jobban_isbanned(user,job.title) \
		   && job.player_old_enough(user.client) \
		   && job.player_has_enough_playtime(user.client) \
		   && job.pto_type == department \
		   && !job.disallow_jobhop \
		   && job.timeoff_factor > 0

/obj/machinery/computer/timeclock/proc/makeOnDuty(var/newrank, var/newassignment, var/mob/user)
	var/datum/job/oldjob = job_master.GetJob(card.rank)
	var/datum/job/newjob = job_master.GetJob(newrank)
	if(!oldjob || !isOpenOnDutyJob(user, oldjob.pto_type, newjob))
		return
	if(newassignment != newjob.title && !(newassignment in newjob.alt_titles))
		return
	if(newjob)
		card.access = newjob.get_access()
		card.rank = newjob.title
		card.assignment = newassignment
		card.name = text("[card.registered_name]'s ID Card ([card.assignment])")
		data_core.manifest_modify(card.registered_name, card.assignment, card.rank)
		card.last_job_switch = world.time
		callHook("reassign_employee", list(card))
		newjob.current_positions++
		var/mob/living/carbon/human/H = user
		H.mind.assigned_role = card.rank
		H.mind.role_alt_title = card.assignment
		announce.autosay("[card.registered_name] has moved On-Duty as [card.assignment].", "Employee Oversight", channel, zlevels = using_map.get_map_levels(get_z(src)))
	return

/obj/machinery/computer/timeclock/proc/makeOffDuty(var/mob/user)
	var/datum/job/foundjob = job_master.GetJob(card.rank)
	if(!foundjob)
		return
	var/new_dept = foundjob.pto_type || PTO_CIVILIAN
	var/datum/job/ptojob = null
	for(var/datum/job/job in job_master.occupations)
		if(job.pto_type == new_dept && job.timeoff_factor < 0)
			ptojob = job
			break
	if(ptojob)
		var/oldtitle = card.assignment
		card.access = ptojob.get_access()
		card.rank = ptojob.title
		card.assignment = ptojob.title
		card.name = text("[card.registered_name]'s ID Card ([card.assignment])")
		data_core.manifest_modify(card.registered_name, card.assignment, card.rank)
		card.last_job_switch = world.time
		callHook("reassign_employee", list(card))
		var/mob/living/carbon/human/H = user
		H.mind.assigned_role = ptojob.title
		H.mind.role_alt_title = ptojob.title
		foundjob.current_positions--
		announce.autosay("[card.registered_name], [oldtitle], has moved Off-Duty.", "Employee Oversight", channel, zlevels = using_map.get_map_levels(get_z(src)))
	return

/obj/machinery/computer/timeclock/proc/checkCardCooldown(var/mob/user)
	if(!card)
		return FALSE
	var/time_left = getCooldown()
	if(time_left > 0)
		to_chat(user, "You need to wait another [round((time_left/10)/60, 1)] minute\s before you can switch.")
		return FALSE
	return TRUE

/obj/machinery/computer/timeclock/proc/getCooldown()
	return 10 MINUTES - (world.time - card.last_job_switch)

/obj/machinery/computer/timeclock/proc/checkFace(var/mob/user)
	if(!card)
		to_chat(user, span_notice("No ID is inserted."))
		return FALSE
	var/mob/living/carbon/human/H = user
	if(!(istype(H)))
		to_chat(user, span_warning("Invalid user detected. Access denied."))
		return FALSE
	else if((H.wear_mask && (H.wear_mask.flags_inv & HIDEFACE)) || (H.head && (H.head.flags_inv & HIDEFACE)))	//Face hiding bad
		to_chat(user, span_warning("Facial recognition scan failed due to physical obstructions. Access denied."))
		return FALSE
	else if(H.get_face_name() == "Unknown" || !(H.real_name == card.registered_name))
		to_chat(user, span_warning("Facial recognition scan failed. Access denied."))
		return FALSE
	else
		return TRUE

/obj/item/card/id
	var/last_job_switch

/obj/item/card/id/New()
	.=..()
	last_job_switch = world.time

//
// Frame type for construction
//
/datum/frame/frame_types/timeclock_terminal
	name = "Timeclock Terminal"
	frame_class = FRAME_CLASS_DISPLAY
	frame_size = 2
	frame_style = FRAME_STYLE_WALL
	x_offset = 30
	y_offset = 30
	icon_override = 'icons/obj/machines/timeclock_vr.dmi'

/datum/frame/frame_types/timeclock_terminal/get_icon_state(var/state)
	return "timeclock_b[state]"

//
// Easy mapping
//
/obj/machinery/computer/timeclock/premade/north
	dir = 2
	pixel_y = 26

/obj/machinery/computer/timeclock/premade/south
	dir = 1
	pixel_y = -26

/obj/machinery/computer/timeclock/premade/east
	dir = 8
	pixel_x = 26

/obj/machinery/computer/timeclock/premade/west
	dir = 4
	pixel_x = -26
