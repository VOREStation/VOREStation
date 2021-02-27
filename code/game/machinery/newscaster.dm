//##############################################
//################### NEWSCASTERS BE HERE! ####
//###-Agouri###################################

/datum/feed_message
	var/author =""
	var/body =""
	var/message_type ="Story"
	var/datum/feed_channel/parent_channel
	var/is_admin_message = 0
	var/icon/img = null
	var/icon/caption = ""
	var/time_stamp = ""
	var/backup_body = ""
	var/backup_author = ""
	var/icon/backup_img = null
	var/icon/backup_caption = ""
	var/post_time = 0

/datum/feed_channel
	var/channel_name=""
	var/list/datum/feed_message/messages = list()
	var/locked=0
	var/author=""
	var/backup_author=""
	var/censored=0
	var/is_admin_channel=0
	var/updated = 0
	var/announcement = ""

/datum/feed_message/proc/clear()
	src.author = ""
	src.body = ""
	src.caption = ""
	src.img = null
	src.time_stamp = ""
	src.backup_body = ""
	src.backup_author = ""
	src.backup_caption = ""
	src.backup_img = null
	parent_channel.update()

/datum/feed_channel/proc/update()
	updated = world.time

/datum/feed_channel/proc/clear()
	src.channel_name = ""
	src.messages = list()
	src.locked = 0
	src.author = ""
	src.backup_author = ""
	src.censored = 0
	src.is_admin_channel = 0
	src.announcement = ""
	update()

/datum/feed_network
	var/list/datum/feed_channel/network_channels = list()
	var/datum/feed_message/wanted_issue

/datum/feed_network/New()
	CreateFeedChannel("Station Announcements", "SS13", 1, 1, "New Station Announcement Available")

/datum/feed_network/proc/CreateFeedChannel(var/channel_name, var/author, var/locked, var/adminChannel = 0, var/announcement_message)
	var/datum/feed_channel/newChannel = new /datum/feed_channel
	newChannel.channel_name = channel_name
	newChannel.author = author
	newChannel.locked = locked
	newChannel.is_admin_channel = adminChannel
	if(announcement_message)
		newChannel.announcement = announcement_message
	else
		newChannel.announcement = "Breaking news from [channel_name]!"
	network_channels += newChannel

/datum/feed_network/proc/SubmitArticle(var/msg, var/author, var/channel_name, var/obj/item/weapon/photo/photo, var/adminMessage = 0, var/message_type = "")
	var/datum/feed_message/newMsg = new /datum/feed_message
	newMsg.author = author
	newMsg.body = msg
	newMsg.time_stamp = "[stationtime2text()]"
	newMsg.is_admin_message = adminMessage
	newMsg.post_time = round_duration_in_ds // Should be almost universally unique
	if(message_type)
		newMsg.message_type = message_type
	if(photo)
		newMsg.img = photo.img
		newMsg.caption = photo.scribble
	for(var/datum/feed_channel/FC in network_channels)
		if(FC.channel_name == channel_name)
			insert_message_in_channel(FC, newMsg) //Adding message to the network's appropriate feed_channel
			break

/datum/feed_network/proc/insert_message_in_channel(var/datum/feed_channel/FC, var/datum/feed_message/newMsg)
	FC.messages += newMsg
	newMsg.parent_channel = FC
	FC.update()
	alert_readers(FC.announcement)

/datum/feed_network/proc/alert_readers(var/annoncement)
	for(var/obj/machinery/newscaster/NEWSCASTER in allCasters)
		NEWSCASTER.newsAlert(annoncement)
		NEWSCASTER.update_icon()

	// var/list/receiving_pdas = new
	// for (var/obj/item/device/pda/P in PDAs)
	// 	if(!P.owner)
	// 		continue
	// 	if(P.toff)
	// 		continue
	// 	receiving_pdas += P

	// spawn(0)	// get_receptions sleeps further down the line, spawn of elsewhere
	// 	var/datum/receptions/receptions = get_receptions(null, receiving_pdas) // datums are not atoms, thus we have to assume the newscast network always has reception

	// 	for(var/obj/item/device/pda/PDA in receiving_pdas)
	// 		if(!(receptions.receiver_reception[PDA] & TELECOMMS_RECEPTION_RECEIVER))
	// 			continue

	// 		PDA.new_news(annoncement)

var/datum/feed_network/news_network = new /datum/feed_network     //The global news-network, which is coincidentally a global list.

GLOBAL_LIST_BOILERPLATE(allCasters, /obj/machinery/newscaster)
/obj/machinery/newscaster
	name = "newscaster"
	desc = "A standard newsfeed handler for use on commercial space stations. All the news you absolutely have no use for, in one place!"
	icon = 'icons/obj/terminals_vr.dmi' //VOREStation Edit
	icon_state = "newscaster_normal"
	layer = ABOVE_WINDOW_LAYER
	var/isbroken = 0  //1 if someone banged it with something heavy
	var/ispowered = 1 //starts powered, changes with power_change()
	//var/list/datum/feed_channel/channel_list = list() //This list will contain the names of the feed channels. Each name will refer to a data region where the messages of the feed channels are stored.
	//OBSOLETE: We're now using a global news network
	var/paper_remaining = 0
	var/securityCaster = 0
		// 0 = Caster cannot be used to issue wanted posters
		// 1 = the opposite
	var/static/unit_no_cur = 0 //Each newscaster has a unit number
	var/unit_no
	//var/datum/feed_message/wanted //We're gonna use a feed_message to store data of the wanted person because fields are similar
	//var/wanted_issue = 0          //OBSOLETE
		// 0 = there's no WANTED issued, we don't need a special icon_state
		// 1 = Guess what.
	var/alert_delay = 500
	var/alert = 0
		// 0 = there hasn't been a news/wanted update in the last alert_delay
		// 1 = there has
	var/scanned_user = "Unknown" //Will contain the name of the person who currently uses the newscaster
	var/msg = "";                //Feed message
	var/datum/news_photo/photo_data = null
	var/channel_name = ""; //the feed channel which will be receiving the feed, or being created
	var/c_locked=0;        //Will our new channel be locked to public submissions?
	var/hitstaken = 0      //Death at 3 hits from an item with force>=15
	var/datum/feed_channel/viewing_channel = null
	light_range = 0
	anchored = 1
	var/obj/machinery/exonet_node/node = null
	circuit = /obj/item/weapon/circuitboard/newscaster
	// TGUI
	var/list/temp = null

/obj/machinery/newscaster/security_unit                   //Security unit
	name = "Security Newscaster"
	securityCaster = 1

/obj/machinery/newscaster/Initialize()
	..()
	allCasters += src
	unit_no = ++unit_no_cur
	paper_remaining = 15
	update_icon()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/newscaster/LateInitialize()
	node = get_exonet_node()

/obj/machinery/newscaster/Destroy()
	allCasters -= src
	node = null
	return ..()

/obj/machinery/newscaster/update_icon()
	if(!ispowered || isbroken)
		icon_state = "newscaster_off"
		if(isbroken) //If the thing is smashed, add crack overlay on top of the unpowered sprite.
			overlays.Cut()
			overlays += image(icon, "crack3")
		return

	overlays.Cut() //reset overlays

	if(news_network.wanted_issue) //wanted icon state, there can be no overlays on it as it's a priority message
		icon_state = "newscaster_wanted"
		return

	if(alert) //new message alert overlay
		overlays += "newscaster_alert"

	if(hitstaken > 0) //Cosmetic damage overlay
		overlays += image(icon, "crack[hitstaken]")

	icon_state = "newscaster_normal"
	return

/obj/machinery/newscaster/power_change()
	if(isbroken) //Broken shit can't be powered.
		return
	..()
	if(!(stat & NOPOWER))
		ispowered = 1
		update_icon()
	else
		spawn(rand(0, 15))
			ispowered = 0
			update_icon()

/obj/machinery/newscaster/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			isbroken=1
			if(prob(50))
				qdel(src)
			else
				update_icon() //can't place it above the return and outside the if-else. or we might get runtimes of null.update_icon() if(prob(50)) goes in.
			return
		else
			if(prob(50))
				isbroken=1
			update_icon()
			return
	return

/obj/machinery/newscaster/attack_ai(mob/user)
	return attack_hand(user)

/obj/machinery/newscaster/tgui_status(mob/user)
	if(!ispowered || isbroken)
		return STATUS_CLOSE
	. = ..()


/obj/machinery/newscaster/attack_hand(mob/user)
	if(!ispowered || isbroken)
		return

	if(!node)
		node = get_exonet_node()

	if(!node || !node.on || !node.allow_external_newscasters)
		to_chat(user, "<span class='danger'>Error: Cannot connect to external content.  Please try again in a few minutes.  If this error persists, please \
		contact the system administrator.</span>")
		return 0

	if(!user.IsAdvancedToolUser())
		return 0
	
	tgui_interact(user)

/**
  * Sets a temporary message to display to the user
  *
  * Arguments:
  * * text - Text to display, null/empty to clear the message from the UI
  * * style - The style of the message: (color name), info, success, warning, danger, virus
  */
/obj/machinery/newscaster/proc/set_temp(text = "", style = "info", update_now = FALSE)
	temp = list(text = text, style = style)
	if(update_now)
		SStgui.update_uis(src)
	
/obj/machinery/newscaster/tgui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Newscaster", "Newscaster Unit #[unit_no]")
		ui.open()

/obj/machinery/newscaster/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	// Main menu
	data["temp"] = temp

	data["user"] = tgui_user_name(user)
	data["unit_no"] = unit_no

	var/list/wanted_issue = null
	if(news_network.wanted_issue)
		wanted_issue = list(
			"author" = news_network.wanted_issue.backup_author,
			"criminal" = news_network.wanted_issue.author,
			"desc" = news_network.wanted_issue.body,
			"img" = null
		)
		if(news_network.wanted_issue.img)
			wanted_issue["img"] = icon2base64(news_network.wanted_issue.img)

	data["wanted_issue"] = wanted_issue

	data["securityCaster"] = !!securityCaster
	
	var/list/network_channels = list()
	for(var/datum/feed_channel/FC in news_network.network_channels)
		network_channels.Add(list(list(
			"admin" = FC.is_admin_channel,
			"ref" = REF(FC),
			"name" = FC.channel_name,
			"censored" = FC.censored,
		)))
	data["channels"] = network_channels

	// Creating Channels
	data["channel_name"] = channel_name
	data["c_locked"] = c_locked

	// Creating Messages
	// data["channel_name"] = channel_name
	data["msg"] = msg
	data["photo_data"] = !!photo_data

	// Printing menu
	var/total_num = LAZYLEN(news_network.network_channels)
	var/active_num = total_num
	var/message_num = 0
	for(var/datum/feed_channel/FC in news_network.network_channels)
		if(!FC.censored)
			message_num += length(FC.messages)    //Dont forget, datum/feed_channel's var messages is a list of datum/feed_message
		else
			active_num--
	data["total_num"] = total_num
	data["active_num"] = active_num
	data["message_num"] = message_num
	data["paper_remaining"] = paper_remaining

	// Viewing a specific channel
	var/list/viewing = null
	if(viewing_channel)
		var/list/messages = list()
		viewing = list(
			"name" = viewing_channel.channel_name,
			"author" = viewing_channel.author,
			"censored" = viewing_channel.censored,
			"messages" = messages,
			"ref" = REF(viewing_channel),
		)
		if(!viewing_channel.censored)
			for(var/datum/feed_message/M in viewing_channel.messages)
				var/list/msgdata = list(
					"body" = M.body,
					"img" = null,
					"type" = M.message_type,
					"caption" = null,
					"author" = M.author,
					"timestamp" = M.time_stamp,
					"ref" = REF(M),
				)
				if(M.img)
					msgdata["img"] = icon2base64(M.img)
					msgdata["caption"] = M.caption

				messages.Add(list(msgdata))
	data["viewing_channel"] = viewing

	// Censorship
	data["company"] = using_map.company_name

	return data

/obj/machinery/newscaster/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	switch(action)
		if("cleartemp")
			temp = null
			return TRUE

		if("set_channel_name")
			channel_name = sanitizeSafe(params["val"], MAX_LNAME_LEN)
			return TRUE

		if("set_channel_lock")
			c_locked = !c_locked
			return TRUE

		if("submit_new_channel")
			//var/list/existing_channels = list() //OBSOLETE
			var/list/existing_authors = list()
			for(var/datum/feed_channel/FC in news_network.network_channels)
				//existing_channels += FC.channel_name
				if(FC.author == "\[REDACTED\]")
					existing_authors += FC.backup_author
				else
					existing_authors  +=FC.author
			var/check = 0
			for(var/datum/feed_channel/FC in news_network.network_channels)
				if(FC.channel_name == channel_name)
					check = 1
					break
			var/our_user = tgui_user_name(usr)
			if(channel_name == "" || channel_name == "\[REDACTED\]")
				set_temp("Error: Could not submit feed channel to network: Invalid Channel Name.", "danger", FALSE)
				return TRUE
			if(our_user == "Unknown")
				set_temp("Error: Could not submit feed channel to network: Channel author unverified.", "danger", FALSE)
				return TRUE
			if(check)
				set_temp("Error: Could not submit feed channel to network: Channel name already in use.", "danger", FALSE)
				return TRUE
			if(our_user in existing_authors)
				set_temp("Error: Could not submit feed channel to network: A feed channel already exists under your name.", "danger", FALSE)
				return TRUE

			var/choice = alert("Please confirm Feed channel creation","Network Channel Handler","Confirm","Cancel")
			if(choice == "Confirm")
				news_network.CreateFeedChannel(channel_name, our_user, c_locked)
				set_temp("Feed channel [channel_name] created successfully.", "success", FALSE)
			return TRUE

		if("set_channel_receiving")
			//var/list/datum/feed_channel/available_channels = list()
			var/list/available_channels = list()
			for(var/datum/feed_channel/F in news_network.network_channels)
				if((!F.locked || F.author == scanned_user) && !F.censored)
					available_channels += F.channel_name
			var/new_channel_name = input(usr, "Choose receiving Feed Channel", "Network Channel Handler") as null|anything in available_channels
			if(new_channel_name)
				channel_name = new_channel_name
			return TRUE

		if("set_new_message")
			msg = sanitize(input(usr, "Write your Feed story", "Network Channel Handler", "") as message|null)
			return TRUE

		if("set_attachment")
			AttachPhoto(usr)
			return TRUE

		if("submit_new_message")
			var/our_user = tgui_user_name(usr)
			if(msg == "" || msg == "\[REDACTED\]")
				set_temp("Error: Could not submit feed message to network: Invalid Message.", "danger", FALSE)
				return TRUE
			if(our_user == "Unknown")
				set_temp("Error: Could not submit feed message to network: Channel author unverified.", "danger", FALSE)
				return TRUE
			if(channel_name == "")
				set_temp("Error: Could not submit feed message to network: No feed channel selected.", "danger", FALSE)
				return TRUE

			var/image = photo_data ? photo_data.photo : null
			feedback_inc("newscaster_stories",1)
			news_network.SubmitArticle(msg, our_user, channel_name, image, 0)
			set_temp("Feed message created successfully.", "success", FALSE)
			return TRUE

		if("print_paper")
			if(!paper_remaining)
				set_temp("Unable to print newspaper. Insufficient paper. Please notify maintenance personnel to refill machine storage.", "danger", FALSE)
				return TRUE
			
			print_paper()
			set_temp("Printing successful. Please receive your newspaper from the bottom of the machine.", "success", FALSE)
			return TRUE

		if("set_wanted_desc")
			msg = sanitize(params["val"])
			return TRUE

		if("submit_wanted")
			if(!securityCaster)
				return FALSE
			var/our_user = tgui_user_name(usr)
			if(channel_name == "")
				set_temp("Error: Could not submit wanted issue to network: Invalid Criminal Name.", "danger", FALSE)
				return TRUE
			if(msg == "")
				set_temp("Error: Could not submit wanted issue to network: Invalid Description.", "danger", FALSE)
				return TRUE
			if(our_user == "Unknown")
				set_temp("Error: Could not submit wanted issue to network: Author unverified.", "danger", FALSE)
				return TRUE

			var/choice = alert("Please confirm Wanted Issue change.", "Network Security Handler", "Confirm", "Cancel")
			if(choice == "Confirm")
				if(news_network.wanted_issue)
					if(news_network.wanted_issue.is_admin_message)
						alert("The wanted issue has been distributed by a [using_map.company_name] higherup. You cannot edit it.", "Ok")
						return
					news_network.wanted_issue.author = channel_name
					news_network.wanted_issue.body = msg
					news_network.wanted_issue.backup_author = scanned_user
					if(photo_data)
						news_network.wanted_issue.img = photo_data.photo.img
					set_temp("Wanted issue for [channel_name] successfully edited.", "success", FALSE)
					return TRUE

				var/datum/feed_message/WANTED = new /datum/feed_message
				WANTED.author = channel_name
				WANTED.body = msg
				WANTED.backup_author = scanned_user //I know, a bit wacky
				if(photo_data)
					WANTED.img = photo_data.photo.img
				news_network.wanted_issue = WANTED
				news_network.alert_readers()
				set_temp("Wanted issue for [channel_name] is now in Network Circulation.", "success", FALSE)
				return TRUE

		if("cancel_wanted")
			if(!securityCaster)
				return FALSE
			if(news_network.wanted_issue.is_admin_message)
				alert("The wanted issue has been distributed by a [using_map.company_name] higherup. You cannot take it down.","Ok")
				return
			var/choice = alert("Please confirm Wanted Issue removal","Network Security Handler","Confirm","Cancel")
			if(choice=="Confirm")
				news_network.wanted_issue = null
				for(var/obj/machinery/newscaster/NEWSCASTER in allCasters)
					NEWSCASTER.update_icon()
				set_temp("Wanted issue taken down.", "success", FALSE)
			return TRUE

		if("censor_channel_author")
			if(!securityCaster)
				return FALSE
			var/datum/feed_channel/FC = locate(params["ref"])
			if(FC.is_admin_channel)
				alert("This channel was created by a [using_map.company_name] Officer. You cannot censor it.","Ok")
				return
			if(FC.author != "\[REDACTED\]")
				FC.backup_author = FC.author
				FC.author = "\[REDACTED\]"
			else
				FC.author = FC.backup_author
			FC.update()
			return TRUE

		if("censor_channel_story_author")
			if(!securityCaster)
				return FALSE
			var/datum/feed_message/MSG = locate(params["ref"])
			if(MSG.is_admin_message)
				alert("This message was created by a [using_map.company_name] Officer. You cannot censor its author.","Ok")
				return
			if(MSG.author != "\[REDACTED\]")
				MSG.backup_author = MSG.author
				MSG.author = "\[REDACTED\]"
			else
				MSG.author = MSG.backup_author
			MSG.parent_channel.update()
			return TRUE

		if("censor_channel_story_body")
			if(!securityCaster)
				return FALSE
			var/datum/feed_message/MSG = locate(params["ref"])
			if(MSG.is_admin_message)
				alert("This channel was created by a [using_map.company_name] Officer. You cannot censor it.","Ok")
				return
			if(MSG.body != "\[REDACTED\]")
				MSG.backup_body = MSG.body
				MSG.backup_caption = MSG.caption
				MSG.backup_img = MSG.img
				MSG.body = "\[REDACTED\]"
				MSG.caption = "\[REDACTED\]"
				MSG.img = null
			else
				MSG.body = MSG.backup_body
				MSG.caption = MSG.caption
				MSG.img = MSG.backup_img

			MSG.parent_channel.update()
			return TRUE

		if("toggle_d_notice")
			if(!securityCaster)
				return FALSE
			var/datum/feed_channel/FC = locate(params["ref"])
			if(FC.is_admin_channel)
				alert("This channel was created by a [using_map.company_name] Officer. You cannot place a D-Notice upon it.","Ok")
				return
			FC.censored = !FC.censored
			FC.update()
			return TRUE

		if("show_channel")
			var/datum/feed_channel/FC = locate(params["show_channel"])
			viewing_channel = FC
			return TRUE

/obj/machinery/newscaster/attackby(I as obj, user)
	if(computer_deconstruction_screwdriver(user, I))
		return
	else
		attack_hand(user)
	return

/obj/machinery/newscaster/attack_ai(mob/user)
	return attack_hand(user) //or maybe it'll have some special functions? No idea.

/datum/news_photo
	var/is_synth = 0
	var/obj/item/weapon/photo/photo = null

/datum/news_photo/New(var/obj/item/weapon/photo/p, var/synth)
	is_synth = synth
	photo = p

/obj/machinery/newscaster/proc/AttachPhoto(mob/user)
	if(photo_data)
		if(!photo_data.is_synth)
			photo_data.photo.loc = src.loc
			if(!issilicon(user))
				user.put_in_inactive_hand(photo_data.photo)
		qdel(photo_data)

	if(istype(user.get_active_hand(), /obj/item/weapon/photo))
		var/obj/item/photo = user.get_active_hand()
		user.drop_item()
		photo.loc = src
		photo_data = new(photo, 0)
	else if(istype(user,/mob/living/silicon))
		var/mob/living/silicon/tempAI = user
		var/obj/item/weapon/photo/selection = tempAI.GetPicture()
		if(!selection)
			return

		photo_data = new(selection, 1)

//########################################################################################################################
//###################################### NEWSPAPER! ######################################################################
//########################################################################################################################

/obj/item/weapon/newspaper
	name = "newspaper"
	desc = "An issue of The Griffon, the newspaper circulating aboard most stations."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "newspaper"
	w_class = ITEMSIZE_SMALL	//Let's make it fit in trashbags!
	attack_verb = list("bapped")
	var/screen = 0
	var/pages = 0
	var/curr_page = 0
	var/list/datum/feed_channel/news_content = list()
	var/datum/feed_message/important_message = null
	var/scribble=""
	var/scribble_page = null
	drop_sound = 'sound/items/drop/wrapper.ogg'
	pickup_sound = 'sound/items/pickup/wrapper.ogg'

obj/item/weapon/newspaper/attack_self(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/human_user = user
		var/dat
		pages = 0
		switch(screen)
			if(0) //Cover
				dat+="<DIV ALIGN='center'><B><FONT SIZE=6>The Griffon</FONT></B></div>"
				dat+="<DIV ALIGN='center'><FONT SIZE=2>[using_map.company_name]-standard newspaper, for use on [using_map.company_name]© Space Facilities</FONT></div><HR>"
				if(isemptylist(news_content))
					if(important_message)
						dat+="Contents:<BR><ul><B><FONT COLOR='red'>**</FONT>Important Security Announcement<FONT COLOR='red'>**</FONT></B> <FONT SIZE=2>\[page [pages+2]\]</FONT><BR></ul>"
					else
						dat+="<I>Other than the title, the rest of the newspaper is unprinted...</I>"
				else
					dat+="Contents:<BR><ul>"
					for(var/datum/feed_channel/NP in news_content)
						pages++
					if(important_message)
						dat+="<B><FONT COLOR='red'>**</FONT>Important Security Announcement<FONT COLOR='red'>**</FONT></B> <FONT SIZE=2>\[page [pages+2]\]</FONT><BR>"
					var/temp_page=0
					for(var/datum/feed_channel/NP in news_content)
						temp_page++
						dat+="<B>[NP.channel_name]</B> <FONT SIZE=2>\[page [temp_page+1]\]</FONT><BR>"
					dat+="</ul>"
				if(scribble_page==curr_page)
					dat+="<BR><I>There is a small scribble near the end of this page... It reads: \"[scribble]\"</I>"
				dat+= "<HR><DIV STYLE='float:right;'><A href='?src=\ref[src];next_page=1'>Next Page</A></DIV> <div style='float:left;'><A href='?src=\ref[human_user];mach_close=newspaper_main'>Done reading</A></DIV>"
			if(1) // X channel pages inbetween.
				for(var/datum/feed_channel/NP in news_content)
					pages++ //Let's get it right again.
				var/datum/feed_channel/C = news_content[curr_page]
				dat+="<FONT SIZE=4><B>[C.channel_name]</B></FONT><FONT SIZE=1> \[created by: <FONT COLOR='maroon'>[C.author]</FONT>\]</FONT><BR><BR>"
				if(C.censored)
					dat+="This channel was deemed dangerous to the general welfare of the station and therefore marked with a <B><FONT COLOR='red'>D-Notice</B></FONT>. Its contents were not transferred to the newspaper at the time of printing."
				else
					if(isemptylist(C.messages))
						dat+="No Feed stories stem from this channel..."
					else
						dat+="<ul>"
						var/i = 0
						for(var/datum/feed_message/MESSAGE in C.messages)
							i++
							dat+="-[MESSAGE.body] <BR>"
							if(MESSAGE.img)
								user << browse_rsc(MESSAGE.img, "tmp_photo[i].png")
								dat+="<img src='tmp_photo[i].png' width = '180'><BR>"
							dat+="<FONT SIZE=1>\[[MESSAGE.message_type] by <FONT COLOR='maroon'>[MESSAGE.author]</FONT>\]</FONT><BR><BR>"
						dat+="</ul>"
				if(scribble_page==curr_page)
					dat+="<BR><I>There is a small scribble near the end of this page... It reads: \"[scribble]\"</I>"
				dat+= "<BR><HR><DIV STYLE='float:left;'><A href='?src=\ref[src];prev_page=1'>Previous Page</A></DIV> <DIV STYLE='float:right;'><A href='?src=\ref[src];next_page=1'>Next Page</A></DIV>"
			if(2) //Last page
				for(var/datum/feed_channel/NP in news_content)
					pages++
				if(important_message!=null)
					dat+="<DIV STYLE='float:center;'><FONT SIZE=4><B>Wanted Issue:</B></FONT></DIV><BR><BR>"
					dat+="<B>Criminal name</B>: <FONT COLOR='maroon'>[important_message.author]</FONT><BR>"
					dat+="<B>Description</B>: [important_message.body]<BR>"
					dat+="<B>Photo:</B>: "
					if(important_message.img)
						user << browse_rsc(important_message.img, "tmp_photow.png")
						dat+="<BR><img src='tmp_photow.png' width = '180'>"
					else
						dat+="None"
				else
					dat+="<I>Apart from some uninteresting Classified ads, there's nothing on this page...</I>"
				if(scribble_page==curr_page)
					dat+="<BR><I>There is a small scribble near the end of this page... It reads: \"[scribble]\"</I>"
				dat+= "<HR><DIV STYLE='float:left;'><A href='?src=\ref[src];prev_page=1'>Previous Page</A></DIV>"
			else
				dat+="I'm sorry to break your immersion. This shit's bugged. Report this bug to Agouri, polyxenitopalidou@gmail.com"

		dat+="<BR><HR><div align='center'>[curr_page+1]</div>"
		human_user << browse(dat, "window=newspaper_main;size=300x400")
		onclose(human_user, "newspaper_main")
	else
		to_chat(user, "The paper is full of intelligible symbols!")

obj/item/weapon/newspaper/Topic(href, href_list)
	var/mob/living/U = usr
	..()
	if((src in U.contents) || (istype(loc, /turf) && in_range(src, U)))
		U.set_machine(src)
		if(href_list["next_page"])
			if(curr_page == pages+1)
				return //Don't need that at all, but anyway.
			if(curr_page == pages) //We're at the middle, get to the end
				screen = 2
			else
				if(curr_page == 0) //We're at the start, get to the middle
					screen = 1
			curr_page++
			playsound(src, "pageturn", 50, 1)

		else if(href_list["prev_page"])
			if(curr_page == 0)
				return
			if(curr_page == 1)
				screen = 0

			else
				if(curr_page == pages+1) //we're at the end, let's go back to the middle.
					screen = 1
			curr_page--
			playsound(src, "pageturn", 50, 1)

		if(istype(src.loc, /mob))
			attack_self(src.loc)

obj/item/weapon/newspaper/attackby(obj/item/weapon/W as obj, mob/user)
	if(istype(W, /obj/item/weapon/pen))
		if(scribble_page == curr_page)
			to_chat(user, "<FONT COLOR='blue'>There's already a scribble in this page... You wouldn't want to make things too cluttered, would you?</FONT>")
		else
			var/s = sanitize(input(user, "Write something", "Newspaper", ""))
			s = sanitize(s)
			if(!s)
				return
			if(!in_range(src, usr) && src.loc != usr)
				return
			scribble_page = curr_page
			scribble = s
			attack_self(user)
		return

////////////////////////////////////helper procs
/obj/machinery/newscaster/proc/tgui_user_name(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/weapon/card/id/I = H.GetIdCard()
		if(I)
			return GetNameAndAssignmentFromId(I)

	if(issilicon(user))
		var/mob/living/silicon/S = user
		return "[S.name] ([S.job])"

	return "Unknown"

/obj/machinery/newscaster/proc/scan_user(mob/living/user)
	if(istype(user,/mob/living/carbon/human))                       //User is a human
		var/mob/living/carbon/human/human_user = user
		var/obj/item/weapon/card/id/I = human_user.GetIdCard()
		if(I)
			scanned_user = GetNameAndAssignmentFromId(I)
		else
			scanned_user = "Unknown"
	else
		var/mob/living/silicon/ai_user = user
		scanned_user = "[ai_user.name] ([ai_user.job])"

/obj/machinery/newscaster/proc/print_paper()
	feedback_inc("newscaster_newspapers_printed",1)
	var/obj/item/weapon/newspaper/NEWSPAPER = new /obj/item/weapon/newspaper
	for(var/datum/feed_channel/FC in news_network.network_channels)
		NEWSPAPER.news_content += FC
	if(news_network.wanted_issue)
		NEWSPAPER.important_message = news_network.wanted_issue
	NEWSPAPER.loc = get_turf(src)
	paper_remaining--
	return

/obj/machinery/newscaster/proc/newsAlert(var/news_call)
	if(!node || !node.on || !node.allow_external_newscasters) //The messages will still be there once the connection returns.
		return
	var/turf/T = get_turf(src)
	if(news_call)
		for(var/mob/O in hearers(world.view-1, T))
			O.show_message("<span class='newscaster'><EM>[name]</EM> beeps, \"[news_call]\"</span>",2)
		alert = 1
		update_icon()
		spawn(300)
			alert = 0
			update_icon()
		playsound(src, 'sound/machines/twobeep.ogg', 75, 1)
	else
		for(var/mob/O in hearers(world.view-1, T))
			O.show_message("<span class='newscaster'><EM>[name]</EM> beeps, \"Attention! Wanted issue distributed!\"</span>",2)
		playsound(src, 'sound/machines/warning-buzzer.ogg', 75, 1)
	return
