/datum/asset/spritesheet/vore
	name = "vore"

/datum/asset/spritesheet/vore/create_spritesheets()
	var/icon/downscaled = icon('icons/mob/screen_full_vore.dmi')
	downscaled.Scale(240, 240)
	InsertAll("", downscaled)

/datum/asset/spritesheet/vore_colorized //This should be getting loaded in the TGUI vore panel but the game refuses to do so, for some reason. It only loads the vore spritesheet.
	name = "colorizedvore"

/datum/asset/spritesheet/vore_colorized/create_spritesheets()
	var/icon/downscaledVC = icon('icons/mob/screen_full_colorized_vore.dmi')
	downscaledVC.Scale(240, 240)
	InsertAll("", downscaledVC)
