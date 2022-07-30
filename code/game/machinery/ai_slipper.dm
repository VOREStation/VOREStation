/obj/machinery/ai_slipper
	name = "\improper AI Liquid Dispenser"
	icon = 'icons/obj/device.dmi'
	icon_state = "liquid_dispenser"
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 10
	var/uses = 20
	var/disabled = 1
	var/lethal = 0
	var/locked = 1
	var/cooldown_time = 0
	var/cooldown_timeleft = 0
	var/cooldown_on = 0
	req_access = list(access_ai_upload)

/obj/machinery/ai_slipper/New()
	..()
	update_icon()

/obj/machinery/ai_slipper/power_change()
	..()
	update_icon()

/obj/machinery/ai_slipper/update_icon()
	if(stat & NOPOWER || stat & BROKEN)
		icon_state = "liquid_dispenser"
	else
		icon_state = disabled ? "liquid_dispenser" : "liquid_dispenser_on"

/obj/machinery/ai_slipper/proc/setState(var/enabled, var/uses)
	disabled = disabled
	uses = uses
	power_change()

/obj/machinery/ai_slipper/attackby(obj/item/W, mob/user)
	if(stat & (NOPOWER|BROKEN))
		return
	if(istype(user, /mob/living/silicon))
		return attack_hand(user)
	else // trying to unlock the interface
		if(allowed(usr))
			locked = !locked
			to_chat(user, "You [ locked ? "lock" : "unlock"] the device.")
			if(locked)
				if(user.machine==src)
					user.unset_machine()
					user << browse(null, "window=ai_slipper")
			else
				if(user.machine==src)
					attack_hand(usr)
		else
			to_chat(user, "<span class='warning'>Access denied.</span>")
			return
	return

/obj/machinery/ai_slipper/attack_ai(mob/user as mob)
	return attack_hand(user)

/obj/machinery/ai_slipper/attack_hand(mob/user as mob)
	if(stat & (NOPOWER|BROKEN))
		return
	if((get_dist(src, user) > 1))
		if(!istype(user, /mob/living/silicon))
			to_chat(user, "Too far away.")
			user.unset_machine()
			user << browse(null, "window=ai_slipper")
			return

	user.set_machine(src)
	var/loc = src.loc
	if(istype(loc, /turf))
		loc = loc:loc
	if(!istype(loc, /area))
		to_chat(user, "Turret badly positioned - loc.loc is [loc].")
		return
	var/area/area = loc
	var/t = "<TT><B>AI Liquid Dispenser</B> ([area.name])<HR>"

	if(locked && (!istype(user, /mob/living/silicon)))
		t += "<I>(Swipe ID card to unlock control panel.)</I><BR>"
	else
		t += text("Dispenser [] - <A href='?src=\ref[];toggleOn=1'>[]?</a><br>\n", disabled?"deactivated":"activated", src, disabled?"Enable":"Disable")
		t += text("Uses Left: [uses]. <A href='?src=\ref[src];toggleUse=1'>Activate the dispenser?</A><br>\n")

	user << browse(t, "window=computer;size=575x450")
	onclose(user, "computer")
	return

/obj/machinery/ai_slipper/Topic(href, href_list)
	..()
	if(locked)
		if(!istype(usr, /mob/living/silicon))
			to_chat(usr, "Control panel is locked!")
			return
	if(href_list["toggleOn"])
		disabled = !disabled
		update_icon()
	if(href_list["toggleUse"])
		if(cooldown_on || disabled)
			return
		else
			new /obj/effect/vfx/foam(src.loc)
			uses--
			cooldown_on = 1
			cooldown_time = world.timeofday + 100
			slip_process()
			return

	attack_hand(usr)
	return

/obj/machinery/ai_slipper/proc/slip_process()
	while(cooldown_time - world.timeofday > 0)
		var/ticksleft = cooldown_time - world.timeofday

		if(ticksleft > 1e5)
			cooldown_time = world.timeofday + 10	// midnight rollover


		cooldown_timeleft = (ticksleft / 10)
		sleep(5)
	if(uses <= 0)
		return
	if(uses >= 0)
		cooldown_on = 0
	power_change()
	return
