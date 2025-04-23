/*
 * Backpack
 */

/obj/item/storage/backpack
	name = "backpack"
	desc = "You wear this on your back and put items into it."
	icon = 'icons/inventory/back/item.dmi'
	icon_state = "backpack"
	sprite_sheets = list(
		SPECIES_TESHARI = 'icons/inventory/back/mob_teshari.dmi'
		)
	w_class = ITEMSIZE_LARGE
	slot_flags = SLOT_BACK
	max_w_class = ITEMSIZE_LARGE
	max_storage_space = INVENTORY_STANDARD_SPACE
	var/flippable = 0
	var/side = 0 //0 = right, 1 = left
	drop_sound = 'sound/items/drop/backpack.ogg'
	pickup_sound = 'sound/items/pickup/backpack.ogg'


/obj/item/storage/backpack/equipped(var/mob/user, var/slot)
	if (slot == slot_back && src.use_sound)
		playsound(src, src.use_sound, 50, 1, -5)
	..(user, slot)

/*
/obj/item/storage/backpack/dropped(mob/user)
	if (loc == user && src.use_sound)
		if(isbelly(user.loc))
			var/obj/belly/B = user.loc
			if(B.mode_flags & DM_FLAG_MUFFLEITEMS)
				return
		else
			playsound(src, src.use_sound, 50, 1, -5)
	..(user)
*/

/*
 * Backpack Types
 */

/obj/item/storage/backpack/holding
	name = "bag of holding"
	desc = "A backpack that opens into a localized pocket of Blue Space."
	origin_tech = list(TECH_BLUESPACE = 4)
	icon_state = "holdingpack"
	max_w_class = ITEMSIZE_LARGE
	max_storage_space = ITEMSIZE_COST_NORMAL * 14 // 56
	storage_cost = INVENTORY_STANDARD_SPACE + 1

/obj/item/storage/backpack/holding/duffle
	name = "dufflebag of holding"
	var/tilted = 0
	icon_state = "holdingduffle"

/obj/item/storage/backpack/holding/duffle/Initialize(mapload)
	. = ..()
	if(prob(50))
		icon_state = "[icon_state]_tilted"
		tilted = 1

/obj/item/storage/backpack/holding/duffle/verb/tilt()
	set name = "Adjust Duffelbag Angle"
	set desc = "Adjust the angle of your dufflebag for cosmetic effect"
	set category = "Object"
	set src in usr
	if(!usr.canmove || usr.stat || usr.restrained())
		return
	if(tilted)
		icon_state = "[initial(icon_state)]"
		to_chat(usr, "You adjust the angle of \the [src] to rest across your lower back.")
		tilted = 0
	else
		icon_state = "[icon_state]_tilted"
		to_chat(usr, "You adjust the angle of \the [src] to rest diagonally across your back.")
		tilted = 1
	update_icon()
	usr.update_inv_back()

/obj/item/storage/backpack/holding/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/storage/backpack/holding))
		to_chat(user, span_warning("The Bluespace interfaces of the two devices conflict and malfunction."))
		qdel(W)
		return
	. = ..()

//Please don't clutter the parent storage item with stupid hacks.
/obj/item/storage/backpack/holding/can_be_inserted(obj/item/W as obj, stop_messages = 0)
	if(istype(W, /obj/item/storage/backpack/holding))
		return FALSE
	return ..()

/obj/item/storage/backpack/santabag
	name = "\improper Santa's gift bag"
	desc = "Space Santa uses this to deliver toys to all the nice children in space in Christmas! Wow, it's pretty big!"
	icon_state = "giftbag0"
	item_state_slots = list(slot_r_hand_str = "giftbag", slot_l_hand_str = "giftbag")
	w_class = ITEMSIZE_LARGE
	max_w_class = ITEMSIZE_NORMAL
	max_storage_space = ITEMSIZE_COST_NORMAL * 100 // can store a ton of shit!

/obj/item/storage/backpack/cultpack
	name = "trophy rack"
	desc = "It's useful for both carrying extra gear and proudly declaring your insanity."
	icon_state = "backpack_cult"

/obj/item/storage/backpack/clown
	name = "Giggles von Honkerton"
	desc = "It's a backpack made by Honk! Co."
	icon_state = "backpack_clown"

/obj/item/storage/backpack/white
	name = "white backpack"
	icon_state = "backpack_white"

/obj/item/storage/backpack/fancy
	name = "fancy backpack"
	icon_state = "backpack_fancy"

/obj/item/storage/backpack/military
	name = "military backpack"
	icon_state = "backpack_military"

/obj/item/storage/backpack/medic
	name = "medical backpack"
	desc = "It's a backpack especially designed for use in a sterile environment."
	icon_state = "backpack_medical"

/obj/item/storage/backpack/security
	name = "security backpack"
	desc = "It's a very robust backpack."
	icon_state = "backpack_security"

/obj/item/storage/backpack/captain
	name = "site manager's backpack"
	desc = "It's a special backpack made exclusively for officers."
	icon_state = "backpack_captain"

/obj/item/storage/backpack/industrial
	name = "industrial backpack"
	desc = "It's a tough backpack for the daily grind of station life."
	icon_state = "backpack_industrial"

/obj/item/storage/backpack/toxins
	name = "laboratory backpack"
	desc = "It's a light backpack modeled for use in laboratories and other scientific institutions."
	icon_state = "backpack_purple"

/obj/item/storage/backpack/hydroponics
	name = "herbalist's backpack"
	desc = "It's a green backpack with many pockets to store plants and tools in."
	icon_state = "backpack_hydro"

/obj/item/storage/backpack/genetics
	name = "geneticist backpack"
	desc = "It's a backpack fitted with slots for diskettes and other workplace tools."
	icon_state = "backpack_blue"

/obj/item/storage/backpack/virology
	name = "sterile backpack"
	desc = "It's a sterile backpack able to withstand different pathogens from entering its fabric."
	icon_state = "backpack_green"

/obj/item/storage/backpack/chemistry
	name = "chemistry backpack"
	desc = "It's an orange backpack which was designed to hold beakers, pill bottles and bottles."
	icon_state = "backpack_orange"

/*
 * Duffle Types
 */

/obj/item/storage/backpack/dufflebag
	name = "dufflebag"
	desc = "A large dufflebag for holding extra things."
	icon_state = "duffle"
	slowdown = 0.5
	var/tilted = 0
	var/can_tilt = 1
	max_storage_space = INVENTORY_DUFFLEBAG_SPACE

/obj/item/storage/backpack/dufflebag/Initialize(mapload)
	. = ..()
	if(prob(50))
		icon_state = "[icon_state]_tilted"
		tilted = 1

/obj/item/storage/backpack/dufflebag/verb/tilt()
	set name = "Adjust Duffelbag Angle"
	set desc = "Adjust the angle of your dufflebag for cosmetic effect"
	set category = "Object"
	set src in usr
	if(!usr.canmove || usr.stat || usr.restrained())
		return
	if(!can_tilt)
		to_chat(usr, "[src] can't be adjusted like that.")
		return
	if(tilted)
		icon_state = "[initial(icon_state)]"
		to_chat(usr, "You adjust the angle of \the [src] to rest across your lower back.")
		tilted = 0
	else
		icon_state = "[icon_state]_tilted"
		to_chat(usr, "You adjust the angle of \the [src] to rest diagonally across your back.")
		tilted = 1
	update_icon()
	usr.update_inv_back()

/obj/item/storage/backpack/dufflebag/syndie
	name = "black dufflebag"
	desc = "A large dufflebag for holding extra tactical supplies. This one appears to be made out of lighter material than usual."
	icon_state = "duffle_syndie"
	slowdown = 0

/obj/item/storage/backpack/dufflebag/syndie/med
	name = "medical dufflebag"
	desc = "A large dufflebag for holding extra tactical medical supplies. This one appears to be made out of lighter material than usual."
	icon_state = "duffle_syndiemed"

/obj/item/storage/backpack/dufflebag/syndie/ammo
	name = "ammunition dufflebag"
	desc = "A large dufflebag for holding extra weapons ammunition and supplies. This one appears to be made out of lighter material than usual."
	icon_state = "duffle_syndieammo"

/obj/item/storage/backpack/dufflebag/captain
	name = "site manager's dufflebag"
	desc = "A large dufflebag for holding extra captainly goods."
	icon_state = "duffle_captain"

/obj/item/storage/backpack/dufflebag/med
	name = "medical dufflebag"
	desc = "A large dufflebag for holding extra medical supplies."
	icon_state = "duffle_medical"

/obj/item/storage/backpack/dufflebag/emt
	name = "EMT dufflebag"
	desc = "A large dufflebag for holding extra medical supplies. This one has reflective stripes!"
	icon_state = "duffle_emt"

/obj/item/storage/backpack/dufflebag/sec
	name = "security dufflebag"
	desc = "A large dufflebag for holding extra security supplies and ammunition."
	icon_state = "duffle_security"

/obj/item/storage/backpack/dufflebag/eng
	name = "industrial dufflebag"
	desc = "A large dufflebag for holding extra tools and supplies."
	icon_state = "duffle_industrial"

/obj/item/storage/backpack/dufflebag/sci
	name = "science dufflebag"
	desc = "A large dufflebag for holding circuits and beakers."
	icon_state = "duffle_science"

/obj/item/storage/backpack/dufflebag/drone
	name = "drone dufflebag"
	desc = "A large dufflebag for holding small robots? Or maybe it's one used by robots!"
	icon_state = "duffle_drone"

/obj/item/storage/backpack/dufflebag/cursed
	name = "cursed dufflebag"
	desc = "That probably shouldn't be moving..."
	icon_state = "duffle_curse"

/*
 * Satchel Types
 */

/obj/item/storage/backpack/satchel
	name = "leather satchel"
	desc = "It's a very fancy satchel made with fine leather."
	icon_state = "satchel"

/obj/item/storage/backpack/satchel/withwallet
	starts_with = list(/obj/item/storage/wallet/random)

/obj/item/storage/backpack/satchel/norm
	name = "satchel"
	desc = "A trendy looking satchel."
	icon_state = "satchel_grey"

/obj/item/storage/backpack/satchel/white
	name = "white satchel"
	icon_state = "satchel_white"

/obj/item/storage/backpack/satchel/fancy
	name = "fancy satchel"
	icon_state = "satchel_fancy"

/obj/item/storage/backpack/satchel/military
	name = "military satchel"
	icon_state = "satchel_military"

/obj/item/storage/backpack/satchel/eng
	name = "industrial satchel"
	desc = "A tough satchel with extra pockets."
	icon_state = "satchel_industrial"

/obj/item/storage/backpack/satchel/med
	name = "medical satchel"
	desc = "A sterile satchel used in medical departments."
	icon_state = "satchel_medical"

/obj/item/storage/backpack/satchel/vir
	name = "virologist satchel"
	desc = "A sterile satchel with virologist colours."
	icon_state = "satchel_green"

/obj/item/storage/backpack/satchel/chem
	name = "chemist satchel"
	desc = "A sterile satchel with chemist colours."
	icon_state = "satchel_orange"

/obj/item/storage/backpack/satchel/gen
	name = "geneticist satchel"
	desc = "A sterile satchel with geneticist colours."
	icon_state = "satchel_blue"

/obj/item/storage/backpack/satchel/tox
	name = "scientist satchel"
	desc = "Useful for holding research materials."
	icon_state = "satchel_purple"

/obj/item/storage/backpack/satchel/sec
	name = "security satchel"
	desc = "A robust satchel for security related needs."
	icon_state = "satchel_security"

/obj/item/storage/backpack/satchel/hyd
	name = "hydroponics satchel"
	desc = "A green satchel for plant related work."
	icon_state = "satchel_hydro"

/obj/item/storage/backpack/satchel/cap
	name = "site manager's satchel"
	desc = "An exclusive satchel for officers."
	icon_state = "satchel_captain"

//ERT backpacks.
/obj/item/storage/backpack/ert
	name = "emergency response team backpack"
	desc = "A spacious backpack with lots of pockets, used by members of the Emergency Response Team."
	icon_state = "ert_commander"

//Commander
/obj/item/storage/backpack/ert/commander
	name = "emergency response team commander backpack"
	desc = "A spacious backpack with lots of pockets, worn by the commander of an Emergency Response Team."

//Security
/obj/item/storage/backpack/ert/security
	name = "emergency response team security backpack"
	desc = "A spacious backpack with lots of pockets, worn by security members of an Emergency Response Team."
	icon_state = "ert_security"

//Engineering
/obj/item/storage/backpack/ert/engineer
	name = "emergency response team engineer backpack"
	desc = "A spacious backpack with lots of pockets, worn by engineering members of an Emergency Response Team."
	icon_state = "ert_engineering"

//Medical
/obj/item/storage/backpack/ert/medical
	name = "emergency response team medical backpack"
	desc = "A spacious backpack with lots of pockets, worn by medical members of an Emergency Response Team."
	icon_state = "ert_medical"

/*
 * Courier Bags
 */

/obj/item/storage/backpack/messenger
	name = "messenger bag"
	desc = "A sturdy backpack worn over one shoulder."
	icon_state = "courier"
	item_state_slots = list(slot_r_hand_str = "satchel_grey", slot_l_hand_str = "satchel_grey")

/obj/item/storage/backpack/messenger/chem
	name = "chemistry messenger bag"
	desc = "A serile backpack worn over one shoulder.  This one is in Chemsitry colors."
	icon_state = "courier_chemistry"
	item_state_slots = list(slot_r_hand_str = "satchel_orange", slot_l_hand_str = "satchel_orange")

/obj/item/storage/backpack/messenger/med
	name = "medical messenger bag"
	desc = "A sterile backpack worn over one shoulder used in medical departments."
	icon_state = "courier_medical"
	item_state_slots = list(slot_r_hand_str = "satchel_medical", slot_l_hand_str = "satchel_medical")

/obj/item/storage/backpack/messenger/viro
	name = "virology messenger bag"
	desc = "A sterile backpack worn over one shoulder.  This one is in Virology colors."
	icon_state = "courier_virology"
	item_state_slots = list(slot_r_hand_str = "satchel_green", slot_l_hand_str = "satchel_green")

/obj/item/storage/backpack/messenger/tox
	name = "research messenger bag"
	desc = "A backpack worn over one shoulder.  Useful for holding science materials."
	icon_state = "courier_toxins"
	item_state_slots = list(slot_r_hand_str = "satchel_purple", slot_l_hand_str = "satchel_purple")

/obj/item/storage/backpack/messenger/com
	name = "command messenger bag"
	desc = "A special backpack worn over one shoulder.  This one is made specifically for officers."
	icon_state = "courier_captain"
	item_state_slots = list(slot_r_hand_str = "satchel_captain", slot_l_hand_str = "satchel_captain")

/obj/item/storage/backpack/messenger/engi
	name = "engineering messenger bag"
	icon_state = "courier_industrial"
	item_state_slots = list(slot_r_hand_str = "satchel_industrial", slot_l_hand_str = "satchel_industrial")

/obj/item/storage/backpack/messenger/hyd
	name = "hydroponics messenger bag"
	desc = "A backpack worn over one shoulder.  This one is designed for plant-related work."
	icon_state = "courier_hydro"
	item_state_slots = list(slot_r_hand_str = "satchel_hydro", slot_l_hand_str = "satchel_hydro")

/obj/item/storage/backpack/messenger/sec
	name = "security messenger bag"
	desc = "A tactical backpack worn over one shoulder. This one is in Security colors."
	icon_state = "courier_security"
	item_state_slots = list(slot_r_hand_str = "satchel_security", slot_l_hand_str = "satchel_security")

/obj/item/storage/backpack/messenger/black
	icon_state = "courier_black"


/*
 * Sport Bags
 */

/obj/item/storage/backpack/sport
	name = "sports backpack"
	icon_state = "backsport"

/obj/item/storage/backpack/sport/white
	name = "white sports backpack"
	icon_state = "backsport_white"

/obj/item/storage/backpack/sport/fancy
	name = "fancy sports backpack"
	icon_state = "backsport_fancy"

/obj/item/storage/backpack/sport/vir
	name = "virologist sports backpack"
	desc = "A sterile sports backpack with virologist colours."
	icon_state = "backsport_green"

/obj/item/storage/backpack/sport/chem
	name = "chemist sports backpack"
	desc = "A sterile sports backpack with chemist colours."
	icon_state = "backsport_orange"

/obj/item/storage/backpack/sport/gen
	name = "geneticist sports backpack"
	desc = "A sterile sports backpack with geneticist colours."
	icon_state = "backsport_blue"

/obj/item/storage/backpack/sport/tox
	name = "scientist sports backpack"
	desc = "Useful for holding research materials."
	icon_state = "backsport_purple"

/obj/item/storage/backpack/sport/sec
	name = "security sports backpack"
	desc = "A robust sports backpack for security related needs."
	icon_state = "backsport_security"

/obj/item/storage/backpack/sport/hyd
	name = "hydroponics sports backpack"
	desc = "A green sports backpack for plant related work."
	icon_state = "backsport_hydro"

//Purses
/obj/item/storage/backpack/purse
	name = "purse"
	desc = "A small, fashionable bag typically worn over the shoulder."
	icon_state = "purse"
	item_state_slots = list(slot_r_hand_str = "lgpurse", slot_l_hand_str = "lgpurse")
	w_class = ITEMSIZE_LARGE
	max_w_class = ITEMSIZE_NORMAL
	max_storage_space = ITEMSIZE_COST_NORMAL * 5

//Parachutes
/obj/item/storage/backpack/parachute
	name = "parachute"
	desc = "A specially made backpack, designed to help one survive jumping from incredible heights. It sacrifices some storage space for that added functionality."
	icon_state = "parachute"
	item_state_slots = list(slot_r_hand_str = "backpack", slot_l_hand_str = "backpack")
	max_storage_space = ITEMSIZE_COST_NORMAL * 5

/obj/item/storage/backpack/parachute/examine(mob/user)
	. = ..()
	if(Adjacent(user))
		if(parachute)
			. += "It seems to be packed."
		else
			. += "It seems to be unpacked."

/obj/item/storage/backpack/parachute/handleParachute()
	parachute = FALSE	//If you parachute in, the parachute has probably been used.

/obj/item/storage/backpack/parachute/verb/pack_parachute()

	set name = "Pack/Unpack Parachute"
	set category = "Object"
	set src in usr

	if(!isliving(src.loc))
		return

	var/mob/living/carbon/human/H = usr

	if(!istype(H))
		return
	if(H.stat)
		return
	if(H.back == src)
		to_chat(H, span_warning("How do you expect to work on \the [src] while it's on your back?"))
		return

	if(!parachute)	//This packs the parachute
		H.visible_message(span_infoplain(span_bold("\The [H]") + " starts to pack \the [src]!"), \
					span_notice("You start to pack \the [src]!"), \
					span_infoplain("You hear the shuffling of cloth."))
		if(do_after(H, 50))
			H.visible_message(span_infoplain(span_bold("\The [H]") + " finishes packing \the [src]!"), \
					span_notice("You finish packing \the [src]!"), \
					span_infoplain("You hear the shuffling of cloth."))
			parachute = TRUE
		else
			H.visible_message(span_infoplain(span_bold("\The [src]") + " gives up on packing \the [src]!"), \
					span_notice("You give up on packing \the [src]!"))
			return
	else			//This unpacks the parachute
		H.visible_message(span_infoplain(span_bold("\The [src]") + " starts to unpack \the [src]!"), \
					span_notice("You start to unpack \the [src]!"), \
					span_infoplain("You hear the shuffling of cloth."))
		if(do_after(H, 25))
			H.visible_message(span_infoplain(span_bold("\The [src]") + " finishes unpacking \the [src]!"), \
					span_notice("You finish unpacking \the [src]!"), \
					span_infoplain("You hear the shuffling of cloth."))
			parachute = FALSE
		else
			H.visible_message(span_infoplain(span_bold("\The [src]") + " decides not to unpack \the [src]!"), \
					span_notice("You decide not to unpack \the [src]!"))
	return

/obj/item/storage/backpack/satchel/ranger
	name = "ranger satchel"
	desc = "A satchel designed for the Go Go ERT Rangers series to allow for slightly bigger carry capacity for the ERT-Rangers.\
		Unlike the show claims, it is not a phoron-enhanced satchel of holding with plot-relevant content."
	icon = 'icons/obj/clothing/ranger.dmi'
	icon_state = "ranger_satchel"
