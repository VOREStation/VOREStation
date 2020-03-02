SUBSYSTEM_DEF(nanoui)
	name = "NanoUI"
	wait = 5
	flags = SS_NO_INIT
	// a list of current open /nanoui UIs, grouped by src_object and ui_key
	var/list/open_uis = list()
	// a list of current open /nanoui UIs, not grouped, for use in processing
	var/list/processing_uis = list()

/datum/controller/subsystem/nanoui/Recover()
	if(SSnanoui.open_uis)
		open_uis |= SSnanoui.open_uis
	if(SSnanoui.processing_uis)
		processing_uis |= SSnanoui.processing_uis

/datum/controller/subsystem/nanoui/stat_entry()
	return ..("[processing_uis.len] UIs")

/datum/controller/subsystem/nanoui/fire(resumed)
	for(var/thing in processing_uis)
		var/datum/nanoui/UI = thing
		UI.process()
