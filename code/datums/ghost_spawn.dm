// Robot module selection
/datum/tgui_module/ghost_spawn_menu
	name = "Ghost Spawn Menu"
	tgui_id = "GhostSpawn"

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

/datum/tgui_module/ghost_spawn_menu/tgui_static_data()
	var/list/data = ..()

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

	data["all_ghost_pods"] = compiled_pods
	return data

/datum/tgui_module/ghost_spawn_menu/tgui_data(mob/user)
	var/list/data = ..()

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
			close_ui()
			. = TRUE

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
