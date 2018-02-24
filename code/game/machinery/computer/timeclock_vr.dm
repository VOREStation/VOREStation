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

	var/obj/item/weapon/card/id/card // Inserted Id card

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
			nanomanager.update_uis(src)
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
				"department" = job.department,
				"selection_color" = job.selection_color,
				"economic_modifier" = job.economic_modifier,
				"head_position" = job.head_position,
				"timeoff_factor" = job.timeoff_factor
			)
		// TODO - Once job changing is implemented, we will want to list jobs to change into.
		// if(job && job.timeoff_factor < 0) // Currently are Off Duty, so gotta lookup what on-duty jobs are open
		// 	data["job_choices"] = getOpenOnDutyJobs(user, job.department)

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
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
		if (card)
			usr.put_in_hands(card)
			card = null
		else
			var/obj/item/I = usr.get_active_hand()
			if (istype(I, /obj/item/weapon/card/id) && usr.unEquip(I))
				I.forceMove(src)
				card = I
		update_icon()
	return 1 // Return 1 to update UI

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
