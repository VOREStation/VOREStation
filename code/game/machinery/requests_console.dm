/******************** Requests Console ********************/
/** Originally written by errorage, updated by: Carn, needs more work though. I just added some security fixes */

//Request Console Department Types
#define RC_ASSIST 1		//Request Assistance
#define RC_SUPPLY 2		//Request Supplies
#define RC_INFO   4		//Relay Info

//Request Console Screens
#define RCS_MAINMENU 0	// Main menu
#define RCS_RQASSIST 1	// Request supplies
#define RCS_RQSUPPLY 2	// Request assistance
#define RCS_SENDINFO 3	// Relay information
#define RCS_SENTPASS 4	// Message sent successfully
#define RCS_SENTFAIL 5	// Message sent unsuccessfully
#define RCS_VIEWMSGS 6	// View messages
#define RCS_MESSAUTH 7	// Authentication before sending
#define RCS_ANNOUNCE 8	// Send announcement

var/req_console_assistance = list()
var/req_console_supplies = list()
var/req_console_information = list()
var/list/obj/machinery/requests_console/allConsoles = list()

/obj/machinery/requests_console
	name = "requests console"
	desc = "A console intended to send requests to different departments on the station."
	anchored = 1
	icon = 'icons/obj/terminals_vr.dmi' //VOREStation Edit
	icon_state = "req_comp0"
	layer = ABOVE_WINDOW_LAYER
	circuit = /obj/item/weapon/circuitboard/request
	var/department = "Unknown" //The list of all departments on the station (Determined from this variable on each unit) Set this to the same thing if you want several consoles in one department
	var/list/message_log = list() //List of all messages
	var/departmentType = 0 		//Bitflag. Zero is reply-only. Map currently uses raw numbers instead of defines.
	var/newmessagepriority = 0
		// 0 = no new message
		// 1 = normal priority
		// 2 = high priority
	var/screen = RCS_VIEWMSGS
	var/silent = 0 // set to 1 for it not to beep all the time
//	var/hackState = 0
		// 0 = not hacked
		// 1 = hacked
	var/announcementConsole = 0
		// 0 = This console cannot be used to send department announcements
		// 1 = This console can send department announcementsf
	var/open = 0 // 1 if open
	var/announceAuth = 0 //Will be set to 1 when you authenticate yourself for announcements
	var/msgVerified = "" //Will contain the name of the person who varified it
	var/msgStamped = "" //If a message is stamped, this will contain the stamp name
	var/message = "";
	var/recipient = ""; //the department which will be receiving the message
	var/priority = -1 ; //Priority of the message being sent
	light_range = 0
	var/datum/announcement/announcement = new

/obj/machinery/requests_console/power_change()
	..()
	update_icon()

/obj/machinery/requests_console/update_icon()
	if(stat & NOPOWER)
		if(icon_state != "req_comp_off")
			icon_state = "req_comp_off"
	else
		if(icon_state == "req_comp_off")
			icon_state = "req_comp[newmessagepriority]"

/obj/machinery/requests_console/New()
	..()

	announcement.title = "[department] announcement"
	announcement.newscast = 1

	name = "[department] requests console"
	allConsoles += src
	if(departmentType & RC_ASSIST)
		req_console_assistance |= department
	if(departmentType & RC_SUPPLY)
		req_console_supplies |= department
	if(departmentType & RC_INFO)
		req_console_information |= department

	set_light(1)

/obj/machinery/requests_console/Destroy()
	allConsoles -= src
	var/lastDeptRC = 1
	for (var/obj/machinery/requests_console/Console in allConsoles)
		if(Console.department == department)
			lastDeptRC = 0
			break
	if(lastDeptRC)
		if(departmentType & RC_ASSIST)
			req_console_assistance -= department
		if(departmentType & RC_SUPPLY)
			req_console_supplies -= department
		if(departmentType & RC_INFO)
			req_console_information -= department
	return ..()

/obj/machinery/requests_console/attack_hand(user as mob)
	if(..(user))
		return
	tgui_interact(user)

/obj/machinery/requests_console/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "RequestConsole", "[department] Request Console")
		ui.open()

/obj/machinery/requests_console/tgui_data(mob/user)
	var/list/data = ..()
	data["department"] = department
	data["screen"] = screen
	data["message_log"] = message_log
	data["newmessagepriority"] = newmessagepriority
	data["silent"] = silent
	data["announcementConsole"] = announcementConsole

	data["assist_dept"] = req_console_assistance
	data["supply_dept"] = req_console_supplies
	data["info_dept"]   = req_console_information

	data["message"] = message
	data["recipient"] = recipient
	data["priority"] = priority
	data["msgStamped"] = msgStamped
	data["msgVerified"] = msgVerified
	data["announceAuth"] = announceAuth
	return data

/obj/machinery/requests_console/tgui_act(action, list/params)
	if(..())
		return TRUE
	
	add_fingerprint(usr)
	
	switch(action)
		if("write")
			if(reject_bad_text(params["write"]))
				recipient = params["write"] //write contains the string of the receiving department's name

				var/new_message = sanitize(input("Write your message:", "Awaiting Input", ""))
				if(new_message)
					message = new_message
					screen = RCS_MESSAUTH
					switch(params["priority"])
						if(1)
							priority = 1
						if(2)
							priority = 2
						else
							priority = 0
				else
					reset_message(1)
				. = TRUE

		if("writeAnnouncement")
			var/new_message = sanitize(input("Write your message:", "Awaiting Input", ""))
			if(new_message)
				message = new_message
			else
				reset_message(1)
			. = TRUE

		if("sendAnnouncement")
			if(!announcementConsole)
				return FALSE
			announcement.Announce(message, msg_sanitized = 1)
			reset_message(1)
			. = TRUE

		if("department")
			if(!message)
				return FALSE
			var/log_msg = message
			var/pass = 0
			screen = RCS_SENTFAIL
			for(var/obj/machinery/message_server/MS in machines)
				if(!MS.active)
					continue
				MS.send_rc_message(ckey(params["department"]), department, log_msg, msgStamped, msgVerified, priority)
				pass = 1
			if(pass)
				screen = RCS_SENTPASS
				message_log += list(list("Message sent to [recipient]", "[message]"))
			else
				audible_message(text("[bicon(src)] *The Requests Console beeps: 'NOTICE: No server detected!'"),,4)
			. = TRUE

		//Handle printing
		if("print")
			var/msg = message_log[text2num(params["print"])];
			if(msg)
				msg = "<b>[msg[1]]:</b><br>[msg[2]]"
				msg = replacetext(msg, "<BR>", "\n")
				msg = strip_html_properly(msg)
				var/obj/item/weapon/paper/R = new(src.loc)
				R.name = "[department] Message"
				R.info = "<H3>[department] Requests Console</H3><div>[msg]</div>"
				. = TRUE

		//Handle screen switching
		if("setScreen")
			var/tempScreen = text2num(params["setScreen"])
			if(tempScreen == RCS_ANNOUNCE && !announcementConsole)
				return
			if(tempScreen == RCS_VIEWMSGS)
				for (var/obj/machinery/requests_console/Console in allConsoles)
					if(Console.department == department)
						Console.newmessagepriority = 0
						Console.icon_state = "req_comp0"
						Console.set_light(1)
			if(tempScreen == RCS_MAINMENU)
				reset_message()
			screen = tempScreen
			. = TRUE

		//Handle silencing the console
		if("toggleSilent")
			silent = !silent
			. = TRUE

					//err... hacking code, which has no reason for existing... but anyway... it was once supposed to unlock priority 3 messaging on that console (EXTREME priority...), but the code for that was removed.
/obj/machinery/requests_console/attackby(var/obj/item/weapon/O as obj, var/mob/user as mob)
	if(computer_deconstruction_screwdriver(user, O))
		return
	if(istype(O, /obj/item/device/multitool))
		var/input = sanitize(input(usr, "What Department ID would you like to give this request console?", "Multitool-Request Console Interface", department))
		if(!input)
			to_chat(usr, "No input found. Please hang up and try your call again.")
			return
		department = input
		announcement.title = "[department] announcement"
		announcement.newscast = 1

		name = "[department] Requests Console"
		allConsoles += src
		if(departmentType & RC_ASSIST)
			req_console_assistance |= department
		if(departmentType & RC_SUPPLY)
			req_console_supplies |= department
		if(departmentType & RC_INFO)
			req_console_information |= department
		return

	if(istype(O, /obj/item/weapon/card/id))
		if(inoperable(MAINT)) return
		if(screen == RCS_MESSAUTH)
			var/obj/item/weapon/card/id/T = O
			msgVerified = text("<font color='green'><b>Verified by [T.registered_name] ([T.assignment])</b></font>")
			SStgui.update_uis(src)
		if(screen == RCS_ANNOUNCE)
			var/obj/item/weapon/card/id/ID = O
			if(access_RC_announce in ID.GetAccess())
				announceAuth = 1
				announcement.announcer = ID.assignment ? "[ID.assignment] [ID.registered_name]" : ID.registered_name
			else
				reset_message()
				to_chat(user, "<span class='warning'>You are not authorized to send announcements.</span>")
			SStgui.update_uis(src)
	if(istype(O, /obj/item/weapon/stamp))
		if(inoperable(MAINT)) return
		if(screen == RCS_MESSAUTH)
			var/obj/item/weapon/stamp/T = O
			msgStamped = text("<font color='blue'><b>Stamped with the [T.name]</b></font>")
			SStgui.update_uis(src)
	return

/obj/machinery/requests_console/proc/reset_message(var/mainmenu = 0)
	message = ""
	recipient = ""
	priority = 0
	msgVerified = ""
	msgStamped = ""
	announceAuth = 0
	announcement.announcer = ""
	if(mainmenu)
		screen = RCS_MAINMENU
