/datum/tgui_module/scanner
	name = "Scanner"
	ntos = TRUE
	tgui_id = "Scanner"

/datum/tgui_module/scanner/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	var/datum/computer_file/program/scanner/program = host
	if(!istype(program))
		return 0
	
	if(program.computer.scanner)
		data["scanner_name"] = program.computer.scanner.name
		data["scanner_enabled"] = program.computer.scanner.enabled
		data["can_view_scan"] = program.computer.scanner.can_view_scan
		data["can_save_scan"] = (program.computer.scanner.can_save_scan && program.data_buffer)

	data["using_scanner"] = program.using_scanner
	data["check_scanning"] = program.check_scanning()
	//if(program.metadata_buffer.len > 0 && program.paper_type == /obj/item/weapon/paper/bodyscan)
		//data["data_buffer"] = display_medical_data(program.metadata_buffer.Copy(), user.get_skill_value(SKILL_MEDICAL, TRUE))
	//else
		//data["data_buffer"] = pencode2html(program.data_buffer)
	data["data_buffer"] = pencode2html(program.data_buffer)

	return data

/datum/tgui_module/scanner/tgui_act(action, list/params, datum/tgui/ui)
	if(..())
		return TRUE

	var/datum/computer_file/program/scanner/program = host
	if(!istype(program))
		return TRUE
	var/obj/item/modular_computer/computer = tgui_host()
	if(!istype(computer))
		return TRUE

	switch(action)
		if("connect_scanner")
			if(text2num(params["connect_scanner"]))
				if(!program.connect_scanner())
					to_chat(usr, "Scanner installation failed.")
			else
				program.disconnect_scanner()
			return 1

		if("PC_toggle_component")
			var/obj/item/weapon/computer_hardware/H = computer.find_hardware_by_name(params["name"])
			if(H && istype(H))
				H.enabled = !H.enabled

		if("scan")
			if(program.check_scanning())
				program.metadata_buffer.Cut()
				program.computer.scanner.run_scan(usr, program)
			return 1

		if("save")
			var/name = sanitize(input(usr, "Enter file name:", "Save As") as text|null)
			if(!program.save_scan(name))
				to_chat(usr, "Scan save failed.")

