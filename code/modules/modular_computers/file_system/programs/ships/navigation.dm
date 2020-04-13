/datum/computer_file/program/ship_nav
	filename = "navviewer"
	filedesc = "Ship Navigational Screen"
	nanomodule_path = /datum/nano_module/program/ship/nav
	program_icon_state = "helm"
	program_key_state = "generic_key"
	program_menu_icon = "search"
	extended_desc = "Displays a ship's location in the sector."
	required_access = null
	requires_ntnet = 1
	network_destination = "ship position sensors"
	size = 4

/datum/nano_module/program/ship/nav
	name = "Navigation Display"

/datum/nano_module/program/ship/nav/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = default_state)
	if(!linked)
		to_chat(user, "<span class='warning'>You don't appear to be on a spaceship...</span>")
		if(program)
			program.kill_program()
		else if(ui)
			ui.close()
		return
	
	var/list/data = list()
	if(program)
		data = program.get_header_data()

	var/turf/T = get_turf(linked)
	var/obj/effect/overmap/visitable/sector/current_sector = locate() in T

	data["sector"] = current_sector ? current_sector.name : "Deep Space"
	data["sector_info"] = current_sector ? current_sector.desc : "Not Available"
	data["s_x"] = linked.x
	data["s_y"] = linked.y
	data["speed"] = round(linked.get_speed()*1000, 0.01)
	data["accel"] = round(linked.get_acceleration()*1000, 0.01)
	data["heading"] = linked.get_heading_degrees()
	data["viewing"] = viewing_overmap(user)

	if(linked.get_speed())
		data["ETAnext"] = "[round(linked.ETA()/10)] seconds"
	else
		data["ETAnext"] = "N/A"

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "nav.tmpl", "[linked.name] Navigation Screen", 380, 530, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/datum/nano_module/program/ship/nav/OnTopic(var/mob/user, var/list/href_list)
	if(..())
		return TOPIC_HANDLED

	if (!linked)
		return TOPIC_NOACTION

	if (href_list["viewing"])
		viewing_overmap(user) ? unlook(user) : look(user)
		return TOPIC_REFRESH
