/mob/observer/dead/verb/soulcatcherjoin()
	set category = "Ghost.Join"
	set name = "Join Into Soulcatcher(Vore)"
	set desc = "Select a player with enabled Soulcatcher to join."

	var/list/valid_players = list()
	for(var/mob/player in player_list)
		if(player.soulgem?.flag_check(SOULGEM_ACTIVE | SOULGEM_CATCHING_GHOSTS, TRUE))
			valid_players += player

	if(!valid_players.len)
		to_chat(src, span_warning("No valid players found."))
		return

	var/picked = tgui_input_list(usr, "Pick a friend with enabled Soulcatcher to join into. Harrass strangers, get banned.","Select a player", valid_players)

	if(!picked)
		return

	if(!ismob(picked))
		to_chat(src, span_warning("Target is no mob."))
		return

	var/mob/M = picked

	var/obj/soulgem/gem = M.soulgem

	if(!gem?.flag_check(SOULGEM_ACTIVE))
		to_chat(src, span_warning("[M] has no enabled Soulcatcher."))
		return

	var/req_time = world.time
	gem.notify_holder("Transient mindstate detected, analyzing...")
	sleep(15) //So if they are typing they get interrupted by sound and message, and don't type over the box
	if(tgui_alert(M,"[src.name] wants to join into your Soulcatcher.","Soulcatcher Request",list("Deny","Allow"), timeout=1 MINUTES) != "Allow")
		to_chat(src, span_warning("[M] has denied your request."))
		return

	if((world.time - req_time) > 1 MINUTES)
		to_chat(M, span_warning("The request had already expired. (1 minute waiting max)"))
		return

	//Final check since we waited for input a couple times.
	if(M && src && src.key && !M.stat && gem?.flag_check(SOULGEM_ACTIVE | SOULGEM_CATCHING_GHOSTS, TRUE))
		if(!mind) //No mind yet, aka haven't played in this round.
			mind = new(key)

		mind.name = name
		mind.current = src
		mind.active = TRUE

		gem.catch_mob(src) //This will result in us being deleted so...
