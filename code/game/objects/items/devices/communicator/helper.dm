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
						list("entry" = "Pressure", "type" = "pressure", "val" = "[round(pressure,0.1)]", "bad_high" = 120, "poor_high" = 110, "poor_low" = 95, "bad_low" = 80),
						list("entry" = "Temperature", "type" = "temp", "val" = "[round(environment.temperature-T0C,0.1)]", "bad_high" = 35, "poor_high" = 25, "poor_low" = 15, "bad_low" = 5),
						list("entry" = "Oxygen", "type" = "pressure", "val" = "[round(o2_level*100,0.1)]", "bad_high" = 140, "poor_high" = 135, "poor_low" = 19, "bad_low" = 17),
						list("entry" = "Nitrogen", "type" = "pressure", "val" = "[round(n2_level*100,0.1)]", "bad_high" = 105, "poor_high" = 85, "poor_low" = 50, "bad_low" = 40),
						list("entry" = "Carbon Dioxide", "type" = "pressure", "val" = "[round(co2_level*100,0.1)]", "bad_high" = 10, "poor_high" = 5, "poor_low" = 0, "bad_low" = 0),
						list("entry" = "Phoron", "type" = "pressure", "val" = "[round(phoron_level*100,0.01)]", "bad_high" = 0.5, "poor_high" = 0, "poor_low" = 0, "bad_low" = 0),
						list("entry" = "Other", "type" = "pressure", "val" = "[round(unknown_level, 0.01)]", "bad_high" = 1, "poor_high" = 0.5, "poor_low" = 0, "bad_low" = 0)
						)

	if(isnull(results))
		results = list(list("entry" = "pressure", "val" = "0"))
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
					"messages" = messages
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
							)

	// Cut out all but the youngest three
	while(news.len > 3)
		var/oldest = min(news[0]["time_stamp"], news[1]["time_stamp"], news[2]["time_stamp"], news[3]["time_stamp"])
		for(var/i = 0, i < 4, i++)
			if(news[i]["time_stamp"] == oldest)
				news.Remove(news[i])

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