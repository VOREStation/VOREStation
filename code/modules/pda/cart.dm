var/list/command_cartridges = list(
	/obj/item/cartridge/captain,
	/obj/item/cartridge/hop,
	/obj/item/cartridge/hos,
	/obj/item/cartridge/ce,
	/obj/item/cartridge/rd,
	/obj/item/cartridge/cmo,
	/obj/item/cartridge/head,
	/obj/item/cartridge/lawyer // Internal Affaris,
	)

var/list/security_cartridges = list(
	/obj/item/cartridge/security,
	/obj/item/cartridge/detective,
	/obj/item/cartridge/hos
	)

var/list/engineering_cartridges = list(
	/obj/item/cartridge/engineering,
	/obj/item/cartridge/atmos,
	/obj/item/cartridge/ce
	)

var/list/medical_cartridges = list(
	/obj/item/cartridge/medical,
	/obj/item/cartridge/chemistry,
	/obj/item/cartridge/cmo
	)

var/list/research_cartridges = list(
	/obj/item/cartridge/signal/science,
	/obj/item/cartridge/rd
	)

var/list/cargo_cartridges = list(
	/obj/item/cartridge/quartermaster, // This also covers cargo-techs, apparently,
	/obj/item/cartridge/miner,
	/obj/item/cartridge/hop
	)

var/list/civilian_cartridges = list(
	/obj/item/cartridge/janitor,
	/obj/item/cartridge/service,
	/obj/item/cartridge/hop
	)

/obj/item/cartridge
	name = "generic cartridge"
	desc = "A data cartridge for portable microcomputers."
	icon = 'icons/obj/pda.dmi'
	icon_state = "cart"
	item_state = "electronic"
	w_class = ITEMSIZE_TINY
	drop_sound = 'sound/items/drop/component.ogg'
	pickup_sound = 'sound/items/pickup/component.ogg'

	var/obj/item/radio/integrated/radio = null

	var/charges = 0

	var/list/stored_data = list()
	var/list/programs = list()
	var/list/messenger_plugins = list()

/obj/item/cartridge/Destroy()
	QDEL_NULL(radio)
	QDEL_LIST(programs)
	QDEL_LIST(messenger_plugins)
	return ..()

/obj/item/cartridge/proc/update_programs(obj/item/pda/pda)
	for(var/datum/data/pda/P as anything in programs)
		P.pda = pda
	for(var/datum/data/pda/messenger_plugin/P as anything in messenger_plugins)
		P.pda = pda

/obj/item/cartridge/engineering
	name = "\improper Power-ON cartridge"
	icon_state = "cart-e"
	programs = list(
		new/datum/data/pda/app/power,
		new/datum/data/pda/utility/scanmode/halogen)

/obj/item/cartridge/atmos
	name = "\improper BreatheDeep cartridge"
	icon_state = "cart-a"
	programs = list(new/datum/data/pda/utility/scanmode/gas)

/obj/item/cartridge/medical
	name = "\improper Med-U cartridge"
	icon_state = "cart-m"
	programs = list(
		new/datum/data/pda/app/crew_records/medical,
		new/datum/data/pda/utility/scanmode/medical)

/obj/item/cartridge/chemistry
	name = "\improper ChemWhiz cartridge"
	icon_state = "cart-chem"
	programs = list(
		new/datum/data/pda/app/crew_records/medical,
		new/datum/data/pda/utility/scanmode/medical,
		new/datum/data/pda/utility/scanmode/reagent)

/obj/item/cartridge/security
	name = "\improper R.O.B.U.S.T. cartridge"
	icon_state = "cart-s"
	programs = list(
		new/datum/data/pda/app/crew_records/security)

/obj/item/cartridge/detective
	name = "\improper D.E.T.E.C.T. cartridge"
	icon_state = "cart-s"
	programs = list(
		new/datum/data/pda/app/crew_records/medical,
		new/datum/data/pda/utility/scanmode/medical,

		new/datum/data/pda/app/crew_records/security)


/obj/item/cartridge/janitor
	name = "\improper CustodiPRO cartridge"
	desc = "The ultimate in clean-room design."
	icon_state = "cart-j"
	programs = list(new/datum/data/pda/app/janitor)

/obj/item/cartridge/lawyer
	name = "\improper P.R.O.V.E. cartridge"
	icon_state = "cart-s"
	programs = list(new/datum/data/pda/app/crew_records/security)

/obj/item/cartridge/clown
	name = "\improper Honkworks 5.0 cartridge"
	icon_state = "cart-clown"
	charges = 5
	programs = list(new/datum/data/pda/utility/honk)
	messenger_plugins = list(new/datum/data/pda/messenger_plugin/virus/clown)

/obj/item/cartridge/mime
	name = "\improper Gestur-O 1000 cartridge"
	icon_state = "cart-mi"
	charges = 5
	messenger_plugins = list(new/datum/data/pda/messenger_plugin/virus/mime)

/obj/item/cartridge/service
	name = "\improper Serv-U Pro cartridge"
	desc = "A data cartridge designed to serve YOU!"

/obj/item/cartridge/signal
	name = "generic signaler cartridge"
	desc = "A data cartridge with an integrated radio signaler module."
	programs = list(new/datum/data/pda/app/signaller)

/obj/item/cartridge/signal/Initialize()
	radio = new /obj/item/radio/integrated/signal(src)
	. = ..()

/obj/item/cartridge/signal/science
	name = "\improper Signal Ace 2 cartridge"
	desc = "Complete with integrated radio signaler!"
	icon_state = "cart-tox"
	programs = list(
		new/datum/data/pda/utility/scanmode/gas,

		new/datum/data/pda/utility/scanmode/reagent,

		new/datum/data/pda/app/signaller)

/obj/item/cartridge/quartermaster
	name = "\improper Space Parts & Space Vendors cartridge"
	desc = "Perfect for the Quartermaster on the go!"
	icon_state = "cart-q"
	programs = list(
		new/datum/data/pda/app/supply)

/obj/item/cartridge/miner
	name = "\improper Drill-Jockey 4.5 cartridge"
	desc = "It's covered in some sort of sand."
	icon_state = "cart-q"

/obj/item/cartridge/head
	name = "\improper Easy-Record DELUXE cartridge"
	icon_state = "cart-h"
	programs = list(new/datum/data/pda/app/status_display)

/obj/item/cartridge/hop
	name = "\improper HumanResources9001 cartridge"
	icon_state = "cart-h"
	programs = list(
		new/datum/data/pda/app/crew_records/security,

		new/datum/data/pda/app/janitor,

		new/datum/data/pda/app/supply,

		new/datum/data/pda/app/status_display)

/obj/item/cartridge/hos
	name = "\improper R.O.B.U.S.T. DELUXE cartridge"
	icon_state = "cart-hos"
	programs = list(
		new/datum/data/pda/app/crew_records/security,

		new/datum/data/pda/app/status_display)

/obj/item/cartridge/ce
	name = "\improper Power-On DELUXE cartridge"
	icon_state = "cart-ce"
	programs = list(
		new/datum/data/pda/app/power,
		new/datum/data/pda/utility/scanmode/halogen,

		new/datum/data/pda/utility/scanmode/gas,

		new/datum/data/pda/app/status_display)

/obj/item/cartridge/cmo
	name = "\improper Med-U DELUXE cartridge"
	icon_state = "cart-cmo"
	programs = list(
		new/datum/data/pda/app/crew_records/medical,
		new/datum/data/pda/utility/scanmode/medical,

		new/datum/data/pda/utility/scanmode/reagent,

		new/datum/data/pda/app/status_display)

/obj/item/cartridge/rd
	name = "\improper Signal Ace DELUXE cartridge"
	icon_state = "cart-rd"
	programs = list(
		new/datum/data/pda/utility/scanmode/gas,

		new/datum/data/pda/utility/scanmode/reagent,

		new/datum/data/pda/app/signaller,

		new/datum/data/pda/app/status_display)

/obj/item/cartridge/rd/Initialize()
	radio = new /obj/item/radio/integrated/signal(src)
	. = ..()

/obj/item/cartridge/captain
	name = "\improper Value-PAK cartridge"
	desc = "Now with 200% more value!"
	icon_state = "cart-c"
	programs = list(
		new/datum/data/pda/app/power,
		new/datum/data/pda/utility/scanmode/halogen,

		new/datum/data/pda/utility/scanmode/gas,

		new/datum/data/pda/app/crew_records/medical,
		new/datum/data/pda/utility/scanmode/medical,

		new/datum/data/pda/utility/scanmode/reagent,

		new/datum/data/pda/app/crew_records/security,

		new/datum/data/pda/app/janitor,

		new/datum/data/pda/app/supply,

		new/datum/data/pda/app/status_display)

/obj/item/cartridge/syndicate
	name = "\improper Detomatix cartridge"
	icon_state = "cart"
	var/initial_remote_door_id = "smindicate" //Make sure this matches the syndicate shuttle's shield/door id!!	//don't ask about the name, testing.
	charges = 4
	programs = list(new/datum/data/pda/utility/toggle_door)
	messenger_plugins = list(new/datum/data/pda/messenger_plugin/virus/detonate)

/obj/item/cartridge/syndicate/New()
	var/datum/data/pda/utility/toggle_door/D = programs[1]
	if(istype(D))
		D.remote_door_id = initial_remote_door_id

/obj/item/cartridge/proc/post_status(var/command, var/data1, var/data2)

	var/datum/radio_frequency/frequency = radio_controller.return_frequency(1435)
	if(!frequency) return

	var/datum/signal/status_signal = new
	status_signal.source = src
	status_signal.transmission_method = TRANSMISSION_RADIO
	status_signal.data["command"] = command

	switch(command)
		if("message")
			status_signal.data["msg1"] = data1
			status_signal.data["msg2"] = data2
			if(loc)
				var/obj/item/PDA = loc
				var/mob/user = PDA.fingerprintslast
				log_admin("STATUS: [user] set status screen with [PDA]. Message: [data1] [data2]")
				message_admins("STATUS: [user] set status screen with [PDA]. Message: [data1] [data2]")

		if("alert")
			status_signal.data["picture_state"] = data1

	frequency.post_signal(src, status_signal)

/obj/item/cartridge/frame
	name = "F.R.A.M.E. cartridge"
	icon_state = "cart"
	charges = 5
	messenger_plugins = list(new/datum/data/pda/messenger_plugin/virus/frame)
