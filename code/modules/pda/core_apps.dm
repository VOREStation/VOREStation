/datum/data/pda/app/main_menu
	icon = "home"
	template = "pda_main_menu"
	hidden = 1

/datum/data/pda/app/main_menu/update_ui(mob/user as mob, list/data)
	title = pda.name

	data["app"]["is_home"] = 1

	data["apps"] = pda.shortcut_cache
	data["categories"] = pda.shortcut_cat_order
	data["pai"] = !isnull(pda.pai)				// pAI inserted?

	var/list/notifying[0]
	for(var/P in pda.notifying_programs)
		notifying["\ref[P]"] = 1
	data["notifying"] = notifying

/datum/data/pda/app/main_menu/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE
	switch(action)
		if("UpdateInfo")
			pda.ownjob = pda.id.assignment
			pda.ownrank = pda.id.rank
			pda.name = "PDA-[pda.owner] ([pda.ownjob])"
			return TRUE
		if("pai")
			if(pda.pai)
				if(pda.pai.loc != pda)
					pda.pai = null
				else
					switch(text2num(params["option"]))
						if(1)		// Configure pAI device
							pda.pai.attack_self(usr)
						if(2)		// Eject pAI device
							var/turf/T = get_turf_or_move(pda.loc)
							if(T)
								pda.pai.loc = T
								pda.pai = null
			return TRUE

/datum/data/pda/app/notekeeper
	name = "Notekeeper"
	icon = "sticky-note-o"
	template = "pda_notekeeper"

	var/greeted = FALSE
	var/note = null
	var/notetitle = null
	var/currentnote = 1
	var/list/storedtitles = list("","","","","","","","","","","","")
	var/list/storednotes = list("","","","","","","","","","","","")
	var/notehtml = ""

/datum/data/pda/app/notekeeper/start()
	. = ..()
	if(!note && greeted == FALSE)

		// display greeting!
		greeted = TRUE
		note = "Thank you for choosing the [pda.model_name]!"
		notetitle = "Congratulations!"

/datum/data/pda/app/notekeeper/update_ui(mob/user as mob, list/data)
	data["note"] = note									// current pda notes
	data["notename"] = "Note [alphabet_uppercase[currentnote]] : [notetitle]"

/datum/data/pda/app/notekeeper/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE
	switch(action)
		if("Edit")
			var/n = tgui_input_text(usr, "Please enter message", name, notehtml, multiline = TRUE, prevent_enter = TRUE)
			if(pda.loc == usr)
				note = adminscrub(n)
				notehtml = html_decode(note)
				note = replacetext(note, "\n", "<br>")
			else
				pda.close(usr)
			return TRUE
		if("Titleset")
			var/n = tgui_input_text(usr, "Please enter title", name, notetitle, multiline = FALSE)
			if(pda.loc == usr)
				notetitle = adminscrub(n)
			else
				pda.close(usr)
			return TRUE
		if("Print")
			if(pda.loc == usr)
				printnote()
			else
				pda.close(usr)
			return TRUE
		// dumb way to do this, but i don't know how to easily parse this without a lot of silly code outside the switch!
		if("Note1")
			if(pda.loc == usr)
				changetonote(1)
			else
				pda.close(usr)
			return TRUE
		if("Note2")
			if(pda.loc == usr)
				changetonote(2)
			else
				pda.close(usr)
			return TRUE
		if("Note3")
			if(pda.loc == usr)
				changetonote(3)
			else
				pda.close(usr)
			return TRUE
		if("Note4")
			if(pda.loc == usr)
				changetonote(4)
			else
				pda.close(usr)
			return TRUE
		if("Note5")
			if(pda.loc == usr)
				changetonote(5)
			else
				pda.close(usr)
			return TRUE
		if("Note6")
			if(pda.loc == usr)
				changetonote(6)
			else
				pda.close(usr)
			return TRUE
		if("Note7")
			if(pda.loc == usr)
				changetonote(7)
			else
				pda.close(usr)
			return TRUE
		if("Note8")
			if(pda.loc == usr)
				changetonote(8)
			else
				pda.close(usr)
			return TRUE
		if("Note9")
			if(pda.loc == usr)
				changetonote(9)
			else
				pda.close(usr)
			return TRUE
		if("Note10")
			if(pda.loc == usr)
				changetonote(10)
			else
				pda.close(usr)
			return TRUE
		if("Note11")
			if(pda.loc == usr)
				changetonote(11)
			else
				pda.close(usr)
			return TRUE
		if("Note12")
			if(pda.loc == usr)
				changetonote(12)
			else
				pda.close(usr)
			return TRUE

/datum/data/pda/app/notekeeper/proc/printnote()
	// get active hand of person holding PDA, and print the page to the paper in it
	if(istype( usr, /mob/living/carbon/human ))
		var/mob/living/carbon/human/H = usr
		var/obj/item/I = H.get_active_hand()
		if(istype(I,/obj/item/weapon/paper))
			var/obj/item/weapon/paper/P = I
			if(isnull(P.info) || P.info == "" )
				var/titlenote = "Note [alphabet_uppercase[currentnote]]"
				if(!isnull(notetitle) && notetitle != "")
					titlenote = notetitle
				to_chat(usr, "<span class='notice'>Successfully printed [titlenote]!</span>")
				P.set_content( pencode2html(note), titlenote)
			else
				to_chat(usr, "<span class='notice'>You can only print to empty paper!</span>")
		else
			to_chat(usr, "<span class='notice'>You must be holding paper for the pda to print to!</span>")


/datum/data/pda/app/notekeeper/proc/changetonote(var/noteindex)
	// save note to current slot, then load another slot
	storednotes[currentnote] = note
	storedtitles[currentnote] = notetitle

	currentnote = noteindex

	note = storednotes[currentnote]
	notetitle = storedtitles[currentnote]

	// update text on keeper, silly swapping!
	note = replacetext(note, "<br>", "\n")
	notehtml = html_decode(note)
	note = replacetext(note, "\n", "<br>")

/datum/data/pda/app/manifest
	name = "Crew Manifest"
	icon = "user"
	template = "pda_manifest"

/datum/data/pda/app/manifest/update_ui(mob/user as mob, list/data)
	if(data_core)
		data_core.get_manifest_list()
	data["manifest"] = PDA_Manifest

/datum/data/pda/app/manifest/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

/datum/data/pda/app/atmos_scanner
	name = "Atmospheric Scan"
	icon = "fire"
	template = "pda_atmos_scan"
	category = "Utilities"

/datum/data/pda/app/atmos_scanner/update_ui(mob/user as mob, list/data)
	var/list/results = list()
	var/turf/T = get_turf(user)
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

			// entry is what the element is describing
			// Type identifies which unit or other special characters to use
			// Val is the information reported
			// Bad_high/_low are the values outside of which the entry reports as dangerous
			// Poor_high/_low are the values outside of which the entry reports as unideal
			// Values were extracted from the template itself
			results = list(
						list("entry" = "Pressure", "units" = "kPa", "val" = "[round(pressure,0.1)]", "bad_high" = 120, "poor_high" = 110, "poor_low" = 95, "bad_low" = 80),
						list("entry" = "Temperature", "units" = "\u00B0C", "val" = "[round(environment.temperature-T0C,0.1)]", "bad_high" = 35, "poor_high" = 25, "poor_low" = 15, "bad_low" = 5),
						list("entry" = "Oxygen", "units" = "kPa", "val" = "[round(o2_level*100,0.1)]", "bad_high" = 140, "poor_high" = 135, "poor_low" = 19, "bad_low" = 17),
						list("entry" = "Nitrogen", "units" = "kPa", "val" = "[round(n2_level*100,0.1)]", "bad_high" = 105, "poor_high" = 85, "poor_low" = 50, "bad_low" = 40),
						list("entry" = "Carbon Dioxide", "units" = "kPa", "val" = "[round(co2_level*100,0.1)]", "bad_high" = 10, "poor_high" = 5, "poor_low" = 0, "bad_low" = 0),
						list("entry" = "Phoron", "units" = "kPa", "val" = "[round(phoron_level*100,0.01)]", "bad_high" = 0.5, "poor_high" = 0, "poor_low" = 0, "bad_low" = 0),
						list("entry" = "Other", "units" = "kPa", "val" = "[round(unknown_level, 0.01)]", "bad_high" = 1, "poor_high" = 0.5, "poor_low" = 0, "bad_low" = 0)
						)

	if(isnull(results))
		results = list(list("entry" = "pressure", "units" = "kPa", "val" = "0", "bad_high" = 120, "poor_high" = 110, "poor_low" = 95, "bad_low" = 80))

	data["aircontents"] = results

/datum/data/pda/app/news
	name = "News"
	icon = "newspaper"
	template = "pda_news"

	var/newsfeed_channel

/datum/data/pda/app/news/update_ui(mob/user as mob, list/data)
	data["feeds"] = compile_news()
	data["latest_news"] = get_recent_news()
	if(newsfeed_channel)
		data["target_feed"] = data["feeds"][newsfeed_channel]
	else
		data["target_feed"] = null

/datum/data/pda/app/news/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE
	switch(action)
		if("newsfeed")
			newsfeed_channel = text2num(params["newsfeed"])

/datum/data/pda/app/news/proc/compile_news()
	var/list/feeds = list()
	for(var/datum/feed_channel/channel in news_network.network_channels)
		var/list/messages = list()
		if(!channel.censored)
			var/index = 0
			for(var/datum/feed_message/FM in channel.messages)
				index++
				var/list/msgdata = list(
					"author" = FM.author,
					"body" = FM.body,
					"img" = null,
					"message_type" = FM.message_type,
					"time_stamp" = FM.time_stamp,
					"caption" = FM.caption,
					"index" = index
				)
				if(FM.img)
					msgdata["img"] = icon2base64(FM.img)
				messages[++messages.len] = msgdata

		feeds[++feeds.len] = list(
					"name" = channel.channel_name,
					"censored" = channel.censored,
					"author" = channel.author,
					"messages" = messages,
					"index" = feeds.len + 1
					)
	return feeds

/datum/data/pda/app/news/proc/get_recent_news()
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
