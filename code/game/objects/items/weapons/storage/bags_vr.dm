/obj/item/weapon/storage/bag/chemistry
	slot_flags = null

/obj/item/weapon/storage/bag/xeno
	name = "xenobiology bag"
	icon = 'icons/obj/storage.dmi'
	icon_state = "chembag"
	max_storage_space = ITEMSIZE_COST_NORMAL * 25
	max_w_class = ITEMSIZE_NORMAL
	w_class = ITEMSIZE_SMALL
	can_hold = list(
		/obj/item/slime_extract,
		/obj/item/slimepotion,
		/obj/item/weapon/reagent_containers/food/snacks/monkeycube
		)