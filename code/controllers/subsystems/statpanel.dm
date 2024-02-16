SUBSYSTEM_DEF(statpanels)
	name = "Stat Panels"
	wait = 4
	init_order = INIT_ORDER_STATPANELS
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY
	var/list/currentrun = list()
	var/encoded_global_data
	var/mc_data_encoded
	var/list/cached_images = list()

/datum/controller/subsystem/statpanels/fire(resumed = FALSE)
	if (!resumed)
		//var/datum/map_config/cached = SSmapping.next_map_config
		var/round_time = world.time - SSticker.pregame_timeleft
		var/list/global_data = list(
			//"Map: [SSmapping.config?.map_name || "Loading..."]",
			"Map: [using_map.name]",
			//cached ? "Next Map: [cached.map_name]" : null,
			"Next Map: -- Not Available -- ",
			//"Round ID: [GLOB.round_id ? GLOB.round_id : "NULL"]",
			"Round ID: -- Not Available -- ",
			"Server Time: [time2text(world.timeofday, "YYYY-MM-DD hh:mm:ss")]",
			"Round Time: [round_time > MIDNIGHT_ROLLOVER ? "[round(round_time/MIDNIGHT_ROLLOVER)]:[worldtime2stationtime()]" : worldtime2stationtime()]",
			"Station Time: [stationtime2text()]",
			"Time Dilation: [round(SStime_track.time_dilation_current,1)]% AVG:([round(SStime_track.time_dilation_avg_fast,1)]%, [round(SStime_track.time_dilation_avg,1)]%, [round(SStime_track.time_dilation_avg_slow,1)]%)"
		)

		if(emergency_shuttle.evac)
			var/ETA = emergency_shuttle.get_status_panel_eta()
			if(ETA)
				global_data += "[ETA]"
		encoded_global_data = url_encode(json_encode(global_data))

		var/list/mc_data = list(
			list("CPU:", world.cpu),
			list("Instances:", "[num2text(world.contents.len, 10)]"),
			list("World Time:", "[world.time]"),
			list("Globals:", "Edit", "\ref[GLOB]"),
			list("[config]:", "Edit", "\ref[config]"),
			list("Byond:", "(FPS:[world.fps]) (TickCount:[world.time/world.tick_lag]) (TickDrift:[round(Master.tickdrift,1)]([round((Master.tickdrift/(world.time/world.tick_lag))*100,0.1)]%))"),
			list("Master Controller:", Master ? "(TickRate:[Master.processing]) (Iteration:[Master.iteration])" : "ERROR", "\ref[Master]"),
			list("Failsafe Controller:", Failsafe ? "Defcon: [Failsafe.defcon_pretty()] (Interval: [Failsafe.processing_interval] | Iteration: [Failsafe.master_iteration])" : "ERROR", "\ref[Failsafe]"),
			list("","")
		)
		for(var/ss in Master.subsystems)
			var/datum/controller/subsystem/sub_system = ss
			mc_data[++mc_data.len] = list("\[[sub_system.state_letter()]][sub_system.name]", sub_system.stat_entry(), "\ref[sub_system]")
		mc_data[++mc_data.len] = list("Camera Net", "Cameras: [global.cameranet.cameras.len] | Chunks: [global.cameranet.chunks.len]", "\ref[global.cameranet]")
		mc_data_encoded = url_encode(json_encode(mc_data))
		src.currentrun = GLOB.clients.Copy()

	var/list/currentrun = src.currentrun
	while(length(currentrun))
		var/client/target = currentrun[length(currentrun)]
		currentrun.len--
		//var/ping_str = url_encode("Ping: [round(target.lastping, 1)]ms (Average: [round(target.avgping, 1)]ms)")
		var/ping_str = url_encode("Ping: -- Not Available --")
		var/other_str = url_encode(json_encode(target.mob.get_status_tab_items()))
		target << output("[encoded_global_data];[ping_str];[other_str]", "statbrowser:update")
		if(!target.holder)
			target << output("", "statbrowser:remove_admin_tabs")
		else
			var/turf/eye_turf = get_turf(target.eye)
			//var/coord_entry = url_encode(COORD(eye_turf))
			//target << output("[mc_data_encoded];[coord_entry];[url_encode(target.holder.href_token)]", "statbrowser:update_mc")
			var/list/ahelp_tickets = GLOB.ahelp_tickets.stat_entry()
			target << output("[url_encode(json_encode(ahelp_tickets))];", "statbrowser:update_tickets")
			if(!length(GLOB.sdql2_queries))
				target << output("", "statbrowser:remove_sqdl2")
			else
				var/list/sqdl2A = list()
				sqdl2A[++sqdl2A.len] = list("", "Access Global SDQL2 List", REF(GLOB.sdql2_vv_statobj))
				// TODO: Fix
				//var/list/sqdl2B = list()
				//for(var/i in GLOB.sdql2_queries)
				//	var/datum/sdql2_query/Q = i
				//	sqdl2B = Q.generate_stat()
				//sqdl2A += sqdl2B
				target << output(url_encode(json_encode(sqdl2A)), "statbrowser:update_sqdl2")
		var/list/proc_holders = target.mob.get_proc_holders()
		target.spell_tabs.Cut()
		for(var/phl in proc_holders)
			var/list/proc_holder_list = phl
			target.spell_tabs |= proc_holder_list[1]
		var/proc_holders_encoded = ""
		if(length(proc_holders))
			proc_holders_encoded = url_encode(json_encode(proc_holders))
		target << output("[url_encode(json_encode(target.spell_tabs))];[proc_holders_encoded]", "statbrowser:update_spells")
		if(target.mob?.listed_turf)
			var/mob/target_mob = target.mob
			if(!target_mob.TurfAdjacent(target_mob.listed_turf))
				target << output("", "statbrowser:remove_listedturf")
				target_mob.listed_turf = null
			else
				var/list/overrides = list()
				var/list/turfitems = list()
				for(var/img in target.images)
					var/image/target_image = img
					if(!target_image.loc || target_image.loc.loc != target_mob.listed_turf || !target_image.override)
						continue
					overrides += target_image.loc
				for(var/tc in target_mob.listed_turf)
					var/atom/movable/turf_content = tc
					if(turf_content.mouse_opacity == MOUSE_OPACITY_TRANSPARENT)
						continue
					if(turf_content.invisibility > target_mob.see_invisible)
						continue
					if(turf_content in overrides)
						continue
					// TODO: Fix?
					//if(turf_content.IsObscured())
						//continue
					if(length(turfitems) < 30) // only create images for the first 30 items on the turf, for performance reasons
						if(!(REF(turf_content) in cached_images))
							target << browse_rsc(getFlatIcon(turf_content, no_anim = TRUE), "[REF(turf_content)].png")
							cached_images += REF(turf_content)
						turfitems[++turfitems.len] = list("[turf_content.name]", REF(turf_content), "[REF(turf_content)].png")
					else
						turfitems[++turfitems.len] = list("[turf_content.name]", REF(turf_content))
				turfitems = url_encode(json_encode(turfitems))
				target << output("[turfitems];", "statbrowser:update_listedturf")
		if(MC_TICK_CHECK)
			return
