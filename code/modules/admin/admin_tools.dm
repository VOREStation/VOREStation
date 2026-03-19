ADMIN_VERB_ONLY_CONTEXT_MENU(cmd_admin_check_player_logs, R_ADMIN|R_MOD, "Check Mob Logs", mob/living/player in  GLOB.mob_list)
	user.show_cmd_admin_check_player_logs(player.logging, player.name, player.ckey, player.mind?.special_role)

//Views specific attack logs belonging to one player.
/client/proc/show_cmd_admin_check_player_logs(list/mob_data, target_name, target_ckey, target_special)
	if(CONFIG_GET(flag/database_logging))
		var/datum/db_query/query = SSdbcore.NewQuery("SELECT id,time,ckey,mob,area,color,type,message from erro_attacklog WHERE ckey = :t_ckey", list("t_ckey" = ckey))
		if(!query.Execute())
			to_chat(src, span_admin("Database query error"))
			qdel(query)
			return

		var/list/data = list()
		while(query.NextRow())
			LAZYADD(data[type], list(
				"event_id" = query.item[1],
				"time" = query.item[2],
				"ckey" = query.item[3],
				"name" = query.item[4],
				"loc" = query.item[5],
				"color" = query.item[6],
				"message" = query.item[8]
			))
		qdel(query)
		if(!length(data))
			to_chat(src, span_admin("No data found."))
			return
		admin_log_view_target(data, target_name, target_ckey, target_special)
		return
	if(!length(mob_data))
		to_chat(src, span_admin("No data found."))
		return
	admin_log_view_target(mob_data, target_name, target_ckey, target_special)

ADMIN_VERB(persistent_client_logs, R_ADMIN|R_MOD, "Check Player Logs", "Displays the client logs of the selected ckey.", ADMIN_CATEGORY_LOGS)
	var/mob/living/selected_key = tgui_input_list(user, "Select a ckey to check their logs", "Ckey", GLOB.persistent_clients_by_ckey)
	if(!selected_key)
		return

	var/datum/persistent_client/selected = GLOB.persistent_clients_by_ckey[selected_key]

	user.show_cmd_admin_check_player_logs(selected.logging, selected.mob?.name, selected_key, selected.mob?.mind?.special_role)

/client/proc/admin_log_view_target(list/log_data, name, ckey, special, use_db)
	var/datum/player_log_viwer/log_view = new(log_data, name, ckey, special)
	log_view.tgui_interact(mob)

/datum/player_log_viwer
	var/list/log_data
	var/target_name
	var/target_ckey
	var/special_role

/datum/player_log_viwer/tgui_close(mob/user)
	. = ..()
	log_data = null

/datum/player_log_viwer/New(list/data, name, ckey, special)
	. = ..()
	log_data = data
	target_name = name
	target_ckey = ckey
	special_role = special

/datum/player_log_viwer/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "PlayerLogViewer")
		ui.open()

/datum/player_log_viwer/tgui_state(mob/user)
	return ADMIN_STATE(R_ADMIN|R_MOD)

/datum/player_log_viwer/tgui_static_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	return list(
		"entries" = log_data,
		"name" = target_name,
		"ckey" = target_ckey,
		"special" = special_role
	)
