/*
FIRE ALARM
*/
/obj/machinery/firealarm
	name = "fire alarm"
	desc = "<i>\"Pull this in case of emergency\"</i>. Thus, keep pulling it forever."
	icon = 'icons/obj/monitors.dmi'
	icon_state = "fire0"
	layer = ABOVE_WINDOW_LAYER
	var/detecting = 1.0
	var/working = 1.0
	var/time = 10.0
	var/timing = 0.0
	var/lockdownbyai = 0
	anchored = 1.0
	use_power = USE_POWER_IDLE
	idle_power_usage = 2
	active_power_usage = 6
	power_channel = ENVIRON
	var/last_process = 0
	panel_open = 0
	var/seclevel
	circuit = /obj/item/weapon/circuitboard/firealarm
	var/alarms_hidden = FALSE //If the alarms from this machine are visible on consoles

/obj/machinery/firealarm/alarms_hidden
	alarms_hidden = TRUE

/obj/machinery/firealarm/examine()
	. = ..()
	. += "Current security level: [seclevel]"

/obj/machinery/firealarm/Initialize()
	. = ..()
	if(z in using_map.contact_levels)
		set_security_level(security_level ? get_security_level() : "green")

/obj/machinery/firealarm/update_icon()
	cut_overlays()

	if(panel_open)
		set_light(0)
		return

	if(stat & BROKEN)
		icon_state = "firex"
		set_light(0)
	else if(stat & NOPOWER)
		icon_state = "firep"
		set_light(0)
	else
		if(!detecting)
			icon_state = "fire1"
			set_light(l_range = 4, l_power = 0.9, l_color = "#ff0000")
		else
			icon_state = "fire0"
			switch(seclevel)
				if("green")	set_light(l_range = 2, l_power = 0.25, l_color = "#00ff00")
				if("yellow")	set_light(l_range = 2, l_power = 0.25, l_color = "#ffff00")
				if("violet")	set_light(l_range = 2, l_power = 0.25, l_color = "#9933ff")
				if("orange")	set_light(l_range = 2, l_power = 0.25, l_color = "#ff9900")
				if("blue")	set_light(l_range = 2, l_power = 0.25, l_color = "#1024A9")
				if("red")	set_light(l_range = 4, l_power = 0.9, l_color = "#ff0000")
				if("delta")	set_light(l_range = 4, l_power = 0.9, l_color = "#FF6633")
		add_overlay("overlay_[seclevel]")

/obj/machinery/firealarm/fire_act(datum/gas_mixture/air, temperature, volume)
	if(detecting)
		if(temperature > T0C + 200)
			alarm()			// added check of detector status here
	return

/obj/machinery/firealarm/attack_ai(mob/user as mob)
	return attack_hand(user)

/obj/machinery/firealarm/bullet_act()
	return alarm()

/obj/machinery/firealarm/emp_act(severity)
	if(prob(50 / severity))
		alarm(rand(30 / severity, 60 / severity))
	..()

/obj/machinery/firealarm/attackby(obj/item/W as obj, mob/user as mob)
	add_fingerprint(user)

	if(alarm_deconstruction_screwdriver(user, W))
		return
	if(alarm_deconstruction_wirecutters(user, W))
		return

	if(panel_open)
		if(istype(W, /obj/item/device/multitool))
			detecting = !(detecting)
			if(detecting)
				user.visible_message("<span class='notice'>\The [user] has reconnected [src]'s detecting unit!</span>", "<span class='notice'>You have reconnected [src]'s detecting unit.</span>")
			else
				user.visible_message("<span class='notice'>\The [user] has disconnected [src]'s detecting unit!</span>", "<span class='notice'>You have disconnected [src]'s detecting unit.</span>")
		return

	alarm()
	return

/obj/machinery/firealarm/process()//Note: this processing was mostly phased out due to other code, and only runs when needed
	if(stat & (NOPOWER|BROKEN))
		return

	if(timing)
		if(time > 0)
			time = time - ((world.timeofday - last_process) / 10)
		else
			alarm()
			time = 0
			timing = 0
			STOP_PROCESSING(SSobj, src)
		updateDialog()
	last_process = world.timeofday

	if(locate(/obj/fire) in src.loc)
		alarm()

	return

/obj/machinery/firealarm/power_change()
	..()
	spawn(rand(0,15))
		update_icon()

/obj/machinery/firealarm/attack_hand(mob/user as mob)
	if(user.stat || stat & (NOPOWER | BROKEN))
		return

	add_fingerprint(user)
	var/area/A = get_area(src)
	if(A.fire)
		reset(user)
	else
		alarm(0, user)

/obj/machinery/firealarm/proc/reset(mob/user)
	if(!(working))
		return
	var/area/area = get_area(src)
	for(var/obj/machinery/firealarm/FA in area)
		fire_alarm.clearAlarm(src.loc, FA)
	update_icon()
	if(user)
		log_game("[user] reset a fire alarm at [COORD(src)]")

/obj/machinery/firealarm/proc/alarm(var/duration = 0, mob/user)
	if(!(working))
		return
	var/area/area = get_area(src)
	for(var/obj/machinery/firealarm/FA in area)
		fire_alarm.triggerAlarm(loc, FA, duration, hidden = alarms_hidden)
	update_icon()
	playsound(src, 'sound/machines/airalarm.ogg', 25, 0, 4, volume_channel = VOLUME_CHANNEL_ALARMS)
	if(user)
		log_game("[user] triggered a fire alarm at [COORD(src)]")

/obj/machinery/firealarm/proc/set_security_level(var/newlevel)
	if(seclevel != newlevel)
		seclevel = newlevel
		update_icon()

/*
FIRE ALARM CIRCUIT
Just a object used in constructing fire alarms

/obj/item/weapon/firealarm_electronics
	name = "fire alarm electronics"
	icon = 'icons/obj/doors/door_assembly.dmi'
	icon_state = "door_electronics"
	desc = "A circuit. It has a label on it, it says \"Can handle heat levels up to 40 degrees celsius!\""
	w_class = ITEMSIZE_SMALL
	matter = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)
*/
/obj/machinery/partyalarm
	name = "\improper PARTY BUTTON"
	desc = "Cuban Pete is in the house!"
	icon = 'icons/obj/monitors.dmi'
	icon_state = "fire0"
	var/detecting = 1.0
	var/working = 1.0
	var/time = 10.0
	var/timing = 0.0
	var/lockdownbyai = 0
	anchored = 1.0
	use_power = USE_POWER_IDLE
	idle_power_usage = 2
	active_power_usage = 6

/obj/machinery/partyalarm/attack_hand(mob/user as mob)
	if(user.stat || stat & (NOPOWER|BROKEN))
		return

	user.machine = src
	var/area/A = get_area(src)
	ASSERT(isarea(A))
	var/d1
	var/d2
	if(istype(user, /mob/living/carbon/human) || istype(user, /mob/living/silicon/ai))

		if(A.party)
			d1 = text("<A href='?src=\ref[];reset=1'>No Party :(</A>", src)
		else
			d1 = text("<A href='?src=\ref[];alarm=1'>PARTY!!!</A>", src)
		if(timing)
			d2 = text("<A href='?src=\ref[];time=0'>Stop Time Lock</A>", src)
		else
			d2 = text("<A href='?src=\ref[];time=1'>Initiate Time Lock</A>", src)
		var/second = time % 60
		var/minute = (time - second) / 60
		var/dat = text("<HTML><HEAD></HEAD><BODY><TT><B>Party Button</B> []\n<HR>\nTimer System: []<BR>\nTime Left: [][] <A href='?src=\ref[];tp=-30'>-</A> <A href='?src=\ref[];tp=-1'>-</A> <A href='?src=\ref[];tp=1'>+</A> <A href='?src=\ref[];tp=30'>+</A>\n</TT></BODY></HTML>", d1, d2, (minute ? text("[]:", minute) : null), second, src, src, src, src)
		user << browse(dat, "window=partyalarm")
		onclose(user, "partyalarm")
	else
		if(A.fire)
			d1 = text("<A href='?src=\ref[];reset=1'>[]</A>", src, stars("No Party :("))
		else
			d1 = text("<A href='?src=\ref[];alarm=1'>[]</A>", src, stars("PARTY!!!"))
		if(timing)
			d2 = text("<A href='?src=\ref[];time=0'>[]</A>", src, stars("Stop Time Lock"))
		else
			d2 = text("<A href='?src=\ref[];time=1'>[]</A>", src, stars("Initiate Time Lock"))
		var/second = time % 60
		var/minute = (time - second) / 60
		var/dat = text("<HTML><HEAD></HEAD><BODY><TT><B>[]</B> []\n<HR>\nTimer System: []<BR>\nTime Left: [][] <A href='?src=\ref[];tp=-30'>-</A> <A href='?src=\ref[];tp=-1'>-</A> <A href='?src=\ref[];tp=1'>+</A> <A href='?src=\ref[];tp=30'>+</A>\n</TT></BODY></HTML>", stars("Party Button"), d1, d2, (minute ? text("[]:", minute) : null), second, src, src, src, src)
		user << browse(dat, "window=partyalarm")
		onclose(user, "partyalarm")
	return

/obj/machinery/partyalarm/proc/reset()
	if(!(working))
		return
	var/area/A = get_area(src)
	ASSERT(isarea(A))
	A.partyreset()
	return

/obj/machinery/partyalarm/proc/alarm()
	if(!(working))
		return
	var/area/A = get_area(src)
	ASSERT(isarea(A))
	A.partyalert()
	return

/obj/machinery/partyalarm/Topic(href, href_list)
	..()
	if(usr.stat || stat & (BROKEN|NOPOWER))
		return
	if((usr.contents.Find(src) || ((get_dist(src, usr) <= 1) && istype(loc, /turf))) || (istype(usr, /mob/living/silicon/ai)))
		usr.machine = src
		if(href_list["reset"])
			reset()
		else if(href_list["alarm"])
			alarm()
		else if(href_list["time"])
			timing = text2num(href_list["time"])
		else if(href_list["tp"])
			var/tp = text2num(href_list["tp"])
			time += tp
			time = min(max(round(time), 0), 120)
		updateUsrDialog()

		add_fingerprint(usr)
	else
		usr << browse(null, "window=partyalarm")
		return
	return
