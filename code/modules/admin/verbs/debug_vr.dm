/datum/admins/proc/quick_nif()
	set category = "Fun"
	set name = "Quick NIF"
	set desc = "Spawns a NIF into someone in quick-implant mode."
	
	var/input_NIF

	if(!check_rights(R_ADMIN))
		return

	var/mob/living/carbon/human/H = tgui_input_list(usr, "Pick a mob with a player","Quick NIF", player_list)

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
		var/obj/item/device/nif/S = /obj/item/device/nif/bioadap
		input_NIF = initial(S.name)
		new /obj/item/device/nif/bioadap(H)
	else
		var/list/NIF_types = typesof(/obj/item/device/nif)
		var/list/NIFs = list()

		for(var/NIF_type in NIF_types)
			var/obj/item/device/nif/S = NIF_type
			NIFs[capitalize(initial(S.name))] = NIF_type

		var/list/show_NIFs = sortList(NIFs) // the list that will be shown to the user to pick from

		input_NIF = tgui_input_list(usr, "Pick the NIF type","Quick NIF", show_NIFs)
		var/chosen_NIF = NIFs[capitalize(input_NIF)]

		if(chosen_NIF)
			new chosen_NIF(H)
		else
			new /obj/item/device/nif(H)

	log_and_message_admins("[key_name(src)] Quick NIF'd [H.real_name] with a [input_NIF].")
	feedback_add_details("admin_verb","QNIF") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc! 

