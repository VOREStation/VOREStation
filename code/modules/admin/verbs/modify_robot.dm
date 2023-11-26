//Allows to add and remove modules from bogs
/client/proc/modify_robot(var/mob/living/silicon/robot/target in player_list)
	set name = "Modify Robot Module"
	set desc = "Allows to add or remove modules to/from robots."
	set category = "Admin"
	if(!check_rights(R_ADMIN))
		return

	if(!istype(target))
		return

	var/list/modification_options = list(MODIFIY_ROBOT_MODULE_ADD,MODIFIY_ROBOT_MODULE_REMOVE)

	var/modification_choice = tgui_input_list(usr, "Select if you want to add or remove a module to/from [target]","Choice", modification_options)
	if(!modification_choice)
		return

	log_and_message_admins("[key_name(src)] has used MODIFYROBOT ([modification_choice]) on [key_name(target)].")
	feedback_add_details("admin_verb","MODIFYROBOT") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

	switch(modification_choice)
		if(MODIFIY_ROBOT_MODULE_ADD)
			while(TRUE)
				var/selection = tgui_input_list(usr, "Please select the module to pick modules from", "Module", robot_modules)
				if(!selection || selection == "Cancel")
					break
				var/module_type = robot_modules[selection]
				var/mob/living/silicon/robot/robot = new /mob/living/silicon/robot(null)
				var/obj/item/weapon/robot_module/robot/robot_type = new module_type(robot)
				robot.emag_items = 1
				if(!istype(robot_type, /obj/item/weapon/robot_module/robot/))
					robot.Destroy()
					break
				while(TRUE)
					var/list/all_modules = robot.module.modules
					all_modules += robot.module.emag
					var/add_item = tgui_input_list(usr, "Please select the modules to add", "Modules", all_modules)
					if(!istype(add_item, /obj/item/))
						break
					to_chat(usr, "<span class='danger'>You added [add_item] to [target]</span>")
					robot.module.modules.Remove(add_item)
					robot.module.contents.Remove(add_item)
					target.module.modules.Add(add_item)
					target.module.contents.Add(add_item)
				robot.Destroy()
		if(MODIFIY_ROBOT_MODULE_REMOVE)
			if(!target.module.modules)
				return
			while(TRUE)
				var/list/active_modules = target.module.modules
				if(target.emagged || target.emag_items)
					active_modules += target.module.emag
				var/selected_module_module = tgui_input_list(usr, "Please select the modules to remove", "Modules", active_modules)
				if(!istype(selected_module_module, /obj/item/))
					break
				target.module.modules.Remove(selected_module_module)
				target.module.contents.Remove(selected_module_module)
				qdel(selected_module_module)
