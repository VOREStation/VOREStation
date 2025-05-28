/*
 * This file contains all of the UI code for the RD console.
 * It's moved off to this file for simplicity and understanding what is UI and what is functionality.
 */

#define ENTRIES_PER_RDPAGE 50

/obj/machinery/computer/rdconsole
	var/locked = FALSE
	var/busy_msg = null

	var/search = ""
	var/design_page = 0
	var/builder_page = 0

/obj/machinery/computer/rdconsole/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ResearchConsole", name)
		ui.open()

/obj/machinery/computer/rdconsole/tgui_status(mob/user)
	. = ..()
	if(locked && !allowed(user) && !emagged)
		. = min(., STATUS_UPDATE)
	if(busy_msg)
		. = min(., STATUS_UPDATE)

/obj/machinery/computer/rdconsole/tgui_static_data(mob/user)
	var/list/data = ..()

	data["sheet_material_amount"] = SHEET_MATERIAL_AMOUNT

	data["tech"] = tgui_GetResearchLevelsInfo()
	data["designs"] = tgui_GetDesignInfo(design_page)

	data["lathe_designs"] = tgui_GetProtolatheDesigns(linked_lathe, builder_page)
	data["imprinter_designs"] = tgui_GetImprinterDesigns(linked_imprinter, builder_page)

	return data

/obj/machinery/computer/rdconsole/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	data["locked"] = locked
	data["busy_msg"] = busy_msg
	data["search"] = search

	data["builder_page"] = builder_page
	data["design_page"] = design_page

	data["sync"] = sync
	data["is_public"] = is_public

	// Skip the rest of the data if it's locked
	if(locked)
		return data

	if(linked_destroy)
		data["linked_destroy"] = list(
			"loaded_item" = linked_destroy.loaded_item,
			"origin_tech" = tgui_GetOriginTechForItem(linked_destroy.loaded_item),
		)
	else
		data["linked_destroy"] = null

	if(linked_lathe)
		var/list/reagents = list()
		for(var/datum/reagent/R as anything in linked_lathe.reagents.reagent_list)
			UNTYPED_LIST_ADD(reagents, list(
				"name" = R.name,
				"id" = R.id,
				"volume" = R.volume
			))

		var/list/queue = list()
		var/i = 1
		for(var/datum/design/D as anything in linked_lathe.queue)
			UNTYPED_LIST_ADD(queue, list(
				"name" = D.name,
				"index" = i
			))
			i += 1

		data["linked_lathe"] = list(
			"total_materials" = linked_lathe.TotalMaterials(),
			"max_materials" = linked_lathe.max_material_storage,
			"total_volume" = linked_lathe.reagents.total_volume,
			"max_volume" = linked_lathe.reagents.maximum_volume,
			"busy" = linked_lathe.busy,
			"materials" = linked_lathe.materials,
			"reagents" = reagents,
			"queue" = queue,
		)
	else
		data["linked_lathe"] = null

	if(linked_imprinter)
		var/list/reagents = list()
		for(var/datum/reagent/R as anything in linked_imprinter.reagents.reagent_list)
			UNTYPED_LIST_ADD(reagents, list(
				"name" = R.name,
				"id" = R.id,
				"volume" = R.volume
			))

		var/list/queue = list()
		var/i = 1
		for(var/datum/design/D as anything in linked_imprinter.queue)
			UNTYPED_LIST_ADD(queue, list(
				"name" = D.name,
				"index" = i
			))
			i += 1

		data["linked_imprinter"] = list(
			"total_materials" = linked_imprinter.TotalMaterials(),
			"max_materials" = linked_imprinter.max_material_storage,
			"total_volume" = linked_imprinter.reagents.total_volume,
			"max_volume" = linked_imprinter.reagents.maximum_volume,
			"busy" = linked_imprinter.busy,
			"materials" = linked_imprinter.materials,
			"reagents" = reagents,
			"queue" = queue
		)
	else
		data["linked_imprinter"] = null

	if(t_disk)
		data["t_disk"] = list(
			"stored" = t_disk.stored ? list(
				"name" = t_disk.stored.name,
				"level" = t_disk.stored.level,
				"desc" = t_disk.stored.desc,
			) : null,
		)
	else
		data["t_disk"] = null

	if(d_disk)
		data["d_disk"] = list(
			"stored" = d_disk.blueprint ? list(
				"name" = d_disk.blueprint.name,
				"build_type" = d_disk.blueprint.build_type,
				"materials" = d_disk.blueprint.materials,
			) : null,
		)
	else
		data["d_disk"] = null

	return data

/obj/machinery/computer/rdconsole/proc/tgui_GetResearchLevelsInfo()
	var/list/data = list()
	for(var/datum/tech/T in files.known_tech)
		if(T.level < 1)
			continue
		data.Add(list(list(
			"name" = T.name,
			"level" = T.level,
			"desc" = T.desc,
			"id" = T.id,
		)))
	return data

/obj/machinery/computer/rdconsole/proc/tgui_GetOriginTechForItem(obj/item/I)
	if(!istype(I))
		return list()

	var/list/data = list()
	for(var/T in I.origin_tech)
		var/list/subdata = list(
			"name" = CallTechName(T),
			"level" = I.origin_tech[T],
			"current" = null,
		)
		for(var/datum/tech/F in files.known_tech)
			if(F.name == CallTechName(T))
				subdata["current"] = F.level
				break
		data.Add(list(subdata))

	return data

/proc/cmp_designs_rdconsole(list/A, list/B)
	return sorttext(B["name"], A["name"])

/obj/machinery/computer/rdconsole/proc/tgui_GetProtolatheDesigns(obj/machinery/r_n_d/protolathe/P, page)
	if(!istype(P))
		return list()

	var/list/data = list()
	// For some reason, this is faster than direct access.
	var/list/known_designs = files.known_designs
	for(var/datum/design/D in known_designs)
		if(!D.build_path || !(D.build_type & PROTOLATHE))
			continue
		if(search && !findtext(D.name, search))
			continue

		var/list/mat_list = list()
		for(var/M in D.materials)
			mat_list.Add("[D.materials[M] * P.mat_efficiency] [CallMaterialName(M)]")

		var/list/chem_list = list()
		for(var/T in D.chemicals)
			chem_list.Add("[D.chemicals[T] * P.mat_efficiency] [CallReagentName(T)]")

		data.Add(list(list(
			"name" = D.name,
			"id" = D.id,
			"mat_list" = mat_list,
			"chem_list" = chem_list,
		)))

	data = sortTim(data, GLOBAL_PROC_REF(cmp_designs_rdconsole), FALSE)
	if((ENTRIES_PER_RDPAGE * page) > LAZYLEN(data))
		return null

	if(LAZYLEN(data) > ENTRIES_PER_RDPAGE)
		var/first_index = clamp(ENTRIES_PER_RDPAGE * page, 1, LAZYLEN(data))
		var/last_index  = min((ENTRIES_PER_RDPAGE * page) + ENTRIES_PER_RDPAGE, LAZYLEN(data) + 1)

		data = data.Copy(first_index, last_index)

	return data


/obj/machinery/computer/rdconsole/proc/tgui_GetImprinterDesigns(obj/machinery/r_n_d/circuit_imprinter/P, page)
	if(!istype(P))
		return list()

	var/list/data = list()
	// For some reason, this is faster than direct access.
	var/list/known_designs = files.known_designs
	for(var/datum/design/D in known_designs)
		if(!D.build_path || !(D.build_type & IMPRINTER))
			continue
		if(search && !findtext(D.name, search))
			continue

		var/list/mat_list = list()
		for(var/M in D.materials)
			mat_list.Add("[D.materials[M] * P.mat_efficiency] [CallMaterialName(M)]")

		var/list/chem_list = list()
		for(var/T in D.chemicals)
			chem_list.Add("[D.chemicals[T] * P.mat_efficiency] [CallReagentName(T)]")

		data.Add(list(list(
			"name" = D.name,
			"id" = D.id,
			"mat_list" = mat_list,
			"chem_list" = chem_list,
		)))

	data = sortTim(data, GLOBAL_PROC_REF(cmp_designs_rdconsole), FALSE)
	if((ENTRIES_PER_RDPAGE * page) > LAZYLEN(data))
		return null

	if(LAZYLEN(data) > ENTRIES_PER_RDPAGE)
		var/first_index = clamp(ENTRIES_PER_RDPAGE * page, 1, LAZYLEN(data))
		var/last_index  = min((ENTRIES_PER_RDPAGE * page) + ENTRIES_PER_RDPAGE, LAZYLEN(data) + 1)

		data = data.Copy(first_index, last_index)

	return data

/obj/machinery/computer/rdconsole/proc/tgui_GetDesignInfo(page)
	var/list/data = list()
	// For some reason, this is faster than direct access.
	var/list/known_designs = files.known_designs
	for(var/datum/design/D in known_designs)
		if(search && !findtext(D.name, search))
			continue
		if(D.build_path)
			data.Add(list(list(
				"name" = D.name,
				"desc" = D.desc,
				"id" = D.id,
			)))


	data = sortTim(data, GLOBAL_PROC_REF(cmp_designs_rdconsole), FALSE)
	if((ENTRIES_PER_RDPAGE * page) > LAZYLEN(data))
		return null

	if(LAZYLEN(data) > ENTRIES_PER_RDPAGE)
		var/first_index = clamp(ENTRIES_PER_RDPAGE * page, 1, LAZYLEN(data))
		var/last_index  = clamp((ENTRIES_PER_RDPAGE * page) + ENTRIES_PER_RDPAGE, 1, LAZYLEN(data) + 1)

		data = data.Copy(first_index, last_index)

	return data

/obj/machinery/computer/rdconsole/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	add_fingerprint(ui.user)

	switch(action)
		if("search")
			search = params["search"]
			update_static_data_for_all_viewers()
			return TRUE
		if("design_page")
			if(params["reset"])
				design_page = 0
			else
				design_page = max(design_page + (1 * params["reverse"]), 0)
			update_static_data_for_all_viewers()
			return TRUE
		if("builder_page")
			if(params["reset"])
				builder_page = 0
			else
				builder_page = max(builder_page + (1 * params["reverse"]), 0)
			update_static_data_for_all_viewers()
			return TRUE

		if("updt_tech") //Update the research holder with information from the technology disk.
			busy_msg = "Updating Database..."
			spawn(5 SECONDS)
				busy_msg = null
				files.AddTech2Known(t_disk.stored)
				files.RefreshResearch()
				griefProtection() //Update CentCom too
				update_static_data_for_all_viewers()
			return TRUE

		if("clear_tech") //Erase data on the technology disk.
			t_disk.stored = null
			return TRUE

		if("eject_tech") //Eject the technology disk.
			t_disk.loc = loc
			t_disk = null
			return TRUE

		if("copy_tech") //Copys some technology data from the research holder to the disk.
			for(var/datum/tech/T in files.known_tech)
				if(params["copy_tech_ID"] == T.id)
					t_disk.stored = T
					break
			return TRUE

		if("updt_design") //Updates the research holder with design data from the design disk.
			busy_msg = "Updating Database..."
			spawn(5 SECONDS)
				busy_msg = null
				files.AddDesign2Known(d_disk.blueprint)
				griefProtection() //Update CentCom too
				update_static_data_for_all_viewers()
			return TRUE

		if("clear_design") //Erases data on the design disk.
			d_disk.blueprint = null
			return TRUE

		if("eject_design") //Eject the design disk.
			d_disk.loc = loc
			d_disk = null
			return TRUE

		if("copy_design") //Copy design data from the research holder to the design disk.
			for(var/datum/design/D in files.known_designs)
				if(params["copy_design_ID"] == D.id)
					d_disk.blueprint = D
					break
			return TRUE

		if("eject_item") //Eject the item inside the destructive analyzer.
			if(linked_destroy)
				if(linked_destroy.busy)
					to_chat(ui.user, span_notice("The destructive analyzer is busy at the moment."))
					return FALSE

				if(linked_destroy.loaded_item)
					linked_destroy.loaded_item.loc = linked_destroy.loc
					linked_destroy.loaded_item = null
					linked_destroy.icon_state = "d_analyzer"
				return TRUE

		if("deconstruct") //Deconstruct the item in the destructive analyzer and update the research holder.
			if(!linked_destroy)
				return FALSE

			if(linked_destroy.busy)
				to_chat(ui.user, span_notice("The destructive analyzer is busy at the moment."))
				return

			linked_destroy.busy = 1
			busy_msg = "Processing and Updating Database..."
			flick("d_analyzer_process", linked_destroy)
			spawn(2.4 SECONDS)
				if(linked_destroy)
					linked_destroy.busy = 0
					busy_msg = null
					if(!linked_destroy.loaded_item)
						to_chat(ui.user, span_notice("The destructive analyzer appears to be empty."))
						return

					if(istype(linked_destroy.loaded_item,/obj/item/stack))//Only deconsturcts one sheet at a time instead of the entire stack
						var/obj/item/stack/ST = linked_destroy.loaded_item
						if(ST.get_amount() < 1)
							playsound(linked_destroy, 'sound/machines/destructive_analyzer.ogg', 50, 1)
							qdel(ST)
							linked_destroy.icon_state = "d_analyzer"
							return

					for(var/T in linked_destroy.loaded_item.origin_tech)
						files.UpdateTech(T, linked_destroy.loaded_item.origin_tech[T])
					if(linked_lathe && linked_destroy.loaded_item.matter) // Also sends salvaged materials to a linked protolathe, if any.
						for(var/t in linked_destroy.loaded_item.matter)
							if(t in linked_lathe.materials)
								linked_lathe.materials[t] += min(linked_lathe.max_material_storage - linked_lathe.TotalMaterials(), linked_destroy.loaded_item.matter[t] * linked_destroy.decon_mod)


					linked_destroy.loaded_item = null
					for(var/obj/I in linked_destroy.contents)
						for(var/mob/M in I.contents)
							playsound(linked_destroy, 'sound/machines/destructive_analyzer.ogg', 50, 1)
							M.death()
						if(istype(I,/obj/item/stack/material))//Only deconsturcts one sheet at a time instead of the entire stack
							var/obj/item/stack/material/S = I
							if(S.get_amount() > 1)
								playsound(linked_destroy, 'sound/machines/destructive_analyzer.ogg', 50, 1)
								S.use(1)
								linked_destroy.loaded_item = S
							else
								playsound(linked_destroy, 'sound/machines/destructive_analyzer.ogg', 50, 1)
								qdel(S)
								linked_destroy.icon_state = "d_analyzer"
						else
							if(I != linked_destroy.circuit && !(I in linked_destroy.component_parts))
								playsound(linked_destroy, 'sound/machines/destructive_analyzer.ogg', 50, 1)
								qdel(I)
								linked_destroy.icon_state = "d_analyzer"

					use_power(linked_destroy.active_power_usage)
					files.RefreshResearch()
					update_static_data_for_all_viewers()
			return TRUE

		if("lock") //Lock the console from use by anyone without tox access.
			if(!allowed(ui.user))
				to_chat(ui.user, "Unauthorized Access.")
				return
			locked = !locked
			return TRUE

		if("sync") //Sync the research holder with all the R&D consoles in the game that aren't sync protected.
			if(!sync)
				to_chat(ui.user, span_notice("You must connect to the network first."))
				return

			busy_msg = "Updating Database..."
			griefProtection() //Putting this here because I dont trust the sync process
			spawn(3 SECONDS)
				if(src)
					for(var/obj/machinery/r_n_d/server/S in GLOB.machines)
						var/server_processed = 0
						if((id in S.id_with_upload) || istype(S, /obj/machinery/r_n_d/server/centcom))
							for(var/datum/tech/T in files.known_tech)
								S.files.AddTech2Known(T)
							for(var/datum/design/D in files.known_designs)
								S.files.AddDesign2Known(D)
							S.files.RefreshResearch()
							server_processed = 1
						if((id in S.id_with_download) && !istype(S, /obj/machinery/r_n_d/server/centcom))
							for(var/datum/tech/T in S.files.known_tech)
								files.AddTech2Known(T)
							for(var/datum/design/D in S.files.known_designs)
								files.AddDesign2Known(D)
							server_processed = 1
						if(!istype(S, /obj/machinery/r_n_d/server/centcom) && server_processed)
							S.produce_heat()
					busy_msg = null
					files.RefreshResearch()
					update_static_data_for_all_viewers()
			return TRUE

		if("togglesync") //Prevents the console from being synced by other consoles. Can still send data.
			sync = !sync
			return TRUE

		if("build") //Causes the Protolathe to build something.
			if(linked_lathe)
				var/datum/design/being_built = null
				for(var/datum/design/D in files.known_designs)
					if(D.id == params["build"])
						being_built = D
						break
				if(being_built)
					linked_lathe.addToQueue(being_built)
				return TRUE

		if("buildfive") //Causes the Protolathe to build 5 of something.
			if(linked_lathe)
				var/datum/design/being_built = null
				for(var/datum/design/D in files.known_designs)
					if(D.id == params["build"])
						being_built = D
						break
				if(being_built)
					for(var/i = 1 to 5)
						linked_lathe.addToQueue(being_built)
				return TRUE

		if("imprint") //Causes the Circuit Imprinter to build something.
			if(linked_imprinter)
				var/datum/design/being_built = null
				for(var/datum/design/D in files.known_designs)
					if(D.id == params["imprint"])
						being_built = D
						break
				if(being_built)
					linked_imprinter.addToQueue(being_built)
				return TRUE

		if("disposeI")  //Causes the circuit imprinter to dispose of a single reagent (all of it)
			if(!linked_imprinter)
				return
			linked_imprinter.reagents.del_reagent(params["dispose"])
			return TRUE

		if("disposeallI") //Causes the circuit imprinter to dispose of all it's reagents.
			if(!linked_imprinter)
				return
			linked_imprinter.reagents.clear_reagents()
			return TRUE

		if("removeI")
			if(!linked_imprinter)
				return
			linked_imprinter.removeFromQueue(text2num(params["removeI"]))
			return TRUE

		if("imprinter_ejectsheet") //Causes the imprinter to eject a sheet of material
			if(!linked_imprinter)
				return
			linked_imprinter.eject(params["imprinter_ejectsheet"], text2num(params["amount"]))
			return TRUE

		if("disposeP")  //Causes the protolathe to dispose of a single reagent (all of it)
			if(!linked_lathe)
				return
			linked_lathe.reagents.del_reagent(params["dispose"])
			return TRUE

		if("disposeallP") //Causes the protolathe to dispose of all it's reagents.
			if(!linked_lathe)
				return
			linked_lathe.reagents.clear_reagents()
			return TRUE

		if("removeP")
			if(!linked_lathe)
				return
			linked_lathe.removeFromQueue(text2num(params["removeP"]))
			return TRUE

		if("lathe_ejectsheet") //Causes the protolathe to eject a sheet of material
			if(!linked_lathe)
				return
			linked_lathe.eject(params["lathe_ejectsheet"], text2num(params["amount"]))
			return TRUE

		if("find_device") //The R&D console looks for devices nearby to link up with.
			busy_msg = "Updating Database..."

			spawn(10)
				busy_msg = null
				SyncRDevices()
				update_static_data_for_all_viewers()
			return TRUE

		if("disconnect") //The R&D console disconnects with a specific device.
			switch(params["disconnect"])
				if("destroy")
					linked_destroy.linked_console = null
					linked_destroy = null
				if("lathe")
					linked_lathe.linked_console = null
					linked_lathe = null
				if("imprinter")
					linked_imprinter.linked_console = null
					linked_imprinter = null
			update_static_data_for_all_viewers()

		if("reset") //Reset the R&D console's database.
			griefProtection()
			var/choice = tgui_alert(ui.user, "R&D Console Database Reset", "Are you sure you want to reset the R&D console's database? Data lost cannot be recovered.", list("Continue", "Cancel"))
			if(choice == "Continue")
				busy_msg = "Updating Database..."
				qdel(files)
				files = new /datum/research(src)
				spawn(20)
					busy_msg = null
					update_static_data_for_all_viewers()

		if("print") //Print research information
			busy_msg = "Printing Research Information. Please Wait..."
			spawn(20)
				var/obj/item/paper/PR = new/obj/item/paper
				PR.name = "list of researched technologies"
				PR.info = "<center><b>[station_name()] Science Laboratories</b>"
				PR.info += "<h2>[ (text2num(params["print"]) == 2) ? "Detailed" : null] Research Progress Report</h2>"
				PR.info += "<i>report prepared at [stationtime2text()] station time</i></center><br>"
				if(text2num(params["print"]) == 2)
					PR.info += GetResearchListInfo()
				else
					PR.info += GetResearchLevelsInfo()
				PR.info_links = PR.info
				PR.icon_state = "paper_words"
				PR.forceMove(loc)
				busy_msg = null

#undef ENTRIES_PER_RDPAGE
