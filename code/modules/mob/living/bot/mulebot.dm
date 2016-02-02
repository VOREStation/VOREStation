#define MULE_IDLE 0
#define MULE_MOVING 1
#define MULE_UNLOAD 2
#define MULE_LOST 3
#define MULE_CALC_MIN 4
#define MULE_CALC_MAX 10
#define MULE_PATH_DONE 11
// IF YOU CHANGE THOSE, UPDATE THEM IN pda.tmpl TOO

/mob/living/bot/mulebot
	name = "Mulebot"
	desc = "A Multiple Utility Load Effector bot."
	icon_state = "mulebot0"
	anchored = 1
	density = 1
	health = 150
	maxHealth = 150
	mob_bump_flag = HEAVY

	botcard_access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_qm, access_mining, access_mining_station)

	var/busy = 0
	var/mode = MULE_IDLE
	var/atom/movable/load

	var/crates_only = 1
	var/auto_return = 1
	var/safety = 1

	var/list/path = list()
	var/frustration = 0
	var/turf/target
	var/targetName
	var/turf/home
	var/homeName
	var/turf/obstacle

	var/global/amount = 0

/mob/living/bot/mulebot/New()
	..()

	var/turf/T = get_turf(loc)
	var/obj/machinery/navbeacon/N = locate() in home
	if(N)
		home = T
		homeName = N.location
	else
		homeName = "Unset"

	suffix = num2text(++amount) // Starts from 1

	name = "Mulebot #[suffix]"

/mob/living/bot/mulebot/MouseDrop_T(var/atom/movable/C, var/mob/user)
	if(user.stat)
		return

	if(!istype(C) || C.anchored || get_dist(user, src) > 1 || get_dist(src, C) > 1 )
		return

	load(C)

/mob/living/bot/mulebot/attack_hand(var/mob/user)
	interact(user)

/mob/living/bot/mulebot/proc/interact(var/mob/user)
	var/dat
	dat += "<TT><B>Multiple Utility Load Effector Mk. III</B></TT><BR><BR>"
	dat += "ID: [suffix]<BR>"
	dat += "Power: [on ? "On" : "Off"]<BR>"

	if(!open)
		dat += "Status: "
		switch(mode)
			if(MULE_IDLE)
				dat += "Ready"
			if(MULE_MOVING, MULE_UNLOAD, MULE_PATH_DONE)
				dat += "Navigating"
			if(MULE_UNLOAD)
				dat += "Unloading"
			if(MULE_LOST)
				dat += "Processing commands"
			if(MULE_CALC_MIN to MULE_CALC_MAX)
				dat += "Calculating navigation path"

		dat += "<BR>Current Load: [load ? load.name : "<i>none</i>"]<BR>"

		if(locked)
			dat += "<HR>Controls are locked"
		else
			dat += "<HR>Controls are unlocked<BR><BR>"

		if(!locked || issilicon(user))
			dat += "<A href='byond://?src=\ref[src];op=power'>Toggle power</A><BR>"
			dat += "<A href='byond://?src=\ref[src];op=stop'>Stop</A><BR>"
			dat += "<A href='byond://?src=\ref[src];op=go'>Proceed</A><BR>"
			dat += "<A href='byond://?src=\ref[src];op=home'>Return to home</A><BR>"
			dat += "<A href='byond://?src=\ref[src];op=destination'>Set destination</A><BR>"
			dat += "<A href='byond://?src=\ref[src];op=sethome'>Set home</A><BR>"
			dat += "<A href='byond://?src=\ref[src];op=autoret'>Toggle auto return home</A> ([auto_return ? "On" : "Off"])<BR>"
			dat += "<A href='byond://?src=\ref[src];op=cargotypes'>Toggle non-standard cargo</A> ([crates_only ? "Off" : "On"])<BR>"

			if(load)
				dat += "<A href='byond://?src=\ref[src];op=unload'>Unload now</A><BR>"
			dat += "<HR>The maintenance hatch is closed.<BR>"

	else
		if(!issilicon(user))
			dat += "The maintenance hatch is open.<BR><BR>"

			dat += "<A href='byond://?src=\ref[src];op=safety'>Toggle safety</A> ([safety ? "On" : "Off - DANGER"])<BR>"
		else
			dat += "The bot is in maintenance mode and cannot be controlled.<BR>"

	user << browse("<HEAD><TITLE>Mulebot [suffix ? "([suffix])" : ""]</TITLE></HEAD>[dat]", "window=mulebot;size=350x500")
	onclose(user, "mulebot")
	return

/mob/living/bot/mulebot/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	add_fingerprint(usr)
	switch(href_list["op"])
		if("power")
			if(on)
				turn_off()
			else
				turn_on()
			visible_message("[usr] switches [on ? "on" : "off"] [src].")

		if("stop")
			obeyCommand("Stop")

		if("go")
			obeyCommand("GoTD")

		if("home")
			obeyCommand("Home")

		if("destination")
			obeyCommand("SetD")

		if("sethome")
			var/new_dest
			var/list/beaconlist = new()
			for(var/obj/machinery/navbeacon/N in navbeacons)
				beaconlist.Add(N.location)
				beaconlist[N.location] = N
			if(beaconlist.len)
				new_dest = input("Select new home tag", "Mulebot [suffix ? "([suffix])" : ""]", null) in null|beaconlist
			else
				alert("No destination beacons available.")
			if(new_dest)
				home = get_turf(beaconlist[new_dest])
				homeName = new_dest

		if("unload")
			unload()

		if("autoret")
			auto_return = !auto_return

		if("cargotypes")
			crates_only = !crates_only

		if("safety")
			safety = !safety

	interact(usr)

/mob/living/bot/mulebot/attackby(var/obj/item/O, var/mob/user)
	..()
	update_icons()

/mob/living/bot/mulebot/proc/obeyCommand(var/command)
	switch(command)
		if("Home")
			mode = MULE_IDLE
			target = home
			targetName = "Home"
			mode = MULE_LOST
		if("SetD")
			var/new_dest
			var/list/beaconlist = new()
			for(var/obj/machinery/navbeacon/N in navbeacons)
				beaconlist.Add(N.location)
				beaconlist[N.location] = N
			if(beaconlist.len)
				new_dest = input("Select new destination tag", "Mulebot [suffix ? "([suffix])" : ""]") in null|beaconlist
			else
				alert("No destination beacons available.")
			if(new_dest)
				target = get_turf(beaconlist[new_dest])
				targetName = new_dest
		if("GoTD")
			if(mode == MULE_IDLE)
				mode = MULE_LOST
		if("Stop")
			mode = MULE_IDLE

/mob/living/bot/mulebot/emag_act(var/remaining_charges, var/user)
	locked = !locked
	user << "<span class='notice'>You [locked ? "lock" : "unlock"] the mulebot's controls!</span>"
	flick("mulebot-emagged", src)
	playsound(loc, 'sound/effects/sparks1.ogg', 100, 0)
	return 1

/mob/living/bot/mulebot/update_icons()
	if(open)
		icon_state = "mulebot-hatch"
		return
	if(mode == MULE_MOVING || mode == MULE_UNLOAD)
		icon_state = "mulebot1"
		return
	icon_state = "mulebot0"

/mob/living/bot/mulebot/Life()
	..()

	if(busy)
		return

	if(!safety && prob(1))
		flick("mulebot-emagged", src)

	switch(mode)
		if(MULE_IDLE) // Idle
			return
		if(MULE_MOVING) // Moving to target
			if(!target) // Return home
				if(auto_return && home)
					target = home
					targetName = "Home"
					mode = MULE_LOST
				else
					mode = MULE_IDLE
				update_icons()
				return
			if(loc == target) // Unload or stop
				custom_emote(2, "makes a chiming sound.")
				playsound(loc, 'sound/machines/chime.ogg', 50, 0)
				mode = MULE_UNLOAD
				update_icons()
				return
			if(path.len) // Move
				var/turf/next = path[1]
				if(next == loc)
					path -= next
					return

				var/moved = step_towards(src, next)
				if(moved)
					frustration = 0
					path -= next
				else if(frustration < 6)
					if(frustration == 3)
						custom_emote(2, "makes an annoyed buzzing sound")
						playsound(loc, 'sound/machines/buzz-two.ogg', 50, 0)
					++frustration
				else
					custom_emote(2, "makes a sighing buzz.")
					playsound(loc, 'sound/machines/buzz-sigh.ogg', 50, 0)
					obstacle = next

					mode = MULE_LOST
			else
				mode = MULE_LOST
			update_icons()
			return
		if(MULE_UNLOAD)
			unload(dir)

			if(auto_return && home && (loc != home))
				target = home
				targetName = "Home"
				mode = MULE_LOST
			else
				mode = MULE_IDLE
			update_icons()
			return
		if(MULE_LOST) // Lost my way
			if(target)
				spawn(0)
					calc_path(obstacle)
				mode = MULE_CALC_MIN
			else
				mode = MULE_IDLE
			update_icons()
			return
		if(MULE_CALC_MIN to MULE_CALC_MAX) // Calcing path
			if(path.len)
				mode = MULE_PATH_DONE
				update_icons()
			else
				++mode
			return
		if(MULE_PATH_DONE) // Done with path
			obstacle = null
			if(path.len)
				frustration = 0
				mode = MULE_MOVING
			else
				if(home)
					target = home
					targetName = "Home"
					mode = MULE_LOST
				else
					mode = MULE_IDLE
			update_icons()

/mob/living/bot/mulebot/Bump(var/mob/living/M)
	if(!safety && istype(M))
		visible_message("<span class='warning'>[src] knocks over [M]!</span>")
		M.Stun(8)
		M.Weaken(5)
	..()

/mob/living/bot/mulebot/proc/runOver(var/mob/living/carbon/human/H)
	if(istype(H)) // No safety checks - WILL run over lying humans. Stop ERPing in the maint!
		visible_message("<span class='warning'>[src] drives over [H]!</span>")
		playsound(loc, 'sound/effects/splat.ogg', 50, 1)

		var/damage = rand(5, 7)
		H.apply_damage(2 * damage, BRUTE, BP_HEAD)
		H.apply_damage(2 * damage, BRUTE, BP_TORSO)
		H.apply_damage(0.5 * damage, BRUTE, BP_L_LEG)
		H.apply_damage(0.5 * damage, BRUTE, BP_R_LEG)
		H.apply_damage(0.5 * damage, BRUTE, BP_L_ARM)
		H.apply_damage(0.5 * damage, BRUTE, BP_R_ARM)

		blood_splatter(src, H, 1)
	..()

/mob/living/bot/mulebot/relaymove(var/mob/user, var/direction)
	if(load == user)
		unload(direction)

/mob/living/bot/mulebot/explode()
	unload(pick(0, 1, 2, 4, 8))

	visible_message("<span class='danger'>[src] blows apart!</span>")

	var/turf/Tsec = get_turf(src)
	new /obj/item/device/assembly/prox_sensor(Tsec)
	PoolOrNew(/obj/item/stack/rods, Tsec)
	PoolOrNew(/obj/item/stack/rods, Tsec)
	new /obj/item/stack/cable_coil/cut(Tsec)

	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(3, 1, src)
	s.start()

	new /obj/effect/decal/cleanable/blood/oil(Tsec)
	..()

/mob/living/bot/mulebot/proc/calc_path(var/turf/avoid = null)
	path = AStar(loc, target, /turf/proc/CardinalTurfsWithAccess, /turf/proc/Distance, 0, 250, id = botcard, exclude = avoid)
	if(!path)
		path = list()

/mob/living/bot/mulebot/proc/load(var/atom/movable/C)
	if(busy || load || get_dist(C, src) > 1 || !isturf(C.loc))
		return

	for(var/obj/structure/plasticflaps/P in src.loc)//Takes flaps into account
		if(!CanPass(C,P))
			return

	if(crates_only && !istype(C,/obj/structure/closet/crate))
		custom_emote(2, "makes a sighing buzz.")
		playsound(loc, 'sound/machines/buzz-sigh.ogg', 50, 0)
		return

	var/obj/structure/closet/crate/crate = C
	if(istype(crate))
		crate.close()

	//I'm sure someone will come along and ask why this is here... well people were dragging screen items onto the mule, and that was not cool.
	//So this is a simple fix that only allows a selection of item types to be considered. Further narrowing-down is below.
	//if(!istype(C,/obj/item) && !istype(C,/obj/machinery) && !istype(C,/obj/structure) && !ismob(C))
	//	return
	busy = 1

	C.loc = loc
	sleep(2)
	if(C.loc != loc) //To prevent you from going onto more than one bot.
		return
	C.loc = src
	load = C

	C.pixel_y += 9
	if(C.layer < layer)
		C.layer = layer + 0.1
	overlays += C

	busy = 0

/mob/living/bot/mulebot/proc/unload(var/dirn = 0)
	if(!load || busy)
		return

	busy = 1
	overlays.Cut()

	load.loc = loc
	load.pixel_y -= 9
	load.layer = initial(load.layer)

	if(dirn)
		step(load, dirn)

	load = null

	for(var/atom/movable/AM in src)
		if(AM == botcard || AM == access_scanner)
			continue

		AM.loc = loc
		AM.layer = initial(AM.layer)
		AM.pixel_y = initial(AM.pixel_y)
	busy = 0

#undef MULE_IDLE
#undef MULE_MOVING
#undef MULE_UNLOAD
#undef MULE_LOST
#undef MULE_CALC_MIN
#undef MULE_CALC_MAX
#undef MULE_PATH_DONE
