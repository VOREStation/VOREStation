/obj/machinery/appliance/mixer/candy
	name = "candy machine"
	desc = "Get yer candied cheese wheels here!"
	icon_state = "mixer_off"
	off_icon = "mixer_off"
	on_icon = "mixer_on"
	cook_type = "candied"
	appliancetype = CANDYMAKER
	var/datum/looping_sound/candymaker/candymaker_loop
	circuit = /obj/item/circuitboard/candymachine
	cooking_coeff = 1.0 // Original Value 0.6

	output_options = list(
		"Jawbreaker" = /obj/item/food/variable/jawbreaker,
		"Candy Bar" = /obj/item/food/variable/candybar,
		"Sucker" = /obj/item/food/variable/sucker,
		"Jelly" = /obj/item/food/variable/jelly
		)

/obj/machinery/appliance/mixer/candy/Initialize(mapload)
	. = ..()

	candymaker_loop = new(list(src), FALSE)

/obj/machinery/appliance/mixer/candy/Destroy()
	. = ..()

	QDEL_NULL(candymaker_loop)

/obj/machinery/appliance/mixer/candy/update_icon()
	. = ..()

	if(!stat)
		icon_state = on_icon
		if(candymaker_loop)
			candymaker_loop.start(src)
	else
		icon_state = off_icon
		if(candymaker_loop)
			candymaker_loop.stop(src)

/obj/machinery/appliance/mixer/candy/change_product_appearance(var/obj/item/food/product)
	food_color = get_random_colour(1)
	. = ..()
