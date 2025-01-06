/datum/antagonist/proc/add_antagonist(var/datum/mind/player, var/ignore_role, var/do_not_equip, var/move_to_spawn, var/do_not_announce, var/preserve_appearance)

	if(!add_antagonist_mind(player, ignore_role))
		return

	//do this again, just in case
	if(flags & ANTAG_OVERRIDE_JOB)
		player.assigned_role = role_text
	player.special_role = role_text

	if(isobserver(player.current))
		create_default(player.current)
	else
		create_antagonist(player, move_to_spawn, do_not_announce, preserve_appearance)
		if(!do_not_equip)
			equip(player.current)
	return 1

/datum/antagonist/proc/add_antagonist_mind(var/datum/mind/player, var/ignore_role, var/nonstandard_role_type, var/nonstandard_role_msg)
	if(!istype(player))
		return 0
	if(!player.current)
		return 0
	if(player in current_antagonists)
		return 0
	if(!can_become_antag(player, ignore_role))
		return 0
	current_antagonists |= player

	if(faction_verb && player.current)
		add_verb(player.current, faction_verb)

	spawn(1 SECOND) //Added a delay so that this should pop up at the bottom and not the top of the text flood the new antag gets.
		to_chat(player.current, span_notice("Once you decide on a goal to pursue, you can optionally display it to \
			everyone at the end of the shift with the " + span_bold("Set Ambition") + " verb, located in the IC tab.  You can change this at any time, \
			and it otherwise has no bearing on your round."))
	add_verb(player.current, /mob/living/proc/write_ambition)

	if(can_speak_aooc)
		add_verb(player.current.client, /client/proc/aooc)

	// Handle only adding a mind and not bothering with gear etc.
	if(nonstandard_role_type)
		faction_members |= player
		to_chat(player.current, span_danger(span_large("You are \a [nonstandard_role_type]!")))
		player.special_role = nonstandard_role_type
		if(nonstandard_role_msg)
			to_chat(player.current, span_notice("[nonstandard_role_msg]"))
		update_icons_added(player)
	return 1

/datum/antagonist/proc/remove_antagonist(var/datum/mind/player, var/show_message, var/implanted)
	if(player.current && faction_verb)
		remove_verb(player.current, faction_verb)
	if(player in current_antagonists)
		to_chat(player.current, span_danger(span_large("You are no longer a [role_text]!")))
		current_antagonists -= player
		faction_members -= player
		player.special_role = null
		update_icons_removed(player)
		BITSET(player.current.hud_updateflag, SPECIALROLE_HUD)
		if(!is_special_character(player))
			remove_verb(player.current, /mob/living/proc/write_ambition)
			remove_verb(player.current.client, /client/proc/aooc)
			player.ambitions = ""
		return 1
	return 0
