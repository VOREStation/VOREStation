/obj/structure/event_collector/nukies
	name = "Experimental Nukies Mixer"
	desc = "A machine rigged together from various bits and pieces, designed to mix some reagents into new Nukies."
	icon = 'icons/obj/cooking_event.dmi'
	icon_state = "equipment_empty"

	possible_ingredients = list(
		/obj/item/collector_item/nukies_acid,
		/obj/item/collector_item/nukies_formula,
		/obj/item/collector_item/nukies_sludge
	)

	no_dupes_in_recipe = TRUE
	automatic_recipe_restart = FALSE
	step_in_examine = FALSE
	wait_between_items = 1 MINUTE
	need_recipe_in_order = TRUE

	type_to_spawn_on_complete = /obj/item/reagent_containers/food/drinks/cans/nukie_one

/obj/structure/event_collector/update_icon()
	. = ..()
	if(!current_step)
		icon_state = "equipment_empty"
	else if(current_step <= 3)
		icon_state = "equipment_[current_step]"


//simple obj defs here. overwrite or change as requested.

/obj/item/collector_item
	icon = 'icons/obj/cooking_event.dmi'
	icon_state = "acid"
	name = "Mewriatic Acid"
	desc = "Not a typo or label misprint. There's an entire dissolved cat in here. Says so right on the ingredients label."

/obj/item/collector_item/nukies_acid

/obj/item/collector_item/nukies_formula
	icon_state = "formula"
	name = "Nukies Secret Formula"
	desc = "A disgustingly thick bottle of... something. It smells bad, in a good way."

/obj/item/collector_item/nukies_sludge
	icon_state = "sludge"
	name = "Sludge"
	desc = "Eughghhgh. gross. Smells like gasoline and gamers."
