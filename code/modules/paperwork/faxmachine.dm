var/list/obj/machinery/photocopier/faxmachine/allfaxes = list()
var/list/admin_departments = list("[using_map.boss_name]", "Virgo-Prime Governmental Authority", "Virgo-Erigonne Job Boards", "Supply")
var/list/alldepartments = list()
var/global/last_fax_role_request

var/list/adminfaxes = list()	//cache for faxes that have been sent to admins

/obj/machinery/photocopier/faxmachine
	name = "fax machine"
	desc = "Send papers and pictures far away! Or to your co-worker's office a few doors down."
	icon = 'icons/obj/library.dmi'
	icon_state = "fax"
	insert_anim = "faxsend"
	req_one_access = list()
	density = 0

	use_power = USE_POWER_IDLE
	idle_power_usage = 30
	active_power_usage = 200
	circuit = /obj/item/circuitboard/fax

	var/obj/item/card/id/scan = null
	var/authenticated = null
	var/rank = null

	var/sendcooldown = 0 // to avoid spamming fax messages
	var/department = "Unknown" // our department
	var/destination = null // the department we're sending to
	var/talon = 0 // So that the talon can access their own crew roles for the request

/obj/machinery/photocopier/faxmachine/Initialize(mapload)
	. = ..()
	allfaxes += src
	if(!destination) destination = "[using_map.boss_name]"
	if( !(("[department]" in alldepartments) || ("[department]" in admin_departments)) )
		alldepartments |= department

/obj/machinery/photocopier/faxmachine/attack_hand(mob/user as mob)
	user.set_machine(src)

	tgui_interact(user)

/obj/machinery/photocopier/faxmachine/verb/remove_card()
	set name = "Remove ID card"
	set category = "Object"
	set src in oview(1)

	var/mob/living/L = usr

	if(!L || !isturf(L.loc) || !isliving(L))
		return
	if(!ishuman(L) && !issilicon(L))
		return
	if(L.stat || L.restrained())
		return
	if(!scan)
		to_chat(L, span_notice("There is no I.D card to remove!"))
		return

	scan.forceMove(loc)
	if(ishuman(L) && !L.get_active_hand())
		L.put_in_hands(scan)
		scan = null
	authenticated = null

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
		to_chat(L, span_warning("The global automated relays are still recalibrating. Try again later or relay your request in written form for processing."))
		return

	var/confirmation = tgui_alert(L, "Are you sure you want to send automated crew request?", "Confirmation", list("Yes", "No", "Cancel"))
	if(confirmation != "Yes")
		return

	var/list/jobs = list()
	for(var/datum/department/dept as anything in SSjob.get_all_department_datums())
		if(!src.talon)
			if(!dept.assignable || dept.centcom_only)
				continue
			for(var/job in SSjob.get_job_titles_in_department(dept.name))
				var/datum/job/J = SSjob.get_job(job)
				if(J.requestable)
					jobs |= job
		else
			for(var/job in SSjob.get_job_titles_in_department(dept.name))
				var/datum/job/J = SSjob.get_job(job)
				if(J.offmap_spawn)
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
		to_chat(L, span_warning("Selected job cannot be requested for \[ERRORDEPTNOTFOUND] reason. Please report this to system administrator."))
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
		if(DEPARTMENT_TALON)
			ping_name = "Offmap"
	if(!ping_name)
		to_chat(L, span_warning("Selected job cannot be requested for \[ERRORUNKNOWNDEPT] reason. Please report this to system administrator."))
		return
	message_color = ping_dept.color

	message_chat_rolerequest(message_color, ping_name, reason, role)
	last_fax_role_request = world.time
	to_chat(L, span_notice("Your request was transmitted."))

/obj/machinery/photocopier/faxmachine/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Fax", name)
		ui.open()

/obj/machinery/photocopier/faxmachine/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()
	data["scan"] = scan ? scan.name : null
	data["authenticated"] = authenticated
	data["rank"] = rank
	data["isAI"] = isAI(user)
	data["isRobot"] = isrobot(user)
	data["adminDepartments"] = admin_departments

	data["bossName"] = using_map.boss_name
	data["copyItem"] = copyitem
	data["cooldown"] = sendcooldown
	data["destination"] = destination

	return data

/obj/machinery/photocopier/faxmachine/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	switch(action)
		if("scan")
			if(scan)
				scan.forceMove(loc)
				if(ishuman(ui.user) && !ui.user.get_active_hand())
					ui.user.put_in_hands(scan)
				scan = null
			else
				var/obj/item/I = ui.user.get_active_hand()
				if(istype(I, /obj/item/card/id))
					ui.user.drop_item()
					I.forceMove(src)
					scan = I
			return TRUE
		if("login")
			var/login_type = text2num(params["login_type"])
			if(login_type == LOGIN_TYPE_NORMAL && istype(scan))
				if(check_access(scan))
					authenticated = scan.registered_name
					rank = scan.assignment
			else if(login_type == LOGIN_TYPE_AI && isAI(ui.user))
				authenticated = ui.user.name
				rank = JOB_AI
			else if(login_type == LOGIN_TYPE_ROBOT && isrobot(ui.user))
				authenticated = ui.user.name
				var/mob/living/silicon/robot/R = ui.user
				rank = "[R.modtype] [R.braintype]"
			return TRUE
		if("logout")
			if(scan)
				scan.forceMove(loc)
				if(ishuman(ui.user) && !ui.user.get_active_hand())
					ui.user.put_in_hands(scan)
				scan = null
			authenticated = null
			return TRUE
		if("remove")
			if(copyitem)
				if(get_dist(ui.user, src) >= 2)
					to_chat(ui.user, "\The [copyitem] is too far away for you to remove it.")
					return
				copyitem.forceMove(loc)
				ui.user.put_in_hands(copyitem)
				to_chat(ui.user, span_notice("You take \the [copyitem] out of \the [src]."))
				copyitem = null
		if("send_automated_staff_request")
			request_roles()

	if(!authenticated)
		return

	switch(action)
		if("rename")
			if(copyitem)
				var/new_name = tgui_input_text(ui.user, "Enter new paper title", "This will show up in the preview for staff chat on discord when sending \
				to central.", copyitem.name, MAX_NAME_LEN)
				if(!new_name)
					return
				copyitem.name = new_name
		if("send")
			if(copyitem)
				if (destination in admin_departments)
					if(check_if_default_title_and_rename(ui.user))
						return
					send_admin_fax(ui.user, destination)
				else
					sendfax(destination)

				if (sendcooldown)
					spawn(sendcooldown) // cooldown time
						sendcooldown = 0

		if("dept")
			var/lastdestination = destination
			destination = tgui_input_list(ui.user, "Which department?", "Choose a department", (alldepartments + admin_departments))
			if(!destination)
				destination = lastdestination

	return TRUE


/obj/machinery/photocopier/faxmachine/proc/check_if_default_title_and_rename(mob/user)
/*
Returns TRUE only on "Cancel" or invalid newname, else returns null/false
Extracted to its own procedure for easier logic handling with paper bundles.
*/
	var/question_text = "Your fax is set to its default name. It's advisable to rename it to something self-explanatory to"

	if(istype(copyitem, /obj/item/paper_bundle))
		var/obj/item/paper_bundle/B = copyitem
		if(B.name != initial(B.name))
			var/atom/page1 = B.pages[1]	//atom is enough for us to ensure it has name var. would've used ?. opertor, but linter doesnt like.
			var/atom/page2 = B.pages[2]
			if((istype(page1) && B.name == page1.name) || (istype(page2) && B.name == page2.name) )
				question_text = "Your fax is set to use the title of its first or second page. It's advisable to rename it to something \
				summarizing the entire bundle succintly to"
			else
				return FALSE
	else if(copyitem.name != initial(copyitem.name))
		return FALSE

	var/choice = tgui_alert(user, "[question_text] improve response time from staff when sending to discord. \
	Renaming it changes its preview in staff chat.", \
	"Default name detected", list("Change Title","Continue", "Cancel"))
	if(!choice || choice == "Cancel")
		return TRUE
	else if(choice == "Change Title")
		var/new_name = tgui_input_text(user, "Enter new fax title", "This will show up in the preview for staff chat on discord when sending \
		to central.", copyitem.name, MAX_NAME_LEN)
		if(!new_name)
			return TRUE
		copyitem.name = new_name


/obj/machinery/photocopier/faxmachine/attackby(obj/item/O as obj, mob/user as mob)
	if(istype(O, /obj/item/card/id) && !scan)
		user.drop_from_inventory(O)
		O.forceMove(src)
		scan = O
	else if(O.has_tool_quality(TOOL_MULTITOOL) && panel_open)
		var/input = sanitize(tgui_input_text(user, "What Department ID would you like to give this fax machine?", "Multitool-Fax Machine Interface", department))
		if(!input)
			to_chat(user, "No input found. Please hang up and try your call again.")
			return
		department = input
		if( !(("[department]" in alldepartments) || ("[department]" in admin_departments)) && !(department == "Unknown"))
			alldepartments |= department
	else if(istype(O, /obj/item/toner))
		if(toner <= 10) //allow replacing when low toner is affecting the print darkness
			user.drop_item()
			to_chat(user, span_notice("You insert the toner cartridge into \the [src]."))
			playsound(loc, 'sound/machines/click.ogg', 50, 1)
			var/obj/item/toner/T = O
			toner += T.toner_amount
			qdel(O)
		else
			to_chat(user, span_notice("This cartridge is not yet ready for replacement! Use up the rest of the toner."))
			playsound(loc, 'sound/machines/buzz-two.ogg', 75, 1)
		return

	return ..()

/obj/machinery/photocopier/faxmachine/proc/sendfax(var/destination)
	if(stat & (BROKEN|NOPOWER))
		return

	use_power(200)

	var/success = 0
	for(var/obj/machinery/photocopier/faxmachine/F in allfaxes)
		if( F.department == destination )
			success = F.receivefax(copyitem)

	if (success)
		visible_message("[src] beeps, \"Message transmitted successfully.\"")
		//sendcooldown = 600
	else
		visible_message("[src] beeps, \"Error transmitting message.\"")

/obj/machinery/photocopier/faxmachine/proc/receivefax(var/obj/item/incoming)
	if(stat & (BROKEN|NOPOWER))
		return 0

	if(department == "Unknown")
		return 0	//You can't send faxes to "Unknown"

	flick("faxreceive", src)
	playsound(src, "sound/machines/printer.ogg", 50, 1)


	// give the sprite some time to flick
	sleep(20)

	if (istype(incoming, /obj/item/paper))
		copy(incoming)
	else if (istype(incoming, /obj/item/photo))
		photocopy(incoming)
	else if (istype(incoming, /obj/item/paper_bundle))
		bundlecopy(incoming)
	else
		return 0

	use_power(active_power_usage)
	return 1

/obj/machinery/photocopier/faxmachine/proc/send_admin_fax(var/mob/sender, var/destination)
	if(stat & (BROKEN|NOPOWER))
		return

	use_power(200)

	//received copies should not use toner since it's being used by admins only.
	var/obj/item/rcvdcopy
	if (istype(copyitem, /obj/item/paper))
		rcvdcopy = copy(copyitem, 0)
	else if (istype(copyitem, /obj/item/photo))
		rcvdcopy = photocopy(copyitem, 0)
	else if (istype(copyitem, /obj/item/paper_bundle))
		rcvdcopy = bundlecopy(copyitem, 0)
	else
		visible_message("[src] beeps, \"Error transmitting message.\"")
		return

	rcvdcopy.loc = null //hopefully this shouldn't cause trouble
	adminfaxes += rcvdcopy

	//message badmins that a fax has arrived

	// Sadly, we can't use a switch statement here due to not using a constant value for the current map's centcom name.
	if(destination == using_map.boss_name)
		message_admins(sender, "[uppertext(using_map.boss_short)] FAX", rcvdcopy, "CentComFaxReply", "#006100")
	else if(destination == "Virgo-Prime Governmental Authority")
		message_admins(sender, "VIRGO GOVERNMENT FAX", rcvdcopy, "CentComFaxReply", "#1F66A0")
	else if(destination == "Supply")
		message_admins(sender, "[uppertext(using_map.boss_short)] SUPPLY FAX", rcvdcopy, "CentComFaxReply", "#5F4519")
	else
		message_admins(sender, "[uppertext(destination)] FAX", rcvdcopy, "UNKNOWN")

	sendcooldown = 1800
	sleep(50)
	visible_message("[src] beeps, \"Message transmitted successfully.\"")

// Turns objects into just text.
/obj/machinery/photocopier/faxmachine/proc/make_summary(obj/item/sent)
	if(istype(sent, /obj/item/paper))
		var/obj/item/paper/P = sent
		return P.info
	if(istype(sent, /obj/item/paper_bundle))
		. = ""
		var/obj/item/paper_bundle/B = sent
		for(var/i in 1 to B.pages.len)
			var/obj/item/paper/P = B.pages[i]
			if(istype(P)) // Photos can show up here too.
				if(.) // Space out different pages.
					. += "<br>"
				. += "PAGE [i] - [P.name]<br>"
				. += P.info

/obj/machinery/photocopier/faxmachine/proc/message_admins(var/mob/sender, var/faxname, var/obj/item/sent, var/reply_type, font_colour="#006100")
	var/msg = "<font color='[font_colour]'>[faxname]: </font>[get_options_bar(sender, 2,1,1)]"
	msg += "(<a href='byond://?_src_=holder;[HrefToken()];FaxReply=\ref[sender];originfax=\ref[src];replyorigin=[reply_type]'>REPLY</a>)"
	msg = span_bold(msg) + ": "
	msg += "Receiving '[sent.name]' via secure connection ... <a href='byond://?_src_=holder;[HrefToken(TRUE)];AdminFaxView=\ref[sent]'>view message</a>"
	msg = span_notice(msg)

	for(var/client/C in GLOB.admins)
		if(check_rights_for(C, (R_ADMIN|R_MOD|R_EVENT)))
			to_chat(C,msg)
			C << 'sound/machines/printer.ogg'

	var/faxid = export_fax(sent)
	message_chat_admins(sender, faxname, sent, faxid, font_colour) //Sends to admin chat

	// Webhooks don't parse the HTML on the paper, so we gotta strip them out so it's still readable.
	var/summary = make_summary(sent)
	summary = paper_html_to_plaintext(summary)

	log_game("Fax to [lowertext(faxname)] was sent by [key_name(sender)].")
	log_game(summary)

	var/webhook_length_limit = 1900 // The actual limit is a little higher.
	if(length(summary) > webhook_length_limit)
		summary = copytext(summary, 1, webhook_length_limit + 1)
		summary += "\n\[Truncated\]"

	SSwebhooks.send(
		WEBHOOK_FAX_SENT,
		list(
			"name" = "[faxname] '[sent.name]' sent from [key_name(sender)]",
			"body" = summary
		)
	)

/*
								#####						####
								##### Webhook Functionality ####
								#####						####
*/

/datum/configuration
	var/chat_webhook_url = ""		// URL of the webhook for sending announcements/faxes to discord chat.
	var/chat_webhook_key = ""		// Shared secret for authenticating to the chat webhook
	var/fax_export_dir = "data/faxes"	// Directory in which to write exported fax HTML files.


/**
 * Write the fax to disk as (potentially multiple) HTML files.
 * If the fax is a paper_bundle, do so recursively for each page.
 * returns a random unique faxid.
 */
/obj/machinery/photocopier/faxmachine/proc/export_fax(fax)
	var faxid = "[num2text(world.realtime,12)]_[rand(10000)]"
	if (istype(fax, /obj/item/paper))
		var/obj/item/paper/P = fax
		var/text = "<HTML><HEAD><TITLE>[P.name]</TITLE></HEAD><BODY>[P.info][P.stamps]</BODY></HTML>";
		file("[CONFIG_GET(string/fax_export_dir)]/fax_[faxid].html") << text;
	else if (istype(fax, /obj/item/photo))
		var/obj/item/photo/H = fax
		fcopy(H.img, "[CONFIG_GET(string/fax_export_dir)]/photo_[faxid].png")
		var/text = "<html><head><title>[H.name]</title></head>" \
			+ "<body style='overflow:hidden;margin:0;text-align:center'>" \
			+ "<img src='photo_[faxid].png'>" \
			+ "[H.scribble ? "<br>Written on the back:<br><i>[H.scribble]</i>" : ""]"\
			+ "</body></html>"
		file("[CONFIG_GET(string/fax_export_dir)]/fax_[faxid].html") << text
	else if (istype(fax, /obj/item/paper_bundle))
		var/obj/item/paper_bundle/B = fax
		var/data = ""
		for (var/page = 1, page <= B.pages.len, page++)
			var/obj/pageobj = B.pages[page]
			var/page_faxid = export_fax(pageobj)
			data += "<a href='fax_[page_faxid].html'>Page [page] - [pageobj.name]</a><br>"
		var/text = "<html><head><title>[B.name]</title></head><body>[data]</body></html>"
		file("[CONFIG_GET(string/fax_export_dir)]/fax_[faxid].html") << text
	return faxid



/**
 * Call the chat webhook to transmit a notification of an admin fax to the admin chat.
 */
/obj/machinery/photocopier/faxmachine/proc/message_chat_admins(var/mob/sender, var/faxname, var/obj/item/sent, var/faxid, font_colour="#006100")
	if (CONFIG_GET(string/chat_webhook_url))
		spawn(0)
			var/query_string = "type=fax"
			query_string += "&key=[url_encode(CONFIG_GET(string/chat_webhook_key))]"
			query_string += "&faxid=[url_encode(faxid)]"
			query_string += "&color=[url_encode(font_colour)]"
			query_string += "&faxname=[url_encode(faxname)]"
			query_string += "&sendername=[url_encode(sender.name)]"
			query_string += "&sentname=[url_encode(sent.name)]"
			world.Export("[CONFIG_GET(string/chat_webhook_url)]?[query_string]")




/**
 * Call the chat webhook to transmit a notification of a job request
 */
/obj/machinery/photocopier/faxmachine/proc/message_chat_rolerequest(var/font_colour="#006100", var/role_to_ping, var/reason, var/jobname)
	if(CONFIG_GET(string/chat_webhook_url))
		spawn(0)
			var/query_string = "type=rolerequest"
			query_string += "&key=[url_encode(CONFIG_GET(string/chat_webhook_key))]"
			query_string += "&ping=[url_encode(role_to_ping)]"
			query_string += "&color=[url_encode(font_colour)]"
			query_string += "&reason=[url_encode(reason)]"
			query_string += "&job=[url_encode(jobname)]"
			world.Export("[CONFIG_GET(string/chat_webhook_url)]?[query_string]")
