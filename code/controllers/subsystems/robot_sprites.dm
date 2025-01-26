SUBSYSTEM_DEF(robot_sprites)
	name = "Robot Sprites"
	init_order = INIT_ORDER_ROBOT_SPRITES
	flags = SS_NO_FIRE
	var/list/all_cyborg_sprites = list()
	var/list/cyborg_sprites_by_module = list()
	var/list/whitelisted_sprites_by_module = list()
	var/list/all_test_sprites = list()

/datum/controller/subsystem/robot_sprites/Initialize()
	initialize_borg_sprites()
	load_test_sprites()
	return SS_INIT_SUCCESS

/datum/controller/subsystem/robot_sprites/proc/initialize_borg_sprites()

	var/list/all_paths = typesof(/datum/robot_sprite)

	//Let's sort this a little
	var/list/dogborg_paths = typesof(/datum/robot_sprite/dogborg)
	var/list/tallborg_paths = typesof(/datum/robot_sprite/dogborg/tall)
	all_paths -= dogborg_paths
	dogborg_paths -= tallborg_paths
	all_paths |= dogborg_paths
	all_paths |= tallborg_paths


	for(var/spath in all_paths)
		var/datum/robot_sprite/RS = new spath()

		if(!RS.name || !RS.module_type)			// We're a technical kinda datum
			qdel(RS)
			continue

		all_cyborg_sprites |= src

		if(islist(RS.module_type))
			for(var/M in RS.module_type)
				if(RS.is_whitelisted)
					if(!(M in whitelisted_sprites_by_module))
						whitelisted_sprites_by_module += M
						whitelisted_sprites_by_module[M] = list()
					whitelisted_sprites_by_module[M] |= RS
				else
					if(!(M in cyborg_sprites_by_module))
						cyborg_sprites_by_module += M
						cyborg_sprites_by_module[M] = list()
					cyborg_sprites_by_module[M] |= RS
		else
			if(RS.is_whitelisted)
				if(!(RS.module_type in whitelisted_sprites_by_module))
					whitelisted_sprites_by_module += RS.module_type
					whitelisted_sprites_by_module[RS.module_type] = list()
				whitelisted_sprites_by_module[RS.module_type] |= RS
			else
				if(!(RS.module_type in cyborg_sprites_by_module))
					cyborg_sprites_by_module += RS.module_type
					cyborg_sprites_by_module[RS.module_type] = list()
				cyborg_sprites_by_module[RS.module_type] |= RS

/datum/controller/subsystem/robot_sprites/proc/get_module_sprites(var/module, var/mob/living/silicon/robot/wlcheck)
	. = list()

	if(!module || !(module in cyborg_sprites_by_module))
		return

	if(wlcheck && istype(wlcheck))
		. |= get_whitelisted_sprites(wlcheck.ckey, wlcheck.sprite_name, module)

	. |= cyborg_sprites_by_module[module]

	return

/datum/controller/subsystem/robot_sprites/proc/get_module_sprites_len(var/module, var/mob/living/silicon/robot/wlcheck)
	if(!module || (!(module in cyborg_sprites_by_module) && !(module in whitelisted_sprites_by_module)))
		return 0

	var/list/sprite_list = cyborg_sprites_by_module[module]

	if(wlcheck && istype(wlcheck))
		sprite_list |= get_whitelisted_sprites(wlcheck.ckey, wlcheck.sprite_name, module)

	if(!islist(sprite_list))
		return 0

	return sprite_list.len

/datum/controller/subsystem/robot_sprites/proc/get_default_module_sprite(var/module)

	var/list/module_sprites = get_module_sprites(module)

	if(!module_sprites || !module_sprites.len)
		return

	var/chosen_sprite
	for(var/datum/robot_sprite/sprite in module_sprites)
		if(sprite.default_sprite)
			chosen_sprite = sprite
			break
	if(!chosen_sprite)
		chosen_sprite = module_sprites[1]

	return chosen_sprite

/datum/controller/subsystem/robot_sprites/proc/get_whitelisted_sprites(var/ckey, var/spritename, var/module)
	. = list()

	if(!ckey || !spritename || !module || !(module in whitelisted_sprites_by_module))
		return

	for(var/datum/robot_sprite/RS in whitelisted_sprites_by_module[module])
		if(RS.whitelist_ckey == ckey) //If we're trusting people to be a custom borg, does the whitelist_charname really matter? Leaving untouched for downstream, but really.
			. |= RS

	return

// This is mostly for sprite testing, don't use it in active productions!
/datum/controller/subsystem/robot_sprites/proc/load_test_sprites()
	var/list/test_sprites = list()
	// file name must be robot_xxy.dmi -> testborg_64x32
	var/path = "icons/mob/robot/testdir/"
	for(var/f in flist(path))
		if(!findtext(f, regex(".dmi")))
			continue
		test_sprites += list("[f]" = file("[path][f]"))
	for(var/sprite in test_sprites)
		var/datum/robot_sprite/RS = new()
		all_test_sprites += RS
		RS.sprite_flags = 0
		RS.rest_sprite_options = list()
		RS.sprite_icon = test_sprites[sprite]
		var/splitted = splittext(sprite, "_")
		RS.name = splitted[1]
		RS.sprite_icon_state = splitted[1]
		splitted = splittext(splitted[2], "x")
		RS.pixel_x = (32 - text2num(splitted[1])) / 2
		RS.icon_x = text2num(splitted[1])
		RS.icon_y = text2num(splitted[2])
		RS.vis_height = text2num(splitted[2])
		var/list/icon_states = icon_states(RS.sprite_icon)
		for(var/icon in icon_states)
			// testing whitelist functionality ckey-...
			if(findtext(icon, regex("ckey-")))
				var/list/owner = splittext(icon, "-")
				RS.whitelist_ckey = owner[3]
				RS.is_whitelisted = TRUE
				continue
			// testing module types slots modules-...
			if(findtext(icon, regex("modules-")))
				var/list/jobs = splittext(icon, "-")
				jobs -= "modules"
				RS.module_type = jobs
				continue
			// Check for all the possible overlays
			if(findtext(icon, regex("-roll")))
				RS.sprite_flags |= ROBOT_HAS_SPEED_SPRITE
				continue
			if(findtext(icon, regex("-shield")))
				RS.sprite_flags |= ROBOT_HAS_SHIELD_SPRITE
				continue
			if(findtext(icon, regex("-speed_shield")))
				RS.sprite_flags |= ROBOT_HAS_SHIELD_SPEED_SPRITE
				continue
			if(findtext(icon, regex("-melee",)))
				RS.sprite_flags |= ROBOT_HAS_MELEE_SPRITE
				continue
			if(findtext(icon, regex("-dagger")))
				RS.sprite_flags |= ROBOT_HAS_DAGGER_SPRITE
				continue
			if(findtext(icon, regex("-blade")))
				RS.sprite_flags |= ROBOT_HAS_BLADE_SPRITE
				continue
			if(findtext(icon, regex("-gun")))
				RS.sprite_flags |= ROBOT_HAS_GUN_SPRITE
				continue
			if(findtext(icon, regex("-laser")))
				RS.sprite_flags |= ROBOT_HAS_LASER_SPRITE
				continue
			if(findtext(icon, regex("-taser")))
				RS.sprite_flags |= ROBOT_HAS_TASER_SPRITE
				continue
			if(findtext(icon, regex("-disabler")))
				RS.sprite_flags |= ROBOT_HAS_DISABLER_SPRITE
				continue
			if(findtext(icon, regex("-eyes")))
				RS.has_eye_sprites = TRUE
				continue
			if(findtext(icon, regex("-lights")))
				RS.has_eye_light_sprites = TRUE
				continue
			if(findtext(icon, regex("-decals")))
				RS.has_robotdecal_sprites = TRUE
				continue
			if(findtext(icon, regex("-openpanel_w")))
				RS.has_custom_open_sprites = TRUE
				continue
			if(findtext(icon, regex("-\\d-rest")))
				RS.has_vore_belly_resting_sprites = TRUE
				continue
			if(findtext(icon, regex("-\\d-sit")))
				RS.has_vore_belly_resting_sprites = TRUE
				continue
			if(findtext(icon, regex("-\\d-bellyup")))
				RS.has_vore_belly_resting_sprites = TRUE
				continue
			if(findtext(icon, regex("-\\d-\[a-z\]$")))
				var/list/belly = splittext(icon, "-")
				var/capacity = text2num(belly[3])
				if(!RS.belly_light_list)
					RS.belly_light_list = list()
				if(isnum(capacity))
					if(!RS.belly_light_list[belly[2]])
						RS.belly_light_list[belly[2]] = capacity
					else if(RS.belly_light_list[belly[2]] < capacity)
						RS.belly_light_list[belly[2]] = capacity
				continue
			if(findtext(icon, regex("-\\d$")))
				var/list/belly = splittext(icon, "-")
				var/capacity = text2num(belly[3])
				if(!RS.belly_capacity_list)
					RS.belly_capacity_list = list()
				if(isnum(capacity))
					if(!RS.belly_capacity_list[belly[2]])
						RS.belly_capacity_list[belly[2]] = capacity
					else if(RS.belly_capacity_list[belly[2]] < capacity)
						RS.belly_capacity_list[belly[2]] = capacity
				continue
			if(findtext(icon, regex("-sit")))
				RS.has_rest_sprites = TRUE
				RS.rest_sprite_options |= list("Sit")
				continue
			if(findtext(icon, regex("-rest")))
				RS.has_rest_sprites = TRUE
				RS.rest_sprite_options |= list("Default")
				continue
			if(findtext(icon, regex("-bellyup")))
				RS.has_rest_sprites = TRUE
				RS.rest_sprite_options |= list("Bellyup")
				continue
			if(findtext(icon, regex("-wreck")))
				RS.has_dead_sprite = TRUE
				continue
			if(findtext(icon, regex("wreck-overlay")))
				RS.has_dead_sprite_overlay = TRUE
				continue
		// We want to test it, so just give it all if there were non defined in the dmi
		if(!RS.module_type)
			RS.module_type = list("Standard", "Engineering", "Surgeon", "Crisis", "Miner", "Janitor", "Service", "Clerical", "Security", "Research")
		// Apply it to the possible modules, there will be no preview icon in the module selection as those datums are not ran through icon forge
		if(islist(RS.module_type))
			for(var/M in RS.module_type)
				if(RS.is_whitelisted)
					if(!(M in whitelisted_sprites_by_module))
						whitelisted_sprites_by_module += M
						whitelisted_sprites_by_module[M] = list()
					whitelisted_sprites_by_module[M] |= RS
				else
					if(!(M in cyborg_sprites_by_module))
						cyborg_sprites_by_module += M
						cyborg_sprites_by_module[M] = list()
					cyborg_sprites_by_module[M] |= RS
		else
			if(RS.is_whitelisted)
				if(!(RS.module_type in whitelisted_sprites_by_module))
					whitelisted_sprites_by_module += RS.module_type
					whitelisted_sprites_by_module[RS.module_type] = list()
				whitelisted_sprites_by_module[RS.module_type] |= RS
			else
				if(!(RS.module_type in cyborg_sprites_by_module))
					cyborg_sprites_by_module += RS.module_type
					cyborg_sprites_by_module[RS.module_type] = list()
				cyborg_sprites_by_module[RS.module_type] |= RS

/datum/controller/subsystem/robot_sprites/proc/clear_test_sprites()
	// Clears all our test sprites, allows spriters to reload the dmis after edits ingame
	for(var/datum/robot_sprite/RS in all_test_sprites)
		if(islist(RS.module_type))
			for(var/M in RS.module_type)
				if(RS.is_whitelisted)
					if(M in whitelisted_sprites_by_module)
						whitelisted_sprites_by_module[M] -= RS
				else
					if(M in cyborg_sprites_by_module)
						cyborg_sprites_by_module[M] -= RS
		else
			if(RS.is_whitelisted)
				if(RS.module_type in whitelisted_sprites_by_module)
					whitelisted_sprites_by_module[RS.module_type] -= RS
			else
				if(RS.module_type in cyborg_sprites_by_module)
					cyborg_sprites_by_module[RS.module_type] -= RS
		all_test_sprites -= RS
		qdel(RS)

/datum/controller/subsystem/robot_sprites/proc/reload_test_sprites()
	clear_test_sprites()
	load_test_sprites()
