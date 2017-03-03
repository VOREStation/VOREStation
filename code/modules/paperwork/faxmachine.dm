var/list/obj/machinery/photocopier/faxmachine/allfaxes = list()
var/list/admin_departments = list("[using_map.boss_name]", "Virgo Prime Governmental Authority", "Supply")
var/list/alldepartments = list()

var/list/adminfaxes = list()	//cache for faxes that have been sent to admins

/obj/machinery/photocopier/faxmachine
	name = "fax machine"
	icon = 'icons/obj/library.dmi'
	icon_state = "fax"
	insert_anim = "faxsend"
	req_one_access = list(access_lawyer, access_heads, access_armory, access_qm)

	use_power = 1
	idle_power_usage = 30
	active_power_usage = 200
	circuit = /obj/item/weapon/circuitboard/fax

	var/obj/item/weapon/card/id/scan = null // identification
	var/authenticated = 0
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

	ui_interact(user)

/**
 *  Display the NanoUI window for the fax machine.
 *
 *  See NanoUI documentation for details.
 */
/obj/machinery/photocopier/faxmachine/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	user.set_machine(src)

	var/list/data = list()
	if(scan)
		data["scanName"] = scan.name
	else
		data["scanName"] = null
	data["bossName"] = using_map.boss_name
	data["authenticated"] = authenticated
	data["copyItem"] = copyitem
	if(copyitem)
		data["copyItemName"] = copyitem.name
	else
		data["copyItemName"] = null
	data["cooldown"] = sendcooldown
	data["destination"] = destination

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "fax.tmpl", src.name, 500, 500)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(10) //this machine is so unimportant let's not have it update that often.

/obj/machinery/photocopier/faxmachine/Topic(href, href_list)
	if(href_list["send"])
		if(copyitem)
			if (destination in admin_departments)
				send_admin_fax(usr, destination)
			else
				sendfax(destination)

			if (sendcooldown)
				spawn(sendcooldown) // cooldown time
					sendcooldown = 0

	else if(href_list["remove"])
		if(copyitem)
			copyitem.loc = usr.loc
			usr.put_in_hands(copyitem)
			usr << "<span class='notice'>You take \the [copyitem] out of \the [src].</span>"
			copyitem = null

	if(href_list["scan"])
		if (scan)
			if(ishuman(usr))
				scan.loc = usr.loc
				if(!usr.get_active_hand())
					usr.put_in_hands(scan)
				scan = null
			else
				scan.loc = src.loc
				scan = null
		else
			var/obj/item/I = usr.get_active_hand()
			if (istype(I, /obj/item/weapon/card/id) && usr.unEquip(I))
				I.loc = src
				scan = I
		authenticated = 0

	if(href_list["dept"])
		var/lastdestination = destination
		destination = input(usr, "Which department?", "Choose a department", "") as null|anything in (alldepartments + admin_departments)
		if(!destination) destination = lastdestination

	if(href_list["auth"])
		if ( (!( authenticated ) && (scan)) )
			if (check_access(scan))
				authenticated = 1

	if(href_list["logout"])
		authenticated = 0

	nanomanager.update_uis(src)

/obj/machinery/photocopier/faxmachine/proc/sendfax(var/destination)
	if(stat & (BROKEN|NOPOWER))
		return

	use_power(200)

	var/success = 0
	for(var/obj/machinery/photocopier/faxmachine/F in allfaxes)
		if( F.department == destination )
			success = F.recievefax(copyitem)

	if (success)
		visible_message("[src] beeps, \"Message transmitted successfully.\"")
		//sendcooldown = 600
	else
		visible_message("[src] beeps, \"Error transmitting message.\"")

/obj/machinery/photocopier/faxmachine/proc/recievefax(var/obj/item/incoming)
	if(stat & (BROKEN|NOPOWER))
		return 0

	if(department == "Unknown")
		return 0	//You can't send faxes to "Unknown"

	flick("faxreceive", src)
	playsound(loc, "sound/effects/printer.ogg", 50, 1)


	// give the sprite some time to flick
	sleep(20)

	if (istype(incoming, /obj/item/weapon/paper))
		copy(incoming)
	else if (istype(incoming, /obj/item/weapon/photo))
		photocopy(incoming)
	else if (istype(incoming, /obj/item/weapon/paper_bundle))
		bundlecopy(incoming)
	else
		return 0

	use_power(active_power_usage)
	return 1

/obj/machinery/photocopier/faxmachine/proc/send_admin_fax(var/mob/sender, var/destination)
	if(stat & (BROKEN|NOPOWER))
		return

	use_power(200)

	//recieved copies should not use toner since it's being used by admins only.
	var/obj/item/rcvdcopy
	if (istype(copyitem, /obj/item/weapon/paper))
		rcvdcopy = copy(copyitem, 0)
	else if (istype(copyitem, /obj/item/weapon/photo))
		rcvdcopy = photocopy(copyitem, 0)
	else if (istype(copyitem, /obj/item/weapon/paper_bundle))
		rcvdcopy = bundlecopy(copyitem, 0)
	else
		visible_message("[src] beeps, \"Error transmitting message.\"")
		return

	rcvdcopy.loc = null //hopefully this shouldn't cause trouble
	adminfaxes += rcvdcopy

	//message badmins that a fax has arrived
	if (destination == using_map.boss_name)
		message_admins(sender, "[uppertext(using_map.boss_short)] FAX", rcvdcopy, "CentComFaxReply", "#006100")
	else if (destination == "Virgo Prime Governmental Authority")
		message_admins(sender, "VIRGO GOVERNMENT FAX", rcvdcopy, "CentComFaxReply", "#1F66A0")
	else if (destination == "Supply")
		message_admins(sender, "[uppertext(using_map.boss_short)] SUPPLY FAX", rcvdcopy, "CentComFaxReply", "#5F4519")
	else
		message_admins(sender, "[uppertext(destination)] FAX", rcvdcopy, "UNKNOWN")


	sendcooldown = 1800
	sleep(50)
	visible_message("[src] beeps, \"Message transmitted successfully.\"")


/obj/machinery/photocopier/faxmachine/proc/message_admins(var/mob/sender, var/faxname, var/obj/item/sent, var/reply_type, font_colour="#006100")
	var/msg = "<span class='notice'><b><font color='[font_colour]'>[faxname]: </font>[get_options_bar(sender, 2,1,1)]"
	msg += "(<a href='?_src_=holder;FaxReply=\ref[sender];originfax=\ref[src];replyorigin=[reply_type]'>REPLY</a>)</b>: "
	msg += "Receiving '[sent.name]' via secure connection ... <a href='?_src_=holder;AdminFaxView=\ref[sent]'>view message</a></span>"

	for(var/client/C in admins)
		if(check_rights((R_ADMIN|R_MOD),0,C))
			C << msg
			C << 'sound/effects/printer.ogg'

	// VoreStation Edit Start
	var/faxid = export_fax(sent)
	message_chat_admins(sender, faxname, sent, faxid, font_colour)
	// VoreStation Edit End
