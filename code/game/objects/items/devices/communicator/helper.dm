/obj/item/communicator/proc/analyze_air()
	return get_gas_mixture_default_scan_data(get_turf(src.loc))

// Proc - compile_news()
// Parameters - none
// Description - Returns the list of newsfeeds, compiled for template processing
/obj/item/communicator/proc/compile_news()
	var/list/feeds = list()
	for(var/datum/feed_channel/channel in news_network.network_channels)
		var/list/messages = list()
		if(!channel.censored && channel.channel_name != "Vir News Network") //Do not load the 'IC news' channel as it is simply too long.
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
					"index" = feeds.len + 1 // actually align them, since I guess the population of the list doesn't occur until after the evaluation of the new entry's contents
					)
	return feeds

// Proc - get_recent_news()
// Parameters - none
// Description - Returns the latest three newscasts, compiled for template processing
/obj/item/communicator/proc/get_recent_news()
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
