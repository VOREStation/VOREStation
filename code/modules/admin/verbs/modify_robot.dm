//Allows to add and remove modules from bogs
/client/proc/modify_robot(var/mob/living/silicon/robot/target in player_list)
	set name = "Modify Robot Module"
	set desc = "Allows to add or remove modules to/from robots."
	set category = "Admin"
	if(!check_rights(R_ADMIN))
		return

	if(!istype(target))
		return

	if(!target.module.modules)
		return

	var/list/modification_options = list(MODIFIY_ROBOT_MODULE_ADD,MODIFIY_ROBOT_MODULE_REMOVE, MODIFIY_ROBOT_RADIOC_ADD, MODIFIY_ROBOT_RADIOC_REMOVE)

	var/modification_choice = tgui_input_list(usr, "Select if you want to add or remove a module to/from [target]","Choice", modification_options)
	if(!modification_choice)
		return

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
					robot.Destroy()
					break
				var/list/all_modules = robot.module.modules
				all_modules += robot.module.emag
				while(TRUE)
					var/add_item = tgui_input_list(usr, "Please select the module to add", "Modules", all_modules)
					if(!istype(add_item, /obj/item/))
						break
					to_chat(usr, "<span class='danger'>You added \"[add_item]\" to [target]</span>")
					robot.module.emag.Remove(add_item)
					robot.module.modules.Remove(add_item)
					robot.module.contents.Remove(add_item)
					target.module.modules.Add(add_item)
					target.module.contents.Add(add_item)
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
				robot.Destroy()
		if(MODIFIY_ROBOT_MODULE_REMOVE)
			while(TRUE)
				var/list/active_modules = target.module.modules
				var/selected_module_module = tgui_input_list(usr, "Please select the module to remove", "Modules", active_modules)
				if(!istype(selected_module_module, /obj/item/))
					break
				to_chat(usr, "<span class='danger'>You removed \"[selected_module_module]\" from [target]</span>")
				target.module.emag.Remove(selected_module_module)
				target.module.modules.Remove(selected_module_module)
				target.module.contents.Remove(selected_module_module)
				qdel(selected_module_module)
		if(MODIFIY_ROBOT_RADIOC_ADD)
			var/list/available_channels = radiochannels.Copy()
			for(var/has_channel in target.radio.channels)
				available_channels -= has_channel
			while(TRUE)
				var/selected_radio_channel = tgui_input_list(usr, "Please select the radio channel to add", "Channels", available_channels)
				if(!selected_radio_channel || selected_radio_channel == "Cancel")
					break
				to_chat(usr, "<span class='danger'>You added \"[selected_radio_channel]\" channel to [target]</span>")
				if(selected_radio_channel == "Special Ops")
					target.radio.centComm = 1
					to_chat(usr, "Debug, Add cetCOm key")
				if(selected_radio_channel == "Raider")
					qdel(target.radio.keyslot)
					target.radio.keyslot = new /obj/item/device/encryptionkey/raider(src)
					target.radio.syndie = 1
					to_chat(usr, "Debug, Add raid key")
				if(selected_radio_channel == "Mercenary")
					qdel(target.radio.keyslot)
					target.radio.keyslot = new /obj/item/device/encryptionkey/syndicate(src)
					target.radio.syndie = 1
				target.module.channels += list("[selected_radio_channel]" = 1)
				target.radio.channels[selected_radio_channel] += target.module.channels[selected_radio_channel]
				target.radio.secure_radio_connections[selected_radio_channel] += radio_controller.add_object(target.radio, radiochannels[selected_radio_channel],  RADIO_CHAT)
				available_channels -= selected_radio_channel
		if(MODIFIY_ROBOT_RADIOC_REMOVE)
			while(TRUE)
				var/selected_radio_channel = tgui_input_list(usr, "Please select the radio channel to remove", "Channels", target.radio.channels)
				if(!selected_radio_channel || selected_radio_channel == "Cancel")
					break
				to_chat(usr, "<span class='danger'>You removed \"[selected_radio_channel]\" channel from [target]</span>")
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
