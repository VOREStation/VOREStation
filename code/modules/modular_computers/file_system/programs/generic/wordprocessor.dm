/datum/computer_file/program/wordprocessor
	filename = "wordprocessor"
	filedesc = "NanoWord"
	extended_desc = "This program allows the editing and preview of text documents."
	program_icon_state = "word"
	program_key_state = "atmos_key"
	size = 4
	requires_ntnet = FALSE
	available_on_ntnet = TRUE
	tgui_id = "NtosWordProcessor"

	var/browsing
	var/open_file
	var/loaded_data
	var/error
	var/is_edited

/datum/computer_file/program/wordprocessor/proc/get_file(var/filename)
	var/obj/item/weapon/computer_hardware/hard_drive/HDD = computer.hard_drive
	if(!HDD)
		return
	var/datum/computer_file/data/F = HDD.find_file_by_name(filename)
	if(!istype(F))
		return
	return F

/datum/computer_file/program/wordprocessor/proc/open_file(var/filename)
	var/datum/computer_file/data/F = get_file(filename)
	if(F)
		open_file = F.filename
		loaded_data = F.stored_data
		return TRUE

/datum/computer_file/program/wordprocessor/proc/save_file(var/filename)
	var/datum/computer_file/data/F = get_file(filename)
	if(!F) //try to make one if it doesn't exist
		F = create_file(filename, loaded_data)
		return !isnull(F)
	var/datum/computer_file/data/backup = F.clone()
	var/obj/item/weapon/computer_hardware/hard_drive/HDD = computer.hard_drive
	if(!HDD)
		return
	HDD.remove_file(F)
	F.stored_data = loaded_data
	F.calculate_size()
	if(!HDD.store_file(F))
		HDD.store_file(backup)
		return 0
	is_edited = 0
	return TRUE

/datum/computer_file/program/wordprocessor/proc/create_file(var/newname, var/data = "")
	if(!newname)
		return
	var/obj/item/weapon/computer_hardware/hard_drive/HDD = computer.hard_drive
	if(!HDD)
		return
	if(get_file(newname))
		return
	var/datum/computer_file/data/F = new/datum/computer_file/data()
	F.filename = newname
	F.filetype = "TXT"
	F.stored_data = data
	F.calculate_size()
	if(HDD.store_file(F))
		return F

/datum/computer_file/program/wordprocessor/tgui_act(action, list/params, datum/tgui/ui)
	if(..())
		return TRUE

	switch(action)
		if("PRG_txtrpeview")
			show_browser(usr,"<HTML><HEAD><TITLE>[open_file]</TITLE></HEAD>[pencode2html(loaded_data)]</BODY></HTML>", "window=[open_file]")
			return TRUE

		if("PRG_taghelp")
			to_chat(usr, "<span class='notice'>The hologram of a googly-eyed paper clip helpfully tells you:</span>")
			var/help = {"
			\[br\] : Creates a linebreak.
			\[center\] - \[/center\] : Centers the text.
			\[h1\] - \[/h1\] : First level heading.
			\[h2\] - \[/h2\] : Second level heading.
			\[h3\] - \[/h3\] : Third level heading.
			\[b\] - \[/b\] : Bold.
			\[i\] - \[/i\] : Italic.
			\[u\] - \[/u\] : Underlined.
			\[small\] - \[/small\] : Decreases the size of the text.
			\[large\] - \[/large\] : Increases the size of the text.
			\[field\] : Inserts a blank text field, which can be filled later. Useful for forms.
			\[date\] : Current station date.
			\[time\] : Current station time.
			\[list\] - \[/list\] : Begins and ends a list.
			\[*\] : A list item.
			\[hr\] : Horizontal rule.
			\[table\] - \[/table\] : Creates table using \[row\] and \[cell\] tags.
			\[grid\] - \[/grid\] : Table without visible borders, for layouts.
			\[row\] - New table row.
			\[cell\] - New table cell.
			\[logo\] - Inserts NT logo image.
			\[redlogo\] - Inserts red NT logo image.
			\[sglogo\] - Inserts Solgov insignia image."}

			to_chat(usr, help)
			return TRUE

		if("PRG_closebrowser")
			browsing = 0
			return TRUE

		if("PRG_backtomenu")
			error = null
			return TRUE

		if("PRG_loadmenu")
			browsing = 1
			return TRUE

		if("PRG_openfile")
			if(is_edited)
				if(tgui_alert(usr, "Would you like to save your changes first?","Save Changes",list("Yes","No")) == "Yes")
					save_file(open_file)
			browsing = 0
			if(!open_file(params["PRG_openfile"]))
				error = "I/O error: Unable to open file '[params["PRG_openfile"]]'."
			return TRUE

		if("PRG_newfile")
			if(is_edited)
				if(tgui_alert(usr, "Would you like to save your changes first?","Save Changes",list("Yes","No")) == "Yes")
					save_file(open_file)

			var/newname = sanitize(input(usr, "Enter file name:", "New File") as text|null)
			if(!newname)
				return TRUE
			var/datum/computer_file/data/F = create_file(newname)
			if(F)
				open_file = F.filename
				loaded_data = ""
				return TRUE
			else
				error = "I/O error: Unable to create file '[params["PRG_saveasfile"]]'."
			return TRUE

		if("PRG_saveasfile")
			var/newname = sanitize(input(usr, "Enter file name:", "Save As") as text|null)
			if(!newname)
				return TRUE
			var/datum/computer_file/data/F = create_file(newname, loaded_data)
			if(F)
				open_file = F.filename
			else
				error = "I/O error: Unable to create file '[params["PRG_saveasfile"]]'."
			return TRUE

		if("PRG_savefile")
			if(!open_file)
				open_file = sanitize(input(usr, "Enter file name:", "Save As") as text|null)
				if(!open_file)
					return 0
			if(!save_file(open_file))
				error = "I/O error: Unable to save file '[open_file]'."
			return TRUE

		if("PRG_editfile")
			var/oldtext = html_decode(loaded_data)
			oldtext = replacetext(oldtext, "\[br\]", "\n")

			var/newtext = sanitize(replacetext(input(usr, "Editing file '[open_file]'. You may use most tags used in paper formatting:", "Text Editor", oldtext) as message|null, "\n", "\[br\]"), MAX_TEXTFILE_LENGTH)
			if(!newtext)
				return
			loaded_data = newtext
			is_edited = 1
			return TRUE

		if("PRG_printfile")
			if(!computer.nano_printer)
				error = "Missing Hardware: Your computer does not have the required hardware to complete this operation."
				return TRUE
			if(!computer.nano_printer.print_text(pencode2html(loaded_data)))
				error = "Hardware error: Printer was unable to print the file. It may be out of paper."
				return TRUE
			return TRUE

/datum/computer_file/program/wordprocessor/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = get_header_data()

	var/obj/item/weapon/computer_hardware/hard_drive/HDD = computer.hard_drive
	var/obj/item/weapon/computer_hardware/hard_drive/portable/RHDD = computer.portable_drive
	data["error"] = null
	if(error)
		data["error"] = error

	data["browsing"] = null
	data["files"] = list()
	data["usbconnected"] = FALSE
	data["usbfiles"] = list()
	data["filedata"] = null
	data["filename"] = null

	if(browsing)
		data["browsing"] = browsing
		if(!computer || !HDD)
			data["error"] = "I/O ERROR: Unable to access hard drive."
		else
			var/list/files[0]
			for(var/datum/computer_file/F in HDD.stored_files)
				if(F.filetype == "TXT")
					files.Add(list(list(
						"name" = F.filename,
						"size" = F.size
					)))
			data["files"] = files

			if(RHDD)
				data["usbconnected"] = 1
				var/list/usbfiles[0]
				for(var/datum/computer_file/F in RHDD.stored_files)
					if(F.filetype == "TXT")
						usbfiles.Add(list(list(
							"name" = F.filename,
							"size" = F.size,
						)))
				data["usbfiles"] = usbfiles
	else if(open_file)
		data["filedata"] = pencode2html(loaded_data)
		data["filename"] = is_edited ? "[open_file]*" : open_file
	else
		data["filedata"] = pencode2html(loaded_data)
		data["filename"] = "UNNAMED"

	return data