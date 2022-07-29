#define NEWSFILE "data/news.sav"	//where the memos are saved

/client/
	//var/last_news_hash = null // Stores a hash of the last news window it saw, which gets compared to the current one to see if it is different.

// Returns true if news was updated since last seen.
/client/proc/check_for_new_server_news()
	var/savefile/F = get_server_news()
	if(F)
		if(md5(F["body"]) != prefs.lastnews)
			return TRUE
	return FALSE

/client/proc/modify_server_news()
	set name = "Modify Public News"
	set category = "Server"

	if(!check_rights(0))
		return

	var/savefile/F = new(NEWSFILE)
	if(F)
		var/title = F["title"]
		var/body = html2paper_markup(F["body"])
		var/new_title = sanitize(tgui_input_text(src,"Write a good title for the news update.  Note: HTML is NOT supported.","Write News", title), extra = 0)
		if(!new_title)
			return
		var/new_body = sanitize(tgui_input_text(src,"Write the body of the news update here. Note: HTML is NOT supported, however paper markup is supported.  \n\
		Hitting enter will automatically add a line break.  \n\
		Valid markup includes: \[b\], \[i\], \[u\], \[large\], \[h1\], \[h2\], \[h3\]\ \[*\], \[hr\], \[small\], \[list\], \[table\], \[grid\], \
		\[row\], \[cell\], \[logo\], \[sglogo\].","Write News", body, multiline = TRUE, prevent_enter = TRUE), extra = 0)

		new_body = paper_markup2html(new_body)

		if(findtext(new_body,"<script",1,0) ) // Is this needed with santize()?
			return
		F["title"] << new_title
		F["body"] << new_body
		F["author"] << key
		F["timestamp"] << time2text(world.realtime, "DDD, MMM DD YYYY")
		message_admins("[key] modified the news to read:<br>[new_title]<br>[new_body]")

/proc/get_server_news()
	var/savefile/F = new(NEWSFILE)
	if(F)
		return F
// This is used when submitting the news input, so the safe markup can get past sanitize.
/proc/paper_markup2html(var/text)
	text = replacetext(text, "\n", "<br>")
	text = replacetext(text, "\[center\]", "<center>")
	text = replacetext(text, "\[/center\]", "</center>")
	text = replacetext(text, "\[br\]", "<BR>")
	text = replacetext(text, "\[b\]", "<B>")
	text = replacetext(text, "\[/b\]", "</B>")
	text = replacetext(text, "\[i\]", "<I>")
	text = replacetext(text, "\[/i\]", "</I>")
	text = replacetext(text, "\[u\]", "<U>")
	text = replacetext(text, "\[/u\]", "</U>")
	text = replacetext(text, "\[large\]", "<font size=\"4\">")
	text = replacetext(text, "\[/large\]", "</font>")
	text = replacetext(text, "\[h1\]", "<H1>")
	text = replacetext(text, "\[/h1\]", "</H1>")
	text = replacetext(text, "\[h2\]", "<H2>")
	text = replacetext(text, "\[/h2\]", "</H2>")
	text = replacetext(text, "\[h3\]", "<H3>")
	text = replacetext(text, "\[/h3\]", "</H3>")

	text = replacetext(text, "\[*\]", "<li>")
	text = replacetext(text, "\[hr\]", "<HR>")
	text = replacetext(text, "\[small\]", "<font size = \"1\">")
	text = replacetext(text, "\[/small\]", "</font>")
	text = replacetext(text, "\[list\]", "<ul>")
	text = replacetext(text, "\[/list\]", "</ul>")
	text = replacetext(text, "\[table\]", "<table border=1 cellspacing=0 cellpadding=3 style='border: 1px solid black;'>")
	text = replacetext(text, "\[/table\]", "</td></tr></table>")
	text = replacetext(text, "\[grid\]", "<table>")
	text = replacetext(text, "\[/grid\]", "</td></tr></table>")
	text = replacetext(text, "\[row\]", "</td><tr>")
	text = replacetext(text, "\[cell\]", "<td>")
	text = replacetext(text, "\[logo\]", "<img src = ntlogo.png>") // Not sure if these would get used but why not
	text = replacetext(text, "\[sglogo\]", "<img src = sglogo.png>")
	return text

// This is used when reading text that went through paper_markup2html(), to reverse it so that edits don't need to replace everything once more to avoid sanitization.
/proc/html2paper_markup(var/text)
	text = replacetext(text, "<br>", "\[br\]")
	text = replacetext(text, "<center>", "\[center\]")
	text = replacetext(text, "</center>", "\[/center\]")
	text = replacetext(text, "<BR>", "\[br\]")
	text = replacetext(text, "<B>", "\[b\]")
	text = replacetext(text, "</B>", "\[/b\]")
	text = replacetext(text, "<I>", "\[i\]")
	text = replacetext(text, "</I>", "\[/i\]")
	text = replacetext(text, "<U>", "\[u\]")
	text = replacetext(text, "</U>", "\[/u\]")
	text = replacetext(text, "<font size=\"4\">", "\[large\]")
	text = replacetext(text, "</font>", "\[/large\]")
	text = replacetext(text, "<H1>", "\[h1\]")
	text = replacetext(text, "</H1>", "\[/h1\]")
	text = replacetext(text, "<H2>", "\[h2\]")
	text = replacetext(text, "</H2>", "\[/h2\]")
	text = replacetext(text, "<H3>", "\[h3\]")
	text = replacetext(text, "</H3>", "\[/h3\]")

	text = replacetext(text, "<li>", "\[*\]")
	text = replacetext(text, "<HR>", "\[hr\]")
	text = replacetext(text, "<font size = \"1\">", "\[small\]")
	text = replacetext(text, "</font>", "\[/small\]")
	text = replacetext(text, "<ul>", "\[list\]")
	text = replacetext(text, "</ul>", "\[/list\]")
	text = replacetext(text, "<table border=1 cellspacing=0 cellpadding=3 style='border: 1px solid black;'>", "\[table\]")
	text = replacetext(text, "</td></tr></table>", "\[/table\]")
	text = replacetext(text, "<table>", "\[grid\]")
	text = replacetext(text, "</td></tr></table>", "\[/grid\]")
	text = replacetext(text, "</td><tr>", "\[row\]")
	text = replacetext(text, "<td>", "\[cell\]")
	text = replacetext(text, "<img src = ntlogo.png>", "\[logo\]") // Not sure if these would get used but why not
	text = replacetext(text, "<img src = sglogo.png>", "\[sglogo\]")
	return text

#undef NEWSFILE