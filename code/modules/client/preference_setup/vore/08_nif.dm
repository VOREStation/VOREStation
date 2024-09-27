//Pretty small file, mostly just for storage.
/datum/preferences
	var/obj/item/device/nif/nif_path
	var/nif_durability
	var/list/nif_savedata

// Definition of the stuff for NIFs
// Magic bullshit, they're stored separately from everything else
/datum/category_item/player_setup_item/vore/nif
	name = "NIF Data"
	sort_order = 8

/proc/nif_savefile_path(ckey)
	if(!ckey)
		return
	return "data/player_saves/[copytext(ckey,1,2)]/[ckey]/nif.json"

/datum/category_item/player_setup_item/vore/nif/load_character()
	var/datum/json_savefile/savefile = new /datum/json_savefile(nif_savefile_path(pref.client_ckey))
	var/list/save_data_file = savefile.get_entry("character[pref.default_slot]", list())

	pref.nif_path		= save_data_file["nif_path"]
	pref.nif_durability	= save_data_file["nif_durability"]
	pref.nif_savedata	= check_list_copy(save_data_file["nif_savedata"])

/datum/category_item/player_setup_item/vore/nif/save_character()
	var/datum/json_savefile/savefile = new /datum/json_savefile(nif_savefile_path(pref.client_ckey))
	var/list/save_data_file = savefile.get_entry("character[pref.default_slot]", list())

	save_data_file["nif_path"]			= pref.nif_path
	save_data_file["nif_durability"]	= pref.nif_durability
	save_data_file["nif_savedata"]		= check_list_copy(pref.nif_savedata)

	savefile.set_entry("character[pref.default_slot]", save_data_file)
	savefile.save()

/datum/category_item/player_setup_item/vore/nif/sanitize_character()
	if(pref.nif_path && !ispath(pref.nif_path))		//We have at least a text string that should be a path.
		pref.nif_path = text2path(pref.nif_path) 	//Try to convert it to a hard path.
		if(!pref.nif_path)							//If we couldn't, kill it.
			pref.nif_path = null					//Kill!
			WARNING("Loaded a NIF but it was an invalid path, [pref.real_name]")

	if (ispath(pref.nif_path, /obj/item/device/nif/protean) && pref.species != SPECIES_PROTEAN) //no free nifs
		pref.nif_path = null

	if(ispath(pref.nif_path) && isnull(pref.nif_durability))		//How'd you lose this?
		pref.nif_durability = initial(pref.nif_path.durability)		//Well, have a new one, my bad.
		WARNING("Loaded a NIF but with no durability, [pref.real_name]")

	if(!islist(pref.nif_savedata))
		pref.nif_savedata = list()

/datum/category_item/player_setup_item/vore/nif/copy_to_mob(var/mob/living/carbon/human/character)
	//If you had a NIF...
	if(istype(character) && ispath(pref.nif_path) && pref.nif_durability)
		new pref.nif_path(character, pref.nif_durability, pref.nif_savedata)

/datum/category_item/player_setup_item/vore/nif/content(var/mob/user)
	. += "<b>NIF:</b> [ispath(pref.nif_path) ? "Present" : "None"]"
