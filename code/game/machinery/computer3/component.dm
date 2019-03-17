
/*
	Objects used to construct computers, and objects that can be inserted into them, etc.

	TODO:
	* Synthesizer part (toybox, injectors, etc)
*/



/obj/item/part/computer
	name = "computer part"
	desc = "Holy jesus you donnit now"
	gender = PLURAL
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "hdd1"
	w_class = ITEMSIZE_SMALL

	var/emagged = 0

	// the computer that this device is attached to
	var/obj/machinery/computer3/computer

	// If the computer is attacked by an item it will reference this to decide which peripheral(s) are affected.
	var/list/attackby_types	= list()

/obj/item/part/computer/proc/allow_attackby(var/obj/item/I, var/mob/user)
	for(var/typepath in attackby_types)
		if(istype(I, typepath))
			return 1
	return 0

/obj/item/part/computer/proc/init(var/obj/machinery/computer/target)
		computer = target
		// continue to handle all other type-specific procedures

/*
	Below are all the miscellaneous components
	For storage drives, see storage.dm
	For networking parts, see
*/

/obj/item/part/computer/ai_holder
	name = "intelliCore computer module"
	desc = "Contains a specialized nacelle for dealing with highly sensitive equipment without interference."

	attackby_types = list(/obj/item/device/aicard)

	var/mob/living/silicon/ai/occupant	= null
	var/busy = 0

/obj/item/part/computer/ai_holder/attackby(obj/I as obj,mob/user as mob)
	if(computer && !computer.stat)
		if(istype(I, /obj/item/device/aicard))
			var/obj/item/device/aicard/card = I
			var/mob/living/silicon/ai/comp_ai = locate() in src
			var/mob/living/silicon/ai/card_ai = locate() in card

			if(istype(comp_ai))
				if(busy)
					to_chat(user, "<span class='danger'>ERROR:</span> Reconstruction in progress.")
					return

				if(card.grab_ai(comp_ai, user))
					occupant = null

			else if(istype(card_ai))
				load_ai(card_ai,card,user)

			if(computer.program)
				computer.program.update_icon()

			computer.update_icon()
	..()
	return

/obj/item/part/computer/ai_holder/proc/load_ai(var/mob/living/silicon/ai/transfer, var/obj/item/device/aicard/card, var/mob/user)

	if(!istype(transfer))
		return

	// Transfer over the AI.
	to_chat(transfer, "You have been transferred into a mobile terminal. Sadly, there is no remote access from here.")
	to_chat(user, "<span class='notice'>Transfer successful:</span> [transfer.name] placed within mobile terminal.")

	transfer.loc = src
	transfer.cancel_camera()
	transfer.control_disabled = 1
	occupant = transfer

	if(card)
		card.clear()


/*
	ID computer cardslot - reading and writing slots
*/

/obj/item/part/computer/cardslot
	name = "magnetic card slot"
	desc = "Contains a slot for reading magnetic swipe cards."

	var/obj/item/weapon/card/reader	= null

	attackby_types = list(/obj/item/weapon/card)

/obj/item/part/computer/cardslot/attackby(var/obj/item/I as obj, var/mob/user)
	if(istype(I,/obj/item/weapon/card) && computer)
		if(istype(I,/obj/item/weapon/card/emag) && !reader) // emag reader slot
			user.visible_message("[computer]'s screen flickers for a moment.","You insert \the [I].  After a moment, the card ejects itself, and [computer] beeps.","[computer] beeps.")
			computer.emagged = 1
			return

		insert(I, user)
		return
	..(I,user)

	// cardslot.insert(card, slot)
	// card: The card obj you want to insert (usually your ID)
	// user: The mob inserting the card
/obj/item/part/computer/cardslot/proc/insert(var/obj/item/weapon/card/card, var/mob/user)
	if(equip_to_reader(card, user))
		to_chat(user, "You insert the card into reader slot")
		return 1
	to_chat(user, "There is already something in the reader slot.")
	return 0


	// Usage of insert() preferred, as it also tells result to the user.
/obj/item/part/computer/cardslot/proc/equip_to_reader(var/obj/item/weapon/card/card, var/mob/living/L)
	if(!reader)
		L.drop_item()
		card.loc = src
		reader = card
		return 1
	return 0

	// cardslot.remove(slot)
	// user: The mob removing the card
/obj/item/part/computer/cardslot/proc/remove(var/mob/user)
	if(remove_reader(user))
		to_chat(user,  "You remove the card from reader slot")
		return 1
	to_chat(user,  "There is nothing in the reader slot")
	return 0

/obj/item/part/computer/cardslot/proc/remove_reader(var/mob/living/L)
	if(reader)
		if(ishuman(L) && !L.get_active_hand())
			L.put_in_hands(reader)
		else
			reader.loc = get_turf(computer)
		reader = null
		return 1
	return 0

	// Authorizes the user based on the computer's requirements
/obj/item/part/computer/cardslot/proc/authenticate()
		return computer.check_access(reader)


/obj/item/part/computer/cardslot/dual
	name	= "magnetic card reader"
	desc	= "Contains slots for inserting magnetic swipe cards for reading and writing."

	var/obj/item/weapon/card/writer	= null


	// Ater: Single- and dual-slot card readers have separate functions.
	// According to OOP principles, they should be separate classes and use inheritance, polymorphism.


/obj/item/part/computer/cardslot/dual/proc/equip_to_writer(var/obj/item/weapon/card/card, var/mob/living/L)
	if(!writer)
		L.drop_item()
		card.loc = src
		writer = card
		return 1
	return 0

/obj/item/part/computer/cardslot/dual/proc/remove_from_writer(var/mob/living/L)
	if(writer)
		if(ishuman(L) && !L.get_active_hand())
			L.put_in_hands(writer)
		else
			writer.loc = get_turf(computer)
		writer = null
		return 1
	return 0

	// cardslot.insert(card, slot)
	// card: The card obj you want to insert (usually your ID)
	// user: The mob inserting the card
	// slot: Which slot to insert into (1->Reader, 2->Writer, 3->Auto) Default 3
/obj/item/part/computer/cardslot/dual/insert(var/obj/item/weapon/card/card, var/mob/user, var/slot = 3)
	if(slot != 2)
		if(..(card, user))
			return 1

	if(slot != 1)
		if(equip_to_writer(card, user))
			to_chat(user, "You insert the card into writer slot")
			return 1
		else
			to_chat(user, "There is already something in the writer slot.")
	return 0

	// cardslot/dual.insert(card, slot)
	// user: The mob removing the card
	// slot: Which slot to remove from (1->Reader, 2->Writer, 3->Both, 4->Reader and if empty, Writer) Default 3
/obj/item/part/computer/cardslot/dual/remove(var/mob/user, var/slot = 3)
	if(slot != 2)
		if(..(user) && slot != 3) // ..() probes reader
			return 1 // slot is either 1 or 4, where we only probe reader if there's anything in it

	if(slot != 1) // If slot is 1, then we only probe reader
		if(remove_from_writer(user)) // Probe writer
			to_chat(user, "You remove the card from the writer slot")
			return 1
		to_chat(user, "There is nothing in the writer slot.")
	return 0

/obj/item/part/computer/cardslot/dual/proc/addfile(var/datum/file/F)
	if(!istype(writer,/obj/item/weapon/card/data))
		return 0
	var/obj/item/weapon/card/data/D = writer
	if(D.files.len > 3)
		return 0
	D.files += F
	return 1
