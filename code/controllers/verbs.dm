//TODO: rewrite and standardise all controller datums to the datum/controller type
//TODO: allow all controllers to be deleted for clean restarts (see WIP master controller stuff) - MC done - lighting done

// Clickable stat() button.
/obj/effect/statclick
	name = "Initializing..."
	var/target

/obj/effect/statclick/New(loc, text, target) //Don't port this to Initialize it's too critical
	..()
	name = text
	src.target = target

/obj/effect/statclick/proc/update(text)
	name = text
	return src

/obj/effect/statclick/debug
	var/class

/obj/effect/statclick/debug/Click()
	if(!usr.client.holder || !target)
		return
	if(!class)
		if(istype(target, /datum/controller/subsystem))
			class = "subsystem"
		else if(istype(target, /datum/controller))
			class = "controller"
		else if(istype(target, /datum))
			class = "datum"
		else
			class = "unknown"

	usr.client.debug_variables(target)
	message_admins("Admin [key_name_admin(usr)] is debugging the [target] [class].")


// Debug verbs.
/client/proc/restart_controller(controller in list("Master", "Failsafe"))
	set category = "Debug"
	set name = "Restart Controller"
	set desc = "Restart one of the various periodic loop controllers for the game (be careful!)"

	if(!holder)
		return
	switch(controller)
		if("Master")
			Recreate_MC()
			feedback_add_details("admin_verb","RMC")
		if("Failsafe")
			new /datum/controller/failsafe()
			feedback_add_details("admin_verb","RFailsafe")

	message_admins("Admin [key_name_admin(usr)] has restarted the [controller] controller.")

/client/proc/debug_antagonist_template(antag_type in all_antag_types)
	set category = "Debug"
	set name = "Debug Antagonist"
	set desc = "Debug an antagonist template."

	var/datum/antagonist/antag = all_antag_types[antag_type]
	if(antag)
		usr.client.debug_variables(antag)
		message_admins("Admin [key_name_admin(usr)] is debugging the [antag.role_text] template.")

/client/proc/debug_controller()
	set category = "Debug"
	set name = "Debug Controller"
	set desc = "Debug the various subsystems/controllers for the game (be careful!)"

<<<<<<< HEAD
	if(!holder)	return
	switch(controller)
		if("Master")
			debug_variables(master_controller)
			feedback_add_details("admin_verb","DMC")
		if("Ticker")
			debug_variables(ticker)
			feedback_add_details("admin_verb","DTicker")
		if("Ticker Process")
			debug_variables(tickerProcess)
			feedback_add_details("admin_verb","DTickerProcess")
		if("Air")
			debug_variables(air_master)
			feedback_add_details("admin_verb","DAir")
		if("Jobs")
			debug_variables(job_master)
			feedback_add_details("admin_verb","DJobs")
		if("Radio")
			debug_variables(radio_controller)
			feedback_add_details("admin_verb","DRadio")
		if("Supply")
			debug_variables(supply_controller)
			feedback_add_details("admin_verb","DSupply")
		if("Emergency Shuttle")
			debug_variables(emergency_shuttle)
			feedback_add_details("admin_verb","DEmergency")
		if("Configuration")
			debug_variables(config)
			feedback_add_details("admin_verb","DConf")
		if("pAI")
			debug_variables(paiController)
			feedback_add_details("admin_verb","DpAI")
		if("Cameras")
			debug_variables(cameranet)
			feedback_add_details("admin_verb","DCameras")
		if("Transfer Controller")
			debug_variables(transfer_controller)
			feedback_add_details("admin_verb","DAutovoter")
		if("Gas Data")
			debug_variables(gas_data)
			feedback_add_details("admin_verb","DGasdata")
		if("Plants")
			debug_variables(plant_controller)
			feedback_add_details("admin_verb", "DPlants")
		if("Alarm")
			debug_variables(alarm_manager)
			feedback_add_details("admin_verb", "DAlarm")
	message_admins("Admin [key_name_admin(usr)] is debugging the [controller] controller.")
	return

/client/proc/debug_process_scheduler()
	set category = "Debug"
	set name = "Debug Process Scheduler"
	set desc = "Debug the process scheduler itself. For vulpine use only."

	if(!check_rights(R_DEBUG)) return
	if(config.debugparanoid && !check_rights(R_ADMIN)) return
	debug_variables(processScheduler)
	feedback_add_details("admin_verb", "DProcSchd")
	message_admins("Admin [key_name_admin(usr)] is debugging the process scheduler.")

/client/proc/debug_process(controller in processScheduler.nameToProcessMap)
	set category = "Debug"
	set name = "Debug Process Controller"
	set desc = "Debug one of the periodic loop background task controllers for the game (be careful!)"

	if(!check_rights(R_DEBUG)) return
	if(config.debugparanoid && !check_rights(R_ADMIN)) return
	var/datum/controller/process/P = processScheduler.nameToProcessMap[controller]
	debug_variables(P)
	feedback_add_details("admin_verb", "DProcCtrl")
	message_admins("Admin [key_name_admin(usr)] is debugging the [controller] controller.")
=======
	if(!holder)
		return
	var/list/options = list()
	options["MC"] = Master
	options["Failsafe"] = Failsafe
	options["Configuration"] = config
	for(var/i in Master.subsystems)
		var/datum/controller/subsystem/S = i
		if(!istype(S))		//Eh, we're a debug verb, let's have typechecking.
			continue
		var/strtype = "SS[get_end_section_of_type(S.type)]"
		if(options[strtype])
			var/offset = 2
			while(istype(options["[strtype]_[offset] - DUPE ERROR"], /datum/controller/subsystem))
				offset++
			options["[strtype]_[offset] - DUPE ERROR"] = S		//Something is very, very wrong.
		else
			options[strtype] = S

	//Goon PS stuff, and other yet-to-be-subsystem things.
	options["LEGACY: master_controller"] = master_controller
	options["LEGACY: ticker"] = ticker
	options["LEGACY: tickerProcess"] = tickerProcess
	options["LEGACY: air_master"] = air_master
	options["LEGACY: job_master"] = job_master
	options["LEGACY: radio_controller"] = radio_controller
	options["LEGACY: supply_controller"] = supply_controller
	options["LEGACY: emergency_shuttle"] = emergency_shuttle
	options["LEGACY: paiController"] = paiController
	options["LEGACY: cameranet"] = cameranet
	options["LEGACY: transfer_controller"] = transfer_controller
	options["LEGACY: gas_data"] = gas_data
	options["LEGACY: plant_controller"] = plant_controller
	options["LEGACY: alarm_manager"] = alarm_manager

	var/pick = input(mob, "Choose a controller to debug/view variables of.", "VV controller:") as null|anything in options
	if(!pick)
		return
	var/datum/D = options[pick]
	if(!istype(D))
		return
	feedback_add_details("admin_verb", "DebugController")
	message_admins("Admin [key_name_admin(mob)] is debugging the [pick] controller.")
	debug_variables(D)
>>>>>>> bfaaffb... Adds a better debug controller verb that can target all controllers/processes/mc/failsafe/config/etc (#5852)
