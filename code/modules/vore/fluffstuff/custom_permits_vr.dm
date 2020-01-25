/obj/item/clothing/accessory/permit/gun/fluff
	owner = 1 // These permits already have owners.
	desc = "A card indicating that the owner is allowed to carry a firearm/sidearm. It is issued by CentCom, so it is valid until it expires. This one is just a sample, so it belongs to no one."

/obj/item/clothing/accessory/permit/gun/fluff/emag_act(var/remaining_charges, var/mob/user)
	to_chat(user, "You cannot reset the naming locks on [src]. It's issued by CentCom and totally tamper-proof!")
	return

//TFF 28/11/19 - Remove expired permit
/*
// jertheace:Jeremiah 'Ace' Acacius
/obj/item/clothing/accessory/permit/gun/fluff/ace
	name = "Jeremiah Acacius's Sidearm Permit"
	desc = "A card indicating that the owner is allowed to carry a sidearm. It is issued by CentCom, so it is valid until it expires on November 10th, 2563."
*/

// ValiTheWolf: Vakashi
/obj/item/clothing/accessory/permit/gun/fluff/Vakashi
	name = "Vakashi's Sidearm Permit"
	desc = "A card indicating that the owner is allowed to carry a sidearm that uses less-than-lethal munitions. It is issued by CentCom, so it is valid until it expires on March 1st, 2564."

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
