/*
 * Donut Box
 */

var/list/random_weighted_donuts = list(
	/obj/item/reagent_containers/food/snacks/donut/plain = 5,
	/obj/item/reagent_containers/food/snacks/donut/plain/jelly = 5,
	/obj/item/reagent_containers/food/snacks/donut/pink = 4,
	/obj/item/reagent_containers/food/snacks/donut/pink/jelly = 4,
	/obj/item/reagent_containers/food/snacks/donut/purple = 4,
	/obj/item/reagent_containers/food/snacks/donut/purple/jelly = 4,
	/obj/item/reagent_containers/food/snacks/donut/green = 4,
	/obj/item/reagent_containers/food/snacks/donut/green/jelly = 4,
	/obj/item/reagent_containers/food/snacks/donut/beige = 4,
	/obj/item/reagent_containers/food/snacks/donut/beige/jelly = 4,
	/obj/item/reagent_containers/food/snacks/donut/choc = 4,
	/obj/item/reagent_containers/food/snacks/donut/choc/jelly = 4,
	/obj/item/reagent_containers/food/snacks/donut/blue = 4,
	/obj/item/reagent_containers/food/snacks/donut/blue/jelly = 4,
	/obj/item/reagent_containers/food/snacks/donut/yellow = 4,
	/obj/item/reagent_containers/food/snacks/donut/yellow/jelly = 4,
	/obj/item/reagent_containers/food/snacks/donut/olive = 4,
	/obj/item/reagent_containers/food/snacks/donut/olive/jelly = 4,
	/obj/item/reagent_containers/food/snacks/donut/homer = 3,
	/obj/item/reagent_containers/food/snacks/donut/homer/jelly = 3,
	/obj/item/reagent_containers/food/snacks/donut/choc_sprinkles = 3,
	/obj/item/reagent_containers/food/snacks/donut/choc_sprinkles/jelly = 3,
	/obj/item/reagent_containers/food/snacks/donut/chaos = 1
)

/obj/item/storage/box/donut
	icon = 'icons/obj/food_donuts.dmi'
	icon_state = "donutbox"
	name = "donut box"
	desc = "A box that holds tasty donuts, if you're lucky."
	center_of_mass_x = 16
	center_of_mass_y = 9
	max_storage_space = ITEMSIZE_COST_SMALL * 6
	can_hold = list(/obj/item/reagent_containers/food/snacks/donut)
	foldable = /obj/item/stack/material/cardboard
	//starts_with = list(/obj/item/reagent_containers/food/snacks/donut/normal = 6)

/obj/item/storage/box/donut/Initialize()
	if(!empty)
		for(var/i in 1 to 6)
			var/type_to_spawn = pickweight(random_weighted_donuts)
			new type_to_spawn(src)
	. = ..()
	update_icon()

/obj/item/storage/box/donut/update_icon()
	cut_overlays()
	var/x_offset = 0
	for(var/obj/item/reagent_containers/food/snacks/donut/D in contents)
		var/mutable_appearance/ma = mutable_appearance(icon = icon, icon_state = D.overlay_state)
		ma.pixel_x = x_offset
		add_overlay(ma)
		x_offset += 3

/obj/item/storage/box/donut/empty
	empty = TRUE

/obj/item/storage/box/wormcan
	icon = 'icons/obj/food.dmi'
	icon_state = "wormcan"
	name = "can of worms"
	desc = "You probably do want to open this can of worms."
	max_storage_space = ITEMSIZE_COST_TINY * 6
	can_hold = list(
		/obj/item/reagent_containers/food/snacks/wormsickly,
		/obj/item/reagent_containers/food/snacks/worm,
		/obj/item/reagent_containers/food/snacks/wormdeluxe
	)
	starts_with = list(/obj/item/reagent_containers/food/snacks/worm = 6)

/obj/item/storage/box/wormcan/Initialize()
	. = ..()
	update_icon()

/obj/item/storage/box/wormcan/update_icon(var/itemremoved = 0)
	if (contents.len == 0)
		icon_state = "wormcan_empty"

/obj/item/storage/box/wormcan/sickly
	icon_state = "wormcan_sickly"
	name = "can of sickly worms"
	desc = "You probably don't want to open this can of worms."
	max_storage_space = ITEMSIZE_COST_TINY * 6
	starts_with = list(/obj/item/reagent_containers/food/snacks/wormsickly = 6)

/obj/item/storage/box/wormcan/sickly/update_icon(var/itemremoved = 0)
	if (contents.len == 0)
		icon_state = "wormcan_empty_sickly"

/obj/item/storage/box/wormcan/deluxe
	icon_state = "wormcan_deluxe"
	name = "can of deluxe worms"
	desc = "You absolutely want to open this can of worms."
	max_storage_space = ITEMSIZE_COST_TINY * 6
	starts_with = list(/obj/item/reagent_containers/food/snacks/wormdeluxe = 6)

/obj/item/storage/box/wormcan/deluxe/update_icon(var/itemremoved = 0)
	if (contents.len == 0)
		icon_state = "wormcan_empty_deluxe"
