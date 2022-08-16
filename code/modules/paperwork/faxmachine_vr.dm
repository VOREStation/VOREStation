var/global/last_fax_role_request

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

/**
 * Call the chat webhook to transmit a notification of a job request
 */
/obj/machinery/photocopier/faxmachine/proc/message_chat_rolerequest(var/font_colour="#006100", var/role_to_ping, var/reason, var/jobname)
	if(config.chat_webhook_url)
		spawn(0)
			var/query_string = "type=rolerequest"
			query_string += "&key=[url_encode(config.chat_webhook_key)]"
			query_string += "&ping=[url_encode(role_to_ping)]"
			query_string += "&color=[url_encode(font_colour)]"
			query_string += "&reason=[url_encode(reason)]"
			query_string += "&job=[url_encode(jobname)]"
			world.Export("[config.chat_webhook_url]?[query_string]")

//
// Overrides/additions to stock defines go here, as well as hooks. Sort them by
// the object they are overriding. So all /mob/living together, etc.
//
/datum/configuration
	var/chat_webhook_url = ""		// URL of the webhook for sending announcements/faxes to discord chat.
	var/chat_webhook_key = ""		// Shared secret for authenticating to the chat webhook
	var/fax_export_dir = "data/faxes"	// Directory in which to write exported fax HTML files.


/obj/machinery/photocopier/faxmachine/verb/request_roles()
	set name = "Staff Request Form"
	set category = "Object"
	set src in oview(1)

	var/mob/living/L = usr

	if(!L || !isturf(L.loc) || !isliving(L))
		return
	if(!ishuman(L) && !issilicon(L))
		return
	if(L.stat || L.restrained())
		return
	if(last_fax_role_request && (world.time - last_fax_role_request < 5 MINUTES))
		to_chat(L, "<span class='warning'>The global automated relays are still recalibrating. Try again later or relay your request in written form for processing.</span>")
		return

	var/confirmation = tgui_alert(L, "Are you sure you want to send automated crew request?", "Confirmation", list("Yes", "No", "Cancel"))
	if(confirmation != "Yes")
		return

	var/list/jobs = list()
	for(var/datum/department/dept as anything in SSjob.get_all_department_datums())
		if(!dept.assignable || dept.centcom_only)
			continue
		for(var/job in SSjob.get_job_titles_in_department(dept.name))
			var/datum/job/J = SSjob.get_job(job)
			if(J.requestable)
				jobs |= job

	var/role = tgui_input_list(L, "Pick the job to request.", "Job Request", jobs)
	if(!role)
		return

	var/datum/job/job_to_request = SSjob.get_job(role)
	var/reason = "Unspecified"
	var/list/possible_reasons = list("Unspecified", "General duties", "Emergency situation")
	possible_reasons += job_to_request.get_request_reasons()
	reason = tgui_input_list(L, "Pick request reason.", "Request reason", possible_reasons)

	var/final_conf = tgui_alert(L, "You are about to request [role]. Are you sure?", "Confirmation", list("Yes", "No", "Cancel"))
	if(final_conf != "Yes")
		return

	var/datum/department/ping_dept = SSjob.get_ping_role(role)
	if(!ping_dept)
		to_chat(L, "<span class='warning'>Selected job cannot be requested for \[ERRORDEPTNOTFOUND] reason. Please report this to system administrator.</span>")
		return
	var/message_color = "#FFFFFF"
	var/ping_name = null
	switch(ping_dept.name)
		if(DEPARTMENT_COMMAND)
			ping_name = "Command"
		if(DEPARTMENT_SECURITY)
			ping_name = "Security"
		if(DEPARTMENT_ENGINEERING)
			ping_name = "Engineering"
		if(DEPARTMENT_MEDICAL)
			ping_name = "Medical"
		if(DEPARTMENT_RESEARCH)
			ping_name = "Research"
		if(DEPARTMENT_CARGO)
			ping_name = "Supply"
		if(DEPARTMENT_CIVILIAN)
			ping_name = "Service"
		if(DEPARTMENT_PLANET)
			ping_name = "Expedition"
		if(DEPARTMENT_SYNTHETIC)
			ping_name = "Silicon"
		//if(DEPARTMENT_TALON)
		//	ping_name = "Offmap"
	if(!ping_name)
		to_chat(L, "<span class='warning'>Selected job cannot be requested for \[ERRORUNKNOWNDEPT] reason. Please report this to system administrator.</span>")
		return
	message_color = ping_dept.color

	message_chat_rolerequest(message_color, ping_name, reason, role)
	last_fax_role_request = world.time
	to_chat(L, "<span class='notice'>Your request was transmitted.</span>")
