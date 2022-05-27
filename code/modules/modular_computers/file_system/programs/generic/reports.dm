#define REPORTS_VIEW      1
#define REPORTS_DOWNLOAD  2

/datum/computer_file/program/reports
	filename = "repview"
	filedesc = "Report Editor"
	tgui_id = "NtosReports"
	extended_desc = "A general paperwork viewing and editing utility."
	size = 2
	available_on_ntnet = TRUE
	requires_ntnet = FALSE
	usage_flags = PROGRAM_ALL
	category = PROG_OFFICE

	var/can_view_only = FALSE                           // Whether we are in view-only mode.
	var/datum/computer_file/report/selected_report      // A report being viewed/edited. This is a temporary copy.
	var/datum/computer_file/report/saved_report         // The computer file currently open.
	var/prog_state = REPORTS_VIEW

/datum/computer_file/program/reports/tgui_act(action, list/params, datum/tgui/ui)
	if(..())
		return TRUE
	var/mob/user = usr

	switch(action)
		//if(text2num(href_list["warning"])) //Gives the user a chance to avoid losing unsaved reports.
			//if(alert(user, "Are you sure you want to leave this page? Unsubmitted data will be lost.",, "Yes.", "No.") == "No.")
				//return TOPIC_HANDLED //If yes, proceed to the actual action instead.

		if("load")
			if(selected_report || saved_report)
				close_report()
			load_report(user)
			return TOPIC_HANDLED
		if("save")
			. = TOPIC_HANDLED
			if(!selected_report)
				return
			//if(!selected_report.verify_access(get_access(user)))
				//return
			var/save_as = text2num(params["save_as"])
			save_report(user, save_as)
			return
		if("submit")
			. = TOPIC_HANDLED
			if(!selected_report)
				return
			//if(!selected_report.verify_access_edit(get_access(user)))
				//return
			if(selected_report.submit(user))
				to_chat(user, "The [src] has been submitted.")
				if(alert(user, "Would you like to save a copy?","Save Report", "Yes.", "No.") == "Yes.")
					save_report(user)
			return
		if("discard")
			. = TOPIC_HANDLED
			if(!selected_report)
				return
			close_report()
			return
		if("edit")
			. = TOPIC_HANDLED
			if(!selected_report)
				return
			var/field_ID = text2num(params["ID"])
			var/datum/report_field/field = selected_report.field_from_ID(field_ID)
			//if(!field || !field.verify_access_edit(get_access(user)))
				//return
			field.ask_value(user) //Handles the remaining IO.
			return
		if("print")
			. = TOPIC_HANDLED
			//if(!selected_report || !selected_report.verify_access(get_access(user)))
				//return
			var/with_fields = text2num(params["print_mode"])
			//var/text = selected_report.generate_pencode(get_access(user), with_fields)
			var/text = selected_report.generate_pencode(access_heads, with_fields)
			//if(!program.computer.print_paper(text, selected_report.display_name()))
			//if(!computer.print_paper(text, selected_report.display_name()))
				//to_chat(user, "Hardware error: Printer was unable to print the file. It may be out of paper.")
			return
		if("export")
			. = TOPIC_HANDLED
			//if(!selected_report || !selected_report.verify_access(get_access(user)))
				//return
			selected_report.rename_file()
			var/datum/computer_file/data/text/file = new
			file.filename = selected_report.filename
			//file.stored_data = selected_report.generate_pencode(get_access(user), no_html = TRUE) //TXT files can't have html; they use pencode only.
			file.stored_data = selected_report.generate_pencode(access_heads, no_html = TRUE)
			//if(!program.computer.create_file(file))
			//if(!computer.create_file(file))
				//to_chat(user, "Error storing file. Please check your hard drive.")
			//else
				//to_chat(user, "The report has been exported as [file.filename].[file.filetype]")
			return

		if("download")
			switch_state(REPORTS_DOWNLOAD)
			return TOPIC_HANDLED
		if("get_report")
			. = TOPIC_HANDLED
			var/uid = text2num(params["report"])
			//for(var/datum/computer_file/report/report in ntnet_global.fetch_reports(get_access(user)))
			for(var/datum/computer_file/report/report in ntnet_global.fetch_reports(access_heads))
				if(report.uid == uid)
					selected_report = report.clone()
					can_view_only = FALSE
					switch_state(REPORTS_VIEW)
					return
			to_chat(user, "Network error: Selected report could not be downloaded. Check network functionality and credentials.")
			return
		if("home")
			switch_state(REPORTS_VIEW)
			return TOPIC_HANDLED

/datum/computer_file/program/reports/tgui_data(mob/user)
	var/list/data = get_header_data()

	data["prog_state"] = prog_state
	switch(prog_state)
		if(REPORTS_VIEW)
			if(selected_report)
				//data["report_data"] = selected_report.generate_nano_data(get_access(user))
				data["report_data"] = selected_report.generate_nano_data(access_heads)
			data["view_only"] = can_view_only
			//data["printer"] = program.computer.has_component(PART_PRINTER)
			data["printer"] = null
		if(REPORTS_DOWNLOAD)
			var/list/L = list()
			//for(var/datum/computer_file/report/report in ntnet_global.fetch_reports(get_access(user)))
			for(var/datum/computer_file/report/report in ntnet_global.fetch_reports(access_heads))
				var/M = list()
				M["name"] = report.display_name()
				M["uid"] = report.uid
				L += list(M)
			data["reports"] = L

	return data

/datum/computer_file/program/reports/proc/switch_state(new_state)
	if(prog_state == new_state)
		return
	switch(new_state)
		if(REPORTS_VIEW)
			//program.requires_ntnet_feature = null
			//program.requires_ntnet = FALSE
			requires_ntnet_feature = null
			requires_ntnet = FALSE
			prog_state = REPORTS_VIEW
		if(REPORTS_DOWNLOAD)
			close_report()
			//program.requires_ntnet_feature = NTNET_SOFTWAREDOWNLOAD
			//program.requires_ntnet = TRUE
			requires_ntnet_feature = NTNET_SOFTWAREDOWNLOAD
			requires_ntnet = TRUE
			prog_state = REPORTS_DOWNLOAD

/datum/computer_file/program/reports/proc/close_report()
	QDEL_NULL(selected_report)
	saved_report = null

/datum/computer_file/program/reports/proc/save_report(mob/user, save_as)
	//if(!program.computer || !program.computer.has_component(PART_HDD))
	//if(!computer || !computer.has_component(PART_HDD))
		//to_chat(user, "Unable to find hard drive.")
		//return
	selected_report.rename_file()
	//if(!program.computer.create_file(selected_report))
	//if(!computer.create_file(selected_report))
		//to_chat(user, "Error storing file. Please check your hard drive.")
		//return
	saved_report = selected_report
	selected_report = saved_report.clone()
	to_chat(user, "The report has been saved as [saved_report.filename].[saved_report.filetype]")

/datum/computer_file/program/reports/proc/load_report(mob/user)
	//if(!program.computer || !program.computer.has_component(PART_HDD))
	//if(!computer || !computer.has_component(PART_HDD))
		//to_chat(user, "Unable to find hard drive.")
		//return
	var/choices = list()
	//for(var/datum/computer_file/report/R in program.computer.get_all_files())
		//choices["[R.filename].[R.filetype]"] = R
	var/choice = input(user, "Which report would you like to load?", "Loading Report") as null|anything in choices
	if(choice in choices)
		var/datum/computer_file/report/chosen_report = choices[choice]
		var/editing = alert(user, "Would you like to view or edit the report", "Loading Report", "View", "Edit")
		if(editing == "View")
			//if(!chosen_report.verify_access(get_access(user)))
			if(!chosen_report.verify_access(access_heads))
				to_chat(user, "<span class='warning'>You lack access to view this report.</span>")
				return
			can_view_only = TRUE
		else
			//if(!chosen_report.verify_access_edit(get_access(user)))
			if(!chosen_report.verify_access_edit(access_heads))
				to_chat(user, "<span class='warning'>You lack access to edit this report.</span>")
				return
			can_view_only = FALSE
		saved_report = chosen_report
		selected_report = chosen_report.clone()
		return

#undef REPORTS_VIEW
#undef REPORTS_DOWNLOAD