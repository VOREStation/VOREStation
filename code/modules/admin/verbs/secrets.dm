ADMIN_VERB(secrets, R_HOLDER, "Secrets", "Abuse harder than you ever have before with this handy dandy semi-misc stuff menu.", ADMIN_CATEGORY_SECRETS)
	var/datum/secrets_menu/tgui = new(user)
	tgui.tgui_interact(user.mob)
	//BLACKBOX_LOG_ADMIN_VERB("Secrets Panel")
	feedback_add_details("admin_verb","S") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/secrets_menu
	var/client/holder //client of whoever is using this datum
	var/is_debugger = FALSE
	var/is_funmin = FALSE

/datum/secrets_menu/New(user)//user can either be a client or a mob due to byondcode(tm)
	if (istype(user, /client))
		var/client/user_client = user
		holder = user_client //if its a client, assign it to holder
	else
		var/mob/user_mob = user
		holder = user_mob.client //if its a mob, assign the mob's client to holder

	is_debugger = check_rights(R_DEBUG)
	is_funmin = check_rights(R_FUN)

/datum/secrets_menu/tgui_state(mob/user)
	return ADMIN_STATE(R_HOLDER)

/datum/secrets_menu/tgui_close()
	qdel(src)

/datum/secrets_menu/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Secrets")
		ui.open()

/datum/secrets_menu/tgui_data(mob/user)
	var/list/data = list()
	data["is_debugger"] = is_debugger
	data["is_funmin"] = is_funmin
	return data

#define HIGHLANDER_DELAY_TEXT "40 seconds (crush the hope of a normal shift)"
/datum/secrets_menu/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	. = ..()
	if(.)
		return
	if((action != "admin_log" || action != "show_admins") && !check_rights(R_ADMIN))
		return
	switch(action)
		//Generic Buttons anyone can use.
		if("admin_log")
			var/dat
			for(var/l in GLOB.admin_log)
				dat += "<li>[l]</li>"
			if(!GLOB.admin_log.len)
				dat += "No-one has done anything this round!"
			var/datum/browser/browser = new(holder, "admin_log", "Admin Logs", 600, 500)
			browser.set_content(dat)
			browser.open()
		if("dialog_log")
			var/dat = span_bold("Dialog Log<HR>")
			dat += "<fieldset style='border: 2px solid white; display: inline'>"
			for(var/l in GLOB.round_text_log)
				dat += "<li>[l]</li>"
			dat += "</fieldset>"
			if(!GLOB.round_text_log)
				dat += "No-one has said anything this round! (How odd?)"
			var/datum/browser/browser = new(holder, "dialog_logs", "[src]", 550, 650, src)
			browser.set_content(jointext(dat,null))
			browser.open()
		if("show_admins")
			var/dat
			if(GLOB.admin_datums)
				for(var/ckey in GLOB.admin_datums)
					var/datum/admins/D = GLOB.admin_datums[ckey]
					dat += "[ckey] - [D.rank_names()]<br>"
				var/datum/browser/browser = new(holder, "showadmins", "Current admins", 600, 500)
				browser.set_content(dat)
				browser.open()
		if("show_traitors_and_objectives") // Not implemented in the UI
			holder.holder.check_antagonists()
		if("show_game_mode")
			if (SSticker.mode) tgui_alert_async(holder, "The game mode is [SSticker.mode.name]")
			else tgui_alert_async(holder, "For some reason there's a ticker, but not a game mode")

		//Buttons for debug.
		//tbd

		//Buttons for helpful stuff. This is where people land in the tgui
		if("list_bombers")
			holder.holder.list_bombers()

		if("list_signalers")
			holder.holder.list_signalers()

		if("list_lawchanges")
			holder.holder.list_law_changes()

		if("showailaws")
			holder.holder.list_law_changes()

		if("manifest")
			holder.holder.show_manifest()

		if("dna")
			holder.holder.list_dna()

		if("fingerprints")
			holder.holder.list_fingerprints()

		if("prison_warp")
			for(var/mob/living/carbon/human/H in GLOB.mob_list)
				var/turf/T = get_turf(H)
				var/security = 0
				if((T in using_map.admin_levels) || GLOB.prisonwarped.Find(H))
				//don't warp them if they aren't ready or are already there
					continue
				H.Paralyse(5)
				H.Sleeping(5)
				if(H.wear_id)
					var/obj/item/card/id/id = H.get_idcard()
					for(var/A in id.GetAccess())
						if(A == ACCESS_SECURITY)
							security++
				if(!security)
					//strip their stuff before they teleport into a cell :downs:
					for(var/obj/item/W in H)
						if(istype(W, /obj/item/organ/external))
							continue
							//don't strip organs
						H.drop_from_inventory(W)
					//teleport person to cell
					H.loc = pick(GLOB.prisonwarp)
					H.equip_to_slot_or_del(new /obj/item/clothing/under/color/prison(H), slot_w_uniform)
					H.equip_to_slot_or_del(new /obj/item/clothing/shoes/orange(H), slot_shoes)
				else
					//teleport security person
					H.loc = pick(GLOB.prisonsecuritywarp)
				GLOB.prisonwarped += H

		if("night_shift_set")
			var/val = tgui_alert(holder, "What do you want to set night shift to? This will override the automatic system until set to automatic again.", "Night Shift", list("On", "Off", "Automatic"))
			switch(val)
				if("Automatic")
					if(CONFIG_GET(flag/enable_night_shifts))
						SSnightshift.can_fire = TRUE
						SSnightshift.fire()
					else
						SSnightshift.update_nightshift(active = FALSE, announce = TRUE, forced = TRUE)
				if("On")
					SSnightshift.can_fire = FALSE
					SSnightshift.update_nightshift(active = TRUE, announce = TRUE, forced = TRUE)
				if("Off")
					SSnightshift.can_fire = FALSE
					SSnightshift.update_nightshift(active = FALSE, announce = TRUE, forced = TRUE)

		if("trigger_xenomorph_infestation")
			GLOB.xenomorphs.attempt_random_spawn()

		if("trigger_cortical_borer_infestation")
			GLOB.borers.attempt_random_spawn()

		if("jump_shuttle")
			var/shuttle_tag = tgui_input_list(holder, "Which shuttle do you want to jump?", "Shuttle Choice", SSshuttles.shuttles)
			if (!shuttle_tag) return

			var/datum/shuttle/S = SSshuttles.shuttles[shuttle_tag]

			var/list/area_choices = return_areas()
			var/origin_area = tgui_input_list(holder, "Which area is the shuttle at now? (MAKE SURE THIS IS CORRECT OR THINGS WILL BREAK)", "Area Choice", area_choices)
			if (!origin_area) return

			var/destination_area = tgui_input_list(holder, "Which area is the shuttle at now? (MAKE SURE THIS IS CORRECT OR THINGS WILL BREAK)", "Area Choice", area_choices)
			if (!destination_area) return

			var/long_jump = tgui_alert(holder, "Is there a transition area for this jump?","Transition?", list("Yes","No"))
			if(!long_jump)
				return
			if (long_jump == "Yes")
				var/transition_area = tgui_input_list(holder, "Which area is the transition area? (MAKE SURE THIS IS CORRECT OR THINGS WILL BREAK)", "Area Choice", area_choices)
				if (!transition_area) return

				var/move_duration = tgui_input_number(holder, "How many seconds will this jump take?")

				S.long_jump(area_choices[origin_area], area_choices[destination_area], area_choices[transition_area], move_duration)
				message_admins(span_notice("[key_name_admin(holder)] has initiated a jump from [origin_area] to [destination_area] lasting [move_duration] seconds for the [shuttle_tag] shuttle"), 1)
				log_admin("[key_name_admin(holder)] has initiated a jump from [origin_area] to [destination_area] lasting [move_duration] seconds for the [shuttle_tag] shuttle")
			else
				S.short_jump(area_choices[origin_area], area_choices[destination_area])
				message_admins(span_notice("[key_name_admin(holder)] has initiated a jump from [origin_area] to [destination_area] for the [shuttle_tag] shuttle"), 1)
				log_admin("[key_name_admin(holder)] has initiated a jump from [origin_area] to [destination_area] for the [shuttle_tag] shuttle")

		if("launch_shuttle_forced")
			var/list/valid_shuttles = list()
			for (var/shuttle_tag in SSshuttles.shuttles)
				if (istype(SSshuttles.shuttles[shuttle_tag], /datum/shuttle/autodock))
					valid_shuttles += shuttle_tag

			var/shuttle_tag = tgui_input_list(holder, "Which shuttle's launch do you want to force?", "Shuttle Choice", valid_shuttles)
			if (!shuttle_tag)
				return

			var/datum/shuttle/autodock/S = SSshuttles.shuttles[shuttle_tag]
			if (S.can_force())
				S.force_launch(holder)
				log_and_message_admins("forced the [shuttle_tag] shuttle", holder)
			else
				tgui_alert_async(holder, "The [shuttle_tag] shuttle launch cannot be forced at this time. It's busy, or hasn't been launched yet.")

		if("launch_shuttle")
			var/list/valid_shuttles = list()
			for (var/shuttle_tag in SSshuttles.shuttles)
				if (istype(SSshuttles.shuttles[shuttle_tag], /datum/shuttle/autodock))
					valid_shuttles += shuttle_tag

			var/shuttle_tag = tgui_input_list(holder, "Which shuttle do you want to launch?", "Shuttle Choice", valid_shuttles)
			if (!shuttle_tag)
				return

			var/datum/shuttle/autodock/S = SSshuttles.shuttles[shuttle_tag]
			if (S.can_launch())
				S.launch(holder)
				log_and_message_admins("launched the [shuttle_tag] shuttle", holder)
			else
				tgui_alert_async(holder, "The [shuttle_tag] shuttle cannot be launched at this time. It's probably busy.")

		if("move_shuttle")
			var/confirm = tgui_alert(holder, "This command directly moves a shuttle from one area to another. DO NOT USE THIS UNLESS YOU ARE DEBUGGING A SHUTTLE AND YOU KNOW WHAT YOU ARE DOING.", "Are you sure?", list("Ok", "Cancel"))
			if (confirm != "Ok")
				return

			var/shuttle_tag = tgui_input_list(holder, "Which shuttle do you want to jump?", "Shuttle Choice", SSshuttles.shuttles)
			if (!shuttle_tag) return

			var/datum/shuttle/S = SSshuttles.shuttles[shuttle_tag]

			var/destination_tag = tgui_input_list(holder, "Which landmark do you want to jump to? (IF YOU GET THIS WRONG THINGS WILL BREAK)", "Landmark Choice", SSshuttles.registered_shuttle_landmarks)
			if (!destination_tag) return
			var/destination_location = SSshuttles.get_landmark(destination_tag)
			if (!destination_location) return

			S.attempt_move(destination_location)
			log_and_message_admins("moved the [shuttle_tag] shuttle", holder)

		//!fun! buttons.
		if("ghost_mode")
			var/list/affected_mobs = list()
			var/list/affected_areas = list()
			for(var/mob/M in GLOB.living_mob_list)
				if(M.stat == CONSCIOUS && !(M in affected_mobs))
					affected_mobs |= M
					switch(rand(1,4))
						if(1)
							M.show_message(span_notice("You shudder as if cold..."), 1)
						if(2)
							M.show_message(span_notice("You feel something gliding across your back..."), 1)
						if(3)
							M.show_message(span_notice("Your eyes twitch, you feel like something you can't see is here..."), 1)
						if(4)
							M.show_message(span_notice("You notice something moving out of the corner of your eye, but nothing is there..."), 1)

					for(var/obj/W in orange(5,M))
						if(prob(25) && !W.anchored)
							step_rand(W)

					var/area/A = get_area(M)
					if(A.requires_power && !A.always_unpowered && A.power_light && (A.z in using_map.player_levels))
						affected_areas |= get_area(M)

			affected_mobs |= holder
			for(var/area/AffectedArea in affected_areas)
				AffectedArea.power_light = 0
				AffectedArea.power_change()
				spawn(rand(25,50))
					AffectedArea.power_light = 1
					AffectedArea.power_change()

			sleep(100)
			for(var/mob/M in affected_mobs)
				M.show_message(span_notice("The chilling wind suddenly stops..."), 1)
			affected_mobs.Cut()
			affected_areas.Cut()

		if("paintball_mode")
			for(var/species in GLOB.all_species)
				var/datum/species/S = GLOB.all_species[species]
				S.blood_color = "rainbow"
			for(var/obj/effect/decal/cleanable/blood/B in world)
				B.basecolor = "rainbow"
				B.update_icon()

		if("power")
			if(!is_funmin)
				return
			//SSblackbox.record_feedback("nested tally", "admin_secrets_fun_used", 1, list("Power All APCs"))
			log_admin("[key_name(holder)] made all areas powered")
			message_admins(span_adminnotice("[key_name_admin(holder)] made all areas powered"))
			power_restore()
		if("unpower")
			if(!is_funmin)
				return
			//SSblackbox.record_feedback("nested tally", "admin_secrets_fun_used", 1, list("Depower All APCs"))
			log_admin("[key_name(holder)] made all areas unpowered")
			message_admins(span_adminnotice("[key_name_admin(holder)] made all areas unpowered"))
			power_failure()
		if("quickpower")
			if(!is_funmin)
				return
			//SSblackbox.record_feedback("nested tally", "admin_secrets_fun_used", 1, list("Power All SMESs"))
			log_admin("[key_name(holder)] made all SMESs powered")
			message_admins(span_adminnotice("[key_name_admin(holder)] made all SMESs powered"))
			power_restore_quick()
		if("gravity")
			GLOB.gravity_is_on = !GLOB.gravity_is_on
			for(var/area/A in world)
				A.gravitychange(GLOB.gravity_is_on)

			feedback_inc("admin_secrets_fun_used",1)
			feedback_add_details("admin_secrets_fun_used","Grav")
			if(GLOB.gravity_is_on)
				log_admin("[key_name(holder)] toggled gravity on.", 1)
				message_admins(span_notice("[key_name_admin(holder)] toggled gravity on."), 1)
				command_announcement.Announce("Gravity generators are again functioning within normal parameters. Sorry for any inconvenience.")
			else
				log_admin("[key_name(holder)] toggled gravity off.", 1)
				message_admins(span_notice("[key_name_admin(holder)] toggled gravity off."), 1)
				command_announcement.Announce("Feedback surge detected in mass-distributions systems. Artificial gravity has been disabled whilst the system reinitializes. Further failures may result in a gravitational collapse and formation of blackholes. Have a nice day.")
		if("tripleAI")
			if(!is_funmin)
				return
			holder.triple_ai()
			//SSblackbox.record_feedback("nested tally", "admin_secrets_fun_used", 1, list("Triple AI"))
		if("onlyone")
			if(!is_funmin)
				return
			var/response = tgui_alert(usr,"Delay by 40 seconds?", "There can, in fact, only be one", list("Instant!", HIGHLANDER_DELAY_TEXT))
			switch(response)
				if("Instant!")
					holder.only_one()
				if(HIGHLANDER_DELAY_TEXT)
					holder.only_one_delayed()
				else
					return
			//SSblackbox.record_feedback("nested tally", "admin_secrets_fun_used", 1, list("There Can Be Only One"))
		if("blackout")
			if(!is_funmin)
				return
			//SSblackbox.record_feedback("nested tally", "admin_secrets_fun_used", 1, list("Break All Lights"))
			message_admins("[key_name_admin(holder)] broke all lights")
			//for(var/obj/machinery/light/L as anything in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/light))
			//	L.break_light_tube()
			//	CHECK_TICK
			lightsout(0,0)
		if("partial_blackout")
			if(!is_funmin)
				return
			message_admins("[key_name_admin(holder)] broke some lights")
			lightsout(1,2)
		if("whiteout")
			if(!is_funmin)
				return
			//SSblackbox.record_feedback("nested tally", "admin_secrets_fun_used", 1, list("Fix All Lights"))
			message_admins("[key_name_admin(holder)] fixed all lights")
			//for(var/obj/machinery/light/L as anything in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/light))
			for(var/obj/machinery/light/L in GLOB.machines)
				L.fix()
				CHECK_TICK
		if("changebombcap")
			if(!is_funmin)
				return
			//SSblackbox.record_feedback("nested tally", "admin_secrets_fun_used", 1, list("Bomb Cap"))

			//var/newBombCap = tgui_input_list(holder,"What would you like the new bomb cap to be. (entered as the light damage range (the 3rd number in common (1,2,3) notation)) Must be above 4)", "New Bomb Cap", GLOB.MAX_EX_LIGHT_RANGE)
			//if (!CONFIG_SET(number/bombcap, newBombCap))
			//	return

			var/new_cap = tgui_input_list(holder, "Select the max explosion range", "Change Bomb Cap", list(14, 16, 20, 28, 56, 128))

			if(new_cap)
				GLOB.max_explosion_range = new_cap

			var/range_dev = GLOB.max_explosion_range *0.25
			var/range_high = GLOB.max_explosion_range *0.5
			var/range_low = GLOB.max_explosion_range

			message_admins(span_danger("[key_name_admin(holder)] changed the bomb cap to [range_dev], [range_high], [range_low]"))
			log_admin("[key_name_admin(holder)] changed the bomb cap to [GLOB.max_explosion_range]")

			//message_admins(span_boldannounce("[key_name_admin(holder)] changed the bomb cap to [GLOB.MAX_EX_DEVESTATION_RANGE], [GLOB.MAX_EX_HEAVY_RANGE], [GLOB.MAX_EX_LIGHT_RANGE]"))
			//log_admin("[key_name(holder)] changed the bomb cap to [GLOB.MAX_EX_DEVESTATION_RANGE], [GLOB.MAX_EX_HEAVY_RANGE], [GLOB.MAX_EX_LIGHT_RANGE]")

		if("alter_narsie")
			var/choice = tgui_alert(holder, "How do you wish for Nar-Sie to interact with its surroundings?","NarChoice",list("CultStation13", "Nar-Singulo"))
			if(choice == "CultStation13")
				log_and_message_admins("has set narsie's behaviour to \"CultStation13\".", holder)
				GLOB.narsie_behaviour = choice
			if(choice == "Nar-Singulo")
				log_and_message_admins("has set narsie's behaviour to \"Nar-Singulo\".", holder)
				GLOB.narsie_behaviour = choice

		if("remove_all_clothing")
			for(var/obj/item/clothing/O in world)
				qdel(O)

		if("remove_internal_clothing")
			for(var/obj/item/clothing/under/O in world)
				qdel(O)

		if("send_strike_team")
			holder.strike_team()

		//buttons that are fun for exactly you and nobody else.
		if("corgie")
			for(var/mob/living/carbon/human/H in GLOB.mob_list)
				spawn(0)
					H.corgize()

		if("monkey")
			if(!is_funmin)
				return
			//SSblackbox.record_feedback("nested tally", "admin_secrets_fun_used", 1, list("Monkeyize All Humans"))
			message_admins("[key_name_admin(holder)] made everyone into monkeys.")
			log_admin("[key_name_admin(holder)] made everyone into monkeys.")
			for(var/i in GLOB.mob_list)
				var/mob/living/carbon/human/H = i
				INVOKE_ASYNC(H, TYPE_PROC_REF(/mob/living/carbon/human, monkeyize))

		if("supermatter_cascade")
			var/choice = tgui_alert(holder, "You sure you want to destroy the universe and create a large explosion at your location? Misuse of this could result in removal of flags or hilarity.","WARNING!", list("NO TIME TO EXPLAIN", "Cancel"))
			if(choice == "NO TIME TO EXPLAIN")
				explosion(get_turf(holder.mob), 8, 16, 24, 32, 1)
				SSturf_cascade.start_cascade(get_turf(holder.mob), /turf/unsimulated/wall/supermatter)
				SetUniversalState(/datum/universal_state/supermatter_cascade)
				message_admins("[key_name_admin(holder)] has managed to destroy the universe with a supermatter cascade. Good job, [key_name_admin(holder)]")

		if("summon_narsie")
			var/choice = tgui_alert(holder, "You sure you want to end the round and summon Nar-Sie at your location? Misuse of this could result in removal of flags or hilarity.","WARNING!",list("PRAISE SATAN", "Cancel"))
			if(choice == "PRAISE SATAN")
				new /obj/singularity/narsie/large(get_turf(holder))
				log_and_message_admins("has summoned Nar-Sie and brought about a new realm of suffering.", holder)

	if(holder)
		log_admin("[key_name(holder)] used secret: [action].")
#undef HIGHLANDER_DELAY_TEXT
