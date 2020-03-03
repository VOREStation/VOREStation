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