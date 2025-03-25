/obj/item/pda
	var/delete_id = FALSE			//Guaranteed deletion of ID upon deletion of PDA

/obj/item/pda/multicaster/exploration
	owner = "Away Team"
	name = "Away Team (Relay)"
	cartridges_to_send_to = list(/obj/item/cartridge/explorer,/obj/item/cartridge/sar)

/obj/item/pda/centcom
	default_cartridge = /obj/item/cartridge/captain
	icon_state = "pda-h"
	detonate = 0
//	hidden = 1

/obj/item/pda/pathfinder
	default_cartridge = /obj/item/cartridge/explorer
	icon_state = "pda-transp"			//Might as well let this sprite actually get seen, otherwise it's going to be hidden forever.

/obj/item/pda/explorer
	default_cartridge = /obj/item/cartridge/explorer
	icon_state = "pda-explore"			//Explorer's can get the PF's old style instead, rather than re-using the detective PDA

/obj/item/pda/sar
	default_cartridge = /obj/item/cartridge/sar
	icon_state = "pda-sar"			//Gives FM's a distinct PDA of their own, rather than sharing with the bridge-secretary & CCO's.

/obj/item/pda/pilot
	icon_state = "pda-pilot"		//New sprites, but still no ROM cartridge or anything
