//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32


/*
	Telecomms monitor tracks the overall trafficing of a telecommunications network
	and displays a heirarchy of linked machines.
*/

/obj/machinery/computer/telecomms/monitor
	name = "Telecommunications Monitor"
	desc = "Used to traverse a telecommunication network. Helpful for debugging connection issues."
	icon_screen = "comm_monitor"

	var/screen = 0				// the screen number:
	var/list/machinelist = list()	// the machines located by the computer
	var/obj/machinery/telecomms/SelectedMachine
	circuit = /obj/item/weapon/circuitboard/comm_monitor

	var/network = "NULL"		// the network to probe

	var/list/temp = null				// temporary feedback messages

/obj/machinery/computer/telecomms/monitor/tgui_data(mob/user)
	var/list/data = list()

	data["network"] = network
	data["temp"] = temp


	var/list/machinelist = list()
	for(var/obj/machinery/telecomms/T in src.machinelist)
		machinelist.Add(list(list(
			"id" = T.id,
			"name" = T.name,
		)))
	data["machinelist"] = machinelistData

	data["selectedMachine"] = null
	if(SelectedMachine)
		data["selectedMachine"] = list(
			"id" = SelectedMachine.id,
			"name" = SelectedMachine.name,
		)
		var/list/links = list()
		for(var/obj/machinery/telecomms/T in SelectedMachine.links)
			if(!T.hide)
				links.Add(list(list(
					"id" = T.id,
					"name" = T.name
				)))
		data["selectedMachine"]["links"] = links
	return data

/obj/machinery/computer/telecomms/monitor/attack_hand(mob/user)
	if(stat & (BROKEN|NOPOWER))
		return
	tgui_interact(user)

/obj/machinery/computer/telecomms/monitor/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TelecommsMachineBrowser", name)
		ui.open()

/obj/machinery/computer/telecomms/monitor/tgui_act(action, params)
	if(..())
		return TRUE

	add_fingerprint(usr)

	switch(action)
		if("view")
			for(var/obj/machinery/telecomms/T in machinelist)
				if(T.id == params["id"])
					SelectedMachine = T
					break
			. = TRUE

		if("mainmenu")
			SelectedMachine = null
			. = TRUE

		if("release")
			machinelist = list()
			SelectedMachine = null
			. = TRUE

		if("scan")
			if(machinelist.len > 0)
				set_temp("FAILED: CANNOT PROBE WHEN BUFFER FULL", "bad")
				return TRUE

			for(var/obj/machinery/telecomms/T in range(25, src))
				if(T.network == network)
					machinelist.Add(T)

			if(!machinelist.len)
				set_temp("FAILED: UNABLE TO LOCATE NETWORK ENTITIES IN \[[network]\]", "bad")
			else
				set_temp("[machinelist.len] ENTITIES LOCATED & BUFFERED", "good")
			. = TRUE

		if("network")
			var/newnet = tgui_input_text(usr, "Which network do you want to view?", "Comm Monitor", network)
			if(newnet && ((usr in range(1, src) || issilicon(usr))))
				if(length(newnet) > 15)
					set_temp("FAILED: NETWORK TAG STRING TOO LENGTHY", "bad")
					return TRUE
				network = newnet
				machinelist = list()
				set_temp("NEW NETWORK TAG SET IN ADDRESS \[[network]\]", "good")

			. = TRUE

		if("cleartemp")
			temp = null
			. = TRUE


/obj/machinery/computer/telecomms/monitor/emag_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		playsound(src, 'sound/effects/sparks4.ogg', 75, 1)
		emagged = 1
		to_chat(user, "<span class='notice'>You you disable the security protocols</span>")
		src.updateUsrDialog()
		return 1

/obj/machinery/computer/telecomms/monitor/proc/set_temp(var/text, var/color = "average")
	temp = list("color" = color, "text" = text)
