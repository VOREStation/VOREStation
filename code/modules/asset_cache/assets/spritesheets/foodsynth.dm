//Let's be optimal with our menu preview icons, shall we?
/datum/asset/spritesheet_batched/synthesizer
	name = "synthesizer"

/datum/asset/spritesheet_batched/synthesizer/create_spritesheets()
	for(var/datum/category_item/synthesizer/path as anything in subtypesof(/datum/category_item/synthesizer))
		var/datum/universal_icon/icon = get_display_icon_for(path::build_path)

		if(!icon || !icon.icon_file)
			continue

		icon.scale(128, 128) //enbiggen for the menu UI

		var/key = sanitize_css_class_name("[path::type]")
		insert_icon(key, icon)
