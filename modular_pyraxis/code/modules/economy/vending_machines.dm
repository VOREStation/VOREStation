/obj/machinery/vending/random
	name = "Old-Looking Soda Machine"
	desc = "A pretty beaten up soda machine. How did this get here?"
	icon_state = "sovietsoda"

/obj/machinery/vending/random/Initialize(mapload)
	generate_stock()
	. = ..()

/obj/machinery/vending/random/proc/generate_stock()
	for(var/i in 1 to rand(5, 10))
		var/obj/item/reagent_containers/food/drinks/cans/can = pick(subtypesof(/obj/item/reagent_containers/food/drinks/cans))
		stock_random_machine(can)

/obj/machinery/vending/random/proc/stock_random_machine(obj/item/can as obj)
	var/datum/stored_item/vending_product/product = new /datum/stored_item/vending_product(src, can.type, can.name, price = rand(1, 5))
	product_records.Add(product)
	product.add_product(can)
