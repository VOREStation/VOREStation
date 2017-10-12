/obj/item/clothing/accessory/permit/gun/fluff
	owner = 1 // These permits already have owners.
	desc = "A card indicating that the owner is allowed to carry a firearm/sidearm. It is issued by CentCom, so it is valid until it expires. This one is just a sample, so it belongs to no one."

/obj/item/clothing/accessory/permit/gun/fluff/emag_act(var/remaining_charges, var/mob/user)
	to_chat(user, "You cannot reset the naming locks on [src]. It's issued by CentCom and totally tamper-proof!")
	return

// aerowing:Sebastian Aji
/obj/item/clothing/accessory/permit/gun/fluff/sebastian_aji
	name = "Sebastian Aji's Sidearm Permit"
	desc = "A card indicating that the owner is allowed to carry a sidearm. It is issued by CentCom, so it is valid until it expires on April 17th, 2562."

// arokha:Aronai Kadigan
/obj/item/clothing/accessory/permit/gun/fluff/aronai_kadigan
	name = "Aronai Kadigan's Sidearm Permit"
	desc = "A card indicating that the owner is allowed to carry a sidearm. It is issued by CentCom, so it is valid until it expires on February 16th, 2562."

// bwoincognito:Tasald Corlethian
/obj/item/clothing/accessory/permit/gun/fluff/tasald_corlethian
	name = "Tasald Ajax Corlethian's Sidearm Permit"
	desc = "A card indicating that the owner is allowed to carry a sidearm. It is issued by CentCom, so it is valid until it expires on August 2nd, 2562."

// dhaeleena:Dhaeleena M'iar
/obj/item/clothing/accessory/permit/gun/fluff/dhaeleena_miar
	name = "Dhaeleena M'iar's Sidearm Permit"
	desc = "A card indicating that the owner is allowed to carry a sidearm that uses less-than-lethal munitions. It is issued by CentCom, so it is valid until it expires on March 1st, 2562."

// jertheace:Jeremiah 'Ace' Acacius
/obj/item/clothing/accessory/permit/gun/fluff/ace
	name = "Ace's Shotgun Permit"
	desc = "A card indicating that the owner is allowed to carry a firearm. It is issued by CentCom, so it is valid until it expires on October 1st, 2562."

// joanrisu:Joan Risu
/obj/item/clothing/accessory/permit/gun/fluff/joanrisu
	name = "Joan Risu's Sidearm Permit"
	desc = "A card indicating that the owner is allowed to carry a sidearm. It is issued by CentCom, so it is valid until it expires on April 4th, 2562."

// luminescent_ring:Briana Moore
/obj/item/clothing/accessory/permit/gun/fluff/briana_moore
	name = "Briana Moore's Sidearm Permit"
	desc = "A card indicating that the owner is allowed to carry a sidearm. It is issued by CentCom, so it is valid until it expires on April 24th, 2562."

// silenedmp5a5:Serdykov Antoz
/obj/item/clothing/accessory/permit/gun/fluff/silencedmp5a5
	name = "Serdykov Antoz's Sidearm Permit"
	desc = "A card indicating that the owner is allowed to carry a sidearm that uses less-than-lethal munitions. It is issued by CentCom, so it is valid until it expires on April 24th, 2562."

// pawoverlord:Sorrel Cavalet
/obj/item/clothing/accessory/permit/gun/fluff/sorrel_cavalet
	name = "Sorrel Cavalet's Sidearm Permit"
	desc = "A card indicating that the owner is allowed to carry a sidearm. It is issued by CentCom, so it is valid until it expires on September 26th, 2562."

/* Legacy Permits
// BEGIN - PROTOTYPE
/obj/item/clothing/accessory/permit/gun/fluff
	name = "Sample Permit"
	desc = {"There is a bright red <b><font color=red>SAMPLE PERMIT</font></b> stamped across the stock photo displayed on the card. Obviously this is only an example to educate security.
	<b>NAME:</b> First Last | <b>RACE:</b> Human | <b>HOMEWORLD:</b> Moon (if applicable), Planet, System
	<b>DOB:</b> DD/Mon/YYYY | <b>HEIGHT:</b> XXcm | <b>SEX:</b> Female

	The individual named above is licensed by the Nanotrasen Department of Civil Protection to ______.
	This license expires on DD/Month/YYYY and must be renewed by CentCom prior to this date."}
	icon = 'icons/obj/card.dmi'
	icon_state = "guest"
	w_class = ITEMSIZE_TINY
// END - PROTOTYPE
*/

/* OLD TEMPLATE
/obj/item/clothing/accessory/permit/gun/fluff/charactername
	name = "Name's Thing Permit"
	desc = {"
	<b>NAME:</b> Firstname Lastname | <b>RACE:</b> Human | <b>HOMEWORLD:</b> Earth, Sol
	<b>DOB:</b> DD/Mon/YYYY | <b>HEIGHT:</b> XXXcm | <b>SEX:</b> X

	The individual named above is licensed by the Nanotrasen Department of Civil Protection to openly carry XYZ. CONDITIONS.
	This license expires on DD/Mon/YYYY and must be renewed by CentCom prior to this date."}
*/
