/datum/asset/spritesheet_batched/sheetmaterials
	name = "sheetmaterials_batched"

/datum/asset/spritesheet_batched/sheetmaterials/create_spritesheets()
	for(var/obj/item/stack/material/M as anything in subtypesof(/obj/item/stack/material))
		if(M::default_type in entries)
			continue

		if(!M::icon_state)
			continue

		var/append = "_3"
		if(M::no_variants)
			append = ""
		// rods inexplicably have a different format than everything else
		if(M::icon_state == "rods")
			append = "-3"

		var/datum/universal_icon/UI = uni_icon(M::icon, "[M::icon_state][append]")
		if(M.apply_colour)
			var/datum/material/material = GET_MATERIAL_REF(M::default_type)
			UI.blend_color(material.icon_colour, ICON_MULTIPLY)

		insert_icon(M::default_type, UI)
