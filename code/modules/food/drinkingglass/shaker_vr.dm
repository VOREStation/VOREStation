/obj/item/weapon/reagent_containers/food/drinks/glass2/fitnessflask/proteanshake
	name = "protean shake"
	icon = 'icons/obj/drinks.dmi'
	icon_state = "protean_shake"
	base_icon = "protean_shake"
	desc = "A strangely unlabeled, unbranded pre-workout drink carton."

/obj/item/weapon/reagent_containers/food/drinks/glass2/fitnessflask/proteanshake/Initialize()
	. = ..()
	cut_overlays()
	reagents.add_reagent("liquid_protean", 50)
	reagents.add_reagent("nutriment", 50)

/obj/item/weapon/reagent_containers/food/drinks/glass2/fitnessflask/proteanshake/update_icon()
	return