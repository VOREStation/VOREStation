/datum/tgui_module/law_manager
	name = "Law manager"
	tgui_id = "LawManager"
	var/ion_law	= "IonLaw"
	var/zeroth_law = "ZerothLaw"
	var/inherent_law = "InherentLaw"
	var/supplied_law = "SuppliedLaw"
	var/supplied_law_position = MIN_SUPPLIED_LAW_NUMBER

	var/global/list/datum/ai_laws/admin_laws
	var/global/list/datum/ai_laws/player_laws
	var/mob/living/silicon/owner = null

/datum/tgui_module/law_manager/New(mob/living/silicon/S)
	. = ..()

	owner = S

	if(!admin_laws)
		admin_laws = new()
		player_laws = new()

		init_subtypes(/datum/ai_laws, admin_laws)
		admin_laws = dd_sortedObjectList(admin_laws)

		for(var/datum/ai_laws/laws in admin_laws)
			if(laws.selectable)
				player_laws += laws

/datum/tgui_module/law_manager/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	switch(action)
		if("law_channel")
			if(params["law_channel"] in owner.law_channels())
				owner.lawchannel = params["law_channel"]
			return TRUE

		if("state_law")
			var/datum/ai_law/AL = locate(params["ref"]) in owner.laws.all_laws()
			if(AL)
				var/state_law = text2num(params["state_law"])
				owner.laws.set_state_law(AL, state_law)
			return TRUE

		if("add_zeroth_law")
			if(zeroth_law && is_admin(ui.user) && !owner.laws.zeroth_law)
				owner.set_zeroth_law(zeroth_law)
			return TRUE

		if("add_ion_law")
			if(ion_law && is_malf(ui.user))
				owner.add_ion_law(ion_law)
			return TRUE

		if("add_inherent_law")
			if(inherent_law && is_malf(ui.user))
				owner.add_inherent_law(inherent_law)
			return TRUE

		if("add_supplied_law")
			if(supplied_law && supplied_law_position >= 1 && MIN_SUPPLIED_LAW_NUMBER <= MAX_SUPPLIED_LAW_NUMBER && is_malf(ui.user))
				owner.add_supplied_law(supplied_law_position, supplied_law)
			return TRUE

		if("change_zeroth_law")
			var/new_law = sanitize(params["val"])
			if(new_law && new_law != zeroth_law && can_still_topic(ui.user, state))
				zeroth_law = new_law
			return TRUE

		if("change_ion_law")
			var/new_law = sanitize(params["val"])
			if(new_law && new_law != ion_law && can_still_topic(ui.user, state))
				ion_law = new_law
			return TRUE

		if("change_inherent_law")
			var/new_law = sanitize(params["val"])
			if(new_law && new_law != inherent_law && can_still_topic(ui.user, state))
				inherent_law = new_law
			return TRUE

		if("change_supplied_law")
			var/new_law = sanitize(params["val"])
			if(new_law && new_law != supplied_law && can_still_topic(ui.user, state))
				supplied_law = new_law
			return TRUE

		if("change_supplied_law_position")
			var/new_position = tgui_input_number(ui.user, "Enter new supplied law position between 1 and [MAX_SUPPLIED_LAW_NUMBER], inclusive. Inherent laws at the same index as a supplied law will not be stated.", "Law Position", supplied_law_position, MAX_SUPPLIED_LAW_NUMBER, 1)
			if(isnum(new_position) && can_still_topic(ui.user, state))
				supplied_law_position = CLAMP(new_position, 1, MAX_SUPPLIED_LAW_NUMBER)
			return TRUE

		if("edit_law")
			if(is_malf(ui.user))
				var/datum/ai_law/AL = locate(params["edit_law"]) in owner.laws.all_laws()
				if(AL)
					var/new_law = sanitize(tgui_input_text(ui.user, "Enter new law. Leaving the field blank will cancel the edit.", "Edit Law", AL.law))
					if(new_law && new_law != AL.law && is_malf(ui.user) && can_still_topic(ui.user, state))
						log_and_message_admins("has changed a law of [owner] from '[AL.law]' to '[new_law]'")
						AL.law = new_law
				return TRUE

		if("delete_law")
			if(is_malf(ui.user))
				var/datum/ai_law/AL = locate(params["delete_law"]) in owner.laws.all_laws()
				if(AL && is_malf(ui.user))
					owner.delete_law(AL)
			return TRUE

		if("state_laws")
			owner.statelaws(owner.laws)
			return TRUE

		if("state_law_set")
			var/datum/ai_laws/ALs = locate(params["state_law_set"]) in (is_admin(ui.user) ? admin_laws : player_laws)
			if(ALs)
				owner.statelaws(ALs)
			return TRUE

		if("transfer_laws")
			if(is_malf(ui.user))
				var/datum/ai_laws/ALs = locate(params["transfer_laws"]) in (is_admin(ui.user) ? admin_laws : player_laws)
				if(ALs)
					log_and_message_admins("has transfered the [ALs.name] laws to [owner].")
					ALs.sync(owner, 0)
			return TRUE

		if("notify_laws")
			to_chat(owner, span_danger("Law Notice"))
			owner.laws.show_laws(owner)
			if(isAI(owner))
				var/mob/living/silicon/ai/AI = owner
				for(var/mob/living/silicon/robot/R in AI.connected_robots)
					to_chat(R, span_danger("Law Notice"))
					R.laws.show_laws(R)
			if(ui.user != owner)
				to_chat(ui.user, span_notice("Laws displayed."))
			return TRUE

/datum/tgui_module/law_manager/tgui_interact(mob/user, datum/tgui/ui)
	owner.lawsync()
	return ..() // 800, is_malf(user) ? 600 : 400

/datum/tgui_module/law_manager/tgui_data(mob/user)
	var/list/data = ..()

	data["ion_law_nr"] = ionnum()
	data["ion_law"] = ion_law
	data["zeroth_law"] = zeroth_law
	data["inherent_law"] = inherent_law
	data["supplied_law"] = supplied_law
	data["supplied_law_position"] = supplied_law_position

	package_laws(data, "zeroth_laws", list(owner.laws.zeroth_law))
	package_laws(data, "ion_laws", owner.laws.ion_laws)
	package_laws(data, "inherent_laws", owner.laws.inherent_laws)
	package_laws(data, "supplied_laws", owner.laws.supplied_laws)

	data["isAI"] = isAI(owner)
	data["isMalf"] = is_malf(user)
	data["isSlaved"] = owner.is_slaved()
	data["isAdmin"] = is_admin(user)

	var/list/channels = list()
	for(var/ch_name in owner.law_channels())
		channels[++channels.len] = list("channel" = ch_name)
	data["channel"] = owner.lawchannel
	data["channels"] = channels
	data["law_sets"] = package_multiple_laws(data["isAdmin"] ? admin_laws : player_laws)

	return data

/datum/tgui_module/law_manager/proc/package_laws(var/list/data, var/field, var/list/datum/ai_law/laws)
	var/list/packaged_laws = list()
	for(var/datum/ai_law/AL in laws)
		packaged_laws[++packaged_laws.len] = list("law" = AL.law, "index" = AL.get_index(), "state" = owner.laws.get_state_law(AL), "ref" = "\ref[AL]")
	data[field] = packaged_laws
	data["has_[field]"] = packaged_laws.len

/datum/tgui_module/law_manager/proc/package_multiple_laws(var/list/datum/ai_laws/laws)
	var/list/law_sets = list()
	for(var/datum/ai_laws/ALs in laws)
		var/list/packaged_laws = list()
		package_laws(packaged_laws, "zeroth_laws", list(ALs.zeroth_law, ALs.zeroth_law_borg))
		package_laws(packaged_laws, "ion_laws", ALs.ion_laws)
		package_laws(packaged_laws, "inherent_laws", ALs.inherent_laws)
		package_laws(packaged_laws, "supplied_laws", ALs.supplied_laws)
		law_sets[++law_sets.len] = list("name" = ALs.name, "header" = ALs.law_header, "ref" = "\ref[ALs]","laws" = packaged_laws)

	return law_sets

/datum/tgui_module/law_manager/proc/is_malf(var/mob/user)
	return (is_admin(user) && !owner.is_slaved()) || is_special_role(user)

/datum/tgui_module/law_manager/proc/is_special_role(var/mob/user)
	if(user.mind.special_role)
		return TRUE
	else
		return FALSE

/mob/living/silicon/proc/is_slaved()
	return 0

/mob/living/silicon/robot/is_slaved()
	return lawupdate && connected_ai ? sanitize(connected_ai.name) : null

/datum/tgui_module/law_manager/proc/sync_laws(var/mob/living/silicon/ai/AI)
	if(!AI)
		return
	for(var/mob/living/silicon/robot/R in AI.connected_robots)
		R.sync()
	log_and_message_admins("has syncronized [AI]'s laws with its borgs.")

/datum/tgui_module/law_manager/robot
/datum/tgui_module/law_manager/robot/tgui_state(mob/user)
	return GLOB.tgui_self_state

/datum/tgui_module/law_manager/admin
/datum/tgui_module/law_manager/admin/tgui_state(mob/user)
	return GLOB.tgui_admin_state
