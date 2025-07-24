/**
 * Helper function to call the appropriate ghost spawn function
 * This centralizes all ghost spawn actions, and fixes non-admins not being able to use the ghost spawn menu.
 */
/proc/ghost_spawn(function_name, mob/observer/dead/user, additional_args = null)
	if(!istype(user))
		return FALSE

	switch(function_name)
		if("jump_to_pod")
			var/datum/tgui_module/ghost_spawn_menu/menu = new()
			menu.jump_to_pod(user, additional_args)
			return TRUE

		if("become_mouse")
			var/datum/tgui_module/ghost_spawn_menu/menu = new()
			menu.become_mouse(user)
			return TRUE

		if("become_drone")
			var/datum/tgui_module/ghost_spawn_menu/menu = new()
			menu.become_drone(user, additional_args)
			return TRUE

		if("join_vr")
			var/datum/tgui_module/ghost_spawn_menu/menu = new()
			menu.join_vr(user, additional_args)
			return TRUE

		if("join_corgi")
			var/datum/tgui_module/ghost_spawn_menu/menu = new()
			menu.join_corgi(user)
			return TRUE

		if("join_lost")
			var/datum/tgui_module/ghost_spawn_menu/menu = new()
			menu.join_lost(user)
			return TRUE

		if("join_maintpred")
			var/datum/tgui_module/ghost_spawn_menu/menu = new()
			menu.join_maintpred(user)
			return TRUE

		if("join_grave")
			var/datum/tgui_module/ghost_spawn_menu/menu = new()
			menu.join_grave(user)
			return TRUE

		if("join_morpth")
			var/datum/tgui_module/ghost_spawn_menu/menu = new()
			menu.join_morpth(user)
			return TRUE

		if("soulcatcher_spawn")
			var/datum/tgui_module/ghost_spawn_menu/menu = new()
			menu.soulcatcher_spawn(user, additional_args)
			return TRUE

		if("soulcatcher_vore_spawn")
			var/datum/tgui_module/ghost_spawn_menu/menu = new()
			menu.soulcatcher_vore_spawn(user, additional_args)
			return TRUE

		if("vore_belly_spawn")
			var/datum/tgui_module/ghost_spawn_menu/menu = new()
			menu.vore_belly_spawn(user, additional_args)
			return TRUE

	return FALSE
