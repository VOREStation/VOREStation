/datum/computer_file/program/newsbrowser
	filename = "newsbrowser"
	filedesc = "NTNet/ExoNet News Browser"
	extended_desc = "This program may be used to view and download news articles from the network."
	program_icon_state = "generic"
	program_key_state = "generic_key"
	program_menu_icon = "contact"
	size = 4
	requires_ntnet = TRUE
	available_on_ntnet = TRUE

	tgui_id = "NtosNewsBrowser"

	var/datum/computer_file/data/news_article/loaded_article
	var/download_progress = 0
	var/download_netspeed = 0
	var/downloading = FALSE
	var/message = ""
	var/show_archived = FALSE

/datum/computer_file/program/newsbrowser/process_tick()
	if(!downloading)
		return
	download_netspeed = 0
	// Speed defines are found in misc.dm
	switch(ntnet_status)
		if(1)
			download_netspeed = NTNETSPEED_LOWSIGNAL
		if(2)
			download_netspeed = NTNETSPEED_HIGHSIGNAL
		if(3)
			download_netspeed = NTNETSPEED_ETHERNET
	download_progress += download_netspeed
	if(download_progress >= loaded_article.size)
		downloading = 0
		requires_ntnet = 0 // Turn off NTNet requirement as we already loaded the file into local memory.
	SStgui.update_uis(src)

/datum/computer_file/program/newsbrowser/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = get_header_data()

	var/list/all_articles = list()
	data["message"] = message
	data["showing_archived"] = show_archived
	data["download"] = null
	data["article"] = null
	if(loaded_article && !downloading) 	// Viewing an article.
		data["article"] = list(
			"title" = loaded_article.filename,
			"cover" = loaded_article.cover,
			"content" = loaded_article.stored_data,
		)
	else if(downloading)					// Downloading an article.
		data["download"] = list(
			"download_progress" = download_progress,
			"download_maxprogress" = loaded_article.size,
			"download_rate" = download_netspeed
		)
	else										// Viewing list of articles
		for(var/datum/computer_file/data/news_article/F in ntnet_global.available_news)
			if(!show_archived && F.archived)
				continue
			all_articles.Add(list(list(
				"name" = F.filename,
				"size" = F.size,
				"uid" = F.uid,
				"archived" = F.archived
			)))
	data["all_articles"] = all_articles

	return data

/datum/computer_file/program/newsbrowser/kill_program()
	..()
	requires_ntnet = TRUE
	loaded_article = null
	download_progress = 0
	downloading = FALSE
	show_archived = FALSE

/datum/computer_file/program/newsbrowser/tgui_act(action, list/params, datum/tgui/ui)
	if(..())
		return TRUE
	switch(action)
		if("PRG_openarticle")
			. = TRUE
			if(downloading || loaded_article)
				return TRUE

			for(var/datum/computer_file/data/news_article/N in ntnet_global.available_news)
				if(N.uid == text2num(params["uid"]))
					loaded_article = N.clone()
					downloading = 1
					break
		if("PRG_reset")
			. = TRUE
			downloading = 0
			download_progress = 0
			requires_ntnet = 1
			loaded_article = null
		if("PRG_clearmessage")
			. = TRUE
			message = ""
		if("PRG_savearticle")
			. = TRUE
			if(downloading || !loaded_article)
				return

			var/savename = sanitize(tgui_input_text(usr, "Enter file name or leave blank to cancel:", "Save article", loaded_article.filename))
			if(!savename)
				return TRUE
			var/obj/item/weapon/computer_hardware/hard_drive/HDD = computer.hard_drive
			if(!HDD)
				return TRUE
			var/datum/computer_file/data/news_article/N = loaded_article.clone()
			N.filename = savename
			HDD.store_file(N)
		if("PRG_toggle_archived")
			. = TRUE
			show_archived = !show_archived

