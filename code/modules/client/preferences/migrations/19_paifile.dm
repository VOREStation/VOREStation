/// Moves pai save file to tg pref in current file slot
/datum/preferences/proc/migration_19_paifile(datum/json_savefile/S)
	//Not everyone has a pai savefile.
	var/pai_path = "data/player_saves/[copytext(client_ckey, 1, 2)]/[client_ckey]/pai.sav"
	if(!fexists(pai_path))
		return
	var/savefile/F = new /savefile(pai_path)
	if(!F)
		return

	// Should never happen, but if someone has a wonked out file then lets avoid it too
	var/version = null
	F["version"] >> version
	if(isnull(version) || version != 1)
		fdel(pai_path)
		return

	// Put the pai in slot 0
	var/list/prefs = S.get_entry("character1", null)
	if(!islist(prefs))
		return

	// Get data
	var/pai_name
	var/pai_description
	var/pai_role
	var/pai_comments
	var/pai_eye_color
	var/pai_chassis
	var/pai_ouremotion
	F["name"] >> pai_name
	F["description"] >> pai_description
	F["role"] >> pai_role
	F["comments"] >> pai_comments
	F["eyecolor"] >> pai_eye_color
	F["chassis"] >> pai_chassis
	F["emotion"] >> pai_ouremotion
	// F["gender"] >> pai_gender // We use the character slot's now

	if(pai_name)
		prefs["Pai_Name"] = pai_name
	if(pai_role)
		prefs["Pai_Role"] = pai_role
	if(pai_description)
		prefs["Pai_Desc"] = pai_description
	if(pai_comments)
		prefs["Pai_Comments"] = pai_comments
	if(pai_eye_color)
		prefs["Pai_EyeColor"] = pai_eye_color
	if(pai_chassis)
		prefs["Pai_Chassis"] = pai_chassis
	if(pai_ouremotion)
		prefs["Pai_Emotion"] = pai_ouremotion

	fdel(pai_path)

	S.save()
