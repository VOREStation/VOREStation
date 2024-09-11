//Allows to add and remove modules from borgs
/client/proc/modify_robot(var/mob/living/silicon/robot/target in silicon_mob_list)
	set name = "Modify Robot Module"
	set desc = "Allows to add or remove modules to/from robots."
	set category = "Admin"
	if(!check_rights(R_ADMIN|R_FUN|R_VAREDIT|R_EVENT))
		return

	if(!istype(target))
		return

	if(!target.module)
		var/list/pre_modification_options = list(MODIFIY_ROBOT_TOGGLE_ERT, MODIFIY_ROBOT_LIMIT_MODULES_ADD, MODIFIY_ROBOT_LIMIT_MODULES_REMOVE)
		while(TRUE)
			var/pre_modification_choice = tgui_input_list(usr, "Which pre module selection edits would you like to perform form [target]","Choice", pre_modification_options)
			if(!pre_modification_choice || pre_modification_choice == "Cancel")
				return
			switch(pre_modification_choice)
				if(MODIFIY_ROBOT_TOGGLE_ERT)
					if(tgui_alert(usr, "This robot has not yet selected a module. Would you like to toggle combat module override?","Confirm",list("Yes","No"))!="Yes")
						continue
					target.crisis_override = !target.crisis_override
					to_chat(usr, "<span class='danger'>You [target.crisis_override? "enabled":"disabled"] [target]'s combat module overwrite.</span>")
					continue
				if(MODIFIY_ROBOT_LIMIT_MODULES_ADD)
					if(target.restrict_modules_to.len)
						to_chat(usr, "<span class='warning'>[target]'s modules are already restricted. For details you can use the remove verb to show all active restrictions.</span>")
					var/list/possible_options = list()
					for(var/entry in robot_modules)
						if(!target.restrict_modules_to.Find(entry))
							possible_options += entry
					while(TRUE)
						var/selected_type = tgui_input_list(usr, "Please select the module type to add to the robot's restrictions. This will limit the module choices to the added types only.", "Module types", possible_options)
						if(!selected_type || selected_type == "Cancel")
							break
						possible_options -= selected_type
						target.restrict_modules_to += selected_type
						to_chat(usr, "<span class='danger'>You added [selected_type] to [target]'s possible modules list.</span>")
					continue
				if(MODIFIY_ROBOT_LIMIT_MODULES_REMOVE)
					while(TRUE)
						var/selected_type = tgui_input_list(usr, "Please select the module type to remove. Removing all module types here will allow default station module selection.", "Module types", target.restrict_modules_to)
						if(!selected_type || selected_type == "Cancel")
							to_chat(usr, "<span class='danger'>[target] uses the default module list without special restrictions.</span>")
							break
						target.restrict_modules_to -= selected_type
						to_chat(usr, "<span class='danger'>You removed [selected_type] from [target]'s possible modules list.</span>")
					continue

	if(!target.module.modules)
		return

	var/list/modification_options = list(MODIFIY_ROBOT_MODULE_ADD,MODIFIY_ROBOT_MODULE_REMOVE, MODIFIY_ROBOT_APPLY_UPGRADE, MODIFIY_ROBOT_SUPP_ADD, MODIFIY_ROBOT_SUPP_REMOVE, MODIFIY_ROBOT_RADIOC_ADD, MODIFIY_ROBOT_RADIOC_REMOVE,
		MODIFIY_ROBOT_COMP_ADD, MODIFIY_ROBOT_COMP_REMOVE, MODIFIY_ROBOT_SWAP_MODULE, MODIFIY_ROBOT_RESET_MODULE, MODIFIY_ROBOT_TOGGLE_ERT, MODIFIY_ROBOT_TOGGLE_STATION_ACCESS, MODIFIY_ROBOT_TOGGLE_CENT_ACCESS)

	while(TRUE)
		var/modification_choice = tgui_input_list(usr, "Select if you want to add or remove a module to/from [target]","Choice", modification_options)
		if(!modification_choice || modification_choice == "Cancel")
			return

		if(!target.module || !target.module.modules)
			to_chat(usr, "<span class='danger'>[target] was recently reset, you must wait until module selection has been completed before continuing modifying.</span>")
			continue

		log_and_message_admins("[key_name(src)] has used MODIFYROBOT ([modification_choice]) on [key_name(target)].")
		feedback_add_details("admin_verb","MODIFYROBOT") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

		switch(modification_choice)
			if(MODIFIY_ROBOT_MODULE_ADD)
				while(TRUE)
					var/selected_module_module = tgui_input_list(usr, "Please select the module to pick modules from", "Module", robot_modules)
					if(!selected_module_module || selected_module_module == "Cancel")
						break
					var/module_type = robot_modules[selected_module_module]
					var/mob/living/silicon/robot/robot = new /mob/living/silicon/robot(null)
					var/obj/item/weapon/robot_module/robot/robot_type = new module_type(robot)
					robot.emag_items = 1
					if(!istype(robot_type, /obj/item/weapon/robot_module/robot/))
						qdel(robot)
						break
					var/list/all_modules = robot.module.modules
					all_modules += robot.module.emag
					while(TRUE)
						var/add_item_select = tgui_input_list(usr, "Please select the module to add", "Modules", all_modules)
						if(!istype(add_item_select, /obj/item/))
							break
						var/obj/item/add_item = add_item_select
						robot.module.emag.Remove(add_item)
						robot.module.modules.Remove(add_item)
						robot.module.contents.Remove(add_item)
						target.module.modules.Add(add_item)
						target.module.contents.Add(add_item)
						spawn(0) //ChompEDIT Must be after to allow the movement to finish
							SEND_SIGNAL(add_item, COMSIG_OBSERVER_MOVED)//ChompEDIT - report the movement since setting loc doesn't call Move or Moved
						target.hud_used.update_robot_modules_display()
						to_chat(usr, "<span class='danger'>You added \"[add_item]\" to [target].</span>")
						if(istype(add_item, /obj/item/stack/))
							var/obj/item/stack/item_with_synth = add_item
							for(var/synth in item_with_synth.synths)
								var/found = target.module.synths.Find(synth)
								if(!found)
									robot.module.synths.Remove(synth)
									target.module.synths.Add(synth)
								else
									item_with_synth.synths = list(target.module.synths[found])
							continue
						if(istype(add_item, /obj/item/weapon/matter_decompiler/) || istype(add_item, /obj/item/device/dogborg/sleeper/compactor/decompiler/))
							var/obj/item/weapon/matter_decompiler/item_with_matter = add_item
							if(item_with_matter.metal)
								var/found = target.module.synths.Find(item_with_matter.metal)
								if(!found)
									robot.module.synths.Remove(item_with_matter.metal)
									target.module.synths.Add(item_with_matter.metal)
								else
									item_with_matter.metal = target.module.synths[found]
							if(item_with_matter.glass)
								var/found = target.module.synths.Find(item_with_matter.glass)
								if(!found)
									robot.module.synths.Remove(item_with_matter.glass)
									target.module.synths.Add(item_with_matter.glass)
								else
									item_with_matter.glass = target.module.synths[found]
							if(item_with_matter.wood)
								var/found = target.module.synths.Find(item_with_matter.wood)
								if(!found)
									robot.module.synths.Remove(item_with_matter.wood)
									target.module.synths.Add(item_with_matter.wood)
								else
									item_with_matter.wood = target.module.synths[found]
							if(item_with_matter.plastic)
								var/found = target.module.synths.Find(item_with_matter.plastic)
								if(!found)
									robot.module.synths.Remove(item_with_matter.plastic)
									target.module.synths.Add(item_with_matter.plastic)
								else
									item_with_matter.plastic = target.module.synths[found]
					qdel(robot)
			if(MODIFIY_ROBOT_MODULE_REMOVE)
				while(TRUE)
					var/list/active_modules = target.module.modules
					var/selected_module_module = tgui_input_list(usr, "Please select the module to remove", "Modules", active_modules)
					if(!istype(selected_module_module, /obj/item/))
						break
					to_chat(usr, "<span class='danger'>You removed \"[selected_module_module]\" from [target]</span>")
					target.uneq_all()
					target.hud_used.update_robot_modules_display(TRUE)
					target.module.emag.Remove(selected_module_module)
					target.module.modules.Remove(selected_module_module)
					target.module.contents.Remove(selected_module_module)
					qdel(selected_module_module)
			if(MODIFIY_ROBOT_APPLY_UPGRADE)
				var/list/upgrades = list()
				for(var/datum/design/item/prosfab/robot_upgrade/upgrade)
					if(!(target.has_upgrade(initial(upgrade.build_path))))
						upgrades[initial(upgrade.name)] = initial(upgrade.build_path)
				while(TRUE)
					var/selected_module_upgrade = tgui_input_list(usr, "Please select the module to remove", "Upgrades", upgrades)
					if(!selected_module_upgrade || selected_module_upgrade == "Cancel")
						break
					if(selected_module_upgrade == "Reset Module")
						if(tgui_alert(usr, "Are you sure that you want to install [selected_module_upgrade] and reset the robot's module?","Confirm",list("Yes","No"))!="Yes")
							continue
					var/new_upgrade = upgrades[capitalize(selected_module_upgrade)]
					upgrades.Remove(selected_module_upgrade)
					var/obj/item/borg/upgrade/U = new new_upgrade(src)
					if(selected_module_upgrade == "Rename Module")
						var/obj/item/borg/upgrade/utility/rename/UN = U
						var/new_name = sanitizeSafe(tgui_input_text(usr, "Enter new robot name", "Robot Reclassification", UN.heldname, MAX_NAME_LEN), MAX_NAME_LEN)
						if(new_name)
							UN.heldname = new_name
						U = UN
					if(istype(U, /obj/item/borg/upgrade/restricted))
						target.module.supported_upgrades |= new_upgrade
					if(U.action(target))
						to_chat(usr, "<span class='danger'>You apply the [U] to [target]!</span>")
						usr.drop_item()
						U.loc = target
						target.hud_used.update_robot_modules_display()
					else
						to_chat(usr, "<span class='danger'>Upgrade error!</span>")
					if(selected_module_upgrade == "Proto-Kinetic Accelerator")
						var/list/modkits = list()
						for(var/modkit in typesof(/obj/item/borg/upgrade/modkit))
							var/obj/item/borg/upgrade/modkit/single_modkit = modkit
							modkits["[initial(single_modkit.name)] [initial(single_modkit.cost)]"] = modkit
						modkits.Remove("kinetic accelerator modification kit 30")
						var/capacity = 100
						while(TRUE)
							var/selected_ka_upgrade = tgui_input_list(usr, "Do you want to install upgrades? Remaining capacity: [capacity]", "KA Upgrades", modkits)
							if(!selected_ka_upgrade || selected_ka_upgrade == "Cancel")
								break
							var/new_modkit = modkits[selected_ka_upgrade]
							var/obj/item/borg/upgrade/modkit/M = new new_modkit(src)
							var/obj/item/weapon/gun/energy/kinetic_accelerator/kin = locate() in target.module.modules
							if(kin.get_remaining_mod_capacity() >= M.cost)
								to_chat(usr, "<span class='danger'>You installed the [M] into the [kin], [capacity]% remaining!</span>")
								modkits.Remove(selected_ka_upgrade)
							M.install(kin, target)
							capacity = kin.get_remaining_mod_capacity()
			if(MODIFIY_ROBOT_SUPP_ADD)
				var/list/whitelisted_upgrades = list()
				for(var/datum/design/item/prosfab/robot_upgrade/restricted/upgrade)
					if(!(initial(upgrade.build_path) in target.module.supported_upgrades))
						whitelisted_upgrades[initial(upgrade.name)] = initial(upgrade.build_path)
				while(TRUE)
					var/selected_upgrade_type = tgui_input_list(usr, "Please select which upgrade you want this module to support", "Upgrades", whitelisted_upgrades)
					if(!selected_upgrade_type || selected_upgrade_type == "Cancel")
						break
					var/upgrade_path = whitelisted_upgrades[capitalize(selected_upgrade_type)]
					whitelisted_upgrades.Remove(selected_upgrade_type)
					target.module.supported_upgrades |= upgrade_path
			if(MODIFIY_ROBOT_SUPP_REMOVE)
				var/list/whitelisted_upgrades = list()
				for(var/datum/design/item/prosfab/robot_upgrade/restricted/upgrade)
					if((initial(upgrade.build_path) in target.module.supported_upgrades))
						whitelisted_upgrades[initial(upgrade.name)] = initial(upgrade.build_path)
				while(TRUE)
					var/selected_upgrade_type = tgui_input_list(usr, "Please select which upgrade you want this module to support", "Upgrades", whitelisted_upgrades)
					if(!selected_upgrade_type || selected_upgrade_type == "Cancel")
						break
					var/upgrade_path = whitelisted_upgrades[capitalize(selected_upgrade_type)]
					whitelisted_upgrades.Remove(selected_upgrade_type)
					target.module.supported_upgrades -= upgrade_path
			if(MODIFIY_ROBOT_RADIOC_ADD)
				var/list/available_channels = radiochannels.Copy()
				for(var/has_channel in target.radio.channels)
					available_channels -= has_channel
				while(TRUE)
					var/selected_radio_channel = tgui_input_list(usr, "Please select the radio channel to add", "Channels", available_channels)
					if(!selected_radio_channel || selected_radio_channel == "Cancel")
						break
					if(selected_radio_channel == "Special Ops")
						target.radio.centComm = 1
					if(selected_radio_channel == "Raider")
						qdel(target.radio.keyslot)
						target.radio.keyslot = new /obj/item/device/encryptionkey/raider(target)
						target.radio.syndie = 1
					if(selected_radio_channel == "Mercenary")
						qdel(target.radio.keyslot)
						target.radio.keyslot = new /obj/item/device/encryptionkey/syndicate(target)
						target.radio.syndie = 1
					target.module.channels += list("[selected_radio_channel]" = 1)
					target.radio.channels[selected_radio_channel] += target.module.channels[selected_radio_channel]
					target.radio.secure_radio_connections[selected_radio_channel] += radio_controller.add_object(target.radio, radiochannels[selected_radio_channel],  RADIO_CHAT)
					available_channels -= selected_radio_channel
					to_chat(usr, "<span class='danger'>You added \"[selected_radio_channel]\" channel to [target].</span>")
			if(MODIFIY_ROBOT_RADIOC_REMOVE)
				while(TRUE)
					var/selected_radio_channel = tgui_input_list(usr, "Please select the radio channel to remove", "Channels", target.radio.channels)
					if(!selected_radio_channel || selected_radio_channel == "Cancel")
						break
					if(selected_radio_channel == "Special Ops")
						target.radio.centComm = 0
					target.module.channels -= selected_radio_channel
					if((selected_radio_channel == "Mercenary" || selected_radio_channel == "Raider") && !(target.module.channels["Raider"] || target.module.channels["Mercenary"]))
						qdel(target.radio.keyslot)
						target.radio.keyslot = null
						target.radio.syndie = 0
					target.radio.channels = list()
					for(var/n_chan in target.module.channels)
						target.radio.channels[n_chan] -= target.module.channels[n_chan]
					radio_controller.remove_object(target.radio, radiochannels[selected_radio_channel])
					target.radio.secure_radio_connections -= selected_radio_channel
					to_chat(usr, "<span class='danger'>You removed \"[selected_radio_channel]\" channel from [target].</span>")
			if(MODIFIY_ROBOT_COMP_ADD)
				while(TRUE)
					var/selected_component = tgui_input_list(usr, "Please select the component to add or replace", "Component", target.components)
					if(!selected_component || selected_component == "Cancel")
						break
					var/datum/robot_component/C = target.components[selected_component]
					if(C.wrapped && selected_component != "power cell")
						qdel(C.wrapped)
					switch(selected_component)
						if("actuator")
							C.wrapped = new /obj/item/robot_parts/robot_component/actuator(target)
						if("radio")
							C.wrapped = new /obj/item/robot_parts/robot_component/radio(target)
						if("power cell")
							var/list/recommended_cells = list(/obj/item/weapon/cell/robot_station, /obj/item/weapon/cell/high, /obj/item/weapon/cell/super, /obj/item/weapon/cell/robot_syndi, /obj/item/weapon/cell/hyper,
								/obj/item/weapon/cell/infinite, /obj/item/weapon/cell/potato, /obj/item/weapon/cell/slime)
							var/list/cell_names = list()
							for(var/cell_type in recommended_cells)
								var/obj/item/weapon/cell/single_cell = cell_type
								cell_names[capitalize(initial(single_cell.name))] = cell_type
							var/selected_cell = tgui_input_list(usr, "What kind of cell do you want to install?", "Cells", cell_names)
							if(!selected_cell || selected_cell == "Cancel")
								continue
							qdel(C.wrapped)
							var/new_power_cell = cell_names[capitalize(selected_cell)]
							target.cell = new new_power_cell(target)
							C.wrapped = target.cell
							to_chat(usr, "<span class='danger'>You replaced \"[C]\" on [target] with \"[selected_cell]\".</span>")
						if("diagnosis unit")
							C.wrapped = new /obj/item/robot_parts/robot_component/diagnosis_unit(target)
						if("camera")
							C.wrapped = new /obj/item/robot_parts/robot_component/camera(target)
						if("comms")
							C.wrapped = new /obj/item/robot_parts/robot_component/binary_communication_device(target)
						if("armour")
							C.wrapped = new /obj/item/robot_parts/robot_component/armour(target)
					C.install()
					C.installed = 1
					if(selected_component != "power cell")
						to_chat(usr, "<span class='danger'>You repplaced \"[C]\" on [target].</span>")
			if(MODIFIY_ROBOT_COMP_REMOVE)
				while(TRUE)
					var/selected_component = tgui_input_list(usr, "Please select the component to remove", "Component", target.components)
					if(!selected_component || selected_component == "Cancel")
						break
					var/datum/robot_component/C = target.components[selected_component]
					if(C.wrapped)
						C.uninstall()
						C.installed = 0
						qdel(C.wrapped)
						C.wrapped = null
						if(selected_component == "power cell")
							target.cell = null
					to_chat(usr, "<span class='danger'>You removed \"[C]\" from [target]</span>")
			if(MODIFIY_ROBOT_SWAP_MODULE)
				var/selected_module = tgui_input_list(usr, "Which Module would you like to use?", "Module", robot_modules)
				if(!selected_module || selected_module == "Cancel")
					continue
				if(!(selected_module in robot_modules))
					continue
				target.uneq_all()
				target.hud_used.update_robot_modules_display(TRUE)
				target.modtype = initial(target.modtype)
				target.module.Reset(target)
				qdel(target.module)
				target.modtype = selected_module
				var/module_type = robot_modules[selected_module]
				target.transform_with_anim()
				new module_type(target)
				target.hands.icon_state = target.get_hud_module_icon()
				target.hud_used.update_robot_modules_display()
			if(MODIFIY_ROBOT_RESET_MODULE)
				if(tgui_alert(usr, "Are you sure that you want to reset the entire module?","Confirm",list("Yes","No"))!="Yes")
					continue
				target.module_reset(FALSE)
				to_chat(usr, "<span class='danger'>You resetted [target]'s module selection.</span>")
			if(MODIFIY_ROBOT_TOGGLE_ERT)
				target.crisis_override = !target.crisis_override
				to_chat(usr, "<span class='danger'>You [target.crisis_override? "enabled":"disabled"] [target]'s combat module overwrite.</span>")
				if(tgui_alert(usr, "Do you want to reset the module as well to allow selection?","Confirm",list("Yes","No"))!="Yes")
					continue
				target.module_reset(FALSE)
			if(MODIFIY_ROBOT_TOGGLE_STATION_ACCESS)
				if(target?.idcard?.GetAccess())
					var/obj/item/weapon/card/id/synthetic/card = target.idcard
					if(access_synth in card.GetAccess())
						card.access -= get_all_station_access()
						card.access -= access_synth
						to_chat(usr, "<span class='danger'>You revoke station access from [target].</span>")
					else
						card.access |= get_all_station_access()
						card.access |= access_synth
						to_chat(usr, "<span class='danger'>You grant station access to [target].</span>")
			if(MODIFIY_ROBOT_TOGGLE_CENT_ACCESS)
				if(target?.idcard?.GetAccess())
					var/obj/item/weapon/card/id/synthetic/card = target.idcard
					if(access_cent_specops in card.GetAccess())
						card.access -= get_all_centcom_access()
						to_chat(usr, "<span class='danger'>You revoke central access from [target].</span>")
					else
						card.access |= get_all_centcom_access()
						to_chat(usr, "<span class='danger'>You grant central access to [target].</span>")
