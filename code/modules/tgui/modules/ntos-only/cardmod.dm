// This really should be used for both regular ID computers and NTOS, but
// the data structures are just different enough right now that I can't be assed
/datum/tgui_module/cardmod
	name = "ID card modification program"
	ntos = TRUE
	tgui_id = "IdentificationComputer"
	var/mod_mode = 1
	var/is_centcom = 0

/datum/tgui_module/cardmod/tgui_static_data(mob/user)
	var/list/data =  ..()
	if(data_core)
		data_core.get_manifest_list()
	data["manifest"] = PDA_Manifest
	return data

/datum/tgui_module/cardmod/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/datum/computer_file/program/card_mod/program = host
	if(!istype(program))
		return 0
	var/list/data = ..()
	data["station_name"] = station_name()
	data["mode"] = mod_mode
	data["printing"] = FALSE
	if(program && program.computer)
		data["have_id_slot"] = !!program.computer.card_slot
		data["have_printer"] = !!program.computer.nano_printer
		data["authenticated"] = program.can_run(user)
		if(!program.computer.card_slot)
			mod_mode = 0 //We can't modify IDs when there is no card reader
	else
		data["have_id_slot"] = 0
		data["have_printer"] = 0
		data["authenticated"] = 0
	data["centcom_access"] = is_centcom


	data["has_modify"] = null
	data["account_number"] = null
	data["id_rank"] = null
	data["target_owner"] = null
	data["target_name"] = null
	if(program && program.computer && program.computer.card_slot)
		var/obj/item/card/id/id_card = program.computer.card_slot.stored_card
		data["has_modify"] = !!id_card
		data["account_number"] = id_card ? id_card.associated_account_number : null
		data["id_rank"] = id_card && id_card.assignment ? id_card.assignment : "Unassigned"
		data["target_owner"] = id_card && id_card.registered_name ? id_card.registered_name : "-----"
		data["target_name"] = id_card ? id_card.name : "-----"

	var/list/departments = list()
	for(var/datum/department/dept as anything in SSjob.get_all_department_datums())
		if(!dept.assignable) // No AI ID cards for you.
			continue
		if(dept.centcom_only && !is_centcom)
			continue
		departments.Add(list(list(
			"department_name" = dept.name,
			"jobs" = format_jobs(SSjob.get_job_titles_in_department(dept.name)),
		)))

	data["departments"] = departments

	var/list/all_centcom_access = list()
	var/list/regions = list()
	if(program.computer.card_slot && program.computer.card_slot.stored_card)
		var/obj/item/card/id/id_card = program.computer.card_slot.stored_card
		if(is_centcom)
			for(var/access in get_all_centcom_access())
				all_centcom_access.Add(list(list(
					"desc" = replacetext(get_centcom_access_desc(access), " ", "&nbsp;"),
					"ref" = access,
					"allowed" = (access in id_card.access) ? 1 : 0)))
			data["all_centcom_access"] = all_centcom_access
		else
			for(var/i in ACCESS_REGION_SECURITY to ACCESS_REGION_SUPPLY)
				var/list/accesses = list()
				for(var/access in get_region_accesses(i))
					if(get_access_desc(access))
						accesses.Add(list(list(
							"desc" = replacetext(get_access_desc(access), " ", "&nbsp;"),
							"ref" = access,
							"allowed" = (access in id_card.access) ? 1 : 0)))

				regions.Add(list(list(
					"name" = get_region_accesses_name(i),
					"accesses" = accesses)))
			data["regions"] = regions

	data["regions"] = regions
	data["all_centcom_access"] = all_centcom_access

	return data

/datum/tgui_module/cardmod/proc/format_jobs(list/jobs)
	var/datum/computer_file/program/card_mod/program = host
	if(!istype(program))
		return null

	var/obj/item/card/id/id_card = program.computer.card_slot ? program.computer.card_slot.stored_card : null
	var/list/formatted = list()
	for(var/job in jobs)
		formatted.Add(list(list(
			"display_name" = replacetext(job, " ", "&nbsp;"),
			"target_rank" = id_card && id_card.assignment ? id_card.assignment : "Unassigned",
			"job" = job)))

	return formatted

/datum/tgui_module/cardmod/tgui_act(action, list/params, datum/tgui/ui)
	if(..())
		return TRUE


	var/datum/computer_file/program/card_mod/program = host
	if(!istype(program))
		return TRUE
	var/obj/item/modular_computer/computer = tgui_host()
	if(!istype(computer))
		return TRUE

	var/obj/item/card/id/user_id_card = usr.GetIdCard()
	var/obj/item/card/id/id_card
	if(computer.card_slot)
		id_card = computer.card_slot.stored_card

	switch(action)
		if("mode")
			mod_mode = clamp(text2num(params["mode_target"]), 0, 1)
			. = TRUE
		if("print")
			if(computer && computer.nano_printer) //This option should never be called if there is no printer
				if(!mod_mode)
					if(program.can_run(usr, 1))
						var/contents = {"<h4>Access Report</h4>
									<u>Prepared By:</u> [user_id_card.registered_name ? user_id_card.registered_name : "Unknown"]<br>
									<u>For:</u> [id_card.registered_name ? id_card.registered_name : "Unregistered"]<br>
									<hr>
									<u>Assignment:</u> [id_card.assignment]<br>
									<u>Account Number:</u> #[id_card.associated_account_number]<br>
									<u>Blood Type:</u> [id_card.blood_type]<br><br>
									<u>Access:</u><br>
								"}

						var/known_access_rights = get_access_ids(ACCESS_TYPE_STATION|ACCESS_TYPE_CENTCOM)
						for(var/A in id_card.access)
							if(A in known_access_rights)
								contents += "  [get_access_desc(A)]"

						if(!computer.nano_printer.print_text(contents,"access report"))
							to_chat(usr, "<span class='notice'>Hardware error: Printer was unable to print the file. It may be out of paper.</span>")
							return
						else
							computer.visible_message("<b>\The [computer]</b> prints out paper.")
				else
					var/contents = {"<h4>Crew Manifest</h4>
									<br>
									[data_core ? data_core.get_manifest(0) : ""]
									"}
					if(!computer.nano_printer.print_text(contents,text("crew manifest ([])", stationtime2text())))
						to_chat(usr, "<span class='notice'>Hardware error: Printer was unable to print the file. It may be out of paper.</span>")
						return
					else
						computer.visible_message("<b>\The [computer]</b> prints out paper.")
			. = TRUE
		if("modify")
			if(computer && computer.card_slot)
				if(id_card)
					data_core.manifest_modify(id_card.registered_name, id_card.assignment, id_card.rank)
				computer.proc_eject_id(usr)
			. = TRUE
		if("terminate")
			if(computer && program.can_run(usr, 1))
				id_card.assignment = "Dismissed"	//VOREStation Edit: setting adjustment
				id_card.access = list()
				callHook("terminate_employee", list(id_card))
			. = TRUE
		if("reg")
			if(computer && program.can_run(usr, 1))
				var/temp_name = sanitizeName(params["reg"], allow_numbers = TRUE)
				if(temp_name)
					id_card.registered_name = temp_name
				else
					computer.visible_message("<span class='notice'>[computer] buzzes rudely.</span>")
			. = TRUE
		if("account")
			if(computer && program.can_run(usr, 1))
				var/account_num = text2num(params["account"])
				id_card.associated_account_number = account_num
			. = TRUE
		if("assign")
			if(computer && program.can_run(usr, 1) && id_card)
				var/t1 = params["assign_target"]
				if(t1 == "Custom")
					var/temp_t = sanitize(tgui_input_text(usr, "Enter a custom job assignment.","Assignment", id_card.assignment, 45), 45)
					//let custom jobs function as an impromptu alt title, mainly for sechuds
					if(temp_t)
						id_card.assignment = temp_t
				else
					var/list/access = list()
					if(is_centcom)
						access = get_centcom_access(t1)
					else
						var/datum/job/jobdatum
						for(var/jobtype in typesof(/datum/job))
							var/datum/job/J = new jobtype
							if(ckey(J.title) == ckey(t1))
								jobdatum = J
								break
						if(!jobdatum)
							to_chat(usr, "<span class='warning'>No log exists for this job: [t1]</span>")
							return

						access = jobdatum.get_access()

					id_card.access = access
					id_card.assignment = t1
					id_card.rank = t1

				callHook("reassign_employee", list(id_card))
			. = TRUE
		if("access")
			if(computer && program.can_run(usr, 1))
				var/access_type = text2num(params["access_target"])
				var/access_allowed = text2num(params["allowed"])
				if(access_type in get_access_ids(ACCESS_TYPE_STATION|ACCESS_TYPE_CENTCOM))
					id_card.access -= access_type
					if(!access_allowed)
						id_card.access += access_type
			. = TRUE

	if(id_card)
		id_card.name = text("[id_card.registered_name]'s ID Card ([id_card.assignment])")

