/mob/new_player
	var/current_news_page

/mob/new_player/Topic(href, href_list[])
	. = ..()

	if(href_list["open_station_news"])
		show_latest_news(GLOB.news_data.station_newspaper)

	if(href_list["next_news"])
		var/datum/feed_channel/next_page = locate(href_list["nextpage"])
		if(!next_page)
			return
		if(!current_news_page)
			return
		if(!next_page.messages)
			return

		if(current_news_page == next_page.messages.len)
			return
		else
			current_news_page++
			playsound(src.loc, "pageturn", 50, 1)
			show_latest_news(GLOB.news_data.station_newspaper)


	if(href_list["previous_news"])
		var/datum/feed_channel/prev_page = locate(href_list["prevpage"])
		if(!prev_page)
			return
		if(!current_news_page)
			return
		if(!prev_page.messages)
			return
		if(1 >= current_news_page)
			return
		else
			current_news_page--
			playsound(src.loc, "pageturn", 50, 1)
			show_latest_news(GLOB.news_data.station_newspaper)


/mob/new_player/proc/show_latest_news(var/datum/feed_channel/CHANNEL)
	if(!GLOB.news_data) return
	if(!GLOB.news_data.station_newspaper) return

	var/dat

	if(!current_news_page)
		if(CHANNEL.messages)
			current_news_page = 1 //Start at the 'front' because of how the codex works.

	if(!current_news_page || isemptylist(CHANNEL.messages))
		dat += "No current available news on [GLOB.news_data.station_newspaper.channel_name], it may still be loading!"
	else
		dat += get_news_page(CHANNEL, CHANNEL.messages[current_news_page], current_news_page)
		if(CHANNEL.messages.len > current_news_page)
			dat += "<a href='?src=\ref[src];next_news=1;nextpage=\ref[CHANNEL]'>Older Issue</a>"
		if(current_news_page > CHANNEL.messages.len || (CHANNEL.messages.len > 1) && !(current_news_page == 1))
			dat += "<a href='?src=\ref[src];previous_news=1;prevpage=\ref[CHANNEL]'>Newer Issue</a>  "

		dat += "  (Page <b>[current_news_page]</b> out of <b>[CHANNEL.messages.len]</b>)"

	var/datum/browser/popup = new(usr, "News", "Latest News", 640, 600, src)
	popup.set_content(jointext(dat,null))
	popup.open()

	client.seen_news = 1

/proc/get_news_page(var/datum/feed_channel/CHANNEL, var/datum/feed_message/MESSAGE, current_page)
	var/dat

	dat += get_newspaper_header(CHANNEL.channel_name, "Aggregated News", "#d4cec1")

	if(isemptylist(CHANNEL.messages))
		dat += "<I>No current articles for this newspaper.</I><BR>"
	else
		var/pic_data

		if(MESSAGE.img)
			usr << browse_rsc(MESSAGE.img, "tmp_photo[current_page].png")
			pic_data+="<img src='tmp_photo[current_page].png' width = '180'><BR>"

		dat += get_newspaper_content(MESSAGE.title, MESSAGE.body, MESSAGE.author, "#d4cec1", pic_data)

	return dat