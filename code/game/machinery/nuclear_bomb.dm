var/bomb_set

/obj/machinery/nuclearbomb
	name = "\improper Nuclear Fission Explosive"
	desc = "Uh oh. RUN!!!!"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "nuclearbomb0"
	density = 1
	var/deployable = 0.0
	var/extended = 0.0
	var/lighthack = 0
	var/opened = 0.0
	var/timeleft = 60.0
	var/timing = 0.0
	var/r_code = "ADMIN"
	var/code = ""
	var/yes_code = 0.0
	var/safety = 1.0
	var/obj/item/weapon/disk/nuclear/auth = null
	var/list/wires = list()
	var/light_wire
	var/safety_wire
	var/timing_wire
	var/removal_stage = 0 // 0 is no removal, 1 is covers removed, 2 is covers open,
	                      // 3 is sealant open, 4 is unwrenched, 5 is removed from bolts.
	use_power = 0

/obj/machinery/nuclearbomb/New()
	..()
	r_code = "[rand(10000, 99999.0)]"//Creates a random code upon object spawn.
	wires["Red"] = 0
	wires["Blue"] = 0
	wires["Green"] = 0
	wires["Marigold"] = 0
	wires["Fuschia"] = 0
	wires["Black"] = 0
	wires["Pearl"] = 0
	var/list/w = list("Red","Blue","Green","Marigold","Black","Fuschia","Pearl")
	light_wire = pick(w)
	w -= light_wire
	timing_wire = pick(w)
	w -= timing_wire
	safety_wire = pick(w)
	w -= safety_wire

/obj/machinery/nuclearbomb/process()
	if(timing)
		bomb_set = 1 //So long as there is one nuke timing, it means one nuke is armed.
		timeleft--
		if(timeleft <= 0)
			explode()
		for(var/mob/M in viewers(1, src))
			if((M.client && M.machine == src))
				attack_hand(M)
	return

/obj/machinery/nuclearbomb/attackby(obj/item/weapon/O as obj, mob/user as mob)
	if(O.is_screwdriver())
		playsound(src, O.usesound, 50, 1)
		add_fingerprint(user)
		if(auth)
			if(opened == 0)
				opened = 1
				overlays += image(icon, "npanel_open")
				to_chat(user, "You unscrew the control panel of [src].")

			else
				opened = 0
				overlays -= image(icon, "npanel_open")
				to_chat(user, "You screw the control panel of [src] back on.")
		else
			if(opened == 0)
				to_chat(user, "The [src] emits a buzzing noise, the panel staying locked in.")
			if(opened == 1)
				opened = 0
				overlays -= image(icon, "npanel_open")
				to_chat(user, "You screw the control panel of [src] back on.")
			flick("nuclearbombc", src)

		return
	if(O.is_wirecutter() || istype(O, /obj/item/device/multitool))
		if(opened == 1)
			nukehack_win(user)
		return

	if(extended)
		if(istype(O, /obj/item/weapon/disk/nuclear))
			usr.drop_item()
			O.loc = src
			auth = O
			add_fingerprint(user)
			return

	if(anchored)
		switch(removal_stage)
			if(0)
				if(istype(O,/obj/item/weapon/weldingtool))

					var/obj/item/weapon/weldingtool/WT = O
					if(!WT.isOn()) return
					if(WT.get_fuel() < 5) // uses up 5 fuel.
						to_chat(user, "<span class='warning'>You need more fuel to complete this task.</span>")
						return

					user.visible_message("[user] starts cutting loose the anchoring bolt covers on [src].", "You start cutting loose the anchoring bolt covers with [O]...")

					if(do_after(user,40 * WT.toolspeed))
						if(!src || !user || !WT.remove_fuel(5, user)) return
						user.visible_message("[user] cuts through the bolt covers on [src].", "You cut through the bolt cover.")
						removal_stage = 1
				return

			if(1)
				if(O.is_crowbar())
					user.visible_message("[user] starts forcing open the bolt covers on [src].", "You start forcing open the anchoring bolt covers with [O]...")

					playsound(src, O.usesound, 50, 1)
					if(do_after(user,15 * O.toolspeed))
						if(!src || !user) return
						user.visible_message("[user] forces open the bolt covers on [src].", "You force open the bolt covers.")
						removal_stage = 2
				return

			if(2)
				if(istype(O,/obj/item/weapon/weldingtool))

					var/obj/item/weapon/weldingtool/WT = O
					if(!WT.isOn()) return
					if(WT.get_fuel() < 5) // uses up 5 fuel.
						to_chat(user, "<span class='warning'>You need more fuel to complete this task.</span>")
						return

					user.visible_message("[user] starts cutting apart the anchoring system sealant on [src].", "You start cutting apart the anchoring system's sealant with [O]...")
					playsound(src, WT.usesound, 50, 1)
					if(do_after(user,40 * WT.toolspeed))
						if(!src || !user || !WT.remove_fuel(5, user)) return
						user.visible_message("[user] cuts apart the anchoring system sealant on [src].", "You cut apart the anchoring system's sealant.")
						removal_stage = 3
				return

			if(3)
				if(O.is_wrench())

					user.visible_message("[user] begins unwrenching the anchoring bolts on [src].", "You begin unwrenching the anchoring bolts...")
					playsound(src, O.usesound, 50, 1)
					if(do_after(user,50 * O.toolspeed))
						if(!src || !user) return
						user.visible_message("[user] unwrenches the anchoring bolts on [src].", "You unwrench the anchoring bolts.")
						removal_stage = 4
				return

			if(4)
				if(O.is_crowbar())

					user.visible_message("[user] begins lifting [src] off of the anchors.", "You begin lifting the device off the anchors...")
					playsound(src, O.usesound, 50, 1)
					if(do_after(user,80 * O.toolspeed))
						if(!src || !user) return
						user.visible_message("[user] crowbars [src] off of the anchors. It can now be moved.", "You jam the crowbar under the nuclear device and lift it off its anchors. You can now move it!")
						anchored = 0
						removal_stage = 5
				return
	..()

/obj/machinery/nuclearbomb/attack_hand(mob/user as mob)
	if(extended)
		if(!ishuman(user))
			to_chat(user, "<span class='warning'>You don't have the dexterity to do this!</span>")
			return 1

		user.set_machine(src)
		var/dat = text("<TT><B>Nuclear Fission Explosive</B><BR>\nAuth. Disk: <A href='?src=\ref[];auth=1'>[]</A><HR>", src, (auth ? "++++++++++" : "----------"))
		if(auth)
			if(yes_code)
				dat += text("\n<B>Status</B>: []-[]<BR>\n<B>Timer</B>: []<BR>\n<BR>\nTimer: [] <A href='?src=\ref[];timer=1'>Toggle</A><BR>\nTime: <A href='?src=\ref[];time=-10'>-</A> <A href='?src=\ref[];time=-1'>-</A> [] <A href='?src=\ref[];time=1'>+</A> <A href='?src=\ref[];time=10'>+</A><BR>\n<BR>\nSafety: [] <A href='?src=\ref[];safety=1'>Toggle</A><BR>\nAnchor: [] <A href='?src=\ref[];anchor=1'>Toggle</A><BR>\n", (timing ? "Func/Set" : "Functional"), (safety ? "Safe" : "Engaged"), timeleft, (timing ? "On" : "Off"), src, src, src, timeleft, src, src, (safety ? "On" : "Off"), src, (anchored ? "Engaged" : "Off"), src)
			else
				dat += text("\n<B>Status</B>: Auth. S2-[]<BR>\n<B>Timer</B>: []<BR>\n<BR>\nTimer: [] Toggle<BR>\nTime: - - [] + +<BR>\n<BR>\n[] Safety: Toggle<BR>\nAnchor: [] Toggle<BR>\n", (safety ? "Safe" : "Engaged"), timeleft, (timing ? "On" : "Off"), timeleft, (safety ? "On" : "Off"), (anchored ? "Engaged" : "Off"))
		else
			if(timing)
				dat += text("\n<B>Status</B>: Set-[]<BR>\n<B>Timer</B>: []<BR>\n<BR>\nTimer: [] Toggle<BR>\nTime: - - [] + +<BR>\n<BR>\nSafety: [] Toggle<BR>\nAnchor: [] Toggle<BR>\n", (safety ? "Safe" : "Engaged"), timeleft, (timing ? "On" : "Off"), timeleft, (safety ? "On" : "Off"), (anchored ? "Engaged" : "Off"))
			else
				dat += text("\n<B>Status</B>: Auth. S1-[]<BR>\n<B>Timer</B>: []<BR>\n<BR>\nTimer: [] Toggle<BR>\nTime: - - [] + +<BR>\n<BR>\nSafety: [] Toggle<BR>\nAnchor: [] Toggle<BR>\n", (safety ? "Safe" : "Engaged"), timeleft, (timing ? "On" : "Off"), timeleft, (safety ? "On" : "Off"), (anchored ? "Engaged" : "Off"))
		var/message = "AUTH"
		if(auth)
			message = text("[]", code)
			if(yes_code)
				message = "*****"
		dat += text("<HR>\n>[]<BR>\n<A href='?src=\ref[];type=1'>1</A>-<A href='?src=\ref[];type=2'>2</A>-<A href='?src=\ref[];type=3'>3</A><BR>\n<A href='?src=\ref[];type=4'>4</A>-<A href='?src=\ref[];type=5'>5</A>-<A href='?src=\ref[];type=6'>6</A><BR>\n<A href='?src=\ref[];type=7'>7</A>-<A href='?src=\ref[];type=8'>8</A>-<A href='?src=\ref[];type=9'>9</A><BR>\n<A href='?src=\ref[];type=R'>R</A>-<A href='?src=\ref[];type=0'>0</A>-<A href='?src=\ref[];type=E'>E</A><BR>\n</TT>", message, src, src, src, src, src, src, src, src, src, src, src, src)
		user << browse(dat, "window=nuclearbomb;size=300x400")
		onclose(user, "nuclearbomb")
	else if(deployable)
		if(removal_stage < 5)
			anchored = 1
			visible_message("<span class='warning'>With a steely snap, bolts slide out of [src] and anchor it to the flooring!</span>")
		else
			visible_message("<span class='warning'>\The [src] makes a highly unpleasant crunching noise. It looks like the anchoring bolts have been cut.</span>")
		if(!lighthack)
			flick("nuclearbombc", src)
			icon_state = "nuclearbomb1"
		extended = 1
	return

obj/machinery/nuclearbomb/proc/nukehack_win(mob/user as mob)
	var/dat as text
	dat += "<TT><B>Nuclear Fission Explosive</B><BR>\nNuclear Device Wires:</A><HR>"
	for(var/wire in wires)
		dat += text("[wire] Wire: <A href='?src=\ref[src];wire=[wire];act=wire'>[wires[wire] ? "Mend" : "Cut"]</A> <A href='?src=\ref[src];wire=[wire];act=pulse'>Pulse</A><BR>")
	dat += text("<HR>The device is [timing ? "shaking!" : "still"]<BR>")
	dat += text("The device is [safety ? "quiet" : "whirring"].<BR>")
	dat += text("The lights are [lighthack ? "static" : "functional"].<BR>")
	user << browse("<HTML><HEAD><TITLE>Bomb Defusion</TITLE></HEAD><BODY>[dat]</BODY></HTML>","window=nukebomb_hack")
	onclose(user, "nukebomb_hack")

/obj/machinery/nuclearbomb/verb/make_deployable()
	set category = "Object"
	set name = "Make Deployable"
	set src in oview(1)

	if(!usr.canmove || usr.stat || usr.restrained())
		return
	if(!ishuman(usr))
		to_chat(usr, "<span class='warning'>You don't have the dexterity to do this!</span>")
		return 1

	if(deployable)
		to_chat(usr, "<span class='warning'>You close several panels to make [src] undeployable.</span>")
		deployable = 0
	else
		to_chat(usr, "<span class='warning'>You adjust some panels to make [src] deployable.</span>")
		deployable = 1
	return

/obj/machinery/nuclearbomb/Topic(href, href_list)
	..()
	if(!usr.canmove || usr.stat || usr.restrained())
		return
	if((usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf))))
		usr.set_machine(src)
		if(href_list["act"])
			var/temp_wire = href_list["wire"]
			if(href_list["act"] == "pulse")
				if(!istype(usr.get_active_hand(), /obj/item/device/multitool))
					to_chat(usr, "You need a multitool!")
				else
					if(wires[temp_wire])
						to_chat(usr, "You can't pulse a cut wire.")
					else
						if(light_wire == temp_wire)
							lighthack = !lighthack
							spawn(100) lighthack = !lighthack
						if(timing_wire == temp_wire)
							if(timing)
								explode()
						if(safety_wire == temp_wire)
							safety = !safety
							spawn(100) safety = !safety
							if(safety == 1)
								visible_message("<span class='notice'>The [src] quiets down.</span>")
								if(!lighthack)
									if(icon_state == "nuclearbomb2")
										icon_state = "nuclearbomb1"
							else
								visible_message("<span class='notice'>The [src] emits a quiet whirling noise!</span>")
			if(href_list["act"] == "wire")
				var/obj/item/I = usr.get_active_hand()
				if(!I.is_wirecutter())
					to_chat(usr, "You need wirecutters!")
				else
					wires[temp_wire] = !wires[temp_wire]
					if(safety_wire == temp_wire)
						if(timing)
							explode()
					if(timing_wire == temp_wire)
						if(!lighthack)
							if(icon_state == "nuclearbomb2")
								icon_state = "nuclearbomb1"
						timing = 0
						bomb_set = 0
					if(light_wire == temp_wire)
						lighthack = !lighthack

		if(href_list["auth"])
			if(auth)
				auth.loc = src.loc
				yes_code = 0
				auth = null
			else
				var/obj/item/I = usr.get_active_hand()
				if(istype(I, /obj/item/weapon/disk/nuclear))
					usr.drop_item()
					I.loc = src
					auth = I
		if(auth)
			if(href_list["type"])
				if(href_list["type"] == "E")
					if(code == r_code)
						yes_code = 1
						code = null
					else
						code = "ERROR"
				else
					if(href_list["type"] == "R")
						yes_code = 0
						code = null
					else
						code += text("[]", href_list["type"])
						if(length(code) > 5)
							code = "ERROR"
			if(yes_code)
				if(href_list["time"])
					var/time = text2num(href_list["time"])
					timeleft += time
					timeleft = min(max(round(timeleft), 60), 600)
				if(href_list["timer"])
					if(timing == -1.0)
						return
					if(safety)
						to_chat(usr, "<span class='warning'>The safety is still on.</span>")
						return
					timing = !(timing)
					if(timing)
						if(!lighthack)
							icon_state = "nuclearbomb2"
						if(!safety)
							bomb_set = 1//There can still be issues with this reseting when there are multiple bombs. Not a big deal tho for Nuke/N
						else
							bomb_set = 0
					else
						bomb_set = 0
						if(!lighthack)
							icon_state = "nuclearbomb1"
				if(href_list["safety"])
					safety = !(safety)
					if(safety)
						timing = 0
						bomb_set = 0
				if(href_list["anchor"])

					if(removal_stage == 5)
						anchored = 0
						visible_message("<span class='warning'>\The [src] makes a highly unpleasant crunching noise. It looks like the anchoring bolts have been cut.</span>")
						return

					anchored = !(anchored)
					if(anchored)
						visible_message("<span class='warning'>With a steely snap, bolts slide out of [src] and anchor it to the flooring.</span>")
					else
						visible_message("<span class='warning'>The anchoring bolts slide back into the depths of [src].</span>")

		add_fingerprint(usr)
		for(var/mob/M in viewers(1, src))
			if((M.client && M.machine == src))
				attack_hand(M)
	else
		usr << browse(null, "window=nuclearbomb")
		return
	return


/obj/machinery/nuclearbomb/ex_act(severity)
	return


#define NUKERANGE 80
/obj/machinery/nuclearbomb/proc/explode()
	if(safety)
		timing = 0
		return
	timing = -1.0
	yes_code = 0
	safety = 1
	if(!lighthack)
		icon_state = "nuclearbomb3"
	playsound(src,'sound/machines/Alarm.ogg',100,0,5)
	if(ticker && ticker.mode)
		ticker.mode.explosion_in_progress = 1
	sleep(100)

	var/off_station = 0
	var/turf/bomb_location = get_turf(src)
	if(bomb_location && (bomb_location.z in using_map.station_levels))
		if((bomb_location.x < (128-NUKERANGE)) || (bomb_location.x > (128+NUKERANGE)) || (bomb_location.y < (128-NUKERANGE)) || (bomb_location.y > (128+NUKERANGE)))
			off_station = 1
	else
		off_station = 2

	if(ticker)
		if(ticker.mode && ticker.mode.name == "Mercenary")
			var/obj/machinery/computer/shuttle_control/multi/syndicate/syndie_location = locate(/obj/machinery/computer/shuttle_control/multi/syndicate)
			if(syndie_location)
				ticker.mode:syndies_didnt_escape = (syndie_location.z > 1 ? 0 : 1)	//muskets will make me change this, but it will do for now
			ticker.mode:nuke_off_station = off_station
		ticker.station_explosion_cinematic(off_station,null)
		if(ticker.mode)
			ticker.mode.explosion_in_progress = 0
			world << "<B>The station was destoyed by the nuclear blast!</B>"

			ticker.mode.station_was_nuked = (off_station<2)	//offstation==1 is a draw. the station becomes irradiated and needs to be evacuated.
															//kinda shit but I couldn't  get permission to do what I wanted to do.

			if(!ticker.mode.check_finished())//If the mode does not deal with the nuke going off so just reboot because everyone is stuck as is
				world << "<B>Resetting in 30 seconds!</B>"

				feedback_set_details("end_error","nuke - unhandled ending")

				if(blackbox)
					blackbox.save_all_data_to_sql()
				sleep(300)
				log_game("Rebooting due to nuclear detonation")
				world.Reboot()
				return
	return

/obj/item/weapon/disk/nuclear/New()
	..()
	nuke_disks |= src

/obj/item/weapon/disk/nuclear/Destroy()
	if(!nuke_disks.len && blobstart.len > 0)
		var/obj/D = new /obj/item/weapon/disk/nuclear(pick(blobstart))
		message_admins("[src], the last authentication disk, has been destroyed. Spawning [D] at ([D.x], [D.y], [D.z]).")
		log_game("[src], the last authentication disk, has been destroyed. Spawning [D] at ([D.x], [D.y], [D.z]).")
	..()

/obj/item/weapon/disk/nuclear/touch_map_edge()
	qdel(src)
