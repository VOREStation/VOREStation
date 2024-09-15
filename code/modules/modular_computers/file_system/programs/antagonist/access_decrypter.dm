/datum/computer_file/program/access_decrypter
	filename = "nt_accrypt"
	filedesc = "NTNet Access Decrypter"
	program_icon_state = "hostile"
	program_key_state = "security_key"
	program_menu_icon = "unlocked"
	extended_desc = "This highly advanced script can very slowly decrypt operational codes used in almost any network. These codes can be downloaded to an ID card to expand the available access. The system administrator will probably notice this."
	size = 34
	requires_ntnet = TRUE
	available_on_ntnet = FALSE
	available_on_syndinet = TRUE
	tgui_id = "NtosAccessDecrypter"

	var/message = ""
	var/running = FALSE
	var/progress = 0
	var/target_progress = 300
	var/datum/access/target_access = null
	var/list/restricted_access_codes = list(access_change_ids, access_network) // access codes that are not hackable due to balance reasons

/datum/computer_file/program/access_decrypter/kill_program(var/forced)
	reset()
	..(forced)

/datum/computer_file/program/access_decrypter/proc/reset()
	running = FALSE
	message = ""
	progress = 0

/datum/computer_file/program/access_decrypter/process_tick()
	. = ..()
	if(!running)
		return
	var/obj/item/weapon/computer_hardware/processor_unit/CPU = computer.processor_unit
	var/obj/item/weapon/computer_hardware/card_slot/RFID = computer.card_slot
	if(!istype(CPU) || !CPU.check_functionality() || !istype(RFID) || !RFID.check_functionality())
		message = "A fatal hardware error has been detected."
		return
	if(!istype(RFID.stored_card))
		message = "RFID card has been removed from the device. Operation aborted."
		return

	progress += CPU.max_idle_programs
	if(progress >= target_progress)
		reset()
		RFID.stored_card.access |= target_access.id
		if(ntnet_global.intrusion_detection_enabled)
			ntnet_global.add_log("IDS WARNING - Unauthorised access to primary keycode database from device: [computer.network_card.get_network_tag()]  - downloaded access codes for: [target_access.desc].")
			ntnet_global.intrusion_detection_alarm = 1
		message = "Successfully decrypted and saved operational key codes. Downloaded access codes for: [target_access.desc]"
		target_access = null

/datum/computer_file/program/access_decrypter/tgui_act(action, list/params, datum/tgui/ui)
	if(..())
		return TRUE
	switch(action)
		if("PRG_reset")
			reset()
			return TRUE
		if("PRG_execute")
			if(running)
				return TRUE
			if(text2num(params["allowed"]))
				return TRUE
			var/obj/item/weapon/computer_hardware/processor_unit/CPU = computer.processor_unit
			var/obj/item/weapon/computer_hardware/card_slot/RFID = computer.card_slot
			if(!istype(CPU) || !CPU.check_functionality() || !istype(RFID) || !RFID.check_functionality())
				message = "A fatal hardware error has been detected."
				return
			if(!istype(RFID.stored_card))
				message = "RFID card is not present in the device. Operation aborted."
				return
			running = TRUE
			target_access = get_access_by_id("[params["access_target"]]")
			if(ntnet_global.intrusion_detection_enabled)
				ntnet_global.add_log("IDS WARNING - Unauthorised access attempt to primary keycode database from device: [computer.network_card.get_network_tag()]")
				ntnet_global.intrusion_detection_alarm = TRUE
			return TRUE

/datum/computer_file/program/access_decrypter/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	if(!ntnet_global)
		return
	var/list/data = get_header_data()

	var/list/regions = list()
	data["message"] = null
	data["running"] = running
	if(message)
		data["message"] = message
	else if(running)
		data["running"] = 1
		data["rate"] = computer.processor_unit.max_idle_programs
		data["factor"] = (progress / target_progress)
	else if(computer?.card_slot?.stored_card)
		var/obj/item/weapon/card/id/id_card = computer.card_slot.stored_card
		for(var/i = 1; i <= 7; i++)
			var/list/accesses = list()
			for(var/access in get_region_accesses(i))
				if(get_access_desc(access) && !(access in restricted_access_codes))
					accesses.Add(list(list(
						"desc" = replacetext(get_access_desc(access), " ", "&nbsp;"),
						"ref" = access,
						"allowed" = (access in id_card.GetAccess()) ? 1 : 0
					)))

			regions.Add(list(list(
				"name" = get_region_accesses_name(i),
				"accesses" = accesses
			)))
	data["regions"] = regions

	return data
