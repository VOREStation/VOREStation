SUBSYSTEM_DEF(lobby_monitor)
	name = "Lobby Art"
	init_order = INIT_ORDER_LOBBY
	// init_stage = INITSTAGE_EARLY
	flags = SS_NO_INIT
	wait = 1 SECOND
	runlevels = ALL

	/// The clients who we've waited a [wait] duration to start working. If they haven't, we reboot them
	var/to_reinitialize = list()

/datum/controller/subsystem/lobby_monitor/fire(resumed)
	var/list/new_players = GLOB.new_player_list

	for(var/mob/new_player/player as anything in to_reinitialize)
		if(!player.client)
			continue

		var/datum/tgui/ui = SStgui.get_open_ui(player, player)
		if(ui && player.lobby_window && player.lobby_window.status > TGUI_WINDOW_CLOSED)
			continue

		log_tgui(player, "Reinitialized [player.client.ckey]'s lobby window: [ui ? "ui" : "no ui"], status: [player.lobby_window?.status].", "lobby_monitor/Fire")
		INVOKE_ASYNC(player, TYPE_PROC_REF(/mob/new_player, initialize_lobby_screen))

	var/initialize_queue = list()
	for(var/mob/new_player/player as anything in new_players)
		if(!player.client)
			continue

		if(player in to_reinitialize)
			continue

		var/datum/tgui/ui = SStgui.get_open_ui(player, player)
		if(ui && player.lobby_window && player.lobby_window.status > TGUI_WINDOW_CLOSED)
			continue

		initialize_queue += player

	to_reinitialize = initialize_queue

/datum/controller/subsystem/lobby_monitor/Shutdown()
	var/datum/asset/our_asset = get_asset_datum(/datum/asset/simple/restart_animation)
	var/to_send = "<!DOCTYPE html><html lang='en'><head><meta http-equiv='X-UA-Compatible' content='IE=edge' /></head><body style='overflow: hidden;padding: 0 !important;margin: 0 !important'><div style='background-image: url([our_asset.get_url_mappings()["loading"]]);background-position:center;background-size:cover;position:absolute;width:100%;height:100%'></body></html>"

	for(var/client/client as anything in GLOB.clients)
		winset(client, "lobby_browser", "is-disabled=false;is-visible=true")

		client << browse(to_send, "window=lobby_browser")
