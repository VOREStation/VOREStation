/datum/computer_file/program/robotact
	filename = "robotact"
	filedesc = "RoboTact"
	extended_desc = "A built-in app for cyborg self-management and diagnostics."
	ui_header = "robotact.gif" //DEBUG -- new icon before PR
	program_icon_state = "command"
	requires_ntnet = FALSE
	available_on_ntnet = FALSE
	unsendable = TRUE
	undeletable = TRUE
	usage_flags = PROGRAM_TABLET
	size = 5
	tgui_id = "NtosRobotact"
	///A typed reference to the computer, specifying the borg tablet type
	var/obj/item/modular_computer/tablet/integrated/tablet

/datum/computer_file/program/robotact/Destroy()
	tablet = null
	return ..()

/datum/computer_file/program/robotact/run_program(mob/living/user)
	if(!istype(computer, /obj/item/modular_computer/tablet/integrated))
		to_chat(user, "<span class='warning'>A warning flashes across \the [computer]: Device Incompatible.</span>")
		return FALSE
	. = ..()
	if(.)
		tablet = computer
		if(tablet.device_theme == "syndicate")
			program_icon_state = "command-syndicate"
		return TRUE
	return FALSE

/datum/computer_file/program/robotact/tgui_data(mob/user)
	var/list/data = get_header_data()
	if(!isrobot(user))
		return data
	var/mob/living/silicon/robot/borgo = tablet.borgo

	data["name"] = borgo.name
	data["designation"] = borgo.modtype //Borgo module type
	data["masterAI"] = borgo.connected_ai //Master AI

	data["isdrone"] = istype(borgo, /mob/living/silicon/robot/drone)

	var/charge = 0
	var/maxcharge = 1
	if(borgo.cell)
		charge = borgo.cell.charge
		maxcharge = borgo.cell.maxcharge
	data["charge"] = charge //Current cell charge
	data["maxcharge"] = maxcharge //Cell max charge
	data["integrity"] = ((borgo.health + 100) / 2) //Borgo health, as percentage
	data["lampIntensity"] = borgo.lamp_intensity //Borgo lamp power setting
	data["sensors"] = borgo.hudmode ? borgo.hudmode : "Disable"
	data["printerPictures"] = borgo.aiCamera.aipictures.len //Number of pictures taken
	data["printerToner"] = borgo.toner //amount of toner
	data["printerTonerMax"] = borgo.tonermax //It's a variable, might as well use it
	data["thrustersInstalled"] = borgo.get_jetpack() //If we have a thruster uprade
	data["thrustersStatus"] = borgo.get_jetpack() ? "ACTIVE" : "DISABLED" // "[borgo.ionpulse_on?"ACTIVE":"DISABLED"]" //Feedback for thruster status

	//DEBUG -- Cover, TRUE for locked
	data["cover"] = "[borgo.locked? "LOCKED":"UNLOCKED"]"
	//Ability to move. FAULT if lockdown wire is cut, DISABLED if borg locked, ENABLED otherwise
	data["locomotion"] = "[borgo.wires.is_cut(WIRE_BORG_LOCKED)?"FAULT":"[borgo.lockcharge?"DISABLED":"ENABLED"]"]"
	//Module wire. FAULT if cut, NOMINAL otherwise
	data["wireModule"] = "NOMINAL" //"[borgo.wires.is_cut(WIRE_RESET_MODULE)?"FAULT":"NOMINAL"]"
	//DEBUG -- Camera(net) wire. FAULT if cut (or no cameranet camera), DISABLED if pulse-disabled, NOMINAL otherwise
	data["wireCamera"] = "[!borgo.is_component_functioning("camera") || borgo.wires.is_cut(WIRE_BORG_CAMERA) ? "FAULT":"NOMINAL"]"
	//AI wire. FAULT if wire is cut, CONNECTED if connected to AI, READY otherwise
	data["wireAI"] = "[borgo.wires.is_cut(WIRE_AI_CONTROL)?"FAULT":"[borgo.connected_ai?"CONNECTED":"READY"]"]"
	//Law sync wire. FAULT if cut, NOMINAL otherwise
	data["wireLaw"] = "[borgo.wires.is_cut(WIRE_BORG_LAWCHECK)?"FAULT":"NOMINAL"]"

	data["diagnosisAvailable"] = borgo.is_component_functioning("diagnosis unit")

	var/list/components = list()
	for(var/V in borgo.components)
		var/datum/robot_component/C = borgo.components[V]
		components.Add(list(list(
			"name" = V,
			"installed" = C.installed,
			"toggled" = C.toggled,
			"can_toggle" = (C.installed && V != "power cell"),
			"brute" = C.brute_damage,
			"electronics" = C.electronics_damage,
			"powered" = !C.idle_usage || C.is_powered(),
		)))
	data["components"] = components

	return data

/datum/computer_file/program/robotact/tgui_static_data(mob/user)
	var/list/data = list()
	if(!isrobot(user))
		return data
	var/mob/living/silicon/robot/borgo = user

	data["Laws"] = borgo.laws.get_law_list(TRUE, TRUE, FALSE)
	data["borgLog"] = tablet.borglog
	var/list/upgrades = list()
	for(var/obj/item/borg/upgrade/U in borgo)
		upgrades.Add(U)
	data["borgUpgrades"] = upgrades
	return data

/datum/computer_file/program/robotact/tgui_act(action, params)
	. = ..()
	if(.)
		return

	var/mob/living/silicon/robot/borgo = tablet.borgo

	switch(action)
		if("coverunlock")
			if(borgo.locked)
				borgo.locked = FALSE
				borgo.update_icons()
				if(borgo.emagged)
					borgo.logevent("ChÃ¥vÃis cover lock has been [borgo.locked ? "engaged" : "released"]") //"The cover interface glitches out for a split second"
				else
					borgo.logevent("Chassis cover lock has been [borgo.locked ? "engaged" : "released"]")
			return TRUE

		if("toggleComponent")
			var/datum/robot_component/C = borgo.components["[params["name"]]"]
			if(istype(C) && C.installed)
				C.toggled = !C.toggled
				return TRUE

		if("spark")
			borgo.spark_plug()
			return TRUE

		if("namepick")
			borgo.Namepick()
			return TRUE

		if("lawpanel")
			borgo.subsystem_law_manager()
			return TRUE

		if("lawstate")
			borgo.statelaws(borgo.laws)
			return TRUE

		if("alertPower")
			if(borgo.stat == CONSCIOUS)
				if(!borgo.cell || !borgo.cell.charge)
					borgo.visible_message("<span class='notice'>The power warning light on <span class='name'>[borgo]</span> flashes urgently.</span>", \
						"You announce you are operating in low power mode.")
					playsound(borgo, 'sound/machines/buzz-two.ogg', 50, FALSE)
			return TRUE

		if("toggleSensors")
			borgo.toggle_sensor_mode()
			return TRUE

		if("viewImage")
			borgo.aiCamera?.viewpictures(usr)
			return TRUE

		if("printImage")
			var/obj/item/device/camera/siliconcam/robot_camera/borgcam = borgo.aiCamera
			borgcam?.borgprint(usr)
			return TRUE

		if("deleteImage")
			borgo.aiCamera?.deletepicture()
			return TRUE

		if("lampIntensity")
			borgo.lamp_intensity = clamp(text2num(params["ref"]), 1, 6)
			borgo.handle_light()
			borgo.update_icon()
			return TRUE
		
		// Drone only
		if("setMailTag")
			var/mob/living/silicon/robot/drone/D = borgo
			if(!istype(D))
				return
			D.set_mail_tag()

/**
  * Forces a full update of the UI, if currently open.
  *
  * Forces an update that includes refreshing tgui_static_data. Called by
  * law changes and borg log additions.
  */
/datum/computer_file/program/robotact/proc/force_full_update()
	if(tablet)
		var/datum/tgui/active_ui = SStgui.get_open_ui(tablet.borgo, src)
		if(active_ui)
			active_ui.send_full_update()
