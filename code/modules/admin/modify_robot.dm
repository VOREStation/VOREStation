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

/datum/eventkit/modify_robot/New()
	. = ..()

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
		if(target.module)
			.["target"]["front"] = icon2base64(get_flat_icon(target,dir=SOUTH,no_anim=TRUE))
			.["target"]["side"] = icon2base64(get_flat_icon(target,dir=WEST,no_anim=TRUE))
			.["target"]["back"] = icon2base64(get_flat_icon(target,dir=NORTH,no_anim=TRUE))
			var/list/target_items = list()
			for(var/obj/item in target.module.modules)
				target_items += list(list("item" = item.name, "ref" = "\ref[item]", "icon" = icon2html(item, user, sourceonly=TRUE), "desc" = item.desc))
			.["target"]["modules"] = target_items
			var/list/module_options = list()
			for(var/module in robot_modules)
				module_options += module
			.["model_options"] = module_options
			if(source)
				.["source"] = list()
				.["source"]["model"] = source.module
				.["source"]["front"] = icon2base64(get_flat_icon(source,dir=SOUTH,no_anim=TRUE))
				var/list/source_items = list()
				for(var/obj/item in (source.module.modules | source.module.emag))
					var/exists
					for(var/obj/has_item in (target.module.modules + target.module.emag))
						if(has_item.name == item.name)
							exists = TRUE
							break
					if(exists)
						continue
					source_items += list(list("item" = item.name, "ref" = "\ref[item]", "icon" = icon2html(item, user, sourceonly=TRUE), "desc" = item.desc))
				.["source"]["modules"] = source_items
	var/list/all_robots = list()
	for(var/mob/living/silicon/robot/R in silicon_mob_list)
		if(!R.loc)
			continue
		var/list/info = list("displayText" = "[R]", "value" = "\ref[R]")
		all_robots.Add(list(info))
	.["all_robots"] = all_robots


/datum/eventkit/modify_robot/tgui_state(mob/user)
	return GLOB.tgui_admin_state

/datum/eventkit/modify_robot/tgui_act(action, params)
	. = ..()
	if(.)
		return
	switch(action)
		if("select_target")
			target = locate(params["new_target"])
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
			var/obj/item/add_item = locate(params["new_module"])
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
			var/obj/item/rem_item = locate(params["old_module"])
			target.uneq_all()
			target.hud_used.update_robot_modules_display(TRUE)
			target.module.emag.Remove(rem_item)
			target.module.modules.Remove(rem_item)
			target.module.contents.Remove(rem_item)
			qdel(rem_item)
			return TRUE
