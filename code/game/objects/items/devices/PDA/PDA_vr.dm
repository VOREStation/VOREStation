/obj/item/device/pda
	var/delete_id = FALSE			//Guaranteed deletion of ID upon deletion of PDA

/obj/item/device/pda/centcom
	default_cartridge = /obj/item/weapon/cartridge/captain
	icon_state = "pda-h"
	detonate = 0
//	hidden = 1

/obj/item/device/pda/pathfinder
	default_cartridge = /obj/item/weapon/cartridge/signal/science
	icon_state = "pda-lawyer-old"

/obj/item/device/pda/explorer
	default_cartridge = /obj/item/weapon/cartridge/signal/science
	icon_state = "pda-det"

/obj/item/device/pda/sar
	default_cartridge = /obj/item/weapon/cartridge/medical
	icon_state = "pda-h"
