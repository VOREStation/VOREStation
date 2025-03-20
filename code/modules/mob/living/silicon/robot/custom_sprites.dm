// Deprecated as of the sprite datumization, kept only for ai custom icons (even though we dont yet have any)

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
		var/list/split_idx = splittext(line, "|") //this was set to a - before, even though a good 30% of the borgs I see have a - in their name, set it to | instead
		if(!split_idx || !split_idx.len)
			continue //bad entry

		var/ckey = split_idx[1]
		//Prevents the CKEY from being considered a borg name / being processed into the name list. ~Mech
		split_idx.Remove(ckey)

		for(var/name in split_idx)
			GLOB.robot_custom_icons[name] = ckey
	return 1

/mob/living/silicon/robot/proc/set_custom_sprite()
	if(!sprite_name || !(sprite_name in GLOB.robot_custom_icons))
		return
	var/sprite_owner = GLOB.robot_custom_icons[sprite_name]
	if(sprite_owner && sprite_owner == ckey)
		custom_sprite = 1
		icon = CUSTOM_ITEM_SYNTH
		if(icon_state == "robot")
			icon_state = "[ckey]-[sprite_name]-Standard" //Compliant with robot.dm line 236 ~Mech
// To summarize, if you want to add a whitelisted borg sprite, you have to
// 1. Add ckey and character name to config/custom_sprites, separated by a |
// 2. Add your custom sprite to custom_synthetic.dmi under icon/mob/custom_synthetic.dmi
// 3. Name the sprite, and all of its components, as ckey-charname-module
// Note that, due to the last couple lines of code, your sprite may appear invisible until you select a module.
// You can fix this by adding a 'standard' configuration, or you could probably just ignore it if you're lazy.
