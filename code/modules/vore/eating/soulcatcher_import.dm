/datum/vore_look/proc/import_soulcatcher(mob/host, var/list/soulcatcher_data)
	if(!host.soulgem)
		return FALSE

	if(!islist(soulcatcher_data))
		tgui_alert_async(host, "The supplied file was not a valid VRDB file.", "Error!")
		return FALSE

	if(LAZYLEN(soulcatcher_data) == 0)
		return FALSE

	var/confirm = tgui_alert(host, "WARNING: This will override your current soulcatcher settings!","Import soulcatcher?",list("Yes","Cancel"))

	if(confirm != "Yes")
		return FALSE

	var/obj/soulgem/gem = host.soulgem

	if(istext(soulcatcher_data["name"]))
		gem.rename(soulcatcher_data["name"])

	if(istext(soulcatcher_data["inside_flavor"]))
		gem.adjust_interior(soulcatcher_data["inside_flavor"])

	if(istext(soulcatcher_data["capture_message"]))
		gem.set_custom_message("capture", soulcatcher_data["capture_message"])

	if(istext(soulcatcher_data["transit_message"]))
		gem.set_custom_message("transit", soulcatcher_data["transit_message"])

	if(istext(soulcatcher_data["release_message"]))
		gem.set_custom_message("release", soulcatcher_data["release_message"])

	if(istext(soulcatcher_data["transfer_message"]))
		gem.set_custom_message("transfer", soulcatcher_data["transfer_message"])

	if(istext(soulcatcher_data["delete_message"]))
		gem.set_custom_message("delete", soulcatcher_data["delete_message"])

	if(istext(soulcatcher_data["linked_belly"]))
		gem.apply_stored_belly(soulcatcher_data["linked_belly"])

	if(isnum(soulcatcher_data["setting_flags"]))
		gem.setting_flags = NONE
		gem.toggle_setting(soulcatcher_data["setting_flags"])

	return TRUE
