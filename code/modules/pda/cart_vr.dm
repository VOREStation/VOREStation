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

/obj/item/weapon/cartridge/storage
	name = "\improper BLU-PAK cartridge"
	desc = "It feels heavier for some reason."
	w_class = ITEMSIZE_SMALL
	icon_state = "cart-lib"
	var/slots = 1
	var/obj/item/weapon/storage/internal/hold

/obj/item/weapon/cartridge/storage/Initialize()
	. = ..()
	hold = new/obj/item/weapon/storage/internal(src)
	hold.max_storage_space = slots * 2
	hold.max_w_class = ITEMSIZE_SMALL

/obj/item/weapon/cartridge/storage/attack_hand(mob/user as mob)
	if (hold.handle_attack_hand(user))	//otherwise interact as a regular storage item
		..(user)

/obj/item/weapon/cartridge/storage/attackby(obj/item/W as obj, mob/user as mob)
	..()
	return hold.attackby(W, user)

/obj/item/weapon/cartridge/storage/MouseDrop(obj/over_object as obj)
	if (hold.handle_mousedrop(usr, over_object))
		..(over_object)

/obj/item/weapon/cartridge/storage/attack_self(mob/user as mob)
	to_chat(user, "<span class='notice'>You empty [src].</span>")
	var/turf/T = get_turf(src)
	hold.hide_from(usr)
	for(var/obj/item/I in hold.contents)
		hold.remove_from_storage(I, T)
	add_fingerprint(user)

/obj/item/weapon/cartridge/storage/emp_act(severity)
	hold.emp_act(severity)
	..()

/obj/item/weapon/cartridge/storage/deluxe
	name = "\improper BLU-PAK DELUXE cartridge"
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
