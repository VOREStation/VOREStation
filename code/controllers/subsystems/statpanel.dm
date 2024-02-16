SUBSYSTEM_DEF(statpanels)
	name = "Stat Panels"
	wait = 4
	init_order = INIT_ORDER_STATPANELS
	//init_stage = INITSTAGE_EARLY
	//priority = FIRE_PRIORITY_STATPANEL
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY
	var/list/currentrun = list()
	var/list/global_data
	var/list/mc_data
	var/list/cached_images = list()

	///how many subsystem fires between most tab updates
	var/default_wait = 10
	///how many subsystem fires between updates of the status tab
	var/status_wait = 6
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
			"Next Map: -- Not Available --",
			//"Round ID: [GLOB.round_id ? GLOB.round_id : "NULL"]",
			"Round ID: -- Not Available --",
			"Server Time: [time2text(world.timeofday, "YYYY-MM-DD hh:mm:ss")]",
			//"Round Time: [ROUND_TIME]",
			"Round Time: -- Not Available --",
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

		if(!target.stat_panel.is_ready())
			continue

		if(target.stat_tab == "Status" && num_fires % status_wait == 0)
			set_status_tab(target)

		if(!target.holder)
			target.stat_panel.send_message("remove_admin_tabs")
		else
			//target.stat_panel.send_message("update_split_admin_tabs", !!(target.prefs.toggles & SPLIT_ADMIN_TABS))
			target.stat_panel.send_message("update_split_admin_tabs", TRUE)

			if(!("MC" in target.panel_tabs) || !("Tickets" in target.panel_tabs))
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

			// Handle the examined turf of the stat panel

			if(target_mob?.listed_turf && num_fires % default_wait == 0)
				if(!target_mob.TurfAdjacent(target_mob.listed_turf) || isnull(target_mob.listed_turf))
					target.stat_panel.send_message("remove_listedturf")
					target_mob.listed_turf = null

				else if(target.stat_tab == target_mob?.listed_turf.name || !(target_mob?.listed_turf.name in target.panel_tabs))
					set_turf_examine_tab(target, target_mob)

		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/statpanels/proc/set_status_tab(client/target)
	if(!global_data)//statbrowser hasnt fired yet and we were called from immediate_send_stat_data()
		return

	target.stat_panel.send_message("update_stat", list(
		global_data = global_data,
		//ping_str = "Ping: [round(target.lastping, 1)]ms (Average: [round(target.avgping, 1)]ms)",
		ping_str = "Ping: -- Not Available --",
		other_str = target.mob?.get_status_tab_items(),
	))

/datum/controller/subsystem/statpanels/proc/set_MC_tab(client/target)
	var/turf/eye_turf = get_turf(target.eye)
	var/coord_entry = COORD(eye_turf)
	if(!mc_data)
		generate_mc_data()
	target.stat_panel.send_message("update_mc", list(mc_data = mc_data, coord_entry = coord_entry))

/datum/controller/subsystem/statpanels/proc/set_tickets_tab(client/target)
	var/list/ahelp_tickets = GLOB.ahelp_tickets.stat_entry()
	target.stat_panel.send_message("update_tickets", ahelp_tickets)
	/*
	var/datum/interview_manager/m = GLOB.interviews

	// get open interview count
	var/dc = 0
	for (var/ckey in m.open_interviews)
		var/datum/interview/current_interview = m.open_interviews[ckey]
		if (current_interview && !current_interview.owner)
			dc++
	var/stat_string = "([m.open_interviews.len - dc] online / [dc] disconnected)"

	// Prepare each queued interview
	var/list/queued = list()
	for (var/datum/interview/queued_interview in m.interview_queue)
		queued += list(list(
			"ref" = REF(queued_interview),
			"status" = "\[[queued_interview.pos_in_queue]\]: [queued_interview.owner_ckey][!queued_interview.owner ? " (DC)": ""] \[INT-[queued_interview.id]\]"
		))

	*/
	var/list/queued = list() // -- REMOVE IF ABOVE IS FIXED --
	var/list/data = list(
		"status" = list(
			"Active:" = "-- Not Available --",
			"Queued:" = "-- Not Available --",
			"Closed:" = "-- Not Available --"),
		"interviews" = queued
	)

	// Push update
	target.stat_panel.send_message("update_interviews", data)

/datum/controller/subsystem/statpanels/proc/set_SDQL2_tab(client/target)
	var/list/sdql2A = list()
	sdql2A[++sdql2A.len] = list("", "Access Global SDQL2 List", REF(GLOB.sdql2_vv_statobj))
	//var/list/sdql2B = list()
	//for(var/datum/sdql2_query/query as anything in GLOB.sdql2_queries)
	//	sdql2B = query.generate_stat()

	//sdql2A += sdql2B
	target.stat_panel.send_message("update_sdql2", sdql2A)

/// Set up the various action tabs.
/datum/controller/subsystem/statpanels/proc/set_action_tabs(client/target, mob/target_mob)
	return
	//var/list/actions = target_mob.get_actions_for_statpanel()
	//target.spell_tabs.Cut()

	//for(var/action_data in actions)
	//	target.spell_tabs |= action_data[1]

	//target.stat_panel.send_message("update_spells", list(spell_tabs = target.spell_tabs, actions = actions))

/datum/controller/subsystem/statpanels/proc/set_turf_examine_tab(client/target, mob/target_mob)
	var/list/overrides = list()
	var/list/turfitems = list()
	for(var/image/target_image as anything in target.images)
		if(!target_image.loc || target_image.loc.loc != target_mob.listed_turf || !target_image.override)
			continue
		overrides += target_image.loc

	turfitems[++turfitems.len] = list("[target_mob.listed_turf]", REF(target_mob.listed_turf), icon2html(target_mob.listed_turf, target, sourceonly=TRUE))

	for(var/atom/movable/turf_content as anything in target_mob.listed_turf)
		if(turf_content.mouse_opacity == MOUSE_OPACITY_TRANSPARENT)
			continue
		if(turf_content.invisibility > target_mob.see_invisible)
			continue
		if(turf_content in overrides)
			continue
		//if(turf_content.IsObscured())
			//continue

		if(length(turfitems) < 10) // only create images for the first 10 items on the turf, for performance reasons
			var/turf_content_ref = REF(turf_content)
			if(!(turf_content_ref in cached_images))
				cached_images += turf_content_ref
				turf_content.RegisterSignal(turf_content, COMSIG_PARENT_QDELETING, /atom/.proc/remove_from_cache) // we reset cache if anything in it gets deleted

				if(ismob(turf_content) || length(turf_content.overlays) > 2)
					turfitems[++turfitems.len] = list("[turf_content.name]", turf_content_ref, costly_icon2html(turf_content, target, sourceonly=TRUE))
				else
					turfitems[++turfitems.len] = list("[turf_content.name]", turf_content_ref, icon2html(turf_content, target, sourceonly=TRUE))
			else
				turfitems[++turfitems.len] = list("[turf_content.name]", turf_content_ref)
		else
			turfitems[++turfitems.len] = list("[turf_content.name]", REF(turf_content))

	turfitems = turfitems
	target.stat_panel.send_message("update_listedturf", turfitems)

/datum/controller/subsystem/statpanels/proc/generate_mc_data()
	mc_data = list(
		list("CPU:", world.cpu),
		list("Instances:", "[num2text(world.contents.len, 10)]"),
		list("World Time:", "[world.time]"),
		list("Globals:", GLOB.stat_entry(), "\ref[GLOB]"),
		//list("[config]:", config.stat_entry(), "\ref[config]"),
		//list("Byond:", "(FPS:[world.fps]) (TickCount:[world.time/world.tick_lag]) (TickDrift:[round(Master.tickdrift,1)]([round((Master.tickdrift/(world.time/world.tick_lag))*100,0.1)]%)) (Internal Tick Usage: [round(MAPTICK_LAST_INTERNAL_TICK_USAGE,0.1)]%)"),
		list("Byond:", "(FPS:[world.fps]) (TickCount:[world.time/world.tick_lag]) (TickDrift:[round(Master.tickdrift,1)]([round((Master.tickdrift/(world.time/world.tick_lag))*100,0.1)]%)) (Internal Tick Usage: -- Not Available --)"),
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

	// Handle turfs

	if(target_mob?.listed_turf)
		if(!target_mob.TurfAdjacent(target_mob.listed_turf))
			target.stat_panel.send_message("removed_listedturf")
			target_mob.listed_turf = null

		else if(target.stat_tab == target_mob?.listed_turf.name || !(target_mob?.listed_turf.name in target.panel_tabs))
			set_turf_examine_tab(target, target_mob)
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

/atom/proc/remove_from_cache()
	SIGNAL_HANDLER
	SSstatpanels.cached_images -= REF(src)

/// Stat panel window declaration
/client/var/datum/tgui_window/stat_panel
