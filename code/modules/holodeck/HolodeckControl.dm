/obj/machinery/computer/HolodeckControl
	name = "holodeck control console"
	desc = "A computer used to control a nearby holodeck."
	icon_keyboard = "tech_key"
	icon_screen = "holocontrol"

	use_power = 1
	active_power_usage = 8000 //8kW for the scenery + 500W per holoitem
	var/item_power_usage = 500

	var/area/linkedholodeck = null
	var/area/target = null
	var/active = 0
	var/list/holographic_objs = list()
	var/list/holographic_mobs = list()
	var/damaged = 0
	var/safety_disabled = 0
	var/mob/last_to_emag = null
	var/last_change = 0
	var/last_gravity_change = 0

	var/area/projection_area = /area/holodeck/alphadeck
	var/current_program
	var/powerdown_program = "Turn Off"
	var/default_program = "Empty Court"

	var/list/supported_programs = list(
	"Empty Court" 		= new/datum/holodeck_program(/area/holodeck/source_emptycourt, list('sound/music/THUNDERDOME.ogg')),
	"Boxing Ring" 		= new/datum/holodeck_program(/area/holodeck/source_boxingcourt, list('sound/music/THUNDERDOME.ogg')),
	"Basketball" 		= new/datum/holodeck_program(/area/holodeck/source_basketball, list('sound/music/THUNDERDOME.ogg')),
	"Thunderdome"		= new/datum/holodeck_program(/area/holodeck/source_thunderdomecourt, list('sound/music/THUNDERDOME.ogg')),
	"Beach" 			= new/datum/holodeck_program(/area/holodeck/source_beach),
	"Desert" 			= new/datum/holodeck_program(/area/holodeck/source_desert,
													list(
														'sound/effects/weather/wind/wind_2_1.ogg',
											 			'sound/effects/weather/wind/wind_2_2.ogg',
											 			'sound/effects/weather/wind/wind_3_1.ogg',
											 			'sound/effects/weather/wind/wind_4_1.ogg',
											 			'sound/effects/weather/wind/wind_4_2.ogg',
											 			'sound/effects/weather/wind/wind_5_1.ogg'
												 		)
		 											),
	"Snowfield" 		= new/datum/holodeck_program(/area/holodeck/source_snowfield,
													list(
														'sound/effects/weather/wind/wind_2_1.ogg',
											 			'sound/effects/weather/wind/wind_2_2.ogg',
											 			'sound/effects/weather/wind/wind_3_1.ogg',
											 			'sound/effects/weather/wind/wind_4_1.ogg',
											 			'sound/effects/weather/wind/wind_4_2.ogg',
											 			'sound/effects/weather/wind/wind_5_1.ogg'
												 		)
		 											),
	"Space" 			= new/datum/holodeck_program(/area/holodeck/source_space,
													list(
														'sound/ambience/ambispace.ogg',
														'sound/music/main.ogg',
														'sound/music/space.ogg',
														'sound/music/traitor.ogg',
														)
													),
	"Picnic Area" 		= new/datum/holodeck_program(/area/holodeck/source_picnicarea, list('sound/music/title2.ogg')),
	"Theatre" 			= new/datum/holodeck_program(/area/holodeck/source_theatre),
	"Meetinghall" 		= new/datum/holodeck_program(/area/holodeck/source_meetinghall),
	"Courtroom" 		= new/datum/holodeck_program(/area/holodeck/source_courtroom, list('sound/music/traitor.ogg')),
	"Turn Off" 			= new/datum/holodeck_program(/area/holodeck/source_plating, list())
	)

	var/list/restricted_programs = list(
	"Burnoff Test Simulation"	= new/datum/holodeck_program(/area/holodeck/source_burntest, list()),
	"Wildlife Simulation" 		= new/datum/holodeck_program(/area/holodeck/source_wildlife, list())
	)

/obj/machinery/computer/HolodeckControl/attack_ai(var/mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/HolodeckControl/attack_hand(var/mob/user as mob)
	if(..())
		return
	user.set_machine(src)

	ui_interact(user)

/**
 *  Display the NanoUI window for the Holodeck Computer.
 *
 *  See NanoUI documentation for details.
 */
/obj/machinery/computer/HolodeckControl/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	user.set_machine(src)

	var/list/data = list()
	var/program_list[0]
	var/restricted_program_list[0]

	for(var/P in supported_programs)
		program_list[++program_list.len] = P

	for(var/P in restricted_programs)
		restricted_program_list[++restricted_program_list.len] = P

	data["supportedPrograms"] = program_list
	data["restrictedPrograms"] = restricted_program_list
	data["currentProgram"] = current_program
	if(issilicon(user))
		data["isSilicon"] = 1
	else
		data["isSilicon"] = null
	data["safetyDisabled"] = safety_disabled
	data["emagged"] = emagged
	if(linkedholodeck.has_gravity)
		data["gravity"] = 1
	else
		data["gravity"] = null

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "holodeck.tmpl", src.name, 400, 550)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(20)

/obj/machinery/computer/HolodeckControl/Topic(href, href_list)
	if(..())
		return 1
	if((usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf))) || (istype(usr, /mob/living/silicon)))
		usr.set_machine(src)

		if(href_list["program"])
			var/prog = href_list["program"]
			if(prog in (supported_programs + restricted_programs))
				if(loadProgram(prog))
					current_program = prog

		else if(href_list["AIoverride"])
			if(!issilicon(usr))
				return

			if(safety_disabled && emagged)
				return //if a traitor has gone through the trouble to emag the thing, let them keep it.

			safety_disabled = !safety_disabled
			update_projections()
			if(safety_disabled)
				message_admins("[key_name_admin(usr)] overrode the holodeck's safeties")
				log_game("[key_name(usr)] overrided the holodeck's safeties")
			else
				message_admins("[key_name_admin(usr)] restored the holodeck's safeties")
				log_game("[key_name(usr)] restored the holodeck's safeties")

		else if(href_list["gravity"])
			toggleGravity(linkedholodeck)

		src.add_fingerprint(usr)

	SSnanoui.update_uis(src)

/obj/machinery/computer/HolodeckControl/emag_act(var/remaining_charges, var/mob/user as mob)
	playsound(src.loc, 'sound/effects/sparks4.ogg', 75, 1)
	last_to_emag = user //emag again to change the owner
	if (!emagged)
		emagged = 1
		safety_disabled = 1
		update_projections()
		to_chat(user, "<span class='notice'>You vastly increase projector power and override the safety and security protocols.</span>")
		to_chat(user, "Warning.  Automatic shutoff and derezing protocols have been corrupted.  Please call [using_map.company_name] maintenance and do not use the simulator.")
		log_game("[key_name(usr)] emagged the Holodeck Control Computer")
		return 1
	return

/obj/machinery/computer/HolodeckControl/proc/update_projections()
	if (safety_disabled)
		item_power_usage = 2500
		for(var/obj/item/weapon/holo/esword/H in linkedholodeck)
			H.damtype = BRUTE
	else
		item_power_usage = initial(item_power_usage)
		for(var/obj/item/weapon/holo/esword/H in linkedholodeck)
			H.damtype = initial(H.damtype)

	for(var/mob/living/simple_mob/animal/space/carp/holodeck/C in holographic_mobs)
		C.set_safety(!safety_disabled)
		if (last_to_emag)
			C.friends = list(last_to_emag)

/obj/machinery/computer/HolodeckControl/New()
	..()
	current_program = powerdown_program
	linkedholodeck = locate(projection_area)
	if(!linkedholodeck)
		to_world("<span class='danger'>Holodeck computer at [x],[y],[z] failed to locate projection area.</span>")

//This could all be done better, but it works for now.
/obj/machinery/computer/HolodeckControl/Destroy()
	emergencyShutdown()
	..()

/obj/machinery/computer/HolodeckControl/ex_act(severity)
	emergencyShutdown()
	..()

/obj/machinery/computer/HolodeckControl/power_change()
	var/oldstat
	..()
	if (stat != oldstat && active && (stat & NOPOWER))
		emergencyShutdown()

/obj/machinery/computer/HolodeckControl/process()
	for(var/item in holographic_objs) // do this first, to make sure people don't take items out when power is down.
		if(!(get_turf(item) in linkedholodeck))
			derez(item, 0)

	if (!safety_disabled)
		for(var/mob/living/simple_mob/animal/space/carp/holodeck/C in holographic_mobs)
			if (get_area(C.loc) != linkedholodeck)
				holographic_mobs -= C
				C.derez()

	if(!..())
		return
	if(active)
		use_power(item_power_usage * (holographic_objs.len + holographic_mobs.len))

		if(!checkInteg(linkedholodeck))
			damaged = 1
			loadProgram(powerdown_program, 0)
			active = 0
			use_power = 1
			for(var/mob/M in range(10,src))
				M.show_message("The holodeck overloads!")


			for(var/turf/T in linkedholodeck)
				if(prob(30))
					var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
					s.set_up(2, 1, T)
					s.start()
				T.ex_act(3)
				T.hotspot_expose(1000,500,1)

/obj/machinery/computer/HolodeckControl/proc/derez(var/obj/obj , var/silent = 1)
	holographic_objs.Remove(obj)

	if(obj == null)
		return

	if(isobj(obj))
		var/mob/M = obj.loc
		if(ismob(M))
			M.remove_from_mob(obj)

	if(!silent)
		var/obj/oldobj = obj
		visible_message("The [oldobj.name] fades away!")
	qdel(obj)

/obj/machinery/computer/HolodeckControl/proc/checkInteg(var/area/A)
	for(var/turf/T in A)
		if(istype(T, /turf/space))
			return 0

	return 1

//Why is it called toggle if it doesn't toggle?
/obj/machinery/computer/HolodeckControl/proc/togglePower(var/toggleOn = 0)
	if(toggleOn)
		loadProgram(default_program, 0)
	else
		loadProgram(powerdown_program, 0)

		if(!linkedholodeck.has_gravity)
			linkedholodeck.gravitychange(1,linkedholodeck)

		active = 0
		use_power = 1


/obj/machinery/computer/HolodeckControl/proc/loadProgram(var/prog, var/check_delay = 1)
	if(!prog)
		return

	var/datum/holodeck_program/HP
	if(prog in supported_programs)
		HP = supported_programs[prog]
	else if(prog in restricted_programs)
		HP = restricted_programs[prog]
	if(!HP)
		return

	var/area/A = locate(HP.target)
	if(!A)
		return

	if(check_delay)
		if(world.time < (last_change + 25))
			if(world.time < (last_change + 15))//To prevent super-spam clicking, reduced process size and annoyance -Sieve
				return 0
			for(var/mob/M in range(3,src))
				M.show_message("<b>ERROR. Recalibrating projection apparatus.</b>")
				last_change = world.time
				return 0

	last_change = world.time
	active = 1
	use_power = 2

	for(var/item in holographic_objs)
		derez(item)

	for(var/mob/living/simple_mob/animal/space/carp/holodeck/C in holographic_mobs)
		holographic_mobs -= C
		C.derez()

	for(var/obj/effect/decal/cleanable/blood/B in linkedholodeck)
		qdel(B)

	holographic_objs = A.copy_contents_to(linkedholodeck , 1)
	for(var/obj/holo_obj in holographic_objs)
		holo_obj.alpha *= 0.8 //give holodeck objs a slight transparency

	if(HP.ambience)
		linkedholodeck.forced_ambience = HP.ambience
	else
		linkedholodeck.forced_ambience = list()

	for(var/mob/living/M in mobs_in_area(linkedholodeck))
		if(M.mind)
			linkedholodeck.play_ambience(M)

	linkedholodeck.sound_env = A.sound_env

	spawn(30)
		for(var/obj/effect/landmark/L in linkedholodeck)
			if(L.name=="Atmospheric Test Start")
				spawn(20)
					var/turf/T = get_turf(L)
					var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
					s.set_up(2, 1, T)
					s.start()
					if(T)
						T.temperature = 5000
						T.hotspot_expose(50000,50000,1)
			if(L.name=="Holocarp Spawn")
				holographic_mobs += new /mob/living/simple_mob/animal/space/carp/holodeck(L.loc)

			if(L.name=="Holocarp Spawn Random")
				if (prob(4)) //With 4 spawn points, carp should only appear 15% of the time.
					holographic_mobs += new /mob/living/simple_mob/animal/space/carp/holodeck(L.loc)

		update_projections()

	return 1


/obj/machinery/computer/HolodeckControl/proc/toggleGravity(var/area/A)
	if(world.time < (last_gravity_change + 25))
		if(world.time < (last_gravity_change + 15))//To prevent super-spam clicking
			return
		for(var/mob/M in range(3,src))
			M.show_message("<b>ERROR. Recalibrating gravity field.</b>")
			last_change = world.time
			return

	last_gravity_change = world.time
	active = 1
	use_power = 1

	if(A.has_gravity)
		A.gravitychange(0,A)
	else
		A.gravitychange(1,A)

/obj/machinery/computer/HolodeckControl/proc/emergencyShutdown()
	//Turn it back to the regular non-holographic room
	loadProgram(powerdown_program, 0)

	if(!linkedholodeck.has_gravity)
		linkedholodeck.gravitychange(1,linkedholodeck)

	active = 0
	use_power = 1
