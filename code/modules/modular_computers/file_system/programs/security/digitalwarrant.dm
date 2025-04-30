var/warrant_uid = 0
/datum/datacore
	var/list/warrants = list()

/datum/data/record/warrant
	var/warrant_id

/datum/data/record/warrant/New()
	..()
	warrant_id = warrant_uid++

/datum/computer_file/program/digitalwarrant
	filename = "digitalwarrant"
	filedesc = "Warrant Assistant"
	extended_desc = "Official NTsec program for creation and handling of warrants."
	size = 8
	program_icon_state = "warrant"
	program_key_state = "security_key"
	program_menu_icon = "star"
	requires_ntnet = TRUE
	available_on_ntnet = TRUE
	required_access = access_security
	usage_flags = PROGRAM_ALL
	tgui_id = "NtosDigitalWarrant"
	category = PROG_SEC

	var/datum/data/record/warrant/activewarrant

/datum/computer_file/program/digitalwarrant/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = get_header_data()

	data["warrantname"] = null
	data["warrantcharges"] = null
	data["warrantauth"] = null
	data["type"] = null

	if(activewarrant)
		data["warrantname"] = activewarrant.fields["namewarrant"]
		data["warrantcharges"] = activewarrant.fields["charges"]
		data["warrantauth"] = activewarrant.fields["auth"]
		data["type"] = activewarrant.fields["arrestsearch"]

	var/list/allwarrants = list()
	for(var/datum/data/record/warrant/W in GLOB.data_core.warrants)
		allwarrants.Add(list(list(
			"warrantname" = W.fields["namewarrant"],
			"charges" = "[copytext(W.fields["charges"],1,min(length(W.fields["charges"]) + 1, 50))]...",
			"auth" = W.fields["auth"],
			"id" = W.warrant_id,
			"arrestsearch" = W.fields["arrestsearch"]
		)))
	data["allwarrants"] = allwarrants

	return data

/datum/computer_file/program/digitalwarrant/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	switch(action)
		if("back")
			. = TRUE
			activewarrant = null

		if("editwarrant")
			. = TRUE
			for(var/datum/data/record/warrant/W in GLOB.data_core.warrants)
				if(W.warrant_id == text2num(params["id"]))
					activewarrant = W
					break

	// The following actions will only be possible if the user has an ID with security access equipped. This is in line with modular computer framework's authentication methods,
	// which also use RFID scanning to allow or disallow access to some functions. Anyone can view warrants, editing requires ID. This also prevents situations where you show a tablet
	// to someone who is to be arrested, which allows them to change the stuff there.
	var/obj/item/card/id/I = ui.user.GetIdCard()
	if(!istype(I) || !I.registered_name || !(access_security in I.GetAccess()))
		to_chat(ui.user, "Authentication error: Unable to locate ID with appropriate access to allow this operation.")
		return

	switch(action)
		if("addwarrant")
			. = TRUE
			var/datum/data/record/warrant/W = new()
			var/temp = tgui_alert(ui.user, "Do you want to create a search-, or an arrest warrant?", "Warrant Type", list("Search","Arrest","Cancel"))
			if(!temp)
				return
			if(tgui_status(ui.user, state) == STATUS_INTERACTIVE)
				if(temp == "Arrest")
					W.fields["namewarrant"] = "Unknown"
					W.fields["charges"] = "No charges present"
					W.fields["auth"] = "Unauthorized"
					W.fields["arrestsearch"] = "arrest"
				if(temp == "Search")
					W.fields["namewarrant"] = "No suspect/location given" // VOREStation edit
					W.fields["charges"] = "No reason given"
					W.fields["auth"] = "Unauthorized"
					W.fields["arrestsearch"] = "search"
				activewarrant = W

		if("savewarrant")
			. = TRUE
			GLOB.data_core.warrants |= activewarrant
			activewarrant = null

		if("deletewarrant")
			. = TRUE
			GLOB.data_core.warrants -= activewarrant
			activewarrant = null

		if("editwarrantname")
			. = TRUE
			var/namelist = list()
			for(var/datum/data/record/t in GLOB.data_core.general)
				namelist += t.fields["name"]
			var/new_name = sanitize(tgui_input_list(ui.user, "Please input name:", "Name Choice", namelist))
			if(tgui_status(ui.user, state) == STATUS_INTERACTIVE)
				if (!new_name)
					return
				activewarrant.fields["namewarrant"] = new_name

		if("editwarrantnamecustom")
			. = TRUE
			var/new_name = sanitize(tgui_input_text(ui.user, "Please input name"))
			if(tgui_status(ui.user, state) == STATUS_INTERACTIVE)
				if (!new_name)
					return
				activewarrant.fields["namewarrant"] = new_name

		if("editwarrantcharges")
			. = TRUE
			var/new_charges = sanitize(tgui_input_text(ui.user, "Please input charges", "Charges", activewarrant.fields["charges"]))
			if(tgui_status(ui.user, state) == STATUS_INTERACTIVE)
				if (!new_charges)
					return
				activewarrant.fields["charges"] = new_charges

		if("editwarrantauth")
			. = TRUE
			if(!(access_hos in I.GetAccess())) // VOREStation edit begin
				to_chat(ui.user, span_warning("You don't have the access to do this!"))
				return // VOREStation edit end
			activewarrant.fields["auth"] = "[I.registered_name] - [I.assignment ? I.assignment : "(Unknown)"]"
