/obj/machinery/photocopier/faxmachine
	req_one_access = list()

/**
 * Write the fax to disk as (potentially multiple) HTML files.
 * If the fax is a paper_bundle, do so recursively for each page.
 * returns a random unique faxid.
 */
/obj/machinery/photocopier/faxmachine/proc/export_fax(fax)
	var faxid = "[num2text(world.realtime,12)]_[rand(10000)]"
	if (istype(fax, /obj/item/weapon/paper))
		var/obj/item/weapon/paper/P = fax
		var/text = "<HTML><HEAD><TITLE>[P.name]</TITLE></HEAD><BODY>[P.info][P.stamps]</BODY></HTML>";
		file("[config.fax_export_dir]/fax_[faxid].html") << text;
	else if (istype(fax, /obj/item/weapon/photo))
		var/obj/item/weapon/photo/H = fax
		fcopy(H.img, "[config.fax_export_dir]/photo_[faxid].png")
		var/text = "<html><head><title>[H.name]</title></head>" \
			+ "<body style='overflow:hidden;margin:0;text-align:center'>" \
			+ "<img src='photo_[faxid].png'>" \
			+ "[H.scribble ? "<br>Written on the back:<br><i>[H.scribble]</i>" : ""]"\
			+ "</body></html>"
		file("[config.fax_export_dir]/fax_[faxid].html") << text
	else if (istype(fax, /obj/item/weapon/paper_bundle))
		var/obj/item/weapon/paper_bundle/B = fax
		var/data = ""
		for (var/page = 1, page <= B.pages.len, page++)
			var/obj/pageobj = B.pages[page]
			var/page_faxid = export_fax(pageobj)
			data += "<a href='fax_[page_faxid].html'>Page [page] - [pageobj.name]</a><br>"
		var/text = "<html><head><title>[B.name]</title></head><body>[data]</body></html>"
		file("[config.fax_export_dir]/fax_[faxid].html") << text
	return faxid

/**
 * Call the chat webhook to transmit a notification of an admin fax to the admin chat.
 */
/obj/machinery/photocopier/faxmachine/proc/message_chat_admins(var/mob/sender, var/faxname, var/obj/item/sent, var/faxid, font_colour="#006100")
	if (config.chat_webhook_url)
		spawn(0)
			var/query_string = "type=fax"
			query_string += "&key=[url_encode(config.chat_webhook_key)]"
			query_string += "&faxid=[url_encode(faxid)]"
			query_string += "&color=[url_encode(font_colour)]"
			query_string += "&faxname=[url_encode(faxname)]"
			query_string += "&sendername=[url_encode(sender.name)]"
			query_string += "&sentname=[url_encode(sent.name)]"
			world.Export("[config.chat_webhook_url]?[query_string]")

//
// Overrides/additions to stock defines go here, as well as hooks. Sort them by
// the object they are overriding. So all /mob/living together, etc.
//
/datum/configuration
	var/chat_webhook_url = ""		// URL of the webhook for sending announcements/faxes to discord chat.
	var/chat_webhook_key = ""		// Shared secret for authenticating to the chat webhook
	var/fax_export_dir = "data/faxes"	// Directory in which to write exported fax HTML files.
