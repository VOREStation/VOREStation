/*
 * Donut Box
 */

/obj/item/weapon/storage/box/donut
	icon = 'icons/obj/food.dmi'
	icon_state = "donutbox"
	name = "donut box"
	desc = "A box that holds tasty donuts, if you're lucky."
	center_of_mass = list("x" = 16,"y" = 9)
	max_storage_space = ITEMSIZE_COST_SMALL * 6
	can_hold = list(/obj/item/weapon/reagent_containers/food/snacks/donut)
	foldable = /obj/item/stack/material/cardboard
	starts_with = list(/obj/item/weapon/reagent_containers/food/snacks/donut/normal = 6)

/obj/item/weapon/storage/box/donut/Initialize()
	. = ..()
	update_icon()

/obj/item/weapon/storage/box/donut/update_icon()
	cut_overlays()
	var/i = 0
	for(var/obj/item/weapon/reagent_containers/food/snacks/donut/D in contents)
		add_overlay("[i][D.overlay_state]")
		i++

/obj/item/weapon/storage/box/donut/empty
	empty = TRUE

/obj/item/weapon/storage/box/wormcan
	icon = 'icons/obj/food.dmi'
	icon_state = "wormcan"
	name = "can of worms"
	desc = "You probably do want to open this can of worms."
	max_storage_space = ITEMSIZE_COST_TINY * 6
	can_hold = list(
		/obj/item/weapon/reagent_containers/food/snacks/wormsickly,
		/obj/item/weapon/reagent_containers/food/snacks/worm,
		/obj/item/weapon/reagent_containers/food/snacks/wormdeluxe
	)
	starts_with = list(/obj/item/weapon/reagent_containers/food/snacks/worm = 6)

/obj/item/weapon/storage/box/wormcan/Initialize()
	. = ..()
	update_icon()

/obj/item/weapon/storage/box/wormcan/update_icon(var/itemremoved = 0)
	if (contents.len == 0)
		icon_state = "wormcan_empty"

/obj/item/weapon/storage/box/wormcan/sickly
	icon_state = "wormcan_sickly"
	name = "can of sickly worms"
	desc = "You probably don't want to open this can of worms."
	max_storage_space = ITEMSIZE_COST_TINY * 6
	starts_with = list(/obj/item/weapon/reagent_containers/food/snacks/wormsickly = 6)

/obj/item/weapon/storage/box/wormcan/sickly/update_icon(var/itemremoved = 0)
	if (contents.len == 0)
		icon_state = "wormcan_empty_sickly"

/obj/item/weapon/storage/box/wormcan/deluxe
	icon_state = "wormcan_deluxe"
	name = "can of deluxe worms"
	desc = "You absolutely want to open this can of worms."
	max_storage_space = ITEMSIZE_COST_TINY * 6
	starts_with = list(/obj/item/weapon/reagent_containers/food/snacks/wormdeluxe = 6)

/obj/item/weapon/storage/box/wormcan/deluxe/update_icon(var/itemremoved = 0)
	if (contents.len == 0)
		icon_state = "wormcan_empty_deluxe"