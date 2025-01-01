/datum/asset/spritesheet_batched/robot_icons
	name = "robot_icons"

/datum/asset/spritesheet_batched/robot_icons/create_spritesheets()
	for(var/datum/robot_sprite/S as anything in typesof(/datum/robot_sprite))
		if(!S.name || !S.sprite_icon_state) // snowflake out those customs... they suck
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
