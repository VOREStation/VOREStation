SUBSYSTEM_DEF(nanoui)
	name = "NanoUI"
	wait = 5
	// a list of current open /nanoui UIs, grouped by src_object and ui_key
	var/list/open_uis = list()
	// a list of current open /nanoui UIs, not grouped, for use in processing
	var/list/processing_uis = list()
	// a list of asset filenames which are to be sent to the client on user logon
	var/list/asset_files = list()

/datum/controller/subsystem/nanoui/Initialize()
	var/list/nano_asset_dirs = list(\
		"nano/css/",\
		"nano/images/",\
		"nano/images/status_icons/",\
		"nano/images/modular_computers/",\
		"nano/js/",\
		"nano/templates/"\
	)

	var/list/filenames = null
	for (var/path in nano_asset_dirs)
		filenames = flist(path)
		for(var/filename in filenames)
			if(copytext(filename, length(filename)) != "/") // filenames which end in "/" are actually directories, which we want to ignore
				if(fexists(path + filename))
					asset_files.Add(fcopy_rsc(path + filename)) // add this file to asset_files for sending to clients when they connect
	.=..()
	for(var/i in GLOB.clients)
		send_resources(i)

/datum/controller/subsystem/nanoui/Recover()
	if(SSnanoui.open_uis)
		open_uis |= SSnanoui.open_uis
	if(SSnanoui.processing_uis)
		processing_uis |= SSnanoui.processing_uis
	if(SSnanoui.asset_files)
		asset_files |= SSnanoui.asset_files

/datum/controller/subsystem/nanoui/stat_entry()
	return ..("[processing_uis.len] UIs")

/datum/controller/subsystem/nanoui/fire(resumed)
	for(var/thing in processing_uis)
		var/datum/nanoui/UI = thing
		UI.process()

//Sends asset files to a client, called on client/New()
/datum/controller/subsystem/nanoui/proc/send_resources(client)
	if(!subsystem_initialized)
		return
	for(var/file in asset_files)
		client << browse_rsc(file)	// send the file to the client
