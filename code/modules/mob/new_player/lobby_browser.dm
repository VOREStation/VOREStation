/mob/new_player/proc/initialize_lobby_screen()
	if(!client)
		return

	var/datum/tgui/ui = SStgui.get_open_ui(src, src)
	if(ui)
		ui.close()

	winset(src, "lobby_browser", "is-disabled=false;is-visible=true")
	// winset(src, "mapwindow.status_bar", "is-visible=false")
	lobby_window = new(client, "lobby_browser")
	lobby_window.initialize(
		assets = list(
			get_asset_datum(/datum/asset/simple/tgui)
		)
	)

	tgui_interact(src)

/mob/new_player/tgui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui, custom_state)
	. = ..()

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "LobbyMenu", window = lobby_window)
		ui.closeable = FALSE
		ui.open(preinitialized = TRUE)

/mob/new_player/tgui_state(mob/user)
	return GLOB.tgui_always_state

/mob/new_player/ui_assets(mob/user)
	. = ..()
	. += get_asset_datum(/datum/asset/simple/lobby_files)

/mob/new_player/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	var/displayed_name = world.name
	if(config && CONFIG_GET(string/servername))
		displayed_name = CONFIG_GET(string/servername)

	data["server_name"] = displayed_name
	data["map"] = using_map.full_name
	data["station_time"] = stationtime2text()
	data["display_loading"] = SSticker.current_state == GAME_STATE_INIT
	data["round_start"] = !SSticker.mode || SSticker.current_state <= GAME_STATE_PREGAME
	data["round_time"] = roundduration2text()
	data["ready"] = ready
	data["new_news"] = client?.check_for_new_server_news()
	data["can_submit_feedback"] = SSsqlite.can_submit_feedback(client)
	data["show_station_news"] = GLOB.news_data.station_newspaper
	data["new_station_news"] = client.prefs.lastlorenews != GLOB.news_data.newsindex
	data["new_changelog"] = read_preference(/datum/preference/text/lastchangelog) == GLOB.changelog_hash

	return data

/mob/new_player/tgui_static_data(mob/user)
	var/list/data = ..()

	data["bg"] = 'icons/misc/loading.dmi'
	data["bg_state"] = "loading"

	return data

/mob/new_player/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("character_setup")
			client.prefs.ShowChoices(src)
			return TRUE
		if("ready")
			if(!SSticker || SSticker.current_state <= GAME_STATE_PREGAME)
				ready = !ready
			else
				ready = 0
			return TRUE
		if("manifest")
			ViewManifest()
			return TRUE
		if("late_join")
			if(!ticker || ticker.current_state != GAME_STATE_PLAYING)
				to_chat(usr, span_red("The round is either not ready, or has already finished..."))
				return TRUE

			var/time_till_respawn = time_till_respawn()
			if(time_till_respawn == -1) // Special case, never allowed to respawn
				to_chat(usr, span_warning("Respawning is not allowed!"))
			else if(time_till_respawn) // Nonzero time to respawn
				to_chat(usr, span_warning("You can't respawn yet! You need to wait another [round(time_till_respawn/10/60, 0.1)] minutes."))
				return TRUE
			LateChoices()
			return TRUE
		if("observe")
			if(!SSticker || SSticker.current_state == GAME_STATE_INIT)
				to_chat(src, span_warning("The game is still setting up, please try again later."))
				return TRUE
			if(tgui_alert(src,"Are you sure you wish to observe? If you do, make sure to not use any knowledge gained from observing if you decide to join later.","Observe Round?",list("Yes","No")) == "Yes")
				if(!client)
					return TRUE

				//Make a new mannequin quickly, and allow the observer to take the appearance
				var/mob/living/carbon/human/dummy/mannequin = get_mannequin(client.ckey)
				client.prefs.dress_preview_mob(mannequin)
				var/mob/observer/dead/observer = new(mannequin)
				observer.moveToNullspace() //Let's not stay in our doomed mannequin

				spawning = 1
				if(client.media)
					client.media.stop_music() // MAD JAMS cant last forever yo

				observer.started_as_observer = 1
				close_spawn_windows()
				var/obj/O = locate("landmark*Observer-Start")
				if(istype(O))
					to_chat(src, span_notice("Now teleporting."))
					observer.forceMove(O.loc)
				else
					to_chat(src, span_danger("Could not locate an observer spawn point. Use the Teleport verb to jump to the station map."))

				announce_ghost_joinleave(src)

				if(client.prefs.read_preference(/datum/preference/toggle/human/name_is_always_random))
					client.prefs.real_name = random_name(client.prefs.identifying_gender)
				observer.real_name = client.prefs.real_name
				observer.name = observer.real_name
				if(!client.holder && !CONFIG_GET(flag/antag_hud_allowed))           // For new ghosts we remove the verb from even showing up if it's not allowed.
					remove_verb(observer, /mob/observer/dead/verb/toggle_antagHUD)        // Poor guys, don't know what they are missing!
				observer.key = key
				observer.set_respawn_timer(time_till_respawn()) // Will keep their existing time if any, or return 0 and pass 0 into set_respawn_timer which will use the defaults
				observer.client.init_verbs()
				qdel(src)

			return TRUE
		if("shownews")
			handle_server_news()
			return TRUE
		if("give_feedback")
			if(!SSsqlite.can_submit_feedback(GLOB.directory[persistent_ckey]))
				return

			if(client.feedback_form)
				client.feedback_form.display() // In case they closed the form early.
			else
				client.feedback_form = new(client)
			return TRUE
		if("open_station_news")
			show_latest_news(GLOB.news_data.station_newspaper)
			return TRUE
		if("open_changelog")
			write_preference_directly(/datum/preference/text/lastchangelog, GLOB.changelog_hash)
			client.changes()
			return TRUE
		if("keyboard")
			if(!SSsounds.subsystem_initialized)
				return

			playsound_local(ui.user, get_sfx("keyboard"), vol = 20)
			return TRUE
