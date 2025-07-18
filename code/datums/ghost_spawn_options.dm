/datum/tgui_module/ghost_spawn_menu/proc/jump_to_pod(mob/observer/dead/user, selected_pod)
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

/datum/tgui_module/ghost_spawn_menu/proc/become_mouse(mob/observer/dead/user)
	if(CONFIG_GET(flag/disable_player_mice))
		to_chat(user, span_warning("Spawning as a mouse is currently disabled."))
		return

	if(jobban_isbanned(user, JOB_GHOSTROLES))
		to_chat(user, span_warning("You cannot become a mouse because you are banned from playing ghost roles."))
		return

	if(!user.MayRespawn(1))
		return

	var/turf/T = get_turf(user)
	if(!T || (T.z in using_map.admin_levels))
		to_chat(user, span_warning("You may not spawn as a mouse on this Z-level."))
		return

	var/timedifference = world.time - user.client.time_died_as_mouse
	if(user.client.time_died_as_mouse && timedifference <= CONFIG_GET(number/mouse_respawn_time) MINUTES)
		var/timedifference_text = time2text(CONFIG_GET(number/mouse_respawn_time) MINUTES - timedifference,"mm:ss")
		to_chat(user, span_warning("You may only spawn again as a mouse more than [CONFIG_GET(number/mouse_respawn_time)] minutes after your death. You have [timedifference_text] left."))
		return

	//find a viable mouse candidate
	var/mob/living/simple_mob/animal/passive/mouse/host
	var/obj/machinery/atmospherics/unary/vent_pump/vent_found
	var/list/found_vents = list()
	for(var/obj/machinery/atmospherics/unary/vent_pump/v in GLOB.machines)
		if(!v.welded && v.z == T.z && v.network && v.network.normal_members.len > MOUSE_VENT_NETWORK_LENGTH)
			found_vents.Add(v)
	if(found_vents.len)
		vent_found = pick(found_vents)
		host = new /mob/living/simple_mob/animal/passive/mouse(vent_found)
	else
		to_chat(user, span_warning("Unable to find any unwelded vents to spawn mice at."))

	if(host)
		if(CONFIG_GET(flag/uneducated_mice))
			host.universal_understand = 0
		announce_ghost_joinleave(user, 0, "They are now a mouse.")
		host.ckey = user.ckey
		host.add_ventcrawl(vent_found)
		to_chat(host, span_info("You are now a mouse. Try to avoid interaction with players, and do not give hints away that you are more than a simple rodent."))

/datum/tgui_module/ghost_spawn_menu/proc/become_drone(mob/observer/dead/user, fabricator)
	if(ticker.current_state < GAME_STATE_PLAYING)
		to_chat(user, span_danger("The game hasn't started yet!"))
		return

	if(!CONFIG_GET(flag/allow_drone_spawn))
		to_chat(user, span_danger("That verb is not currently permitted."))
		return

	if(jobban_isbanned(user, JOB_CYBORG))
		to_chat(user, span_danger("You are banned from playing synthetics and cannot spawn as a drone."))
		return

	if(CONFIG_GET(flag/use_age_restriction_for_jobs) && isnum(user.client.player_age))
		var/time_till_play = max(0, 3 - user.client.player_age)
		if(time_till_play)
			to_chat(user, span_danger("You have not been playing on the server long enough to join as drone."))
			return

	if(!user.MayRespawn(1))
		return

	var/deathtime = world.time - user.timeofdeath
	var/deathtimeminutes = round(deathtime / (1 MINUTE))
	var/pluralcheck = "minute"
	if(deathtimeminutes == 0)
		pluralcheck = ""
	else if(deathtimeminutes == 1)
		pluralcheck = " [deathtimeminutes] minute and"
	else if(deathtimeminutes > 1)
		pluralcheck = " [deathtimeminutes] minutes and"
	var/deathtimeseconds = round((deathtime - deathtimeminutes * 1 MINUTE) / 10,1)

	if (deathtime < 5 MINUTES)
		to_chat(user, "You have been dead for[pluralcheck] [deathtimeseconds] seconds.")
		to_chat(user, "You must wait 5 minutes to respawn as a drone!")
		return

	var/obj/machinery/drone_fabricator/chosen_fabricator = locate(fabricator) in GLOB.all_drone_fabricators

	if(!chosen_fabricator)
		return
	if(chosen_fabricator.stat & NOPOWER || !chosen_fabricator.produce_drones)
		return
	if(!chosen_fabricator.drone_progress >= 100)
		return

	chosen_fabricator.create_drone(user.client)

/datum/tgui_module/ghost_spawn_menu/proc/join_vr(mob/observer/dead/user, landmark)
	var/S = locate(landmark) in GLOB.landmarks_list

	user.fake_enter_vr(S)

/datum/tgui_module/ghost_spawn_menu/proc/soulcatcher_spawn(mob/observer/dead/user, selected_player)
	var/mob/living/target = locate(selected_player) in GLOB.player_list
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

/datum/tgui_module/ghost_spawn_menu/proc/finish_soulcatcher_spawn(mob/observer/dead/user, mob/living/carbon/human/H, datum/nifsoft/soulcatcher/SC, req_time)
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

/datum/tgui_module/ghost_spawn_menu/proc/soulcatcher_vore_spawn(mob/observer/dead/user, selected_player)
	var/mob/living/target = locate(selected_player) in GLOB.player_list
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

/datum/tgui_module/ghost_spawn_menu/proc/finish_soulcatcher_vore_spawn(mob/observer/dead/user, mob/M, obj/soulgem/gem, req_time)
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


/datum/tgui_module/ghost_spawn_menu/proc/vore_belly_spawn(mob/observer/dead/user, selected_player)
	var/mob/living/target = locate(selected_player) in GLOB.player_list

	if(!target)
		to_chat(user, span_warning("Invalid player selected!"))
		return

	to_chat(user, span_notice("Inbelly spawn request sent to predator."))
	to_chat(target, span_notice("Incoming belly spawn request."))
	addtimer(CALLBACK(src, PROC_REF(finish_vore_belly_spawn), user, target), 1.5 SECONDS, TIMER_DELETE_ME)

/datum/tgui_module/ghost_spawn_menu/proc/finish_vore_belly_spawn(mob/observer/dead/user,  mob/living/L)
	L.inbelly_spawn_prompt(user.client)			// Hand reins over to them

/datum/tgui_module/ghost_spawn_menu/proc/join_corgi(mob/observer/dead/user)
	if(jobban_isbanned(user, JOB_GHOSTROLES))
		to_chat(user, span_danger("You are banned from playing ghost roles and cannot spawn as a corgi."))
		return

	if(GLOB.allowed_ghost_spawns <= 0)
		to_chat(user, span_warning("There're no free ghost join slots."))
		return

	var/obj/effect/landmark/spawnspot = get_ghost_role_spawn()
	if(!spawnspot)
		to_chat(user, span_warning("No spawnpoint available."))
		return

	GLOB.allowed_ghost_spawns--
	announce_ghost_joinleave(user, 0, "They are now a corgi.")
	var/obj/structure/ghost_pod/manual/corgi/corg = new(get_turf(spawnspot))
	corg.create_occupant(user)

/datum/tgui_module/ghost_spawn_menu/proc/join_lost(mob/observer/dead/user)
	if(jobban_isbanned(user, JOB_CYBORG))
		to_chat(user, span_danger("You are banned from playing synthetics and cannot spawn as a drone."))
		return

	if(GLOB.allowed_ghost_spawns <= 0)
		to_chat(user, span_warning("There're no free ghost join slots."))
		return

	var/obj/effect/landmark/spawnspot = get_ghost_role_spawn()
	if(!spawnspot)
		to_chat(user, span_warning("No spawnpoint available."))
		return

	GLOB.allowed_ghost_spawns--
	announce_ghost_joinleave(user, 0, "They are now a lost drone.")
	var/obj/structure/ghost_pod/manual/lost_drone/dogborg/lost = new(get_turf(spawnspot))
	lost.create_occupant(user)

/datum/tgui_module/ghost_spawn_menu/proc/join_maintpred(mob/observer/dead/user)
	if(jobban_isbanned(user, JOB_GHOSTROLES))
		to_chat(user, span_danger("You are banned from playing ghost roles and cannot spawn as a maint pred."))
		return

	if(GLOB.allowed_ghost_spawns <= 0)
		to_chat(user, span_warning("There're no free ghost join slots."))
		return

	var/obj/effect/landmark/spawnspot = get_ghost_role_spawn()
	if(!spawnspot)
		to_chat(user, span_warning("No spawnpoint available."))
		return

	GLOB.allowed_ghost_spawns--
	announce_ghost_joinleave(user, 0, "They are now a maint pred.")
	var/obj/structure/ghost_pod/ghost_activated/maintpred/no_announce/mpred = new(get_turf(spawnspot))
	mpred.create_occupant(user)

/datum/tgui_module/ghost_spawn_menu/proc/join_grave(mob/observer/dead/user)
	if(jobban_isbanned(user, JOB_CYBORG))
		to_chat(user, span_danger("You are banned from playing synthetics and cannot spawn as a gravekeeper."))
		return

	if(GLOB.allowed_ghost_spawns <= 0)
		to_chat(user, span_warning("There're no free ghost join slots."))
		return

	var/obj/effect/landmark/spawnspot = get_ghost_role_spawn()
	if(!spawnspot)
		to_chat(user, span_warning("No spawnpoint available."))
		return

	GLOB.allowed_ghost_spawns--
	announce_ghost_joinleave(user, 0, "They are now a gravekeeper drone.")
	var/obj/structure/ghost_pod/automatic/gravekeeper_drone/grave = new(get_turf(spawnspot))
	grave.create_occupant(user)

/datum/tgui_module/ghost_spawn_menu/proc/join_morpth(mob/observer/dead/user)
	if(jobban_isbanned(user, JOB_GHOSTROLES))
		to_chat(user, span_danger("You are banned from playing ghost roles and cannot spawn as a morph."))
		return

	if(GLOB.allowed_ghost_spawns <= 0)
		to_chat(user, span_warning("There're no free ghost join slots."))
		return

	var/obj/effect/landmark/spawnspot = get_ghost_role_spawn()
	if(!spawnspot)
		to_chat(user, span_warning("No spawnpoint available."))
		return

	GLOB.allowed_ghost_spawns--
	announce_ghost_joinleave(user, 0, "They are now a morph.")
	var/obj/structure/ghost_pod/ghost_activated/morphspawn/no_announce/morph = new(get_turf(spawnspot))
	morph.create_occupant(user)

/datum/tgui_module/ghost_spawn_menu/proc/get_ghost_role_spawn()
	var/list/possibleSpawnspots = list()
	for(var/obj/effect/landmark/L in GLOB.landmarks_list)
		if(L.name == JOB_GHOSTROLES)
			possibleSpawnspots += L
	if(possibleSpawnspots.len)
		return pick(possibleSpawnspots)
	return null
