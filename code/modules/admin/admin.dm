var/global/floorIsLava = 0


////////////////////////////////
/proc/message_admins(var/msg)
	msg = "<span class='filter_adminlog log_message'><span class='prefix'>ADMIN LOG:</span> <span class=\"message\">[msg]</span></span>"
	//log_adminwarn(msg) //log_and_message_admins is for this

	for(var/client/C in GLOB.admins)
		if((R_ADMIN|R_MOD) & C.holder.rights)
			to_chat(C,
					type = MESSAGE_TYPE_ADMINLOG,
					html = msg,
					confidential = TRUE)

/proc/msg_admin_attack(var/text) //Toggleable Attack Messages
	var/rendered = "<span class='filter_attacklog log_message'><span class='prefix'>ATTACK:</span> <span class=\"message\">[text]</span></span>"
	for(var/client/C in GLOB.admins)
		if((R_ADMIN|R_MOD) & C.holder.rights)
			if(C.is_preference_enabled(/datum/client_preference/mod/show_attack_logs))
				var/msg = rendered
				to_chat(C,
						type = MESSAGE_TYPE_ATTACKLOG,
						html = msg,
						confidential = TRUE)

/proc/admin_notice(var/message, var/rights)
	for(var/mob/M in mob_list)
		if(check_rights(rights, 0, M))
			to_chat(M,message)

///////////////////////////////////////////////////////////////////////////////////////////////Panels

/datum/admins/proc/show_player_panel(var/mob/M in mob_list)
	set category = "Admin"
	set name = "Show Player Panel"
	set desc="Edit player (respawn, ban, heal, etc)"

	if(!M)
		to_chat(usr, "You seem to be selecting a mob that doesn't exist anymore.")
		return
	if (!istype(src,/datum/admins))
		src = usr.client.holder
	if (!istype(src,/datum/admins))
		to_chat(usr, "Error: you are not an admin!")
		return

	var/body = "<html><head><title>Options for [M.key]</title></head>"
	body += "<body>Options panel for <b>[M]</b>"
	if(M.client)
		body += " played by <b>[M.client]</b> "
		body += "\[<A href='?src=\ref[src];[HrefToken()];editrights=show'>[M.client.holder ? M.client.holder.rank : "Player"]</A>\]"

	if(istype(M, /mob/new_player))
		body += " <B>Hasn't Entered Game</B> "
	else
		body += " \[<A href='?src=\ref[src];[HrefToken()];revive=\ref[M]'>Heal</A>\] "

	if(M.client)
		body += "<br><b>First connection:</b> [M.client.player_age] days ago"
		body += "<br><b>BYOND account created:</b> [M.client.account_join_date]"
		body += "<br><b>BYOND account age (days):</b> [M.client.account_age]"

	body += {"
		<br><br>\[
		<a href='?_src_=vars;[HrefToken()];Vars=\ref[M]'>VV</a> -
		<a href='?src=\ref[src];[HrefToken()];traitor=\ref[M]'>TP</a> -
		<a href='?src=\ref[usr];[HrefToken()];priv_msg=\ref[M]'>PM</a> -
		<a href='?src=\ref[src];[HrefToken()];subtlemessage=\ref[M]'>SM</a> -
		[admin_jump_link(M, src)]\] <br>
		<b>Mob type:</b> [M.type]<br>
		<b>Inactivity time:</b> [M.client ? "[M.client.inactivity/600] minutes" : "Logged out"]<br/><br/>
		<A href='?src=\ref[src];[HrefToken()];boot2=\ref[M]'>Kick</A> |
		<A href='?_src_=holder;[HrefToken()];warn=[M.ckey]'>Warn</A> |
		<A href='?src=\ref[src];[HrefToken()];newban=\ref[M]'>Ban</A> |
		<A href='?src=\ref[src];[HrefToken()];jobban2=\ref[M]'>Jobban</A> |
		<A href='?src=\ref[src];[HrefToken()];notes=show;mob=\ref[M]'>Notes</A>
	"}

	if(M.client)
		body += "| <A HREF='?src=\ref[src];[HrefToken()];sendtoprison=\ref[M]'>Prison</A> | "
		body += "\ <A HREF='?src=\ref[src];[HrefToken()];sendbacktolobby=\ref[M]'>Send back to Lobby</A> | "
		var/muted = M.client.prefs.muted
		body += {"<br><b>Mute: </b>
			\[<A href='?src=\ref[src];[HrefToken()];mute=\ref[M];mute_type=[MUTE_IC]'><font color='[(muted & MUTE_IC)?"red":"blue"]'>IC</font></a> |
			<A href='?src=\ref[src];[HrefToken()];mute=\ref[M];mute_type=[MUTE_OOC]'><font color='[(muted & MUTE_OOC)?"red":"blue"]'>OOC</font></a> |
			<A href='?src=\ref[src];[HrefToken()];mute=\ref[M];mute_type=[MUTE_LOOC]'><font color='[(muted & MUTE_LOOC)?"red":"blue"]'>LOOC</font></a> |
			<A href='?src=\ref[src];[HrefToken()];mute=\ref[M];mute_type=[MUTE_PRAY]'><font color='[(muted & MUTE_PRAY)?"red":"blue"]'>PRAY</font></a> |
			<A href='?src=\ref[src];[HrefToken()];mute=\ref[M];mute_type=[MUTE_ADMINHELP]'><font color='[(muted & MUTE_ADMINHELP)?"red":"blue"]'>ADMINHELP</font></a> |
			<A href='?src=\ref[src];[HrefToken()];mute=\ref[M];mute_type=[MUTE_DEADCHAT]'><font color='[(muted & MUTE_DEADCHAT)?"red":"blue"]'>DEADCHAT</font></a>\]
			(<A href='?src=\ref[src];[HrefToken()];mute=\ref[M];mute_type=[MUTE_ALL]'><font color='[(muted & MUTE_ALL)?"red":"blue"]'>toggle all</font></a>)
		"}

	body += {"<br><br>
		<A href='?src=\ref[src];[HrefToken()];jumpto=\ref[M]'><b>Jump to</b></A> |
		<A href='?src=\ref[src];[HrefToken()];getmob=\ref[M]'>Get</A> |
		<A href='?src=\ref[src];[HrefToken()];sendmob=\ref[M]'>Send To</A>
		<br><br>
		[check_rights(R_ADMIN|R_MOD|R_EVENT,0) ? "<A href='?src=\ref[src];[HrefToken()];traitor=\ref[M]'>Traitor panel</A> | " : "" ]
		<A href='?src=\ref[src];[HrefToken()];narrateto=\ref[M]'>Narrate to</A> |
		<A href='?src=\ref[src];[HrefToken()];subtlemessage=\ref[M]'>Subtle message</A>
	"}

	if (M.client)
		if(!istype(M, /mob/new_player))
			body += "<br><br>"
			body += "<b>Transformation:</b>"
			body += "<br>"

			//Monkey
			if(issmall(M))
				body += "<B>Monkeyized</B> | "
			else
				body += "<A href='?src=\ref[src];[HrefToken()];monkeyone=\ref[M]'>Monkeyize</A> | "

			//Corgi
			if(iscorgi(M))
				body += "<B>Corgized</B> | "
			else
				body += "<A href='?src=\ref[src];[HrefToken()];corgione=\ref[M]'>Corgize</A> | "

			//AI / Cyborg
			if(isAI(M))
				body += "<B>Is an AI</B> "
			else if(ishuman(M))
				body += {"<A href='?src=\ref[src];[HrefToken()];makeai=\ref[M]'>Make AI</A> |
					<A href='?src=\ref[src];[HrefToken()];makerobot=\ref[M]'>Make Robot</A> |
					<A href='?src=\ref[src];[HrefToken()];makealien=\ref[M]'>Make Alien</A>
				"}

			//Simple Animals
			if(isanimal(M))
				body += "<A href='?src=\ref[src];[HrefToken()];makeanimal=\ref[M]'>Re-Animalize</A> | "
			else
				body += "<A href='?src=\ref[src];[HrefToken()];makeanimal=\ref[M]'>Animalize</A> | "

			body += "<A href='?src=\ref[src];[HrefToken()];respawn=\ref[M.client]'>Respawn</A> | "

			// DNA2 - Admin Hax
			if(M.dna && iscarbon(M))
				body += "<br><br>"
				body += "<b>DNA Blocks:</b><br><table border='0'><tr><th>&nbsp;</th><th>1</th><th>2</th><th>3</th><th>4</th><th>5</th>"
				var/bname
				for(var/block=1;block<=DNA_SE_LENGTH;block++)
					if(((block-1)%5)==0)
						body += "</tr><tr><th>[block-1]</th>"
					bname = assigned_blocks[block]
					body += "<td>"
					if(bname)
						var/bstate=M.dna.GetSEState(block)
						var/bcolor="[(bstate)?"#006600":"#ff0000"]"
						body += "<A href='?src=\ref[src];[HrefToken()];togmutate=\ref[M];block=[block]' style='color:[bcolor];'>[bname]</A><sub>[block]</sub>"
					else
						body += "[block]"
					body+="</td>"
				body += "</tr></table>"

			body += {"<br><br>
				<b>Rudimentary transformation:</b><font size=2><br>These transformations only create a new mob type and copy stuff over. They do not take into account MMIs and similar mob-specific things. The buttons in 'Transformations' are preferred, when possible.</font><br>
				<A href='?src=\ref[src];[HrefToken()];simplemake=observer;mob=\ref[M]'>Observer</A> |
				\[ Xenos: <A href='?src=\ref[src];[HrefToken()];simplemake=larva;mob=\ref[M]'>Larva</A>
				<A href='?src=\ref[src];[HrefToken()];simplemake=human;species=Xenomorph Drone;mob=\ref[M]'>Drone</A>
				<A href='?src=\ref[src];[HrefToken()];simplemake=human;species=Xenomorph Hunter;mob=\ref[M]'>Hunter</A>
				<A href='?src=\ref[src];[HrefToken()];simplemake=human;species=Xenomorph Sentinel;mob=\ref[M]'>Sentinel</A>
				<A href='?src=\ref[src];[HrefToken()];simplemake=human;species=Xenomorph Queen;mob=\ref[M]'>Queen</A> \] |
				\[ Crew: <A href='?src=\ref[src];[HrefToken()];simplemake=human;mob=\ref[M]'>Human</A>
				<A href='?src=\ref[src];[HrefToken()];simplemake=human;species=Unathi;mob=\ref[M]'>Unathi</A>
				<A href='?src=\ref[src];[HrefToken()];simplemake=human;species=Tajaran;mob=\ref[M]'>Tajaran</A>
				<A href='?src=\ref[src];[HrefToken()];simplemake=human;species=Skrell;mob=\ref[M]'>Skrell</A> \] | \[
				<A href='?src=\ref[src];[HrefToken()];simplemake=nymph;mob=\ref[M]'>Nymph</A>
				<A href='?src=\ref[src];[HrefToken()];simplemake=human;species='Diona';mob=\ref[M]'>Diona</A> \] |
				\[ slime: <A href='?src=\ref[src];[HrefToken()];simplemake=slime;mob=\ref[M]'>Baby</A>,
				<A href='?src=\ref[src];[HrefToken()];simplemake=adultslime;mob=\ref[M]'>Adult</A> \]
				<A href='?src=\ref[src];[HrefToken()];simplemake=monkey;mob=\ref[M]'>Monkey</A> |
				<A href='?src=\ref[src];[HrefToken()];simplemake=robot;mob=\ref[M]'>Cyborg</A> |
				<A href='?src=\ref[src];[HrefToken()];simplemake=cat;mob=\ref[M]'>Cat</A> |
				<A href='?src=\ref[src];[HrefToken()];simplemake=runtime;mob=\ref[M]'>Runtime</A> |
				<A href='?src=\ref[src];[HrefToken()];simplemake=corgi;mob=\ref[M]'>Corgi</A> |
				<A href='?src=\ref[src];[HrefToken()];simplemake=ian;mob=\ref[M]'>Ian</A> |
				<A href='?src=\ref[src];[HrefToken()];simplemake=crab;mob=\ref[M]'>Crab</A> |
				<A href='?src=\ref[src];[HrefToken()];simplemake=coffee;mob=\ref[M]'>Coffee</A> |
				\[ Construct: <A href='?src=\ref[src];[HrefToken()];simplemake=constructarmoured;mob=\ref[M]'>Armoured</A> ,
				<A href='?src=\ref[src];[HrefToken()];simplemake=constructbuilder;mob=\ref[M]'>Builder</A> ,
				<A href='?src=\ref[src];[HrefToken()];simplemake=constructwraith;mob=\ref[M]'>Wraith</A> \]
				<A href='?src=\ref[src];[HrefToken()];simplemake=shade;mob=\ref[M]'>Shade</A>
				<br>
			"}
	body += {"<br><br>
			<b>Other actions:</b>
			<br>
			<A href='?src=\ref[src];[HrefToken()];forcespeech=\ref[M]'>Forcesay</A>
			"}
	if (M.client)
		body += {" |
			<A href='?src=\ref[src];[HrefToken()];tdome1=\ref[M]'>Thunderdome 1</A> |
			<A href='?src=\ref[src];[HrefToken()];tdome2=\ref[M]'>Thunderdome 2</A> |
			<A href='?src=\ref[src];[HrefToken()];tdomeadmin=\ref[M]'>Thunderdome Admin</A> |
			<A href='?src=\ref[src];[HrefToken()];tdomeobserve=\ref[M]'>Thunderdome Observer</A> |
		"}
	// language toggles
	body += "<br><br><b>Languages:</b><br>"
	var/f = 1
	for(var/k in GLOB.all_languages)
		var/datum/language/L = GLOB.all_languages[k]
		if(!(L.flags & INNATE))
			if(!f) body += " | "
			else f = 0
			if(L in M.languages)
				body += "<a href='?src=\ref[src];[HrefToken()];toglang=\ref[M];lang=[html_encode(k)]' style='color:#006600'>[k]</a>"
			else
				body += "<a href='?src=\ref[src];[HrefToken()];toglang=\ref[M];lang=[html_encode(k)]' style='color:#ff0000'>[k]</a>"

	body += {"<br>
		</body></html>
	"}

	usr << browse(body, "window=adminplayeropts;size=550x515")
	feedback_add_details("admin_verb","SPP") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/datum/player_info/var/author // admin who authored the information
/datum/player_info/var/rank //rank of admin who made the notes
/datum/player_info/var/content // text content of the information
/datum/player_info/var/timestamp // Because this is bloody annoying

/datum/admins/proc/PlayerNotes()
	set category = "Admin"
	set name = "Player Notes"
	if (!istype(src,/datum/admins))
		src = usr.client.holder
	if (!istype(src,/datum/admins))
		to_chat(usr, "Error: you are not an admin!")
		return
	PlayerNotesPage(1)

/datum/admins/proc/PlayerNotesFilter()
	if (!istype(src,/datum/admins))
		src = usr.client.holder
	if (!istype(src,/datum/admins))
		to_chat(usr, "Error: you are not an admin!")
		return
	var/filter = tgui_input_text(usr, "Filter string (case-insensitive regex)", "Player notes filter")
	PlayerNotesPage(1, filter)

/datum/admins/proc/PlayerNotesPage(page, filter)
	var/savefile/S=new("data/player_notes.sav")
	var/list/note_keys
	S >> note_keys

	if(note_keys)
		note_keys = sortList(note_keys)

	var/datum/tgui_module/player_notes/A = new(src)
	A.ckeys = note_keys
	A.tgui_interact(usr)


/datum/admins/proc/player_has_info(var/key as text)
	var/savefile/info = new("data/player_saves/[copytext(key, 1, 2)]/[key]/info.sav")
	var/list/infos
	info >> infos
	if(!infos || !infos.len) return 0
	else return 1


/datum/admins/proc/show_player_info(var/key as text)
	set category = "Admin"
	set name = "Show Player Info"
	if (!istype(src,/datum/admins))
		src = usr.client.holder
	if (!istype(src,/datum/admins))
		to_chat(usr, "Error: you are not an admin!")
		return

	var/datum/tgui_module/player_notes_info/A = new(src)
	A.key = key
	A.tgui_interact(usr)


/datum/admins/proc/access_news_network() //MARKER
	set category = "Fun"
	set name = "Access Newscaster Network"
	set desc = "Allows you to view, add and edit news feeds."

	if (!istype(src,/datum/admins))
		src = usr.client.holder
	if (!istype(src,/datum/admins))
		to_chat(usr, "Error: you are not an admin!")
		return
	var/dat
	dat = text("<HEAD><TITLE>Admin Newscaster</TITLE></HEAD><H3>Admin Newscaster Unit</H3>")

	switch(admincaster_screen)
		if(0)
			dat += {"Welcome to the admin newscaster.<BR> Here you can add, edit and censor every newspiece on the network.
				<BR>Feed channels and stories entered through here will be uneditable and handled as official news by the rest of the units.
				<BR>Note that this panel allows full freedom over the news network, there are no constrictions except the few basic ones. Don't break things!
			"}
			if(news_network.wanted_issue)
				dat+= "<HR><A href='?src=\ref[src];[HrefToken()];ac_view_wanted=1'>Read Wanted Issue</A>"

			dat+= {"<HR><BR><A href='?src=\ref[src];[HrefToken()];ac_create_channel=1'>Create Feed Channel</A>
				<BR><A href='?src=\ref[src];[HrefToken()];ac_view=1'>View Feed Channels</A>
				<BR><A href='?src=\ref[src];[HrefToken()];ac_create_feed_story=1'>Submit new Feed story</A>
				<BR><BR><A href='?src=\ref[usr];[HrefToken()];mach_close=newscaster_main'>Exit</A>
			"}

			var/wanted_already = 0
			if(news_network.wanted_issue)
				wanted_already = 1

			dat+={"<HR><B>Feed Security functions:</B><BR>
				<BR><A href='?src=\ref[src];[HrefToken()];ac_menu_wanted=1'>[(wanted_already) ? ("Manage") : ("Publish")] \"Wanted\" Issue</A>
				<BR><A href='?src=\ref[src];[HrefToken()];ac_menu_censor_story=1'>Censor Feed Stories</A>
				<BR><A href='?src=\ref[src];[HrefToken()];ac_menu_censor_channel=1'>Mark Feed Channel with [using_map.company_name] D-Notice (disables and locks the channel.</A>
				<BR><HR><A href='?src=\ref[src];[HrefToken()];ac_set_signature=1'>The newscaster recognises you as:<BR> <FONT COLOR='green'>[src.admincaster_signature]</FONT></A>
			"}
		if(1)
			dat+= "Station Feed Channels<HR>"
			if( isemptylist(news_network.network_channels) )
				dat+="<I>No active channels found...</I>"
			else
				for(var/datum/feed_channel/CHANNEL in news_network.network_channels)
					if(CHANNEL.is_admin_channel)
						dat+="<B><FONT style='BACKGROUND-COLOR: LightGreen'><A href='?src=\ref[src];[HrefToken()];ac_show_channel=\ref[CHANNEL]'>[CHANNEL.channel_name]</A></FONT></B><BR>"
					else
						dat+="<B><A href='?src=\ref[src];[HrefToken()];ac_show_channel=\ref[CHANNEL]'>[CHANNEL.channel_name]</A> [(CHANNEL.censored) ? ("<FONT COLOR='red'>***</FONT>") : null]<BR></B>"
			dat+={"<BR><HR><A href='?src=\ref[src];[HrefToken()];ac_refresh=1'>Refresh</A>
				<BR><A href='?src=\ref[src];[HrefToken()];ac_setScreen=[0]'>Back</A>
			"}

		if(2)
			dat+={"
				Creating new Feed Channel...
				<HR><B><A href='?src=\ref[src];[HrefToken()];ac_set_channel_name=1'>Channel Name</A>:</B> [src.admincaster_feed_channel.channel_name]<BR>
				<B><A href='?src=\ref[src];[HrefToken()];ac_set_signature=1'>Channel Author</A>:</B> <FONT COLOR='green'>[src.admincaster_signature]</FONT><BR>
				<B><A href='?src=\ref[src];[HrefToken()];ac_set_channel_lock=1'>Will Accept Public Feeds</A>:</B> [(src.admincaster_feed_channel.locked) ? ("NO") : ("YES")]<BR><BR>
				<BR><A href='?src=\ref[src];[HrefToken()];ac_submit_new_channel=1'>Submit</A><BR><BR><A href='?src=\ref[src];[HrefToken()];ac_setScreen=[0]'>Cancel</A><BR>
			"}
		if(3)
			dat+={"
				Creating new Feed Message...
				<HR><B><A href='?src=\ref[src];[HrefToken()];ac_set_channel_receiving=1'>Receiving Channel</A>:</B> [src.admincaster_feed_channel.channel_name]<BR>
				<B>Message Author:</B> <FONT COLOR='green'>[src.admincaster_signature]</FONT><BR>
				<B><A href='?src=\ref[src];[HrefToken()];ac_set_new_message=1'>Message Body</A>:</B> [src.admincaster_feed_message.body] <BR>
				<BR><A href='?src=\ref[src];[HrefToken()];ac_submit_new_message=1'>Submit</A><BR><BR><A href='?src=\ref[src];[HrefToken()];ac_setScreen=[0]'>Cancel</A><BR>
			"}
		if(4)
			dat+={"
					Feed story successfully submitted to [src.admincaster_feed_channel.channel_name].<BR><BR>
					<BR><A href='?src=\ref[src];[HrefToken()];ac_setScreen=[0]'>Return</A><BR>
				"}
		if(5)
			dat+={"
				Feed Channel [src.admincaster_feed_channel.channel_name] created successfully.<BR><BR>
				<BR><A href='?src=\ref[src];[HrefToken()];ac_setScreen=[0]'>Return</A><BR>
			"}
		if(6)
			dat+="<B><FONT COLOR='maroon'>ERROR: Could not submit Feed story to Network.</B></FONT><HR><BR>"
			if(src.admincaster_feed_channel.channel_name=="")
				dat+="<FONT COLOR='maroon'>Invalid receiving channel name.</FONT><BR>"
			if(src.admincaster_feed_message.body == "" || src.admincaster_feed_message.body == "\[REDACTED\]" || admincaster_feed_message.title == "")
				dat+="<FONT COLOR='maroon'>Invalid message body.</FONT><BR>"
			dat+="<BR><A href='?src=\ref[src];[HrefToken()];ac_setScreen=[3]'>Return</A><BR>"
		if(7)
			dat+="<B><FONT COLOR='maroon'>ERROR: Could not submit Feed Channel to Network.</B></FONT><HR><BR>"
			if(src.admincaster_feed_channel.channel_name =="" || src.admincaster_feed_channel.channel_name == "\[REDACTED\]")
				dat+="<FONT COLOR='maroon'>Invalid channel name.</FONT><BR>"
			var/check = 0
			for(var/datum/feed_channel/FC in news_network.network_channels)
				if(FC.channel_name == src.admincaster_feed_channel.channel_name)
					check = 1
					break
			if(check)
				dat+="<FONT COLOR='maroon'>Channel name already in use.</FONT><BR>"
			dat+="<BR><A href='?src=\ref[src];[HrefToken()];ac_setScreen=[2]'>Return</A><BR>"
		if(9)
			dat+="<B>[src.admincaster_feed_channel.channel_name]: </B><FONT SIZE=1>\[created by: <FONT COLOR='maroon'>[src.admincaster_feed_channel.author]</FONT>\]</FONT><HR>"
			if(src.admincaster_feed_channel.censored)
				dat+={"
					<FONT COLOR='red'><B>ATTENTION: </B></FONT>This channel has been deemed as threatening to the welfare of the station, and marked with a [using_map.company_name] D-Notice.<BR>
					No further feed story additions are allowed while the D-Notice is in effect.<BR><BR>
				"}
			else
				if( isemptylist(src.admincaster_feed_channel.messages) )
					dat+="<I>No feed messages found in channel...</I><BR>"
				else
					var/i = 0
					for(var/datum/feed_message/MESSAGE in src.admincaster_feed_channel.messages)
						i++
						//dat+="-[MESSAGE.body] <BR>"
						var/pic_data
						if(MESSAGE.img)
							usr << browse_rsc(MESSAGE.img, "tmp_photo[i].png")
							pic_data+="<img src='tmp_photo[i].png' width = '180'><BR>"
						dat+= get_newspaper_content(MESSAGE.title, MESSAGE.body, MESSAGE.author,"#d4cec1", pic_data)
						dat+="<BR>"
						dat+="<FONT SIZE=1>\[Story by <FONT COLOR='maroon'>[MESSAGE.author] - [MESSAGE.time_stamp]</FONT>\]</FONT><BR>"
			dat+={"
				<BR><HR><A href='?src=\ref[src];[HrefToken()];ac_refresh=1'>Refresh</A>
				<BR><A href='?src=\ref[src];[HrefToken()];ac_setScreen=[1]'>Back</A>
			"}
		if(10)
			dat+={"
				<B>[using_map.company_name] Feed Censorship Tool</B><BR>
				<FONT SIZE=1>NOTE: Due to the nature of news Feeds, total deletion of a Feed Story is not possible.<BR>
				Keep in mind that users attempting to view a censored feed will instead see the \[REDACTED\] tag above it.</FONT>
				<HR>Select Feed channel to get Stories from:<BR>
			"}
			if(isemptylist(news_network.network_channels))
				dat+="<I>No feed channels found active...</I><BR>"
			else
				for(var/datum/feed_channel/CHANNEL in news_network.network_channels)
					dat+="<A href='?src=\ref[src];[HrefToken()];ac_pick_censor_channel=\ref[CHANNEL]'>[CHANNEL.channel_name]</A> [(CHANNEL.censored) ? ("<FONT COLOR='red'>***</FONT>") : null]<BR>"
			dat+="<BR><A href='?src=\ref[src];[HrefToken()];ac_setScreen=[0]'>Cancel</A>"
		if(11)
			dat+={"
				<B>[using_map.company_name] D-Notice Handler</B><HR>
				<FONT SIZE=1>A D-Notice is to be bestowed upon the channel if the handling Authority deems it as harmful for the station's
				morale, integrity or disciplinary behaviour. A D-Notice will render a channel unable to be updated by anyone, without deleting any feed
				stories it might contain at the time. You can lift a D-Notice if you have the required access at any time.</FONT><HR>
			"}
			if(isemptylist(news_network.network_channels))
				dat+="<I>No feed channels found active...</I><BR>"
			else
				for(var/datum/feed_channel/CHANNEL in news_network.network_channels)
					dat+="<A href='?src=\ref[src];[HrefToken()];ac_pick_d_notice=\ref[CHANNEL]'>[CHANNEL.channel_name]</A> [(CHANNEL.censored) ? ("<FONT COLOR='red'>***</FONT>") : null]<BR>"

			dat+="<BR><A href='?src=\ref[src];[HrefToken()];ac_setScreen=[0]'>Back</A>"
		if(12)
			dat+={"
				<B>[src.admincaster_feed_channel.channel_name]: </B><FONT SIZE=1>\[ created by: <FONT COLOR='maroon'>[src.admincaster_feed_channel.author]</FONT> \]</FONT><BR>
				<FONT SIZE=2><A href='?src=\ref[src];[HrefToken()];ac_censor_channel_author=\ref[src.admincaster_feed_channel]'>[(src.admincaster_feed_channel.author=="\[REDACTED\]") ? ("Undo Author censorship") : ("Censor channel Author")]</A></FONT><HR>
			"}
			if( isemptylist(src.admincaster_feed_channel.messages) )
				dat+="<I>No feed messages found in channel...</I><BR>"
			else
				for(var/datum/feed_message/MESSAGE in src.admincaster_feed_channel.messages)
					dat+={"
						-[MESSAGE.body] <BR><FONT SIZE=1>\[Story by <FONT COLOR='maroon'>[MESSAGE.author]</FONT>\]</FONT><BR>
						<FONT SIZE=2><A href='?src=\ref[src];[HrefToken()];ac_censor_channel_story_body=\ref[MESSAGE]'>[(MESSAGE.body == "\[REDACTED\]") ? ("Undo story censorship") : ("Censor story")]</A>  -  <A href='?src=\ref[src];[HrefToken()];ac_censor_channel_story_author=\ref[MESSAGE]'>[(MESSAGE.author == "\[REDACTED\]") ? ("Undo Author Censorship") : ("Censor message Author")]</A></FONT><BR>
					"}
			dat+="<BR><A href='?src=\ref[src];[HrefToken()];ac_setScreen=[10]'>Back</A>"
		if(13)
			dat+={"
				<B>[src.admincaster_feed_channel.channel_name]: </B><FONT SIZE=1>\[ created by: <FONT COLOR='maroon'>[src.admincaster_feed_channel.author]</FONT> \]</FONT><BR>
				Channel messages listed below. If you deem them dangerous to the station, you can <A href='?src=\ref[src];[HrefToken()];ac_toggle_d_notice=\ref[src.admincaster_feed_channel]'>Bestow a D-Notice upon the channel</A>.<HR>
			"}
			if(src.admincaster_feed_channel.censored)
				dat+={"
					<FONT COLOR='red'><B>ATTENTION: </B></FONT>This channel has been deemed as threatening to the welfare of the station, and marked with a [using_map.company_name] D-Notice.<BR>
					No further feed story additions are allowed while the D-Notice is in effect.<BR><BR>
				"}
			else
				if( isemptylist(src.admincaster_feed_channel.messages) )
					dat+="<I>No feed messages found in channel...</I><BR>"
				else
					for(var/datum/feed_message/MESSAGE in src.admincaster_feed_channel.messages)
						dat+="-[MESSAGE.body] <BR><FONT SIZE=1>\[Story by <FONT COLOR='maroon'>[MESSAGE.author]</FONT>\]</FONT><BR>"

			dat+="<BR><A href='?src=\ref[src];[HrefToken()];ac_setScreen=[11]'>Back</A>"
		if(14)
			dat+="<B>Wanted Issue Handler:</B>"
			var/wanted_already = 0
			var/end_param = 1
			if(news_network.wanted_issue)
				wanted_already = 1
				end_param = 2
			if(wanted_already)
				dat+="<FONT SIZE=2><BR><I>A wanted issue is already in Feed Circulation. You can edit or cancel it below.</FONT></I>"
			dat+={"
				<HR>
				<A href='?src=\ref[src];[HrefToken()];ac_set_wanted_name=1'>Criminal Name</A>: [src.admincaster_feed_message.author] <BR>
				<A href='?src=\ref[src];[HrefToken()];ac_set_wanted_desc=1'>Description</A>: [src.admincaster_feed_message.body] <BR>
			"}
			if(wanted_already)
				dat+="<B>Wanted Issue created by:</B><FONT COLOR='green'> [news_network.wanted_issue.backup_author]</FONT><BR>"
			else
				dat+="<B>Wanted Issue will be created under prosecutor:</B><FONT COLOR='green'> [src.admincaster_signature]</FONT><BR>"
			dat+="<BR><A href='?src=\ref[src];[HrefToken()];ac_submit_wanted=[end_param]'>[(wanted_already) ? ("Edit Issue") : ("Submit")]</A>"
			if(wanted_already)
				dat+="<BR><A href='?src=\ref[src];[HrefToken()];ac_cancel_wanted=1'>Take down Issue</A>"
			dat+="<BR><A href='?src=\ref[src];[HrefToken()];ac_setScreen=[0]'>Cancel</A>"
		if(15)
			dat+={"
				<FONT COLOR='green'>Wanted issue for [src.admincaster_feed_message.author] is now in Network Circulation.</FONT><BR><BR>
				<BR><A href='?src=\ref[src];[HrefToken()];ac_setScreen=[0]'>Return</A><BR>
			"}
		if(16)
			dat+="<B><FONT COLOR='maroon'>ERROR: Wanted Issue rejected by Network.</B></FONT><HR><BR>"
			if(src.admincaster_feed_message.author =="" || src.admincaster_feed_message.author == "\[REDACTED\]")
				dat+="<FONT COLOR='maroon'>Invalid name for person wanted.</FONT><BR>"
			if(src.admincaster_feed_message.body == "" || src.admincaster_feed_message.body == "\[REDACTED\]")
				dat+="<FONT COLOR='maroon'>Invalid description.</FONT><BR>"
			dat+="<BR><A href='?src=\ref[src];[HrefToken()];ac_setScreen=[0]'>Return</A><BR>"
		if(17)
			dat+={"
				<B>Wanted Issue successfully deleted from Circulation</B><BR>
				<BR><A href='?src=\ref[src];[HrefToken()];ac_setScreen=[0]'>Return</A><BR>
			"}
		if(18)
			dat+={"
				<B><FONT COLOR ='maroon'>-- STATIONWIDE WANTED ISSUE --</B></FONT><BR><FONT SIZE=2>\[Submitted by: <FONT COLOR='green'>[news_network.wanted_issue.backup_author]</FONT>\]</FONT><HR>
				<B>Criminal</B>: [news_network.wanted_issue.author]<BR>
				<B>Description</B>: [news_network.wanted_issue.body]<BR>
				<B>Photo:</B>:
			"}
			if(news_network.wanted_issue.img)
				usr << browse_rsc(news_network.wanted_issue.img, "tmp_photow.png")
				dat+="<BR><img src='tmp_photow.png' width = '180'>"
			else
				dat+="None"
			dat+="<BR><A href='?src=\ref[src];[HrefToken()];ac_setScreen=[0]'>Back</A><BR>"
		if(19)
			dat+={"
				<FONT COLOR='green'>Wanted issue for [src.admincaster_feed_message.author] successfully edited.</FONT><BR><BR>
				<BR><A href='?src=\ref[src];[HrefToken()];ac_setScreen=[0]'>Return</A><BR>
			"}
		else
			dat+="I'm sorry to break your immersion. This shit's bugged. Report this bug to Agouri, polyxenitopalidou@gmail.com"

	//to_world("Channelname: [src.admincaster_feed_channel.channel_name] [src.admincaster_feed_channel.author]")
	//to_world("Msg: [src.admincaster_feed_message.author] [src.admincaster_feed_message.body]")
	usr << browse(dat, "window=admincaster_main;size=400x600")
	onclose(usr, "admincaster_main")



/datum/admins/proc/Jobbans()
	if(!check_rights(R_BAN))	return

	var/dat = "<B>Job Bans!</B><HR><table>"
	for(var/t in jobban_keylist)
		var/r = t
		if( findtext(r,"##") )
			r = copytext( r, 1, findtext(r,"##") )//removes the description
		dat += text("<tr><td>[t] (<A href='?src=\ref[src];[HrefToken()];removejobban=[r]'>unban</A>)</td></tr>")
	dat += "</table>"
	usr << browse(dat, "window=ban;size=400x400")

/datum/admins/proc/Game()
	if(!check_rights(0))	return

	var/dat = {"
		<center><B>Game Panel</B></center><hr>\n
		<A href='?src=\ref[src];[HrefToken()];c_mode=1'>Change Game Mode</A><br>
		"}
	if(master_mode == "secret")
		dat += "<A href='?src=\ref[src];[HrefToken()];f_secret=1'>(Force Secret Mode)</A><br>"

	dat += {"
		<BR>
		<A href='?src=\ref[src];[HrefToken()];create_object=1'>Create Object</A><br>
		<A href='?src=\ref[src];[HrefToken()];quick_create_object=1'>Quick Create Object</A><br>
		<A href='?src=\ref[src];[HrefToken()];create_turf=1'>Create Turf</A><br>
		<A href='?src=\ref[src];[HrefToken()];create_mob=1'>Create Mob</A><br>
		<br><A href='?src=\ref[src];[HrefToken()];vsc=airflow'>Edit Airflow Settings</A><br>
		<A href='?src=\ref[src];[HrefToken()];vsc=phoron'>Edit Phoron Settings</A><br>
		<A href='?src=\ref[src];[HrefToken()];vsc=default'>Choose a default ZAS setting</A><br>
		"}

	usr << browse(dat, "window=admin2;size=210x280")
	return

/datum/admins/proc/Secrets(var/datum/admin_secret_category/active_category = null)
	if(!check_rights(0))	return

	// Print the header with category selection buttons.
	var/dat = "<B>The first rule of adminbuse is: you don't talk about the adminbuse.</B><HR>"
	for(var/datum/admin_secret_category/category in admin_secrets.categories)
		if(!category.can_view(usr))
			continue
		dat += "<A href='?src=\ref[src];[HrefToken()];admin_secrets_panel=\ref[category]'>[category.name]</A> "
	dat += "<HR>"

	// If a category is selected, print its description and then options
	if(istype(active_category) && active_category.can_view(usr))
		dat += "<B>[active_category.name]</B><BR>"
		if(active_category.desc)
			dat += "<I>[active_category.desc]</I><BR>"
		for(var/datum/admin_secret_item/item in active_category.items)
			if(!item.can_view(usr))
				continue
			dat += "<A href='?src=\ref[src];[HrefToken()];admin_secrets=\ref[item]'>[item.name()]</A><BR>"
		dat += "<BR>"

	var/datum/browser/popup = new(usr, "secrets", "Secrets", 500, 500)
	popup.set_content(dat)
	popup.open()
	return

/////////////////////////////////////////////////////////////////////////////////////////////////admins2.dm merge
//i.e. buttons/verbs


/datum/admins/proc/restart()
	set category = "Server"
	set name = "Restart"
	set desc="Restarts the world"
	if (!usr.client.holder)
		return
	var/confirm = alert(usr, "Restart the game world?", "Restart", "Yes", "Cancel") // Not tgui_alert for safety
	if(!confirm || confirm == "Cancel")
		return
	if(confirm == "Yes")
		to_world("<span class='danger'>Restarting world!</span> <span class='notice'>Initiated by [usr.client.holder.fakekey ? "Admin" : usr.key]!</span>")
		log_admin("[key_name(usr)] initiated a reboot.")

		feedback_set_details("end_error","admin reboot - by [usr.key] [usr.client.holder.fakekey ? "(stealth)" : ""]")
		feedback_add_details("admin_verb","R") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

		if(blackbox)
			blackbox.save_all_data_to_sql()

		sleep(50)
		world.Reboot()


/datum/admins/proc/announce()
	set category = "Special Verbs"
	set name = "Announce"
	set desc="Announce your desires to the world"
	if(!check_rights(0))	return

	var/message = tgui_input_text(usr, "Global message to send:", "Admin Announce", multiline = TRUE, prevent_enter = TRUE)
	if(message)
		if(!check_rights(R_SERVER,0))
			message = sanitize(message, 500, extra = 0)
		message = replacetext(message, "\n", "<br>") // required since we're putting it in a <p> tag
		to_world("<span class=notice><b>[usr.client.holder.fakekey ? "Administrator" : usr.key] Announces:</b><p style='text-indent: 50px'>[message]</p></span>")
		log_admin("Announce: [key_name(usr)] : [message]")
	feedback_add_details("admin_verb","A") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

//VOREStation Edit to this verb for the purpose of making it compliant with the annunciator system
var/datum/announcement/priority/admin_pri_announcer = new
var/datum/announcement/minor/admin_min_announcer = new
/datum/admins/proc/intercom()
	set category = "Fun"
	set name = "Intercom Msg"
	set desc = "Send an intercom message, like an arrivals announcement."
	if(!check_rights(0))	return

	var/channel = tgui_input_list(usr, "Channel for message:","Channel", radiochannels)

	if(channel) //They picked a channel
		var/sender = tgui_input_text(usr, "Name of sender (max 75):", "Announcement", "Announcement Computer")

		if(sender) //They put a sender
			sender = sanitize(sender, 75, extra = 0)
			var/message = tgui_input_text(usr, "Message content (max 500):", "Contents", "This is a test of the announcement system.", multiline = TRUE, prevent_enter = TRUE)
			var/msgverb = tgui_input_text(usr, "Name of verb (Such as 'states', 'says', 'asks', etc):", "Verb", "says")
			if(message) //They put a message
				message = sanitize(message, 500, extra = 0)
				//VOREStation Edit Start
				if(msgverb)
					msgverb = sanitize(msgverb, 50, extra = 0)
				else
					msgverb = "states"
				global_announcer.autosay("[message]", "[sender]", "[channel == "Common" ? null : channel]", states = msgverb) //Common is a weird case, as it's not a "channel", it's just talking into a radio without a channel set.
				//VOREStation Edit End
				log_admin("Intercom: [key_name(usr)] : [sender]:[message]")

	feedback_add_details("admin_verb","IN") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/intercom_convo()
	set category = "Fun"
	set name = "Intercom Convo"
	set desc = "Send an intercom conversation, like several uses of the Intercom Msg verb."
	set waitfor = FALSE //Why bother? We have some sleeps. You can leave tho!
	if(!check_rights(0))	return

	var/channel = tgui_input_list(usr, "Channel for message:","Channel", radiochannels)

	if(!channel) //They picked a channel
		return

	var/speech_verb = tgui_alert(usr, "What speech verb to use for the conversation?", "Type", list("states", "says"))
	if(!speech_verb)
		return

	to_chat(usr, "<span class='notice'><B>Intercom Convo Directions</B><br>Start the conversation with the sender, a pipe (|), and then the message on one line. Then hit enter to \
		add another line, and type a (whole) number of seconds to pause between that message, and the next message, then repeat the message syntax up to 20 times. For example:<br>\
		--- --- ---<br>\
		Some Guy|Hello guys, what's up?<br>\
		5<br>\
		Other Guy|Hey, good to see you.<br>\
		5<br>\
		Some Guy|Yeah, you too.<br>\
		--- --- ---<br>\
		The above will result in those messages playing, with a 5 second gap between each. Maximum of 20 messages allowed.</span>")

	var/list/decomposed
	var/message = tgui_input_text(usr,"See your chat box for instructions. Keep a copy elsewhere in case it is rejected when you click OK.", "Input Conversation", "", multiline = TRUE, prevent_enter = TRUE)

	if(!message)
		return

	//Split on pipe or \n
	decomposed = splittext(message,regex("\\||$","m"))
	decomposed += "0" //Tack on a final 0 sleep to make 3-per-message evenly

	//Time to find how they screwed up.
	//Wasn't the right length
	if((decomposed.len) % 3) //+1 to accomidate the lack of a wait time for the last message
		to_chat(usr, "<span class='warning'>You passed [decomposed.len] segments (senders+messages+pauses). You must pass a multiple of 3, minus 1 (no pause after the last message). That means a sender and message on every other line (starting on the first), separated by a pipe character (|), and a number every other line that is a pause in seconds.</span>")
		return

	//Too long a conversation
	if((decomposed.len / 3) > 20)
		to_chat(usr, "<span class='warning'>This conversation is too long! 20 messages maximum, please.</span>")
		return

	//Missed some sleeps, or sanitized to nothing.
	for(var/i = 1; i < decomposed.len; i++)

		//Sanitize sender
		var/clean_sender = sanitize(decomposed[i])
		if(!clean_sender)
			to_chat(usr, "<span class='warning'>One part of your conversation was not able to be sanitized. It was the sender of the [(i+2)/3]\th message.</span>")
			return
		decomposed[i] = clean_sender

		//Sanitize message
		var/clean_message = sanitize(decomposed[++i])
		if(!clean_message)
			to_chat(usr, "<span class='warning'>One part of your conversation was not able to be sanitized. It was the body of the [(i+2)/3]\th message.</span>")
			return
		decomposed[i] = clean_message

		//Sanitize wait time
		var/clean_time = text2num(decomposed[++i])
		if(!isnum(clean_time))
			to_chat(usr, "<span class='warning'>One part of your conversation was not able to be sanitized. It was the wait time after the [(i+2)/3]\th message.</span>")
			return
		if(clean_time > 60)
			to_chat(usr, "<span class='warning'>Max 60 second wait time between messages for sanity's sake please.</span>")
			return
		decomposed[i] = clean_time

	log_admin("Intercom convo started by: [key_name(usr)] : [sanitize(message)]")
	feedback_add_details("admin_verb","IN") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

	//Sanitized AND we still have a chance to send it? Wow!
	if(LAZYLEN(decomposed))
		for(var/i = 1; i < decomposed.len; i++)
			var/this_sender = decomposed[i]
			var/this_message = decomposed[++i]
			var/this_wait = decomposed[++i]
			global_announcer.autosay("[this_message]", "[this_sender]", "[channel == "Common" ? null : channel]", states = speech_verb) //Common is a weird case, as it's not a "channel", it's just talking into a radio without a channel set.	//VOREStation Edit
			sleep(this_wait SECONDS)

/datum/admins/proc/toggleooc()
	set category = "Server"
	set desc="Globally Toggles OOC"
	set name="Toggle Player OOC"

	if(!check_rights(R_ADMIN))
		return

	config.ooc_allowed = !(config.ooc_allowed)
	if (config.ooc_allowed)
		to_world("<B>The OOC channel has been globally enabled!</B>")
	else
		to_world("<B>The OOC channel has been globally disabled!</B>")
	log_and_message_admins("toggled OOC.")
	feedback_add_details("admin_verb","TOOC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/togglelooc()
	set category = "Server"
	set desc="Globally Toggles LOOC"
	set name="Toggle Player LOOC"

	if(!check_rights(R_ADMIN))
		return

	config.looc_allowed = !(config.looc_allowed)
	if (config.looc_allowed)
		to_world("<B>The LOOC channel has been globally enabled!</B>")
	else
		to_world("<B>The LOOC channel has been globally disabled!</B>")
	log_and_message_admins("toggled LOOC.")
	feedback_add_details("admin_verb","TLOOC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/datum/admins/proc/toggledsay()
	set category = "Server"
	set desc="Globally Toggles DSAY"
	set name="Toggle DSAY"

	if(!check_rights(R_ADMIN))
		return

	config.dsay_allowed = !(config.dsay_allowed)
	if (config.dsay_allowed)
		to_world("<B>Deadchat has been globally enabled!</B>")
	else
		to_world("<B>Deadchat has been globally disabled!</B>")
	log_admin("[key_name(usr)] toggled deadchat.")
	message_admins("[key_name_admin(usr)] toggled deadchat.", 1)
	feedback_add_details("admin_verb","TDSAY") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc

/datum/admins/proc/toggleoocdead()
	set category = "Server"
	set desc="Toggle Dead OOC."
	set name="Toggle Dead OOC"

	if(!check_rights(R_ADMIN))
		return

	config.dooc_allowed = !( config.dooc_allowed )
	log_admin("[key_name(usr)] toggled Dead OOC.")
	message_admins("[key_name_admin(usr)] toggled Dead OOC.", 1)
	feedback_add_details("admin_verb","TDOOC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/togglehubvisibility()
	set category = "Server"
	set desc="Globally Toggles Hub Visibility"
	set name="Toggle Hub Visibility"

	if(!check_rights(R_ADMIN))
		return

	world.visibility = !(world.visibility)
	log_admin("[key_name(usr)] toggled hub visibility.")
	message_admins("[key_name_admin(usr)] toggled hub visibility.  The server is now [world.visibility ? "visible" : "invisible"] ([world.visibility]).", 1)
	feedback_add_details("admin_verb","THUB") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc

/datum/admins/proc/toggletraitorscaling()
	set category = "Server"
	set desc="Toggle traitor scaling"
	set name="Toggle Traitor Scaling"
	config.traitor_scaling = !config.traitor_scaling
	log_admin("[key_name(usr)] toggled Traitor Scaling to [config.traitor_scaling].")
	message_admins("[key_name_admin(usr)] toggled Traitor Scaling [config.traitor_scaling ? "on" : "off"].", 1)
	feedback_add_details("admin_verb","TTS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/startnow()
	set category = "Server"
	set desc="Start the round ASAP"
	set name="Start Now"

	if(!check_rights(R_SERVER|R_EVENT))
		return
	if(SSticker.current_state > GAME_STATE_PREGAME)
		to_chat(usr, "<span class='warning'>Error: Start Now: Game has already started.</span>")
		return
	if(!SSticker.start_immediately)
		SSticker.start_immediately = TRUE
		var/msg = ""
		if(SSticker.current_state == GAME_STATE_INIT)
			msg = " (The server is still setting up, but the round will be started as soon as possible.)"
		log_admin("[key_name(usr)] has started the game.[msg]")
		message_admins("<span class='notice'>[key_name_admin(usr)] has started the game.[msg]</span>")
		feedback_add_details("admin_verb","SN") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	else
		SSticker.start_immediately = FALSE
		to_world("<span class='notice'>Immediate game start canceled.  Normal startup resumed.</span>")
		log_and_message_admins("cancelled immediate game start.")

/datum/admins/proc/toggleenter()
	set category = "Server"
	set desc="People can't enter"
	set name="Toggle Entering"
	config.enter_allowed = !(config.enter_allowed)
	if (!(config.enter_allowed))
		to_world("<B>New players may no longer enter the game.</B>")
	else
		to_world("<B>New players may now enter the game.</B>")
	log_admin("[key_name(usr)] toggled new player game entering.")
	message_admins(span_blue("[key_name_admin(usr)] toggled new player game entering."), 1)
	world.update_status()
	feedback_add_details("admin_verb","TE") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/toggleAI()
	set category = "Server"
	set desc="People can't be AI"
	set name="Toggle AI"
	config.allow_ai = !( config.allow_ai )
	if (!( config.allow_ai ))
		to_world("<B>The AI job is no longer chooseable.</B>")
	else
		to_world("<B>The AI job is chooseable now.</B>")
	log_admin("[key_name(usr)] toggled AI allowed.")
	world.update_status()
	feedback_add_details("admin_verb","TAI") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/toggleaban()
	set category = "Server"
	set desc="Respawn basically"
	set name="Toggle Respawn"
	config.abandon_allowed = !(config.abandon_allowed)
	if(config.abandon_allowed)
		to_world("<B>You may now respawn.</B>")
	else
		to_world("<B>You may no longer respawn :(</B>")
	message_admins(span_blue("[key_name_admin(usr)] toggled respawn to [config.abandon_allowed ? "On" : "Off"]."), 1)
	log_admin("[key_name(usr)] toggled respawn to [config.abandon_allowed ? "On" : "Off"].")
	world.update_status()
	feedback_add_details("admin_verb","TR") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/togglepersistence()
	set category = "Server"
	set desc="Whether persistent data will be saved from now on."
	set name="Toggle Persistent Data"
	config.persistence_disabled = !(config.persistence_disabled)
	if(!config.persistence_disabled)
		to_world("<B>Persistence is now enabled..</B>")
	else
		to_world("<B>Persistence is no longer enabled.</B>")
	message_admins(span_blue("[key_name_admin(usr)] toggled persistence to [config.persistence_disabled ? "Off" : "On"]."), 1)
	log_admin("[key_name(usr)] toggled persistence to [config.persistence_disabled ? "Off" : "On"].")
	world.update_status()
	feedback_add_details("admin_verb","TPD") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/togglemaploadpersistence()
	set category = "Server"
	set desc="Whether mapload persistent data will be saved from now on."
	set name="Toggle Mapload Persistent Data"
	config.persistence_ignore_mapload = !(config.persistence_ignore_mapload)
	if(!config.persistence_ignore_mapload)
		to_world("<B>Persistence is now enabled..</B>")
	else
		to_world("<B>Persistence is no longer enabled.</B>")
	message_admins(span_blue("[key_name_admin(usr)] toggled persistence to [config.persistence_ignore_mapload ? "Off" : "On"]."), 1)
	log_admin("[key_name(usr)] toggled persistence to [config.persistence_ignore_mapload ? "Off" : "On"].")
	world.update_status()
	feedback_add_details("admin_verb","TMPD") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/toggle_aliens()
	set category = "Server"
	set desc="Toggle alien mobs"
	set name="Toggle Aliens"
	config.aliens_allowed = !config.aliens_allowed
	log_admin("[key_name(usr)] toggled Aliens to [config.aliens_allowed].")
	message_admins("[key_name_admin(usr)] toggled Aliens [config.aliens_allowed ? "on" : "off"].", 1)
	feedback_add_details("admin_verb","TA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/toggle_space_ninja()
	set category = "Server"
	set desc="Toggle space ninjas spawning."
	set name="Toggle Space Ninjas"
	config.ninjas_allowed = !config.ninjas_allowed
	log_admin("[key_name(usr)] toggled Space Ninjas to [config.ninjas_allowed].")
	message_admins("[key_name_admin(usr)] toggled Space Ninjas [config.ninjas_allowed ? "on" : "off"].", 1)
	feedback_add_details("admin_verb","TSN") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/delay()
	set category = "Server"
	set desc="Delay the game start/end"
	set name="Delay"

	if(!check_rights(R_SERVER|R_EVENT))	return
	if (SSticker.current_state >= GAME_STATE_PLAYING)
		SSticker.delay_end = !SSticker.delay_end
		log_admin("[key_name(usr)] [SSticker.delay_end ? "delayed the round end" : "has made the round end normally"].")
		message_admins(span_blue("[key_name(usr)] [SSticker.delay_end ? "delayed the round end" : "has made the round end normally"]."), 1)
		return
	round_progressing = !round_progressing
	if (!round_progressing)
		to_world("<b>The game start has been delayed.</b>")
		log_admin("[key_name(usr)] delayed the game.")
	else
		to_world("<b>The game will start soon.</b>")
		log_admin("[key_name(usr)] removed the delay.")
	feedback_add_details("admin_verb","DELAY") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/adjump()
	set category = "Server"
	set desc="Toggle admin jumping"
	set name="Toggle Jump"
	config.allow_admin_jump = !(config.allow_admin_jump)
	message_admins(span_blue("Toggled admin jumping to [config.allow_admin_jump]."))
	feedback_add_details("admin_verb","TJ") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/adspawn()
	set category = "Server"
	set desc="Toggle admin spawning"
	set name="Toggle Spawn"
	config.allow_admin_spawning = !(config.allow_admin_spawning)
	message_admins(span_blue("Toggled admin item spawning to [config.allow_admin_spawning]."))
	feedback_add_details("admin_verb","TAS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/adrev()
	set category = "Server"
	set desc="Toggle admin revives"
	set name="Toggle Revive"
	config.allow_admin_rev = !(config.allow_admin_rev)
	message_admins(span_blue("Toggled reviving to [config.allow_admin_rev]."))
	feedback_add_details("admin_verb","TAR") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/immreboot()
	set category = "Server"
	set desc="Reboots the server post haste"
	set name="Immediate Reboot"
	if(!usr.client.holder)	return
	if(alert(usr, "Reboot server?","Reboot!","Yes","No") != "Yes") // Not tgui_alert for safety
		return
	to_world("[span_red("<b>Rebooting world!</b>")] [span_blue("Initiated by [usr.client.holder.fakekey ? "Admin" : usr.key]!")]")
	log_admin("[key_name(usr)] initiated an immediate reboot.")

	feedback_set_details("end_error","immediate admin reboot - by [usr.key] [usr.client.holder.fakekey ? "(stealth)" : ""]")
	feedback_add_details("admin_verb","IR") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

	if(blackbox)
		blackbox.save_all_data_to_sql()

	world.Reboot()

/datum/admins/proc/unprison(var/mob/M in mob_list)
	set category = "Admin"
	set name = "Unprison"
	if (M.z == 2)
		if (config.allow_admin_jump)
			M.loc = pick(latejoin)
			message_admins("[key_name_admin(usr)] has unprisoned [key_name_admin(M)]", 1)
			log_admin("[key_name(usr)] has unprisoned [key_name(M)]")
		else
			tgui_alert_async(usr, "Admin jumping disabled")
	else
		tgui_alert_async(usr, "[M.name] is not prisoned.")
	feedback_add_details("admin_verb","UP") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

////////////////////////////////////////////////////////////////////////////////////////////////ADMIN HELPER PROCS

/proc/is_special_character(var/character) // returns 1 for special characters and 2 for heroes of gamemode
	if(!ticker || !ticker.mode)
		return 0
	var/datum/mind/M
	if (ismob(character))
		var/mob/C = character
		M = C.mind
	else if(istype(character, /datum/mind))
		M = character

	if(M)
		if(ticker.mode.antag_templates && ticker.mode.antag_templates.len)
			for(var/datum/antagonist/antag in ticker.mode.antag_templates)
				if(antag.is_antagonist(M))
					return 2
		if(M.special_role)
			return 1

	if(isrobot(character))
		var/mob/living/silicon/robot/R = character
		if(R.emagged)
			return 1

	return 0

/datum/admins/proc/spawn_fruit(seedtype in SSplants.seeds)
	set category = "Debug"
	set desc = "Spawn the product of a seed."
	set name = "Spawn Fruit"

	if(!check_rights(R_SPAWN))	return

	if(!seedtype || !SSplants.seeds[seedtype])
		return
	var/amount = tgui_input_number(usr, "Amount of fruit to spawn", "Fruit Amount", 1)
	if(!isnull(amount))
		var/datum/seed/S = SSplants.seeds[seedtype]
		S.harvest(usr,0,0,amount)
	log_admin("[key_name(usr)] spawned [seedtype] fruit at ([usr.x],[usr.y],[usr.z])")

/datum/admins/proc/spawn_custom_item()
	set category = "Debug"
	set desc = "Spawn a custom item."
	set name = "Spawn Custom Item"

	if(!check_rights(R_SPAWN))	return

	var/owner = tgui_input_list(usr, "Select a ckey.", "Spawn Custom Item", custom_items)
	if(!owner|| !custom_items[owner])
		return

	var/list/possible_items = custom_items[owner]
	var/datum/custom_item/item_to_spawn = tgui_input_list(usr, "Select an item to spawn.", "Spawn Custom Item", possible_items)
	if(!item_to_spawn)
		return

	item_to_spawn.spawn_item(get_turf(usr))

/datum/admins/proc/check_custom_items()

	set category = "Debug"
	set desc = "Check the custom item list."
	set name = "Check Custom Items"

	if(!check_rights(R_SPAWN))	return

	if(!custom_items)
		to_chat(usr, "Custom item list is null.")
		return

	if(!custom_items.len)
		to_chat(usr, "Custom item list not populated.")
		return

	for(var/assoc_key in custom_items)
		to_chat(usr, "[assoc_key] has:")
		var/list/current_items = custom_items[assoc_key]
		for(var/datum/custom_item/item in current_items)
			to_chat(usr, "- name: [item.name] icon: [item.item_icon] path: [item.item_path] desc: [item.item_desc]")

/datum/admins/proc/spawn_plant(seedtype in SSplants.seeds)
	set category = "Debug"
	set desc = "Spawn a spreading plant effect."
	set name = "Spawn Plant"

	if(!check_rights(R_SPAWN))	return

	if(!seedtype || !SSplants.seeds[seedtype])
		return
	new /obj/effect/plant(get_turf(usr), SSplants.seeds[seedtype])
	log_admin("[key_name(usr)] spawned [seedtype] vines at ([usr.x],[usr.y],[usr.z])")

/datum/admins/proc/spawn_atom(var/object as text)
	set name = "Spawn"
	set category = "Debug"
	set desc = "(atom path) Spawn an atom"

	if(!check_rights(R_SPAWN))	return

	var/list/types = typesof(/atom)
	var/list/matches = new()

	for(var/path in types)
		if(findtext("[path]", object))
			matches += path

	if(matches.len==0)
		return

	var/chosen
	if(matches.len==1)
		chosen = matches[1]
	else
		chosen = tgui_input_list(usr, "Select an atom type", "Spawn Atom", matches)
		if(!chosen)
			return

	if(ispath(chosen,/turf))
		var/turf/T = get_turf(usr.loc)
		T.ChangeTurf(chosen)
	else
		new chosen(usr.loc)

	log_and_message_admins("spawned [chosen] at ([usr.x],[usr.y],[usr.z])")
	feedback_add_details("admin_verb","SA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/datum/admins/proc/show_traitor_panel(var/mob/M in mob_list)
	set category = "Admin"
	set desc = "Edit mobs's memory and role"
	set name = "Show Traitor Panel"

	if(!istype(M))
		to_chat(usr, "This can only be used on instances of type /mob")
		return
	if(!M.mind)
		to_chat(usr, "This mob has no mind!")
		return

	M.mind.edit_memory()
	feedback_add_details("admin_verb","STP") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/show_game_mode()
	set category = "Admin"
	set desc = "Show the current round configuration."
	set name = "Show Game Mode"

	if(!ticker || !ticker.mode)
		tgui_alert_async(usr, "Not before roundstart!", "Alert")
		return

	var/out = "<font size=3><b>Current mode: [ticker.mode.name] (<a href='?src=\ref[ticker.mode];[HrefToken()];debug_antag=self'>[ticker.mode.config_tag]</a>)</b></font><br/>"
	out += "<hr>"

	if(ticker.mode.ert_disabled)
		out += "<b>Emergency Response Teams:</b> <a href='?src=\ref[ticker.mode];[HrefToken()];toggle=ert'>disabled</a>"
	else
		out += "<b>Emergency Response Teams:</b> <a href='?src=\ref[ticker.mode];[HrefToken()];toggle=ert'>enabled</a>"
	out += "<br/>"

	if(ticker.mode.deny_respawn)
		out += "<b>Respawning:</b> <a href='?src=\ref[ticker.mode];[HrefToken()];toggle=respawn'>disallowed</a>"
	else
		out += "<b>Respawning:</b> <a href='?src=\ref[ticker.mode];[HrefToken()];toggle=respawn'>allowed</a>"
	out += "<br/>"

	out += "<b>Shuttle delay multiplier:</b> <a href='?src=\ref[ticker.mode];[HrefToken()];set=shuttle_delay'>[ticker.mode.shuttle_delay]</a><br/>"

	if(ticker.mode.auto_recall_shuttle)
		out += "<b>Shuttle auto-recall:</b> <a href='?src=\ref[ticker.mode];[HrefToken()];toggle=shuttle_recall'>enabled</a>"
	else
		out += "<b>Shuttle auto-recall:</b> <a href='?src=\ref[ticker.mode];[HrefToken()];toggle=shuttle_recall'>disabled</a>"
	out += "<br/><br/>"

	if(ticker.mode.event_delay_mod_moderate)
		out += "<b>Moderate event time modifier:</b> <a href='?src=\ref[ticker.mode];[HrefToken()];set=event_modifier_moderate'>[ticker.mode.event_delay_mod_moderate]</a><br/>"
	else
		out += "<b>Moderate event time modifier:</b> <a href='?src=\ref[ticker.mode];[HrefToken()];set=event_modifier_moderate'>unset</a><br/>"

	if(ticker.mode.event_delay_mod_major)
		out += "<b>Major event time modifier:</b> <a href='?src=\ref[ticker.mode];[HrefToken()];set=event_modifier_severe'>[ticker.mode.event_delay_mod_major]</a><br/>"
	else
		out += "<b>Major event time modifier:</b> <a href='?src=\ref[ticker.mode];[HrefToken()];set=event_modifier_severe'>unset</a><br/>"

	out += "<hr>"

	if(ticker.mode.antag_tags && ticker.mode.antag_tags.len)
		out += "<b>Core antag templates:</b></br>"
		for(var/antag_tag in ticker.mode.antag_tags)
			out += "<a href='?src=\ref[ticker.mode];[HrefToken()];debug_antag=[antag_tag]'>[antag_tag]</a>.</br>"

	if(ticker.mode.round_autoantag)
		out += "<b>Autotraitor <a href='?src=\ref[ticker.mode];[HrefToken()];toggle=autotraitor'>enabled</a></b>."
		if(ticker.mode.antag_scaling_coeff > 0)
			out += " (scaling with <a href='?src=\ref[ticker.mode];[HrefToken()];set=antag_scaling'>[ticker.mode.antag_scaling_coeff]</a>)"
		else
			out += " (not currently scaling, <a href='?src=\ref[ticker.mode];[HrefToken()];set=antag_scaling'>set a coefficient</a>)"
		out += "<br/>"
	else
		out += "<b>Autotraitor <a href='?src=\ref[ticker.mode];[HrefToken()];toggle=autotraitor'>disabled</a></b>.<br/>"

	out += "<b>All antag ids:</b>"
	if(ticker.mode.antag_templates && ticker.mode.antag_templates.len)
		for(var/datum/antagonist/antag in ticker.mode.antag_templates)
			antag.update_current_antag_max()
			out += " <a href='?src=\ref[ticker.mode];[HrefToken()];debug_antag=[antag.id]'>[antag.id]</a>"
			out += " ([antag.get_antag_count()]/[antag.cur_max]) "
			out += " <a href='?src=\ref[ticker.mode];[HrefToken()];remove_antag_type=[antag.id]'>\[-\]</a><br/>"
	else
		out += " None."
	out += " <a href='?src=\ref[ticker.mode];[HrefToken()];add_antag_type=1'>\[+\]</a><br/>"

	usr << browse(out, "window=edit_mode[src]")
	feedback_add_details("admin_verb","SGM")


/datum/admins/proc/toggletintedweldhelmets()
	set category = "Debug"
	set desc="Reduces view range when wearing welding helmets"
	set name="Toggle tinted welding helmets."
	config.welder_vision = !( config.welder_vision )
	if (config.welder_vision)
		to_world("<B>Reduced welder vision has been enabled!</B>")
	else
		to_world("<B>Reduced welder vision has been disabled!</B>")
	log_admin("[key_name(usr)] toggled welder vision.")
	message_admins("[key_name_admin(usr)] toggled welder vision.", 1)
	feedback_add_details("admin_verb","TTWH") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/toggleguests()
	set category = "Server"
	set desc="Guests can't enter"
	set name="Toggle guests"
	config.guests_allowed = !(config.guests_allowed)
	if (!(config.guests_allowed))
		to_world("<B>Guests may no longer enter the game.</B>")
	else
		to_world("<B>Guests may now enter the game.</B>")
	log_admin("[key_name(usr)] toggled guests game entering [config.guests_allowed?"":"dis"]allowed.")
	message_admins(span_blue("[key_name_admin(usr)] toggled guests game entering [config.guests_allowed?"":"dis"]allowed."), 1)
	feedback_add_details("admin_verb","TGU") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/output_ai_laws()
	var/ai_number = 0
	for(var/mob/living/silicon/S in mob_list)
		ai_number++
		if(isAI(S))
			to_chat(usr, "<b>AI [key_name(S, usr)]'s laws:</b>")
		else if(isrobot(S))
			var/mob/living/silicon/robot/R = S
			to_chat(usr, "<b>CYBORG [key_name(S, usr)] [R.connected_ai?"(Slaved to: [R.connected_ai])":"(Independent)"]: laws:</b>")
		else if (ispAI(S))
			to_chat(usr, "<b>pAI [key_name(S, usr)]'s laws:</b>")
		else
			to_chat(usr, "<b>SOMETHING SILICON [key_name(S, usr)]'s laws:</b>")

		if (S.laws == null)
			to_chat(usr, "[key_name(S, usr)]'s laws are null?? Contact a coder.")
		else
			S.laws.show_laws(usr)
	if(!ai_number)
		to_chat(usr, "<b>No AIs located</b>") //Just so you know the thing is actually working and not just ignoring you.

/datum/admins/proc/show_skills()
	set category = "Admin"
	set name = "Show Skills"

	if (!istype(src,/datum/admins))
		src = usr.client.holder
	if (!istype(src,/datum/admins))
		to_chat(usr, "Error: you are not an admin!")
		return

	var/mob/living/carbon/human/M = tgui_input_list(usr, "Select mob.", "Select mob.", human_mob_list)
	if(!M) return

	show_skill_window(usr, M)

	return

/client/proc/update_mob_sprite(mob/living/carbon/human/H as mob)
	set category = "Admin"
	set name = "Update Mob Sprite"
	set desc = "Should fix any mob sprite update errors."

	if (!holder)
		to_chat(src, "Only administrators may use this command.")
		return

	if(istype(H))
		H.regenerate_icons()

/proc/get_options_bar(whom, detail = 2, name = 0, link = 1, highlight_special = 1)
	if(!whom)
		return "<b>(*null*)</b>"
	var/mob/M
	var/client/C
	if(istype(whom, /client))
		C = whom
		M = C.mob
	else if(istype(whom, /mob))
		M = whom
		C = M.client
	else
		return "<b>(*not a mob*)</b>"
	switch(detail)
		if(0)
			return "<b>[key_name(C, link, name, highlight_special)]</b>"

		if(1)	//Private Messages
			return "<b>[key_name(C, link, name, highlight_special)](<A HREF='?_src_=holder;[HrefToken()];adminmoreinfo=\ref[M]'>?</A>)</b>"

		if(2)	//Admins
			var/ref_mob = "\ref[M]"
			return "<b>[key_name(C, link, name, highlight_special)](<A HREF='?_src_=holder;[HrefToken()];adminmoreinfo=[ref_mob]'>?</A>) (<A HREF='?_src_=holder;[HrefToken()];adminplayeropts=[ref_mob]'>PP</A>) (<A HREF='?_src_=vars;[HrefToken()];Vars=[ref_mob]'>VV</A>) (<A HREF='?_src_=holder;[HrefToken()];subtlemessage=[ref_mob]'>SM</A>) ([admin_jump_link(M)]) (<A HREF='?_src_=holder;[HrefToken()];check_antagonist=1'>CA</A>) (<A HREF='?_src_=holder;[HrefToken()];take_question=\ref[M]'>TAKE</A>)</b>"

		if(3)	//Devs
			var/ref_mob = "\ref[M]"
			return "<b>[key_name(C, link, name, highlight_special)](<A HREF='?_src_=vars;[HrefToken()];Vars=[ref_mob]'>VV</A>)([admin_jump_link(M)]) (<A HREF='?_src_=holder;[HrefToken()];take_question=\ref[M]'>TAKE</A>)</b>"

		if(4)	//Event Managers
			var/ref_mob = "\ref[M]"
			return "<b>[key_name(C, link, name, highlight_special)] (<A HREF='?_src_=holder;[HrefToken()];adminmoreinfo=\ref[M]'>?</A>) (<A HREF='?_src_=holder;[HrefToken()];adminplayeropts=[ref_mob]'>PP</A>) (<A HREF='?_src_=vars;[HrefToken()];Vars=[ref_mob]'>VV</A>) (<A HREF='?_src_=holder;[HrefToken()];subtlemessage=[ref_mob]'>SM</A>) ([admin_jump_link(M)]) (<A HREF='?_src_=holder;[HrefToken()];take_question=\ref[M]'>TAKE</A>)</b>"


/proc/ishost(whom)
	if(!whom)
		return 0
	var/client/C
	var/mob/M
	if(istype(whom, /client))
		C = whom
	if(istype(whom, /mob))
		M = whom
		C = M.client
	if(R_HOST & C.holder.rights)
		return 1
	else
		return 0
//
//
//ALL DONE
//*********************************************************************************************************
//

//Returns 1 to let the dragdrop code know we are trapping this event
//Returns 0 if we don't plan to trap the event
/datum/admins/proc/cmd_ghost_drag(var/mob/observer/dead/frommob, var/mob/living/tomob)
	if(!istype(frommob))
		return //Extra sanity check to make sure only observers are shoved into things

	//Same as assume-direct-control perm requirements.
	if (!check_rights(R_VAREDIT,0) || !check_rights(R_ADMIN|R_DEBUG|R_EVENT,0))
		return 0
	if (!frommob.ckey)
		return 0
	var/question = ""
	if (tomob.ckey)
		question = "This mob already has a user ([tomob.key]) in control of it! "
	question += "Are you sure you want to place [frommob.name]([frommob.key]) in control of [tomob.name]?"
	var/ask = tgui_alert(usr, question, "Place ghost in control of mob?", list("Yes", "No"))
	if (ask != "Yes")
		return 1
	if (!frommob || !tomob) //make sure the mobs don't go away while we waited for a response
		return 1
	if(tomob.client) //No need to ghostize if there is no client
		tomob.ghostize(0)
	if(frommob.mind && frommob.mind.current) //Preserve teleop for original body when adminghosting.
		var/mob/body = frommob.mind.current
		if(body)
			if(body.teleop)
				body.teleop = tomob
	message_admins("<span class='adminnotice'>[key_name_admin(usr)] has put [frommob.ckey] in control of [tomob.name].</span>")
	log_admin("[key_name(usr)] stuffed [frommob.ckey] into [tomob.name].")
	feedback_add_details("admin_verb","CGD")
	tomob.ckey = frommob.ckey
	qdel(frommob)
	return 1

/datum/admins/proc/force_antag_latespawn()
	set category = "Admin"
	set name = "Force Template Spawn"
	set desc = "Force an antagonist template to spawn."

	if (!istype(src,/datum/admins))
		src = usr.client.holder
	if (!istype(src,/datum/admins))
		to_chat(usr, "Error: you are not an admin!")
		return

	if(!ticker || !ticker.mode)
		to_chat(usr, "Mode has not started.")
		return

	var/antag_type = tgui_input_list(usr, "Choose a template.","Force Latespawn", all_antag_types)
	if(!antag_type || !all_antag_types[antag_type])
		to_chat(usr, "Aborting.")
		return

	var/datum/antagonist/antag = all_antag_types[antag_type]
	message_admins("[key_name(usr)] attempting to force latespawn with template [antag.id].")
	antag.attempt_late_spawn()

/datum/admins/proc/force_mode_latespawn()
	set category = "Admin"
	set name = "Force Mode Spawn"
	set desc = "Force autotraitor to proc."

	if (!istype(src,/datum/admins))
		src = usr.client.holder
	if (!istype(src,/datum/admins) || !check_rights(R_ADMIN|R_EVENT|R_FUN))
		to_chat(usr, "Error: you are not an admin!")
		return

	if(!ticker || !ticker.mode)
		to_chat(usr, "Mode has not started.")
		return

	log_and_message_admins("attempting to force mode autospawn.")
	ticker.mode.try_latespawn()

/datum/admins/proc/paralyze_mob(mob/living/H as mob)
	set category = "Admin"
	set name = "Toggle Paralyze"
	set desc = "Paralyzes a player. Or unparalyses them."

	var/msg

	if(check_rights(R_ADMIN|R_MOD|R_EVENT))
		if (H.paralysis == 0)
			H.SetParalysis(8000)
			msg = "has paralyzed [key_name(H)]."
			log_and_message_admins(msg)
		else
			if(tgui_alert(src, "[key_name(H)] is paralyzed, would you like to unparalyze them?","Paralyze Mob",list("Yes","No")) == "Yes")
				H.SetParalysis(0)
				msg = "has unparalyzed [key_name(H)]."
				log_and_message_admins(msg)

/datum/admins/proc/set_tcrystals(mob/living/carbon/human/H as mob)
	set category = "Debug"
	set name = "Set Telecrystals"
	set desc = "Allows admins to change telecrystals of a user."
	set popup_menu = FALSE //VOREStation Edit - Declutter.
	var/crystals

	if(check_rights(R_ADMIN|R_EVENT))
		crystals = tgui_input_number(usr, "Amount of telecrystals for [H.ckey], currently [H.mind.tcrystals].", crystals)
		if (!isnull(crystals))
			H.mind.tcrystals = crystals
			var/msg = "[key_name(usr)] has modified [H.ckey]'s telecrystals to [crystals]."
			message_admins(msg)
	else
		to_chat(usr, "You do not have access to this command.")

/datum/admins/proc/add_tcrystals(mob/living/carbon/human/H as mob)
	set category = "Debug"
	set name = "Add Telecrystals"
	set desc = "Allows admins to change telecrystals of a user by addition."
	set popup_menu = FALSE //VOREStation Edit - Declutter.
	var/crystals

	if(check_rights(R_ADMIN|R_EVENT))
		crystals = tgui_input_number(usr, "Amount of telecrystals to give to [H.ckey], currently [H.mind.tcrystals].", crystals)
		if (!isnull(crystals))
			H.mind.tcrystals += crystals
			var/msg = "[key_name(usr)] has added [crystals] to [H.ckey]'s telecrystals."
			message_admins(msg)
	else
		to_chat(usr, "You do not have access to this command.")


/datum/admins/proc/sendFax()
	set category = "Special Verbs"
	set name = "Send Fax"
	set desc = "Sends a fax to this machine"
	var/department = tgui_input_list(usr, "Choose a fax", "Fax", alldepartments)
	for(var/obj/machinery/photocopier/faxmachine/sendto in allfaxes)
		if(sendto.department == department)

			if (!istype(src,/datum/admins))
				src = usr.client.holder
			if (!istype(src,/datum/admins))
				to_chat(usr, "Error: you are not an admin!")
				return

			var/replyorigin = tgui_input_text(src.owner, "Please specify who the fax is coming from", "Origin")

			var/obj/item/weapon/paper/admin/P = new /obj/item/weapon/paper/admin( null ) //hopefully the null loc won't cause trouble for us
			faxreply = P

			P.admindatum = src
			P.origin = replyorigin
			P.destination = sendto

			P.adminbrowse()


/datum/admins/var/obj/item/weapon/paper/admin/faxreply // var to hold fax replies in

/datum/admins/proc/faxCallback(var/obj/item/weapon/paper/admin/P, var/obj/machinery/photocopier/faxmachine/destination)
	var/customname = tgui_input_text(src.owner, "Pick a title for the report", "Title")

	P.name = "[P.origin] - [customname]"
	P.desc = "This is a paper titled '" + P.name + "'."

	var/shouldStamp = 1
	if(!P.sender) // admin initiated
		if(tgui_alert(usr, "Would you like the fax stamped?","Stamped?", list("Yes", "No")) != "Yes")
			shouldStamp = 0

	if(shouldStamp)
		P.stamps += "<hr><i>This paper has been stamped by the [P.origin] Quantum Relay.</i>"

		var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
		var/x = rand(-2, 0)
		var/y = rand(-1, 2)
		P.offset_x += x
		P.offset_y += y
		stampoverlay.pixel_x = x
		stampoverlay.pixel_y = y

		if(!P.ico)
			P.ico = new
		P.ico += "paper_stamp-cent"
		stampoverlay.icon_state = "paper_stamp-cent"

		if(!P.stamped)
			P.stamped = new
		P.stamped += /obj/item/weapon/stamp/centcomm
		P.add_overlay(stampoverlay)

	var/obj/item/rcvdcopy
	rcvdcopy = destination.copy(P)
	rcvdcopy.loc = null //hopefully this shouldn't cause trouble
	adminfaxes += rcvdcopy



	if(destination.receivefax(P))
		to_chat(src.owner, "<span class='notice'>Message reply to transmitted successfully.</span>")
		if(P.sender) // sent as a reply
			log_admin("[key_name(src.owner)] replied to a fax message from [key_name(P.sender)]")
			for(var/client/C in GLOB.admins)
				if((R_ADMIN | R_MOD | R_EVENT) & C.holder.rights)
					to_chat(C, "<span class='log_message'><span class='prefix'>FAX LOG:</span>[key_name_admin(src.owner)] replied to a fax message from [key_name_admin(P.sender)] (<a href='?_src_=holder;[HrefToken()];AdminFaxView=\ref[rcvdcopy]'>VIEW</a>)</span>")
		else
			log_admin("[key_name(src.owner)] has sent a fax message to [destination.department]")
			for(var/client/C in GLOB.admins)
				if((R_ADMIN | R_MOD | R_EVENT) & C.holder.rights)
					to_chat(C, "<span class='log_message'><span class='prefix'>FAX LOG:</span>[key_name_admin(src.owner)] has sent a fax message to [destination.department] (<a href='?_src_=holder;[HrefToken()];AdminFaxView=\ref[rcvdcopy]'>VIEW</a>)</span>")

		var/plaintext_title = P.sender ? "replied to [key_name(P.sender)]'s fax" : "sent a fax message to [destination.department]"
		var/fax_text = paper_html_to_plaintext(P.info)
		log_game(plaintext_title)
		log_game(fax_text)

		SSwebhooks.send(
			WEBHOOK_FAX_SENT,
			list(
				"name" = "[key_name(owner)] [plaintext_title].",
				"body" = fax_text
			)
		)

	else
		to_chat(src.owner, "<span class='warning'>Message reply failed.</span>")

	spawn(100)
		qdel(P)
		faxreply = null
	return
