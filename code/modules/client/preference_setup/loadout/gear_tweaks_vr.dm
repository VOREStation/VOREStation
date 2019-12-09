/datum/gear_tweak/collar_tag/get_contents(var/metadata)
	return "Tag: [metadata]"

/datum/gear_tweak/collar_tag/get_default()
	return ""

/datum/gear_tweak/collar_tag/get_metadata(var/user, var/metadata)
	return sanitize( input(user, "Choose the tag text", "Character Preference", metadata) as text , MAX_NAME_LEN )

/datum/gear_tweak/collar_tag/tweak_item(var/obj/item/clothing/accessory/collar/C, var/metadata)
	if(metadata == "")
		return ..()
	else
		C.initialize_tag(metadata)