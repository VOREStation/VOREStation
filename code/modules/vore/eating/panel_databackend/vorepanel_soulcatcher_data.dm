/datum/vore_look/proc/get_soulcatcher_data(mob/owner)
	if(!owner.soulgem)
		return null

	var/soulcatcher_data = list()
	var/list/stored_souls = list()
	for(var/soul in owner.soulgem.brainmobs)
		var/list/info = list("displayText" = "[soul]", "value" = "\ref[soul]")
		stored_souls.Add(list(info))
	soulcatcher_data["active"] = owner.soulgem.flag_check(SOULGEM_ACTIVE)
	soulcatcher_data["name"] = owner.soulgem.name
	soulcatcher_data["caught_souls"] = stored_souls
	soulcatcher_data["selected_soul"] = owner.soulgem.selected_soul
	soulcatcher_data["selected_sfx"] = owner.soulgem.linked_belly
	soulcatcher_data["interior_design"] =  owner.soulgem.inside_flavor
	soulcatcher_data["taken_over"] = owner.soulgem.is_taken_over()
	soulcatcher_data["catch_self"] = owner.soulgem.flag_check(NIF_SC_CATCHING_ME)
	soulcatcher_data["catch_prey"] = owner.soulgem.flag_check(NIF_SC_CATCHING_OTHERS)
	soulcatcher_data["catch_drain"] = owner.soulgem.flag_check(SOULGEM_CATCHING_DRAIN)
	soulcatcher_data["catch_ghost"] = owner.soulgem.flag_check(SOULGEM_CATCHING_GHOSTS)
	soulcatcher_data["ext_hearing"] = owner.soulgem.flag_check(NIF_SC_ALLOW_EARS)
	soulcatcher_data["ext_vision"] = owner.soulgem.flag_check(NIF_SC_ALLOW_EYES)
	soulcatcher_data["mind_backups"] = owner.soulgem.flag_check(NIF_SC_BACKUPS)
	soulcatcher_data["sr_projecting"] = owner.soulgem.flag_check(NIF_SC_PROJECTING)
	soulcatcher_data["show_vore_sfx"] = owner.soulgem.flag_check(SOULGEM_SHOW_VORE_SFX)
	soulcatcher_data["see_sr_projecting"] = owner.soulgem.flag_check(SOULGEM_SEE_SR_SOULS)
	return soulcatcher_data

/datum/vore_look/proc/get_ability_data(mob/owner)
	var/list/abilities = list()

	var/nutri_value = 0
	if(isliving(owner))
		var/mob/living/H = owner
		nutri_value = H.nutrition

	abilities["nutrition"] = nutri_value
	abilities["size_change"] = list (
		"current_size" = owner.size_multiplier,
		"minimum_size" = owner.has_large_resize_bounds() ? RESIZE_MINIMUM_DORMS : RESIZE_MINIMUM,
		"maximum_size" = owner.has_large_resize_bounds() ? RESIZE_MAXIMUM_DORMS : RESIZE_MAXIMUM,
		"resize_cost" = VORE_RESIZE_COST
	)
	return abilities
