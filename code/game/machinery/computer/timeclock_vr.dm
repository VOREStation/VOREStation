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
	circuit = /obj/item/weapon/circuitboard/timeclock
	clicksound = null

	var/obj/item/weapon/card/id/card // Inserted Id card
	var/obj/item/device/radio/intercom/announce	// Integreated announcer


/obj/machinery/computer/timeclock/New()
	announce = new /obj/item/device/radio/intercom(src)
	..()

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
	if(istype(I, /obj/item/weapon/card/id))
		if(!card && user.unEquip(I))
			I.forceMove(src)
			card = I
			SSnanoui.update_uis(src)
			update_icon()
		else if(card)
			to_chat(user, "<span class='warning'>There is already ID card inside.</span>")
		return
	. = ..()

/obj/machinery/computer/timeclock/attack_hand(var/mob/user as mob)
	if(..())
		return
	user.set_machine(src)
	ui_interact(user)

/obj/machinery/computer/timeclock/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	user.set_machine(src)

	var/list/data = list()
	// Okay, data for showing the user's OWN PTO stuff
	if(user.client)
		data["department_hours"] = SANITIZE_LIST(user.client.department_hours)
	data["user_name"] = "[user]"

	// Data about the card that we put into it.
	if(card)
		data["card"] = "[card]"
		data["assignment"] = card.assignment
		var/datum/job/job = job_master.GetJob(card.rank)
		if (job)
			data["job_datum"] = list(
				"title" = job.title,
				"departments" = english_list(job.departments),
				"selection_color" = job.selection_color,
				"economic_modifier" = job.economic_modifier,
				"timeoff_factor" = job.timeoff_factor,
				"pto_department" = job.pto_type
			)
		if(config.time_off && config.pto_job_change)
			data["allow_change_job"] = TRUE
			if(job && job.timeoff_factor < 0) // Currently are Off Duty, so gotta lookup what on-duty jobs are open
				data["job_choices"] = getOpenOnDutyJobs(user, job.pto_type)

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "timeclock_vr.tmpl", capitalize(src.name), 500, 520)
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/computer/timeclock/Topic(href, href_list)
	if(..())
		return 1
	usr.set_machine(src)
	src.add_fingerprint(usr)

	if (href_list["id"])
		if(card)
			usr.put_in_hands(card)
			card = null
		else
			var/obj/item/I = usr.get_active_hand()
			if (istype(I, /obj/item/weapon/card/id) && usr.unEquip(I))
				I.forceMove(src)
				card = I
		update_icon()
		return 1
	if(href_list["switch-to-onduty"])
		if(card)
			if(checkFace())
				if(checkCardCooldown())
					makeOnDuty(href_list["switch-to-onduty"])
					usr.put_in_hands(card)
					card = null
		update_icon()
		return 1
	if(href_list["switch-to-offduty"])
		if(card)
			if(checkFace())
				if(checkCardCooldown())
					makeOffDuty()
					usr.put_in_hands(card)
					card = null
		update_icon()
		return 1
	return 1 // Return 1 to update UI

/obj/machinery/computer/timeclock/proc/getOpenOnDutyJobs(var/mob/user, var/department)
	var/list/available_jobs = list()
	for(var/datum/job/job in job_master.occupations)
		if(job && job.is_position_available() && !job.whitelist_only && !jobban_isbanned(user,job.title) && job.player_old_enough(user.client))
			if(job.pto_type == department && !job.disallow_jobhop && job.timeoff_factor > 0)
				available_jobs += job.title
				if(job.alt_titles)
					for(var/alt_job in job.alt_titles)
						if(alt_job != job.title)
							available_jobs += alt_job
	return available_jobs

/obj/machinery/computer/timeclock/proc/makeOnDuty(var/newjob)
	var/datum/job/foundjob = job_master.GetJob(card.rank)
	if(!newjob in getOpenOnDutyJobs(usr, foundjob.pto_type))
		return
	if(foundjob && card)
		card.access = foundjob.get_access()
		card.rank = foundjob.title
		card.assignment = newjob
		card.name = text("[card.registered_name]'s ID Card ([card.assignment])")
		data_core.manifest_modify(card.registered_name, card.assignment)
		card.last_job_switch = world.time
		callHook("reassign_employee", list(card))
		foundjob.current_positions++
		var/mob/living/carbon/human/H = usr
		H.mind.assigned_role = foundjob.title
		H.mind.role_alt_title = newjob
		announce.autosay("[card.registered_name] has moved On-Duty as [card.assignment].", "Employee Oversight")
	return

/obj/machinery/computer/timeclock/proc/makeOffDuty()
	var/datum/job/foundjob = job_master.GetJob(card.rank)
	if(!foundjob)
		return
	var/new_dept = foundjob.pto_type || PTO_CIVILIAN
	var/datum/job/ptojob = null
	for(var/datum/job/job in job_master.occupations)
		if(job.pto_type == new_dept && job.timeoff_factor < 0)
			ptojob = job
			break
	if(ptojob && card)
		var/oldtitle = card.assignment
		card.access = ptojob.get_access()
		card.rank = ptojob.title
		card.assignment = ptojob.title
		card.name = text("[card.registered_name]'s ID Card ([card.assignment])")
		data_core.manifest_modify(card.registered_name, card.assignment)
		card.last_job_switch = world.time
		callHook("reassign_employee", list(card))
		var/mob/living/carbon/human/H = usr
		H.mind.assigned_role = ptojob.title
		H.mind.role_alt_title = ptojob.title
		foundjob.current_positions--
		announce.autosay("[card.registered_name], [oldtitle], has moved Off-Duty.", "Employee Oversight")
	return

/obj/machinery/computer/timeclock/proc/checkCardCooldown()
	if(!card)
		return FALSE
	if((world.time - card.last_job_switch) < 15 MINUTES)
		to_chat(usr, "You need to wait at least 15 minutes after last duty switch.")
		return FALSE
	return TRUE

/obj/machinery/computer/timeclock/proc/checkFace()
	if(!card)
		to_chat(usr, "<span class='notice'>No ID is inserted.</span>")
		return FALSE
	var/mob/living/carbon/human/H = usr
	if(!(istype(H)))
		to_chat(usr, "<span class='warning'>Invalid user detected. Access denied.</span>")
		return FALSE
	else if((H.wear_mask && (H.wear_mask.flags_inv & HIDEFACE)) || (H.head && (H.head.flags_inv & HIDEFACE)))	//Face hiding bad
		to_chat(usr, "<span class='warning'>Facial recognition scan failed due to physical obstructions. Access denied.</span>")
		return FALSE
	else if(H.get_face_name() == "Unknown" || !(H.real_name == card.registered_name))
		to_chat(usr, "<span class='warning'>Facial recognition scan failed. Access denied.</span>")
		return FALSE
	else
		return TRUE

/obj/item/weapon/card/id
	var/last_job_switch

/obj/item/weapon/card/id/New()
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