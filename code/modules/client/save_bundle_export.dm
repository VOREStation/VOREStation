/**
 * Player save bundle export.
 *
 * Prompts the player to choose between exporting their legacy BYOND .sav
 * file or their modern preferences.json (plus vore/ subfolder files).
 *
 * JSON bundle format:
 * {
 *   "format_version": 1,
 *   "ckey":           "playerckey",
 *   "preferences":    { ...preferences.json tree... },
 *   "vore":           { "filename.json": { ...tree... }, ... }
 * }
 *
 * The .sav export sends the raw binary savefile directly via ftp().
 * The JSON export bundles preferences.json and all vore/ files into a
 * single JSON file, working within BYOND's one-file-per-ftp() limitation.
 *
 * Both exports are logged to the game log.
 */

/// How long a player must wait between export downloads.
#define SAVE_BUNDLE_EXPORT_COOLDOWN (60 SECONDS)

/// Working directory for temporary export files.
#define SAVE_BUNDLE_EXPORT_WORKING_DIR "data/save_bundle_export_working_directory/"

#define EXPORT_FORMAT_SAV  "Legacy (.sav)"
#define EXPORT_FORMAT_JSON "Modern (JSON bundle)"

/client
	/// Cooldown for the save bundle export to prevent download spam.
	COOLDOWN_DECLARE(save_bundle_export_cooldown)

/**
 * Exports the calling client's full save data as either a raw .sav file
 * or a JSON bundle containing preferences.json and all vore/ files.
 * The player chooses the format and receives a single file download prompt.
 */
/client/verb/cmd_export_save_bundle()
	set name = "Export Save Data"
	set category = "OOC.Client Settings"
	set desc = "Download your full save data as either a legacy .sav or a modern JSON bundle."

	if(!COOLDOWN_FINISHED(src, save_bundle_export_cooldown))
		to_chat(src, span_warning("You must wait [DisplayTimeText(COOLDOWN_TIMELEFT(src, save_bundle_export_cooldown))] before exporting your save data again."))
		return

	var/save_dir = "data/player_saves/[copytext(ckey, 1, 2)]/[ckey]"

	// Step 1: ask which format the player wants to export.
	// Only offer formats that actually have a file on disk.
	var/has_sav  = fexists("[save_dir]/preferences.sav")
	var/has_json = fexists("[save_dir]/preferences.json")

	if(!has_sav && !has_json)
		to_chat(src, span_warning("No save data found to export."))
		return

	// If only one format exists, skip the question and go straight to confirmation.
	// If both exist, ask the player which they want.
	var/chosen_format
	if(has_sav && has_json)
		chosen_format = tgui_input_list(src, \
			"Which format do you want to export?\n\n[EXPORT_FORMAT_JSON] is what the station currently uses. [EXPORT_FORMAT_SAV] is an older legacy format.", \
			"Export Save Data", \
			list(EXPORT_FORMAT_JSON, EXPORT_FORMAT_SAV))
		if(!chosen_format)
			return
	else
		chosen_format = has_json ? EXPORT_FORMAT_JSON : EXPORT_FORMAT_SAV

	// Step 2: confirm with warning about bundle format.
	var/warning_text = "Export your save data as [chosen_format]? This will save a file to your computer."
	if(chosen_format == EXPORT_FORMAT_JSON)
		warning_text += "\n\nIMPORTANT: The exported JSON bundle contains multiple files combined into one. It CANNOT be placed directly into your save folder. Use the debundler tool to extract individual files before restoring."
	if(tgui_alert(src, warning_text, "Export Save Data", list("Cancel", "Export")) != "Export")
		return

	COOLDOWN_START(src, save_bundle_export_cooldown, SAVE_BUNDLE_EXPORT_COOLDOWN)

	if(chosen_format == EXPORT_FORMAT_SAV)
		_export_sav(save_dir)
	else
		_export_json_bundle(save_dir)

/// Sends the raw legacy .sav file directly to the client.
/client/proc/_export_sav(var/save_dir)
	var/sav_path = "[save_dir]/preferences.sav"
	if(!fexists(sav_path))
		to_chat(src, span_warning("Legacy .sav file not found. It may have already been migrated."))
		COOLDOWN_START(src, save_bundle_export_cooldown, 0)
		return

	var/file_name = "[ckey]_preferences_[time2text(world.timeofday, "MMM_DD_YYYY_hh-mm-ss")].sav"
	log_and_message_admins("exported their legacy .sav save file.")
	DIRECT_OUTPUT(src, ftp(file(sav_path), file_name))

/// Builds a JSON bundle from preferences.json and all vore/ files, then sends it.
/client/proc/_export_json_bundle(var/save_dir)
	var/prefs_path = "[save_dir]/preferences.json"
	if(!fexists(prefs_path))
		to_chat(src, span_warning("preferences.json not found."))
		COOLDOWN_START(src, save_bundle_export_cooldown, 0)
		return

	// Build the bundle.
	var/list/bundle = list()
	bundle["format_version"] = 1
	bundle["ckey"] = ckey

	// Load preferences.
	bundle["preferences"] = json_decode(rustg_file_read(prefs_path))

	// Load vore/ subfolder files, if any exist.
	var/vore_dir = "[save_dir]/vore/"
	var/list/vore_files = list()
	if(fexists(vore_dir))
		for(var/filename in flist(vore_dir))
			// flist() appends "/" to subdirectory names; skip those and non-JSON files.
			if(copytext(filename, length(filename)) == "/")
				continue
			if(!findtext(filename, ".json"))
				continue
			var/file_path = "[vore_dir][filename]"
			if(fexists(file_path))
				vore_files[filename] = json_decode(rustg_file_read(file_path))
	bundle["vore"] = vore_files

	var/file_name = "[ckey]_save_bundle_[time2text(world.timeofday, "MMM_DD_YYYY_hh-mm-ss")].json"
	var/temp_path = "[SAVE_BUNDLE_EXPORT_WORKING_DIR][file_name]"

	if(!text2file(json_encode(bundle, JSON_PRETTY_PRINT), temp_path))
		to_chat(src, span_warning("Failed to generate export file. Try again later."))
		COOLDOWN_START(src, save_bundle_export_cooldown, 0)
		return

	log_and_message_admins("exported their save data as a JSON bundle ([length(vore_files)] vore file\s included).")
	DIRECT_OUTPUT(src, ftp(file(temp_path), file_name))
	fdel(temp_path)
	to_chat(src, span_notice("Save bundle exported. This file contains preferences.json and [length(vore_files)] vore file\s bundled together."))
	to_chat(src, span_warning("Do NOT place this file directly in your save folder. It is a bundle of multiple files. Use the debundler tool to extract individual files before restoring."))

#undef SAVE_BUNDLE_EXPORT_COOLDOWN
#undef SAVE_BUNDLE_EXPORT_WORKING_DIR
#undef EXPORT_FORMAT_SAV
#undef EXPORT_FORMAT_JSON

/*
 * FOR FUTURE REFERENCE, THESE MAY CAUSE DATA LOSS. BE CAREFUL.
 *
 * The two procs below are stubs for the import side of the export system.
 * They are commented out until they can be properly tested and gated.
 *
 * _import_json_bundle: takes a JSON bundle (as produced by _export_json_bundle)
 *   and writes each file back to disk. Renames existing files to .jsonbak first,
 *   deleting any existing .jsonbak to make room.
 *
 * cmd_import_sav: prompts the client to upload a .sav file, then saves it
 *   server-side into the player's save directory. Renames any existing .sav
 *   to .savbak first.
 */

// /// Prompts the client to upload a JSON bundle file, then writes it back to disk as individual files.
// /// Backs up existing files to .jsonbak before overwriting.
// /// NOTE: uses BYOND's input(src) as file to receive the upload from the client.
// /client/verb/cmd_import_json_bundle()
// 	set name = "Import Save Bundle (JSON)"
// 	set category = "OOC.Client Settings"
// 	set desc = "Upload a previously exported JSON save bundle to restore your save data."
//
// 	var/save_dir = "data/player_saves/[copytext(ckey, 1, 2)]/[ckey]"
//
// 	if(tgui_alert(src, "This will overwrite your current save data from a bundle file (backups will be kept as .jsonbak). Proceed?", "Import Save Bundle", list("Cancel", "Upload")) != "Upload")
// 		return
//
// 	// Prompt the client to select and upload a JSON bundle file.
// 	var/file/uploaded = input(src, "Select your JSON save bundle to upload.", "Import Save Bundle") as file
// 	if(!uploaded)
// 		return
//
// 	// Sanity check: file must have a .json extension.
// 	// "[uploaded]" stringifies to the filename in BYOND.
// 	if(!findtext("[uploaded]", ".json"))
// 		to_chat(src, span_warning("That file does not appear to be a JSON file. Make sure you selected the correct bundle."))
// 		return
//
// 	// Parse the uploaded file as JSON.
// 	var/list/bundle
// 	try
// 		bundle = json_decode(file2text(uploaded))
// 	catch(var/exception/err)
// 		to_chat(src, span_warning("Failed to parse the uploaded file as JSON. Make sure you selected the correct file."))
// 		return
//
// 	// Validate that this JSON is actually a save bundle produced by this system.
// 	// Check for all top-level keys that a valid bundle must have.
// 	if(!bundle || !islist(bundle))
// 		to_chat(src, span_warning("Uploaded file is not a valid save bundle."))
// 		return
// 	if(bundle["format_version"] != 1)
// 		to_chat(src, span_warning("Unrecognised bundle format version. This file may be from an incompatible version or is not a save bundle."))
// 		return
// 	if(!bundle["ckey"])
// 		to_chat(src, span_warning("Bundle is missing a ckey field. This does not look like a valid save bundle."))
// 		return
//
// 	var/list/prefs_tree = bundle["preferences"]
// 	if(!prefs_tree || !islist(prefs_tree))
// 		to_chat(src, span_warning("Bundle does not contain a valid preferences block."))
// 		return
//
// 	// Back up and overwrite preferences.json.
// 	var/prefs_path = "[save_dir]/preferences.json"
// 	var/prefs_bak  = "[prefs_path].jsonbak"
// 	if(fexists(prefs_bak))
// 		fdel(prefs_bak)
// 	if(fexists(prefs_path))
// 		fcopy(prefs_path, prefs_bak)
// 	rustg_file_write(json_encode(prefs_tree, JSON_PRETTY_PRINT), prefs_path)
//
// 	// Write vore/ files back out.
// 	var/list/vore_files = bundle["vore"]
// 	if(vore_files && length(vore_files))
// 		var/vore_dir = "[save_dir]/vore/"
// 		for(var/filename in vore_files)
// 			var/file_path = "[vore_dir][filename]"
// 			var/file_bak  = "[file_path].jsonbak"
// 			if(fexists(file_bak))
// 				fdel(file_bak)
// 			if(fexists(file_path))
// 				fcopy(file_path, file_bak)
// 			rustg_file_write(json_encode(vore_files[filename], JSON_PRETTY_PRINT), file_path)
//
// 	log_game("[key_name(src)] imported a save bundle ([length(vore_files)] vore file\s restored).")
// 	log_admin("[key_name(src)] imported a save bundle ([length(vore_files)] vore file\s restored).")
// 	message_admins("[key_name_admin(src)] imported a save bundle ([length(vore_files)] vore file\s restored).")
// 	to_chat(src, span_notice("Save bundle imported. Previous files backed up as .jsonbak."))

// /// Prompts the client to upload a .sav file and saves it into their save directory.
// /// Backs up any existing .sav to .savbak first.
// /// NOTE: uses BYOND's input(src) as file to receive the upload from the client.
// /client/verb/cmd_import_sav()
// 	set name = "Import Legacy Save (.sav)"
// 	set category = "OOC.Client Settings"
// 	set desc = "Upload a legacy .sav save file to restore it server-side."
//
// 	var/save_dir = "data/player_saves/[copytext(ckey, 1, 2)]/[ckey]"
// 	var/sav_path = "[save_dir]/preferences.sav"
// 	var/sav_bak  = "[sav_path].savbak"
//
// 	if(tgui_alert(src, "This will overwrite your current .sav file (a backup will be kept as .savbak). Proceed?", "Import Legacy Save", list("Cancel", "Upload")) != "Upload")
// 		return
//
// 	// Prompt the client to select and upload a .sav file.
// 	var/file/uploaded = input(src, "Select your .sav file to upload.", "Import Legacy Save") as file
// 	if(!uploaded)
// 		return
//
// 	// Sanity check 1: file must have a .sav extension.
// 	if(!findtext("[uploaded]", ".sav"))
// 		to_chat(src, span_warning("That file does not appear to be a .sav file. Make sure you selected the correct file."))
// 		return
//
// 	// Sanity check 2: BYOND savefiles begin with the magic string "BYOND".
// 	// Reading the first 5 bytes lets us reject obviously wrong files before touching anything on disk.
// 	var/header = copytext(file2text(uploaded), 1, 6)
// 	if(header != "BYOND")
// 		to_chat(src, span_warning("That file does not appear to be a valid BYOND save file. Make sure you selected the correct file."))
// 		return
//
// 	if(fexists(sav_bak))
// 		fdel(sav_bak)
// 	if(fexists(sav_path))
// 		fcopy(sav_path, sav_bak)
//
// 	fcopy(uploaded, sav_path)
// 	log_game("[key_name(src)] uploaded a legacy .sav save file.")
// 	to_chat(src, span_notice("Legacy save uploaded. Previous .sav backed up as .savbak."))
