/obj/item/rig_module/datajack

	name = "datajack module"
	desc = "A simple induction datalink module."
	icon_state = "datajack"
	toggleable = 1
	activates_on_touch = 1
	usable = 0

	activate_string = "Enable Datajack"
	deactivate_string = "Disable Datajack"

	interface_name = "contact datajack"
	interface_desc = "An induction-powered high-throughput datalink suitable for hacking encrypted networks."
	var/list/stored_research

/obj/item/rig_module/datajack/Initialize(mapload)
	. = ..()
	stored_research = list()

/obj/item/rig_module/datajack/engage(atom/target)

	if(!..())
		return 0

	if(target)
		var/mob/living/carbon/human/H = holder.wearer
		if(!accepts_item(target,H))
			return 0
	return 1

/obj/item/rig_module/datajack/accepts_item(var/obj/item/input_device, var/mob/living/user)

	if(istype(input_device,/obj/item/disk/tech_disk))
		to_chat(user, "You slot the disk into [src].")
		var/obj/item/disk/tech_disk/disk = input_device
		if(disk.stored)
			if(load_data(disk.stored))
				to_chat(user, span_blue("Download successful; disk erased."))
				disk.stored = null
			else
				to_chat(user, span_warning("The disk is corrupt. It is useless to you."))
		else
			to_chat(user, span_warning("The disk is blank. It is useless to you."))
		return 1

	// I fucking hate R&D code. This typecheck spam would be totally unnecessary in a sane setup. Sanity? This is BYOND.
	else if(istype(input_device,/obj/machinery))
		var/datum/research/incoming_files
		if(istype(input_device,/obj/machinery/computer/rdconsole) ||\
			istype(input_device,/obj/machinery/r_n_d/server) ||\
			istype(input_device,/obj/machinery/mecha_part_fabricator))

			incoming_files = input_device:files

		if(!incoming_files || !incoming_files.known_tech || !incoming_files.known_tech.len)
			to_chat(user, span_warning("Memory failure. There is nothing accessible stored on this terminal."))
		else
			// Maybe consider a way to drop all your data into a target repo in the future.
			if(load_data(incoming_files.known_tech))
				to_chat(user, span_blue("Download successful; local and remote repositories synchronized."))
			else
				to_chat(user, span_warning("Scan complete. There is nothing useful stored on this terminal."))
		return 1
	return 0

/obj/item/rig_module/datajack/proc/load_data(var/incoming_data)

	if(islist(incoming_data))
		for(var/entry in incoming_data)
			load_data(entry)
		return 1

	if(istype(incoming_data, /datum/tech))
		var/data_found
		var/datum/tech/new_data = incoming_data
		for(var/datum/tech/current_data in stored_research)
			if(current_data.id == new_data.id)
				data_found = 1
				if(current_data.level < new_data.level)
					current_data.level = new_data.level
				break
		if(!data_found)
			stored_research += incoming_data
		return 1
	return 0
