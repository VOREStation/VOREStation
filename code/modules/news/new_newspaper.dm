//Version of the newspaper that uses the lobby-style news reports from one channel only. Currently unused.

/obj/item/weapon/newspaper
	name = "newspaper"
	desc = "This seems to be a generic, worn up newspaper."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "newspaper"
	w_class = ITEMSIZE_SMALL	//Let's make it fit in trashbags!
	attack_verb = list("bapped")

	var/datum/feed_channel/news_source
	var/current_news_page

	pickup_sound = 'sound/items/pickup/wrapper.ogg'
	drop_sound = 'sound/items/drop/paper.ogg'

/obj/item/weapon/newspaper/Initialize()
	. = ..()
	if(!news_source && GLOB.news_data)
		news_source = GLOB.news_data.station_newspaper

	if(news_source)
		name = "[news_source.channel_name] [name]"
		desc = "This is a newspaper that contains the articles of the [news_source.channel_name]."


/obj/item/weapon/newspaper/attack_self(mob/user)
	var/dat

	if(!current_news_page)
		if(news_source.messages)
			current_news_page = news_source.messages.len

	if(!current_news_page || !news_source.messages)
		dat += "No current available news on [news_source.channel_name]"
	else
		dat += get_news_page(news_source, news_source.messages[current_news_page], current_news_page)
		if(current_news_page > news_source.messages.len || (news_source.messages.len > 1) && !(current_news_page == 1))
			dat += "<a href='?src=\ref[src];previous_news=1;prevpage=\ref[news_source]'>Previous Issue</a>  "
		if(news_source.messages.len > current_news_page)
			dat += "<a href='?src=\ref[src];next_news=1;nextpage=\ref[news_source]'>Next Issue</a>"

		dat += "  (Page <b>[current_news_page]</b> out of <b>[news_source.messages.len]</b>)"

	var/datum/browser/popup = new(usr, "News", "Latest News", 640, 600, src)
	popup.set_content(jointext(dat,null))
	popup.open()


/obj/item/weapon/newspaper/Topic(href, href_list[])
	..()

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
			updateDialog()
			attack_self(loc)


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
			updateDialog()
			attack_self(loc)