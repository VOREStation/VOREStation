/// converted unit test, maybe should be fully refactored

/// Test that all robot sprites are valid
/datum/unit_test/all_robot_sprites_must_be_valid
	var/signal_failed = FALSE
	var/failed = 0

/datum/unit_test/all_robot_sprites_must_be_valid/Run()
	for(var/datum/robot_sprite/robot_type as anything in subtypesof(/datum/robot_sprite))
		if(!robot_type::name) // Parent type, ignore me
			continue

		if(!robot_type::sprite_icon)
			TEST_FAIL("[robot_type]: Robots - Robot sprite \"[robot_type::name]\", missing sprite_icon.")
			continue

		var/datum/robot_sprite/robot = new robot_type()

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
		for(var/check in checks)
			if(robot.sprite_flag_check(text2num(check)))
				check_state(robot,checks[check])
		// eyes, lights, markings
		if(robot.has_eye_sprites)
			check_state(robot,"-eyes")
		if(robot.has_eye_light_sprites)
			check_state(robot,"-lights")
		if(LAZYLEN(robot.sprite_decals))
			for(var/decal in robot.sprite_decals)
				check_state(robot,"-[decal]")
		if(LAZYLEN(robot.sprite_animations))
			for(var/animation in robot.sprite_animations)
				check_state(robot,"-[animation]")
		// Control panel
		if(robot.has_custom_open_sprites)
			check_state(robot,"-openpanel_nc")
			check_state(robot,"-openpanel_c")
			check_state(robot,"-openpanel_w")
		// Glow State
		if(robot.has_glow_sprites)
			check_state(robot,"-glow")
		// Bellies
		if(robot.has_vore_belly_sprites && !robot.belly_capacity_list)
			if(robot.has_sleeper_light_indicator)
				// belly r/g light
				check_state(robot,"-sleeper-r")
				check_state(robot,"-sleeper-g")
				if(robot.has_vore_belly_resting_sprites)
					for(var/rest_style in robot.rest_sprite_options)
						rest_style = lowertext(rest_style)
						if(rest_style == "default")
							rest_style = "rest"
						check_state(robot,"-sleeper-r-[rest_style]")
						check_state(robot,"-sleeper-g-[rest_style]")
				// struggling
				if(robot.has_vore_struggle_sprite)
					check_state(robot,"-sleeper-r-struggle")
					check_state(robot,"-sleeper-g-struggle")
					if(robot.has_vore_belly_resting_sprites)
						for(var/rest_style in robot.rest_sprite_options)
							rest_style = lowertext(rest_style)
							if(rest_style == "default")
								rest_style = "rest"
							check_state(robot,"-sleeper-r-[rest_style]-struggle")
							check_state(robot,"-sleeper-g-[rest_style]-struggle")
			else
				// belly
				check_state(robot,"-sleeper")
				if(robot.has_vore_belly_resting_sprites)
					for(var/rest_style in robot.rest_sprite_options)
						rest_style = lowertext(rest_style)
						if(rest_style == "default")
							rest_style = "rest"
						check_state(robot,"-sleeper-[rest_style]")
				// struggling
				if(robot.has_vore_struggle_sprite)
					check_state(robot,"-sleeper-struggle")
					if(robot.has_vore_belly_resting_sprites)
						for(var/rest_style in robot.rest_sprite_options)
							rest_style = lowertext(rest_style)
							if(rest_style == "default")
								rest_style = "rest"
							check_state(robot,"-sleeper-[rest_style]-struggle")
		else if(robot.belly_capacity_list)
			for(var/belly in robot.belly_capacity_list)
				for(var/num = 1 to robot.belly_capacity_list[belly])
					// big belly
					check_state(robot,"-[belly]-[num]")
					if(robot.has_vore_belly_resting_sprites)
						for(var/rest_style in robot.rest_sprite_options)
							rest_style = lowertext(rest_style)
							if(rest_style == "default")
								rest_style = "rest"
							check_state(robot,"-[belly]-[num]-[rest_style]")
					// struggling
					if(robot.has_vore_struggle_sprite)
						check_state(robot,"-[belly]-[num]-struggle")
						if(robot.has_vore_belly_resting_sprites)
							for(var/rest_style in robot.rest_sprite_options)
								rest_style = lowertext(rest_style)
								if(rest_style == "default")
									rest_style = "rest"
								check_state(robot,"-[belly]-[num]-[rest_style]-struggle")
			if(robot.belly_light_list)
				for(var/belly in robot.belly_light_list)
					for(var/num = 1 to robot.belly_light_list[belly])
						// multi belly r/g light
						check_state(robot,"-[belly]-[num]-r")
						check_state(robot,"-[belly]-[num]-g")
						if(robot.has_vore_belly_resting_sprites)
							for(var/rest_style in robot.rest_sprite_options)
								rest_style = lowertext(rest_style)
								if(rest_style == "default")
									rest_style = "rest"
								check_state(robot,"-[belly]-[num]-r-[rest_style]")
								check_state(robot,"-[belly]-[num]-g-[rest_style]")
						// struggling
						if(robot.has_vore_struggle_sprite)
							check_state(robot,"-[belly]-[num]-r-struggle")
							check_state(robot,"-[belly]-[num]-g-struggle")
							if(robot.has_vore_belly_resting_sprites)
								for(var/rest_style in robot.rest_sprite_options)
									rest_style = lowertext(rest_style)
									if(rest_style == "default")
										rest_style = "rest"
									check_state(robot,"-[belly]-[num]-r-[rest_style]-struggle")
									check_state(robot,"-[belly]-[num]-g-[rest_style]-struggle")
		// reseting
		for(var/rest_style in robot.rest_sprite_options)
			rest_style = lowertext(rest_style)
			if(rest_style == "default")
				rest_style = "rest"
			check_state(robot,"-[rest_style]")
			if(robot.has_glow_sprites)
				check_state(robot,"-[rest_style]-glow")
			if(robot.has_rest_lights_sprites)
				check_state(robot,"-[rest_style]-lights")
			if(robot.has_rest_eyes_sprites)
				check_state(robot,"-[rest_style]-eyes")
		// death
		if(robot.has_dead_sprite)
			check_state(robot,"-wreck")
		if(robot.has_dead_sprite_overlay) // Only one per dmi
			TEST_ASSERT(icon_exists(robot.sprite_icon, "wreck-overlay"), "[robot.type]: Robots - Robot sprite \"[robot.name]\", missing icon_state wreck-overlay, in dmi \"[robot.sprite_icon]\".")
		// offset
		var/icon/I = new(robot.sprite_icon)
		TEST_ASSERT_EQUAL(robot.icon_x, I.Width(), "[robot.type]: Robots - Robot sprite \"[robot.name]\", icon_x \"[robot.icon_x]\" did not match dmi configured width \"[I.Width()]\"")
		TEST_ASSERT_EQUAL(robot.icon_y, I.Height(), "[robot.type]: Robots - Robot sprite \"[robot.name]\", icon_y \"[robot.icon_y]\" did not match dmi configured height \"[I.Height()]\"")
		TEST_ASSERT_EQUAL(robot.icon_y, robot.vis_height, "[robot.type]: Robots - Robot sprite \"[robot.name]\", vis_height \"[robot.vis_height]\" did not match icon_y \"[robot.icon_y]\"")

		var/legal_offset = (I.Width() - world.icon_size) / 2
		TEST_ASSERT_EQUAL(robot.pixel_x, -legal_offset, "[robot.type]: Robots - Robot sprite \"[robot.name]\", pixel_x \"[robot.pixel_x]\" did not have correct offset, should be \"[-legal_offset]\"")

		qdel(I)
		qdel(robot)

/datum/unit_test/all_robot_sprites_must_be_valid/proc/check_state(datum/robot_sprite/robot, append)
	var/check_state = "[robot.sprite_icon_state][append]"
	TEST_ASSERT(icon_exists(robot.sprite_icon, check_state), "[robot.type]: Robots - Robot sprite \"[robot.name]\", enabled but missing icon_state \"[check_state]\", in dmi \"[robot.sprite_icon]\".")
