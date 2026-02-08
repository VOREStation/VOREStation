GLOBAL_VAR_INIT(global_vantag_hud, 0)

ADMIN_VERB(drop_everything, R_ADMIN, "Drop Everything", ADMIN_VERB_NO_DESCRIPTION, ADMIN_CATEGORY_HIDDEN, mob/living/dropee in GLOB.mob_list)
	var/confirm = tgui_alert(src, "Make [dropee] drop everything?", "Message", list("Yes", "No"))
	if(confirm != "Yes")
		return

	for(var/obj/item/W in dropee)
		if(istype(W, /obj/item/implant/backup) || istype(W, /obj/item/nif))	//There's basically no reason to remove either of these
			continue
		dropee.drop_from_inventory(W)

	dropee.regenerate_icons()

	log_admin("[key_name(user)] made [key_name(dropee)] drop everything!")
	var/msg = "[key_name_admin(user)] made [ADMIN_LOOKUPFLW(dropee)] drop everything!"
	message_admins(msg)
	feedback_add_details("admin_verb","DEVR") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_prison(mob/M as mob in GLOB.mob_list)
	set category = "Admin.Game"
	set name = "Prison"
	if(!check_rights_for(src, R_HOLDER))
		return

	if (ismob(M))
		if(isAI(M))
			tgui_alert_async(usr, "The AI can't be sent to prison you jerk!")
			return
		//strip their stuff before they teleport into a cell :downs:
		for(var/obj/item/W in M)
			M.drop_from_inventory(W)
		//teleport person to cell
		M.Paralyse(5)
		M.Sleeping(5)
		sleep(5)	//so they black out before warping
		M.loc = pick(GLOB.prisonwarp)
		if(ishuman(M))
			var/mob/living/carbon/human/prisoner = M
			prisoner.equip_to_slot_or_del(new /obj/item/clothing/under/color/prison(prisoner), slot_w_uniform)
			prisoner.equip_to_slot_or_del(new /obj/item/clothing/shoes/orange(prisoner), slot_shoes)
		spawn(50)
			to_chat(M, span_red("You have been sent to the prison station!"))
		log_admin("[key_name(usr)] sent [key_name(M)] to the prison station.")
		message_admins(span_blue("[key_name_admin(usr)] sent [key_name_admin(M)] to the prison station."), 1)
		feedback_add_details("admin_verb","PRISON") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

//Allows staff to determine who the newer players are.
/client/proc/cmd_check_new_players()
	set category = "Admin.Investigate"
	set name = "Check new Players"
	if(!check_rights_for(src, R_HOLDER))
		return

	var/age = tgui_alert(src, "Age check", "Show accounts yonger then _____ days", list("7","30","All"))
	if(!age)
		return
	if(age == "All")
		age = 9999999
	else
		age = text2num(age)

	var/missing_ages = 0
	var/msg = ""

	var/highlight_special_characters = 1

	for(var/client/C in GLOB.clients)
		if(C.player_age == "Requires database")
			missing_ages = 1
			continue
		if(C.player_age < age)
			msg += "[key_name(C, 1, 1, highlight_special_characters)]: account is [C.player_age] days old<br>"

	if(missing_ages)
		to_chat(src, "Some accounts did not have proper ages set in their clients.  This function requires database to be present.")

	if(msg != "")
		var/datum/browser/popup = new(src, "Player_age_check", "Player Age Check")
		popup.set_content(msg)
		popup.open()
	else
		to_chat(src, "No matches for that age range found.")

/client/proc/cmd_admin_subtle_message(mob/M as mob in GLOB.mob_list)
	set category = "Admin"
	set name = "Subtle Message"

	if(!ismob(M))	return
	if (!check_rights_for(src, R_HOLDER))
		return

	var/msg = tgui_input_text(usr, "Message:", text("Subtle PM to [M.key]"), encode = FALSE)

	if (!msg)
		return

	if(!(msg[1] == "<" && msg[length(msg)] == ">")) //You can use HTML but only if the whole thing is HTML. Tries to prevent admin 'accidents'.
		msg = sanitize(msg)

	if(usr)
		if (usr.client)
			if(check_rights_for(usr.client, R_HOLDER))
				to_chat(M, span_bold("You hear a voice in your head...") + " " + span_italics("[msg]"))

	log_admin("SubtlePM: [key_name(usr)] -> [key_name(M)] : [msg]")
	msg = span_admin_pm_notice(span_bold(" SubtleMessage: [key_name_admin(usr)] -> [key_name_admin(M)] :") + " [msg]")
	message_admins(msg)
	admin_ticket_log(M, msg)
	feedback_add_details("admin_verb","SMS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_world_narrate() // Allows administrators to fluff events a little easier -- TLE
	set category = "Fun.Narrate"
	set name = "Global Narrate"

	if (!check_rights_for(src, R_HOLDER))
		return

	var/msg = tgui_input_text(usr, "Message:", text("Enter the text you wish to appear to everyone:"), encode = FALSE)

	if (!msg)
		return
	if(!(msg[1] == "<" && msg[length(msg)] == ">")) //You can use HTML but only if the whole thing is HTML. Tries to prevent admin 'accidents'.
		msg = sanitize(msg)
	if (!msg)		// We check both before and after, just in case sanitization ended us up with empty message.
		return

	to_chat(world, "[msg]")
	log_admin("GlobalNarrate: [key_name(usr)] : [msg]")
	message_admins(span_blue(span_bold(" GlobalNarrate: [key_name_admin(usr)] : [msg]<BR>")), 1)
	feedback_add_details("admin_verb","GLN") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_direct_narrate(var/mob/M)	// Targetted narrate -- TLE
	set category = "Fun.Narrate"
	set name = "Direct Narrate"

	if(!check_rights_for(src, R_HOLDER))
		return

	if(!M)
		M = tgui_input_list(usr, "Direct narrate to who?", "Active Players", get_mob_with_client_list())

	if(!M)
		return

	var/msg = tgui_input_text(usr, "Message:", text("Enter the text you wish to appear to your target:"), encode = FALSE)
	if(msg && !(msg[1] == "<" && msg[length(msg)] == ">")) //You can use HTML but only if the whole thing is HTML. Tries to prevent admin 'accidents'.
		msg = sanitize(msg)

	if( !msg )
		return

	to_chat(M, msg)
	log_admin("DirectNarrate: [key_name(usr)] to ([M.name]/[M.key]): [msg]")
	msg = span_admin_pm_notice(span_bold(" DirectNarrate: [key_name(usr)] to ([M.name]/[M.key]):") + " [msg]<BR>")
	message_admins(msg)
	admin_ticket_log(M, msg)
	feedback_add_details("admin_verb","DIRN") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_godmode(mob/M as mob in GLOB.mob_list)
	set category = "Admin.Game"
	set name = "Toggle Godmode"

	if(!check_rights_for(src, R_HOLDER))
		return

	if(M.status_flags & GODMODE)
		M.RemoveElement(/datum/element/godmode)

	else if(!(M.status_flags & GODMODE))
		M.AddElement(/datum/element/godmode)

	to_chat(usr, span_blue("Toggled [(M.status_flags & GODMODE) ? "ON" : "OFF"]"))

	log_admin("[key_name(usr)] has toggled [key_name(M)]'s godmode to [(M.status_flags & GODMODE) ? "On" : "Off"]")
	var/msg = "[key_name_admin(usr)] has toggled [ADMIN_LOOKUPFLW(M)]'s godmode to [(M.status_flags & GODMODE) ? "On" : "Off"]"
	message_admins(msg)
	admin_ticket_log(M, msg)
	feedback_add_details("admin_verb","GOD_ENABLE") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/proc/cmd_admin_mute(mob/M as mob, mute_type, automute = 0)
	if(automute)
		if(!CONFIG_GET(flag/automute_on))
			return
	else
		if(!usr || !usr.client)
			return
		if(!check_rights_for(usr.client, R_HOLDER))
			to_chat(usr, span_red("Error: cmd_admin_mute: You don't have permission to do this."))
			return
		if(!M.client)
			to_chat(usr, span_red("Error: cmd_admin_mute: This mob doesn't have a client tied to it."))
		if(check_rights_for(M.client, R_HOLDER))
			to_chat(usr, span_red("Error: cmd_admin_mute: You cannot mute an admin/mod."))
	if(!M.client)
		return
	if(check_rights_for(M.client, R_HOLDER))
		return

	var/muteunmute
	var/mute_string

	switch(mute_type)
		if(MUTE_IC)			mute_string = "IC (say and emote)"
		if(MUTE_OOC)		mute_string = "OOC"
		if(MUTE_LOOC)		mute_string = "LOOC"
		if(MUTE_PRAY)		mute_string = "pray"
		if(MUTE_ADMINHELP)	mute_string = "adminhelp, admin PM and ASAY"
		if(MUTE_DEADCHAT)	mute_string = "deadchat and DSAY"
		if(MUTE_ALL)		mute_string = "everything"
		else				return

	if(automute)
		muteunmute = "auto-muted"
		M.client.prefs.muted |= mute_type
		log_admin("SPAM AUTOMUTE: [muteunmute] [key_name(M)] from [mute_string]")
		message_admins("SPAM AUTOMUTE: [muteunmute] [key_name_admin(M)] from [mute_string].", 1)
		to_chat(M, span_alert("You have been [muteunmute] from [mute_string] by the SPAM AUTOMUTE system. Contact an admin."))
		feedback_add_details("admin_verb","AUTOMUTE") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
		return

	if(M.client.prefs.muted & mute_type)
		muteunmute = "unmuted"
		M.client.prefs.muted &= ~mute_type
	else
		muteunmute = "muted"
		M.client.prefs.muted |= mute_type

	log_admin("[key_name(usr)] has [muteunmute] [key_name(M)] from [mute_string]")
	message_admins("[key_name_admin(usr)] has [muteunmute] [key_name_admin(M)] from [mute_string].", 1)
	to_chat(M, span_alert("You have been [muteunmute] from [mute_string]."))
	feedback_add_details("admin_verb","MUTE") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

ADMIN_VERB(cmd_admin_add_random_ai_law, R_ADMIN|R_FUN, "Add Random AI Law", "Adds a random law to the station ai.", ADMIN_CATEGORY_FUN_SILICON)
	var/confirm = tgui_alert(user, "You sure?", "Confirm", list("Yes", "No"))
	if(confirm != "Yes") return
	log_admin("[key_name(user)] has added a random AI law.")
	message_admins("[key_name_admin(user)] has added a random AI law.")

	var/show_log = tgui_alert(user, "Show ion message?", "Message", list("Yes", "No"))
	if(!show_log)
		return
	if(show_log == "Yes")
		command_announcement.Announce("Ion storm detected near \the [station_name()]. Please check all AI-controlled equipment for errors.", "Anomaly Alert", new_sound = 'sound/AI/ionstorm.ogg')

	IonStorm(0)
	feedback_add_details("admin_verb","ION") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/*
Allow admins to set players to be able to respawn/bypass 30 min wait, without the admin having to edit variables directly
Ccomp's first proc.
*/

/client/proc/get_ghosts(var/notify = 0,var/what = 2)
	// what = 1, return ghosts ass list.
	// what = 2, return mob list

	var/list/mobs = list()
	var/list/ghosts = list()
	if(!LAZYLEN(GLOB.observer_mob_list))
		if(notify)
			to_chat(src, "There doesn't appear to be any ghosts for you to select.")
		return
	var/list/sortmob = sort_names(GLOB.observer_mob_list)                           // get the mob list.

	for(var/mob/M in sortmob)
		var/name = M.name
		ghosts[name] = M                                        //get the name of the mob for the popup list
	if(what==1)
		return ghosts
	return mobs

ADMIN_VERB(allow_character_respawn, R_ADMIN|R_MOD|R_FUN, "Allow player to respawn", "Let a player bypass the wait to respawn or allow them to re-enter their corpse.", ADMIN_CATEGORY_GAME)
	var/target = tgui_input_list(user, "Select a ckey to allow to rejoin", "Allow Respawn Selector", GLOB.respawn_timers)
	if(!target)
		return

	if(GLOB.respawn_timers[target] == -1) // Their respawn timer is set to -1, which is 'not allowed to respawn'
		var/response = tgui_alert(user, "Are you sure you wish to allow this individual to respawn? They would normally not be able to.", "Allow impossible respawn?", list("No","Yes"))
		if(response != "Yes")
			return

	GLOB.respawn_timers -= target

	var/found_client = FALSE
	for(var/client/current_client as anything in GLOB.clients)
		if(current_client.ckey == target)
			found_client = current_client
			to_chat(current_client, span_boldnotice("You may now respawn. You should roleplay as if you learned nothing about the round during your time with the dead."))
			if(isobserver(current_client.mob))
				var/mob/observer/dead/dead_mob = current_client.mob
				dead_mob.can_reenter_corpse = 1
				to_chat(current_client, span_boldnotice("You can also re-enter your corpse, if you still have one!"))
			break

	if(!found_client)
		to_chat(user, span_notice("The associated client didn't appear to be connected, so they couldn't be notified, but they can now respawn if they reconnect."))

	log_admin("[key_name(user)] allowed [found_client ? key_name(found_client) : target] to bypass the respawn time limit")
	message_admins("Admin [key_name_admin(user)] allowed [found_client ? key_name_admin(found_client) : target] to bypass the respawn time limit")

ADMIN_VERB(toggle_antagHUD_use, R_ADMIN, "Toggle antagHUD usage", "Toggles antagHUD usage for observers.", ADMIN_CATEGORY_SERVER_GAME)
	var/action=""
	if(CONFIG_GET(flag/antag_hud_allowed))
		for(var/mob/observer/dead/dead_mob in user.get_ghosts())
			if(!check_rights_for(dead_mob.client, R_HOLDER))						//Remove the verb from non-admin ghosts
				remove_verb(dead_mob, /mob/observer/dead/verb/toggle_antagHUD)
			if(dead_mob.antagHUD)
				dead_mob.antagHUD = 0						// Disable it on those that have it enabled
				dead_mob.has_enabled_antagHUD = 2				// We'll allow them to respawn
				to_chat(dead_mob, span_boldwarning("The Administrator has disabled AntagHUD "))
		CONFIG_SET(flag/antag_hud_allowed, FALSE)
		to_chat(user, span_boldwarning("AntagHUD usage has been disabled"))
		action = "disabled"
	else
		for(var/mob/observer/dead/dead_mob in user.get_ghosts())
			if(!check_rights_for(dead_mob.client, R_HOLDER))						// Add the verb back for all non-admin ghosts
				add_verb(dead_mob, /mob/observer/dead/verb/toggle_antagHUD)
			to_chat(dead_mob, span_boldnotice("The Administrator has enabled AntagHUD"))	// Notify all observers they can now use AntagHUD
		CONFIG_SET(flag/antag_hud_allowed, TRUE)
		action = "enabled"
		to_chat(user, span_boldnotice("AntagHUD usage has been enabled"))

	log_admin("[key_name(user)] has [action] antagHUD usage for observers")
	message_admins("Admin [key_name_admin(user)] has [action] antagHUD usage for observers")

ADMIN_VERB(toggle_antagHUD_restrictions, R_ADMIN, "Toggle antagHUD Restrictions", "Restricts players that have used antagHUD from being able to join this round.", ADMIN_CATEGORY_SERVER_GAME)
	var/action=""
	if(CONFIG_GET(flag/antag_hud_restricted))
		for(var/mob/observer/dead/dead_mob in user.get_ghosts())
			to_chat(dead_mob, span_boldnotice("The administrator has lifted restrictions on joining the round if you use AntagHUD"))
		action = "lifted restrictions"
		CONFIG_SET(flag/antag_hud_restricted, FALSE)
		to_chat(user, span_boldnotice("AntagHUD restrictions have been lifted"))
	else
		for(var/mob/observer/dead/dead_mob in user.get_ghosts())
			to_chat(dead_mob, span_boldwarning("The administrator has placed restrictions on joining the round if you use AntagHUD"))
			to_chat(dead_mob, span_boldwarning("Your AntagHUD has been disabled, you may choose to re-enabled it but will be under restrictions "))
			dead_mob.antagHUD = 0
			dead_mob.has_enabled_antagHUD = 0
		action = "placed restrictions"
		CONFIG_SET(flag/antag_hud_restricted, TRUE)
		to_chat(user, span_boldwarning("AntagHUD restrictions have been enabled"))

	log_admin("[key_name(user)] has [action] on joining the round if they use AntagHUD")
	message_admins("Admin [key_name_admin(user)] has [action] on joining the round if they use AntagHUD")

/*
If a guy was gibbed and you want to revive him, this is a good way to do so.
Works kind of like entering the game with a new character. Character receives a new mind if they didn't have one.
Traitors and the like can also be revived with the previous role mostly intact.
/N */
ADMIN_VERB(respawn_character, (R_ADMIN|R_REJUVINATE), "Spawn Character", "(Re)Spawn a client's loaded character.", ADMIN_CATEGORY_FUN_EVENT_KIT)
	var/client/picked_client = tgui_input_list(user, "Please specify which client's character to spawn.", "Client", GLOB.clients)
	if(!picked_client)
		return

	user.respawn_character_proper(picked_client)

/client/proc/respawn_character_proper(client/picked_client)
	if(!istype(picked_client))
		return

	//I frontload all the questions so we don't have a half-done process while you're reading.
	var/location = tgui_alert(src, "Please specify where to spawn them.", "Location", list("Right Here", "Arrivals", "Cancel"))
	if(location == "Cancel" || !location)
		return

	var/announce = tgui_alert(src, "Announce as if they had just arrived?", "Announce", list("No", "Yes", "Cancel"))
	if(!announce || announce == "Cancel")
		return
	else if(announce == "Yes") //Too bad buttons can't just have 1/0 values and different display strings
		announce = 1
	else
		announce = 0

	var/inhabit = tgui_alert(src, "Put the person into the spawned mob?", "Inhabit", list("Yes", "No", "Cancel"))
	if(!inhabit || inhabit == "Cancel")
		return
	else if(inhabit == "Yes")
		inhabit = 1
	else
		inhabit = 0

	//Name matching is ugly but mind doesn't persist to look at.
	var/charjob
	var/records
	var/datum/data/record/record_found
	record_found = find_general_record("name",picked_client.prefs.real_name)

	//Found their record, they were spawned previously
	if(record_found)
		var/samejob = tgui_alert(src,"Found [picked_client.prefs.real_name] in data core. They were [record_found.fields["real_rank"]] this round. Assign same job? They will not be re-added to the manifest/records, either way.","Previously spawned",list("Yes","Assistant","No"))
		if(!samejob)
			return
		if(samejob == "Yes")
			charjob = record_found.fields["real_rank"]
		else if(samejob == JOB_ALT_VISITOR)
			charjob = JOB_ALT_VISITOR
	else
		records = tgui_alert(src,"No data core entry detected. Would you like add them to the manifest, and sec/med/HR records?","Records",list("No", "Yes", "Cancel"))
		if(!records || records == "Cancel")
			return
		if(records == "Yes")
			records = 1
		else
			records = 0

	//Well you're not reloading their job or they never had one.
	if(!charjob)
		var/pickjob = tgui_input_list(src, "Pick a job to assign them (or none).","Job Select", GLOB.joblist.Copy() + "-No Job-", "-No Job-")
		if(!pickjob)
			return
		if(pickjob != "-No Job-")
			charjob = pickjob

	//If you've picked a job by now, you can equip them.
	var/equipment
	if(charjob)
		equipment = tgui_alert(src, "Spawn them with equipment?", "Equipment", list("Yes", "No", "Cancel"))
		if(!equipment || equipment == "Cancel")
			return
		else if(equipment == "Yes")
			equipment = 1
		else
			equipment = 0

	var/custom_job
	var/custom_job_title
	if(charjob)
		custom_job = tgui_alert(src, "Customise Job Title?", "Custom Job", list("No", "Yes", "Cancel"))
		if(!custom_job || equipment == "Cancel")
			return
		else if(custom_job == "Yes")
			custom_job = 1
			custom_job_title = tgui_input_text(src, "Choose a Job Title for the character.","Job Title")
		else
			custom_job = 0

	//For logging later
	var/admin = key_name_admin(src)
	var/player_key = picked_client.key
	var/picked_ckey = picked_client.ckey
	var/picked_slot = picked_client.prefs.default_slot

	var/mob/living/carbon/human/new_character
	var/spawnloc
	var/showy

	//Where did you want to spawn them?
	switch(location)
		if("Right Here") //Spawn them on your turf
			spawnloc = get_turf(src.mob)
			showy = tgui_input_list(src, "Showy entrance?", "Showy", list("No", "Telesparks", "Drop Pod", "Fall", "Cancel"))
			if(showy == "Cancel")
				return
			if(showy == "Drop Pod")
				showy = tgui_alert(src, "Destructive drop pods cause damage in a 3x3 and may break turfs. Polite drop pods lightly damage the turfs but won't break through.", "Drop Pod", list("Polite", "Destructive", "Cancel")) // reusing var
				if(!showy || showy == "Cancel")
					return

		if("Arrivals") //Spawn them at a latejoin spawnpoint
			if(LAZYLEN(GLOB.latejoin))
				spawnloc = get_turf(pick(GLOB.latejoin))
			else if(LAZYLEN(GLOB.latejoin_tram))
				spawnloc = pick(GLOB.latejoin_tram)
			else
				to_chat(src, "This map has no latejoin spawnpoint.")
				return

		else //I have no idea how you're here
			to_chat(src, "Invalid spawn location choice.")
			return

	//Did we actually get a loc to spawn them?
	if(!spawnloc)
		to_chat(src, "Couldn't get valid spawn location.")
		return

	new_character = new(spawnloc)

	if(showy == "Telesparks")
		anim(spawnloc,new_character,'icons/mob/mob.dmi',,"phasein",,new_character.dir)
		playsound(spawnloc, "sparks", 50, 1)
		var/datum/effect/effect/system/spark_spread/spk = new(new_character)
		spk.set_up(5, 0, new_character)
		spk.attach(new_character)
		spk.start()

	//We were able to spawn them, right?
	if(!new_character)
		to_chat(src, "Something went wrong and spawning failed.")
		return

	// Respect admin spawn record choice. There's really not a nice way to do this without butchering copy_to() code for an admin proc
	var/old_mind_scan = picked_client.prefs.mind_scan
	var/old_body_scan = picked_client.prefs.resleeve_scan
	if(!records) // Make em false for the copy_to()
		picked_client.prefs.mind_scan = FALSE
		picked_client.prefs.resleeve_scan = FALSE

	//Write the appearance and whatnot out to the character
	picked_client.prefs.copy_to(new_character)

	// Restore pref state
	picked_client.prefs.mind_scan = old_mind_scan
	picked_client.prefs.resleeve_scan = old_body_scan

	//Write the appearance and whatnot out to the character
	if(new_character.dna)
		new_character.dna.ResetUIFrom(new_character)
		new_character.sync_dna_traits(TRUE) // Traitgenes Sync traits to genetics if needed
		new_character.sync_organ_dna()
	new_character.sync_addictions() // These are addicitions our profile wants... May as well give them!
	new_character.initialize_vessel()
	if(inhabit)
		new_character.key = player_key
		//Were they any particular special role? If so, copy.
		if(new_character.mind)
			var/datum/antagonist/antag_data = get_antag_data(new_character.mind.special_role)
			if(antag_data)
				antag_data.add_antagonist(new_character.mind)
				antag_data.place_mob(new_character)
			if(new_character.mind.antag_holder)
				new_character.mind.antag_holder.apply_antags(new_character)

	if(new_character.mind)
		new_character.mind.loaded_from_ckey = picked_ckey
		new_character.mind.loaded_from_slot = picked_slot

	for(var/lang in picked_client.prefs.alternate_languages)
		var/datum/language/chosen_language = GLOB.all_languages[lang]
		if(chosen_language)
			if(is_lang_whitelisted(src,chosen_language) || (new_character.species && (chosen_language.name in new_character.species.secondary_langs)))
				new_character.add_language(lang)

	SEND_SIGNAL(new_character, COMSIG_HUMAN_DNA_FINALIZED)

	//If desired, apply equipment.
	if(equipment)
		if(charjob)
			GLOB.job_master.EquipRank(new_character, charjob, 1)
			if(new_character.mind)
				new_character.mind.assigned_role = charjob
				new_character.mind.role_alt_title = GLOB.job_master.GetPlayerAltTitle(new_character, charjob)

	//If customised job title, modify here.
	if(custom_job && custom_job_title)
		var/character_name = new_character.name
		for(var/obj/item/card/id/player_id in new_character.contents)
			player_id.name = "[character_name]'s ID Card ([custom_job_title])"
			player_id.assignment = custom_job_title
		for(var/obj/item/pda/player_pda in new_character.contents)
			player_pda.name = "PDA-[character_name] ([custom_job_title])"
			player_pda.ownjob = custom_job_title
		new_character.mind.assigned_role = custom_job_title
		new_character.mind.role_alt_title = custom_job_title
		to_chat(new_character, "Your job title has been changed to [custom_job_title].")

	//If desired, add records.
	if(records)
		GLOB.data_core.manifest_inject(new_character)

	//A redraw for good measure
	new_character.regenerate_icons()

	new_character.update_transform()

	//If we're announcing their arrival
	if(announce)
		AnnounceArrival(new_character, new_character.mind.assigned_role, "Common", new_character.z)

	log_admin("[admin] has spawned [player_key]'s character [new_character.real_name].")
	message_admins("[admin] has spawned [player_key]'s character [new_character.real_name].")



	feedback_add_details("admin_verb","RSPCH") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

	// Drop pods and fall
	if(showy == "Polite")
		var/turf/target_turf = get_turf(new_character)
		new /obj/structure/drop_pod/polite(target_turf, new_character)
		to_chat(new_character, span_boldnotice("Please wait for your arrival."))
	else if(showy == "Destructive")
		var/turf/target_turf = get_turf(new_character)
		new /obj/structure/drop_pod(target_turf, new_character)
		to_chat(new_character, span_boldnotice("Please wait for your arrival."))
	else if(showy == "Fall")
		spawn(1)
			var/initial_x = new_character.pixel_x
			var/initial_y = new_character.pixel_y
			new_character.plane = 1
			new_character.pixel_x = rand(-150, 150)
			new_character.pixel_y = 500 // When you think that pixel_z is height but you are wrong
			new_character.density = FALSE
			new_character.opacity = FALSE
			animate(new_character, pixel_y = initial_y, pixel_x = initial_x , time = 7)
			spawn(7)
				new_character.end_fall()
		to_chat(new_character, span_boldnotice("You have been fully spawned. Enjoy the game."))

	return new_character

ADMIN_VERB(cmd_admin_add_freeform_ai_law, R_FUN, "Add Custom AI law", "Adds a custom law to a silicon.", ADMIN_CATEGORY_FUN_SILICON)
	var/input = tgui_input_text(user, "Please enter anything you want the AI to do. Anything. Serious.", "What?", "", MAX_MESSAGE_LEN)
	if(!input)
		return
	for(var/mob/living/silicon/ai/target_ai in GLOB.mob_list)
		if (target_ai.stat == 2)
			to_chat(user, "Upload failed. No signal is being detected from the AI.")
		else if (target_ai.see_in_dark == 0)
			to_chat(user, "Upload failed. Only a faint signal is being detected from the AI, and it is not responding to our requests. It may be low on power.")
		else
			target_ai.add_ion_law(input)
			for(var/mob/living/silicon/ai/found_ai in GLOB.mob_list)
				to_chat(found_ai, span_warning("... LAWS UPDATED!") + "\n" + input)
				found_ai.show_laws()

	log_admin("Admin [key_name(user)] has added a new AI law - [input]")
	message_admins("Admin [key_name_admin(user)] has added a new AI law - [input]", 1)

	var/show_log = tgui_alert(user, "Show ion message?", "Message", list("Yes", "No"))
	if(show_log == "Yes")
		command_announcement.Announce("Ion storm detected near the [station_name()]. Please check all AI-controlled equipment for errors.", "Anomaly Alert", new_sound = 'sound/AI/ionstorm.ogg')
	feedback_add_details("admin_verb","IONC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

ADMIN_VERB_AND_CONTEXT_MENU(cmd_admin_rejuvenate, R_ADMIN|R_FUN|R_MOD, "Rejuvenate", "Fully restores the target mob.", ADMIN_CATEGORY_GAME, mob/living/traget_mob as mob in GLOB.mob_list)
	if(!traget_mob)
		return
	if(!istype(traget_mob))
		tgui_alert_async(user, "Cannot revive a ghost")
		return
	if(CONFIG_GET(flag/allow_admin_rev))
		traget_mob.revive()

		log_admin("[key_name(user)] healed / revived [key_name(traget_mob)]")
		var/msg = span_danger("Admin [key_name_admin(user)] healed / revived [ADMIN_LOOKUPFLW(traget_mob)]!")
		message_admins(msg)
		admin_ticket_log(traget_mob, msg)
	else
		tgui_alert_async(user, "Admin revive disabled")
	feedback_add_details("admin_verb","REJU") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

ADMIN_VERB(cmd_admin_create_centcom_report, R_ADMIN|R_SERVER|R_FUN, "Create Command Report", "Creates a centcom report and sends it globally.", ADMIN_CATEGORY_FUN_EVENT_KIT)
	var/input = tgui_input_text(user, "Please enter anything you want. Anything. Serious.", "What?", "", MAX_MESSAGE_LEN, TRUE, prevent_enter = TRUE)
	var/customname = sanitizeSafe(tgui_input_text(user, "Pick a title for the report.", "Title", encode = FALSE))
	if(!input)
		return
	if(!customname)
		customname = "[using_map.company_name] Update"

	//New message handling
	post_comm_message(customname, replacetext(input, "\n", "<br/>"))

	var/confirm = tgui_alert(user, "Should this be announced to the general population?","Show world?", list("Yes","No"))
	if(!confirm)
		return
	if(confirm == "Yes")
		command_announcement.Announce(input, customname, new_sound = 'sound/AI/commandreport.ogg', msg_sanitized = 1);
	else
		to_chat(world, span_boldannounce("New [using_map.company_name] Update available at all communication consoles."))
		SEND_SOUND(world, sound('sound/AI/commandreport.ogg'))

	log_admin("[key_name(user)] has created a command report: [input]")
	message_admins("[key_name_admin(user)] has created a command report")
	feedback_add_details("admin_verb","CCR") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

ADMIN_VERB_AND_CONTEXT_MENU(cmd_admin_delete, R_FUN|R_ADMIN, "Delete", "Delete the selected atom.", ADMIN_CATEGORY_GAME, atom/atom_target as obj|mob|turf in _validate_atom(atom_target)) // I don't understand precisely how this fixes the string matching against a substring, but it does - Ater
	user.admin_delete(atom_target)

ADMIN_VERB(cmd_admin_list_open_jobs, R_HOLDER, "List free slots", "Show available job slots.", ADMIN_CATEGORY_INVESTIGATE)
	if(GLOB.job_master)
		for(var/datum/job/job in GLOB.job_master.occupations)
			to_chat(user, "[job.title]: [job.total_positions]")
	feedback_add_details("admin_verb","LFS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

ADMIN_VERB(cmd_admin_check_contents, R_HOLDER, "Check Contents", "Check the contents of the mob.", ADMIN_CATEGORY_INVESTIGATE, mob/living/living_target as mob in GLOB.mob_list)
	var/list/content_list = living_target.get_contents()
	for(var/target in content_list)
		to_chat(user, "[target]")
	feedback_add_details("admin_verb","CC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

ADMIN_VERB(toggle_view_range, R_HOLDER, "Change View Range", "Switches between 1x and custom views.", ADMIN_CATEGORY_GAME)
	var/view = user.view
	if(view == world.view)
		view = tgui_input_list(user, "Select view range:", "FUCK YE", list(1,2,3,4,5,6,7,8,9,10,11,12,13,14,128))
	else
		view = world.view
	user.mob.set_viewsize(view)

	log_admin("[key_name(user)] changed their view range to [view].")
	message_admins(span_blue("[key_name_admin(user)] changed their view range to [view]."))

	feedback_add_details("admin_verb","CVRA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

ADMIN_VERB(admin_call_shuttle, R_ADMIN|R_SERVER, "Call Shuttle", "Calls the emergency shuttel.", ADMIN_CATEGORY_EVENTS)
	if ((!( SSticker ) || !emergency_shuttle.location()))
		return

	var/confirm = tgui_alert(user, "You sure?", "Confirm", list("Yes", "No"))
	if(confirm != "Yes") return

	var/choice
	if(SSticker.mode.auto_recall_shuttle)
		choice = tgui_input_list(user, "The shuttle will just return if you call it. Call anyway?", "Shuttle Call", list("Confirm", "Cancel"))
		if(choice == "Confirm")
			emergency_shuttle.auto_recall = 1	//enable auto-recall
		else
			return

	choice = tgui_input_list(user, "Is this an emergency evacuation or a crew transfer?", "Shuttle Call", list("Emergency", "Crew Transfer"))
	if (choice == "Emergency")
		emergency_shuttle.call_evac()
	else
		emergency_shuttle.call_transfer()


	feedback_add_details("admin_verb","CSHUT") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	log_admin("[key_name(user)] admin-called the emergency shuttle.")
	message_admins(span_blue("[key_name_admin(user)] admin-called the emergency shuttle."))

ADMIN_VERB(admin_cancel_shuttle, R_ADMIN|R_FUN, "Cancel Shuttle", "Cancels the emergency shuttel.", ADMIN_CATEGORY_EVENTS)
	if(tgui_alert(user, "You sure?", "Confirm", list("Yes", "No")) != "Yes") return

	if(!SSticker || !emergency_shuttle.can_recall())
		return

	emergency_shuttle.recall()
	feedback_add_details("admin_verb","CCSHUT") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	log_admin("[key_name(user)] admin-recalled the emergency shuttle.")
	message_admins(span_blue("[key_name_admin(user)] admin-recalled the emergency shuttle."))

ADMIN_VERB(admin_deny_shuttle, R_ADMIN, "Toggle Deny Shuttle", "Prevents the shuttle from being called.", ADMIN_CATEGORY_EVENTS)
	if (!SSticker)
		return

	emergency_shuttle.deny_shuttle = !emergency_shuttle.deny_shuttle

	log_admin("[key_name(user)] has [emergency_shuttle.deny_shuttle ? "denied" : "allowed"] the shuttle to be called.")
	message_admins("[key_name_admin(user)] has [emergency_shuttle.deny_shuttle ? "denied" : "allowed"] the shuttle to be called.")

ADMIN_VERB(everyone_random, R_FUN, "Make Everyone Random", "Make everyone have a random appearance. You can only use this before rounds!", ADMIN_CATEGORY_FUN_DO_NOT)
	if (SSticker && SSticker.mode)
		to_chat(user, "Nope you can't do this, the game's already started. This only works before rounds!")
		return

	if(CONFIG_GET(flag/force_random_names))
		CONFIG_SET(flag/force_random_names, FALSE)
		message_admins("Admin [key_name_admin(user)] has disabled \"Everyone is Special\" mode.")
		to_chat(user, span_userdanger("Disabled."))
		return


	var/notifyplayers = tgui_alert(user, "Do you want to notify the players?", "Options", list("Yes", "No", "Cancel"))
	if(!notifyplayers || notifyplayers == "Cancel")
		return

	log_admin("Admin [key_name(user)] has forced the players to have random appearances.")
	message_admins("Admin [key_name_admin(user)] has forced the players to have random appearances.")

	if(notifyplayers == "Yes")
		to_chat(world, span_boldannounce(span_blue("Admin [user.key] has forced the players to have completely random identities!")))

	to_chat(user, span_userdanger(span_italics("Remember: you can always disable the randomness by using the verb again, assuming the round hasn't started yet.")))

	CONFIG_SET(flag/force_random_names, TRUE)
	feedback_add_details("admin_verb","MER") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

ADMIN_VERB(toggle_random_events, R_SERVER, "Toggle random events on/off", "Toggles random events such as meteors, black holes, blob (but not space dust) on/off", ADMIN_CATEGORY_SERVER_GAME)
	if(!CONFIG_GET(flag/allow_random_events))
		CONFIG_SET(flag/allow_random_events, TRUE)
		to_chat(user, "Random events enabled")
		message_admins("Admin [key_name_admin(user)] has enabled random events.")
	else
		CONFIG_SET(flag/allow_random_events, FALSE)
		to_chat(user, "Random events disabled")
		message_admins("Admin [key_name_admin(user)] has disabled random events.")
	feedback_add_details("admin_verb","TRE") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

ADMIN_VERB(despawn_player, R_ADMIN|R_EVENT, "Cryo Player", "Removes a player from the round as if they'd cryo'd.", ADMIN_CATEGORY_GAME, mob/target_mob in GLOB.living_mob_list)
	if(!target_mob)
		return

	var/confirm = tgui_alert(user, "Are you sure you want to cryo [target_mob]?","Confirmation",list("No","Yes"))
	if(confirm != "Yes")
		return

	var/list/human_cryopods = list()
	var/list/robot_cryopods = list()

	for(var/obj/machinery/cryopod/selected_cryopod in GLOB.machines)
		if(!selected_cryopod.control_computer)
			continue //Broken pod w/o computer, move on.

		var/listname = "[selected_cryopod.name] ([selected_cryopod.x],[selected_cryopod.y],[selected_cryopod.z])"
		if(istype(selected_cryopod,/obj/machinery/cryopod/robot))
			robot_cryopods[listname] = selected_cryopod
		else
			human_cryopods[listname] = selected_cryopod

	//Gotta log this up here before they get ghostized and lose their key or anything.
	log_and_message_admins("admin cryo'd [key_name(target_mob)].", user)
	feedback_add_details("admin_verb","ACRYO") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

	if(ishuman(target_mob))
		var/choice = tgui_input_list(user, "Select a cryopod to use","Cryopod Choice", human_cryopods)
		var/obj/machinery/cryopod/selected_cryopod = human_cryopods[choice]
		if(!selected_cryopod)
			return
		target_mob.ghostize()
		selected_cryopod.despawn_occupant(target_mob)
		return

	else if(issilicon(target_mob))
		if(isAI(target_mob))
			var/mob/living/silicon/ai/ai = target_mob
			GLOB.empty_playable_ai_cores += new /obj/structure/AIcore/deactivated(ai.loc)
			GLOB.global_announcer.autosay("[ai] has been moved to intelligence storage.", "Artificial Intelligence Oversight")
			ai.clear_client()
			return
		else
			var/choice = tgui_input_list(user, "Select a cryopod to use","Cryopod Choice", robot_cryopods)
			var/obj/machinery/cryopod/robot/selected_cryopod = robot_cryopods[choice]
			if(!selected_cryopod)
				return
			target_mob.ghostize()
			selected_cryopod.despawn_occupant(target_mob)
			return

	else if(isliving(target_mob))
		target_mob.ghostize()
		qdel(target_mob) //Bye

ADMIN_VERB(cmd_admin_droppod_spawn, R_SPAWN, "Drop Pod Atom", "Spawn a new atom/movable in a drop pod where you are.", ADMIN_CATEGORY_FUN_DROP_POD, object as text)
	var/list/types = typesof(/atom/movable)
	var/list/matches = new()

	for(var/path in types)
		if(findtext("[path]", object))
			matches += path

	if(!matches.len)
		return

	var/chosen
	if(matches.len==1)
		chosen = matches[1]
	else
		chosen = tgui_input_list(user, "Select a movable type:", "Spawn in Drop Pod", matches)
		if(!chosen)
			return

	var/podtype = tgui_alert(user, "Destructive drop pods cause damage in a 3x3 and may break turfs. Polite drop pods lightly damage the turfs but won't break through.", "Drop Pod", list("Polite", "Destructive", "Cancel"))
	if(!podtype || podtype == "Cancel")
		return
	var/autoopen = tgui_alert(user, "Should the pod open automatically?", "Drop Pod", list("Yes", "No", "Cancel"))
	if(!autoopen || autoopen == "Cancel")
		return
	switch(podtype)
		if("Destructive")
			var/atom/movable/AM = new chosen(user.mob.loc)
			new /obj/structure/drop_pod(get_turf(user.mob), AM, autoopen == "Yes" ? TRUE : FALSE)
		if("Polite")
			var/atom/movable/AM = new chosen(user.mob.loc)
			new /obj/structure/drop_pod/polite(get_turf(user.mob), AM, autoopen == "Yes" ? TRUE : FALSE)

	feedback_add_details("admin_verb","DPA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

ADMIN_VERB(cmd_admin_droppod_deploy, R_SPAWN, "Drop Pod Deploy", "Drop an existing mob where you are in a drop pod.", ADMIN_CATEGORY_FUN_DROP_POD, object as text)
	var/mob/living/living_target = tgui_input_list(user, "Select the mob to drop:", "Mob Picker", GLOB.living_mob_list)
	if(!living_target)
		return

	var/podtype = tgui_alert(user, "Destructive drop pods cause damage in a 3x3 and may break turfs. Polite drop pods lightly damage the turfs but won't break through.", "Drop Pod", list("Polite", "Destructive", "Cancel"))
	if(!podtype || podtype == "Cancel")
		return
	var/autoopen = tgui_alert(user, "Should the pod open automatically?", "Drop Pod", list("Yes", "No", "Cancel"))
	if(!autoopen || autoopen == "Cancel")
		return
	if(QDELETED(living_target))
		return
	switch(podtype)
		if("Destructive")
			new /obj/structure/drop_pod(get_turf(user.mob), living_target, autoopen == "Yes" ? TRUE : FALSE)
		if("Polite")
			new /obj/structure/drop_pod/polite(get_turf(user.mob), living_target, autoopen == "Yes" ? TRUE : FALSE)

	feedback_add_details("admin_verb","DPD") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

ADMIN_VERB(toggle_vantag_hud_global, R_EVENT|R_SERVER|R_ADMIN, "Toggle Global Event HUD", "Give everyone the Event HUD.", ADMIN_CATEGORY_FUN_EVENT_KIT)
	GLOB.global_vantag_hud = !GLOB.global_vantag_hud
	if(GLOB.global_vantag_hud)
		for(var/mob/living/living_target in GLOB.living_mob_list)
			if(living_target.ckey)
				living_target.vantag_hud = TRUE
				living_target.recalculate_vis()

	to_chat(user, span_warning("Global Event HUD has been turned [GLOB.global_vantag_hud ? "on" : "off"]."))
