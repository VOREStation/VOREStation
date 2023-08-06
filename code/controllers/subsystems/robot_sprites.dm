#define DEFAULT_ROBOT_SPRITE_NAME "M-USE NanoTrasen"

SUBSYSTEM_DEF(robot_sprites)
	name = "Robot Sprites"
	init_order = INIT_ORDER_ROBOT_SPRITES
	flags = SS_NO_FIRE
	var/list/all_cyborg_sprites = list()
	var/list/cyborg_sprites_by_module = list()
	var/list/whitelisted_sprites_by_module = list()

/datum/controller/subsystem/robot_sprites/Initialize()
	initialize_borg_sprites()
	..()

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

		if(!(RS.name) || !(RS.module_type))			// We're a technical kinda datum
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
			if(!(RS.module_type in cyborg_sprites_by_module))
				cyborg_sprites_by_module += RS.module_type
				cyborg_sprites_by_module[RS.module_type] = list()
			cyborg_sprites_by_module[RS.module_type] |= RS

/datum/controller/subsystem/robot_sprites/proc/get_module_sprites(var/module)
	. = list()

	if(!module || !(module in cyborg_sprites_by_module))
		return

	. |= cyborg_sprites_by_module[module]

	return

/datum/controller/subsystem/robot_sprites/proc/get_module_sprites_len(var/module)
	if(!module || !(module in cyborg_sprites_by_module))
		return 0

	var/list/sprite_list = cyborg_sprites_by_module[module]

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
		if(RS.whitelist_ckey == ckey && RS.whitelist_charname == spritename)
			. |= RS

	return