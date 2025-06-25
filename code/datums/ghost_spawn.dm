#define GHOST_POD_TAB 0
#define GHOST_VORE_SPAWN 1

// Ghost spawn menu
/datum/tgui_module/ghost_spawn_menu
	name = "Ghost Spawn Menu"
	tgui_id = "GhostSpawn"
	var/active_tab = GHOST_POD_TAB

/datum/tgui_module/ghost_spawn_menu/tgui_state(mob/user)
	return GLOB.tgui_self_state

/datum/tgui_module/ghost_spawn_menu/tgui_close(mob/user)
	. = ..()
	if(isobserver(user))
		var/mob/observer/dead/observer = user
		observer.selecting_ghostrole = FALSE

/datum/tgui_module/ghost_spawn_menu/tgui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	. = ..()
	if(isobserver(user) && ui)
		var/mob/observer/dead/observer = user
		observer.selecting_ghostrole = TRUE

/datum/tgui_module/ghost_spawn_menu/tgui_data(mob/user)
	var/list/data = ..()

	if(active_tab == GHOST_POD_TAB)
		data["all_ghost_pods"] = compile_pod_data()

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

/datum/tgui_module/ghost_spawn_menu/proc/compile_pod_data()
	var/list/compiled_pods = list()
	for(var/atom/movable/spawn_object in GLOB.active_ghost_pods)
		var/type = "Other"
		if(ismouse(spawn_object))
			type = "Mouse"
		else if(ismob(spawn_object))
			type = "Mob"
		else if(isstructure(spawn_object))
			type = "Structure"
		UNTYPED_LIST_ADD(compiled_pods, list("pod_type" = type, "pod_name" = spawn_object.name, "z_level" = spawn_object.z, "ref" = REF(spawn_object)))
	return compiled_pods

/datum/tgui_module/ghost_spawn_menu/proc/compile_vorespawn_data()
	var/list/compiled_spawn_data = list()
	for(var/mob/living/player in player_list)
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
#undef GHOST_VORE_SPAWN
