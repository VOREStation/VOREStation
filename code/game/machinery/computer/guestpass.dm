/////////////////////////////////////////////
//Guest pass ////////////////////////////////
/////////////////////////////////////////////
/obj/item/card/id/guest
	name = "guest pass"
	desc = "Allows temporary access to station areas."
	icon_state = "guest"
	initial_sprite_stack = list()
	light_color = "#0099ff"

	var/temp_access = list() //to prevent agent cards stealing access as permanent
	var/expiration_time = 0
	var/expired = 0
	var/reason = "NOT SPECIFIED"

/obj/item/card/id/guest/update_icon()
	return

/obj/item/card/id/guest/GetAccess()
	if(world.time > expiration_time)
		return access
	else
		return temp_access

/obj/item/card/id/guest/examine(mob/user)
	. = ..()
	if(world.time < expiration_time)
		. += span_notice("This pass expires at [worldtime2stationtime(expiration_time)].")
	else
		. += span_warning("It expired at [worldtime2stationtime(expiration_time)].")

/obj/item/card/id/guest/read()
	if(!Adjacent(usr))
		return //Too far to read
	if(world.time > expiration_time)
		to_chat(usr, span_notice("This pass expired at [worldtime2stationtime(expiration_time)]."))
	else
		to_chat(usr, span_notice("This pass expires at [worldtime2stationtime(expiration_time)]."))

	to_chat(usr, span_notice("It grants access to following areas:"))
	for (var/A in temp_access)
		to_chat(usr, span_notice("[get_access_desc(A)]."))
	to_chat(usr, span_notice("Issuing reason: [reason]."))
	return

/obj/item/card/id/guest/attack_self(mob/living/user as mob)
	if(user.a_intent == I_HURT)
		if(icon_state == "guest-invalid")
			to_chat(user, span_warning("This guest pass is already deactivated!"))
			return

		var/confirm = tgui_alert(user, "Do you really want to deactivate this guest pass? (you can't reactivate it)", "Confirm Deactivation", list("Yes", "No"))
		if(confirm == "Yes")
			//rip guest pass </3
			user.visible_message(span_infoplain(span_bold("\The [user]") + "deactivates \the [src]."))
			icon_state = "guest-invalid"
			update_icon()
			expiration_time = world.time
			expired = 1
	return ..()

/obj/item/card/id/guest/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)
	update_icon()

/obj/item/card/id/guest/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/card/id/guest/process()
	if(expired == 0 && world.time >= expiration_time)
		visible_message(span_warning("\The [src] flashes a few times before turning red."))
		icon_state = "guest-invalid"
		update_icon()
		expired = 1
		world.time = expiration_time
		return

/////////////////////////////////////////////
//Guest pass terminal////////////////////////
/////////////////////////////////////////////

/obj/machinery/computer/guestpass
	name = "guest pass terminal"
	desc = "Used to print temporary passes for people. Handy!"
	icon_state = "guest"
	layer = ABOVE_WINDOW_LAYER
	vis_flags = VIS_HIDE // They have an emissive that looks bad in openspace due to their wall-mounted nature
	icon_keyboard = null
	icon_screen = "pass"
	density = FALSE
	circuit = /obj/item/circuitboard/guestpass

	var/obj/item/card/id/giver
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
	if(istype(I, /obj/item/card/id/guest))
		to_chat(user, span_warning("The guest pass terminal denies to accept the guest pass."))
		return
	if(istype(I, /obj/item/card/id))
		if(stat & NOPOWER) //checking for power in here so crowbar and screwdriver and stuff still works.
			to_chat(user, span_warning("The terminal refuses your I.D as it is unpowered!"))
			return
		if(!giver && user.unEquip(I))
			I.forceMove(src)
			giver = I
			SStgui.update_uis(src)
		else if(giver)
			to_chat(user, span_warning("There is already ID card inside."))
		return
	..()

/obj/machinery/computer/guestpass/attack_ai(var/mob/user as mob)
	return attack_hand(user)

/obj/machinery/computer/guestpass/verb/eject_id()
	set category = "Object"
	set name = "Eject ID Card"
	set src in oview(1)

	if(!usr || usr.stat || usr.lying)	return

	if(giver)
		to_chat(usr, span_notice("You remove \the [giver] from \the [src]."))
		giver.loc = get_turf(src)
		if(!usr.get_active_hand() && istype(usr,/mob/living/carbon/human))
			usr.put_in_hands(giver)
		else
			giver.loc = src.loc
		giver = null
		accesses.Cut()
	else
		to_chat(usr, span_warning("There is nothing to remove from the console."))
	return

/obj/machinery/computer/guestpass/attack_hand(var/mob/user as mob)
	if(..())
		return

	user.set_machine(src)
	tgui_interact(user)

/obj/machinery/computer/guestpass/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "GuestPass", name)
		ui.open()

/obj/machinery/computer/guestpass/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	var/list/area_list = list()

	data["access"] = null
	if(giver && giver.GetAccess())
		data["access"] = giver.GetAccess()
		for (var/A in giver.GetAccess())
			if(A in accesses)
				area_list.Add(list(list("area" = A, "area_name" = get_access_desc(A), "on" = 1)))
			else
				area_list.Add(list(list("area" = A, "area_name" = get_access_desc(A), "on" = null)))
	data["area"] = area_list

	data["giver"] = giver
	data["giveName"] = giv_name
	data["reason"] = reason
	data["duration"] = duration
	data["mode"] = mode
	data["log"] = internal_log
	data["uid"] = uid

	return data

/obj/machinery/computer/guestpass/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	switch(action)
		if("mode")
			mode = params["mode"]

		if("giv_name")
			var/nam = sanitizeName(tgui_input_text(ui.user, "Person pass is issued to", "Name", giv_name))
			if(nam)
				giv_name = nam
		if("reason")
			var/reas = sanitize(tgui_input_text(ui.user, "Reason why pass is issued", "Reason", reason))
			if(reas)
				reason = reas
		if("duration")
			var/dur = tgui_input_number(ui.user, "Duration (in minutes) during which pass is valid (up to 360 minutes).", "Duration", null, 360, 0)
			if(dur)
				if(dur > 0 && dur <= 360) //VOREStation Edit
					duration = dur
				else
					to_chat(ui.user, span_warning("Invalid duration."))
		if("access")
			var/A = text2num(params["access"])
			if(A in accesses)
				accesses.Remove(A)
			else
				if(A in giver.GetAccess())	//Let's make sure the ID card actually has the access.
					accesses.Add(A)
				else
					to_chat(ui.user, span_warning("Invalid selection, please consult technical support if there are any issues."))
					log_debug("[key_name_admin(ui.user)] tried selecting an invalid guest pass terminal option.")
		if("id")
			if(giver)
				if(ishuman(ui.user))
					giver.loc = ui.user.loc
					if(!ui.user.get_active_hand())
						ui.user.put_in_hands(giver)
					giver = null
				else
					giver.loc = src.loc
					giver = null
				accesses.Cut()
			else
				var/obj/item/I = ui.user.get_active_hand()
				if(istype(I, /obj/item/card/id) && ui.user.unEquip(I))
					I.loc = src
					giver = I

		if("print")
			var/dat = "<h3>Activity log of guest pass terminal #[uid]</h3><br>"
			for (var/entry in internal_log)
				dat += "[entry]<br><hr>"
			//to_chat(ui.user, "Printing the log, standby...")
			//sleep(50)
			var/obj/item/paper/P = new/obj/item/paper( loc )
			P.name = "activity log"
			P.info = dat

		if("issue")
			if(giver)
				var/number = add_zero("[rand(0,9999)]", 4)
				var/entry = "\[[stationtime2text()]\] Pass #[number] issued by [giver.registered_name] ([giver.assignment]) to [giv_name]. Reason: [reason]. Grants access to following areas: "
				for (var/i=1 to accesses.len)
					var/A = accesses[i]
					if(A)
						var/area = get_access_desc(A)
						entry += "[i > 1 ? ", [area]" : "[area]"]"
				entry += ". Expires at [worldtime2stationtime(world.time + duration*10*60)]."
				internal_log.Add(entry)

				var/obj/item/card/id/guest/pass = new(src.loc)
				pass.temp_access = accesses.Copy()
				pass.registered_name = giv_name
				pass.expiration_time = world.time + duration*10*60
				pass.reason = reason
				pass.name = "guest pass #[number]"
			else
				to_chat(ui.user, span_warning("Cannot issue pass without issuing ID."))

	add_fingerprint(ui.user)
	return TRUE
