//TODO: rewrite and standardise all controller datums to the datum/controller type
//TODO: allow all controllers to be deleted for clean restarts (see WIP master controller stuff) - MC done - lighting done

// Clickable stat() button.
/obj/effect/statclick
	name = "Initializing..."
	blocks_emissive = FALSE
	var/target

INITIALIZE_IMMEDIATE(/obj/effect/statclick)
/obj/effect/statclick/Initialize(mapload, text, target)
	. = ..()
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
	set category = "Debug.Dangerous"
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
	set category = "Debug.Investigate"
	set name = "Debug Antagonist"
	set desc = "Debug an antagonist template."

	var/datum/antagonist/antag = all_antag_types[antag_type]
	if(antag)
		usr.client.debug_variables(antag)
		message_admins("Admin [key_name_admin(usr)] is debugging the [antag.role_text] template.")

/client/proc/debug_controller()
	set category = "Debug.Investigate"
	set name = "Debug Controller"
	set desc = "Debug the various subsystems/controllers for the game (be careful!)"

	if(!holder)
		return
	var/list/options = list()
	options["MC"] = Master
	options["Failsafe"] = Failsafe
	options["Configuration"] = config
	for(var/datum/controller/subsystem/S as anything in Master.subsystems)
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
	options["LEGACY: job_master"] = job_master
	options["LEGACY: radio_controller"] = radio_controller
	options["LEGACY: emergency_shuttle"] = emergency_shuttle
	options["LEGACY: paiController"] = paiController
	options["LEGACY: cameranet"] = cameranet
	options["LEGACY: transfer_controller"] = transfer_controller
	options["LEGACY: gas_data"] = gas_data

	var/pick = tgui_input_list(mob, "Choose a controller to debug/view variables of.", "VV controller:", options)
	if(!pick)
		return
	var/datum/D = options[pick]
	if(!istype(D))
		return
	feedback_add_details("admin_verb", "DebugController")
	message_admins("Admin [key_name_admin(mob)] is debugging the [pick] controller.")
	debug_variables(D)
