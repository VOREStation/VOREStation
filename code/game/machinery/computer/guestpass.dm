/////////////////////////////////////////////
//Guest pass ////////////////////////////////
/////////////////////////////////////////////
/obj/item/weapon/card/id/guest
	name = "guest pass"
	desc = "Allows temporary access to station areas."
	icon_state = "guest"
	light_color = "#0099ff"

	var/temp_access = list() //to prevent agent cards stealing access as permanent
	var/expiration_time = 0
	var/expired = 0
	var/reason = "NOT SPECIFIED"

/obj/item/weapon/card/id/guest/GetAccess()
	if (world.time > expiration_time)
		return access
	else
		return temp_access

/obj/item/weapon/card/id/guest/examine(mob/user)
	..(user)
	if (world.time < expiration_time)
		user << "<span class='notice'>This pass expires at [worldtime2stationtime(expiration_time)].</span>"
	else
		user << "<span class='warning'>It expired at [worldtime2stationtime(expiration_time)].</span>"

/obj/item/weapon/card/id/guest/read()
	if(!Adjacent(usr))
		return //Too far to read
	if (world.time > expiration_time)
		usr << "<span class='notice'>This pass expired at [worldtime2stationtime(expiration_time)].</span>"
	else
		usr << "<span class='notice'>This pass expires at [worldtime2stationtime(expiration_time)].</span>"

	usr << "<span class='notice'>It grants access to following areas:</span>"
	for (var/A in temp_access)
		usr << "<span class='notice'>[get_access_desc(A)].</span>"
	usr << "<span class='notice'>Issuing reason: [reason].</span>"
	return

/obj/item/weapon/card/id/guest/attack_self(mob/living/user as mob)
	if(user.a_intent == I_HURT)
		if(icon_state == "guest_invalid")
			to_chat(user, "<span class='warning'>This guest pass is already deactivated!</span>")
			return

		var/confirm = alert("Do you really want to deactivate this guest pass? (you can't reactivate it)", "Confirm Deactivation", "Yes", "No")
		if(confirm == "Yes")
			//rip guest pass </3
			user.visible_message("<span class='notice'>\The [user] deactivates \the [src].</span>")
			icon_state = "guest_invalid"
			expiration_time = world.time
			expired = 1
	return ..()

/obj/item/weapon/card/id/guest/New()
	..()
	processing_objects.Add(src)
	update_icon()

/obj/item/weapon/card/id/guest/Destroy()
	processing_objects.Remove(src)
	return ..()

/obj/item/weapon/card/id/guest/process()
	if(expired == 0 && world.time >= expiration_time)
		visible_message("<span class='warning'>\The [src] flashes a few times before turning red.</span>")
		icon_state = "guest_invalid"
		expired = 1
		world.time = expiration_time
		return

/////////////////////////////////////////////
//Guest pass terminal////////////////////////
/////////////////////////////////////////////

/obj/machinery/computer/guestpass
	name = "guest pass terminal"
	icon_state = "guest"
	icon_keyboard = null
	icon_screen = "pass"
	density = 0
	circuit = /obj/item/weapon/circuitboard/guestpass

	var/obj/item/weapon/card/id/giver
	var/list/accesses = list()
	var/giv_name = "NOT SPECIFIED"
	var/reason = "NOT SPECIFIED"
	var/duration = 5

	var/list/internal_log = list()
	var/mode = 0  // 0 - making pass, 1 - viewing logs

/obj/machinery/computer/guestpass/New()
	..()
	uid = "[rand(100,999)]-G[rand(10,99)]"


/obj/machinery/computer/guestpass/attackby(obj/I, mob/user)
	if(istype(I, /obj/item/weapon/card/id))
		if(!giver && user.unEquip(I))
			I.forceMove(src)
			giver = I
			nanomanager.update_uis(src)
		else if(giver)
			user << "<span class='warning'>There is already ID card inside.</span>"
		return
	..()

/obj/machinery/computer/guestpass/attack_ai(var/mob/user as mob)
	return attack_hand(user)

/obj/machinery/computer/guestpass/attack_hand(var/mob/user as mob)
	if(..())
		return

	user.set_machine(src)

	ui_interact(user)

/**
 *  Display the NanoUI window for the guest pass console.
 *
 *  See NanoUI documentation for details.
 */
/obj/machinery/computer/guestpass/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	user.set_machine(src)

	var/list/data = list()

	var/area_list[0]

	if (giver && giver.access)
		data["access"] = giver.access
		for (var/A in giver.access)
			if(A in accesses)
				area_list[++area_list.len] = list("area" = A, "area_name" = get_access_desc(A), "on" = 1)
			else
				area_list[++area_list.len] = list("area" = A, "area_name" = get_access_desc(A), "on" = null)

	data["giver"] = giver
	data["giveName"] = giv_name
	data["reason"] = reason
	data["duration"] = duration
	data["area"] = area_list
	data["mode"] = mode
	data["log"] = internal_log
	data["uid"] = uid

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "guest_pass.tmpl", src.name, 400, 520)
		ui.set_initial_data(data)
		ui.open()
		//ui.set_auto_update(5)

/obj/machinery/computer/guestpass/Topic(href, href_list)
	if(..())
		return 1
	usr.set_machine(src)
	if (href_list["mode"])
		mode = href_list["mode"]

	if (href_list["choice"])
		switch(href_list["choice"])
			if ("giv_name")
				var/nam = sanitizeName(input("Person pass is issued to", "Name", giv_name) as text|null)
				if (nam)
					giv_name = nam
			if ("reason")
				var/reas = sanitize(input("Reason why pass is issued", "Reason", reason) as text|null)
				if(reas)
					reason = reas
			if ("duration")
				var/dur = input("Duration (in minutes) during which pass is valid (up to 120 minutes).", "Duration") as num|null
				if (dur)
					if (dur > 0 && dur <= 120)
						duration = dur
					else
						usr << "<span class='warning'>Invalid duration.</span>"
			if ("access")
				var/A = text2num(href_list["access"])
				if (A in accesses)
					accesses.Remove(A)
				else
					if(A in giver.access)	//Let's make sure the ID card actually has the access.
						accesses.Add(A)
					else
						usr << "<span class='warning'>Invalid selection, please consult technical support if there are any issues.</span>"
						log_debug("[key_name_admin(usr)] tried selecting an invalid guest pass terminal option.")
	if (href_list["action"])
		switch(href_list["action"])
			if ("id")
				if (giver)
					if(ishuman(usr))
						giver.loc = usr.loc
						if(!usr.get_active_hand())
							usr.put_in_hands(giver)
						giver = null
					else
						giver.loc = src.loc
						giver = null
					accesses.Cut()
				else
					var/obj/item/I = usr.get_active_hand()
					if (istype(I, /obj/item/weapon/card/id) && usr.unEquip(I))
						I.loc = src
						giver = I

			if ("print")
				var/dat = "<h3>Activity log of guest pass terminal #[uid]</h3><br>"
				for (var/entry in internal_log)
					dat += "[entry]<br><hr>"
				//usr << "Printing the log, standby..."
				//sleep(50)
				var/obj/item/weapon/paper/P = new/obj/item/weapon/paper( loc )
				P.name = "activity log"
				P.info = dat

			if ("issue")
				if (giver)
					var/number = add_zero("[rand(0,9999)]", 4)
					var/entry = "\[[stationtime2text()]\] Pass #[number] issued by [giver.registered_name] ([giver.assignment]) to [giv_name]. Reason: [reason]. Grants access to following areas: "
					for (var/i=1 to accesses.len)
						var/A = accesses[i]
						if (A)
							var/area = get_access_desc(A)
							entry += "[i > 1 ? ", [area]" : "[area]"]"
					entry += ". Expires at [worldtime2stationtime(world.time + duration*10*60)]."
					internal_log.Add(entry)

					var/obj/item/weapon/card/id/guest/pass = new(src.loc)
					pass.temp_access = accesses.Copy()
					pass.registered_name = giv_name
					pass.expiration_time = world.time + duration*10*60
					pass.reason = reason
					pass.name = "guest pass #[number]"
				else
					usr << "<span class='warning'>Cannot issue pass without issuing ID.</span>"

	src.add_fingerprint(usr)
	nanomanager.update_uis(src)