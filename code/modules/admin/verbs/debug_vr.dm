/datum/admins/proc/quick_nif()
	set category = "Fun"
	set name = "Quick NIF"
	set desc = "Spawns a NIF into someone in quick-implant mode."

	if(!check_rights(R_ADMIN))
		return

	var/mob/living/carbon/human/H = input("Pick a mob with a player","Quick NIF") as null|anything in player_list

	if(!H)
		return

	if(!istype(H))
		to_chat(usr,"<span class='warning'>That mob type ([H.type]) doesn't support NIFs, sorry.</span>")
		return

	if(!H.get_organ(BP_HEAD))
		to_chat(usr,"<span class='warning'>Target is unsuitable.</span>")
		return

	if(H.nif)
		to_chat(usr,"<span class='warning'>Target already has a NIF.</span>")
		return

	if(H.species.flags & NO_SCAN)
		new /obj/item/device/nif/bioadap(H)
	else
		new /obj/item/device/nif(H)

	log_and_message_admins("[key_name(src)] Quick NIF'd [H.real_name].")
	feedback_add_details("admin_verb","QNIF") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/assistant_ratio()
	set category = "Admin"
	set name = "Toggle Asst. Ratio"
	set desc = "Toggles the assistant ratio enforcement on/off."

	if(!check_rights(R_ADMIN))
		return

	if(isnull(config.assistants_ratio))
		to_chat(usr,"<span class='warning'>Assistant ratio enforcement isn't even turned on...</span>")
		return

	config.assistants_ratio *= -1
	to_chat(usr,"<span class='notice'>Assistant ratio enforcement now [config.assistants_ratio > 0 ? "<b>en</b>abled" : "<b>dis</b>abled"].</span>")
