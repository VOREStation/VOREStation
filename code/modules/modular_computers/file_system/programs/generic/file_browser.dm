/datum/computer_file/program/filemanager
	filename = "filemanager"
	filedesc = "NTOS File Manager"
	extended_desc = "This program allows management of files."
	program_icon_state = "generic"
	program_key_state = "generic_key"
	program_menu_icon = "folder-collapsed"
	size = 8
	requires_ntnet = FALSE
	available_on_ntnet = FALSE
	undeletable = TRUE
	tgui_id = "NtosFileManager"

	var/open_file
	var/error
	usage_flags = PROGRAM_ALL
	category = PROG_UTIL

/datum/computer_file/program/filemanager/tgui_act(action, list/params, datum/tgui/ui)
	if(..())
		return TRUE

	var/obj/item/weapon/computer_hardware/hard_drive/HDD = computer.hard_drive
	var/obj/item/weapon/computer_hardware/hard_drive/RHDD = computer.portable_drive

	switch(action)
		if("PRG_openfile")
			open_file = params["name"]
			return TRUE
		if("PRG_newtextfile")
			if(!HDD)
				return
			var/newname = sanitize(input(usr, "Enter file name or leave blank to cancel:", "File rename"))
			if(!newname)
				return
			var/datum/computer_file/data/F = new/datum/computer_file/data()
			F.filename = newname
			F.filetype = "TXT"
			HDD.store_file(F)
			return TRUE
		if("PRG_closefile")
			open_file = null
			error = null
			return TRUE
		if("PRG_clone")
			if(!HDD)
				return
			var/datum/computer_file/F = HDD.find_file_by_name(params["name"])
			if(!F || !istype(F))
				return
			var/datum/computer_file/C = F.clone(1)
			HDD.store_file(C)
			return TRUE
		if("PRG_edit")
			if(!HDD)
				return
			if(!open_file)
				return
			var/datum/computer_file/data/F = HDD.find_file_by_name(open_file)
			if(!F || !istype(F))
				return
			if(F.do_not_edit && (tgui_alert(usr, "WARNING: This file is not compatible with editor. Editing it may result in permanently corrupted formatting or damaged data consistency. Edit anyway?", "Incompatible File", list("No", "Yes")) == "No"))
				return

			var/oldtext = html_decode(F.stored_data)
			oldtext = replacetext(oldtext, "\[br\]", "\n")

			var/newtext = sanitize(replacetext(input(usr, "Editing file [open_file]. You may use most tags used in paper formatting:", "Text Editor", oldtext) as message|null, "\n", "\[br\]"), MAX_TEXTFILE_LENGTH)
			if(!newtext)
				return

			if(F)
				var/datum/computer_file/data/backup = F.clone()
				HDD.remove_file(F)
				F.stored_data = newtext
				F.calculate_size()
				// We can't store the updated file, it's probably too large. Print an error and restore backed up version.
				// This is mostly intended to prevent people from losing texts they spent lot of time working on due to running out of space.
				// They will be able to copy-paste the text from error screen and store it in notepad or something.
				if(!HDD.store_file(F))
					error = "I/O error: Unable to overwrite file. Hard drive is probably full. You may want to backup your changes before closing this window:<br><br>[html_decode(F.stored_data)]<br><br>"
					HDD.store_file(backup)
				return TRUE
		if("PRG_printfile")
			if(!HDD)
				return
			if(!open_file)
				return
			var/datum/computer_file/data/F = HDD.find_file_by_name(open_file)
			if(!F || !istype(F))
				return
			if(!computer.nano_printer)
				error = "Missing Hardware: Your computer does not have required hardware to complete this operation."
				return
			if(!computer.nano_printer.print_text(pencode2html(F.stored_data)))
				error = "Hardware error: Printer was unable to print the file. It may be out of paper."
				return
			return TRUE
		if("PRG_deletefile")
			if(!HDD)
				return
			var/datum/computer_file/file = HDD.find_file_by_name(params["name"])
			if(!file || file.undeletable)
				return
			HDD.remove_file(file)
			return TRUE
		if("PRG_usbdeletefile")
			if(!RHDD)
				return
			var/datum/computer_file/file = RHDD.find_file_by_name(params["name"])
			if(!file || file.undeletable)
				return
			RHDD.remove_file(file)
			return TRUE
		if("PRG_rename")
			if(!HDD)
				return
			var/datum/computer_file/file = HDD.find_file_by_name(params["name"])
			if(!file)
				return
			var/newname = params["new_name"]
			if(!newname)
				return
			file.filename = newname
			return TRUE
		if("PRG_copytousb")
			if(!HDD || !RHDD)
				return
			var/datum/computer_file/F = HDD.find_file_by_name(params["name"])
			if(!F)
				return
			var/datum/computer_file/C = F.clone(FALSE)
			RHDD.store_file(C)
			return TRUE
		if("PRG_copyfromusb")
			if(!HDD || !RHDD)
				return
			var/datum/computer_file/F = RHDD.find_file_by_name(params["name"])
			if(!F || !istype(F))
				return
			var/datum/computer_file/C = F.clone(FALSE)
			HDD.store_file(C)
			return TRUE

/datum/computer_file/program/filemanager/tgui_data(mob/user)
	var/list/data = get_header_data()

	var/obj/item/weapon/computer_hardware/hard_drive/HDD = computer.hard_drive
	var/obj/item/weapon/computer_hardware/hard_drive/portable/RHDD = computer.portable_drive

	data["error"] = null
	if(error)
		data["error"] = error
	if(!computer || !HDD)
		data["error"] = "I/O ERROR: Unable to access hard drive."
	
	data["filedata"] = null
	data["filename"] = null
	data["files"] = list()
	data["usbconnected"] = FALSE
	data["usbfiles"] = list()

	if(open_file)
		var/datum/computer_file/data/file

		if(!computer || !computer.hard_drive)
			data["error"] = "I/O ERROR: Unable to access hard drive."
		else
			file = HDD.find_file_by_name(open_file)
			if(!istype(file))
				data["error"] = "I/O ERROR: Unable to open file."
			else
				data["filedata"] = pencode2html(file.stored_data)
				data["filename"] = "[file.filename].[file.filetype]"
	else
		var/list/files = list()
		for(var/datum/computer_file/F in HDD.stored_files)
			files += list(list(
				"name" = F.filename,
				"type" = F.filetype,
				"size" = F.size,
				"undeletable" = F.undeletable
			))
		data["files"] = files
		if(RHDD)
			data["usbconnected"] = TRUE
			var/list/usbfiles = list()
			for(var/datum/computer_file/F in RHDD.stored_files)
				usbfiles += list(list(
					"name" = F.filename,
					"type" = F.filetype,
					"size" = F.size,
					"undeletable" = F.undeletable
				))
			data["usbfiles"] = usbfiles

	return data
