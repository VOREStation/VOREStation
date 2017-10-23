/client/proc/Debug2()
	set category = "Debug"
	set name = "Debug-Game"
	if(!check_rights(R_DEBUG))	return

	if(Debug2)
		Debug2 = 0
		message_admins("[key_name(src)] toggled debugging off.")
		log_admin("[key_name(src)] toggled debugging off.")
	else
		Debug2 = 1
		message_admins("[key_name(src)] toggled debugging on.")
		log_admin("[key_name(src)] toggled debugging on.")

	feedback_add_details("admin_verb","DG2") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

// callproc moved to code/modules/admin/callproc

/client/proc/Cell()
	set category = "Debug"
	set name = "Cell"
	if(!mob)
		return
	var/turf/T = mob.loc

	if (!( istype(T, /turf) ))
		return

	var/datum/gas_mixture/env = T.return_air()

	var/t = "<font color='blue'>Coordinates: [T.x],[T.y],[T.z]\n</font>"
	t += "<font color='red'>Temperature: [env.temperature]\n</font>"
	t += "<font color='red'>Pressure: [env.return_pressure()]kPa\n</font>"
	for(var/g in env.gas)
		t += "<font color='blue'>[g]: [env.gas[g]] / [env.gas[g] * R_IDEAL_GAS_EQUATION * env.temperature / env.volume]kPa\n</font>"

	usr.show_message(t, 1)
	feedback_add_details("admin_verb","ASL") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_robotize(var/mob/M in mob_list)
	set category = "Fun"
	set name = "Make Robot"

	if(!ticker)
		alert("Wait until the game starts")
		return
	if(istype(M, /mob/living/carbon/human))
		log_admin("[key_name(src)] has robotized [M.key].")
		spawn(10)
			M:Robotize()

	else
		alert("Invalid mob")

/client/proc/cmd_admin_animalize(var/mob/M in mob_list)
	set category = "Fun"
	set name = "Make Simple Animal"

	if(!ticker)
		alert("Wait until the game starts")
		return

	if(!M)
		alert("That mob doesn't seem to exist, close the panel and try again.")
		return

	if(istype(M, /mob/new_player))
		alert("The mob must not be a new_player.")
		return

	log_admin("[key_name(src)] has animalized [M.key].")
	spawn(10)
		M.Animalize()


/client/proc/makepAI(var/turf/T in mob_list)
	set category = "Fun"
	set name = "Make pAI"
	set desc = "Specify a location to spawn a pAI device, then specify a key to play that pAI"

	var/list/available = list()
	for(var/mob/C in mob_list)
		if(C.key)
			available.Add(C)
	var/mob/choice = input("Choose a player to play the pAI", "Spawn pAI") in available
	if(!choice)
		return 0
	if(!istype(choice, /mob/observer/dead))
		var/confirm = input("[choice.key] isn't ghosting right now. Are you sure you want to yank them out of them out of their body and place them in this pAI?", "Spawn pAI Confirmation", "No") in list("Yes", "No")
		if(confirm != "Yes")
			return 0
	var/obj/item/device/paicard/card = new(T)
	var/mob/living/silicon/pai/pai = new(card)
	pai.name = sanitizeSafe(input(choice, "Enter your pAI name:", "pAI Name", "Personal AI") as text)
	pai.real_name = pai.name
	pai.key = choice.key
	card.setPersonality(pai)
	for(var/datum/paiCandidate/candidate in paiController.pai_candidates)
		if(candidate.key == choice.key)
			paiController.pai_candidates.Remove(candidate)
	feedback_add_details("admin_verb","MPAI") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_alienize(var/mob/M in mob_list)
	set category = "Fun"
	set name = "Make Alien"

	if(!ticker)
		alert("Wait until the game starts")
		return
	if(ishuman(M))
		log_admin("[key_name(src)] has alienized [M.key].")
		spawn(10)
			M:Alienize()
			feedback_add_details("admin_verb","MKAL") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
		log_admin("[key_name(usr)] made [key_name(M)] into an alien.")
		message_admins("<span class='notice'>[key_name_admin(usr)] made [key_name(M)] into an alien.</span>", 1)
	else
		alert("Invalid mob")

/*
/client/proc/cmd_admin_monkeyize(var/mob/M in world)
	set category = "Fun"
	set name = "Make Monkey"

	if(!ticker)
		alert("Wait until the game starts")
		return
	if(istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/target = M
		log_admin("[key_name(src)] is attempting to monkeyize [M.key].")
		spawn(10)
			target.monkeyize()
	else
		alert("Invalid mob")

/client/proc/cmd_admin_changelinginize(var/mob/M in world)
	set category = "Fun"
	set name = "Make Changeling"

	if(!ticker)
		alert("Wait until the game starts")
		return
	if(istype(M, /mob/living/carbon/human))
		log_admin("[key_name(src)] has made [M.key] a changeling.")
		spawn(10)
			M.absorbed_dna[M.real_name] = M.dna.Clone()
			M.make_changeling()
			if(M.mind)
				M.mind.special_role = "Changeling"
	else
		alert("Invalid mob")
*/
/*
/client/proc/cmd_admin_abominize(var/mob/M in world)
	set category = null
	set name = "Make Abomination"

	usr << "Ruby Mode disabled. Command aborted."
	return
	if(!ticker)
		alert("Wait until the game starts.")
		return
	if(istype(M, /mob/living/carbon/human))
		log_admin("[key_name(src)] has made [M.key] an abomination.")

	//	spawn(10)
	//		M.make_abomination()

*/
/*
/client/proc/make_cultist(var/mob/M in world) // -- TLE, modified by Urist
	set category = "Fun"
	set name = "Make Cultist"
	set desc = "Makes target a cultist"
	if(!cultwords["travel"])
		runerandom()
	if(M)
		if(M.mind in ticker.mode.cult)
			return
		else
			if(alert("Spawn that person a tome?",,"Yes","No")=="Yes")
				M << "<font color='red'>You catch a glimpse of the Realm of Nar-Sie, The Geometer of Blood. You now see how flimsy the world is, you see that it should be open to the knowledge of Nar-Sie. A tome, a message from your new master, appears on the ground.</font>"
				new /obj/item/weapon/book/tome(M.loc)
			else
				M << "<font color='red'>You catch a glimpse of the Realm of Nar-Sie, The Geometer of Blood. You now see how flimsy the world is, you see that it should be open to the knowledge of Nar-Sie.</font>"
			var/glimpse=pick("1","2","3","4","5","6","7","8")
			switch(glimpse)
				if("1")
					M << "<font color='red'>You remembered one thing from the glimpse... [cultwords["travel"]] is travel...</font>"
				if("2")
					M << "<font color='red'>You remembered one thing from the glimpse... [cultwords["blood"]] is blood...</font>"
				if("3")
					M << "<font color='red'>You remembered one thing from the glimpse... [cultwords["join"]] is join...</font>"
				if("4")
					M << "<font color='red'>You remembered one thing from the glimpse... [cultwords["hell"]] is Hell...</font>"
				if("5")
					M << "<font color='red'>You remembered one thing from the glimpse... [cultwords["destroy"]] is destroy...</font>"
				if("6")
					M << "<font color='red'>You remembered one thing from the glimpse... [cultwords["technology"]] is technology...</font>"
				if("7")
					M << "<font color='red'>You remembered one thing from the glimpse... [cultwords["self"]] is self...</font>"
				if("8")
					M << "<font color='red'>You remembered one thing from the glimpse... [cultwords["see"]] is see...</font>"

			if(M.mind)
				M.mind.special_role = "Cultist"
				ticker.mode.cult += M.mind
			src << "Made [M] a cultist."
*/

//TODO: merge the vievars version into this or something maybe mayhaps
/client/proc/cmd_debug_del_all()
	set category = "Debug"
	set name = "Del-All"

	// to prevent REALLY stupid deletions
	var/blocked = list(/obj, /mob, /mob/living, /mob/living/carbon, /mob/living/carbon/human, /mob/observer/dead, /mob/living/silicon, /mob/living/silicon/robot, /mob/living/silicon/ai)
	var/hsbitem = input(usr, "Choose an object to delete.", "Delete:") as null|anything in typesof(/obj) + typesof(/mob) - blocked
	if(hsbitem)
		for(var/atom/O in world)
			if(istype(O, hsbitem))
				qdel(O)
		log_admin("[key_name(src)] has deleted all instances of [hsbitem].")
		message_admins("[key_name_admin(src)] has deleted all instances of [hsbitem].", 0)
	feedback_add_details("admin_verb","DELA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_debug_make_powernets()
	set category = "Debug"
	set name = "Make Powernets"
	makepowernets()
	log_admin("[key_name(src)] has remade the powernet. makepowernets() called.")
	message_admins("[key_name_admin(src)] has remade the powernets. makepowernets() called.", 0)
	feedback_add_details("admin_verb","MPWN") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_debug_tog_aliens()
	set category = "Server"
	set name = "Toggle Aliens"

	config.aliens_allowed = !config.aliens_allowed
	log_admin("[key_name(src)] has turned aliens [config.aliens_allowed ? "on" : "off"].")
	message_admins("[key_name_admin(src)] has turned aliens [config.aliens_allowed ? "on" : "off"].", 0)
	feedback_add_details("admin_verb","TAL") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_grantfullaccess(var/mob/M in mob_list)
	set category = "Admin"
	set name = "Grant Full Access"

	if (!ticker)
		alert("Wait until the game starts")
		return
	if (istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		if (H.wear_id)
			var/obj/item/weapon/card/id/id = H.wear_id
			if(istype(H.wear_id, /obj/item/device/pda))
				var/obj/item/device/pda/pda = H.wear_id
				id = pda.id
			id.icon_state = "gold"
			id.access = get_all_accesses()
		else
			var/obj/item/weapon/card/id/id = new/obj/item/weapon/card/id(M);
			id.icon_state = "gold"
			id.access = get_all_accesses()
			id.registered_name = H.real_name
			id.assignment = "Colony Director"
			id.name = "[id.registered_name]'s ID Card ([id.assignment])"
			H.equip_to_slot_or_del(id, slot_wear_id)
			H.update_inv_wear_id()
	else
		alert("Invalid mob")
	feedback_add_details("admin_verb","GFA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	log_admin("[key_name(src)] has granted [M.key] full access.")
	message_admins("<font color='blue'>[key_name_admin(usr)] has granted [M.key] full access.</font>", 1)

/client/proc/cmd_assume_direct_control(var/mob/M in mob_list)
	set category = "Admin"
	set name = "Assume direct control"
	set desc = "Direct intervention"

	if(!check_rights(R_DEBUG|R_ADMIN))	return
	if(M.ckey)
		if(alert("This mob is being controlled by [M.ckey]. Are you sure you wish to assume control of it? [M.ckey] will be made a ghost.",,"Yes","No") != "Yes")
			return
		else
			var/mob/observer/dead/ghost = new/mob/observer/dead(M,1)
			ghost.ckey = M.ckey
	message_admins("<font color='blue'>[key_name_admin(usr)] assumed direct control of [M].</font>", 1)
	log_admin("[key_name(usr)] assumed direct control of [M].")
	var/mob/adminmob = src.mob
	M.ckey = src.ckey
	if( isobserver(adminmob) )
		qdel(adminmob)
	feedback_add_details("admin_verb","ADC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!






/client/proc/cmd_admin_areatest()
	set category = "Mapping"
	set name = "Test areas"

	var/list/areas_all = list()
	var/list/areas_with_APC = list()
	var/list/areas_with_air_alarm = list()
	var/list/areas_with_RC = list()
	var/list/areas_with_light = list()
	var/list/areas_with_LS = list()
	var/list/areas_with_intercom = list()
	var/list/areas_with_camera = list()

	for(var/area/A in world)
		if(!(A.type in areas_all))
			areas_all.Add(A.type)

	for(var/obj/machinery/power/apc/APC in world)
		var/area/A = get_area(APC)
		if(A && !(A.type in areas_with_APC))
			areas_with_APC.Add(A.type)

	for(var/obj/machinery/alarm/alarm in world)
		var/area/A = get_area(alarm)
		if(A && !(A.type in areas_with_air_alarm))
			areas_with_air_alarm.Add(A.type)

	for(var/obj/machinery/requests_console/RC in world)
		var/area/A = get_area(RC)
		if(A && !(A.type in areas_with_RC))
			areas_with_RC.Add(A.type)

	for(var/obj/machinery/light/L in world)
		var/area/A = get_area(L)
		if(A && !(A.type in areas_with_light))
			areas_with_light.Add(A.type)

	for(var/obj/machinery/light_switch/LS in world)
		var/area/A = get_area(LS)
		if(A && !(A.type in areas_with_LS))
			areas_with_LS.Add(A.type)

	for(var/obj/item/device/radio/intercom/I in world)
		var/area/A = get_area(I)
		if(A && !(A.type in areas_with_intercom))
			areas_with_intercom.Add(A.type)

	for(var/obj/machinery/camera/C in world)
		var/area/A = get_area(C)
		if(A && !(A.type in areas_with_camera))
			areas_with_camera.Add(A.type)

	var/list/areas_without_APC = areas_all - areas_with_APC
	var/list/areas_without_air_alarm = areas_all - areas_with_air_alarm
	var/list/areas_without_RC = areas_all - areas_with_RC
	var/list/areas_without_light = areas_all - areas_with_light
	var/list/areas_without_LS = areas_all - areas_with_LS
	var/list/areas_without_intercom = areas_all - areas_with_intercom
	var/list/areas_without_camera = areas_all - areas_with_camera

	world << "<b>AREAS WITHOUT AN APC:</b>"
	for(var/areatype in areas_without_APC)
		world << "* [areatype]"

	world << "<b>AREAS WITHOUT AN AIR ALARM:</b>"
	for(var/areatype in areas_without_air_alarm)
		world << "* [areatype]"

	world << "<b>AREAS WITHOUT A REQUEST CONSOLE:</b>"
	for(var/areatype in areas_without_RC)
		world << "* [areatype]"

	world << "<b>AREAS WITHOUT ANY LIGHTS:</b>"
	for(var/areatype in areas_without_light)
		world << "* [areatype]"

	world << "<b>AREAS WITHOUT A LIGHT SWITCH:</b>"
	for(var/areatype in areas_without_LS)
		world << "* [areatype]"

	world << "<b>AREAS WITHOUT ANY INTERCOMS:</b>"
	for(var/areatype in areas_without_intercom)
		world << "* [areatype]"

	world << "<b>AREAS WITHOUT ANY CAMERAS:</b>"
	for(var/areatype in areas_without_camera)
		world << "* [areatype]"

/datum/admins/proc/cmd_admin_dress(input in getmobs())
	set category = "Fun"
	set name = "Select equipment"

	if(!check_rights(R_FUN))
		return

	var/target = getmobs()[input]
	if(!target)
		return

	if(!ishuman(target))
		return

	var/mob/living/carbon/human/H = target

	var/decl/hierarchy/outfit/outfit = input("Select outfit.", "Select equipment.") as null|anything in outfits()
	if(!outfit)
		return

	feedback_add_details("admin_verb","SEQ")
	dressup_human(H, outfit, 1)

/proc/dressup_human(var/mob/living/carbon/human/H, var/decl/hierarchy/outfit/outfit, var/undress = 1)
	if(!H || !outfit)
		return
	if(undress)
		H.delete_inventory()
	outfit.equip(H)
	log_and_message_admins("changed the equipment of [key_name(H)] to [outfit.name].")

/client/proc/startSinglo()

	set category = "Debug"
	set name = "Start Singularity"
	set desc = "Sets up the singularity and all machines to get power flowing through the station"

	if(alert("Are you sure? This will start up the engine. Should only be used during debug!",,"Yes","No") != "Yes")
		return

	for(var/obj/machinery/power/emitter/E in world)
		if(E.anchored)
			E.active = 1

	for(var/obj/machinery/field_generator/F in world)
		if(F.anchored)
			F.Varedit_start = 1
	spawn(30)
		for(var/obj/machinery/the_singularitygen/G in world)
			if(G.anchored)
				var/obj/singularity/S = new /obj/singularity(get_turf(G), 50)
				spawn(0)
					qdel(G)
				S.energy = 1750
				S.current_size = 7
				S.icon = 'icons/effects/224x224.dmi'
				S.icon_state = "singularity_s7"
				S.pixel_x = -96
				S.pixel_y = -96
				S.grav_pull = 0
				//S.consume_range = 3
				S.dissipate = 0
				//S.dissipate_delay = 10
				//S.dissipate_track = 0
				//S.dissipate_strength = 10

	for(var/obj/machinery/power/rad_collector/Rad in world)
		if(Rad.anchored)
			if(!Rad.P)
				var/obj/item/weapon/tank/phoron/Phoron = new/obj/item/weapon/tank/phoron(Rad)
				Phoron.air_contents.gas["phoron"] = 70
				Rad.drainratio = 0
				Rad.P = Phoron
				Phoron.loc = Rad

			if(!Rad.active)
				Rad.toggle_power()

	for(var/obj/machinery/power/smes/SMES in world)
		if(SMES.anchored)
			SMES.input_attempt = 1

/client/proc/setup_supermatter_engine()
	set category = "Debug"
	set name = "Setup supermatter"
	set desc = "Sets up the supermatter engine"

	if(!check_rights(R_DEBUG|R_ADMIN))      return

	var/response = alert("Are you sure? This will start up the engine. Should only be used during debug!",,"Setup Completely","Setup except coolant","No")

	if(response == "No")
		return

	var/found_the_pump = 0
	var/obj/machinery/power/supermatter/SM

	for(var/obj/machinery/M in world)
		if(!M)
			continue
		if(!M.loc)
			continue
		if(!M.loc.loc)
			continue

		if(istype(M.loc.loc,/area/engineering/engine_room))
			if(istype(M,/obj/machinery/power/rad_collector))
				var/obj/machinery/power/rad_collector/Rad = M
				Rad.anchored = 1
				Rad.connect_to_network()

				var/obj/item/weapon/tank/phoron/Phoron = new/obj/item/weapon/tank/phoron(Rad)

				Phoron.air_contents.gas["phoron"] = 29.1154	//This is a full tank if you filled it from a canister
				Rad.P = Phoron

				Phoron.loc = Rad

				if(!Rad.active)
					Rad.toggle_power()
				Rad.update_icon()

			else if(istype(M,/obj/machinery/atmospherics/binary/pump))	//Turning on every pump.
				var/obj/machinery/atmospherics/binary/pump/Pump = M
				if(Pump.name == "Engine Feed" && response == "Setup Completely")
					found_the_pump = 1
					Pump.air2.gas["nitrogen"] = 3750	//The contents of 2 canisters.
					Pump.air2.temperature = 50
					Pump.air2.update_values()
				Pump.use_power=1
				Pump.target_pressure = 4500
				Pump.update_icon()

			else if(istype(M,/obj/machinery/power/supermatter))
				SM = M
				spawn(50)
					SM.power = 320

			else if(istype(M,/obj/machinery/power/smes))	//This is the SMES inside the engine room.  We don't need much power.
				var/obj/machinery/power/smes/SMES = M
				SMES.input_attempt = 1
				SMES.input_level = 200000
				SMES.output_level = 75000

		else if(istype(M.loc.loc,/area/engineering/engine_smes))	//Set every SMES to charge and spit out 300,000 power between the 4 of them.
			if(istype(M,/obj/machinery/power/smes))
				var/obj/machinery/power/smes/SMES = M
				SMES.input_attempt = 1
				SMES.input_level = 200000
				SMES.output_level = 75000

	if(!found_the_pump && response == "Setup Completely")
		src << "<font color='red'>Unable to locate air supply to fill up with coolant, adding some coolant around the supermatter</font>"
		var/turf/simulated/T = SM.loc
		T.zone.air.gas["nitrogen"] += 450
		T.zone.air.temperature = 50
		T.zone.air.update_values()


	log_admin("[key_name(usr)] setup the supermatter engine [response == "Setup except coolant" ? "without coolant" : ""]")
	message_admins("<font color='blue'>[key_name_admin(usr)] setup the supermatter engine  [response == "Setup except coolant" ? "without coolant": ""]</font>", 1)
	return



/client/proc/cmd_debug_mob_lists()
	set category = "Debug"
	set name = "Debug Mob Lists"
	set desc = "For when you just gotta know"

	switch(input("Which list?") in list("Players","Admins","Mobs","Living Mobs","Dead Mobs", "Clients"))
		if("Players")
			usr << jointext(player_list,",")
		if("Admins")
			usr << jointext(admins,",")
		if("Mobs")
			usr << jointext(mob_list,",")
		if("Living Mobs")
			usr << jointext(living_mob_list,",")
		if("Dead Mobs")
			usr << jointext(dead_mob_list,",")
		if("Clients")
			usr << jointext(clients,",")

/client/proc/cmd_debug_using_map()
	set category = "Debug"
	set name = "Debug Map Datum"
	set desc = "Debug the map metadata about the currently compiled in map."

	if(!check_rights(R_DEBUG))
		return
	debug_variables(using_map)

// DNA2 - Admin Hax
/client/proc/cmd_admin_toggle_block(var/mob/M,var/block)
	if(!ticker)
		alert("Wait until the game starts")
		return
	if(istype(M, /mob/living/carbon))
		M.dna.SetSEState(block,!M.dna.GetSEState(block))
		domutcheck(M,null,MUTCHK_FORCED)
		M.update_mutations()
		var/state="[M.dna.GetSEState(block)?"on":"off"]"
		var/blockname=assigned_blocks[block]
		message_admins("[key_name_admin(src)] has toggled [M.key]'s [blockname] block [state]!")
		log_admin("[key_name(src)] has toggled [M.key]'s [blockname] block [state]!")
	else
		alert("Invalid mob")

/datum/admins/proc/view_runtimes()
	set category = "Debug"
	set name = "View Runtimes"
	set desc = "Open the Runtime Viewer"

	if(!check_rights(R_DEBUG))
		return

	error_cache.showTo(usr)

/datum/admins/proc/change_weather()
	set category = "Debug"
	set name = "Change Weather"
	set desc = "Changes the current weather."

	if(!check_rights(R_DEBUG))
		return

	var/datum/planet/planet = input(usr, "Which planet do you want to modify the weather on?", "Change Weather") in planet_controller.planets
	var/datum/weather/new_weather = input(usr, "What weather do you want to change to?", "Change Weather") as null|anything in planet.weather_holder.allowed_weather_types
	if(new_weather)
		planet.weather_holder.change_weather(new_weather)
		var/log = "[key_name(src)] changed [planet.name]'s weather to [new_weather]."
		message_admins(log)
		log_admin(log)

/datum/admins/proc/change_time()
	set category = "Debug"
	set name = "Change Planet Time"
	set desc = "Changes the time of a planet."

	if(!check_rights(R_DEBUG))
		return

	var/datum/planet/planet = input(usr, "Which planet do you want to modify time on?", "Change Time") in planet_controller.planets

	var/datum/time/current_time_datum = planet.current_time
	var/new_hour = input(usr, "What hour do you want to change to?", "Change Time", text2num(current_time_datum.show_time("hh"))) as null|num
	if(!isnull(new_hour))
		var/new_minute = input(usr, "What minute do you want to change to?", "Change Time", text2num(current_time_datum.show_time("mm")) ) as null|num
		if(!isnull(new_minute))
			var/type_needed = current_time_datum.type
			var/datum/time/new_time = new type_needed()
			new_time = new_time.add_hours(new_hour)
			new_time = new_time.add_minutes(new_minute)
			planet.current_time = new_time
			spawn(1)
				planet.update_sun()

			var/log = "[key_name(src)] changed [planet.name]'s time to [planet.current_time.show_time("hh:mm")]."
			message_admins(log)
			log_admin(log)