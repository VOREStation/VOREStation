GLOBAL_VAR(create_mob_html)
/datum/admins/proc/create_mob(var/mob/user)
	if (!GLOB.create_mob_html)
		var/mobjs = null
		mobjs = jointext(typesof(/mob), ";")
		GLOB.create_mob_html = file2text('html/create_object.html')
		GLOB.create_mob_html = replacetext(GLOB.create_mob_html, "null /* object types */", "\"[mobjs]\"")

	user << browse(create_panel_helper(GLOB.create_mob_html), "window=create_mob;size=680x600")
