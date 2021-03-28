/client/proc/spawn_character_mob()
	set category = "Special Verbs"
	set name = "Spawn Character As Mob"
	set desc = "Spawn a specified ckey as a chosen mob."
	
	if(!holder)
		return

	var/client/picked_client = input(src, "Who are we spawning as a mob?", "Client", "Cancel") as null|anything in GLOB.clients
	if(!picked_client)
		return
	var/list/types = typesof(/mob/living)
	var/mob_type = input(src, "Mob path to spawn as?", "Mob") as text
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
		chosen = input("Select a mob type", "Select Mob", matches[1]) as null|anything in matches
		if(!chosen)
			return

	var/char_name = alert(src, "Spawn mob with their character name?", "Mob name", "Yes", "No", "Cancel")
	var/name = 0
	if(char_name == "Cancel")
		return
	if(char_name == "Yes")
		name = 1
	var/vorgans = alert(src, "Spawn mob with their character's vore organs and prefs?", "Vore organs", "Yes", "No", "Cancel")
	var/organs
	if(vorgans == "Cancel")
		return
	if(vorgans == "Yes")
		organs = 1
	if(vorgans == "No")
		organs = 0

	var/spawnloc
	if(!src.mob)
		to_chat(src, "Can't spawn them in unless you're in a valid spawn location!")
		return
	spawnloc = get_turf(src.mob)

	var/mob/living/new_mob = new chosen(spawnloc)

	if(!new_mob)
		to_chat(src, "Spawning failed, try again or bully coders")
		return
	new_mob.ai_holder_type = /datum/ai_holder/simple_mob/inert //Dont want the mob AI to activate if the client dc's or anything

	if(name)
		new_mob.real_name = picked_client.prefs.real_name
		new_mob.name = picked_client.prefs.real_name


	new_mob.key = picked_client.key //Finally put them in the mob
	if(organs)
		new_mob.copy_from_prefs_vr()

	log_admin("[key_name_admin(src)] has spawned [new_mob.key] as mob [new_mob.type].")
	message_admins("[key_name_admin(src)] has spawned [new_mob.key] as mob [new_mob.type].", 1)

	to_chat(new_mob, "You've been spawned as a mob! Have fun.")

	feedback_add_details("admin_verb","SCAM") //heh

	return new_mob

/client/proc/cmd_admin_z_narrate() // Allows administrators to fluff events a little easier -- TLE
	set category = "Special Verbs"
	set name = "Z Narrate"
	set desc = "Narrates to your Z level."

	if (!holder)
		return

	var/msg = input("Message:", text("Enter the text you wish to appear to everyone:")) as text
	if(!(msg[1] == "<" && msg[length(msg)] == ">")) //You can use HTML but only if the whole thing is HTML. Tries to prevent admin 'accidents'.
		msg = sanitize(msg)

	if (!msg)
		return

	var/pos_z = get_z(src.mob)
	if (!pos_z)
		return
	for(var/mob/M in player_list)
		if(M.z == pos_z)
			to_chat(M, msg)
	log_admin("ZNarrate: [key_name(usr)] : [msg]")
	message_admins("<font color='blue'><B> ZNarrate: [key_name_admin(usr)] : [msg]<BR></B></font>", 1)
	feedback_add_details("admin_verb","GLNA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/toggle_vantag_hud(var/mob/target as mob)
	set category = "Fun"
	set name = "Give/Remove Event HUD"
	set desc = "Give a mob the event hud, which shows them other people's event preferences, or remove it from them"

	if(target.vantag_hud)
		target.vantag_hud = FALSE
		target.recalculate_vis()
		to_chat(src, "You removed the event HUD from [key_name(target)].")
		to_chat(target, "You no longer have the event HUD.")	
	else
		target.vantag_hud = TRUE
		target.recalculate_vis()
		to_chat(src, "You gave the event HUD to [key_name(target)].")
		to_chat(target, "You now have the event HUD.  Icons will appear next to characters indicating if they prefer to be killed(red crosshairs), devoured(belly), or kidnapped(blue crosshairs) by event characters.")	
	feedback_add_details("admin_verb","GREHud") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
