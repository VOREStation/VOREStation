/datum/tgui_module/agentcard
	name = "Agent Card"
	tgui_id = "AgentCard"

/datum/tgui_module/agentcard/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	var/obj/item/weapon/card/id/syndicate/S = tgui_host()
	if(!istype(S))
		return list()

	var/list/entries = list()
	entries += list(list("name" = "Age", 				"value" = S.age))
	entries += list(list("name" = "Appearance",			"value" = "Set"))
	entries += list(list("name" = "Assignment",			"value" = S.assignment))
	entries += list(list("name" = "Blood Type",			"value" = S.blood_type))
	entries += list(list("name" = "DNA Hash", 			"value" = S.dna_hash))
	entries += list(list("name" = "Fingerprint Hash",	"value" = S.fingerprint_hash))
	entries += list(list("name" = "Name", 				"value" = S.registered_name))
	entries += list(list("name" = "Photo", 				"value" = "Update"))
	entries += list(list("name" = "Sex", 				"value" = S.sex))
	entries += list(list("name" = "Factory Reset",		"value" = "Use With Care"))
	data["entries"] = entries

	data["electronic_warfare"] = S.electronic_warfare

	return data

/datum/tgui_module/agentcard/tgui_status(mob/user, datum/tgui_state/state)
	var/obj/item/weapon/card/id/syndicate/S = tgui_host()
	if(!istype(S))
		return STATUS_CLOSE
	if(user != S.registered_user)
		return STATUS_CLOSE
	return ..()

/datum/tgui_module/agentcard/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	var/obj/item/weapon/card/id/syndicate/S = tgui_host()
	switch(action)
		if("electronic_warfare")
			S.electronic_warfare = !S.electronic_warfare
			to_chat(usr, "<span class='notice'>Electronic warfare [S.electronic_warfare ? "enabled" : "disabled"].</span>")
			. = TRUE
		if("age")
			var/new_age = input(usr,"What age would you like to put on this card?","Agent Card Age", S.age) as null|num
			if(!isnull(new_age) && tgui_status(usr, state) == STATUS_INTERACTIVE)
				if(new_age < 0)
					S.age = initial(S.age)
				else
					S.age = new_age
				to_chat(usr, "<span class='notice'>Age has been set to '[S.age]'.</span>")
				. = TRUE
		if("appearance")
			var/datum/card_state/choice = tgui_input_list(usr, "Select the appearance for this card.", "Agent Card Appearance", id_card_states())
			if(choice && tgui_status(usr, state) == STATUS_INTERACTIVE)
				S.icon_state = choice.icon_state
				S.item_state = choice.item_state
				S.sprite_stack = choice.sprite_stack
				S.update_icon()
				to_chat(usr, "<span class='notice'>Appearance changed to [choice].</span>")
				. = TRUE
		if("assignment")
			var/new_job = sanitize(input(usr,"What assignment would you like to put on this card?\nChanging assignment will not grant or remove any access levels.","Agent Card Assignment", S.assignment) as null|text)
			if(!isnull(new_job) && tgui_status(usr, state) == STATUS_INTERACTIVE)
				S.assignment = new_job
				to_chat(usr, "<span class='notice'>Occupation changed to '[new_job]'.</span>")
				S.update_name()
				. = TRUE
		if("bloodtype")
			var/default = S.blood_type
			if(default == initial(S.blood_type) && ishuman(usr))
				var/mob/living/carbon/human/H = usr
				if(H.dna)
					default = H.dna.b_type
			var/new_blood_type = sanitize(tgui_input_text(usr,"What blood type would you like to be written on this card?","Agent Card Blood Type",default))
			if(!isnull(new_blood_type) && tgui_status(usr, state) == STATUS_INTERACTIVE)
				S.blood_type = new_blood_type
				to_chat(usr, "<span class='notice'>Blood type changed to '[new_blood_type]'.</span>")
				. = TRUE
		if("dnahash")
			var/default = S.dna_hash
			if(default == initial(S.dna_hash) && ishuman(usr))
				var/mob/living/carbon/human/H = usr
				if(H.dna)
					default = H.dna.unique_enzymes
			var/new_dna_hash = sanitize(tgui_input_text(usr,"What DNA hash would you like to be written on this card?","Agent Card DNA Hash",default))
			if(!isnull(new_dna_hash) && tgui_status(usr, state) == STATUS_INTERACTIVE)
				S.dna_hash = new_dna_hash
				to_chat(usr, "<span class='notice'>DNA hash changed to '[new_dna_hash]'.</span>")
				. = TRUE
		if("fingerprinthash")
			var/default = S.fingerprint_hash
			if(default == initial(S.fingerprint_hash) && ishuman(usr))
				var/mob/living/carbon/human/H = usr
				if(H.dna)
					default = md5(H.dna.uni_identity)
			var/new_fingerprint_hash = sanitize(input(usr,"What fingerprint hash would you like to be written on this card?","Agent Card Fingerprint Hash",default) as null|text)
			if(!isnull(new_fingerprint_hash) && tgui_status(usr, state) == STATUS_INTERACTIVE)
				S.fingerprint_hash = new_fingerprint_hash
				to_chat(usr, "<span class='notice'>Fingerprint hash changed to '[new_fingerprint_hash]'.</span>")
				. = TRUE
		if("name")
			var/new_name = sanitizeName(tgui_input_text(usr,"What name would you like to put on this card?","Agent Card Name", S.registered_name))
			if(!isnull(new_name) && tgui_status(usr, state) == STATUS_INTERACTIVE)
				S.registered_name = new_name
				S.update_name()
				to_chat(usr, "<span class='notice'>Name changed to '[new_name]'.</span>")
				. = TRUE
		if("photo")
			S.set_id_photo(usr)
			to_chat(usr, "<span class='notice'>Photo changed.</span>")
			. = TRUE
		if("sex")
			var/new_sex = sanitize(tgui_input_text(usr,"What sex would you like to put on this card?","Agent Card Sex", S.sex))
			if(!isnull(new_sex) && tgui_status(usr, state) == STATUS_INTERACTIVE)
				S.sex = new_sex
				to_chat(usr, "<span class='notice'>Sex changed to '[new_sex]'.</span>")
				. = TRUE
		if("factoryreset")
			if(tgui_alert(usr, "This will factory reset the card, including access and owner. Continue?", "Factory Reset", list("No", "Yes")) == "Yes" && tgui_status(usr, state) == STATUS_INTERACTIVE)
				S.age = initial(S.age)
				S.access = syndicate_access.Copy()
				S.assignment = initial(S.assignment)
				S.blood_type = initial(S.blood_type)
				S.dna_hash = initial(S.dna_hash)
				S.electronic_warfare = initial(S.electronic_warfare)
				S.fingerprint_hash = initial(S.fingerprint_hash)
				S.icon_state = initial(S.icon_state)
				S.item_state = initial(S.item_state)
				S.sprite_stack = S.initial_sprite_stack
				S.front = null
				S.name = initial(S.name)
				S.registered_name = initial(S.registered_name)
				S.unset_registered_user()
				S.sex = initial(S.sex)
				S.update_icon()
				to_chat(usr, "<span class='notice'>All information has been deleted from \the [src].</span>")
				. = TRUE
