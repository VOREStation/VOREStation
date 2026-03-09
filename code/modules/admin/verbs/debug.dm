
ADMIN_VERB(Debug2, R_DEBUG, "Debug-Game", "Toggles debug level 2, might be quite spammy.", ADMIN_CATEGORY_DEBUG_INVESTIGATE)
	if(GLOB.Debug2)
		GLOB.Debug2 = FALSE
		message_admins("[key_name(user)] toggled debugging off.")
		log_admin("[key_name(user)] toggled debugging off.")
	else
		GLOB.Debug2 = TRUE
		message_admins("[key_name(user)] toggled debugging on.")
		log_admin("[key_name(user)] toggled debugging on.")

	feedback_add_details("admin_verb","DG2") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

// callproc moved to code/modules/admin/callproc

ADMIN_VERB(simple_DPS, R_DEBUG, "Simple DPS", "Gives a really basic idea of how much hurt something in-hand does.", ADMIN_CATEGORY_DEBUG_INVESTIGATE)
	var/obj/item/I = null
	var/mob/living/user_mob = user.mob
	if(!istype(user_mob))
		to_chat(user, span_warning("You need to be a living mob, with hands, and for an object to be in your active hand, to use this verb."))
		return

	I = user_mob.get_active_hand()
	if(!I || !istype(I))
		to_chat(user, span_warning("You need to have something in your active hand, to use this verb."))
		return
	var/weapon_attack_speed = user_mob.get_attack_speed(I) / 10
	var/weapon_damage = I.force
	var/modified_damage_percent = 1

	for(var/datum/modifier/M in user_mob.modifiers)
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
		to_chat(user, span_notice("At your maximum health ([user_mob.getMaxHealth()]), it would take approximately;"))
		to_chat(user, span_notice("[(user_mob.getMaxHealth() - CONFIG_GET(number/health_threshold_softcrit)) / DPS] seconds to softcrit you. ([CONFIG_GET(number/health_threshold_softcrit)] health)"))
		to_chat(user, span_notice("[(user_mob.getMaxHealth() - user_mob.get_crit_point()) / DPS] seconds to hardcrit you. ([user_mob.get_crit_point()] health)"))
		to_chat(user, span_notice("[(user_mob.getMaxHealth() - (-user_mob.getMaxHealth())) / DPS] seconds to kill you. ([(-user_mob.getMaxHealth())] health)"))


ADMIN_VERB(Cell, R_DEBUG, "Cell", "Display the atmos information of the current cell.", ADMIN_CATEGORY_DEBUG_INVESTIGATE)
	var/turf/T = get_turf(user.mob)

	if (!(isturf(T)))
		return

	var/datum/gas_mixture/env = T.return_air()

	var/t = span_blue("Coordinates: [T.x],[T.y],[T.z]\n")
	t += span_red("Temperature: [env.temperature]\n")
	t += span_red("Pressure: [env.return_pressure()]kPa\n")
	for(var/g in env.gas)
		t += span_blue("[g]: [env.gas[g]] / [env.gas[g] * R_IDEAL_GAS_EQUATION * env.temperature / env.volume]kPa\n")

	user.mob.show_message(t, 1)
	feedback_add_details("admin_verb","ASL") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

ADMIN_VERB_AND_CONTEXT_MENU(cmd_admin_robotize, R_ADMIN|R_EVENT|R_DEBUG, "Make Robot", "Turns the target into a robot.", ADMIN_CATEGORY_FUN_EVENT_KIT, mob/living/carbon/human/target_human in GLOB.human_mob_list)
	if(!SSticker)
		tgui_alert_async(user, "Wait until the game starts")
		return
	if(!ishuman(target_human))
		tgui_alert_async(user, "Invalid mob")
		return

	log_admin("[key_name(user)] has robotized [target_human.key].")
	addtimer(CALLBACK(target_human, TYPE_PROC_REF(/mob/living/carbon/human, Robotize)), 1 SECOND, TIMER_DELETE_ME)

ADMIN_VERB_AND_CONTEXT_MENU(cmd_admin_animalize, R_ADMIN|R_EVENT|R_DEBUG, "Make Simple Animal", "Spawns a new player directly as animal.", ADMIN_CATEGORY_FUN_EVENT_KIT, mob/target_mob in GLOB.mob_list)
	if(!SSticker)
		tgui_alert_async(user, "Wait until the game starts")
		return

	if(!target_mob)
		tgui_alert_async(user, "That mob doesn't seem to exist, close the panel and try again.")
		return

	if(isnewplayer(target_mob))
		tgui_alert_async(user, "The mob must not be a new_player.")
		return

	log_admin("[key_name(user)] has animalized [target_mob.key].")
	addtimer(CALLBACK(target_mob, TYPE_PROC_REF(/mob, Animalize)), 1 SECOND, TIMER_DELETE_ME)

ADMIN_VERB(makepAI, R_ADMIN|R_EVENT|R_DEBUG, "Make pAI", "Spawn someone in as a pAI!", ADMIN_CATEGORY_FUN_EVENT_KIT)
	var/turf/target_turf = get_turf(user.mob)

	var/list/available = list()
	for(var/mob/current_client in GLOB.mob_list)
		if(current_client.key && isobserver(current_client))
			available += current_client
	var/mob/choice = tgui_input_list(user, "Choose a player to play the pAI", "Spawn pAI", available)
	if(!choice)
		return

	var/obj/item/paicard/typeb/card = new(target_turf)
	var/mob/living/silicon/pai/pai = new(card)
	pai.real_name = pai.name
	pai.key = choice.key
	card.setPersonality(pai)
	if(tgui_alert(pai, "Do you want to load your pAI data?", "Load", list("Yes", "No")) == "Yes")
		pai.apply_preferences(pai.client)
	else
		var/new_name = sanitizeName(tgui_input_text(pai, "Enter your pAI name:", "pAI Name", "Personal AI", encode = FALSE), allow_numbers = TRUE)
		if(new_name)
			pai.name = new_name
	log_admin("made a pAI with key=[pai.key] at ([target_turf.x],[target_turf.y],[target_turf.z])")
	feedback_add_details("admin_verb","MPAI") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

ADMIN_VERB_AND_CONTEXT_MENU(cmd_admin_alienize, R_ADMIN|R_EVENT|R_DEBUG, "Make Alien", "Turns the target into an alien.", ADMIN_CATEGORY_FUN_EVENT_KIT, mob/living/carbon/human/target_human in GLOB.human_mob_list)
	if(!SSticker)
		tgui_alert_async(user, "Wait until the game starts")
		return
	if(!ishuman(target_human))
		tgui_alert_async(user, "Invalid mob")
		return

	log_admin("[key_name(user)] has alienized [target_human.key].")
	addtimer(CALLBACK(target_human, TYPE_PROC_REF(/mob/living/carbon/human, Alienize)), 1 SECOND, TIMER_DELETE_ME)
	feedback_add_details("admin_verb","MKAL") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	log_admin("[key_name(user)] made [key_name(target_human)] into an alien.")
	message_admins(span_notice("[key_name_admin(user)] made [key_name(target_human)] into an alien."))

//TODO: merge the vievars version into this or something maybe mayhaps
ADMIN_VERB(cmd_debug_del_all, R_SERVER, "Del-All", "DANGER: Deletes all instances of a type.", ADMIN_CATEGORY_DEBUG_DANGEROUS)
	// to prevent REALLY stupid deletions
	var/blocked = list(/obj, /mob, /mob/living, /mob/living/carbon, /mob/living/carbon/human, /mob/observer/dead, /mob/living/silicon, /mob/living/silicon/robot, /mob/living/silicon/ai)
	var/hsbitem = tgui_input_list(user, "Choose an object to delete.", "Delete:", typesof(/obj) + typesof(/mob) - blocked)
	if(hsbitem)
		for(var/atom/O in world)
			if(istype(O, hsbitem))
				qdel(O)
		log_admin("[key_name(user)] has deleted all instances of [hsbitem].")
		message_admins("[key_name_admin(user)] has deleted all instances of [hsbitem].", 0)
	feedback_add_details("admin_verb","DELA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

ADMIN_VERB(cmd_debug_make_powernets, R_DEBUG, "Make Powernets", "Rebuild all powernets.", ADMIN_CATEGORY_DEBUG_DANGEROUS)
	SSmachines.makepowernets()
	log_admin("[key_name(user)] has remade the powernet. SSmachines.makepowernets() called.")
	message_admins("[key_name_admin(user)] has remade the powernets. SSmachines.makepowernets() called.")
	feedback_add_details("admin_verb","MPWN") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

ADMIN_VERB(cmd_debug_tog_aliens, R_DEBUG, "Toggle Aliens", "Toggle if aliens are allowed.", ADMIN_CATEGORY_SERVER_GAME)
	CONFIG_SET(flag/aliens_allowed, !CONFIG_GET(flag/aliens_allowed))
	log_admin("[key_name(user)] has turned aliens [CONFIG_GET(flag/aliens_allowed) ? "on" : "off"].")
	message_admins("[key_name_admin(user)] has turned aliens [CONFIG_GET(flag/aliens_allowed) ? "on" : "off"].")
	feedback_add_details("admin_verb","TAL") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

ADMIN_VERB(cmd_display_del_log, R_DEBUG, "Display del() Log", "Display del's log of everything that's passed through it.", ADMIN_CATEGORY_DEBUG_INVESTIGATE)
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

	user << browse("<html>[dellog.Join()]</html>", "window=dellog")

ADMIN_VERB(cmd_display_init_log, R_DEBUG, "Display Initialize() Log", "Displays a list of things that didn't handle Initialize() properly.", ADMIN_CATEGORY_DEBUG_INVESTIGATE)
	user << browse("<html>[replacetext(SSatoms.InitLog(), "\n", "<br>")]</html>", "window=initlog")

ADMIN_VERB(cmd_display_overlay_log, R_DEBUG, "Display overlay Log", "Display SSoverlays log of everything that's passed through it.", ADMIN_CATEGORY_DEBUG_INVESTIGATE)
	render_stats(SSoverlays.stats, user)

// Render stats list for round-end statistics.
/proc/render_stats(list/stats, user, sort = /proc/cmp_generic_stat_item_time)
	sortTim(stats, sort, TRUE)

	var/list/lines = list()
	for (var/entry in stats)
		var/list/data = stats[entry]
		lines += "[entry] => [num2text(data[STAT_ENTRY_TIME], 10)]ms ([data[STAT_ENTRY_COUNT]]) (avg:[num2text(data[STAT_ENTRY_TIME]/(data[STAT_ENTRY_COUNT] || 1), 99)])"

	if (user)
		user << browse("<html><ol><li>[lines.Join("</li><li>")]</li></ol></html>", "window=[url_encode("stats:\ref[stats]")]")
	else
		. = lines.Join("\n")

ADMIN_VERB(cmd_admin_grantfullaccess, (R_ADMIN|R_EVENT), "Assume Direct Control", "Assume direct control of a mob.", ADMIN_CATEGORY_EVENTS, mob/living/carbon/human/H in GLOB.human_mob_list)
	if (!SSticker)
		tgui_alert_async(user, "Wait until the game starts")
		return
	if (H.wear_id)
		var/obj/item/card/id/id = H.wear_id
		if(istype(H.wear_id, /obj/item/pda))
			var/obj/item/pda/pda = H.wear_id
			id = pda.id
		id.icon_state = "gold"
		id.access = get_all_accesses().Copy()
	else
		var/obj/item/card/id/id = new/obj/item/card/id(H);
		id.icon_state = "gold"
		id.access = get_all_accesses().Copy()
		id.registered_name = H.real_name
		id.assignment = JOB_SITE_MANAGER
		id.name = "[id.registered_name]'s ID Card ([id.assignment])"
		H.equip_to_slot_or_del(id, slot_wear_id)
		H.update_inv_wear_id()
	feedback_add_details("admin_verb","GFA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	log_admin("[key_name(user)] has granted [H.key] full access.")
	message_admins(span_blue("[key_name_admin(user)] has granted [H.key] full access."))

ADMIN_VERB(cmd_assume_direct_control, (R_DEBUG|R_ADMIN|R_EVENT), "Assume Direct Control", "Assume direct control of a mob.", ADMIN_CATEGORY_GAME, mob/M)
	if(M.ckey)
		if(tgui_alert(user, "This mob is being controlled by [M.ckey]. Are you sure you wish to assume control of it? [M.ckey] will be made a ghost.","Confirmation",list("Yes","No")) != "Yes")
			return
	if(!M || QDELETED(M))
		to_chat(user, span_warning("The target mob no longer exists."))
		return

	var/mob/observer/dead/ghost = new/mob/observer/dead(M,1)
	ghost.ckey = M.ckey

	message_admins(span_blue("[key_name_admin(user)] assumed direct control of [M]."))
	log_admin("[key_name(user)] assumed direct control of [M].")
	var/mob/adminmob = user.mob
	M.ckey = user.ckey
	if( isobserver(adminmob) )
		qdel(adminmob)
	feedback_add_details("admin_verb","ADC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

ADMIN_VERB(take_picture, R_DEBUG, "Save PNG", "Opens a dialog to save a PNG of any object in the game.", ADMIN_CATEGORY_DEBUG_MISC, atom/selected_atom in world)
	downloadImage(selected_atom)

ADMIN_VERB_VISIBILITY(cmd_admin_areatest, ADMIN_VERB_VISIBLITY_FLAG_LOCALHOST)
ADMIN_VERB(cmd_admin_areatest, R_DEBUG, "Test areas", "Manually tests all areas and prints to world (Only use on a test server).", ADMIN_CATEGORY_MAPPING_TESTS)
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

	for(var/obj/machinery/alarm/alarm in GLOB.machines)
		var/area/A = get_area(alarm)
		if(A && !(A.type in areas_with_air_alarm))
			areas_with_air_alarm.Add(A.type)

	for(var/obj/machinery/requests_console/RC in GLOB.machines)
		var/area/A = get_area(RC)
		if(A && !(A.type in areas_with_RC))
			areas_with_RC.Add(A.type)

	for(var/obj/machinery/light/L in GLOB.machines)
		var/area/A = get_area(L)
		if(A && !(A.type in areas_with_light))
			areas_with_light.Add(A.type)

	for(var/obj/machinery/light_switch/LS in GLOB.machines)
		var/area/A = get_area(LS)
		if(A && !(A.type in areas_with_LS))
			areas_with_LS.Add(A.type)

	for(var/obj/item/radio/intercom/I in GLOB.machines)
		var/area/A = get_area(I)
		if(A && !(A.type in areas_with_intercom))
			areas_with_intercom.Add(A.type)

	for(var/obj/machinery/camera/C in GLOB.machines)
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

	to_chat(world, span_bold("AREAS WITHOUT AN APC:"))
	for(var/areatype in areas_without_APC)
		to_chat(world, "* [areatype]")

	to_chat(world, span_bold("AREAS WITHOUT AN AIR ALARM:"))
	for(var/areatype in areas_without_air_alarm)
		to_chat(world, "* [areatype]")

	to_chat(world, span_bold("AREAS WITHOUT A REQUEST CONSOLE:"))
	for(var/areatype in areas_without_RC)
		to_chat(world, "* [areatype]")

	to_chat(world, span_bold("AREAS WITHOUT ANY LIGHTS:"))
	for(var/areatype in areas_without_light)
		to_chat(world, "* [areatype]")

	to_chat(world, span_bold("AREAS WITHOUT A LIGHT SWITCH:"))
	for(var/areatype in areas_without_LS)
		to_chat(world, "* [areatype]")

	to_chat(world, span_bold("AREAS WITHOUT ANY INTERCOMS:"))
	for(var/areatype in areas_without_intercom)
		to_chat(world, "* [areatype]")

	to_chat(world, span_bold("AREAS WITHOUT ANY CAMERAS:"))
	for(var/areatype in areas_without_camera)
		to_chat(world, "* [areatype]")

ADMIN_VERB(cmd_admin_dress, R_FUN, "elect equipment", "Select equipment for a mob.", ADMIN_CATEGORY_FUN_EVENT_KIT, input)
	if(!input)
		input = tgui_input_list(user, "Pick Target", "Select the target to dress.", getmobs())
		if(!input)
			return

	var/target = getmobs()[input]

	if(!ishuman(target))
		return

	var/mob/living/carbon/human/target_human = target

	var/datum/decl/hierarchy/outfit/outfit = tgui_input_list(user, "Select outfit.", "Select equipment.", outfits())
	if(!outfit)
		return

	feedback_add_details("admin_verb","SEQ")
	dressup_human(target_human, outfit, 1)

/proc/dressup_human(var/mob/living/carbon/human/H, var/datum/decl/hierarchy/outfit/outfit)
	if(!H || !outfit)
		return
	if(outfit.undress)
		H.delete_inventory()
	outfit.equip(H)
	log_and_message_admins("changed the equipment of [key_name(H)] to [outfit.name].")

ADMIN_VERB(startSinglo, R_DEBUG|R_ADMIN, "Start Singularity", "Sets up the singularity and all machines to get power flowing through the station.", ADMIN_CATEGORY_DEBUG_GAME)
	if(tgui_alert(user, "Are you sure? This will start up the engine. Should only be used during debug!","Start Singularity",list("Yes","No")) != "Yes")
		return

	for(var/obj/machinery/power/emitter/E in GLOB.machines)
		if(istype(get_area(E), /area/space))
			E.anchored = TRUE
			E.state = 2
			E.connect_to_network()
			E.active = TRUE
	for(var/obj/machinery/field_generator/F in GLOB.machines)
		if(istype(get_area(F), /area/space))
			F.Varedit_start = 1
	for(var/obj/machinery/power/grounding_rod/GR in GLOB.machines)
		GR.anchored = TRUE
		GR.update_icon()
	for(var/obj/machinery/power/tesla_coil/TC in GLOB.machines)
		TC.anchored = TRUE
		TC.update_icon()
	for(var/obj/structure/particle_accelerator/PA in GLOB.machines)
		PA.anchored = TRUE
		PA.construction_state = 3
		PA.update_icon()
	for(var/obj/machinery/particle_accelerator/PA in GLOB.machines)
		PA.anchored = TRUE
		PA.construction_state = 3
		PA.update_icon()

	for(var/obj/machinery/power/rad_collector/Rad in GLOB.machines)
		if(Rad.anchored)
			if(!Rad.P)
				var/obj/item/tank/phoron/Phoron = new/obj/item/tank/phoron(Rad)
				Phoron.air_contents.gas[GAS_PHORON] = 70
				Rad.drainratio = 0
				Rad.P = Phoron
				Phoron.loc = Rad

			if(!Rad.active)
				Rad.toggle_power()

	log_admin("[key_name(user)] setup the singulo engine")
	message_admins(span_blue("[key_name_admin(user)] setup the singulo engine"))

ADMIN_VERB(setup_supermatter_engine, R_DEBUG|R_ADMIN, "Setup supermatter", "Sets up the supermatter engine.", ADMIN_CATEGORY_DEBUG_GAME)
	var/response = tgui_alert(user, "Are you sure? This will start up the engine. Should only be used during debug!","Setup Supermatter",list("Setup Completely","Setup except coolant","No"))

	if(!response || response == "No")
		return

	var/found_the_pump = 0
	var/obj/machinery/power/supermatter/SM

	for(var/obj/machinery/M in GLOB.machines)
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


	log_admin("[key_name(user)] setup the supermatter engine [response == "Setup except coolant" ? "without coolant" : ""]")
	message_admins(span_blue("[key_name_admin(user)] setup the supermatter engine  [response == "Setup except coolant" ? "without coolant": ""]"))


ADMIN_VERB(cmd_debug_mob_lists, R_DEBUG, "Debug Mob Lists", "For when you just gotta know.", ADMIN_CATEGORY_DEBUG_INVESTIGATE)
	switch(tgui_input_list(user, "Which list?", "List Choice", list("Players","Admins","Mobs","Living Mobs","Dead Mobs", "Clients")))
		if("Players")
			to_chat(user, span_filter_debuglogs(jointext(GLOB.player_list,",")))
		if("Admins")
			to_chat(user, span_filter_debuglogs(jointext(GLOB.admins,",")))
		if("Mobs")
			to_chat(user, span_filter_debuglogs(jointext(GLOB.mob_list,",")))
		if("Living Mobs")
			to_chat(user, span_filter_debuglogs(jointext(GLOB.living_mob_list,",")))
		if("Dead Mobs")
			to_chat(user, span_filter_debuglogs(jointext(GLOB.dead_mob_list,",")))
		if("Clients")
			to_chat(user, span_filter_debuglogs(jointext(GLOB.clients,",")))

ADMIN_VERB(cmd_debug_using_map, R_DEBUG, "Debug Map Datum", "Debug the map metadata about the currently compiled in map.", ADMIN_CATEGORY_DEBUG_INVESTIGATE)
	user.debug_variables(using_map)

// DNA2 - Admin Hax
/client/proc/cmd_admin_toggle_block(var/mob/M,var/block)
	if(!SSticker)
		tgui_alert_async(src, "Wait until the game starts")
		return
	if(istype(M, /mob/living/carbon))
		M.dna.SetSEState(block,!M.dna.GetSEState(block))
		domutcheck(M,null,MUTCHK_FORCED)
		M.UpdateAppearance()
		var/state="[M.dna.GetSEState(block)?"on":"off"]"
		var/blockname=assigned_blocks[block]
		message_admins("[key_name_admin(src)] has toggled [M.key]'s [blockname] block [state]!")
		log_admin("[key_name(src)] has toggled [M.key]'s [blockname] block [state]!")
	else
		tgui_alert_async(src, "Invalid mob")

ADMIN_VERB(view_runtimes, R_DEBUG, "View Runtimes", "Opens the runtime viewer.", ADMIN_CATEGORY_DEBUG_INVESTIGATE)
	GLOB.error_cache.show_to(user)

	// The runtime viewer has the potential to crash the server if there's a LOT of runtimes
	// this has happened before, multiple times, so we'll just leave an alert on it
	if(GLOB.total_runtimes >= 50000) // arbitrary number, I don't know when exactly it happens
		var/warning = "There are a lot of runtimes, clicking any button (especially \"linear\") can have the potential to lag or crash the server"
		if(GLOB.total_runtimes >= 100000)
			warning = "There are a TON of runtimes, clicking any button (especially \"linear\") WILL LIKELY crash the server"
		// Not using TGUI alert, because it's view runtimes, stuff is probably broken
		tgui_alert(user, "[warning]. Proceed with caution. If you really need to see the runtimes, download the runtime log and view it in a text editor.", "HEED THIS WARNING CAREFULLY MORTAL")

ADMIN_VERB(change_weather, R_DEBUG|R_EVENT, "Change Weather", "Changes the current weather.", ADMIN_CATEGORY_DEBUG_EVENTS)
	var/datum/planet/planet = tgui_input_list(user, "Which planet do you want to modify the weather on?", "Change Weather", SSplanets.planets)
	if(!istype(planet))
		return
	var/datum/weather/new_weather = tgui_input_list(user, "What weather do you want to change to?", "Change Weather", planet.weather_holder.allowed_weather_types)
	if(!new_weather)
		return
	planet.weather_holder.change_weather(new_weather)
	planet.weather_holder.rebuild_forecast()
	var/log = "[key_name(user)] changed [planet.name]'s weather to [new_weather]."
	message_admins(log)
	log_admin(log)

ADMIN_VERB(toggle_firework_override, R_DEBUG|R_EVENT, "Toggle Weather Firework Override", "Toggles ability for weather fireworks to affect weather on planet of choice.", ADMIN_CATEGORY_DEBUG_EVENTS)
	var/datum/planet/planet = tgui_input_list(user, "Which planet do you want to toggle firework effects on?", "Change Weather", SSplanets.planets)
	if(istype(planet) && planet.weather_holder)
		planet.weather_holder.firework_override = !(planet.weather_holder.firework_override)
		var/log = "[key_name(user)] toggled [planet.name]'s firework override to [planet.weather_holder.firework_override ? "on" : "off"]."
		message_admins(log)
		log_admin(log)

ADMIN_VERB(change_time, R_DEBUG|R_EVENT, "Change Planet Time", "Changes the time of a planet.", ADMIN_CATEGORY_DEBUG_EVENTS)
	var/datum/planet/planet = tgui_input_list(user, "Which planet do you want to modify time on?", "Change Time", SSplanets.planets)
	if(!istype(planet))
		return
	var/datum/time/current_time_datum = planet.current_time
	var/planet_hours = max(round(current_time_datum.seconds_in_day / 36000) - 1, 0)
	var/new_hour = tgui_input_number(user, "What hour do you want to change to?", "Change Time", text2num(current_time_datum.show_time("hh")), planet_hours)
	if(isnull(new_hour))
		return
	var/planet_minutes = max(round(current_time_datum.seconds_in_hour / 600) - 1, 0)
	var/new_minute = tgui_input_number(user, "What minute do you want to change to?", "Change Time", text2num(current_time_datum.show_time("mm")), planet_minutes)
	if(isnull(new_minute))
		return
	var/type_needed = current_time_datum.type
	var/datum/time/new_time = new type_needed()
	new_time = new_time.add_hours(new_hour)
	new_time = new_time.add_minutes(new_minute)
	planet.current_time = new_time
	spawn(1)
		planet.update_sun()

	var/log = "[key_name(user)] changed [planet.name]'s time to [planet.current_time.show_time("hh:mm")]."
	message_admins(log)
	log_admin(log)

ADMIN_VERB(cmd_regenerate_asset_cache, R_DEBUG|R_SERVER, "Regenerate Asset Cache", "Clears the asset cache and regenerates it immediately.", ADMIN_CATEGORY_DEBUG_ASSETS)
	if(!CONFIG_GET(flag/cache_assets))
		to_chat(user, span_warning("Asset caching is disabled in the config!"))
		return
	var/regenerated = 0
	for(var/datum/asset/current_asset as anything in subtypesof(/datum/asset))
		if(!initial(current_asset.cross_round_cachable))
			continue
		if(current_asset == initial(current_asset._abstract))
			continue
		var/datum/asset/asset_datum = GLOB.asset_datums[current_asset]
		asset_datum.regenerate()
		regenerated++
	to_chat(user, span_notice("Regenerated [regenerated] asset\s."))

ADMIN_VERB(cmd_clear_smart_asset_cache, R_DEBUG|R_SERVER, "Clear Smart Asset Cache", "Clears the smart asset cache.", ADMIN_CATEGORY_DEBUG_ASSETS)
	if(!CONFIG_GET(flag/smart_cache_assets))
		to_chat(user, span_warning("Smart asset caching is disabled in the config!"))
		return
	var/cleared = 0
	for(var/datum/asset/spritesheet_batched/current_asset as anything in subtypesof(/datum/asset/spritesheet_batched))
		if(current_asset == initial(current_asset._abstract))
			continue
		fdel("[ASSET_CROSS_ROUND_SMART_CACHE_DIRECTORY]/spritesheet_cache.[initial(current_asset.name)].json")
		cleared++
	to_chat(user, span_notice("Cleared [cleared] asset\s."))

// For spriters with long world loads, allows to reload test robot sprites
ADMIN_VERB(cmd_reload_robot_sprite_test, R_DEBUG|R_SERVER, "Reload Robot Test Sprites", "Reloads the dmis from the test folder and creates the test datums.", ADMIN_CATEGORY_DEBUG_SPRITES)
	SSrobot_sprites.reload_test_sprites()

ADMIN_VERB(quick_nif, R_ADMIN, "Quick NIF", "Spawns a NIF into someone in quick-implant mode.", ADMIN_CATEGORY_FUN_ADD_NIF)
	var/input_NIF
	var/mob/living/carbon/human/H = tgui_input_list(user, "Pick a mob with a player","Quick NIF", GLOB.player_list)

	if(!H)
		return

	if(!istype(H))
		to_chat(user, span_warning("That mob type ([H.type]) doesn't support NIFs, sorry."))
		return

	if(!H.get_organ(BP_HEAD))
		to_chat(user, span_warning("Target is unsuitable."))
		return

	if(H.nif)
		to_chat(user, span_warning("Target already has a NIF."))
		return

	if(H.species.flags & NO_DNA)
		var/obj/item/nif/S = /obj/item/nif/bioadap
		input_NIF = initial(S.name)
		new /obj/item/nif/bioadap(H)
	else
		var/list/NIF_types = typesof(/obj/item/nif)
		var/list/NIFs = list()

		for(var/NIF_type in NIF_types)
			var/obj/item/nif/S = NIF_type
			NIFs[capitalize(initial(S.name))] = NIF_type

		var/list/show_NIFs = sortList(NIFs) // the list that will be shown to the user to pick from

		input_NIF = tgui_input_list(user, "Pick the NIF type","Quick NIF", show_NIFs)
		var/chosen_NIF = NIFs[capitalize(input_NIF)]

		if(chosen_NIF)
			new chosen_NIF(H)
		else
			new /obj/item/nif(H)

	log_and_message_admins("Quick NIF'd [H.real_name] with a [input_NIF].", user)
	feedback_add_details("admin_verb","QNIF") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

ADMIN_VERB(reload_configuration, R_DEBUG, "Reload Configuration", "Reloads the configuration from the default path on the disk, wiping any in-round modifications.", ADMIN_CATEGORY_DEBUG_SERVER)
	if(tgui_alert(user, "Are you absolutely sure you want to reload the configuration from the default path on the disk, wiping any in-round modifications?", "Really reset?", list("No", "Yes")) != "Yes")
		return
	config.admin_reload()
