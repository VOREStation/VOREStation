/datum/asset/spritesheet/kitchen_recipes
	name = "kitchen_recipes"

/datum/asset/spritesheet/kitchen_recipes/create_spritesheets()
	for(var/datum/recipe/R as anything in subtypesof(/datum/recipe))
		add_atom_icon(R.result, sanitize_css_class_name("[R.type]"))

/datum/asset/spritesheet/kitchen_recipes/proc/add_atom_icon(typepath, id)
	var/icon_file
	var/icon_state
	var/obj/preview_item = typepath

	// if(ispath(ingredient_typepath, /datum/reagent))
	// 	var/datum/reagent/reagent = ingredient_typepath
	// 	preview_item = initial(reagent.default_container)
	// 	var/datum/glass_style/style = GLOB.glass_style_singletons[preview_item]?[reagent]
	// 	if(istype(style))
	// 		icon_file = style.icon
	// 		icon_state = style.icon_state

	// icon_file ||= initial(preview_item.icon_preview) || initial(preview_item.icon)
	// icon_state ||= initial(preview_item.icon_state_preview) || initial(preview_item.icon_state)
	icon_file = initial(preview_item.icon)
	icon_state = initial(preview_item.icon_state)

	Insert("[id]", icon_file, icon_state)
