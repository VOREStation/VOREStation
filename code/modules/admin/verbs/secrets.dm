ADMIN_VERB(secrets, R_NONE, "Secrets", "", "Admin.Secrets")
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
	return GLOB.tgui_admin_state// TGUI_ADMIN_STATE(R_NONE)

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

		//!fun! buttons.
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

		//buttons that are fun for exactly you and nobody else.
		if("monkey")
			if(!is_funmin)
				return
			//SSblackbox.record_feedback("nested tally", "admin_secrets_fun_used", 1, list("Monkeyize All Humans"))
			message_admins("[key_name_admin(holder)] made everyone into monkeys.")
			log_admin("[key_name_admin(holder)] made everyone into monkeys.")
			for(var/i in mob_list)
				var/mob/living/carbon/human/H = i
				INVOKE_ASYNC(H, TYPE_PROC_REF(/mob/living/carbon/human, monkeyize))
	if(holder)
		log_admin("[key_name(holder)] used secret: [action].")
#undef HIGHLANDER_DELAY_TEXT
