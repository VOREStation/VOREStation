/datum/unit_test/all_robot_sprites_must_be_valid
	name = "ROBOTS: Robot sprites must be valid"
	var/signal_failed = FALSE

/datum/unit_test/all_robot_sprites_must_be_valid/start_test()
	var/failed = 0

	for(var/sprite in subtypesof(/datum/robot_sprite))
		var/datum/robot_sprite/RS = new sprite()

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
				if(check_state(RS,checks[C]))
					failed = TRUE
		if(RS.has_eye_sprites)
			if(check_state(RS,"-eyes"))
				failed = TRUE
		if(RS.has_eye_light_sprites)
			if(check_state(RS,"-lights"))
				failed = TRUE
		if(RS.has_robotdecal_sprites)
			if(check_state(RS,"-decals"))
				failed = TRUE
		if(RS.has_custom_open_sprites)
			if(check_state(RS,"-openpanel_wc"))
				failed = TRUE
			if(check_state(RS,"-openpanel_c"))
				failed = TRUE
			if(check_state(RS,"-openpanel_w"))
				failed = TRUE
		if(RS.has_vore_belly_sprites && !RS.belly_capacity_list)
			if(RS.has_sleeper_light_indicator)
				if(check_state(RS,"-sleeper-r"))
					failed = TRUE
				if(check_state(RS,"-sleeper-g"))
					failed = TRUE
				if(RS.has_vore_belly_resting_sprites)
					for(var/rest_style in RS.rest_sprite_options)
						if(rest_style == "Default")
							rest_style = "rest"
						if(check_state(RS,"-sleeper-r-[rest_style]"))
							failed = TRUE
						if(check_state(RS,"-sleeper-g-[rest_style]"))
							failed = TRUE
			else
				if(check_state(RS,"-sleeper"))
					failed = TRUE
				if(RS.has_vore_belly_resting_sprites)
					for(var/rest_style in RS.rest_sprite_options)
						if(rest_style == "Default")
							rest_style = "rest"
						if(check_state(RS,"-sleeper-[rest_style]"))
							failed = TRUE
		else if (RS.belly_capacity_list)
			for(var/belly in RS.belly_capacity_list)
				if(check_state(RS,"-[belly]-[belly_capacity_list[belly]]"))
					failed = TRUE
				if(RS.has_vore_belly_resting_sprites)
					for(var/rest_style in RS.rest_sprite_options)
						if(rest_style == "Default")
							rest_style = "rest"
						if(check_state(RS,"-[belly]-[belly_capacity_list[belly]]-[rest_style]"))
							failed = TRUE
			if(RS.belly_light_list)
				for(var/belly in RS.belly_light_list)
					if(check_state(RS,"-[belly]-[belly_light_list[belly]]-r"))
						failed = TRUE
					if(check_state(RS,"-[belly]-[belly_light_list[belly]]-g"))
						failed = TRUE
					if(RS.has_vore_belly_resting_sprites)
						for(var/rest_style in RS.rest_sprite_options)
							if(rest_style == "Default")
								rest_style = "rest"
							if(check_state(RS,"-[belly]-[belly_light_list[belly]]-r-[rest_style]"))
								failed = TRUE
							if(check_state(RS,"-[belly]-[belly_light_list[belly]]-g-[rest_style]"))
								failed = TRUE
		if(RS.rest_sprite_options in list("Sit"))
			if(check_state(RS,"-sit"))
				failed = TRUE
		if(RS.rest_sprite_options in list("Default"))
			if(check_state(RS,"-rest"))
				failed = TRUE
		if(RS.rest_sprite_options in list("Bellyup"))
			if(check_state(RS,"-bellyup"))
				failed = TRUE
		if(RS.has_dead_sprite)
			if(check_state(RS,"-wreck"))
				failed = TRUE
		if(RS.has_dead_sprite_overlay)
			if(check_state(RS,"wreck-overlay"))
				failed = TRUE
		qdel(RS)

	if(failed)
		fail("One or more /datum/robot_sprite items had invalid flags or icons")
	else
		pass("All /datum/robot_sprite are valid.")
	return 1

/datum/unit_test/all_robot_sprites_must_be_valid/proc/check_state(var/datum/robot_sprite/RS,var/append)
	var/check_state = "[RS.sprite_icon_state][append]"
	if(!(check_state in cached_icon_states(RS.sprite_icon)))
		log_unit_test("[RS.type]: Robots - Robot sprite \"[RS.name]\", had [append] state enabled, but was missing icon_state \"[check_state]\", in dmi \"[RS.sprite_icon]\".")
		return TRUE
	return FALSE
