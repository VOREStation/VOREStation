/obj/machinery/computer/shutoff_monitor
	name = "automated shutoff valve monitor"
	desc = "Console used to remotely monitor shutoff valves on the station."
	icon_keyboard = "power_key"
	icon_screen = "power:0"
	light_color = "#a97faa"
	circuit = /obj/item/weapon/circuitboard/shutoff_monitor

/obj/machinery/computer/shutoff_monitor/attack_hand(var/mob/user)
	..()
	ui_interact(user)

/obj/machinery/computer/shutoff_monitor/attack_robot(var/mob/user) // Borgs and AI will want to see this too
	..()
	ui_interact(user)

/obj/machinery/computer/shutoff_monitor/attack_ai(var/mob/user)
	ui_interact(user)

/obj/machinery/computer/shutoff_monitor/ui_interact(mob/user, ui_key = "shutoff_monitor", var/datum/nanoui/ui = null, var/force_open = 1, var/key_state = null)
	var/data[0]
	data["valves"] = list()
	for(var/obj/machinery/atmospherics/valve/shutoff/S in GLOB.shutoff_valves)
		data["valves"][++data["valves"].len] = list("name" = S.name, "enable" = S.close_on_leaks, "open" = S.open, "x" = S.x, "y" = S.y, "z" = S.z, "ref" = "\ref[S]")

	// update the ui if it exists, returns null if no ui is passed/found
	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		// the ui does not exist, so we'll create a new() one
        // for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "shutoff_monitor.tmpl", "Automated Shutoff Valve Monitor", 625, 700, state = key_state)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()
		// auto update every 20 Master Controller tick
		ui.set_auto_update(20) // Longer term to reduce the rate of data collection and processing

/obj/machinery/computer/shutoff_monitor/Topic(href, href_list)
	if(..())
		return 1

	if(href_list["toggle_enable"])
		var/obj/machinery/atmospherics/valve/shutoff/S = locate(href_list["toggle_enable"])

		// Invalid ref
		if(!istype(S))
			return 0

		S.close_on_leaks = !S.close_on_leaks

	if(href_list["toggle_open"])
		var/obj/machinery/atmospherics/valve/shutoff/S = locate(href_list["toggle_open"])

		// Invalid ref
		if(!istype(S))
			return 0

		if(S.open)
			S.close()
		else
			S.open()

	return


/obj/machinery/computer/shutoff_monitor/update_icon()
	..()
	if(!(stat & (NOPOWER|BROKEN)))
		overlays += image('icons/obj/computer.dmi', "ai-fixer-empty", overlay_layer)
