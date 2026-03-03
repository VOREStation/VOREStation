#define GHOST_POD_TAB 0
#define GHOST_JOIN 1
#define GHOST_VORE_SPAWN 2

GLOBAL_VAR_INIT(allowed_ghost_spawns, 2)

// Ghost spawn menu
/datum/tgui_module/ghost_spawn_menu
	name = "Ghost Spawn Menu"
	tgui_id = "GhostSpawn"
	var/active_tab = GHOST_POD_TAB

/datum/tgui_module/ghost_spawn_menu/tgui_state(mob/user)
	return GLOB.tgui_observer_state

/datum/tgui_module/ghost_spawn_menu/tgui_close(mob/user)
	. = ..()
	if(isobserver(user))
		var/mob/observer/dead/observer = user
		observer.selecting_ghostrole = FALSE
	if(!QDELETED(src))
		qdel(src)

/datum/tgui_module/ghost_spawn_menu/tgui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	. = ..()
	if(isobserver(user) && ui)
		var/mob/observer/dead/observer = user
		observer.selecting_ghostrole = TRUE

/datum/tgui_module/ghost_spawn_menu/tgui_data(mob/user)
	var/list/data = ..()

	if(active_tab == GHOST_POD_TAB)
		data["all_ghost_pods"] = compile_pod_data()

	if(active_tab == GHOST_JOIN)
		data["all_ghost_join_options"] = compile_ghost_join_data(user)

	if(active_tab == GHOST_VORE_SPAWN)
		data["all_vore_spawns"] = compile_vorespawn_data()

	data["active_tab"] = active_tab
	data["user_z"] = user.z
	return data

/datum/tgui_module/ghost_spawn_menu/tgui_act(action, params, datum/tgui/ui)
	. = ..()
	if(.)
		return

	var/mob/observer/dead/observer = ui.user

	switch(action)
		if("select_pod")
			if(istype(observer))
				jump_to_pod(ui.user, params["selected_pod"])
			. = TRUE
		if("set_tab")
			var/new_tab = text2num(params["val"])
			if(isnum(new_tab))
				active_tab = new_tab
			. = TRUE
		if("soulcatcher_spawn")
			soulcatcher_spawn(ui.user, params["selected_player"])
			close_ui()
			. = TRUE
		if("soulcatcher_vore_spawn")
			soulcatcher_vore_spawn(ui.user, params["selected_player"])
			close_ui()
			. = TRUE
		if("bellyspawn")
			vore_belly_spawn(ui.user, params["selected_player"])
			close_ui()
			. = TRUE
		if("mouse_spawn")
			become_mouse(ui.user)
			. = TRUE
		if("drone_spawn")
			become_drone(ui.user, params["fabricator"])
			. = TRUE
		if("vr_spawn")
			join_vr(ui.user, params["landmark"])
			. = TRUE
		if("corgi_spawn")
			join_corgi(ui.user)
			. = TRUE
		if("lost_drone_spawn")
			join_lost(ui.user)
			. = TRUE
		if("maintenance_critter")
			join_maintrcritter(ui.user)
			. = TRUE
		if("gravekeeper_spawn")
			join_grave(ui.user)
			. = TRUE

/datum/tgui_module/ghost_spawn_menu/proc/compile_pod_data()
	var/list/compiled_pods = list()
	for(var/atom/movable/spawn_object in GLOB.active_ghost_pods)
		var/enabled = TRUE
		if(istype(spawn_object, /obj/structure/ghost_pod/manual))
			var/obj/structure/ghost_pod/manual/man = spawn_object
			if(!man.remains_active)
				enabled = FALSE
		var/type = "Other"
		if(ismouse(spawn_object))
			type = "Mouse"
		else if(ismob(spawn_object))
			type = "Mob"
		else if(isstructure(spawn_object))
			type = "Structure"
		UNTYPED_LIST_ADD(compiled_pods, list("pod_type" = type, "pod_name" = spawn_object.name, "z_level" = spawn_object.z, "ref" = REF(spawn_object), "remains_active" = enabled))
	return compiled_pods

/datum/tgui_module/ghost_spawn_menu/proc/compile_ghost_join_data(mob/user)
	var/ghost_spawn_exists = FALSE
	for(var/obj/effect/landmark/L in GLOB.landmarks_list)
		if(L.name == JOB_GHOSTROLES)
			ghost_spawn_exists = TRUE
			break
	var/deathtime = world.time - user.timeofdeath
	var/time_diff = 15 MINUTES - deathtime
	var/timedifference_text = time_diff > 0 ? time2text(time_diff, "mm:ss") : ""
	var/list/ghost_join_data = list(
		"mouse_data" =  get_mouse_data(user),
		"drone_data" = get_drone_data(user),
		"vr_data" = get_vr_data(user),
		"ghost_banned" = jobban_isbanned(user, JOB_CYBORG),
		"cyborg_banned" = jobban_isbanned(user, JOB_GHOSTROLES),
		"may_respawn" = user.MayRespawn(),
		"special_role_respawn" = timedifference_text,
		"existing_ghost_spawnpoints" = ghost_spawn_exists,
		"remaining_ghost_roles" = GLOB.allowed_ghost_spawns
	)
	return ghost_join_data

/datum/tgui_module/ghost_spawn_menu/proc/get_mouse_data(mob/user)
	var/turf/T = get_turf(user)
	var/timedifference_mouse = world.time - user.client.time_died_as_mouse
	var/timedifference_mouse_text = ""
	if(user.client.time_died_as_mouse && timedifference_mouse <= CONFIG_GET(number/mouse_respawn_time) MINUTES)
		timedifference_mouse_text = time2text(CONFIG_GET(number/mouse_respawn_time) MINUTES - timedifference_mouse,"mm:ss")
	var/found_vents = FALSE
	for(var/obj/machinery/atmospherics/unary/vent_pump/v in GLOB.machines)
		if(!v.welded && v.z == T.z && v.network && v.network.normal_members.len > MOUSE_VENT_NETWORK_LENGTH)
			found_vents = TRUE
			break

	return list(
				"disabled" = CONFIG_GET(flag/disable_player_mice),
				"bad_turf" = (!T || (T.z in using_map.admin_levels)),
				"respawn_time" = timedifference_mouse_text,
				"found_vents" = found_vents
			)

/datum/tgui_module/ghost_spawn_menu/proc/get_drone_data(mob/user)
	var/time_till_play
	if(CONFIG_GET(flag/use_age_restriction_for_jobs) && isnum(user.client.player_age))
		time_till_play = max(0, 3 - user.client.player_age)
	var/deathtime = world.time - user.timeofdeath
	var/time_diff = 5 MINUTES - deathtime
	var/timedifference_text = time_diff > 0 ? time2text(time_diff, "mm:ss") : ""
	var/list/all_fabricators = list()
	for(var/obj/machinery/drone_fabricator/DF in GLOB.all_drone_fabricators)
		if(DF.stat & NOPOWER || !DF.produce_drones)
			continue
		if(DF.drone_progress >= 100)
			all_fabricators += list(REF(DF) = DF.fabricator_tag)

	return list(
				"disabled" = !CONFIG_GET(flag/allow_drone_spawn),
				"days_to_play" = time_till_play,
				"respawn_time" = timedifference_text,
				"fabricators" = all_fabricators
			)

/datum/tgui_module/ghost_spawn_menu/proc/get_vr_data(mob/user)
	var/datum/data/record/record_found = find_general_record("name", user.client.prefs.read_preference(/datum/preference/name/real_name))
	var/list/vr_landmarks = list()
	for(var/obj/effect/landmark/virtual_reality/sloc in GLOB.landmarks_list)
		vr_landmarks += list(REF(sloc) = sloc.name)

	return list(
				"record_found" = !!record_found,
				"vr_landmarks" = vr_landmarks
			)

/datum/tgui_module/ghost_spawn_menu/proc/compile_vorespawn_data()
	var/list/compiled_spawn_data = list()
	for(var/mob/living/player in GLOB.player_list)
		if(!player.client || player.stat)
			continue
		var/soulcatcher_active = FALSE
		var/soulcatcher_vore_active = FALSE
		var/vorespawn_active = FALSE
		if(ishuman(player))
			var/mob/living/carbon/human/H = player
			if(H.nif)
				var/datum/nifsoft/soulcatcher/SC = H.nif.imp_check(NIF_SOULCATCHER)
				if(SC)
					soulcatcher_active = TRUE
		if(player.soulgem?.flag_check(SOULGEM_ACTIVE | SOULGEM_CATCHING_GHOSTS, TRUE))
			soulcatcher_vore_active = TRUE

		if(!player.no_vore && (get_z(player) in using_map.station_levels))
			if(ishuman(player))
				var/mob/living/carbon/human/H = player
				if(H.latejoin_vore)
					vorespawn_active = TRUE
			else if(issilicon(player))
				var/mob/living/silicon/S = player
				if(!isAI(S) && S.latejoin_vore)
					vorespawn_active = TRUE
			if(isanimal(player))
				var/mob/living/simple_mob/SM = player
				if(SM.vore_active && SM.latejoin_vore)
					vorespawn_active = TRUE
		compiled_spawn_data += list(REF(player) = list("player" = player.name, "soulcatcher" = soulcatcher_active, "soulcatcher_vore" = soulcatcher_vore_active, "vorespawn" = vorespawn_active))
	return compiled_spawn_data

#undef GHOST_POD_TAB
#undef GHOST_JOIN
#undef GHOST_VORE_SPAWN
