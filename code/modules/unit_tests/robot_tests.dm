/// converted unit test, maybe should be fully refactored

/// Test that all robot sprites are valid
/datum/unit_test/all_robot_sprites_must_be_valid
	var/signal_failed = FALSE
	var/failed = 0

/datum/unit_test/all_robot_sprites_must_be_valid/Run()
	for(var/sprite in subtypesof(/datum/robot_sprite))
		var/datum/robot_sprite/RS = new sprite()
		if(!RS.name) // Parent type, ignore me
			continue

		TEST_ASSERT(RS.sprite_icon, "[RS.type]: Robots - Robot sprite \"[RS.name]\", missing sprite_icon.")
		if(!RS.sprite_icon)
			continue

		var/list/checks = list(
			"[ROBOT_HAS_SPEED_SPRITE]" = "-roll",
			"[ROBOT_HAS_SHIELD_SPRITE]" = "-shield",
			"[ROBOT_HAS_SHIELD_SPEED_SPRITE]" = "-speed_shield",
			"[ROBOT_HAS_MELEE_SPRITE]" = "-melee",
			"[ROBOT_HAS_DAGGER_SPRITE]" = "-dagger",
			"[ROBOT_HAS_BLADE_SPRITE]" = "-blade",
			"[ROBOT_HAS_GUN_SPRITE]" = "-gun",
			"[ROBOT_HAS_LASER_SPRITE]" = "-laser",
			"[ROBOT_HAS_TASER_SPRITE]" = "-taser",
			"[ROBOT_HAS_DISABLER_SPRITE]" = "-disabler"
		)
		for(var/C in checks)
			if(RS.sprite_flag_check(text2num(C)))
				check_state(RS,checks[C])
		// eyes, lights, markings
		if(RS.has_eye_sprites)
			check_state(RS,"-eyes")
		if(RS.has_eye_light_sprites)
			check_state(RS,"-lights")
		if(LAZYLEN(RS.sprite_decals))
			for(var/decal in RS.sprite_decals)
				check_state(RS,"-[decal]")
		if(LAZYLEN(RS.sprite_animations))
			for(var/animation in RS.sprite_animations)
				check_state(RS,"-[animation]")
		// Control panel
		if(RS.has_custom_open_sprites)
			check_state(RS,"-openpanel_nc")
			check_state(RS,"-openpanel_c")
			check_state(RS,"-openpanel_w")
		// Glow State
		if(RS.has_glow_sprites)
			check_state(RS,"-glow")
		// Bellies
		if(RS.has_vore_belly_sprites && !RS.belly_capacity_list)
			if(RS.has_sleeper_light_indicator)
				// belly r/g light
				check_state(RS,"-sleeper-r")
				check_state(RS,"-sleeper-g")
				if(RS.has_vore_belly_resting_sprites)
					for(var/rest_style in RS.rest_sprite_options)
						rest_style = lowertext(rest_style)
						if(rest_style == "default")
							rest_style = "rest"
						check_state(RS,"-sleeper-r-[rest_style]")
						check_state(RS,"-sleeper-g-[rest_style]")
				// struggling
				if(RS.has_vore_struggle_sprite)
					check_state(RS,"-sleeper-r-struggle")
					check_state(RS,"-sleeper-g-struggle")
					if(RS.has_vore_belly_resting_sprites)
						for(var/rest_style in RS.rest_sprite_options)
							rest_style = lowertext(rest_style)
							if(rest_style == "default")
								rest_style = "rest"
							check_state(RS,"-sleeper-r-[rest_style]-struggle")
							check_state(RS,"-sleeper-g-[rest_style]-struggle")
			else
				// belly
				check_state(RS,"-sleeper")
				if(RS.has_vore_belly_resting_sprites)
					for(var/rest_style in RS.rest_sprite_options)
						rest_style = lowertext(rest_style)
						if(rest_style == "default")
							rest_style = "rest"
						check_state(RS,"-sleeper-[rest_style]")
				// struggling
				if(RS.has_vore_struggle_sprite)
					check_state(RS,"-sleeper-struggle")
					if(RS.has_vore_belly_resting_sprites)
						for(var/rest_style in RS.rest_sprite_options)
							rest_style = lowertext(rest_style)
							if(rest_style == "default")
								rest_style = "rest"
							check_state(RS,"-sleeper-[rest_style]-struggle")
		else if (RS.belly_capacity_list)
			for(var/belly in RS.belly_capacity_list)
				for(var/num = 1 to RS.belly_capacity_list[belly])
					// big belly
					check_state(RS,"-[belly]-[num]")
					if(RS.has_vore_belly_resting_sprites)
						for(var/rest_style in RS.rest_sprite_options)
							rest_style = lowertext(rest_style)
							if(rest_style == "default")
								rest_style = "rest"
							check_state(RS,"-[belly]-[num]-[rest_style]")
					// struggling
					if(RS.has_vore_struggle_sprite)
						check_state(RS,"-[belly]-[num]-struggle")
						if(RS.has_vore_belly_resting_sprites)
							for(var/rest_style in RS.rest_sprite_options)
								rest_style = lowertext(rest_style)
								if(rest_style == "default")
									rest_style = "rest"
								check_state(RS,"-[belly]-[num]-[rest_style]-struggle")
			if(RS.belly_light_list)
				for(var/belly in RS.belly_light_list)
					for(var/num = 1 to RS.belly_light_list[belly])
						// multi belly r/g light
						check_state(RS,"-[belly]-[num]-r")
						check_state(RS,"-[belly]-[num]-g")
						if(RS.has_vore_belly_resting_sprites)
							for(var/rest_style in RS.rest_sprite_options)
								rest_style = lowertext(rest_style)
								if(rest_style == "default")
									rest_style = "rest"
								check_state(RS,"-[belly]-[num]-r-[rest_style]")
								check_state(RS,"-[belly]-[num]-g-[rest_style]")
						// struggling
						if(RS.has_vore_struggle_sprite)
							check_state(RS,"-[belly]-[num]-r-struggle")
							check_state(RS,"-[belly]-[num]-g-struggle")
							if(RS.has_vore_belly_resting_sprites)
								for(var/rest_style in RS.rest_sprite_options)
									rest_style = lowertext(rest_style)
									if(rest_style == "default")
										rest_style = "rest"
									check_state(RS,"-[belly]-[num]-r-[rest_style]-struggle")
									check_state(RS,"-[belly]-[num]-g-[rest_style]-struggle")
		// reseting
		for(var/rest_style in RS.rest_sprite_options)
			rest_style = lowertext(rest_style)
			if(rest_style == "default")
				rest_style = "rest"
			check_state(RS,"-[rest_style]")
			if(RS.has_glow_sprites)
				check_state(RS,"-[rest_style]-glow")
			if(RS.has_rest_lights_sprites)
				check_state(RS,"-[rest_style]-lights")
			if(RS.has_rest_eyes_sprites)
				check_state(RS,"-[rest_style]-eyes")
		// death
		if(RS.has_dead_sprite)
			check_state(RS,"-wreck")
		if(RS.has_dead_sprite_overlay) // Only one per dmi
			TEST_ASSERT(icon_exists(wreck-overlay, RS.sprite_icon), "[RS.type]: Robots - Robot sprite \"[RS.name]\", missing icon_state wreck-overlay, in dmi \"[RS.sprite_icon]\".")
			//TEST_ASSERT("wreck-overlay" in cached_icon_states(RS.sprite_icon), "[RS.type]: Robots - Robot sprite \"[RS.name]\", missing icon_state wreck-overlay, in dmi \"[RS.sprite_icon]\".")
		// offset
		var/icon/I = new(RS.sprite_icon)
		TEST_ASSERT_EQUAL(RS.icon_x, I.Width(), "[RS.type]: Robots - Robot sprite \"[RS.name]\", icon_x \"[RS.icon_x]\" did not match dmi configured width \"[I.Width()]\"")
		TEST_ASSERT_EQUAL(RS.icon_y, I.Height(), "[RS.type]: Robots - Robot sprite \"[RS.name]\", icon_y \"[RS.icon_y]\" did not match dmi configured height \"[I.Height()]\"")
		TEST_ASSERT_EQUAL(RS.icon_y, RS.vis_height, "[RS.type]: Robots - Robot sprite \"[RS.name]\", vis_height \"[RS.vis_height]\" did not match icon_y \"[RS.icon_y]\"")

		var/legal_offset = (I.Width() - world.icon_size) / 2
		TEST_ASSERT_EQUAL(RS.pixel_x, -legal_offset, "[RS.type]: Robots - Robot sprite \"[RS.name]\", pixel_x \"[RS.pixel_x]\" did not have correct offset, should be \"[-legal_offset]\"")

		qdel(I)
		qdel(RS)

/datum/unit_test/all_robot_sprites_must_be_valid/proc/check_state(datum/robot_sprite/RS, append)
	var/check_state = "[RS.sprite_icon_state][append]"
	TEST_ASSERT(icon_exists(check_state, RS.sprite_icon), "[RS.type]: Robots - Robot sprite \"[RS.name]\", enabled but missing icon_state \"[check_state]\", in dmi \"[RS.sprite_icon]\".")
	//TEST_ASSERT(check_state in cached_icon_states(RS.sprite_icon), "[RS.type]: Robots - Robot sprite \"[RS.name]\", enabled but missing icon_state \"[check_state]\", in dmi \"[RS.sprite_icon]\".")
