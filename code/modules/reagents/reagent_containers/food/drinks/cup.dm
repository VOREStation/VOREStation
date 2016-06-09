/obj/item/weapon/reagent_containers/food/drinks/cup
	name = "coffee cup"
	desc = "The container of oriental luxuries."
	icon_state = "cup_empty"
	amount_per_transfer_from_this = 5
	volume = 30
	center_of_mass = list("x"=16, "y"=16)

/obj/item/weapon/reagent_containers/food/drinks/cup/on_reagent_change()
	..()
	if (reagents.reagent_list.len > 0)
		var/datum/reagent/R = reagents.get_master_reagent()

		if(R.cup_icon_state)
			icon_state = R.cup_icon_state
		else
			icon_state = "cup_brown"

		if(R.cup_name)
			name = R.cup_name
		else
			name = "Cup of.. what?"

		if(R.cup_desc)
			desc = R.cup_desc
		else
			desc = "You can't really tell what this is."

		if(R.cup_center_of_mass)
			center_of_mass = R.cup_center_of_mass
		else
			center_of_mass = list("x"=16, "y"=16)

	else
		icon_state = "cup_empty"
		name = "coffee cup"
		desc = "The container of oriental luxuries."
		center_of_mass = list("x"=16, "y"=16)
		return
