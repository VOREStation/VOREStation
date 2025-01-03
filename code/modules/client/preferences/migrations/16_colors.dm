/// Moves r_g_b_ affixes to single hex colors
/datum/preferences/proc/migration_16_colors(datum/json_savefile/S)
	for(var/slot in 1 to CONFIG_GET(number/character_slots))
		var/list/prefs = S.get_entry("character[slot]", null)
		if(!islist(prefs))
			continue

		prefs["hair_color"] = rgb(prefs["hair_red"], prefs["hair_green"], prefs["hair_blue"])
		prefs["facial_color"] = rgb(prefs["facial_red"], prefs["facial_green"], prefs["facial_blue"])
		prefs["grad_color"] = rgb(prefs["grad_red"], prefs["grad_green"], prefs["grad_blue"])
		prefs["skin_color"] = rgb(prefs["skin_red"], prefs["skin_green"], prefs["skin_blue"])
		prefs["eyes_color"] = rgb(prefs["eyes_red"], prefs["eyes_green"], prefs["eyes_blue"])
		prefs["synth_color_rgb"] = rgb(prefs["synth_red"], prefs["synth_green"], prefs["synth_blue"])

		prefs["ears_color1"] = rgb(prefs["r_ears"], prefs["g_ears"], prefs["b_ears"])
		prefs["ears_color2"] = rgb(prefs["r_ears2"], prefs["g_ears2"], prefs["b_ears2"])
		prefs["ears_color3"] = rgb(prefs["r_ears3"], prefs["g_ears3"], prefs["b_ears3"])

		prefs["tail_color1"] = rgb(prefs["r_tail"], prefs["g_tail"], prefs["b_tail"])
		prefs["tail_color2"] = rgb(prefs["r_tail2"], prefs["g_tail2"], prefs["b_tail2"])
		prefs["tail_color3"] = rgb(prefs["r_tail3"], prefs["g_tail3"], prefs["b_tail3"])

		prefs["wing_color1"] = rgb(prefs["r_wing"], prefs["g_wing"], prefs["b_wing"])
		prefs["wing_color2"] = rgb(prefs["r_wing2"], prefs["g_wing2"], prefs["b_wing2"])
		prefs["wing_color3"] = rgb(prefs["r_wing3"], prefs["g_wing3"], prefs["b_wing3"])
