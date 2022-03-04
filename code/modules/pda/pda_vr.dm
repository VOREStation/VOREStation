/obj/item/device/pda
	var/delete_id = FALSE			//Guaranteed deletion of ID upon deletion of PDA

/obj/item/device/pda/multicaster/exploration/New()
	..()
	owner = "Exploration Department"
	name = "Exploration Department (Relay)"
	cartridges_to_send_to = exploration_cartridges

/obj/item/device/pda/centcom
	default_cartridge = /obj/item/weapon/cartridge/captain
	icon_state = "pda-h"
	detonate = 0
//	hidden = 1

/obj/item/device/pda/pathfinder
	default_cartridge = /obj/item/weapon/cartridge/explorer
	icon_state = "pda-transp"			//Might as well let this sprite actually get seen, otherwise it's going to be hidden forever.

/obj/item/device/pda/explorer
	default_cartridge = /obj/item/weapon/cartridge/explorer
	icon_state = "pda-lawyer-old"			//Explorer's can get the PF's old style instead, rather than re-using the detective PDA

/obj/item/device/pda/sar
	default_cartridge = /obj/item/weapon/cartridge/sar
	icon_state = "pda-gene"			//Gives FM's a distinct PDA of their own, rather than sharing with the bridge-secretary & CCO's.
