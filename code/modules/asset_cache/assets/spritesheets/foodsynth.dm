//Let's be optimal with our menu preview icons, shall we?
/datum/asset/spritesheet_batched/synthesizer
	name = "synthesizer"

/datum/asset/spritesheet_batched/synthesizer/create_spritesheets()
	for (var/datum/category_item/synthesizer/path as anything in subtypesof(/datum/category_item/synthesizer))
		var/icon_file
		var/icon_state
		var/icon/I
		var/atom/item = initial(path.build_path)
		icon_file = initial(item.icon)
		icon_state = initial(item.icon_state)
		I = icon(icon_file, icon_state, SOUTH)
		I.Scale(128, 128) //enbiggen for the menu UI
		insert_icon(initial(path.id), I)
	..()
