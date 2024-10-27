/datum/computer_file/program/revelation
	filename = "revelation"
	filedesc = "Revelation"
	program_icon_state = "hostile"
	program_key_state = "security_key"
	program_menu_icon = "home"
	extended_desc = "This virus can destroy hard drive of system it is executed on. It may be obfuscated to look like another non-malicious program. Once armed, it will destroy the system upon next execution."
	size = 13
	requires_ntnet = FALSE
	available_on_ntnet = FALSE
	available_on_syndinet = TRUE
	tgui_id = "NtosRevelation"
	var/armed = 0

/datum/computer_file/program/revelation/run_program(var/mob/living/user)
	. = ..(user)
	if(armed)
		activate()

/datum/computer_file/program/revelation/proc/activate()
	if(!computer)
		return

	computer.visible_message(span_notice("\The [computer]'s screen brightly flashes and loud electrical buzzing is heard."))
	computer.enabled = 0
	computer.update_icon()
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(10, 1, computer.loc)
	s.start()

	if(computer.hard_drive)
		qdel(computer.hard_drive)

	if(computer.battery_module && prob(25))
		qdel(computer.battery_module)

	if(computer.tesla_link && prob(50))
		qdel(computer.tesla_link)

/datum/computer_file/program/revelation/tgui_act(action, params)
	if(..())
		return
	switch(action)
		if("PRG_arm")
			armed = !armed
			return TRUE
		if("PRG_activate")
			activate()
			return TRUE
		if("PRG_obfuscate")
			var/newname = params["new_name"]
			if(!newname)
				return
			filedesc = newname
			return TRUE

/datum/computer_file/program/revelation/clone()
	var/datum/computer_file/program/revelation/temp = ..()
	temp.armed = armed
	return temp

/datum/computer_file/program/revelation/tgui_data(mob/user)
	var/list/data = get_header_data()

	data["armed"] = armed

	return data
