
/obj/item/device/pda/medical
	default_cartridge = /obj/item/weapon/cartridge/medical
	icon_state = "pda-m"

/obj/item/device/pda/viro
	default_cartridge = /obj/item/weapon/cartridge/medical
	icon_state = "pda-v"

/obj/item/device/pda/engineering
	default_cartridge = /obj/item/weapon/cartridge/engineering
	icon_state = "pda-e"

/obj/item/device/pda/security
	default_cartridge = /obj/item/weapon/cartridge/security
	icon_state = "pda-s"

/obj/item/device/pda/detective
	default_cartridge = /obj/item/weapon/cartridge/detective
	icon_state = "pda-det"

/obj/item/device/pda/warden
	default_cartridge = /obj/item/weapon/cartridge/security
	icon_state = "pda-warden"

/obj/item/device/pda/janitor
	default_cartridge = /obj/item/weapon/cartridge/janitor
	icon_state = "pda-j"
	ttone = "slip"

/obj/item/device/pda/science
	default_cartridge = /obj/item/weapon/cartridge/signal/science
	icon_state = "pda-tox"
	ttone = "boom"

/obj/item/device/pda/clown
	default_cartridge = /obj/item/weapon/cartridge/clown
	icon_state = "pda-clown"
	desc = "A portable microcomputer by Thinktronic Systems, LTD. The surface is coated with polytetrafluoroethylene and banana drippings."
	ttone = "honk"

/obj/item/device/pda/mime
	default_cartridge = /obj/item/weapon/cartridge/mime
	icon_state = "pda-mime"
	message_silent = 1
	news_silent = 1
	ttone = "silence"
	newstone = "silence"

/obj/item/device/pda/heads
	default_cartridge = /obj/item/weapon/cartridge/head
	icon_state = "pda-h"
	news_silent = 1

/obj/item/device/pda/heads/hop
	default_cartridge = /obj/item/weapon/cartridge/hop
	icon_state = "pda-hop"

/obj/item/device/pda/heads/hos
	default_cartridge = /obj/item/weapon/cartridge/hos
	icon_state = "pda-hos"

/obj/item/device/pda/heads/ce
	default_cartridge = /obj/item/weapon/cartridge/ce
	icon_state = "pda-ce"

/obj/item/device/pda/heads/cmo
	default_cartridge = /obj/item/weapon/cartridge/cmo
	icon_state = "pda-cmo"

/obj/item/device/pda/heads/rd
	default_cartridge = /obj/item/weapon/cartridge/rd
	icon_state = "pda-rd"

/obj/item/device/pda/captain
	default_cartridge = /obj/item/weapon/cartridge/captain
	icon_state = "pda-c"
	detonate = 0
	//toff = 1

/obj/item/device/pda/ert
	default_cartridge = /obj/item/weapon/cartridge/captain
	icon_state = "pda-h"
	detonate = 0
//	hidden = 1

/obj/item/device/pda/cargo
	default_cartridge = /obj/item/weapon/cartridge/quartermaster
	icon_state = "pda-cargo"

/obj/item/device/pda/quartermaster
	default_cartridge = /obj/item/weapon/cartridge/quartermaster
	icon_state = "pda-q"

/obj/item/device/pda/shaftminer
	icon_state = "pda-miner"
	default_cartridge = /obj/item/weapon/cartridge/miner

/obj/item/device/pda/syndicate
	default_cartridge = /obj/item/weapon/cartridge/syndicate
	icon_state = "pda-syn"
//	name = "Military PDA" // Vorestation Edit
//	owner = "John Doe"
	hidden = 1

/obj/item/device/pda/chaplain
	default_cartridge = /obj/item/weapon/cartridge/service
	icon_state = "pda-holy"
	ttone = "holy"

/obj/item/device/pda/lawyer
	default_cartridge = /obj/item/weapon/cartridge/lawyer
	icon_state = "pda-lawyer"
	ttone = "..."

/obj/item/device/pda/botanist
	default_cartridge = /obj/item/weapon/cartridge/service
	icon_state = "pda-hydro"

/obj/item/device/pda/roboticist
	default_cartridge = /obj/item/weapon/cartridge/signal/science
	icon_state = "pda-robot"

/obj/item/device/pda/librarian
	default_cartridge = /obj/item/weapon/cartridge/service
	icon_state = "pda-libb"
	desc = "A portable microcomputer by Thinktronic Systems, LTD. This is model is a WGW-11 series e-reader."
	note = "Congratulations, your station has chosen the Thinktronic 5290 WGW-11 Series E-reader and Personal Data Assistant!"
	message_silent = 1 //Quiet in the library!
	news_silent = 0		// Librarian is above the law!  (That and alt job title is reporter)

/obj/item/device/pda/clear
	icon_state = "pda-transp"
	desc = "A portable microcomputer by Thinktronic Systems, LTD. This is model is a special edition with a transparent case."
	note = "Congratulations, you have chosen the Thinktronic 5230 Personal Data Assistant Deluxe Special Max Turbo Limited Edition!"

/obj/item/device/pda/chef
	default_cartridge = /obj/item/weapon/cartridge/service
	icon_state = "pda-chef"

/obj/item/device/pda/bar
	default_cartridge = /obj/item/weapon/cartridge/service
	icon_state = "pda-bar"

/obj/item/device/pda/atmos
	default_cartridge = /obj/item/weapon/cartridge/atmos
	icon_state = "pda-atmo"

/obj/item/device/pda/chemist
	default_cartridge = /obj/item/weapon/cartridge/chemistry
	icon_state = "pda-chem"

/obj/item/device/pda/geneticist
	default_cartridge = /obj/item/weapon/cartridge/medical
	icon_state = "pda-gene"


// Used for the PDA multicaster, which mirrors messages sent to it to a specific department,
/obj/item/device/pda/multicaster
	ownjob = "Relay"
	icon_state = "NONE"
	ttone = "data"
	detonate = 0
	news_silent = 1
	spam_proof = TRUE // Spam messages don't actually work and its difficult to disable these.
	var/list/cartridges_to_send_to = list()

// This is what actually mirrors the message,
/obj/item/device/pda/multicaster/new_message(var/sending_unit, var/sender, var/sender_job, var/message)
	if(sender)
		var/list/targets = list()
		for(var/obj/item/device/pda/pda in PDAs)
			if(pda.cartridge && pda.owner && is_type_in_list(pda.cartridge, cartridges_to_send_to))
				targets |= pda
		if(targets.len)
			for(var/obj/item/device/pda/target in targets)
				create_message(target, sender, sender_job, message)

// This has so much copypasta,
/obj/item/device/pda/multicaster/create_message(var/obj/item/device/pda/P, var/original_sender, var/original_job, var/t)
	t = sanitize(t, MAX_MESSAGE_LEN, 0)
	t = replace_characters(t, list("&#34;" = "\""))
	if (!t || !istype(P))
		return

	if (isnull(P)||P.toff || toff)
		return

	last_text = world.time
	var/datum/reception/reception = get_reception(src, P, t)
	t = reception.message

	if(reception.message_server && (reception.telecomms_reception & TELECOMMS_RECEPTION_SENDER)) // only send the message if it's stable,
		if(reception.telecomms_reception & TELECOMMS_RECEPTION_RECEIVER == 0) // Does our recipient have a broadcaster on their level?,
			return
		var/send_result = reception.message_server.send_pda_message("[P.owner]","[owner]","[t]")
		if (send_result)
			return

		P.tnote.Add(list(list("sent" = 0, "owner" = "[owner]", "job" = "[ownjob]", "message" = "[t]", "target" = "\ref[src]")))

		if(!P.conversations.Find("\ref[src]"))
			P.conversations.Add("\ref[src]")

		P.new_message(src, "[original_sender] \[Relayed\]", original_job, t, 0)

	else
		return

/obj/item/device/pda/multicaster/command/New()
	..()
	owner = "Command Department"
	name = "Command Department (Relay)"
	cartridges_to_send_to = command_cartridges

/obj/item/device/pda/multicaster/security/New()
	..()
	owner = "Security Department"
	name = "Security Department (Relay)"
	cartridges_to_send_to = security_cartridges

/obj/item/device/pda/multicaster/engineering/New()
	..()
	owner = "Engineering Department"
	name = "Engineering Department (Relay)"
	cartridges_to_send_to = engineering_cartridges

/obj/item/device/pda/multicaster/medical/New()
	..()
	owner = "Medical Department"
	name = "Medical Department (Relay)"
	cartridges_to_send_to = medical_cartridges

/obj/item/device/pda/multicaster/research/New()
	..()
	owner = "Research Department"
	name = "Research Department (Relay)"
	cartridges_to_send_to = research_cartridges

/obj/item/device/pda/multicaster/cargo/New()
	..()
	owner = "Cargo Department"
	name = "Cargo Department (Relay)"
	cartridges_to_send_to = cargo_cartridges

/obj/item/device/pda/multicaster/civilian/New()
	..()
	owner = "Civilian Services Department"
	name = "Civilian Services Department (Relay)"
	cartridges_to_send_to = civilian_cartridges

/obj/item/device/pda/clown/Crossed(atom/movable/AM as mob|obj) //Clown PDA is slippery.
	if(AM.is_incorporeal())
		return
	if (istype(AM, /mob/living))
		var/mob/living/M = AM

		if(M.slip("the PDA",8) && M.real_name != src.owner && istype(src.cartridge, /obj/item/weapon/cartridge/clown))
			if(src.cartridge.charges < 5)
				src.cartridge.charges++

//Some spare PDAs in a box
/obj/item/weapon/storage/box/PDAs
	name = "box of spare PDAs"
	desc = "A box of spare PDA microcomputers."
	icon = 'icons/obj/pda.dmi'
	icon_state = "pdabox"

/obj/item/weapon/storage/box/PDAs/New()
	..()
	new /obj/item/device/pda(src)
	new /obj/item/device/pda(src)
	new /obj/item/device/pda(src)
	new /obj/item/device/pda(src)
	new /obj/item/weapon/cartridge/head(src)

	var/newcart = pick(	/obj/item/weapon/cartridge/engineering,
						/obj/item/weapon/cartridge/security,
						/obj/item/weapon/cartridge/medical,
						/obj/item/weapon/cartridge/signal/science,
						/obj/item/weapon/cartridge/quartermaster)
	new newcart(src)
