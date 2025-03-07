

/obj/item/reagent_containers/food/drinks/drinkingglass
	name = "glass"
	desc = "Your standard drinking glass."
	icon_state = "glass_empty"
	amount_per_transfer_from_this = 5
	volume = 30
	unacidable = TRUE //glass
	center_of_mass_x = 16
	center_of_mass_y = 10
	matter = list(MAT_GLASS = 500)

/obj/item/reagent_containers/food/drinks/drinkingglass/on_reagent_change()
	if (!length(reagents?.reagent_list))
		icon_state = "glass_empty"
		name = "glass"
		desc = "Your standard drinking glass."
		center_of_mass_x = 16
		center_of_mass_y = 10
		return
	var/datum/reagent/R = reagents.get_master_reagent()

	if(R.glass_icon_state)
		icon_state = R.glass_icon_state
	else
		icon_state = "glass_brown"

	if(R.glass_name)
		name = R.glass_name
	else
		name = "Glass of.. what?"

	if(R.glass_desc)
		desc = R.glass_desc
	else
		desc = "You can't really tell what this is."

	if(R.glass_center_of_mass_x || R.glass_center_of_mass_y)
		center_of_mass_x = R.cup_center_of_mass_x
		center_of_mass_y = R.cup_center_of_mass_y
	else
		center_of_mass_x = 16
		center_of_mass_y = 10

	if(R.price_tag)
		price_tag = R.price_tag
	else
		price_tag = null

/obj/item/reagent_containers/food/drinks/cup
	name = "coffee cup"
	desc = "The container of oriental luxuries."
	icon_state = "cup_empty"
	amount_per_transfer_from_this = 5
	volume = 30
	center_of_mass_x = 16
	center_of_mass_y = 16

/obj/item/reagent_containers/food/drinks/cup/on_reagent_change()
	if (!length(reagents?.reagent_list))
		icon_state = "cup_empty"
		name = "coffee cup"
		desc = "The container of oriental luxuries."
		center_of_mass_x = 16
		center_of_mass_y = 16
		return
	var/datum/reagent/R = reagents.get_master_reagent()

	if(R.cup_icon_state)
		icon_state = R.cup_icon_state
	else
		icon_state = "cup_brown"

	if(R.cup_name)
		var/prefix = " "
		for(var/datum/reagent/S in reagents.reagent_list)
			if(S.cup_prefix)
				var/current_prefix = prefix
				prefix = "[current_prefix][S.cup_prefix] "
		name = "cup of[prefix][R.cup_name]"
	else
		name = "Cup of.. what?"

	if(R.cup_desc)
		desc = R.cup_desc
	else
		desc = "You can't really tell what this is."

	if(R.cup_center_of_mass_x || R.cup_center_of_mass_y)
		center_of_mass_x = R.cup_center_of_mass_x
		center_of_mass_y = R.cup_center_of_mass_y
	else
		center_of_mass_x = 16
		center_of_mass_y = 16

	if(R.price_tag)
		price_tag = R.price_tag
	else
		price_tag = null

// for /obj/machinery/vending/sovietsoda
/obj/item/reagent_containers/food/drinks/drinkingglass/soda/New()
	..()
	reagents.add_reagent(REAGENT_ID_SODAWATER, 50)

/obj/item/reagent_containers/food/drinks/drinkingglass/cola/New()
	..()
	reagents.add_reagent(REAGENT_ID_COLA, 50)

/obj/item/reagent_containers/food/drinks/drinkingglass/shotglass
	name = "shot glass"
	desc = "No glasses were shot in the making of this glass."
	icon_state = "shotglass"
	amount_per_transfer_from_this = 10
	volume = 10
	matter = list(MAT_GLASS = 175)

/obj/item/reagent_containers/food/drinks/drinkingglass/shotglass/on_reagent_change()
	cut_overlays()
	name = "shot glass"

	if(!reagents.total_volume)
		return
	var/image/filling = image('icons/obj/reagentfillings.dmi', src, "[icon_state]1")

	switch(reagents.total_volume)
		if(0 to 3)			filling.icon_state = "[icon_state]1"
		if(4 to 7) 			filling.icon_state = "[icon_state]5"
		if(8 to INFINITY)	filling.icon_state = "[icon_state]12"

	filling.color += reagents.get_color()
	add_overlay(filling)
	name += " of [reagents.get_master_reagent_name()]" //No matter what, the glass will tell you the reagent's name. Might be too abusable in the future.

/obj/item/reagent_containers/food/drinks/drinkingglass/fitnessflask
	name = "fitness shaker"
	desc = "Big enough to contain enough protein to get perfectly swole. Don't mind the bits."
	icon_state = "fitness-cup_black"
	volume = 100
	matter = list(MAT_PLASTIC = 2000)

/obj/item/reagent_containers/food/drinks/drinkingglass/fitnessflask/Initialize(mapload)
	. = ..()
	icon_state = pick("fitness-cup_black", "fitness-cup_red", "fitness-cup_black")

/obj/item/reagent_containers/food/drinks/drinkingglass/fitnessflask/on_reagent_change()
	cut_overlays()

	if(reagents.total_volume)
		var/image/filling = image('icons/obj/reagentfillings.dmi', src, "fitness-cup10")

		switch(reagents.total_volume)
			if(0 to 10)			filling.icon_state = "fitness-cup10"
			if(11 to 20)		filling.icon_state = "fitness-cup20"
			if(21 to 29)		filling.icon_state = "fitness-cup30"
			if(30 to 39)		filling.icon_state = "fitness-cup40"
			if(40 to 49)		filling.icon_state = "fitness-cup50"
			if(50 to 59)		filling.icon_state = "fitness-cup60"
			if(60 to 69)		filling.icon_state = "fitness-cup70"
			if(70 to 79)		filling.icon_state = "fitness-cup80"
			if(80 to 89)		filling.icon_state = "fitness-cup90"
			if(90 to INFINITY)	filling.icon_state = "fitness-cup100"

		filling.color += reagents.get_color()
		add_overlay(filling)

/obj/item/reagent_containers/food/drinks/drinkingglass/fitnessflask/proteinshake
	name = "protein shake"

/obj/item/reagent_containers/food/drinks/drinkingglass/fitnessflask/proteinshake/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_NUTRIMENT, 30)
	reagents.add_reagent(REAGENT_ID_IRON, 10)
	reagents.add_reagent(REAGENT_ID_PROTEIN, 15)
	reagents.add_reagent(REAGENT_ID_WATER, 45)


////////////////Fancy coffee cups

/obj/item/reagent_containers/food/drinks/tall
	name = "tall cup"
	desc = "A larger coffee cup."
	icon_state = "tall_cup_empty"
	amount_per_transfer_from_this = 5
	volume = 40
	center_of_mass_x = 16
	center_of_mass_y =  16

/obj/item/reagent_containers/food/drinks/tall/on_reagent_change()
	if (!length(reagents?.reagent_list))
		icon_state = "tall_cup_empty"
		name = "tall cup"
		desc = "A larger coffee cup."
		center_of_mass_x = 16
		center_of_mass_y =  16
		return
	var/datum/reagent/R = reagents.get_master_reagent()

	if(R.cup_icon_state)
		icon_state = "tall_[R.cup_icon_state]"
	else
		icon_state = "tall_cup_brown"

	if(R.cup_name)
		var/prefix = " "
		for(var/datum/reagent/S in reagents.reagent_list)
			if(S.cup_prefix)
				var/current_prefix = prefix
				prefix = "[current_prefix][S.cup_prefix] "
		name = "tall[prefix][R.cup_name]"
	else
		name = "tall.. what?"

	if(R.cup_desc)
		desc = R.cup_desc
	else
		desc = "You can't really tell what this is."

	if(R.cup_center_of_mass_x || R.cup_center_of_mass_y)
		center_of_mass_x = R.cup_center_of_mass_x
		center_of_mass_y = R.cup_center_of_mass_y
	else
		center_of_mass_x = 16
		center_of_mass_y =  16

	if(R.price_tag)
		price_tag = R.price_tag
	else
		price_tag = null

/obj/item/reagent_containers/food/drinks/grande
	name = "grande cup"
	desc = "A much taller coffee cup for people who really need their coffee."
	icon_state = "grande_cup_empty"
	amount_per_transfer_from_this = 5
	volume = 50
	center_of_mass_x = 16
	center_of_mass_y =  16

/obj/item/reagent_containers/food/drinks/grande/on_reagent_change()
	if (!length(reagents?.reagent_list))
		icon_state = "grande_cup_empty"
		name = "grande cup"
		desc = "A much taller coffee cup for people who really need their coffee."
		center_of_mass_x = 16
		center_of_mass_y =  16
		return
	var/datum/reagent/R = reagents.get_master_reagent()

	if(R.cup_icon_state)
		icon_state = "grande_[R.cup_icon_state]"
	else
		icon_state = "grande_cup_brown"

	if(R.cup_name)
		var/prefix = " "
		for(var/datum/reagent/S in reagents.reagent_list)
			if(S.cup_prefix)
				var/current_prefix = prefix
				prefix = "[current_prefix][S.cup_prefix] "
		name = "grande[prefix][R.cup_name]"
	else
		name = "grande.. what?"

	if(R.cup_desc)
		desc = R.cup_desc
	else
		desc = "You can't really tell what this is."

	if(R.cup_center_of_mass_x || R.cup_center_of_mass_y)
		center_of_mass_x = R.cup_center_of_mass_x
		center_of_mass_y = R.cup_center_of_mass_y
	else
		center_of_mass_x = 16
		center_of_mass_y =  16

	if(R.price_tag)
		price_tag = R.price_tag
	else
		price_tag = null

/obj/item/reagent_containers/food/drinks/venti
	name = "venti cup"
	desc = "A huge coffee cup for people who literally cannot function without it."
	icon_state = "venti_cup_empty"
	amount_per_transfer_from_this = 5
	volume = 60
	center_of_mass_x = 16
	center_of_mass_y =  16

/obj/item/reagent_containers/food/drinks/venti/on_reagent_change()
	if (!length(reagents?.reagent_list))
		icon_state = "venti_cup_empty"
		name = "venti cup"
		desc = "A huge coffee cup for people who literally cannot function without it."
		center_of_mass_x = 16
		center_of_mass_y =  16
		return
	var/datum/reagent/R = reagents.get_master_reagent()

	if(R.cup_icon_state)
		icon_state = "venti_[R.cup_icon_state]"
	else
		icon_state = "venti_cup_brown"

	if(R.cup_name)
		var/prefix = " "
		for(var/datum/reagent/S in reagents.reagent_list)
			if(S.cup_prefix)
				var/current_prefix = prefix
				prefix = "[current_prefix][S.cup_prefix] "
		name = "venti[prefix][R.cup_name]"
	else
		name = "venti.. what?"

	if(R.cup_desc)
		desc = R.cup_desc
	else
		desc = "You can't really tell what this is."

	if(R.cup_center_of_mass_x || R.cup_center_of_mass_y)
		center_of_mass_x = R.cup_center_of_mass_x
		center_of_mass_y = R.cup_center_of_mass_y
	else
		center_of_mass_x = 16
		center_of_mass_y =  16

	if(R.price_tag)
		price_tag = R.price_tag
	else
		price_tag = null
