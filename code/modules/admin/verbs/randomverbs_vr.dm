
ADMIN_VERB(spawn_character_mob, R_SPAWN, "Spawn Character As Mob", "Spawn a specified ckey as a chosen mob.", ADMIN_CATEGORY_FUN_EVENT_KIT)
	var/client/picked_client = tgui_input_list(user, "Who are we spawning as a mob?", "Client", GLOB.clients)
	if(!picked_client)
		return
	var/list/types = typesof(/mob/living)
	var/mob_type = tgui_input_text(user, "Mob path to spawn as?", "Mob")
	if(!mob_type)
		return
	var/list/matches = new()
	for(var/path in types)
		if(findtext("[path]", mob_type))
			matches += path
	if(matches.len==0)
		return
	var/mob/living/chosen
	if(matches.len==1)
		chosen = matches[1]
	else
		chosen = tgui_input_list(user, "Select a mob type", "Select Mob", matches)
		if(!chosen)
			return

	var/char_name = tgui_alert(user, "Spawn mob with their character name?", "Mob name", list("Yes", "No", "Cancel"))
	var/name = 0
	if(!char_name || char_name == "Cancel")
		return
	if(char_name == "Yes")
		name = 1
	var/vorgans = tgui_alert(user, "Spawn mob with their character's vore organs and prefs?", "Vore organs", list("Yes", "No", "Cancel"))
	var/organs
	if(!vorgans || vorgans == "Cancel")
		return
	if(vorgans == "Yes")
		organs = 1
	if(vorgans == "No")
		organs = 0

	var/flavor = tgui_alert(user, "Spawn mob with their character's flavor text?", "Flavor text", list("General", "Robot", "Cancel"))

	var/spawnloc
	if(!user.mob)
		to_chat(user, "Can't spawn them in unless you're in a valid spawn location!")
		return
	spawnloc = get_turf(user.mob)

	var/mob/living/new_mob = new chosen(spawnloc)

	if(!new_mob)
		to_chat(user, "Spawning failed, try again or bully coders")
		return
	new_mob.ai_holder_type = /datum/ai_holder/simple_mob/inert //Dont want the mob AI to activate if the client dc's or anything

	if(name)
		var/spawner_name = picked_client.prefs.read_preference(/datum/preference/name/real_name)
		new_mob.real_name = spawner_name
		new_mob.name = spawner_name


	new_mob.key = picked_client.key //Finally put them in the mob
	if(flavor == "General")
		new_mob.flavor_text = new_mob?.client?.prefs?.flavor_texts["general"]
	if(flavor == "Robot")
		new_mob.flavor_text = new_mob?.client?.prefs?.flavour_texts_robot["Default"]
	if(organs)
		new_mob.copy_from_prefs_vr()
		if(LAZYLEN(new_mob.vore_organs))
			new_mob.vore_selected = new_mob.vore_organs[1]
			if(isanimal(new_mob))
				var/mob/living/simple_mob/new_simple_mob = new_mob
				if(!new_simple_mob.voremob_loaded || !new_simple_mob.vore_active)
					new_simple_mob.init_vore(TRUE)

	log_admin("[key_name_admin(user)] has spawned [new_mob.key] as mob [new_mob.type].")
	message_admins("[key_name_admin(user)] has spawned [new_mob.key] as mob [new_mob.type].", 1)

	to_chat(new_mob, "You've been spawned as a mob! Have fun.")

	feedback_add_details("admin_verb","SCAM") //heh

	return new_mob

ADMIN_VERB(cmd_admin_z_narrate, (R_ADMIN|R_MOD|R_EVENT), "Z Narrate", "Narrates to your Z level.", ADMIN_CATEGORY_FUN_NARRATE) // Allows administrators to fluff events a little easier -- TLE
	var/msg = tgui_input_text(user, "Message:", text("Enter the text you wish to appear to everyone:"))

	if (!msg)
		return

	if(!(msg[1] == "<" && msg[length(msg)] == ">")) //You can use HTML but only if the whole thing is HTML. Tries to prevent admin 'accidents'.
		msg = sanitize(msg)

	if (!msg)
		return

	var/pos_z = get_z(user.mob)
	if (!pos_z)
		return
	for(var/mob/M in GLOB.player_list)
		if(M.z == pos_z)
			to_chat(M, msg)
	log_admin("ZNarrate: [key_name(user)] : [msg]")
	message_admins(span_blue(span_bold(" ZNarrate: [key_name_admin(user)] : [msg]<BR>")), 1)
	feedback_add_details("admin_verb","GLNA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

ADMIN_VERB_AND_CONTEXT_MENU(toggle_vantag_hud, R_EVENT|R_ADMIN|R_SERVER, "Give/Remove Event HUD", "Give a mob the event hud, which shows them other people's event preferences, or remove it from them.", ADMIN_CATEGORY_FUN_EVENT_KIT, mob/target in GLOB.player_list)
	if(target.vantag_hud)
		target.vantag_hud = FALSE
		target.recalculate_vis()
		to_chat(user, "You removed the event HUD from [key_name(target)].")
		to_chat(target, "You no longer have the event HUD.")
	else
		target.vantag_hud = TRUE
		target.recalculate_vis()
		to_chat(user, "You gave the event HUD to [key_name(target)].")
		to_chat(target, "You now have the event HUD.  Icons will appear next to characters indicating if they prefer to be killed(red crosshairs), devoured(belly), or kidnapped(blue crosshairs) by event characters.")
	feedback_add_details("admin_verb","GREHud") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
