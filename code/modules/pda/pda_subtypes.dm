
/obj/item/pda/medical
	default_cartridge = /obj/item/cartridge/medical
	icon_state = "pda-m"

/obj/item/pda/viro
	default_cartridge = /obj/item/cartridge/medical
	icon_state = "pda-v"

/obj/item/pda/engineering
	default_cartridge = /obj/item/cartridge/engineering
	icon_state = "pda-e"

/obj/item/pda/security
	default_cartridge = /obj/item/cartridge/security
	icon_state = "pda-s"

/obj/item/pda/detective
	default_cartridge = /obj/item/cartridge/detective
	icon_state = "pda-det"

/obj/item/pda/warden
	default_cartridge = /obj/item/cartridge/security
	icon_state = "pda-warden"

/obj/item/pda/janitor
	default_cartridge = /obj/item/cartridge/janitor
	icon_state = "pda-j"
	ttone = "slip"

/obj/item/pda/science
	default_cartridge = /obj/item/cartridge/signal/science
	icon_state = "pda-tox"
	ttone = "boom"

/obj/item/pda/clown
	default_cartridge = /obj/item/cartridge/clown
	icon_state = "pda-clown"
	desc = "A portable microcomputer by Thinktronic Systems, LTD. The surface is coated with polytetrafluoroethylene and banana drippings."
	ttone = "honk"

/obj/item/pda/mime
	default_cartridge = /obj/item/cartridge/mime
	icon_state = "pda-mime"

/obj/item/pda/mime/Initialize()
	. = ..()
	var/datum/data/pda/app/M = find_program(/datum/data/pda/app/messenger)
	if(M)
		M.notify_silent = TRUE

/obj/item/pda/heads
	default_cartridge = /obj/item/cartridge/head
	icon_state = "pda-h"

/obj/item/pda/heads/hop
	default_cartridge = /obj/item/cartridge/hop
	icon_state = "pda-hop"

/obj/item/pda/heads/hos
	default_cartridge = /obj/item/cartridge/hos
	icon_state = "pda-hos"

/obj/item/pda/heads/ce
	default_cartridge = /obj/item/cartridge/ce
	icon_state = "pda-ce"

/obj/item/pda/heads/cmo
	default_cartridge = /obj/item/cartridge/cmo
	icon_state = "pda-cmo"

/obj/item/pda/heads/rd
	default_cartridge = /obj/item/cartridge/rd
	icon_state = "pda-rd"

/obj/item/pda/captain
	default_cartridge = /obj/item/cartridge/captain
	icon_state = "pda-c"
	detonate = 0
	//toff = 1

/obj/item/pda/ert
	default_cartridge = /obj/item/cartridge/captain
	icon_state = "pda-h"
	detonate = 0
//	hidden = 1

/obj/item/pda/cargo
	default_cartridge = /obj/item/cartridge/quartermaster
	icon_state = "pda-cargo"

/obj/item/pda/quartermaster
	default_cartridge = /obj/item/cartridge/quartermaster
	icon_state = "pda-q"

/obj/item/pda/shaftminer
	icon_state = "pda-miner"
	default_cartridge = /obj/item/cartridge/miner

/obj/item/pda/syndicate
	default_cartridge = /obj/item/cartridge/syndicate
	icon_state = "pda-syn"
//	name = "Military PDA" // Vorestation Edit
//	owner = "John Doe"
	hidden = 1

/obj/item/pda/chaplain
	default_cartridge = /obj/item/cartridge/service
	icon_state = "pda-holy"
	ttone = "holy"

/obj/item/pda/lawyer
	default_cartridge = /obj/item/cartridge/lawyer
	icon_state = "pda-lawyer"
	ttone = "..."

/obj/item/pda/botanist
	default_cartridge = /obj/item/cartridge/service
	icon_state = "pda-hydro"

/obj/item/pda/roboticist
	default_cartridge = /obj/item/cartridge/signal/science
	icon_state = "pda-robot"

/obj/item/pda/librarian
	default_cartridge = /obj/item/cartridge/service
	icon_state = "pda-libb"
	desc = "A portable microcomputer by Thinktronic Systems, LTD. This is model is a WGW-11 series e-reader."
	model_name = "Thinktronic 5290 WGW-11 Series E-reader and Personal Data Assistant"

/obj/item/pda/librarian/Initialize()
	. = ..()
	var/datum/data/pda/app/M = find_program(/datum/data/pda/app/messenger)
	if(M)
		M.notify_silent = TRUE //Quiet in the library!

/obj/item/pda/clear
	icon_state = "pda-transp"
	desc = "A portable microcomputer by Thinktronic Systems, LTD. This is model is a special edition with a transparent case."
	model_name = "Thinktronic 5230 Personal Data Assistant Deluxe Special Max Turbo Limited Edition"

/obj/item/pda/chef
	default_cartridge = /obj/item/cartridge/service
	icon_state = "pda-chef"

/obj/item/pda/bar
	default_cartridge = /obj/item/cartridge/service
	icon_state = "pda-bar"

/obj/item/pda/atmos
	default_cartridge = /obj/item/cartridge/atmos
	icon_state = "pda-atmo"

/obj/item/pda/chemist
	default_cartridge = /obj/item/cartridge/chemistry
	icon_state = "pda-chem"

/obj/item/pda/geneticist
	default_cartridge = /obj/item/cartridge/medical
	icon_state = "pda-gene"


// Used for the PDA multicaster, which mirrors messages sent to it to a specific department,
/obj/item/pda/multicaster
	ownjob = "Relay"
	icon_state = "NONE"
	detonate = 0
	spam_proof = TRUE // Spam messages don't actually work and its difficult to disable these.
	programs = list(
		new/datum/data/pda/app/messenger/multicast
	)
	var/list/cartridges_to_send_to = list()

/obj/item/pda/multicaster/command/Initialize()
	. = ..()
	owner = "Command Department"
	name = "Command Department (Relay)"
	cartridges_to_send_to = command_cartridges

/obj/item/pda/multicaster/security/Initialize()
	. = ..()
	owner = "Security Department"
	name = "Security Department (Relay)"
	cartridges_to_send_to = security_cartridges

/obj/item/pda/multicaster/engineering/Initialize()
	. = ..()
	owner = "Engineering Department"
	name = "Engineering Department (Relay)"
	cartridges_to_send_to = engineering_cartridges

/obj/item/pda/multicaster/medical/Initialize()
	. = ..()
	owner = "Medical Department"
	name = "Medical Department (Relay)"
	cartridges_to_send_to = medical_cartridges

/obj/item/pda/multicaster/research/Initialize()
	. = ..()
	owner = "Research Department"
	name = "Research Department (Relay)"
	cartridges_to_send_to = research_cartridges

/obj/item/pda/multicaster/cargo/Initialize()
	. = ..()
	owner = "Cargo Department"
	name = "Cargo Department (Relay)"
	cartridges_to_send_to = cargo_cartridges

/obj/item/pda/multicaster/civilian/Initialize()
	. = ..()
	owner = "Civilian Services Department"
	name = "Civilian Services Department (Relay)"
	cartridges_to_send_to = civilian_cartridges

/obj/item/pda/clown/Crossed(atom/movable/AM as mob|obj) //Clown PDA is slippery.
	if(AM.is_incorporeal())
		return
	if (istype(AM, /mob/living))
		var/mob/living/M = AM

		if(M.slip("the PDA",8) && M.real_name != src.owner && istype(src.cartridge, /obj/item/cartridge/clown))
			if(src.cartridge.charges < 5)
				src.cartridge.charges++

//Some spare PDAs in a box
/obj/item/storage/box/PDAs
	name = "box of spare PDAs"
	desc = "A box of spare PDA microcomputers."
	icon = 'icons/obj/pda.dmi'
	icon_state = "pdabox"

/obj/item/storage/box/PDAs/Initialize()
	. = ..()
	new /obj/item/pda(src)
	new /obj/item/pda(src)
	new /obj/item/pda(src)
	new /obj/item/pda(src)
	new /obj/item/cartridge/head(src)

	var/newcart = pick(	/obj/item/cartridge/engineering,
						/obj/item/cartridge/security,
						/obj/item/cartridge/medical,
						/obj/item/cartridge/signal/science,
						/obj/item/cartridge/quartermaster)
	new newcart(src)
