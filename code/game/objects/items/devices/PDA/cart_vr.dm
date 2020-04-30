var/list/exploration_cartridges = list(
	/obj/item/weapon/cartridge/explorer,
	/obj/item/weapon/cartridge/sar
	)

/obj/item/weapon/cartridge/explorer
	name = "\improper Explorator cartridge"
	icon_state = "cart-e"
	access_reagent_scanner = 1
	access_atmos = 1

/obj/item/weapon/cartridge/sar
	name = "\improper Med-Exp cartridge"
	icon_state = "cart-m"
	access_medical = 1
	access_reagent_scanner = 1
	access_atmos = 1
