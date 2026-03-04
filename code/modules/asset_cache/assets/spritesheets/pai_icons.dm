/datum/asset/spritesheet_batched/pai_icons
	name = "pai_icons"

/datum/asset/spritesheet_batched/pai_icons/create_spritesheets()
	for(var/name, current_sprite in SSpai.get_chassis_list())
		var/datum/pai_sprite/sprite = current_sprite
		if(!sprite.name || !sprite.sprite_icon_state)
			continue

		var/datum/universal_icon/I_N = uni_icon(sprite.sprite_icon, sprite.sprite_icon_state, NORTH)
		var/datum/universal_icon/I_S = uni_icon(sprite.sprite_icon, sprite.sprite_icon_state, SOUTH)
		var/datum/universal_icon/I_W = uni_icon(sprite.sprite_icon, sprite.sprite_icon_state, WEST)
		var/datum/universal_icon/I_E = uni_icon(sprite.sprite_icon, sprite.sprite_icon_state, EAST)

		if(sprite.icon_x > sprite.icon_y)
			var/buffer = (sprite.icon_x - sprite.icon_y) / 2
			I_N.crop(0, -buffer, sprite.icon_x, sprite.icon_y + buffer)
			I_S.crop(0, -buffer, sprite.icon_x, sprite.icon_y + buffer)
			I_W.crop(0, -buffer, sprite.icon_x, sprite.icon_y + buffer)
			I_E.crop(0, -buffer, sprite.icon_x, sprite.icon_y + buffer)
		else if (sprite.icon_x < sprite.icon_y)
			var/buffer = (sprite.icon_y - sprite.icon_x) / 2
			I_N.crop(-buffer, 0, sprite.icon_x + buffer, sprite.icon_y)
			I_S.crop(-buffer, 0, sprite.icon_x + buffer, sprite.icon_y)
			I_W.crop(-buffer, 0, sprite.icon_x + buffer, sprite.icon_y)
			I_E.crop(-buffer, 0, sprite.icon_x + buffer, sprite.icon_y)
		I_N.scale(120, 120)
		I_S.scale(120, 120)
		I_W.scale(120, 120)
		I_E.scale(120, 120)

		var/imgid = sanitize_css_class_name("[sprite.type]")
		insert_icon(imgid + "N", I_N)
		insert_icon(imgid + "S", I_S)
		insert_icon(imgid + "W", I_W)
		insert_icon(imgid + "E", I_E)

		if(sprite.has_eye_sprites)
			var/datum/universal_icon/I_NE = uni_icon(sprite.sprite_icon, "[sprite.sprite_icon_state]-eyes", NORTH)
			var/datum/universal_icon/I_SE = uni_icon(sprite.sprite_icon, "[sprite.sprite_icon_state]-eyes", SOUTH)
			var/datum/universal_icon/I_WE = uni_icon(sprite.sprite_icon, "[sprite.sprite_icon_state]-eyes", WEST)
			var/datum/universal_icon/I_EE = uni_icon(sprite.sprite_icon, "[sprite.sprite_icon_state]-eyes", EAST)

			if(sprite.icon_x > sprite.icon_y)
				var/buffer = (sprite.icon_x - sprite.icon_y) / 2
				I_NE.crop(0, -buffer, sprite.icon_x, sprite.icon_y + buffer)
				I_SE.crop(0, -buffer, sprite.icon_x, sprite.icon_y + buffer)
				I_WE.crop(0, -buffer, sprite.icon_x, sprite.icon_y + buffer)
				I_EE.crop(0, -buffer, sprite.icon_x, sprite.icon_y + buffer)
			else if (sprite.icon_x < sprite.icon_y)
				var/buffer = (sprite.icon_y - sprite.icon_x) / 2
				I_NE.crop(-buffer, 0, sprite.icon_x + buffer, sprite.icon_y)
				I_SE.crop(-buffer, 0, sprite.icon_x + buffer, sprite.icon_y)
				I_WE.crop(-buffer, 0, sprite.icon_x + buffer, sprite.icon_y)
				I_EE.crop(-buffer, 0, sprite.icon_x + buffer, sprite.icon_y)
			I_NE.scale(120, 120)
			I_SE.scale(120, 120)
			I_WE.scale(120, 120)
			I_EE.scale(120, 120)

			insert_icon(imgid + "NE", I_NE)
			insert_icon(imgid + "SE", I_SE)
			insert_icon(imgid + "WE", I_WE)
			insert_icon(imgid + "EE", I_EE)
