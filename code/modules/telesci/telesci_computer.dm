/obj/machinery/computer/telescience
	name = "\improper Telepad Control Console"
	desc = "Used to teleport objects to and from the telescience telepad."
	icon_screen = "teleport"
	icon_keyboard = "teleport_key"
	circuit = /obj/item/circuitboard/telesci_console
	var/sending = 1
	var/obj/machinery/telepad/telepad = null
	var/temp_msg = "Telescience control console initialized. Welcome."

	// VARIABLES //
	var/teles_left	// How many teleports left until it becomes uncalibrated
	var/datum/projectile_data/last_tele_data = null
	var/z_co = 1
	var/distance_off
	var/rotation_off
	var/turf/last_target

	var/rotation = 0
	var/distance = 5

	// Based on the distance used
	var/teleport_cooldown = 0
	var/teleporting = 0
	var/starting_crystals = 0
	var/max_crystals = 4
	// Used to adjust OP-ness: (4 crystals * 6 efficiency * 12.5 coefficient) = 300 range.
	var/powerCoefficient = 12.5
	var/list/crystals = list()
	var/obj/item/gps/inserted_gps
	var/overmap_range = 3

/obj/machinery/computer/telescience/Destroy()
	eject()
	if(inserted_gps)
		inserted_gps.forceMove(loc)
		inserted_gps = null
	return ..()

/obj/machinery/computer/telescience/examine(mob/user)
	. = ..()
	if(Adjacent(user))
		. += "There are [crystals.len ? crystals.len : "no"] bluespace crystal\s in the crystal slots."

/obj/machinery/computer/telescience/Initialize()
	. = ..()
	recalibrate()
	for(var/i = 1; i <= starting_crystals; i++)
		crystals += new /obj/item/ore/bluespace_crystal/artificial(src) // starting crystals

/obj/machinery/computer/telescience/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/ore/bluespace_crystal))
		if(crystals.len >= max_crystals)
			to_chat(user, "<span class='warning'>There are not enough crystal slots.</span>")
			return
		if(!user.unEquip(W))
			return
		crystals += W
		W.forceMove(src)
		user.visible_message("[user] inserts [W] into \the [src]'s crystal slot.", "<span class='notice'>You insert [W] into \the [src]'s crystal slot.</span>")
		updateDialog()
	else if(istype(W, /obj/item/gps))
		if(!inserted_gps)
			inserted_gps = W
			user.unEquip(W)
			W.forceMove(src)
			user.visible_message("[user] inserts [W] into \the [src]'s GPS device slot.", "<span class='notice'>You insert [W] into \the [src]'s GPS device slot.</span>")
	else if(istype(W, /obj/item/multitool))
		var/obj/item/multitool/M = W
		if(M.connectable && istype(M.connectable, /obj/machinery/telepad))
			telepad = M.connectable
			M.connectable = null
			to_chat(user, "<span class='caution'>You upload the data from the [W.name]'s buffer.</span>")
	else
		return ..()

/obj/machinery/computer/telescience/proc/get_max_allowed_distance()
	return FLOOR((crystals.len * telepad.efficiency * powerCoefficient), 1)

/obj/machinery/computer/telescience/attack_ai(mob/user)
	src.attack_hand(user)

/obj/machinery/computer/telescience/attack_hand(mob/user)
	if(..())
		return
	tgui_interact(user)

/obj/machinery/computer/telescience/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TelesciConsole", name)
		ui.open()

/obj/machinery/computer/telescience/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = list()
	if(!telepad)
		in_use = 0     //Yeah so if you deconstruct teleporter while its in the process of shooting it wont disable the console
		data["noTelepad"] = 1
	else
		data["noTelepad"] = 0
		data["insertedGps"] = inserted_gps
		data["rotation"] = rotation
		data["currentZ"] = z_co
		data["cooldown"] = max(0, min(100, round(teleport_cooldown - world.time) / 10))
		data["crystalCount"] = crystals.len
		data["maxCrystals"] = max_crystals
		data["maxPossibleDistance"] = FLOOR((max_crystals * powerCoefficient * 6), 1); // max efficiency is 6
		data["maxAllowedDistance"] = get_max_allowed_distance()
		data["distance"] = distance

		data["tempMsg"] = temp_msg
		if(telepad.panel_open)
			data["tempMsg"] = "Telepad undergoing physical maintenance operations."

		//We'll base our options on connected z's or overmap
		data["sectorOptions"] = using_map.get_map_levels(z, TRUE, overmap_range)

		data["lastTeleData"] = null
		if(last_tele_data)
			data["lastTeleData"] = list()
			data["lastTeleData"]["src_x"] = last_tele_data.src_x
			data["lastTeleData"]["src_y"] = last_tele_data.src_y
			data["lastTeleData"]["distance"] = last_tele_data.distance
			data["lastTeleData"]["time"] = last_tele_data.time

	return data

/obj/machinery/computer/telescience/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE
	if(!telepad || telepad.panel_open)
		return TRUE

	switch(action)
		if("setrotation")
			rotation = CLAMP(text2num(params["val"]), -900, 900)
			rotation = round(rotation, 0.01)

		if("setdistance")
			distance = CLAMP(text2num(params["val"]), 1, get_max_allowed_distance())
			distance = FLOOR(distance, 1)

		if("setz")
			var/new_z = text2num(params["setz"])
			if(new_z in using_map.player_levels)
				z_co = new_z

		if("ejectGPS")
			if(inserted_gps)
				inserted_gps.forceMove(loc)
				inserted_gps = null

		if("setMemory")
			if(last_target && inserted_gps)
				// TODO - What was this even supposed to do??
				//inserted_gps.locked_location = last_target
				temp_msg = "Location saved."
			else
				temp_msg = "ERROR! No data was stored."

		if("send")
			sending = 1
			teleport(usr)

		if("receive")
			sending = 0
			teleport(usr)

		if("recal")
			recalibrate()
			sparks()
			temp_msg = "NOTICE: Calibration successful."

		if("eject")
			eject()
			temp_msg = "NOTICE: Bluespace crystals ejected."
		else
			return FALSE

	return TRUE

/obj/machinery/computer/telescience/proc/sparks()
	if(telepad)
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread()
		s.set_up(5, 1, get_turf(telepad))
		s.start()
	else
		return

/obj/machinery/computer/telescience/proc/telefail()
	switch(rand(99))
		if(0 to 85)
			sparks()
			visible_message("<span class='warning'>The telepad weakly fizzles.</span>")
			return
		if(86 to 90)
			// Irradiate everyone in telescience!
			for(var/obj/machinery/telepad/E in machines)
				var/L = get_turf(E)
				sparks()
				for(var/mob/living/carbon/human/M in viewers(L, null))
					M.apply_effect((rand(10, 20)), IRRADIATE, 0)
					to_chat(M, "<span class='warning'>You feel strange.</span>")
			return
		if(91 to 98)
			// They did the mash! (They did the monster mash!) The monster mash! (It was a graveyard smash!)
			sparks()
			if(telepad)
				var/L = get_turf(telepad)
				var/blocked = list(/mob/living/simple_mob/hostile)
				var/list/hostiles = typesof(/mob/living/simple_mob/hostile) - blocked
				playsound(L, 'sound/effects/phasein.ogg', 100, 1, extrarange = 3, falloff = 5)
				for(var/i in 1 to rand(1,4))
					var/chosen = pick(hostiles)
					var/mob/living/simple_mob/hostile/H = new chosen
					H.forceMove(L)
			return
		if(99)
			sparks()
			visible_message("<span class='warning'>The telepad changes colors rapidly, and opens a portal, and you see what your mind seems to think is the very threads that hold the pattern of the universe together, and a eerie sense of paranoia creeps into you.</span>")
			spacevine_infestation()
			return

/obj/machinery/computer/telescience/proc/doteleport(mob/user)

	if(teleport_cooldown > world.time)
		return
	if(teleporting)
		return

	if(telepad)
		var/trueDistance = CLAMP(distance + distance_off, 1, get_max_allowed_distance())
		var/trueRotation = rotation + rotation_off

		var/datum/projectile_data/proj_data = simple_projectile_trajectory(telepad.x, telepad.y, trueRotation, trueDistance)
		last_tele_data = proj_data

		var/trueX = proj_data.dest_x
		var/trueY = proj_data.dest_y
		if(trueX < 1 || trueX > world.maxx || trueY < 1 || trueY > world.maxy)
			telefail()
			temp_msg = "ERROR! Target coordinate is outside known time and space!"
			return

		var/spawn_time = round(proj_data.time) * 10

		var/turf/target = locate(trueX, trueY, z_co)
		last_target = target
		var/area/A = get_area(target)
		flick("pad-beam", telepad)

		if(spawn_time > 15) // 1.5 seconds
			playsound(telepad, 'sound/weapons/flash.ogg', 50, 1)
			// Wait depending on the time the projectile took to get there
			teleporting = 1
			temp_msg = "Powering up bluespace crystals. Please wait."

		spawn(spawn_time) // in deciseconds
			if(!telepad)
				return
			if(telepad.inoperable())
				return
			teleporting = 0
			teleport_cooldown = world.time + (spawn_time * 2)
			teles_left -= 1

			// use a lot of power
			use_power(trueDistance * 10000)

			var/datum/effect/effect/system/spark_spread/S = new /datum/effect/effect/system/spark_spread()
			S.set_up(5, 1, get_turf(telepad))
			S.start()

			if(!A || (A.flags & BLUE_SHIELDED))
				telefail()
				temp_msg = "ERROR! Target is shielded from bluespace intersection!"
				return

			temp_msg = "Teleport successful. "
			if(teles_left < 10)
				temp_msg += "Calibration required soon. "
			temp_msg += "Data printed below."

			var/sparks = get_turf(target)
			var/datum/effect/effect/system/spark_spread/Y = new /datum/effect/effect/system/spark_spread()
			Y.set_up(5, 1, sparks)
			Y.start()

			var/turf/source = target
			var/turf/dest = get_turf(telepad)
			var/log_msg = ""
			log_msg += ": [key_name(user)] has teleported "

			if(sending)
				source = dest
				dest = target

			flick("pad-beam", telepad)
			playsound(telepad, 'sound/weapons/emitter2.ogg', 25, 1, extrarange = 3, falloff = 5)
			for(var/atom/movable/ROI in source)
				// if is anchored, don't let through
				if(ROI.anchored)
					if(isliving(ROI))
						var/mob/living/L = ROI
						if(L.buckled)
							// TP people on office chairs
							if(L.buckled.anchored)
								continue

							log_msg += "[key_name(L)] (on a chair), "
						else
							continue
					else if(!isobserver(ROI))
						continue
				if(ismob(ROI))
					var/mob/T = ROI
					log_msg += "[key_name(T)], "
				else
					log_msg += "[ROI.name]"
					if (istype(ROI, /obj/structure/closet))
						var/obj/structure/closet/C = ROI
						log_msg += " ("
						for(var/atom/movable/Q as mob|obj in C)
							if(ismob(Q))
								log_msg += "[key_name(Q)], "
							else
								log_msg += "[Q.name], "
						if (dd_hassuffix(log_msg, "("))
							log_msg += "empty)"
						else
							log_msg += ")"
					log_msg += ", "
				do_teleport(ROI, dest)

			if (!dd_hassuffix(log_msg, ", "))
				log_msg += "nothing"
			log_msg += " [sending ? "to" : "from"] [trueX], [trueY], [z_co] ([A ? A.name : "null area"])"
			investigate_log(log_msg, "telesci")
			updateDialog()

/obj/machinery/computer/telescience/proc/teleport(mob/user)
	distance = CLAMP(distance, 0, get_max_allowed_distance())
	if(rotation == null || distance == null || z_co == null)
		temp_msg = "ERROR! Set a distance, rotation and sector."
		return
	if(distance <= 0)
		telefail()
		temp_msg = "ERROR! No distance selected!"
		return
	if(!(z_co in using_map.player_levels))
		telefail()
		temp_msg = "ERROR! Sector is outside known time and space!"
		return
	if(teles_left > 0)
		doteleport(user)
	else
		telefail()
		temp_msg = "ERROR! Calibration required."
		return
	return

/obj/machinery/computer/telescience/proc/eject()
	for(var/obj/item/I in crystals)
		I.forceMove(src.loc)
		crystals -= I
	distance = 0

/obj/machinery/computer/telescience/proc/recalibrate()
	teles_left = rand(40, 50)
	distance_off = rand(-4, 4)
	rotation_off = rand(-10, 10)


// Procedure that calculates the actual trajectory taken!
/proc/simple_projectile_trajectory(var/src_x, var/src_y, var/rotation, var/distance)
	var/time = distance / 10 // 100ms per distance seems fine?
	var/dest_x = src_x + distance*sin(rotation);
	var/dest_y = src_y + distance*cos(rotation);
	return new /datum/projectile_data(src_x, src_y, time, distance, 0, 0, dest_x, dest_y)
