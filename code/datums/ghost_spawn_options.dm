/datum/tgui_module/proc/jump_to_pod(mob/observer/dead/user, selected_pod)
	var/atom/movable/target = locate(selected_pod) in GLOB.active_ghost_pods
	if(!target)
		to_chat(user, span_warning("Invalid ghost pod selected!"))
		return

	var/turf/T = get_turf(target) //Turf of the destination mob

	if(T && isturf(T))	//Make sure the turf exists, then move the source to that destination.
		user.stop_following()
		user.forceMove(T)
	else
		to_chat(user, span_filter_notice("This ghost pod is not located in the game world."))

/datum/tgui_module/proc/soulcatcher_spawn(mob/observer/dead/user, selected_player)
	var/mob/living/target = locate(selected_player) in player_list
		//Didn't pick anyone or picked a null
	if(!target)
		to_chat(user, span_warning("Invalid player selected!"))
		return

	//Good choice testing and some instance-grabbing
	if(!ishuman(target))
		to_chat(user, span_warning("[target] isn't in a humanoid mob at the moment."))
		return

	var/mob/living/carbon/human/H = target

	if(H.stat || !H.client)
		to_chat(user, span_warning("[H] isn't awake/alive at the moment."))
		return

	if(!H.nif)
		to_chat(user, span_warning("[H] doesn't have a NIF installed."))
		return

	var/datum/nifsoft/soulcatcher/SC = H.nif.imp_check(NIF_SOULCATCHER)
	if(!SC)
		to_chat(user, span_warning("[H] doesn't have the Soulcatcher NIFSoft installed, or their NIF is unpowered."))
		return

	//Fine fine, we can ask.
	var/obj/item/nif/nif = H.nif
	to_chat(user, span_notice("Request sent to [H]."))

	var/req_time = world.time
	nif.notify("Transient mindstate detected, analyzing...")
	addtimer(CALLBACK(src, PROC_REF(finish_soulcatcher_spawn), user, H, SC, req_time), 1.5 SECONDS, TIMER_DELETE_ME)

/datum/tgui_module/proc/finish_soulcatcher_spawn(mob/observer/dead/user, mob/living/carbon/human/H, datum/nifsoft/soulcatcher/SC, req_time)
	var/response = tgui_alert(H,"[user] ([user.key]) wants to join into your Soulcatcher.","Soulcatcher Request", list("Deny", "Allow"), timeout = 1 MINUTE)

	if(!response || response == "Deny")
		to_chat(user, span_warning("[H] denied your request."))
		return

	if((world.time - req_time) > 1 MINUTE)
		to_chat(H, span_warning("The request had already expired. (1 minute waiting max)"))
		return

	//Final check since we waited for input a couple times.
	if(H && user && user.key && !H.stat && H.nif && SC)
		if(!user.mind) //No mind yet, aka haven't played in this round.
			user.mind = new(user.key)

		user.mind.name = name
		user.mind.current = user
		user.mind.active = TRUE

		SC.catch_mob(user) //This will result in us being deleted so...

/datum/tgui_module/proc/soulcatcher_vore_spawn(mob/observer/dead/user, selected_player)
	var/mob/living/target = locate(selected_player) in player_list
	if(!target)
		to_chat(user, span_warning("Invalid player selected!"))
		return

	if(!ismob(target))
		to_chat(user, span_warning("Target is no mob."))
		return

	var/mob/M = target

	var/obj/soulgem/gem = M.soulgem

	if(!gem?.flag_check(SOULGEM_ACTIVE))
		to_chat(user, span_warning("[M] has no enabled Soulcatcher."))
		return

	var/req_time = world.time
	gem.notify_holder("Transient mindstate detected, analyzing...")
	addtimer(CALLBACK(src, PROC_REF(finish_soulcatcher_vore_spawn), user, M, gem, req_time), 1.5 SECONDS, TIMER_DELETE_ME)

/datum/tgui_module/proc/finish_soulcatcher_vore_spawn(mob/observer/dead/user, mob/M, obj/soulgem/gem, req_time)
	if(tgui_alert(M, "[user.name] wants to join into your Soulcatcher.","Soulcatcher Request",list("Deny", "Allow"), timeout=1 MINUTES) != "Allow")
		to_chat(user, span_warning("[M] has denied your request."))
		return

	if((world.time - req_time) > 1 MINUTES)
		to_chat(M, span_warning("The request had already expired. (1 minute waiting max)"))
		return

	//Final check since we waited for input a couple times.
	if(M && user && user.key && !M.stat && gem?.flag_check(SOULGEM_ACTIVE | SOULGEM_CATCHING_GHOSTS, TRUE))
		if(!user.mind) //No mind yet, aka haven't played in this round.
			user.mind = new(user.key)

		user.mind.name = name
		user.mind.current = user
		user.mind.active = TRUE

		gem.catch_mob(user) //This will result in us being deleted so...


/datum/tgui_module/proc/vore_belly_spawn(mob/observer/dead/user, selected_player)
	var/mob/living/target = locate(selected_player) in player_list

	if(!target)
		to_chat(user, span_warning("Invalid player selected!"))
		return

	to_chat(user, span_notice("Inbelly spawn request sent to predator."))
	to_chat(target, span_notice("Incoming belly spawn request."))
	addtimer(CALLBACK(src, PROC_REF(finish_vore_belly_spawn), user, M), 1.5 SECONDS, TIMER_DELETE_ME)

/datum/tgui_module/proc/finish_vore_belly_spawn(mob/observer/dead/user, selected_player)
	target.inbelly_spawn_prompt(user.client)			// Hand reins over to them
