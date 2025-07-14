SUBSYSTEM_DEF(statpanels)
	name = "Stat Panels"
	wait = 4
	init_order = INIT_ORDER_STATPANELS
	//init_stage = INITSTAGE_EARLY
	priority = FIRE_PRIORITY_STATPANEL
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY
	flags = SS_NO_INIT
	var/list/currentrun = list()
	var/list/global_data
	var/list/mc_data

	///how many subsystem fires between most tab updates
	var/default_wait = 10
	///how many subsystem fires between updates of misc tabs
	var/misc_wait = 3
	///how many subsystem fires between updates of the status tab
	var/status_wait = 2
	///how many subsystem fires between updates of the MC tab
	var/mc_wait = 5
	///how many full runs this subsystem has completed. used for variable rate refreshes.
	var/num_fires = 0

/datum/controller/subsystem/statpanels/fire(resumed = FALSE)
	if (!resumed)
		num_fires++
		//var/datum/map_config/cached = SSmapping.next_map_config
		global_data = list(
			//"Map: [SSmapping.config?.map_name || "Loading..."]",
			"Map: [using_map.name]",
			//cached ? "Next Map: [cached.map_name]" : null,
			//"Next Map: -- Not Available --",
			"Round ID: [GLOB.round_id ? GLOB.round_id : "NULL"]",
			"Server Time: [time2text(world.timeofday, "YYYY-MM-DD hh:mm:ss")]",
			"Round Time: [roundduration2text()]",
			"Station Date: [stationdate2text()]", // [capitalize(GLOB.world_time_season)]",
			"Station Time: [stationtime2text()]",
			"Time Dilation: [round(SStime_track.time_dilation_current,1)]% AVG:([round(SStime_track.time_dilation_avg_fast,1)]%, [round(SStime_track.time_dilation_avg,1)]%, [round(SStime_track.time_dilation_avg_slow,1)]%)"
		)

		if(emergency_shuttle.evac)
			var/ETA = emergency_shuttle.get_status_panel_eta()
			if(ETA)
				global_data += "[ETA]"
		src.currentrun = GLOB.clients.Copy()
		mc_data = null

	var/list/currentrun = src.currentrun
	while(length(currentrun))
		var/client/target = currentrun[length(currentrun)]
		currentrun.len--

		if(!target?.stat_panel?.is_ready()) // Null target client, client has null stat panel, or stat panel isn't ready
			continue

		if(target.stat_tab == "Status" && num_fires % status_wait == 0)
			set_status_tab(target)

		if(!target.holder)
			target.stat_panel.send_message("remove_admin_tabs")
		else
			//target.stat_panel.send_message("update_split_admin_tabs", !!(target.prefs.toggles & SPLIT_ADMIN_TABS))
			target.stat_panel.send_message("update_split_admin_tabs", FALSE)

			if(check_rights_for(target, R_MENTOR))
				target.stat_panel.send_message("add_tickets_tabs", target.holder.href_token)
			if(check_rights_for(target, R_HOLDER) && (!("MC" in target.panel_tabs) || !("Tickets" in target.panel_tabs)))
				target.stat_panel.send_message("add_admin_tabs", target.holder.href_token)

			//if(target.stat_tab == "MC" && ((num_fires % mc_wait == 0) || target?.prefs.read_preference(/datum/preference/toggle/fast_mc_refresh)))
				//set_MC_tab(target)
			if(target.stat_tab == "MC" && ((num_fires % mc_wait == 0)))
				set_MC_tab(target)

			if(target.stat_tab == "Tickets" && num_fires % default_wait == 0)
				set_tickets_tab(target)

			if(!length(GLOB.sdql2_queries) && ("SDQL2" in target.panel_tabs))
				target.stat_panel.send_message("remove_sdql2")

			else if(length(GLOB.sdql2_queries) && (target.stat_tab == "SDQL2" || !("SDQL2" in target.panel_tabs)) && num_fires % default_wait == 0)
				set_SDQL2_tab(target)

		if(target.mob)
			var/mob/target_mob = target.mob

			// Handle the action panels of the stat panel

			var/update_actions = FALSE
			// We're on a spell tab, update the tab so we can see cooldowns progressing and such
			if(target.stat_tab in target.spell_tabs)
				update_actions = TRUE
			// We're not on a spell tab per se, but we have cooldown actions, and we've yet to
			// set up our spell tabs at all
			//if(!length(target.spell_tabs) && locate(/datum/action/cooldown) in target_mob.actions)
				//update_actions = TRUE

			if(update_actions && num_fires % default_wait == 0)
				set_action_tabs(target, target_mob)
			//Update every fire if tab is open, otherwise update every 7 fires
			if((num_fires % misc_wait == 0))
				update_misc_tabs(target,target_mob)

		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/statpanels/proc/update_misc_tabs(var/client/target,var/mob/target_mob)
	target_mob.update_misc_tabs()
	for(var/tab in target_mob.misc_tabs)
		if(target_mob.misc_tabs[tab].len == 0 && (tab in target.misc_tabs))
			target.misc_tabs -= tab
			target.stat_panel.send_message("remove_misc",tab)

		if(target_mob.misc_tabs[tab].len > 0)
			if(!(tab in target.misc_tabs))
				target.misc_tabs += tab
				target.stat_panel.send_message("create_misc",tab)
			target.stat_panel.send_message("update_misc",list(
				TN = tab, \
				TC = target_mob.misc_tabs[tab], \
			))

	for(var/tab in target.misc_tabs)
		if(!(tab in target_mob.misc_tabs))
			target.misc_tabs -= tab
			target.stat_panel.send_message("remove_misc",tab)

/datum/controller/subsystem/statpanels/proc/set_status_tab(client/target)
	if(!global_data)//statbrowser hasnt fired yet and we were called from immediate_send_stat_data()
		return

	target.stat_panel.send_message("update_stat", list(
		global_data = global_data,
		ping_str = "Ping: [round(target.lastping, 1)]ms (Average: [round(target.avgping, 1)]ms)",
		other_str = target.mob?.get_status_tab_items(),
	))

/datum/controller/subsystem/statpanels/proc/set_MC_tab(client/target)
	var/turf/eye_turf = get_turf(target.eye)
	var/coord_entry = COORD(eye_turf)
	if(!mc_data)
		generate_mc_data()
	target.stat_panel.send_message("update_mc", list(mc_data = mc_data, coord_entry = coord_entry))

/datum/controller/subsystem/statpanels/proc/set_examine_tab(client/target)
	var/description_holders = target.description_holders
	var/list/examine_update = list()

	var/atom/atom_icon = description_holders["icon"]
	var/shown_icon = target.examine_icon
	if(!shown_icon)
		if(ismob(atom_icon) || length(atom_icon.overlays) > 0)
			var/force_south = FALSE
			if(isliving(atom_icon))
				force_south = TRUE
			shown_icon = costly_icon2html(atom_icon, target, sourceonly=TRUE, force_south = force_south)
		else
			shown_icon = icon2html(atom_icon, target, sourceonly=TRUE)
	examine_update += "<img src=\"[shown_icon]\" />&emsp;" + span_giant("[description_holders["name"]]") //The name, written in big letters.
	examine_update += "[description_holders["desc"]]" //the default examine text.
	if(description_holders["info"])
		examine_update += span_blue(span_bold("[replacetext(description_holders["info"], "\n", "<BR>")]")) + "<br />" //Blue, informative text.
	if(description_holders["interactions"])
		for(var/line in description_holders["interactions"])
			examine_update += span_blue(span_bold("[line]")) + "<br />"
	if(description_holders["fluff"])
		examine_update += span_green(span_bold("[replacetext(description_holders["fluff"], "\n", "<BR>")]")) + "<br />" //Green, fluff-related text.
	if(description_holders["antag"])
		examine_update += span_red(span_bold("[description_holders["antag"]]")) + "<br />" //Red, malicious antag-related text

	var/update_panel = FALSE
	if(target.prefs?.read_preference(/datum/preference/choiced/examine_mode) == EXAMINE_MODE_SWITCH_TO_PANEL)
		update_panel = TRUE

	target.stat_panel.send_message("update_examine", list("EX" = examine_update, "UPD" = update_panel))

/datum/controller/subsystem/statpanels/proc/set_tickets_tab(client/target)
	var/list/tickets = list()
	if(check_rights_for(target, R_ADMIN|R_SERVER|R_MOD|R_MENTOR)) //Prevents non-staff from opening the list of ahelp tickets
		tickets = GLOB.tickets.stat_entry(target)
	target.stat_panel.send_message("update_tickets", tickets)

/datum/controller/subsystem/statpanels/proc/set_SDQL2_tab(client/target)
	var/list/sdql2A = list()
	sdql2A[++sdql2A.len] = list("", "Access Global SDQL2 List", REF(GLOB.sdql2_vv_statobj))
	var/list/sdql2B = list()
	for(var/datum/SDQL2_query/query as anything in GLOB.sdql2_queries)
		sdql2B = query.generate_stat()

	sdql2A += sdql2B
	target.stat_panel.send_message("update_sdql2", sdql2A)

/// Set up the various action tabs.
/datum/controller/subsystem/statpanels/proc/set_action_tabs(client/target, mob/target_mob)
	return
	//var/list/actions = target_mob.get_actions_for_statpanel()
	//target.spell_tabs.Cut()

	//for(var/action_data in actions)
	//	target.spell_tabs |= action_data[1]

	//target.stat_panel.send_message("update_spells", list(spell_tabs = target.spell_tabs, actions = actions))

/datum/controller/subsystem/statpanels/proc/generate_mc_data()
	mc_data = list(
		list("CPU:", world.cpu),
		list("Instances:", "[num2text(world.contents.len, 10)]"),
		list("World Time:", "[world.time]"),
		list("Globals:", GLOB.stat_entry(), "\ref[GLOB]"),
		list("[config]:", config.stat_entry(), "\ref[config]"),
		list("Byond:", "(FPS:[world.fps]) (TickCount:[world.time/world.tick_lag]) (TickDrift:[round(Master.tickdrift,1)]([round((Master.tickdrift/(world.time/world.tick_lag))*100,0.1)]%)) (Internal Tick Usage: [round(MAPTICK_LAST_INTERNAL_TICK_USAGE,0.1)]%)"),
		list("Master Controller:", Master.stat_entry(), "\ref[Master]"),
		list("Failsafe Controller:", Failsafe.stat_entry(), "\ref[Failsafe]"),
		list("","")
	)
	for(var/datum/controller/subsystem/sub_system as anything in Master.subsystems)
		mc_data[++mc_data.len] = list("\[[sub_system.state_letter()]][sub_system.name]", sub_system.stat_entry(), "\ref[sub_system]")
	mc_data[++mc_data.len] = list("Camera Net", "Cameras: [global.cameranet.cameras.len] | Chunks: [global.cameranet.chunks.len]", "\ref[global.cameranet]")

///immediately update the active statpanel tab of the target client
/datum/controller/subsystem/statpanels/proc/immediate_send_stat_data(client/target)
	if(!target.stat_panel.is_ready())
		return FALSE

	if(target.stat_tab == "Examine")
		set_examine_tab(target)
		return TRUE

	if(target.stat_tab == "Status")
		set_status_tab(target)
		return TRUE

	var/mob/target_mob = target.mob

	// Handle actions

	var/update_actions = FALSE
	if(target.stat_tab in target.spell_tabs)
		update_actions = TRUE

	//if(!length(target.spell_tabs) && locate(/datum/action/cooldown) in target_mob.actions)
		//update_actions = TRUE

	if(update_actions)
		set_action_tabs(target, target_mob)
		return TRUE

	if(!target.holder)
		return FALSE

	if(target.stat_tab == "MC")
		set_MC_tab(target)
		return TRUE

	if(target.stat_tab == "Tickets")
		set_tickets_tab(target)
		return TRUE

	if(!length(GLOB.sdql2_queries) && ("SDQL2" in target.panel_tabs))
		target.stat_panel.send_message("remove_sdql2")

	else if(length(GLOB.sdql2_queries) && target.stat_tab == "SDQL2")
		set_SDQL2_tab(target)

/// Stat panel window declaration
/client/var/datum/tgui_window/stat_panel
