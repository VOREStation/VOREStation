GLOBAL_LIST_EMPTY(robot_sprite_sheets)

/datum/asset/spritesheet_batched/robot_icons
	_abstract = /datum/asset/spritesheet_batched/robot_icons
	name = "robot_icons"
	var/module_type

/datum/asset/spritesheet_batched/robot_icons/standard
	name = "robot_icons_standard"
	module_type = "Standard"

/datum/asset/spritesheet_batched/robot_icons/service
	name = "robot_icons_service"
	module_type = "Service"

/datum/asset/spritesheet_batched/robot_icons/clerical
	name = "robot_icons_clerical"
	module_type = "Clerical"

/datum/asset/spritesheet_batched/robot_icons/clown
	name = "robot_icons_clown"
	module_type = "Clown"

/datum/asset/spritesheet_batched/robot_icons/command
	name = "robot_icons_command"
	module_type = "Command"

/datum/asset/spritesheet_batched/robot_icons/research
	name = "robot_icons_research"
	module_type = "Research"

/datum/asset/spritesheet_batched/robot_icons/miner
	name = "robot_icons_miner"
	module_type = "Miner"

/* Module not in use
/datum/asset/spritesheet_batched/robot_icons/crisis
	name = "robot_icons_crisis"
	module_type = "Crisis"
*/

/datum/asset/spritesheet_batched/robot_icons/surgeon
	name = "robot_icons_surgeon"
	module_type = "Surgeon"

/datum/asset/spritesheet_batched/robot_icons/security
	name = "robot_icons_security"
	module_type = "Security"

/datum/asset/spritesheet_batched/robot_icons/combat
	name = "robot_icons_combat"
	module_type = "Combat"

/datum/asset/spritesheet_batched/robot_icons/exploration
	name = "robot_icons_exploration"
	module_type = "Exploration"

/datum/asset/spritesheet_batched/robot_icons/engineering
	name = "robot_icons_engineering"
	module_type = "Engineering"

/datum/asset/spritesheet_batched/robot_icons/janitor
	name = "robot_icons_janitor"
	module_type = "Janitor"

/datum/asset/spritesheet_batched/robot_icons/gravekeeper
	name = "robot_icons_gravekeeper"
	module_type = "Gravekeeper"

/datum/asset/spritesheet_batched/robot_icons/lost
	name = "robot_icons_lost"
	module_type = "Lost"

/datum/asset/spritesheet_batched/robot_icons/protector
	name = "robot_icons_protector"
	module_type = "Protector"

/datum/asset/spritesheet_batched/robot_icons/mechanist
	name = "robot_icons_mechanist"
	module_type = "Mechanist"

/datum/asset/spritesheet_batched/robot_icons/combat_medic
	name = "robot_icons_combat_medic"
	module_type = "Combat Medic"

/datum/asset/spritesheet_batched/robot_icons/ninja
	name = "robot_icons_ninja"
	module_type = "Ninja"

/datum/asset/spritesheet_batched/robot_icons/create_spritesheets()
	if(!module_type)
		return
	for(var/datum/robot_sprite/S as anything in SSrobot_sprites.all_cyborg_sprites)
		if(!S.name || !S.sprite_icon_state) // snowflake out those customs... they suck
			continue
		if(islist(S.module_type))
			if(!(module_type in S.module_type))
				continue
		else if(S.module_type != module_type)
			continue

		var/datum/universal_icon/I_N = uni_icon(S.sprite_icon, S.sprite_icon_state, NORTH)
		var/datum/universal_icon/I_S = uni_icon(S.sprite_icon, S.sprite_icon_state, SOUTH)
		var/datum/universal_icon/I_W = uni_icon(S.sprite_icon, S.sprite_icon_state, WEST)
		var/datum/universal_icon/I_E = uni_icon(S.sprite_icon, S.sprite_icon_state, EAST)

		if(S.has_eye_sprites)
			var/datum/universal_icon/I_NE = uni_icon(S.sprite_icon, "[S.sprite_icon_state]-eyes", NORTH)
			if(I_NE)
				I_N.blend_icon(I_NE, ICON_OVERLAY)
		if(S.has_eye_sprites)
			var/datum/universal_icon/I_SE = uni_icon(S.sprite_icon, "[S.sprite_icon_state]-eyes", SOUTH)
			if(I_SE)
				I_S.blend_icon(I_SE, ICON_OVERLAY)
		if(S.has_eye_sprites)
			var/datum/universal_icon/I_WE = uni_icon(S.sprite_icon, "[S.sprite_icon_state]-eyes", WEST)
			if(I_WE)
				I_W.blend_icon(I_WE, ICON_OVERLAY)
		if(S.has_eye_sprites)
			var/datum/universal_icon/I_EE = uni_icon(S.sprite_icon, "[S.sprite_icon_state]-eyes", EAST)
			if(I_EE)
				I_E.blend_icon(I_EE, ICON_OVERLAY)

		var/imgid = sanitize_css_class_name("[S.type]")
		if(S.icon_x > S.icon_y)
			var/buffer = (S.icon_x - S.icon_y) / 2
			I_N.crop(0, -buffer, S.icon_x, S.icon_y + buffer)
			I_S.crop(0, -buffer, S.icon_x, S.icon_y + buffer)
			I_W.crop(0, -buffer, S.icon_x, S.icon_y + buffer)
			I_E.crop(0, -buffer, S.icon_x, S.icon_y + buffer)
		else if (S.icon_x < S.icon_y)
			var/buffer = (S.icon_y - S.icon_x) / 2
			I_N.crop(-buffer, 0, S.icon_x + buffer, S.icon_y)
			I_S.crop(-buffer, 0, S.icon_x + buffer, S.icon_y)
			I_W.crop(-buffer, 0, S.icon_x + buffer, S.icon_y)
			I_E.crop(-buffer, 0, S.icon_x + buffer, S.icon_y)
		I_N.scale(120, 120)
		I_S.scale(120, 120)
		I_W.scale(120, 120)
		I_E.scale(120, 120)

		insert_icon(imgid + "N", I_N)
		insert_icon(imgid + "S", I_S)
		insert_icon(imgid + "W", I_W)
		insert_icon(imgid + "E", I_E)

	GLOB.robot_sprite_sheets[module_type] = src
