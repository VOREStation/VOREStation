var/list/obj/machinery/photocopier/faxmachine/allfaxes = list()
var/list/admin_departments = list("[using_map.boss_name]", "Virgo-Prime Governmental Authority", "Virgo-Erigonne Job Boards", "Supply") // Vorestation Edit
var/list/alldepartments = list()

var/list/adminfaxes = list()	//cache for faxes that have been sent to admins

/obj/machinery/photocopier/faxmachine
	name = "fax machine"
	desc = "Sent papers and pictures far away! Or to your co-worker's office a few doors down."
	icon = 'icons/obj/library.dmi'
	icon_state = "fax"
	insert_anim = "faxsend"
	req_one_access = list(access_lawyer, access_heads, access_armory, access_qm)

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

/obj/machinery/photocopier/faxmachine/New()
	allfaxes += src
	if(!destination) destination = "[using_map.boss_name]"
	if( !(("[department]" in alldepartments) || ("[department]" in admin_departments)) )
		alldepartments |= department
	..()

/obj/machinery/photocopier/faxmachine/attack_hand(mob/user as mob)
	user.set_machine(src)

	tgui_interact(user)

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
				if(ishuman(usr) && !usr.get_active_hand())
					usr.put_in_hands(scan)
				scan = null
			else
				var/obj/item/I = usr.get_active_hand()
				if(istype(I, /obj/item/card/id))
					usr.drop_item()
					I.forceMove(src)
					scan = I
			return TRUE
		if("login")
			var/login_type = text2num(params["login_type"])
			if(login_type == LOGIN_TYPE_NORMAL && istype(scan))
				if(check_access(scan))
					authenticated = scan.registered_name
					rank = scan.assignment
			else if(login_type == LOGIN_TYPE_AI && isAI(usr))
				authenticated = usr.name
				rank = "AI"
			else if(login_type == LOGIN_TYPE_ROBOT && isrobot(usr))
				authenticated = usr.name
				var/mob/living/silicon/robot/R = usr
				rank = "[R.modtype] [R.braintype]"
			return TRUE
		if("logout")
			if(scan)
				scan.forceMove(loc)
				if(ishuman(usr) && !usr.get_active_hand())
					usr.put_in_hands(scan)
				scan = null
			authenticated = null
			return TRUE
		if("remove")
			if(copyitem)
				if(get_dist(usr, src) >= 2)
					to_chat(usr, "\The [copyitem] is too far away for you to remove it.")
					return
				copyitem.forceMove(loc)
				usr.put_in_hands(copyitem)
				to_chat(usr, "<span class='notice'>You take \the [copyitem] out of \the [src].</span>")
				copyitem = null

	if(!authenticated)
		return

	switch(action)
		if("send")
			if(copyitem)
				if (destination in admin_departments)
					send_admin_fax(usr, destination)
				else
					sendfax(destination)

				if (sendcooldown)
					spawn(sendcooldown) // cooldown time
						sendcooldown = 0

		if("dept")
			var/lastdestination = destination
			destination = tgui_input_list(usr, "Which department?", "Choose a department", (alldepartments + admin_departments))
			if(!destination)
				destination = lastdestination

	return TRUE

/obj/machinery/photocopier/faxmachine/attackby(obj/item/O as obj, mob/user as mob)
	if(O.is_multitool() && panel_open)
		var/input = sanitize(tgui_input_text(usr, "What Department ID would you like to give this fax machine?", "Multitool-Fax Machine Interface", department))
		if(!input)
			to_chat(usr, "No input found. Please hang up and try your call again.")
			return
		department = input
		if( !(("[department]" in alldepartments) || ("[department]" in admin_departments)) && !(department == "Unknown"))
			alldepartments |= department

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
	else if(destination == "Virgo-Prime Governmental Authority") // Vorestation Edit
		message_admins(sender, "VIRGO GOVERNMENT FAX", rcvdcopy, "CentComFaxReply", "#1F66A0") // Vorestation Edit
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
	var/msg = "<span class='notice'><b><font color='[font_colour]'>[faxname]: </font>[get_options_bar(sender, 2,1,1)]"
	msg += "(<a href='?_src_=holder;FaxReply=\ref[sender];originfax=\ref[src];replyorigin=[reply_type]'>REPLY</a>)</b>: "
	msg += "Receiving '[sent.name]' via secure connection ... <a href='?_src_=holder;AdminFaxView=\ref[sent]'>view message</a></span>"

	for(var/client/C in GLOB.admins)
		if(check_rights((R_ADMIN|R_MOD|R_EVENT),0,C))
			to_chat(C,msg)
			C << 'sound/machines/printer.ogg'

	// VoreStation Edit Start
	var/faxid = export_fax(sent)
	message_chat_admins(sender, faxname, sent, faxid, font_colour)
	// VoreStation Edit End

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
