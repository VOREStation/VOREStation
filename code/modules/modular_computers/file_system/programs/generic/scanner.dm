/datum/computer_file/program/scanner
	filename = "scndvr"
	filedesc = "Scanner"
	extended_desc = "This program allows setting up and using an attached scanner module."
	program_icon_state = "generic"
	program_key_state = "generic_key"
	size = 6
	requires_ntnet = 0
	available_on_ntnet = 1
	usage_flags = PROGRAM_ALL
	tguimodule_path = /datum/tgui_module/scanner
	category = PROG_UTIL

	var/using_scanner = 0	//Whether or not the program is synched with the scanner module.
	var/data_buffer = ""	//Buffers scan output for saving/viewing.
	var/scan_file_type = /datum/computer_file/data/text		//The type of file the data will be saved to.
	var/list/metadata_buffer = list()
	var/paper_type

/datum/computer_file/program/scanner/proc/connect_scanner()	//If already connected, will reconnect.
	if(!computer || !computer.scanner)
		return 0
	if(istype(src, computer.scanner.driver_type))
		using_scanner = 1
		computer.scanner.driver = src
		return 1
	return 0

/datum/computer_file/program/scanner/proc/disconnect_scanner()
	using_scanner = 0
	if(computer && computer.scanner && (src == computer.scanner.driver) )
		computer.scanner.driver = null
	data_buffer = null
	metadata_buffer.Cut()
	return 1

/datum/computer_file/program/scanner/proc/save_scan(name)
	if(!data_buffer)
		return 0
	//if(!create_file(name, data_buffer, scan_file_type, metadata_buffer.Copy()))
		//return 0

	if(!computer.hard_drive)
		return 0
	var/datum/computer_file/data/F = new/datum/computer_file/data()
	F.filename = name
	F.filetype = scan_file_type
	F.stored_data = data_buffer
	F.metadata = metadata_buffer.Copy()
	F.calculate_size()
	if(!computer.hard_drive.store_file(F))
		return 0
	return 1

/datum/computer_file/program/scanner/proc/check_scanning()
	if(!computer || !computer.scanner)
		return 0
	if(!computer.scanner.can_run_scan)
		return 0
	if(!computer.scanner.check_functionality())
		return 0
	if(!using_scanner)
		return 0
	if(src != computer.scanner.driver)
		return 0
	return 1