//Adminpaper - it's like paper, but more adminny!
/obj/item/paper/admin
	name = "administrative paper"
	desc = "If you see this, something has gone horribly wrong."
	var/datum/admins/admindatum = null

	var/interactions = null
	var/isCrayon = 0
	var/origin = null
	var/mob/sender = null
	var/obj/machinery/photocopier/faxmachine/destination

	var/header = null
	var/headerOn = TRUE

	var/footer = null
	var/footerOn = FALSE

/obj/item/paper/admin/Initialize()
	. = ..()
	generateInteractions()


/obj/item/paper/admin/proc/generateInteractions()
	//clear first
	interactions = null

	//Snapshot is crazy and likes putting each topic hyperlink on a seperate line from any other tags so it's nice and clean.
	interactions += "<HR><center><font size= \"1\">The fax will transmit everything above this line</font><br>"
	interactions += "<A href='?src=\ref[src];confirm=1'>Send fax</A> "
	interactions += "<A href='?src=\ref[src];penmode=1'>Pen mode: [isCrayon ? "Crayon" : "Pen"]</A> "
	interactions += "<A href='?src=\ref[src];cancel=1'>Cancel fax</A> "
	interactions += "<BR>"
	interactions += "<A href='?src=\ref[src];toggleheader=1'>Toggle Header</A> "
	interactions += "<A href='?src=\ref[src];togglefooter=1'>Toggle Footer</A> "
	interactions += "<A href='?src=\ref[src];clear=1'>Clear page</A> "
	interactions += "</center>"

/obj/item/paper/admin/proc/generateHeader()
	var/originhash = md5("[origin]")
	var/timehash = copytext(md5("[world.time]"),1,10)
	var/text = null
	var/logo = tgui_alert(usr, "Do you want the header of your fax to have a NanoTrasen, SolGov, or Trader logo?","Fax Logo",list("NanoTrasen","SolGov","Trader")) //VOREStation Add - Trader
	if(logo == "SolGov")
		logo = "sglogo.png"
	//VOREStation Edit/Add
	else if(logo == "NanoTrasen")
		logo = "ntlogo.png"
	else
		logo = "trader.png"
	//VOREStation Edit/Add End
	//TODO change logo based on who you're contacting.
	text = "<center><img src = [logo]></br>"
	text += "<b>[origin] Quantum Uplink Signed Message</b><br>"
	text += "<font size = \"1\">Encryption key: [originhash]<br>"
	text += "Challenge: [timehash]<br></font></center><hr>"

	header = text

/obj/item/paper/admin/proc/generateFooter()
	var/text = null

	text = "<hr><font size= \"1\">"
	text += "This transmission is intended only for the addressee and may contain confidential information. Any unauthorized disclosure is strictly prohibited. <br><br>"
	text += "If this transmission is received in error, please notify both the sender and the office of [using_map.boss_name] Internal Affairs immediately so that corrective action may be taken."
	text += "Failure to comply is a breach of regulation and may be prosecuted to the fullest extent of the law, where applicable."
	text += "</font>"

	footer = text


/obj/item/paper/admin/proc/adminbrowse()
	updateinfolinks()
	generateHeader()
	generateFooter()
	updateDisplay()

/obj/item/paper/admin/proc/updateDisplay()
	usr << browse("<HTML><HEAD><TITLE>[name]</TITLE></HEAD><BODY>[headerOn ? header : ""][info_links][stamps][footerOn ? footer : ""][interactions]</BODY></HTML>", "window=[name];can_close=0")



/obj/item/paper/admin/Topic(href, href_list)
	if(href_list["write"])
		var/id = href_list["write"]
		if(free_space <= 0)
			to_chat(usr, "<span class='info'>There isn't enough space left on \the [src] to write anything.</span>")
			return

		var/raw_t = tgui_input_text(usr, "Enter what you want to write:", "Write", multiline = TRUE, prevent_enter = TRUE)
		if(!raw_t)
			return
		var/t =  sanitize(raw_t, free_space, extra = 0)
		if(!t)
			return

		var last_fields_value = fields

		//t = html_encode(t)
		t = replacetext(t, "\n", "<BR>")
		t = parsepencode(t,,, isCrayon) // Encode everything from pencode to html


		if(fields > 50)//large amount of fields creates a heavy load on the server, see updateinfolinks() and addtofield()
			to_chat(usr, "<span class='warning'>Too many fields. Sorry, you can't do this.</span>")
			fields = last_fields_value
			return

		if(id!="end")
			addtofield(text2num(id), t) // He wants to edit a field, let him.
		else
			info += t // Oh, he wants to edit to the end of the file, let him.
			updateinfolinks()

		update_space(t)

		updateDisplay()

		update_icon()
		return

	if(href_list["confirm"])
		switch(tgui_alert(usr, "Are you sure you want to send the fax as is?","Send Fax", list("Yes", "No")))
			if("Yes")
				if(headerOn)
					info = header + info
				if(footerOn)
					info += footer
				updateinfolinks()
				usr << browse(null, "window=[name]")
				admindatum.faxCallback(src, destination)
		return

	if(href_list["penmode"])
		isCrayon = !isCrayon
		generateInteractions()
		updateDisplay()
		return

	if(href_list["cancel"])
		usr << browse(null, "window=[name]")
		qdel(src)
		return

	if(href_list["clear"])
		clearpaper()
		updateDisplay()
		return

	if(href_list["toggleheader"])
		headerOn = !headerOn
		updateDisplay()
		return

	if(href_list["togglefooter"])
		footerOn = !footerOn
		updateDisplay()
		return

/obj/item/paper/admin/get_signature()
	return tgui_input_text(usr, "Enter the name you wish to sign the paper with (will prompt for multiple entries, in order of entry)", "Signature")
