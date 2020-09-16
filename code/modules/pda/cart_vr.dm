var/list/exploration_cartridges = list(
	/obj/item/weapon/cartridge/explorer,
	/obj/item/weapon/cartridge/sar
	)

/obj/item/weapon/cartridge/explorer
	name = "\improper Explorator cartridge"
	icon_state = "cart-e"
	programs = list(
		new/datum/data/pda/utility/scanmode/reagent,
		new/datum/data/pda/utility/scanmode/gas)

/obj/item/weapon/cartridge/sar
	name = "\improper Med-Exp cartridge"
	icon_state = "cart-m"
	programs = list(
		new/datum/data/pda/app/crew_records/medical,
		new/datum/data/pda/utility/scanmode/medical,
		new/datum/data/pda/utility/scanmode/reagent,
		new/datum/data/pda/utility/scanmode/gas)
