GLOBAL_DATUM_INIT(news_data, /datum/lore/news, new)

/datum/feed_network/New()
	CreateFeedChannel("Station Announcements", "NanoTrasen", 1, 1, "New Station Announcement Available")
	//CreateFeedChannel("Vir News Network", "Oculum Broadcast", 1, 1, "Updates from the Vir News Network!") //VOREStation Removal

/datum/lore/news
	var/datum/feed_channel/station_newspaper
	var/datum/lore/codex/category/main_news/news_codex = new()
	var/newsindex

/datum/lore/news/New()
	..()
	spawn(50) //Give it a second or it gets fucky.
		for(var/datum/feed_channel/F in news_network.network_channels)
			if(F.channel_name == "Vir News Network")
				station_newspaper = F
				break
	spawn(300) // Yes, again.
		fill_codex_news()
	if (!news_codex.newsindex)
		return
	else
		newsindex = news_codex.newsindex

/datum/lore/news/proc/fill_codex_news()
	if(!news_network)
		log_debug("Load: Could not find newscaster network.")
		return

	if(!station_newspaper)
		log_debug("Load: Could not find news channel Vir News Network to populate news articles.")
		return

	//Feed the Lore Codex into the News Machine
	for(var/datum/lore/codex/child in news_codex.children)
		news_network.SubmitArticle("[child.data]", "Oculum", "Vir News Network", null, 1, "", "[child.name]")

	return 1