/obj/machinery/appliance/mixer/cereal
	name = "cereal maker"
	desc = "Now with Dann O's available!"
	icon = 'icons/obj/cooking_machines.dmi'
	icon_state = "cereal_off"
	cook_type = "cerealized"
	on_icon = "cereal_on"
	off_icon = "cereal_off"
	appliancetype = CEREALMAKER
	var/datum/looping_sound/cerealmaker/cerealmaker_loop
	circuit = /obj/item/weapon/circuitboard/cerealmaker

	output_options = list(
		"Cereal" = /obj/item/weapon/reagent_containers/food/snacks/variable/cereal
	)

/obj/machinery/appliance/mixer/cereal/Initialize()
	. = ..()
	
	cerealmaker_loop = new(list(src), FALSE)
	
/obj/machinery/appliance/mixer/cereal/Destroy()
	. = ..()
	
	QDEL_NULL(cerealmaker_loop)

/*
/obj/machinery/appliance/mixer/cereal/change_product_strings(var/obj/item/weapon/reagent_containers/food/snacks/product, var/datum/cooking_item/CI)
	. = ..()
	product.name = "box of [CI.object.name] cereal"

/obj/machinery/appliance/mixer/cereal/change_product_appearance(var/obj/item/weapon/reagent_containers/food/snacks/product)
	product.icon = 'icons/obj/food.dmi'
	product.icon_state = "cereal_box"
	product.filling_color = CI.object.color

	var/image/food_image = image(CI.object.icon, CI.object.icon_state)
	food_image.color = CI.object.color
	food_image.add_overlay(CI.object.overlays)
	food_image.transform *= 0.7

	product.add_overlay(food_image)
*/

/obj/machinery/appliance/mixer/cereal/update_icon()
	. = ..()

	if(!stat)
		icon_state = on_icon
		if(cerealmaker_loop)
			cerealmaker_loop.start(src)
	else
		icon_state = off_icon
		if(cerealmaker_loop)
			cerealmaker_loop.stop(src)

/obj/machinery/appliance/mixer/cereal/combination_cook(var/datum/cooking_item/CI)

	var/list/images = list()
	var/num = 0
	for(var/obj/item/I in CI.container)
		if (istype(I, /obj/item/weapon/reagent_containers/food/snacks/variable/cereal))
			//Images of cereal boxes on cereal boxes is dumb
			continue

		var/image/food_image = image(I.icon, I.icon_state)
		food_image.color = I.color
		food_image.add_overlay(I.overlays)
		food_image.transform *= 0.7 - (num * 0.05)
		food_image.pixel_x = rand(-2,2)
		food_image.pixel_y = rand(-3,5)


		if (!images[I.icon_state])
			images[I.icon_state] = food_image
			num++

		if (num > 3)
			continue


	var/obj/item/weapon/reagent_containers/food/snacks/result = ..()

	result.color = result.filling_color
	for (var/i in images)
		result.add_overlay(images[i])
