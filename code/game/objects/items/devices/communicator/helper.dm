/obj/item/device/communicator/proc/analyze_air()
	var/list/results = list()
	var/turf/T = get_turf(src.loc)
	if(!isnull(T))
		var/datum/gas_mixture/environment = T.return_air()
		var/pressure = environment.return_pressure()
		var/total_moles = environment.total_moles
		if (total_moles)
			var/o2_level = environment.gas["oxygen"]/total_moles
			var/n2_level = environment.gas["nitrogen"]/total_moles
			var/co2_level = environment.gas["carbon_dioxide"]/total_moles
			var/phoron_level = environment.gas["phoron"]/total_moles
			var/unknown_level =  1-(o2_level+n2_level+co2_level+phoron_level)

			// Label is what the entry is describing
			// Type identifies which unit or other special characters to use
			// Val is the information reported
			// Bad_high/_low are the values outside of which the entry reports as dangerous
			// Poor_high/_low are the values outside of which the entry reports as unideal
			// Values were extracted from the template itself
			results = list(
						list("entry" = "Pressure", "units" = "kPa", "val" = "[round(pressure,0.1)]", "bad_high" = 120, "poor_high" = 110, "poor_low" = 95, "bad_low" = 80),
						list("entry" = "Temperature", "units" = "&degC", "val" = "[round(environment.temperature-T0C,0.1)]", "bad_high" = 35, "poor_high" = 25, "poor_low" = 15, "bad_low" = 5),
						list("entry" = "Oxygen", "units" = "kPa", "val" = "[round(o2_level*100,0.1)]", "bad_high" = 140, "poor_high" = 135, "poor_low" = 19, "bad_low" = 17),
						list("entry" = "Nitrogen", "units" = "kPa", "val" = "[round(n2_level*100,0.1)]", "bad_high" = 105, "poor_high" = 85, "poor_low" = 50, "bad_low" = 40),
						list("entry" = "Carbon Dioxide", "units" = "kPa", "val" = "[round(co2_level*100,0.1)]", "bad_high" = 10, "poor_high" = 5, "poor_low" = 0, "bad_low" = 0),
						list("entry" = "Phoron", "units" = "kPa", "val" = "[round(phoron_level*100,0.01)]", "bad_high" = 0.5, "poor_high" = 0, "poor_low" = 0, "bad_low" = 0),
						list("entry" = "Other", "units" = "kPa", "val" = "[round(unknown_level, 0.01)]", "bad_high" = 1, "poor_high" = 0.5, "poor_low" = 0, "bad_low" = 0)
						)

	if(isnull(results))
		results = list(list("entry" = "pressure", "units" = "kPa", "val" = "0", "bad_high" = 120, "poor_high" = 110, "poor_low" = 95, "bad_low" = 80))
	return results


// Proc - compile_news()
// Parameters - none
// Description - Returns the list of newsfeeds, compiled for template processing
/obj/item/device/communicator/proc/compile_news()
	var/list/feeds = list()
	for(var/datum/feed_channel/channel in news_network.network_channels)
		var/list/messages = list()
		if(!channel.censored)
			var/index = 0
			for(var/datum/feed_message/FM in channel.messages)
				index++
				if(FM.img)
					usr << browse_rsc(FM.img, "pda_news_tmp_photo_[feeds["channel"]]_[index].png")
				// News stories are HTML-stripped but require newline replacement to be properly displayed in NanoUI
				var/body = replacetext(FM.body, "\n", "<br>")
				messages[++messages.len] = list(
						"author" = FM.author,
						"body" = body,
						"message_type" = FM.message_type,
						"time_stamp" = FM.time_stamp,
						"has_image" = (FM.img != null),
						"caption" = FM.caption,
						"index" = index
					)

		feeds[++feeds.len] = list(
					"name" = channel.channel_name,
					"censored" = channel.censored,
					"author" = channel.author,
					"messages" = messages,
					"index" = feeds.len + 1 // actually align them, since I guess the population of the list doesn't occur until after the evaluation of the new entry's contents
					)
	return feeds

// Proc - get_recent_news()
// Parameters - none
// Description - Returns the latest three newscasts, compiled for template processing
/obj/item/device/communicator/proc/get_recent_news()
	var/list/news = list()

	// Compile all the newscasts
	for(var/datum/feed_channel/channel in news_network.network_channels)
		if(!channel.censored)
			for(var/datum/feed_message/FM in channel.messages)
				var/body = replacetext(FM.body, "\n", "<br>")
				news[++news.len] = list(
							"channel" = channel.channel_name,
							"author" = FM.author,
							"body" = body,
							"message_type" = FM.message_type,
							"time_stamp" = FM.time_stamp,
							"has_image" = (FM.img != null),
							"caption" = FM.caption,
							"time" = FM.post_time
							)

	// Cut out all but the youngest three
	if(news.len > 3)
		sortByKey(news, "time")
		news.Cut(1, news.len - 2) // Last three have largest timestamps, youngest posts
		news.Swap(1, 3) // List is sorted in ascending order of timestamp, we want descending

	return news



// Putting the commcard data harvesting helpers here
// Not ideal to put all the procs on the base type
// but it may open options for adminbus,
// And it saves duplicated code


// Medical records
/obj/item/weapon/commcard/proc/get_med_records()
	var/med_records[0]
	for(var/datum/data/record/M in sortRecord(data_core.medical))
		var/record[0]
		record[++record.len] = list("tab" = "Name", "val" = M.fields["name"])
		record[++record.len] = list("tab" = "ID", "val" = M.fields["id"])
		record[++record.len] = list("tab" = "Blood Type", "val" = M.fields["b_type"])
		record[++record.len] = list("tab" = "DNA #", "val" = M.fields["b_dna"])
		record[++record.len] = list("tab" = "Gender", "val" = M.fields["id_gender"])
		record[++record.len] = list("tab" = "Entity Classification", "val" = M.fields["brain_type"])
		record[++record.len] = list("tab" = "Minor Disorders", "val" = M.fields["mi_dis"])
		record[++record.len] = list("tab" = "Major Disorders", "val" = M.fields["ma_dis"])
		record[++record.len] = list("tab" = "Allergies", "val" = M.fields["alg"])
		record[++record.len] = list("tab" = "Condition", "val" = M.fields["cdi"])
		record[++record.len] = list("tab" = "Notes", "val" = M.fields["notes"])

		med_records[++med_records.len] = list("name" = M.fields["name"], "record" = record)
	return med_records


// Employment records
/obj/item/weapon/commcard/proc/get_emp_records()
	var/emp_records[0]
	for(var/datum/data/record/G in sortRecord(data_core.general))
		var/record[0]
		record[++record.len] = list("tab" = "Name", "val" = G.fields["name"])
		record[++record.len] = list("tab" = "ID", "val" = G.fields["id"])
		record[++record.len] = list("tab" = "Rank", "val" = G.fields["rank"])
		record[++record.len] = list("tab" = "Fingerprint", "val" = G.fields["fingerprint"])
		record[++record.len] = list("tab" = "Entity Classification", "val" = G.fields["brain_type"])
		record[++record.len] = list("tab" = "Sex", "val" = G.fields["sex"])
		record[++record.len] = list("tab" = "Species", "val" = G.fields["species"])
		record[++record.len] = list("tab" = "Age", "val" = G.fields["age"])
		record[++record.len] = list("tab" = "Notes", "val" = G.fields["notes"])

		emp_records[++emp_records.len] = list("name" = G.fields["name"], "record" = record)
	return emp_records


// Security records
/obj/item/weapon/commcard/proc/get_sec_records()
	var/sec_records[0]
	for(var/datum/data/record/G in sortRecord(data_core.general))
		var/record[0]
		record[++record.len] = list("tab" = "Name", "val" = G.fields[""])
		record[++record.len] = list("tab" = "Sex", "val" = G.fields[""])
		record[++record.len] = list("tab" = "Species", "val" = G.fields[""])
		record[++record.len] = list("tab" = "Age", "val" = G.fields[""])
		record[++record.len] = list("tab" = "Rank", "val" = G.fields[""])
		record[++record.len] = list("tab" = "Fingerprint", "val" = G.fields[""])
		record[++record.len] = list("tab" = "Physical Status", "val" = G.fields[""])
		record[++record.len] = list("tab" = "Mental Status", "val" = G.fields[""])
		record[++record.len] = list("tab" = "Criminal Status", "val" = G.fields[""])
		record[++record.len] = list("tab" = "Major Crimes", "val" = G.fields[""])
		record[++record.len] = list("tab" = "Minor Crimes", "val" = G.fields[""])
		record[++record.len] = list("tab" = "Notes", "val" = G.fields["notes"])

		sec_records[++sec_records.len] = list("name" = G.fields["name"], "record" = record)
	return sec_records


// Status of all secbots
// Weaker than what PDAs appear to do, but as of 7/1/2018 PDA secbot access is nonfunctional
/obj/item/weapon/commcard/proc/get_sec_bot_access()
	var/sec_bots[0]
	for(var/mob/living/bot/secbot/S in mob_list)
		// Get new bot
		var/status[0]
		status[++status.len] = list("tab" = "Name", "val" = sanitize(S.name))

		// If it's turned off, then it shouldn't be broadcasting any further info
		if(!S.on)
			status[++status.len] = list("tab" = "Power", "val" = "<span class='bad'>Off</span>") // Encoding the span classes here so I don't have to do complicated switches in the ui template
			continue
		status[++status.len] = list("tab" = "Power", "val" = "<span class='good'>On</span>")

		// -- What it's doing
		// If it's engaged, then say who it thinks it's engaging
		if(S.target)
			status[++status.len] = list("tab" = "Status", "val" = "<span class='bad'>Apprehending Target</span>")
			status[++status.len] = list("tab" = "Target", "val" = S.target_name(S.target))
		// Else if it's patrolling
		else if(S.will_patrol)
			status[++status.len] = list("tab" = "Status", "val" = "<span class='good'>Patrolling</span>")
		// Otherwise we don't know what it's doing
		else
			status[++status.len] = list("tab" = "Status", "val" = "<span class='average'>Idle</span>")

		// Where it is
		status[++status.len] = list("tab" = "Location", "val" = sanitize("[get_area(S.loc)]"))

		// Append bot to the list
		sec_bots[++sec_bots.len] = list("bot" = S.name, "status" = status)
	return sec_bots


// Code and frequency of stored signalers
// Supports multiple signalers within the device
/obj/item/weapon/commcard/proc/get_int_signalers()
	var/signalers[0]
	for(var/obj/item/device/assembly/signaler/S in internal_devices)
		var/unit[0]
		unit[++unit.len] = list("tab" = "Code", "val" = S.code)
		unit[++unit.len] = list("tab" = "Frequency", "val" = S.frequency)

		signalers[++signalers.len] = list("ref" = "\ref[S]", "status" = unit)

	return signalers

// Returns list of all powernet sensors currently visible to the commcard
/obj/item/weapon/commcard/proc/find_powernet_sensors()
	var/grid_sensors[0]

	// Find all the powernet sensors we need to pull data from
	// Copied from /datum/nano_module/power_monitor/proc/refresh_sensors(),
	// located in '/code/modules/nano/modules/power_monitor.dm'
	// Minor tweaks for efficiency and cleanliness
	var/turf/T = get_turf(src)
	if(T)
		var/list/levels = using_map.get_map_levels(T.z, FALSE)
		for(var/obj/machinery/power/sensor/S in machines)
			if((S.long_range) || (S.loc.z in levels) || (S.loc.z == T.z)) // Consoles have range on their Z-Level. Sensors with long_range var will work between Z levels.
				if(S.name_tag == "#UNKN#") // Default name. Shouldn't happen!
					warning("Powernet sensor with unset ID Tag! [S.x]X [S.y]Y [S.z]Z")
				else
					grid_sensors += S
	return grid_sensors

// List of powernets
/obj/item/weapon/commcard/proc/get_powernet_monitoring_list()
	// Fetch power monitor data
	var/sensors[0]

	for(var/obj/machinery/power/sensor/S in internal_data["grid_sensors"])
		var/list/focus = S.return_reading_data()

		sensors[++sensors.len] = list(
				"name" = S.name_tag,
				"alarm" = focus["alarm"]
			)

	return sensors

// Information about the targeted powernet
/obj/item/weapon/commcard/proc/get_powernet_target(var/target_sensor)
	if(!target_sensor)
		return

	var/powernet_target[0]

	for(var/obj/machinery/power/sensor/S in internal_data["grid_sensors"])
		var/list/focus = S.return_reading_data()

		// Packages the span class here so it doesn't need to be interpreted w/in the for loop in the ui template
		var/load_stat = "<span class='good'>Optimal</span>"
		if(focus["load_percentage"] >= 95)
			load_stat = "<span class='bad'>DANGER: Overload</span>"
		else if(focus["load_percentage"] >= 85)
			load_stat = "<span class='average'>WARNING: High Load</span>"

		var/alarm_stat = focus["alarm"] ? "<span class='bad'>WARNING: Abnormal activity detected!</span>" : "<span class='good'>Secure</span>"

		if(target_sensor == S.name_tag)
			powernet_target = list(
				"name" = S.name_tag,
				"alarm" = focus["alarm"],
				"error" = focus["error"],
				"apc_data" = focus["apc_data"],
				"status" = list(
						list("field" = "Network Load Status", "statval" = load_stat),
						list("field" = "Network Security Status", "statval" = alarm_stat),
						list("field" = "Load Percentage", "statval" = focus["load_percentage"]),
						list("field" = "Available Power", "statval" = focus["total_avail"]),
						list("field" = "APC Power Usage", "statval" = focus["total_used_apc"]),
						list("field" = "Other Power Usage", "statval" = focus["total_used_other"]),
						list("field" = "Total Usage", "statval" = focus["total_used_all"])
					)
			)

	return powernet_target

// Compiles the locations of all janitorial paraphernalia, as used by janitorialLocator.tmpl
/obj/item/weapon/commcard/proc/get_janitorial_locations()
	// Fetch janitorial locator
	var/janidata[0]
	var/list/cleaningList = list()
	cleaningList += all_mops + all_mopbuckets + all_janitorial_carts

	// User's location
	var/turf/userloc = get_turf(src)
	if(isturf(userloc))
		janidata[++janidata.len] = list("field" = "Current Location", "val" = "<span class='good'>[userloc.x], [userloc.y], [using_map.get_zlevel_name(userloc.z)]</span>")
	else
		janidata[++janidata.len] = list("field" = "Current Location", "val" = "<span class='bad'>Unknown</span>")
		return janidata // If the user isn't on a valid turf, then it shouldn't be able to find anything anyways

	// Mops, mop buckets, janitorial carts.
	for(var/obj/C in cleaningList)
		var/turf/T = get_turf(C)
		if(isturf(T) )//&& T.z in using_map.get_map_levels(userloc, FALSE))
			if(T.z == userloc.z)
				janidata[++janidata.len] = list("field" = apply_text_macros("\proper [C.name]"), "val" = "<span class='good'>[T.x], [T.y], [using_map.get_zlevel_name(T.z)]</span>")
			else
				janidata[++janidata.len] = list("field" = apply_text_macros("\proper [C.name]"), "val" = "<span class='average'>[T.x], [T.y], [using_map.get_zlevel_name(T.z)]</span>")

	// Cleanbots
	for(var/mob/living/bot/cleanbot/B in living_mob_list)
		var/turf/T = get_turf(B)
		if(isturf(T) )//&& T.z in using_map.get_map_levels(userloc, FALSE))
			var/textout = ""
			if(B.on)
				textout += "Status: <span class='good'>Online</span><br>"
				if(T.z == userloc.z)
					textout += "<span class='good'>[T.x], [T.y], [using_map.get_zlevel_name(T.z)]</span>"
				else
					textout += "<span class='average'>[T.x], [T.y], [using_map.get_zlevel_name(T.z)]</span>"
			else
				textout += "Status: <span class='bad'>Offline</span>"

			janidata[++janidata.len] = list("field" = "[B.name]", "val" = textout)

	return janidata

// Compiles the three lists used by GPS_access.tmpl
// The contents of the three lists are inherently related, so separating them into different procs would be largely redundant
/obj/item/weapon/commcard/proc/get_GPS_lists()
	// GPS Access
	var/intgps[0] // Gps devices within the commcard -- Allow tag edits, turning on/off, etc
	var/extgps[0] // Gps devices not inside the commcard -- Print locations if a gps is on
	var/stagps[0] // Gps net status, location, whether it's on, if it's got long range
	var/obj/item/device/gps/cumulative = new(src)
	cumulative.tracking = FALSE
	cumulative.local_mode = TRUE // Won't detect long-range signals automatically
	cumulative.long_range = FALSE
	var/list/toggled_gps = list() // List of GPS units that are turned off before display_list() is called

	for(var/obj/item/device/gps/G in internal_devices)
		var/gpsdata[0]
		if(G.tracking && !G.emped)
			cumulative.tracking = TRUE // Turn it on
			if(G.long_range)
				cumulative.long_range = TRUE // It can detect long-range
				if(!G.local_mode)
					cumulative.local_mode = FALSE // It is detecting long-range

		gpsdata["ref"] = "\ref[G]"
		gpsdata["tag"] = G.gps_tag
		gpsdata["power"] = G.tracking
		gpsdata["local_mode"] = G.local_mode
		gpsdata["long_range"] = G.long_range
		gpsdata["hide_signal"] = G.hide_signal
		gpsdata["can_hide"] = G.can_hide_signal

		intgps[++intgps.len] = gpsdata // Add it to the list

		if(G.tracking)
			G.tracking = FALSE // Disable the internal gps units so they don't show up in the report
			toggled_gps += G

	var/list/remote_gps = cumulative.display_list() // Fetch information for all units except the ones inside of this device

	for(var/obj/item/device/gps/G in toggled_gps) // Reenable any internal GPS units
		G.tracking = TRUE

	stagps["enabled"] = cumulative.tracking
	stagps["long_range_en"] = (cumulative.long_range && !cumulative.local_mode)

	stagps["my_area_name"] = remote_gps["my_area_name"]
	stagps["curr_x"] = remote_gps["curr_x"]
	stagps["curr_y"] = remote_gps["curr_y"]
	stagps["curr_z"] = remote_gps["curr_z"]
	stagps["curr_z_name"] = remote_gps["curr_z_name"]

	extgps = remote_gps["gps_list"] // Compiled by the GPS

	qdel(cumulative) // Don't want spare GPS units building up in the contents

	return list(
			intgps,
			extgps,
			stagps
		)

// Collects the current status of the supply shuttle
// Copied from /obj/machinery/computer/supplycomp/ui_interact(),
// code\game\machinery\computer\supply.dm, starting at line 55
/obj/item/weapon/commcard/proc/get_supply_shuttle_status()
	var/shuttle_status[0]
	var/datum/shuttle/autodock/ferry/supply/shuttle = SSsupply.shuttle
	if(shuttle)
		if(shuttle.has_arrive_time())
			shuttle_status["location"] = "In transit"
			shuttle_status["mode"] = SUP_SHUTTLE_TRANSIT
			shuttle_status["time"] = shuttle.eta_minutes()

		else
			shuttle_status["time"] = 0
			if(shuttle.at_station())
				if(shuttle.shuttle_docking_controller)
					switch(shuttle.shuttle_docking_controller.get_docking_status())
						if("docked")
							shuttle_status["location"] = "Docked"
							shuttle_status["mode"] = SUP_SHUTTLE_DOCKED
						if("undocked")
							shuttle_status["location"] = "Undocked"
							shuttle_status["mode"] = SUP_SHUTTLE_UNDOCKED
						if("docking")
							shuttle_status["location"] = "Docking"
							shuttle_status["mode"] = SUP_SHUTTLE_DOCKING
							shuttle_status["force"] = shuttle.can_force()
						if("undocking")
							shuttle_status["location"] = "Undocking"
							shuttle_status["mode"] = SUP_SHUTTLE_UNDOCKING
							shuttle_status["force"] = shuttle.can_force()

				else
					shuttle_status["location"] = "Station"
					shuttle_status["mode"] = SUP_SHUTTLE_DOCKED

			else
				shuttle_status["location"] = "Away"
				shuttle_status["mode"] = SUP_SHUTTLE_AWAY

			if(shuttle.can_launch())
				shuttle_status["launch"] = 1
			else if(shuttle.can_cancel())
				shuttle_status["launch"] = 2
			else
				shuttle_status["launch"] = 0

		switch(shuttle.moving_status)
			if(SHUTTLE_IDLE)
				shuttle_status["engine"] = "Idle"
			if(SHUTTLE_WARMUP)
				shuttle_status["engine"] = "Warming up"
			if(SHUTTLE_INTRANSIT)
				shuttle_status["engine"] = "Engaged"

	else
		shuttle["mode"] = SUP_SHUTTLE_ERROR

	return shuttle_status

// Compiles the list of supply orders
// Copied from /obj/machinery/computer/supplycomp/ui_interact(),
// code\game\machinery\computer\supply.dm, starting at line 130
/obj/item/weapon/commcard/proc/get_supply_orders()
	var/orders[0]
	for(var/datum/supply_order/S in SSsupply.order_history)
		orders[++orders.len] = list(
				"ref" = "\ref[S]",
				"status" = S.status,
				"entries" = list(
						list("field" = "Supply Pack", "entry" = S.name),
						list("field" = "Cost", "entry" = S.cost),
						list("field" = "Index", "entry" = S.index),
						list("field" = "Reason", "entry" = S.comment),
						list("field" = "Ordered by", "entry" = S.ordered_by),
						list("field" = "Ordered at", "entry" = S.ordered_at),
						list("field" = "Approved by", "entry" = S.approved_by),
						list("field" = "Approved at", "entry" = S.approved_at)
					)
			)

	return orders

// Compiles the list of supply export receipts
// Copied from /obj/machinery/computer/supplycomp/ui_interact(),
// code\game\machinery\computer\supply.dm, starting at line 147
/obj/item/weapon/commcard/proc/get_supply_receipts()
	var/receipts[0]
	for(var/datum/exported_crate/E in SSsupply.exported_crates)
		receipts[++receipts.len] = list(
				"ref" = "\ref[E]",
				"contents" = E.contents,
				"error" = E.contents["error"],
				"title" = list(
						list("field" = "Name", "entry" = E.name),
						list("field" = "Value", "entry" = E.value)
					)
			)
	return receipts


// Compiles the list of supply packs for the category currently stored in internal_data["supply_category"]
// Copied from /obj/machinery/computer/supplycomp/ui_interact(),
// code\game\machinery\computer\supply.dm, starting at line 147
/obj/item/weapon/commcard/proc/get_supply_pack_list()
	var/supply_packs[0]
	for(var/pack_name in SSsupply.supply_pack)
		var/datum/supply_pack/P = SSsupply.supply_pack[pack_name]
		if(P.group == internal_data["supply_category"])
			var/list/pack = list(
					"name" = P.name,
					"cost" = P.cost,
					"contraband" = P.contraband,
					"manifest" = uniquelist(P.manifest),
					"random" = P.num_contained,
					"expand" = 0,
					"ref" = "\ref[P]"
				)

			if(P in internal_data["supply_pack_expanded"])
				pack["expand"] = 1

			supply_packs[++supply_packs.len] = pack

	return supply_packs


// Compiles miscellaneous data and permissions used by the supply template
/obj/item/weapon/commcard/proc/get_misc_supply_data()
	return list(
			"shuttle_auth" = (internal_data["supply_controls"] & SUP_SEND_SHUTTLE),
			"order_auth" = (internal_data["supply_controls"] & SUP_ACCEPT_ORDERS),
			"supply_points" = SSsupply.points,
			"supply_categories" = all_supply_groups
		)

/obj/item/weapon/commcard/proc/get_status_display()
	return list(
			"line1" = internal_data["stat_display_line1"],
			"line2" = internal_data["stat_display_line2"],
			"active_line1" = internal_data["stat_display_active1"],
			"active_line2" = internal_data["stat_display_active2"],
			"active" = internal_data["stat_display_special"]
		)

/obj/item/weapon/commcard/proc/find_blast_doors()
	var/target_doors[0]
	for(var/obj/machinery/door/blast/B in machines)
		if(B.id == internal_data["shuttle_door_code"])
			target_doors += B

	return target_doors