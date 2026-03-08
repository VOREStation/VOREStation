//admin verb groups - They can overlap if you so wish. Only one of each verb will exist in the verbs list regardless
GLOBAL_LIST_INIT(admin_verbs_admin, list(
	/datum/admins/proc/announce,		//priority announce something to all clients.,
	/datum/admins/proc/intercom,		//send a fake intercom message, like an arrivals announcement,
	/datum/admins/proc/intercom_convo,	//send a fake intercom conversation, like an ATC exchange,
	/client/proc/hide_verbs,			//hides all our adminverbs,
	/client/proc/hide_most_verbs,		//hides all our hideable adminverbs,
	/client/proc/cmd_admin_check_player_logs,	//checks a player's attack logs,
	/client/proc/cmd_admin_check_dialogue_logs,	//checks a player's dialogue logs,
	/client/proc/jumptocoord,			//we ghost and jump to a coordinate,
	/client/proc/Getmob,				//teleports a mob to our location,
	/client/proc/Getkey,				//teleports a mob with a certain ckey to our location,
	/client/proc/Jump,
	/client/proc/jumptokey,				//allows us to jump to the location of a mob with a certain ckey,
	/client/proc/jumptomob,				//allows us to jump to a specific mob,
	/client/proc/check_ai_laws,			//shows AI and borg laws,
	/client/proc/rename_silicon,		//properly renames silicons,
	/client/proc/modify_robot,
	/client/proc/free_slot,			//frees slot for chosen job,
	/client/proc/cmd_admin_change_custom_event,
	/client/proc/toggleghostwriters,
	/client/proc/toggledrones,
	/client/proc/man_up,
	/client/proc/global_man_up,
	/client/proc/response_team, // Response Teams admin verb,
	/client/proc/trader_ship, // Trader ship admin verb,
	/client/proc/aooc,
	/client/proc/change_security_level,
	/client/proc/makepAI,
	/datum/admins/proc/set_uplink,
	/datum/admins/proc/view_feedback,
	/client/proc/delbook,
	/client/proc/start_vote,
	))

GLOBAL_LIST_INIT(admin_verbs_debug, list(
	/client/proc/Debug2,
	/client/proc/kill_air,
	/client/proc/ZASSettings,
	/client/proc/kill_airgroup,
	/client/proc/cmd_debug_mob_lists,
	/client/proc/cmd_debug_using_map,
	/client/proc/cmd_display_del_log,
	/client/proc/cmd_display_init_log,
	/client/proc/air_report,
	/client/proc/reload_admins,
	/client/proc/reload_eventMs,
	/client/proc/print_random_map,
	/client/proc/create_random_map,
	/client/proc/apply_random_map,
	/client/proc/overlay_random_map,
	/client/proc/delete_random_map,
	/client/proc/show_plant_genes,
	/client/proc/enable_debug_verbs,
	/client/proc/Jump,
	/client/proc/jumptomob,
	/client/proc/jumptocoord,
	/client/proc/hide_verbs,			//hides all our adminverbs,
	/client/proc/hide_most_verbs,		//hides all our hideable adminverbs,
	/datum/admins/proc/set_uplink,
	/datum/admins/proc/change_weather,
	/datum/admins/proc/change_time,
	/client/proc/simple_DPS,
	/datum/admins/proc/view_feedback,
	/client/proc/stop_sounds,
	))

//verbs which can be hidden - needs work
GLOBAL_LIST_INIT(admin_verbs_hideable, list(
//	/client/proc/deadchat,
	/datum/admins/proc/announce,
	/client/proc/cmd_admin_check_player_logs,
	/client/proc/cmd_admin_check_dialogue_logs,
	/client/proc/Debug2,
	/client/proc/reload_admins,
	/client/proc/kill_air,
	/client/proc/kill_airgroup,
	/client/proc/startSinglo,
	/client/proc/simple_DPS,
	/client/proc/cmd_debug_mob_lists,
	/client/proc/cmd_debug_using_map,
	/client/proc/cmd_display_del_log,
	/client/proc/air_report,
	/client/proc/enable_debug_verbs,
	/datum/admins/proc/set_uplink,
	/client/proc/stop_sounds
	))

GLOBAL_LIST_INIT(admin_verbs_mod, list(
	/client/proc/hide_verbs,			//hides all our adminverbs,
	/client/proc/hide_most_verbs,		//hides all our hideable adminverbs,
	/client/proc/aooc,
	/client/proc/start_vote
))

GLOBAL_LIST_INIT(admin_verbs_event_manager, list(
	/client/proc/hide_verbs,			//hides all our adminverbs,
	/client/proc/hide_most_verbs,		//hides all our hideable adminverbs,
	/client/proc/aooc,
	/datum/admins/proc/change_weather,
	/datum/admins/proc/change_time,
	/client/proc/Jump,
	/client/proc/jumptomob,
	/client/proc/jumptocoord,
	/datum/admins/proc/change_weather,
	/datum/admins/proc/change_time,
	/datum/admins/proc/announce,            //priority announce something to all clients.,
	/datum/admins/proc/intercom,            //send a fake intercom message, like an arrivals announcement,
	/datum/admins/proc/intercom_convo,      //send a fake intercom conversation, like an ATC exchange,
	/client/proc/cmd_admin_check_player_logs,       //checks a player's attack logs,
	/client/proc/cmd_admin_check_dialogue_logs,     //checks a player's dialogue logs,
	/client/proc/jumptocoord,                       //we ghost and jump to a coordinate,
	/client/proc/Getmob,                            //teleports a mob to our location,
	/client/proc/Getkey,                            //teleports a mob with a certain ckey to our location,
	/client/proc/Jump,
	/client/proc/jumptokey,                         //allows us to jump to the location of a mob with a certain ckey,
	/client/proc/jumptomob,                         //allows us to jump to a specific mob,
	/client/proc/check_ai_laws,                     //shows AI and borg laws,
	/client/proc/rename_silicon,            //properly renames silicons,
	/client/proc/modify_robot,
	/client/proc/free_slot,                 //frees slot for chosen job,
	/client/proc/cmd_admin_change_custom_event,
	/client/proc/toggleghostwriters,
	/client/proc/man_up,
	/client/proc/global_man_up,
	/client/proc/response_team, // Response Teams admin verb,
	/client/proc/trader_ship, // Trader ship admin verb,
	/client/proc/aooc,
	/client/proc/change_security_level,
	/client/proc/makepAI,
	/datum/admins/proc/view_feedback,
	/client/proc/start_vote,
	/client/proc/add_hidden_area,
	/client/proc/remove_hidden_area,
	/client/proc/modify_event_collector,
	/client/proc/induce_malfunction
))

GLOBAL_LIST_INIT(debug_verbs, list(
		/client/proc/do_not_use_these
		,/client/proc/camera_view
		,/client/proc/sec_camera_report
		,/client/proc/intercom_view
		,/client/proc/Cell
		,/client/proc/atmosscan
		,/client/proc/powerdebug
		,/client/proc/count_objects_on_z_level
		,/client/proc/count_objects_all
		,/client/proc/jump_to_dead_group
		,/client/proc/startSinglo
		,/client/proc/cmd_admin_grantfullaccess
		,/client/proc/kaboom
		,/client/proc/cmd_admin_areatest
		,/client/proc/print_jobban_old
		,/client/proc/print_jobban_old_filter
		,/client/proc/Zone_Info
		,/client/proc/Test_ZAS_Connection
		,/client/proc/ZoneTick
		,/client/proc/rebootAirMaster
		,/client/proc/hide_debug_verbs
		,/client/proc/testZAScolors
		,/client/proc/testZAScolors_remove
		,/datum/admins/proc/setup_supermatter
		,/client/proc/atmos_toggle_debug
		,/client/proc/spawn_tanktransferbomb
		,/client/proc/take_picture
	))
