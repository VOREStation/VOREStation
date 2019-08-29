
//list(ckey = real_name,)
//Since the ckey is used as the icon_state, the current system will only permit a single custom robot sprite per ckey.
//While it might be possible for a ckey to use that custom sprite for several real_names, it seems rather pointless to support it. ~Mech: We found it wasn't pointless.
GLOBAL_LIST_EMPTY(robot_custom_icons)

/hook/startup/proc/load_robot_custom_sprites()
	var/config_file = file2text("config/custom_sprites.txt")
	var/list/lines = splittext(config_file, "\n")

	GLOB.robot_custom_icons = list()
	for(var/line in lines)
		//split entry into ckey and real_name
		var/list/split_idx = splittext(line, "-") //this works if ckeys and borg names cannot contain dashes, and splittext starts from the beginning ~Mech
		if(!split_idx || !split_idx.len)
			continue //bad entry

		var/ckey = split_idx[1]
		//Prevents the CKEY from being considered a borg name / being processed into the name list. ~Mech
		split_idx.Remove(ckey)

		for(var/name in split_idx)
			GLOB.robot_custom_icons[name] = ckey
	return 1

/mob/living/silicon/robot/proc/set_custom_sprite()
	if(!sprite_name)
		return
	var/sprite_owner = GLOB.robot_custom_icons[sprite_name]
	if(sprite_owner && sprite_owner == ckey)
		custom_sprite = 1
		icon = CUSTOM_ITEM_SYNTH
		if(icon_state == "robot")
			icon_state = "[ckey]-[sprite_name]-Standard" //Compliant with robot.dm line 236 ~Mech
