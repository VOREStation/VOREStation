/client/proc/Debug2()
	set category = "Debug.Investigate"
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

/client/proc/simple_DPS()
	set name = "Simple DPS"
	set category = "Debug.Investigate"
	set desc = "Gives a really basic idea of how much hurt something in-hand does."

	var/obj/item/I = null
	var/mob/living/user = null
	if(isliving(usr))
		user = usr
		I = user.get_active_hand()
		if(!I || !istype(I))
			to_chat(user, span_warning("You need to have something in your active hand, to use this verb."))
			return
		var/weapon_attack_speed = user.get_attack_speed(I) / 10
		var/weapon_damage = I.force
		var/modified_damage_percent = 1

		for(var/datum/modifier/M in user.modifiers)
			if(!isnull(M.outgoing_melee_damage_percent))
				weapon_damage *= M.outgoing_melee_damage_percent
				modified_damage_percent *= M.outgoing_melee_damage_percent

		if(istype(I, /obj/item/gun))
			var/obj/item/gun/G = I
			var/obj/item/projectile/P

			if(istype(I, /obj/item/gun/energy))
				var/obj/item/gun/energy/energy_gun = G
				P = new energy_gun.projectile_type()

			else if(istype(I, /obj/item/gun/projectile))
				var/obj/item/gun/projectile/projectile_gun = G
				var/obj/item/ammo_casing/ammo = projectile_gun.chambered
				P = ammo.BB

			else
				to_chat(user, span_warning("DPS calculation by this verb is not supported for \the [G]'s type. Energy or Ballistic only, sorry."))

			weapon_damage = P.damage
			weapon_attack_speed = G.fire_delay / 10
			qdel(P)

		var/DPS = weapon_damage / weapon_attack_speed
		to_chat(user, span_notice("Damage: [weapon_damage][modified_damage_percent != 1 ? " (Modified by [modified_damage_percent*100]%)":""]"))
		to_chat(user, span_notice("Attack Speed: [weapon_attack_speed]/s"))
		to_chat(user, span_notice("\The [I] does <b>[DPS]</b> damage per second."))
		if(DPS > 0)
			to_chat(user, span_notice("At your maximum health ([user.getMaxHealth()]), it would take approximately;"))
			to_chat(user, span_notice("[(user.getMaxHealth() - CONFIG_GET(number/health_threshold_softcrit)) / DPS] seconds to softcrit you. ([CONFIG_GET(number/health_threshold_softcrit)] health)"))
			to_chat(user, span_notice("[(user.getMaxHealth() - CONFIG_GET(number/health_threshold_crit)) / DPS] seconds to hardcrit you. ([CONFIG_GET(number/health_threshold_crit)] health)"))
			to_chat(user, span_notice("[(user.getMaxHealth() - CONFIG_GET(number/health_threshold_dead)) / DPS] seconds to kill you. ([CONFIG_GET(number/health_threshold_dead)] health)"))

	else
		to_chat(user, span_warning("You need to be a living mob, with hands, and for an object to be in your active hand, to use this verb."))
		return

/client/proc/Cell()
	set category = "Debug.Investigate"
	set name = "Cell"
	if(!mob)
		return
	var/turf/T = mob.loc

	if (!( istype(T, /turf) ))
		return

	var/datum/gas_mixture/env = T.return_air()

	var/t = span_blue("Coordinates: [T.x],[T.y],[T.z]\n")
	t += span_red("Temperature: [env.temperature]\n")
	t += span_red("Pressure: [env.return_pressure()]kPa\n")
	for(var/g in env.gas)
		t += span_blue("[g]: [env.gas[g]] / [env.gas[g] * R_IDEAL_GAS_EQUATION * env.temperature / env.volume]kPa\n")

	usr.show_message(t, 1)
	feedback_add_details("admin_verb","ASL") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_robotize(var/mob/M in mob_list)
	set category = "Fun.Event Kit"
	set name = "Make Robot"

	if(!ticker)
		tgui_alert_async(usr, "Wait until the game starts")
		return
	if(istype(M, /mob/living/carbon/human))
		log_admin("[key_name(src)] has robotized [M.key].")
		spawn(10)
			M:Robotize()

	else
		tgui_alert_async(usr, "Invalid mob")

/client/proc/cmd_admin_animalize(var/mob/M in mob_list)
	set category = "Fun.Event Kit"
	set name = "Make Simple Animal"

	if(!ticker)
		tgui_alert_async(usr, "Wait until the game starts")
		return

	if(!M)
		tgui_alert_async(usr, "That mob doesn't seem to exist, close the panel and try again.")
		return

	if(istype(M, /mob/new_player))
		tgui_alert_async(usr, "The mob must not be a new_player.")
		return

	log_admin("[key_name(src)] has animalized [M.key].")
	spawn(10)
		M.Animalize()


/client/proc/makepAI()
	set category = "Fun.Event Kit"
	set name = "Make pAI"
	set desc = "Spawn someone in as a pAI!"
	if(!check_rights(R_ADMIN|R_EVENT|R_DEBUG))
		return
	var/turf/T = get_turf(mob)

	var/list/available = list()
	for(var/mob/C in mob_list)
		if(C.key && isobserver(C))
			available.Add(C)
	var/mob/choice = tgui_input_list(usr, "Choose a player to play the pAI", "Spawn pAI", available)
	if(!choice)
		return 0
	var/obj/item/paicard/typeb/card = new(T)
	var/mob/living/silicon/pai/pai = new(card)
	pai.real_name = pai.name
	pai.key = choice.key
	card.setPersonality(pai)
	if(tgui_alert(pai, "Do you want to load your pAI data?", "Load", list("Yes", "No")) == "Yes")
		pai.savefile_load(pai)
	else
		pai.name = sanitizeSafe(tgui_input_text(pai, "Enter your pAI name:", "pAI Name", "Personal AI"))
		card.setPersonality(pai)
	for(var/datum/paiCandidate/candidate in paiController.pai_candidates)
		if(candidate.key == choice.key)
			paiController.pai_candidates.Remove(candidate)
	log_admin("made a pAI with key=[pai.key] at ([T.x],[T.y],[T.z])")
	feedback_add_details("admin_verb","MPAI") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_alienize(var/mob/M in mob_list)
	set category = "Fun.Event Kit"
	set name = "Make Alien"

	if(!ticker)
		tgui_alert_async(usr, "Wait until the game starts")
		return
	if(ishuman(M))
		log_admin("[key_name(src)] has alienized [M.key].")
		spawn(10)
			M:Alienize()
			feedback_add_details("admin_verb","MKAL") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
		log_admin("[key_name(usr)] made [key_name(M)] into an alien.")
		message_admins(span_notice("[key_name_admin(usr)] made [key_name(M)] into an alien."), 1)
	else
		tgui_alert_async(usr, "Invalid mob")


//TODO: merge the vievars version into this or something maybe mayhaps
/client/proc/cmd_debug_del_all()
	set category = "Debug.Dangerous"
	set name = "Del-All"

	// to prevent REALLY stupid deletions
	var/blocked = list(/obj, /mob, /mob/living, /mob/living/carbon, /mob/living/carbon/human, /mob/observer/dead, /mob/living/silicon, /mob/living/silicon/robot, /mob/living/silicon/ai)
	var/hsbitem = tgui_input_list(usr, "Choose an object to delete.", "Delete:", typesof(/obj) + typesof(/mob) - blocked)
	if(hsbitem)
		for(var/atom/O in world)
			if(istype(O, hsbitem))
				qdel(O)
		log_admin("[key_name(src)] has deleted all instances of [hsbitem].")
		message_admins("[key_name_admin(src)] has deleted all instances of [hsbitem].", 0)
	feedback_add_details("admin_verb","DELA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_debug_make_powernets()
	set category = "Debug.Dangerous"
	set name = "Make Powernets"
	SSmachines.makepowernets()
	log_admin("[key_name(src)] has remade the powernet. SSmachines.makepowernets() called.")
	message_admins("[key_name_admin(src)] has remade the powernets. SSmachines.makepowernets() called.", 0)
	feedback_add_details("admin_verb","MPWN") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_debug_tog_aliens()
	set category = "Server.Game"
	set name = "Toggle Aliens"

	CONFIG_SET(flag/aliens_allowed, !CONFIG_GET(flag/aliens_allowed))
	log_admin("[key_name(src)] has turned aliens [CONFIG_GET(flag/aliens_allowed) ? "on" : "off"].")
	message_admins("[key_name_admin(src)] has turned aliens [CONFIG_GET(flag/aliens_allowed) ? "on" : "off"].", 0)
	feedback_add_details("admin_verb","TAL") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_display_del_log()
	set category = "Debug.Investigate"
	set name = "Display del() Log"
	set desc = "Display del's log of everything that's passed through it."

	if(!check_rights(R_DEBUG))	return
	var/list/dellog = list(span_bold("List of things that have gone through qdel this round") + "<BR><BR><ol>")
	sortTim(SSgarbage.items, cmp=/proc/cmp_qdel_item_time, associative = TRUE)
	for(var/path in SSgarbage.items)
		var/datum/qdel_item/I = SSgarbage.items[path]
		dellog += "<li><u>[path]</u><ul>"
		if (I.failures)
			dellog += "<li>Failures: [I.failures]</li>"
		dellog += "<li>qdel() Count: [I.qdels]</li>"
		dellog += "<li>Destroy() Cost: [I.destroy_time]ms</li>"
		if (I.hard_deletes)
			dellog += "<li>Total Hard Deletes [I.hard_deletes]</li>"
			dellog += "<li>Time Spent Hard Deleting: [I.hard_delete_time]ms</li>"
		if (I.slept_destroy)
			dellog += "<li>Sleeps: [I.slept_destroy]</li>"
		if (I.no_respect_force)
			dellog += "<li>Ignored force: [I.no_respect_force]</li>"
		if (I.no_hint)
			dellog += "<li>No hint: [I.no_hint]</li>"
		dellog += "</ul></li>"

	dellog += "</ol>"

	usr << browse(dellog.Join(), "window=dellog")

/client/proc/cmd_display_init_log()
	set category = "Debug.Investigate"
	set name = "Display Initialize() Log"
	set desc = "Displays a list of things that didn't handle Initialize() properly"

	if(!check_rights(R_DEBUG))	return
	src << browse(replacetext(SSatoms.InitLog(), "\n", "<br>"), "window=initlog")

/*
/client/proc/cmd_display_overlay_log()
	set category = "Debug.Investigate"
	set name = "Display overlay Log"
	set desc = "Display SSoverlays log of everything that's passed through it."

	if(!check_rights(R_DEBUG))	return
	render_stats(SSoverlays.stats, src)
*/
// Render stats list for round-end statistics.
/proc/render_stats(list/stats, user, sort = /proc/cmp_generic_stat_item_time)
	sortTim(stats, sort, TRUE)

	var/list/lines = list()
	for (var/entry in stats)
		var/list/data = stats[entry]
		lines += "[entry] => [num2text(data[STAT_ENTRY_TIME], 10)]ms ([data[STAT_ENTRY_COUNT]]) (avg:[num2text(data[STAT_ENTRY_TIME]/(data[STAT_ENTRY_COUNT] || 1), 99)])"

	if (user)
		user << browse("<ol><li>[lines.Join("</li><li>")]</li></ol>", "window=[url_encode("stats:\ref[stats]")]")
	else
		. = lines.Join("\n")

/client/proc/cmd_admin_grantfullaccess(var/mob/M in mob_list)
	set category = "Admin.Events"
	set name = "Grant Full Access"

	if (!ticker)
		tgui_alert_async(usr, "Wait until the game starts")
		return
	if (istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		if (H.wear_id)
			var/obj/item/card/id/id = H.wear_id
			if(istype(H.wear_id, /obj/item/pda))
				var/obj/item/pda/pda = H.wear_id
				id = pda.id
			id.icon_state = "gold"
			id.access = get_all_accesses().Copy()
		else
			var/obj/item/card/id/id = new/obj/item/card/id(M);
			id.icon_state = "gold"
			id.access = get_all_accesses().Copy()
			id.registered_name = H.real_name
			id.assignment = JOB_SITE_MANAGER
			id.name = "[id.registered_name]'s ID Card ([id.assignment])"
			H.equip_to_slot_or_del(id, slot_wear_id)
			H.update_inv_wear_id()
	else
		tgui_alert_async(usr, "Invalid mob")
	feedback_add_details("admin_verb","GFA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	log_admin("[key_name(src)] has granted [M.key] full access.")
	message_admins(span_blue("[key_name_admin(usr)] has granted [M.key] full access."), 1)

/client/proc/cmd_assume_direct_control(var/mob/M in mob_list)
	set category = "Admin.Game"
	set name = "Assume direct control"
	set desc = "Direct intervention"

	if(!check_rights(R_DEBUG|R_ADMIN|R_EVENT))	return
	if(M.ckey)
		if(tgui_alert(usr, "This mob is being controlled by [M.ckey]. Are you sure you wish to assume control of it? [M.ckey] will be made a ghost.","Confirmation",list("Yes","No")) != "Yes")
			return
		else
			var/mob/observer/dead/ghost = new/mob/observer/dead(M,1)
			ghost.ckey = M.ckey
	message_admins(span_blue("[key_name_admin(usr)] assumed direct control of [M]."), 1)
	log_admin("[key_name(usr)] assumed direct control of [M].")
	var/mob/adminmob = src.mob
	M.ckey = src.ckey
	if( isobserver(adminmob) )
		qdel(adminmob)
	feedback_add_details("admin_verb","ADC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/take_picture(var/atom/A in world)
	set name = "Save PNG"
	set category = "Debug.Misc"
	set desc = "Opens a dialog to save a PNG of any object in the game."

	if(!check_rights(R_DEBUG))
		return

	downloadImage(A)

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

	for(var/obj/machinery/power/apc/APC in GLOB.apcs)
		var/area/A = get_area(APC)
		if(A && !(A.type in areas_with_APC))
			areas_with_APC.Add(A.type)

	for(var/obj/machinery/alarm/alarm in machines)
		var/area/A = get_area(alarm)
		if(A && !(A.type in areas_with_air_alarm))
			areas_with_air_alarm.Add(A.type)

	for(var/obj/machinery/requests_console/RC in machines)
		var/area/A = get_area(RC)
		if(A && !(A.type in areas_with_RC))
			areas_with_RC.Add(A.type)

	for(var/obj/machinery/light/L in machines)
		var/area/A = get_area(L)
		if(A && !(A.type in areas_with_light))
			areas_with_light.Add(A.type)

	for(var/obj/machinery/light_switch/LS in machines)
		var/area/A = get_area(LS)
		if(A && !(A.type in areas_with_LS))
			areas_with_LS.Add(A.type)

	for(var/obj/item/radio/intercom/I in machines)
		var/area/A = get_area(I)
		if(A && !(A.type in areas_with_intercom))
			areas_with_intercom.Add(A.type)

	for(var/obj/machinery/camera/C in machines)
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

	to_world(span_bold("AREAS WITHOUT AN APC:"))
	for(var/areatype in areas_without_APC)
		to_world("* [areatype]")

	to_world(span_bold("AREAS WITHOUT AN AIR ALARM:"))
	for(var/areatype in areas_without_air_alarm)
		to_world("* [areatype]")

	to_world(span_bold("AREAS WITHOUT A REQUEST CONSOLE:"))
	for(var/areatype in areas_without_RC)
		to_world("* [areatype]")

	to_world(span_bold("AREAS WITHOUT ANY LIGHTS:"))
	for(var/areatype in areas_without_light)
		to_world("* [areatype]")

	to_world(span_bold("AREAS WITHOUT A LIGHT SWITCH:"))
	for(var/areatype in areas_without_LS)
		to_world("* [areatype]")

	to_world(span_bold("AREAS WITHOUT ANY INTERCOMS:"))
	for(var/areatype in areas_without_intercom)
		to_world("* [areatype]")

	to_world(span_bold("AREAS WITHOUT ANY CAMERAS:"))
	for(var/areatype in areas_without_camera)
		to_world("* [areatype]")

/datum/admins/proc/cmd_admin_dress(input in getmobs())
	set category = "Fun.Event Kit"
	set name = "Select equipment"

	if(!check_rights(R_FUN))
		return

	var/target = getmobs()[input]
	if(!target)
		return

	if(!ishuman(target))
		return

	var/mob/living/carbon/human/H = target

	var/decl/hierarchy/outfit/outfit = tgui_input_list(usr, "Select outfit.", "Select equipment.", outfits())
	if(!outfit)
		return

	feedback_add_details("admin_verb","SEQ")
	dressup_human(H, outfit, 1)

/proc/dressup_human(var/mob/living/carbon/human/H, var/decl/hierarchy/outfit/outfit)
	if(!H || !outfit)
		return
	if(outfit.undress)
		H.delete_inventory()
	outfit.equip(H)
	log_and_message_admins("changed the equipment of [key_name(H)] to [outfit.name].")

/client/proc/startSinglo()

	set category = "Debug.Game"
	set name = "Start Singularity"
	set desc = "Sets up the singularity and all machines to get power flowing through the station"

	if(tgui_alert(usr, "Are you sure? This will start up the engine. Should only be used during debug!","Start Singularity",list("Yes","No")) != "Yes")
		return

	for(var/obj/machinery/power/emitter/E in machines)
		if(istype(get_area(E), /area/space))
			E.anchored = TRUE
			E.state = 2
			E.connect_to_network()
			E.active = TRUE
	for(var/obj/machinery/field_generator/F in machines)
		if(istype(get_area(F), /area/space))
			F.Varedit_start = 1
	for(var/obj/machinery/power/grounding_rod/GR in machines)
		GR.anchored = TRUE
		GR.update_icon()
	for(var/obj/machinery/power/tesla_coil/TC in machines)
		TC.anchored = TRUE
		TC.update_icon()
	for(var/obj/structure/particle_accelerator/PA in machines)
		PA.anchored = TRUE
		PA.construction_state = 3
		PA.update_icon()
	for(var/obj/machinery/particle_accelerator/PA in machines)
		PA.anchored = TRUE
		PA.construction_state = 3
		PA.update_icon()

	for(var/obj/machinery/power/rad_collector/Rad in machines)
		if(Rad.anchored)
			if(!Rad.P)
				var/obj/item/tank/phoron/Phoron = new/obj/item/tank/phoron(Rad)
				Phoron.air_contents.gas[GAS_PHORON] = 70
				Rad.drainratio = 0
				Rad.P = Phoron
				Phoron.loc = Rad

			if(!Rad.active)
				Rad.toggle_power()

/client/proc/setup_supermatter_engine()
	set category = "Debug.Game"
	set name = "Setup supermatter"
	set desc = "Sets up the supermatter engine"

	if(!check_rights(R_DEBUG|R_ADMIN))      return

	var/response = tgui_alert(usr, "Are you sure? This will start up the engine. Should only be used during debug!","Setup Supermatter",list("Setup Completely","Setup except coolant","No"))

	if(!response || response == "No")
		return

	var/found_the_pump = 0
	var/obj/machinery/power/supermatter/SM

	for(var/obj/machinery/M in machines)
		if(!M)
			continue
		if(!M.loc)
			continue
		if(!M.loc.loc)
			continue

		if(istype(M.loc.loc,/area/engineering/engine_room))
			if(istype(M,/obj/machinery/power/rad_collector))
				var/obj/machinery/power/rad_collector/Rad = M
				Rad.anchored = TRUE
				Rad.connect_to_network()

				var/obj/item/tank/phoron/Phoron = new/obj/item/tank/phoron(Rad)

				Phoron.air_contents.gas[GAS_PHORON] = 29.1154	//This is a full tank if you filled it from a canister
				Rad.P = Phoron

				Phoron.loc = Rad

				if(!Rad.active)
					Rad.toggle_power()
				Rad.update_icon()

			else if(istype(M,/obj/machinery/atmospherics/binary/pump))	//Turning on every pump.
				var/obj/machinery/atmospherics/binary/pump/Pump = M
				if(Pump.name == "Engine Feed" && response == "Setup Completely")
					found_the_pump = 1
					Pump.air2.gas[GAS_N2] = 3750	//The contents of 2 canisters.
					Pump.air2.temperature = 50
					Pump.air2.update_values()
				Pump.update_use_power(USE_POWER_IDLE)
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
		to_chat(src, span_red("Unable to locate air supply to fill up with coolant, adding some coolant around the supermatter"))
		var/turf/simulated/T = SM.loc
		T.zone.air.gas[GAS_N2] += 450
		T.zone.air.temperature = 50
		T.zone.air.update_values()


	log_admin("[key_name(usr)] setup the supermatter engine [response == "Setup except coolant" ? "without coolant" : ""]")
	message_admins(span_blue("[key_name_admin(usr)] setup the supermatter engine  [response == "Setup except coolant" ? "without coolant": ""]"), 1)
	return



/client/proc/cmd_debug_mob_lists()
	set category = "Debug.Investigate"
	set name = "Debug Mob Lists"
	set desc = "For when you just gotta know"

	switch(tgui_input_list(usr, "Which list?", "List Choice", list("Players","Admins","Mobs","Living Mobs","Dead Mobs", "Clients")))
		if("Players")
			to_chat(usr, span_filter_debuglogs(jointext(player_list,",")))
		if("Admins")
			to_chat(usr, span_filter_debuglogs(jointext(GLOB.admins,",")))
		if("Mobs")
			to_chat(usr, span_filter_debuglogs(jointext(mob_list,",")))
		if("Living Mobs")
			to_chat(usr, span_filter_debuglogs(jointext(living_mob_list,",")))
		if("Dead Mobs")
			to_chat(usr, span_filter_debuglogs(jointext(dead_mob_list,",")))
		if("Clients")
			to_chat(usr, span_filter_debuglogs(jointext(GLOB.clients,",")))

/client/proc/cmd_debug_using_map()
	set category = "Debug.Investigate"
	set name = "Debug Map Datum"
	set desc = "Debug the map metadata about the currently compiled in map."

	if(!check_rights(R_DEBUG))
		return
	debug_variables(using_map)

// DNA2 - Admin Hax
/client/proc/cmd_admin_toggle_block(var/mob/M,var/block)
	if(!ticker)
		tgui_alert_async(usr, "Wait until the game starts")
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
		tgui_alert_async(usr, "Invalid mob")

/datum/admins/proc/view_runtimes()
	set category = "Debug.Investigate"
	set name = "View Runtimes"
	set desc = "Open the Runtime Viewer"

	if(!check_rights(R_DEBUG))
		return

	error_cache.showTo(usr)

/datum/admins/proc/change_weather()
	set category = "Debug.Events"
	set name = "Change Weather"
	set desc = "Changes the current weather."

	if(!check_rights(R_DEBUG))
		return

	var/datum/planet/planet = tgui_input_list(usr, "Which planet do you want to modify the weather on?", "Change Weather", SSplanets.planets)
	if(istype(planet))
		var/datum/weather/new_weather = tgui_input_list(usr, "What weather do you want to change to?", "Change Weather", planet.weather_holder.allowed_weather_types)
		if(new_weather)
			planet.weather_holder.change_weather(new_weather)
			planet.weather_holder.rebuild_forecast()
			var/log = "[key_name(src)] changed [planet.name]'s weather to [new_weather]."
			message_admins(log)
			log_admin(log)

/datum/admins/proc/toggle_firework_override()
	set category = "Fun.Event Kit"
	set name = "Toggle Weather Firework Override"
	set desc = "Toggles ability for weather fireworks to affect weather on planet of choice."

	if(!check_rights(R_DEBUG))
		return

	var/datum/planet/planet = tgui_input_list(usr, "Which planet do you want to toggle firework effects on?", "Change Weather", SSplanets.planets)
	if(istype(planet) && planet.weather_holder)
		planet.weather_holder.firework_override = !(planet.weather_holder.firework_override)
		var/log = "[key_name(src)] toggled [planet.name]'s firework override to [planet.weather_holder.firework_override ? "on" : "off"]."
		message_admins(log)
		log_admin(log)

/datum/admins/proc/change_time()
	set category = "Debug.Events"
	set name = "Change Planet Time"
	set desc = "Changes the time of a planet."

	if(!check_rights(R_DEBUG))
		return

	var/datum/planet/planet = tgui_input_list(usr, "Which planet do you want to modify time on?", "Change Time", SSplanets.planets)
	if(istype(planet))
		var/datum/time/current_time_datum = planet.current_time
		var/planet_hours = max(round(current_time_datum.seconds_in_day / 36000) - 1, 0)
		var/new_hour = tgui_input_number(usr, "What hour do you want to change to?", "Change Time", text2num(current_time_datum.show_time("hh")), planet_hours)
		if(!isnull(new_hour))
			var/planet_minutes = max(round(current_time_datum.seconds_in_hour / 600) - 1, 0)
			var/new_minute = tgui_input_number(usr, "What minute do you want to change to?", "Change Time", text2num(current_time_datum.show_time("mm")), planet_minutes)
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

/client/proc/cmd_regenerate_asset_cache()
	set category = "Debug.Assets"
	set name = "Regenerate Asset Cache"
	set desc = "Clears the asset cache and regenerates it immediately."
	if(!CONFIG_GET(flag/cache_assets))
		to_chat(usr, span_warning("Asset caching is disabled in the config!"))
		return
	var/regenerated = 0
	for(var/datum/asset/A as() in subtypesof(/datum/asset))
		if(!initial(A.cross_round_cachable))
			continue
		if(A == initial(A._abstract))
			continue
		var/datum/asset/asset_datum = GLOB.asset_datums[A]
		asset_datum.regenerate()
		regenerated++
	to_chat(usr, span_notice("Regenerated [regenerated] asset\s."))

/client/proc/cmd_clear_smart_asset_cache()
	set category = "Debug.Assets"
	set name = "Clear Smart Asset Cache"
	set desc = "Clears the smart asset cache."
	if(!CONFIG_GET(flag/smart_cache_assets))
		to_chat(usr, span_warning("Smart asset caching is disabled in the config!"))
		return
	var/cleared = 0
	for(var/datum/asset/spritesheet_batched/A as() in subtypesof(/datum/asset/spritesheet_batched))
		if(A == initial(A._abstract))
			continue
		fdel("[ASSET_CROSS_ROUND_SMART_CACHE_DIRECTORY]/spritesheet_cache.[initial(A.name)].json")
		cleared++
	to_chat(usr, span_notice("Cleared [cleared] asset\s."))
