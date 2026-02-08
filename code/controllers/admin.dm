// Clickable stat() button.
/obj/effect/statclick
	name = "Initializing..."
	blocks_emissive = FALSE // EMISSIVE_BLOCK_NONE
	var/target

INITIALIZE_IMMEDIATE(/obj/effect/statclick)

/obj/effect/statclick/Initialize(mapload, text, target)
	. = ..()
	name = text
	src.target = target

/obj/effect/statclick/Destroy()
	target = null
	return ..()

/obj/effect/statclick/proc/cleanup()
	SIGNAL_HANDLER
	qdel(src)

/obj/effect/statclick/proc/update(text)
	name = text
	return src

/obj/effect/statclick/debug
	var/class

/obj/effect/statclick/debug/Click()
	if(!check_rights_for(usr.client, R_HOLDER) || !target)
		return
	if(!class)
		if(istype(target, /datum/controller/subsystem))
			class = "subsystem"
		else if(istype(target, /datum/controller))
			class = "controller"
		else if(isdatum(target))
			class = "datum"
		else
			class = "unknown"

	usr.client.debug_variables(target)
	message_admins("Admin [key_name_admin(usr)] is debugging the [target] [class].")

ADMIN_VERB(restart_controller, R_DEBUG, "Restart Controller", "Restart one of the various periodic loop controllers for the game (be careful!)", ADMIN_CATEGORY_DEBUG_GAME, controller in list("Master", "Failsafe"))
	switch(controller)
		if("Master")
			Recreate_MC()
			feedback_add_details("admin_verb","RMC")
		if("Failsafe")
			new /datum/controller/failsafe()
			feedback_add_details("admin_verb","RFailsafe")

	message_admins("Admin [key_name_admin(user)] has restarted the [controller] controller.")

ADMIN_VERB(debug_antagonist_template, R_DEBUG, "Debug Antagonist", "Debug an antagonist template", ADMIN_CATEGORY_DEBUG_GAME, antag_type in GLOB.all_antag_types)
	var/datum/antagonist/antag = GLOB.all_antag_types[antag_type]
	if(antag)
		user.debug_variables(antag)
		message_admins("Admin [key_name_admin(user)] is debugging the [antag.role_text] template.")

ADMIN_VERB(debug_controller, R_DEBUG, "Debug Controller", "Debug the various periodic loop controllers for the game (be careful!)", ADMIN_CATEGORY_DEBUG_GAME)
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
	options["LEGACY: master_controller"] = GLOB.master_controller
	options["LEGACY: job_master"] = GLOB.job_master
	options["LEGACY: emergency_shuttle"] = GLOB.emergency_shuttle
	options["LEGACY: paiController"] = paiController
	options["LEGACY: cameranet"] = cameranet
	options["LEGACY: transfer_controller"] = GLOB.transfer_controller

	var/pick = tgui_input_list(user, "Choose a controller to debug/view variables of.", "VV controller:", options)
	if(!pick)
		return
	var/datum/D = options[pick]
	if(!istype(D))
		return
	feedback_add_details("admin_verb", "DebugController")
	message_admins("Admin [key_name_admin(user)] is debugging the [pick] controller.")
	user.debug_variables(D)
