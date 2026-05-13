/**
 * Admin verb: Convert Player Savefile
 *
 * Converts a player's save data between BYOND .sav (binary) and JSON formats.
 * Used for redundancy, import/export processing, and save file recovery.
 *
 * IMPORTANT: The target player must be logged off before conversion.
 * The verb refuses to run if the player is currently connected, and
 * instructs the admin to tell them to log off first.
 *
 * Files inside the player's vore/ subfolder are excluded from this process.
 * Those files are already JSON and are managed separately.
 */

/// Returns the base save directory for a given ckey.
/proc/get_player_save_dir(ckey)
	return "data/player_saves/[copytext(ckey, 1, 2)]/[ckey]"

ADMIN_VERB(admin_convert_savefile, R_ADMIN, "Convert Player Savefile", "Convert a player's preferences.sav to preferences.json or vice versa. Player must be logged off.", ADMIN_CATEGORY_SERVER_ADMIN)
	// Pick your target.
	var/target_ckey = tgui_input_text(user, "Enter the ckey of the player whose save file you want to convert.", "Convert Player Savefile")
	if(!target_ckey)
		return
	target_ckey = lowertext(target_ckey)

	// Refuse outright if the player is currently connected.
	// Modifying save files while the client is online risks data loss or corruption
	// because the server may overwrite the converted file on the next auto-save.
	for(var/client/C as anything in GLOB.clients)
		if(C.ckey == target_ckey)
			to_chat(user, span_danger("[target_ckey] is currently logged in. Tell them to log off before you try again."))
			message_admins("[key_name_admin(user)] attempted to convert [target_ckey]'s save file, but that player is online.")
			return

	// Also block if they connected at any point this round, even if currently offline.
	if(GLOB.persistent_clients_by_ckey[target_ckey])
		to_chat(user, span_danger("[target_ckey] has connected this round. Their save may have been written by the server since then. Wait until next round to convert."))
		message_admins("[key_name_admin(user)] attempted to convert [target_ckey]'s save file, but that player connected this round.")
		return

	// Make sure save files actually exist for this ckey.
	var/save_dir = get_player_save_dir(target_ckey)
	var/has_sav  = fexists("[save_dir]/preferences.sav")
	var/has_json = fexists("[save_dir]/preferences.json")

	if(!has_sav && !has_json)
		to_chat(user, span_danger("No save files found for '[target_ckey]'. Check that the ckey is correct."))
		return

	// Let the admin pick the conversion direction.
	var/list/options = list()
	if(has_sav)
		options += "preferences.sav -> preferences.json"
	if(has_json)
		options += "preferences.json -> preferences.sav"

	var/direction = tgui_input_list(user, "Select the conversion to perform for '[target_ckey]'.", "Convert Player Savefile", options)
	if(!direction)
		return

	// Warn the admin in case the player has logged in since we checked.
	var/confirm = tgui_alert(
		user,
		"WARNING: '[target_ckey]' should be logged off before this runs. Proceeding while they are online can corrupt their save.\n\nAre you sure [target_ckey] is logged off?",
		"Convert Player Savefile",
		list("Cancel", "Yes, they are logged off"))
	if(confirm != "Yes, they are logged off")
		return

	// Re-verify the player is still offline immediately before touching any files.
	for(var/client/C as anything in GLOB.clients)
		if(C.ckey == target_ckey)
			to_chat(user, span_danger("[target_ckey] is now online. Conversion aborted. Tell them to log off and try again."))
			message_admins("[key_name_admin(user)] attempted to convert [target_ckey]'s save file, but that player came online during the confirmation. Blocked.")
			return

	if(direction == "preferences.sav -> preferences.json")
		var/sav_path  = "[save_dir]/preferences.sav"
		var/json_path = "[save_dir]/preferences.json"

		// Back up the existing JSON file before overwriting it.
		if(fexists(json_path))
			var/bak = "[json_path].convbak"
			if(fexists(bak))
				fdel(bak)
			fcopy(json_path, bak)

		var/datum/json_savefile/result = new(json_path)
		result.import_byond_savefile(new /savefile(sav_path))
		result.save()

		log_and_message_admins("converted [target_ckey]'s preferences.sav to preferences.json", user)
		to_chat(user, span_filter_adminlog("Done. [target_ckey]'s preferences.sav has been converted to preferences.json."))

	else if(direction == "preferences.json -> preferences.sav")
		var/json_path = "[save_dir]/preferences.json"
		var/sav_path  = "[save_dir]/preferences.sav"

		// Back up the existing .sav file before overwriting it.
		if(fexists(sav_path))
			var/bak = "[sav_path].convbak"
			if(fexists(bak))
				fdel(bak)
			fcopy(sav_path, bak)
			// Delete the original so new() creates a blank savefile.
			// Without this, old entries not present in the JSON would persist in the file.
			fdel(sav_path)

		var/datum/json_savefile/source = new(json_path)
		var/savefile/result = new(sav_path)
		source.export_to_byond_savefile(result)

		log_and_message_admins("converted [target_ckey]'s preferences.json to preferences.sav", user)
		to_chat(user, span_filter_adminlog("Done. [target_ckey]'s preferences.json has been converted to preferences.sav."))
