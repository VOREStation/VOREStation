/client/proc/modify_robot(var/mob/living/silicon/robot/target in silicon_mob_list)
	set name = "Modify Robot"
	set desc = "Allows to add or remove modules to/from robots."
	set category = "Admin"
	if(!check_rights(R_ADMIN|R_FUN|R_VAREDIT|R_EVENT))
		return

	var/datum/eventkit/modify_robot/modify_robot = new()
	modify_robot.target = target
	modify_robot.tgui_interact(src.mob)

/datum/eventkit/modify_robot
	var/mob/living/silicon/robot/target
	var/mob/living/silicon/robot/source
	var/mob/living/ai/selected_ai
	var/ion_law	= "IonLaw"
	var/zeroth_law = "ZerothLaw"
	var/inherent_law = "InherentLaw"
	var/supplied_law = "SuppliedLaw"
	var/supplied_law_position = MIN_SUPPLIED_LAW_NUMBER
	var/list/datum/ai_laws/law_list

/datum/eventkit/modify_robot/New()
	. = ..()
	log_and_message_admins("has used modify robot and is modifying [target]")
	law_list = new()
	init_subtypes(/datum/ai_laws, law_list)
	law_list = dd_sortedObjectList(law_list)

/datum/eventkit/modify_robot/tgui_close()
	if(source)
		qdel(source)

/datum/eventkit/modify_robot/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ModifyRobot", "Modify Robot")
		ui.open()

/datum/eventkit/modify_robot/Destroy()
	if(source)
		qdel(source)
	. = ..()

/datum/eventkit/modify_robot/tgui_data(mob/user)
	. = list()
	// Target section for general data
	if(target)
		.["target"] = list()
		.["target"]["name"] = target.name
		.["target"]["ckey"] = target.ckey
		.["target"]["module"] = target.module
		.["target"]["crisis_override"] = target.crisis_override
		.["target"]["active_restrictions"] = target.restrict_modules_to
		var/list/possible_restrictions = list()
		for(var/entry in robot_modules)
			if(!target.restrict_modules_to.Find(entry))
				possible_restrictions += entry
		.["target"]["possible_restrictions"] = possible_restrictions
		// Target section for options once a module has been selected
		if(target.module)
			.["target"]["active"] = target.icon_selected
			.["target"]["front"] = icon2base64(get_flat_icon(target,dir=SOUTH,no_anim=TRUE))
			.["target"]["side"] = icon2base64(get_flat_icon(target,dir=WEST,no_anim=TRUE))
			.["target"]["side_alt"] = icon2base64(get_flat_icon(target,dir=EAST,no_anim=TRUE))
			.["target"]["back"] = icon2base64(get_flat_icon(target,dir=NORTH,no_anim=TRUE))
			.["target"]["modules"] = get_target_items(user)
			var/list/module_options = list()
			for(var/module in robot_modules)
				module_options += module
			.["model_options"] = module_options
			// Data for the upgrade options
			.["target"] += get_upgrades()
			var/obj/item/weapon/gun/energy/kinetic_accelerator/kin = locate() in target.module.modules
			if(kin)
				.["target"]["pka"] += get_pka(kin)
			// Radio section
			var/list/radio_channels = list()
			for(var/channel in target.radio.channels)
				radio_channels += channel
			var/list/availalbe_channels = list()
			for(var/channel in (radiochannels - target.radio.channels))
				availalbe_channels += channel
			.["target"]["radio_channels"] = radio_channels
			.["target"]["availalbe_channels"] = availalbe_channels
			// Components
			.["target"]["components"] = get_components()
			.["cell"] = list("name" = target.cell?.name, "charge" = target.cell?.charge, "maxcharge" = target.cell?.maxcharge)
			.["cell_options"] = get_cells()
			// Access
			.["id_icon"] = icon2html(target.idcard, user, sourceonly=TRUE)
			var/list/active_access = list()
			for(var/access in target.idcard?.GetAccess())
				active_access += list(list("id" = access, "name" = get_access_desc(access)))
			.["target"]["active_access"] = active_access
			var/list/access_options = list()
			for(var/datum/access/acc)
				if(acc.id in target.idcard?.GetAccess())
					continue
				access_options += list(list("id" = acc.id, "name" = acc.desc))
			.["access_options"] = access_options
			// Section for source data for the module we might want to salvage
			if(source)
				.["source"] += get_module_source(user)
	var/list/all_robots = list()
	for(var/mob/living/silicon/robot/R in silicon_mob_list)
		if(!R.loc)
			continue
		all_robots += list(list("displayText" = "[R]", "value" = "\ref[R]"))
	.["all_robots"] = all_robots
	// Law data
	.["ion_law_nr"] = ionnum()
	.["ion_law"] = ion_law
	.["zeroth_law"] = zeroth_law
	.["inherent_law"] = inherent_law
	.["supplied_law"] = supplied_law
	.["supplied_law_position"] = supplied_law_position

	package_laws(., "zeroth_laws", list(target.laws.zeroth_law))
	package_laws(., "ion_laws", target.laws.ion_laws)
	package_laws(., "inherent_laws", target.laws.inherent_laws)
	package_laws(., "supplied_laws", target.laws.supplied_laws)

	.["isAI"] = isAI(target)
	.["isMalf"] = is_malf(user)
	.["isSlaved"] = target.is_slaved()
	var/list/active_ais = list()
	for(var/mob/living/silicon/ai/ai in active_ais())
		if(!ai.loc)
			continue
		active_ais += list(list("displayText" = "[R]", "value" = "\ref[R]"))
	.["active_ais"] = active_ais
	.["selected_ai"] = selected_ai

	var/list/channels = list()
	for(var/ch_name in target.law_channels())
		channels[++channels.len] = list("channel" = ch_name)
	.["channel"] = target.lawchannel
	.["channels"] = channels
	.["law_sets"] = package_multiple_laws(law_list)


/datum/eventkit/modify_robot/tgui_state(mob/user)
	return GLOB.tgui_admin_state

/datum/eventkit/modify_robot/tgui_act(action, params)
	. = ..()
	if(.)
		return
	switch(action)
		if("rename")
			target.name = params["new_name"]
			target.custom_name = params["new_name"]
			target.real_name = params["new_name"]
			return TRUE
		if("select_target")
			target = locate(params["new_target"])
			log_and_message_admins("changed robot modifictation target to [target]")
			return TRUE
		if("toggle_crisis")
			target.crisis_override = !target.crisis_override
			return TRUE
		if("add_restriction")
			target.restrict_modules_to += params["new_restriction"]
			return TRUE
		if("remove_restriction")
			target.restrict_modules_to -= params["rem_restriction"]
			return TRUE
		if("select_source")
			if(source)
				qdel(source)
			source = new /mob/living/silicon/robot(null)
			var/module_type = robot_modules[params["new_source"]]
			source.modtype = params["new_source"]
			var/obj/item/weapon/robot_module/robot/robot_type = new module_type(source)
			source.sprite_datum = pick(SSrobot_sprites.get_module_sprites(source.modtype, source))
			source.update_icon()
			source.emag_items = 1
			if(!istype(robot_type, /obj/item/weapon/robot_module/robot))
				QDEL_NULL(source)
				return TRUE
			return TRUE
		if("reset_module")
			target.module_reset(FALSE)
			return TRUE
		if("add_module")
			var/obj/item/add_item = locate(params["module"])
			if(!add_item)
				return TRUE
			source.module.emag.Remove(add_item)
			source.module.modules.Remove(add_item)
			source.module.contents.Remove(add_item)
			target.module.modules.Add(add_item)
			target.module.contents.Add(add_item)
			spawn(0)
				SEND_SIGNAL(add_item, COMSIG_OBSERVER_MOVED)
			target.hud_used.update_robot_modules_display()
			if(istype(add_item, /obj/item/stack/))
				var/obj/item/stack/item_with_synth = add_item
				for(var/synth in item_with_synth.synths)
					var/found = target.module.synths.Find(synth)
					if(!found)
						source.module.synths.Remove(synth)
						target.module.synths.Add(synth)
					else
						item_with_synth.synths = list(target.module.synths[found])
				return TRUE
			if(istype(add_item, /obj/item/weapon/matter_decompiler/) || istype(add_item, /obj/item/device/dogborg/sleeper/compactor/decompiler/))
				var/obj/item/weapon/matter_decompiler/item_with_matter = add_item
				if(item_with_matter.metal)
					var/found = target.module.synths.Find(item_with_matter.metal)
					if(!found)
						source.module.synths.Remove(item_with_matter.metal)
						target.module.synths.Add(item_with_matter.metal)
					else
						item_with_matter.metal = target.module.synths[found]
				if(item_with_matter.glass)
					var/found = target.module.synths.Find(item_with_matter.glass)
					if(!found)
						source.module.synths.Remove(item_with_matter.glass)
						target.module.synths.Add(item_with_matter.glass)
					else
						item_with_matter.glass = target.module.synths[found]
				if(item_with_matter.wood)
					var/found = target.module.synths.Find(item_with_matter.wood)
					if(!found)
						source.module.synths.Remove(item_with_matter.wood)
						target.module.synths.Add(item_with_matter.wood)
					else
						item_with_matter.wood = target.module.synths[found]
				if(item_with_matter.plastic)
					var/found = target.module.synths.Find(item_with_matter.plastic)
					if(!found)
						source.module.synths.Remove(item_with_matter.plastic)
						target.module.synths.Add(item_with_matter.plastic)
					else
						item_with_matter.plastic = target.module.synths[found]
			return TRUE
		if("rem_module")
			var/obj/item/rem_item = locate(params["module"])
			target.uneq_all()
			target.hud_used.update_robot_modules_display(TRUE)
			target.module.emag.Remove(rem_item)
			target.module.modules.Remove(rem_item)
			target.module.contents.Remove(rem_item)
			qdel(rem_item)
			return TRUE
		if("swap_module")
			if(!source)
				return FALSE
			var/mod_type = source.modtype
			qdel(source.module)
			var/module_type = robot_modules[target.modtype]
			source.modtype = target.modtype
			new module_type(source)
			source.sprite_datum = target.sprite_datum
			source.update_icon()
			source.emag_items = 1
			// Target
			target.uneq_all()
			target.hud_used.update_robot_modules_display(TRUE)
			qdel(target.module)
			target.modtype = mod_type
			module_type = robot_modules[mod_type]
			target.transform_with_anim()
			new module_type(target)
			target.hands.icon_state = target.get_hud_module_icon()
			target.hud_used.update_robot_modules_display()
			return TRUE
		if("ert_toggle")
			target.crisis_override = !target.crisis_override
			target.module_reset(FALSE)
			return TRUE
		if("add_compatibility")
			target.module.supported_upgrades |= text2path(params["upgrade"])
			return TRUE
		if("rem_compatibility")
			target.module.supported_upgrades.Remove(text2path(params["upgrade"]))
			return TRUE
		if("add_upgrade")
			var/new_upgrade = text2path(params["upgrade"])
			if(new_upgrade == /obj/item/borg/upgrade/utility/reset)
				var/obj/item/borg/upgrade/utility/reset/rmodul = new_upgrade
				if(tgui_alert(usr, "Are you sure that you want to install [initial(rmodul.name)] and reset the robot's module?","Confirm",list("Yes","No"))!="Yes")
					return FALSE
			var/obj/item/borg/upgrade/U = new new_upgrade(null)
			if(new_upgrade == /obj/item/borg/upgrade/utility/rename)
				var/obj/item/borg/upgrade/utility/rename/UN = U
				var/new_name = sanitizeSafe(tgui_input_text(usr, "Enter new robot name", "Robot Reclassification", UN.heldname, MAX_NAME_LEN), MAX_NAME_LEN)
				if(new_name)
					UN.heldname = new_name
				U = UN
			if(istype(U, /obj/item/borg/upgrade/restricted))
				target.module.supported_upgrades |= new_upgrade
			if(!U.action(target))
				return FALSE
			U.loc = target
			target.hud_used.update_robot_modules_display()
			return TRUE
		if("install_modkit")
			var/new_modkit = text2path(params["modkit"])
			var/obj/item/weapon/gun/energy/kinetic_accelerator/kin = locate() in target.module.modules
			var/obj/item/borg/upgrade/modkit/M = new new_modkit(null)
			M.install(kin, target)
			return TRUE
		if("remove_modkit")
			var/obj/item/weapon/gun/energy/kinetic_accelerator/kin = locate() in target.module.modules
			var/obj/item/rem_kit = locate(params["modkit"])
			kin.modkits.Remove(rem_kit)
			qdel(rem_kit)
			return TRUE
		if("add_channel")
			var/selected_radio_channel = params["channel"]
			if(selected_radio_channel == CHANNEL_SPECIAL_OPS)
				target.radio.centComm = 1
			if(selected_radio_channel == CHANNEL_RAIDER)
				qdel(target.radio.keyslot)
				target.radio.keyslot = new /obj/item/device/encryptionkey/raider(target)
				target.radio.syndie = 1
			if(selected_radio_channel == CHANNEL_MERCENARY)
				qdel(target.radio.keyslot)
				target.radio.keyslot = new /obj/item/device/encryptionkey/syndicate(target)
				target.radio.syndie = 1
			target.module.channels += list("[selected_radio_channel]" = 1)
			target.radio.channels[selected_radio_channel] += target.module.channels[selected_radio_channel]
			target.radio.secure_radio_connections[selected_radio_channel] += radio_controller.add_object(target.radio, radiochannels[selected_radio_channel],  RADIO_CHAT)
			return TRUE
		if("rem_channel")
			var/selected_radio_channel = params["channel"]
			if(selected_radio_channel == CHANNEL_SPECIAL_OPS)
				target.radio.centComm = 0
			target.module.channels -= selected_radio_channel
			if((selected_radio_channel == CHANNEL_MERCENARY || selected_radio_channel == CHANNEL_RAIDER) && !(target.module.channels[CHANNEL_RAIDER] || target.module.channels[CHANNEL_MERCENARY]))
				qdel(target.radio.keyslot)
				target.radio.keyslot = null
				target.radio.syndie = 0
			target.radio.channels = list()
			for(var/n_chan in target.module.channels)
				target.radio.channels[n_chan] -= target.module.channels[n_chan]
			radio_controller.remove_object(target.radio, radiochannels[selected_radio_channel])
			target.radio.secure_radio_connections -= selected_radio_channel
			return TRUE
		if("add_component")
			var/datum/robot_component/C = locate(params["component"])
			if(C.wrapped)
				qdel(C.wrapped)
			if(istype(C, /datum/robot_component/actuator))
				C.wrapped = new /obj/item/robot_parts/robot_component/actuator(target)
			else if(istype(C, /datum/robot_component/radio))
				C.wrapped = new /obj/item/robot_parts/robot_component/radio(target)
			else if(istype(C, /datum/robot_component/cell))
				var/new_cell = text2path(params["cell"])
				target.cell = new new_cell(target)
				C.wrapped = target.cell
			else if(istype(C, /datum/robot_component/diagnosis_unit))
				C.wrapped = new /obj/item/robot_parts/robot_component/diagnosis_unit(target)
			else if(istype(C, /datum/robot_component/camera))
				C.wrapped = new /obj/item/robot_parts/robot_component/camera(target)
			else if(istype(C, /datum/robot_component/binary_communication))
				C.wrapped = new /obj/item/robot_parts/robot_component/binary_communication_device(target)
			else if(istype(C, /datum/robot_component/armour))
				C.wrapped = new /obj/item/robot_parts/robot_component/armour(target)
			C.brute_damage = 0
			C.electronics_damage = 0
			C.install()
			C.installed = 1
			return TRUE
		if("rem_component")
			var/datum/robot_component/C = locate(params["component"])
			if(!C.wrapped)
				return FALSE
			C.uninstall()
			C.brute_damage = 0
			C.electronics_damage = 0
			C.installed = 0
			qdel(C.wrapped)
			C.wrapped = null
			if(istype(C, /datum/robot_component/cell))
				target.cell = null
			return TRUE
		if("adjust_cell_charge")
			target.cell.charge = text2num(params["charge"])
			return TRUE
		if("adjust_brute")
			var/datum/robot_component/C = locate(params["component"])
			C.brute_damage = text2num(params["damage"])
			return TRUE
		if("adjust_electronics")
			var/datum/robot_component/C = locate(params["component"])
			C.electronics_damage = text2num(params["damage"])
			return TRUE
		if("add_access")
			target.idcard.access += text2num(params["access"])
			return TRUE
		if("rem_access")
			target.idcard.access -= text2num(params["access"])
			return TRUE
		if("add_centcom")
			target.idcard.access |= get_all_centcom_access()
			return TRUE
		if("rem_centcom")
			target.idcard.access -= get_all_centcom_access()
			return TRUE
		if("add_station")
			target.idcard.access |= get_all_station_access()
			target.idcard.access |= access_synth
			return TRUE
		if("rem_station")
			target.idcard.access -= get_all_station_access()
			target.idcard.access -= access_synth
			return TRUE
		if("law_channel")
			if(params["law_channel"] in target.law_channels())
				target.lawchannel = params["law_channel"]
			return TRUE
		if("state_law")
			var/datum/ai_law/AL = locate(params["ref"]) in target.laws.all_laws()
			if(AL)
				var/state_law = text2num(params["state_law"])
				target.laws.set_state_law(AL, state_law)
			return TRUE
		if("add_zeroth_law")
			if(zeroth_law && !target.laws.zeroth_law)
				target.set_zeroth_law(zeroth_law)
				target.lawsync()
			return TRUE
		if("add_ion_law")
			if(ion_law)
				target.add_ion_law(ion_law)
				target.lawsync()
			return TRUE
		if("add_inherent_law")
			if(inherent_law)
				target.add_inherent_law(inherent_law)
				target.lawsync()
			return TRUE
		if("add_supplied_law")
			if(supplied_law && supplied_law_position >= 1 && MIN_SUPPLIED_LAW_NUMBER <= MAX_SUPPLIED_LAW_NUMBER)
				target.add_supplied_law(supplied_law_position, supplied_law)
				target.lawsync()
			return TRUE
		if("change_zeroth_law")
			var/new_law = sanitize(params["val"])
			if(new_law && new_law != zeroth_law)
				zeroth_law = new_law
				target.lawsync()
			return TRUE
		if("change_ion_law")
			var/new_law = sanitize(params["val"])
			if(new_law && new_law != ion_law)
				ion_law = new_law
				target.lawsync()
			return TRUE
		if("change_inherent_law")
			var/new_law = sanitize(params["val"])
			if(new_law && new_law != inherent_law)
				inherent_law = new_law
				target.lawsync()
			return TRUE
		if("change_supplied_law")
			var/new_law = sanitize(params["val"])
			if(new_law && new_law != supplied_law)
				supplied_law = new_law
				target.lawsync()
			return TRUE
		if("change_supplied_law_position")
			var/new_position = tgui_input_number(usr, "Enter new supplied law position between 1 and [MAX_SUPPLIED_LAW_NUMBER], inclusive. Inherent laws at the same index as a supplied law will not be stated.", "Law Position", supplied_law_position, MAX_SUPPLIED_LAW_NUMBER, 1)
			if(isnum(new_position))
				supplied_law_position = CLAMP(new_position, 1, MAX_SUPPLIED_LAW_NUMBER)
				target.lawsync()
			return TRUE
		if("edit_law")
			var/datum/ai_law/AL = locate(params["edit_law"]) in target.laws.all_laws()
			if(AL)
				var/new_law = sanitize(tgui_input_text(usr, "Enter new law. Leaving the field blank will cancel the edit.", "Edit Law", AL.law))
				if(new_law && new_law != AL.law)
					AL.law = new_law
					target.lawsync()
				return TRUE
		if("delete_law")
			var/datum/ai_law/AL = locate(params["delete_law"]) in target.laws.all_laws()
			if(AL)
				target.delete_law(AL)
				target.lawsync()
			return TRUE
		if("state_laws")
			target.statelaws(target.laws)
			return TRUE
		if("state_law_set")
			var/datum/ai_laws/ALs = locate(params["state_law_set"]) in law_list
			if(ALs)
				target.statelaws(ALs)
			return TRUE
		if("transfer_laws")
			var/datum/ai_laws/ALs = locate(params["transfer_laws"]) in law_list
			if(ALs)
				ALs.sync(target, 0)
				target.lawsync()
			return TRUE
		if("notify_laws")
			to_chat(target, "<span class='danger'>Law Notice</span>")
			target.laws.show_laws(target)
			if(isAI(target))
				var/mob/living/silicon/ai/AI = target
				for(var/mob/living/silicon/robot/R in AI.connected_robots)
					to_chat(R, "<span class='danger'>Law Notice</span>")
					R.laws.show_laws(R)
			if(usr != target)
				to_chat(usr, "<span class='notice'>Laws displayed.</span>")
			return TRUE
		if("select_ai")
			selected_ai = locate(params["new_ai"])
			return TRUE
		if("toggle_sync")
			if(target.is_slaved())
				target.disconnect_from_ai()
				target.lawupdate = 0
			else
				var/new_ai = selected_ai ? select_ai : select_active_ai_with_fewest_borgs()
				if(new_ai)
					target.lawupdate = 1
					target.connect_to_ai(new_ai)
			return TRUE
		if("sneaky_toggle")
			target.lawupdate = !target.lawupdate
			return TRUE

/datum/eventkit/modify_robot/proc/get_target_items(var/mob/user)
	var/list/target_items = list()
	for(var/obj/item in target.module.modules)
		target_items += list(list("name" = item.name, "ref" = "\ref[item]", "icon" = icon2html(item, user, sourceonly=TRUE), "desc" = item.desc))
	return target_items

/datum/eventkit/modify_robot/proc/get_module_source(var/mob/user)
	var/list/source_list = list()
	source_list["model"] = source.module
	source_list["front"] = icon2base64(get_flat_icon(source,dir=SOUTH,no_anim=TRUE))
	var/list/source_items = list()
	for(var/obj/item in (source.module.modules | source.module.emag))
		var/exists
		for(var/obj/has_item in (target.module.modules + target.module.emag))
			if(has_item.name == item.name)
				exists = TRUE
				break
		if(exists)
			continue
		source_items += list(list("name" = item.name, "ref" = "\ref[item]", "icon" = icon2html(item, user, sourceonly=TRUE), "desc" = item.desc))
	source_list["modules"] = source_items
	return source_list

/datum/eventkit/modify_robot/proc/get_upgrades()
	var/list/all_upgrades = list()
	var/list/whitelisted_upgrades = list()
	var/list/blacklisted_upgrades = list()
	for(var/datum/design/item/prosfab/robot_upgrade/restricted/upgrade)
		if(!upgrade.name)
			continue
		if(!(initial(upgrade.build_path) in target.module.supported_upgrades))
			whitelisted_upgrades += list(list("name" = initial(upgrade.name), "path" = "[initial(upgrade.build_path)]"))
		else
			blacklisted_upgrades += list(list("name" = initial(upgrade.name), "path" = "[initial(upgrade.build_path)]"))
	all_upgrades["whitelisted_upgrades"] = whitelisted_upgrades
	all_upgrades["blacklisted_upgrades"] = blacklisted_upgrades
	var/list/utility_upgrades = list()
	for(var/datum/design/item/prosfab/robot_upgrade/utility/upgrade)
		if(!upgrade.name)
			continue
		if(!(target.has_upgrade(initial(upgrade.build_path))))
			utility_upgrades += list(list("name" = initial(upgrade.name), "path" = "[initial(upgrade.build_path)]"))
	all_upgrades["utility_upgrades"] = utility_upgrades
	var/list/basic_upgrades = list()
	for(var/datum/design/item/prosfab/robot_upgrade/basic/upgrade)
		if(!upgrade.name)
			continue
		if(!(target.has_upgrade(initial(upgrade.build_path))))
			basic_upgrades += list(list("name" = initial(upgrade.name), "path" = "[initial(upgrade.build_path)]", "installed" = 0))
		else
			basic_upgrades += list(list("name" = initial(upgrade.name), "path" = "[initial(upgrade.build_path)]", "installed" = 1))
	all_upgrades["basic_upgrades"] = basic_upgrades
	var/list/advanced_upgrades = list()
	for(var/datum/design/item/prosfab/robot_upgrade/advanced/upgrade)
		if(!upgrade.name)
			continue
		if(!(target.has_upgrade(initial(upgrade.build_path))))
			advanced_upgrades += list(list("name" = initial(upgrade.name), "path" = "[initial(upgrade.build_path)]", "installed" = 0))
		else
			advanced_upgrades += list(list("name" = initial(upgrade.name), "path" = "[initial(upgrade.build_path)]", "installed" = 1))
	all_upgrades["advanced_upgrades"] = advanced_upgrades
	var/list/restricted_upgrades = list()
	for(var/datum/design/item/prosfab/robot_upgrade/restricted/upgrade)
		if(!upgrade.name)
			continue
		if(!(target.has_upgrade(initial(upgrade.build_path))))
			if(!(initial(upgrade.build_path) in target.module.supported_upgrades))
				restricted_upgrades += list(list("name" = initial(upgrade.name), "path" = "[initial(upgrade.build_path)]", "installed" = 2))
				continue
			restricted_upgrades += list(list("name" = initial(upgrade.name), "path" = "[initial(upgrade.build_path)]", "installed" = 0))
		else
			restricted_upgrades += list(list("name" = initial(upgrade.name), "path" = "[initial(upgrade.build_path)]", "installed" = 1))
	all_upgrades["restricted_upgrades"] = restricted_upgrades
	return all_upgrades

/datum/eventkit/modify_robot/proc/get_pka(var/obj/item/weapon/gun/energy/kinetic_accelerator/kin)
	var/list/pka = list()
	pka["name"] = kin.name
	var/list/installed_modkits = list()
	for(var/obj/item/borg/upgrade/modkit/modkit in kin.modkits)
		installed_modkits += list(list("name" = modkit.name, "ref" = "\ref[modkit]", "costs" = modkit.cost))
	pka["installed_modkits"] = installed_modkits
	var/list/modkits = list()
	for(var/modkit in typesof(/obj/item/borg/upgrade/modkit))
		var/obj/item/borg/upgrade/modkit/single_modkit = modkit
		if(single_modkit == /obj/item/borg/upgrade/modkit)
			continue
		if(kin.get_remaining_mod_capacity() < initial(single_modkit.cost))
			modkits += list(list("name" = initial(single_modkit.name), "path" = single_modkit, "costs" = initial(single_modkit.cost), "denied" = TRUE, "denied_by" = "Insufficient capacity!"))
			continue
		if(initial(single_modkit.denied_type))
			var/number_of_denied = 0
			var/denied = FALSE
			for(var/A in kin.get_modkits())
				var/obj/item/borg/upgrade/modkit/M = A
				if(istype(M, initial(single_modkit.denied_type)))
					number_of_denied++
				if(number_of_denied >= initial(single_modkit.maximum_of_type))
					var/obj/item/denied_type = initial(single_modkit.denied_type)
					modkits += list(list("name" = initial(single_modkit.name), "path" = single_modkit, "costs" = initial(single_modkit.cost), "denied" = TRUE, "denied_by" = "[initial(denied_type.name)]"))
					denied = TRUE
					break
			if(denied)
				continue
		modkits += list(list("name" = initial(single_modkit.name), "path" = single_modkit, "costs" = initial(single_modkit.cost)))
	pka["modkits"] = modkits
	pka["capacity"] = kin.get_remaining_mod_capacity()
	pka["max_capacity"] = kin.max_mod_capacity
	return pka

/datum/eventkit/modify_robot/proc/get_cells()
	var/list/cell_options = list()
	for(var/cell in typesof(/obj/item/weapon/cell))
		var/obj/item/weapon/cell/C = cell
		if(initial(C.name) == "power cell")
			continue
		if(ispath(C, /obj/item/weapon/cell/standin))
			continue
		if(ispath(C, /obj/item/weapon/cell/device))
			continue
		if(ispath(C, /obj/item/weapon/cell/mech))
			continue
		if(cell_options[initial(C.name)]) // empty cells are defined after normal cells!
			continue
		cell_options += list(initial(C.name) = list("path" = "[C]", "charge" = initial(C.maxcharge), "max_charge" = initial(C.maxcharge), "charge_amount" = initial(C.charge_amount) , "self_charge" = initial(C.self_recharge))) // our cells do not have their charge predefined, they do it on init, so both maaxcharge for now
	return cell_options

/datum/eventkit/modify_robot/proc/get_components()
	var/list/components = list()
	for(var/entry in target.components)
		var/datum/robot_component/C = target.components[entry]
		components += list(list("name" = C.name, "ref" = "\ref[C]", "brute_damage" = C.brute_damage, "electronics_damage" = C.electronics_damage, "max_damage" = C.max_damage, "installed" = C.installed, "exists" = (C.wrapped ? TRUE : FALSE)))
	return components

/datum/eventkit/modify_robot/proc/package_laws(var/list/data, var/field, var/list/datum/ai_law/laws)
	var/list/packaged_laws = list()
	for(var/datum/ai_law/AL in laws)
		packaged_laws[++packaged_laws.len] = list("law" = AL.law, "index" = AL.get_index(), "state" = target.laws.get_state_law(AL), "ref" = "\ref[AL]")
	data[field] = packaged_laws
	data["has_[field]"] = packaged_laws.len

/datum/eventkit/modify_robot/proc/package_multiple_laws(var/list/datum/ai_laws/laws)
	var/list/law_sets = list()
	for(var/datum/ai_laws/ALs in laws)
		var/list/packaged_laws = list()
		package_laws(packaged_laws, "zeroth_laws", list(ALs.zeroth_law, ALs.zeroth_law_borg))
		package_laws(packaged_laws, "ion_laws", ALs.ion_laws)
		package_laws(packaged_laws, "inherent_laws", ALs.inherent_laws)
		package_laws(packaged_laws, "supplied_laws", ALs.supplied_laws)
		law_sets[++law_sets.len] = list("name" = ALs.name, "header" = ALs.law_header, "ref" = "\ref[ALs]","laws" = packaged_laws)
	return law_sets

/datum/eventkit/modify_robot/proc/is_malf(var/mob/user)
	return (is_admin(user) && !target.is_slaved()) || is_special_role(user)

/datum/eventkit/modify_robot/proc/is_special_role(var/mob/user)
	return user.mind.special_role ? TRUE : FALSE
