/obj/item/reagent_containers/food/drinks/glass2/fitnessflask/proteanshake
	name = "protean shake"

/obj/item/reagent_containers/food/drinks/glass2/fitnessflask/proteanshake/Initialize()
	. = ..()
	reagents.add_reagent("liquid_protean", 50)
	reagents.add_reagent("nutriment", 50)

/obj/item/reagent_containers/food/drinks/glass2/fitnessflask/proteanshake/update_icon()
	..()
	// And now set half the stuff back because our name shouldn't change
	name = initial(name)
	desc = initial(desc)
