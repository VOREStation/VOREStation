/datum/persistent/paintings
	name = "paintings"
	entries_expire_at = 1000 // Basically forever

/datum/persistent/paintings/SetFilename()
    filename = "data/persistent/paintings.json"

/datum/persistent/paintings/Initialize()
	. = ..()
	if(fexists(filename))
		SSpersistence.paintings = json_decode(file2text(filename))
		var/list/tokens = SSpersistence.paintings
		for(var/list/token in tokens)
			token["age"]++ // Increment age!
			if(!CheckTokenSanity(token))
				tokens -= token

	for(var/obj/structure/sign/painting/P in SSpersistence.painting_frames)
		P.load_persistent()
	return

/datum/persistent/paintings/CheckTokenSanity(var/list/token)
	var/png_filename = "data/paintings/[token["persistence_id"]]/[token["md5"]].png"
	if(!fexists(png_filename))
		return FALSE
	if(token["age"] > entries_expire_at)
		fdel(png_filename)
		return FALSE

/datum/persistent/paintings/Shutdown()
	for(var/obj/structure/sign/painting/P in SSpersistence.painting_frames)
		P.save_persistent()

	if(fexists(filename))
		fdel(filename)
	to_file(file(filename), json_encode(SSpersistence.paintings))
