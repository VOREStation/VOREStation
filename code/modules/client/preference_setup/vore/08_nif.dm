//Pretty small file, mostly just for storage.
/datum/preferences
	var/obj/item/device/nif/nif_path
	var/nif_durability
	var/list/nif_savedata

// Definition of the stuff for NIFs
/datum/category_item/player_setup_item/vore/nif
	name = "NIF Data"
	sort_order = 8

/datum/category_item/player_setup_item/vore/nif/load_character(var/savefile/S)
	S["nif_path"]		>> pref.nif_path
	S["nif_durability"]	>> pref.nif_durability
	S["nif_savedata"]	>> pref.nif_savedata

/datum/category_item/player_setup_item/vore/nif/save_character(var/savefile/S)
	S["nif_path"]		<< pref.nif_path
	S["nif_durability"]	<< pref.nif_durability
	S["nif_savedata"]	<< pref.nif_savedata

/datum/category_item/player_setup_item/vore/nif/sanitize_character()
	if(pref.nif_path && !ispath(pref.nif_path))		//We have at least a text string that should be a path.
		pref.nif_path = text2path(pref.nif_path) 	//Try to convert it to a hard path.
		if(!pref.nif_path)							//If we couldn't, kill it.
			pref.nif_path = null					//Kill!
			WARNING("Loaded a NIF but it was an invalid path, [pref.real_name]")

	if(ispath(pref.nif_path) && isnull(pref.nif_durability))		//How'd you lose this?
		pref.nif_durability = initial(pref.nif_path.durability)		//Well, have a new one, my bad.
		WARNING("Loaded a NIF but with no durability, [pref.real_name]")

	if(!islist(pref.nif_savedata))
		pref.nif_savedata = list()

/datum/category_item/player_setup_item/vore/nif/copy_to_mob(var/mob/living/carbon/human/character)
	//If you had a NIF...
	if((character.type == /mob/living/carbon/human && !(character.mind.assigned_role == "Cyborg" || character.mind.assigned_role == "AI")) && ispath(pref.nif_path) && pref.nif_durability)
		new pref.nif_path(character,pref.nif_durability,pref.nif_savedata)

		/*
		//And now here's the trick. We wipe these so that if they die, they lose the NIF.
		//Backup implants will start saving this again periodically, and so will cryo'ing out.
		pref.nif_path = null
		pref.nif_durability = null
		pref.nif_savedata = null
		*/
		//No we do not, that's lame and admins have to re-NIF them later.
		//If they leave round after they get their NIF extracted, it will save as 'gone' anyway
		//The NIF will save automatically every time durability changes too now.
		var/savefile/S = new /savefile(pref.path)
		if(!S) WARNING ("Couldn't load NIF save savefile? [pref.real_name]")
		S.cd = "/character[pref.default_slot]"
		save_character(S)

/datum/category_item/player_setup_item/vore/nif/content(var/mob/user)
	. += "<b>NIF:</b> [ispath(pref.nif_path) ? "Present" : "None"]"
