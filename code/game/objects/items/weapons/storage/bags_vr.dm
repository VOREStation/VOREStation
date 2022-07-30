/obj/item/storage/bag/chemistry
	slot_flags = null

/obj/item/storage/bag/xeno
	name = "xenobiology bag"
	icon = 'icons/obj/storage.dmi'
	icon_state = "chembag"
	max_storage_space = ITEMSIZE_COST_SMALL * 12
	max_w_class = ITEMSIZE_NORMAL
	w_class = ITEMSIZE_SMALL
	can_hold = list(
		/obj/item/slime_extract,
		/obj/item/slimepotion,
		/obj/item/reagent_containers/food/snacks/monkeycube
		)
