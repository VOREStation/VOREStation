/obj/item/clothing/accessory/permit/gun/fluff
	owner = 1 // These permits already have owners.
	desc = "A card indicating that the owner is allowed to carry a firearm/sidearm. It is issued by CentCom, so it is valid until it expires. This one is just a sample, so it belongs to no one."

/obj/item/clothing/accessory/permit/gun/fluff/emag_act(var/remaining_charges, var/mob/user)
	to_chat(user, "You cannot reset the naming locks on [src]. It's issued by CentCom and totally tamper-proof!")
	return

/* Legacy Permits
// BEGIN - PROTOTYPE
/obj/item/clothing/accessory/permit/gun/fluff
	name = "Sample Permit"
	desc = {"There is a bright red "} + span_bold(span_red("SAMPLE PERMIT")) + {" stamped across the stock photo displayed on the card. Obviously this is only an example to educate security.
	"} + span_bold("NAME:") + {" First Last | "} + span_bold("RACE:") + {" Human | "} + span_bold("HOMEWORLD:") + {" Moon (if applicable), Planet, System
	"} + span_bold("DOB:") + {" DD/Mon/YYYY | "} + span_bold("HEIGHT:") + {" XXcm | "} + span_bold("SEX:") + {" Female

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
	"} + span_bold("NAME:") + {" Firstname Lastname | "} + span_bold("RACE:") + {" Human | "} + span_bold("HOMEWORLD:") + {" Earth, Sol
	"} + span_bold("DOB:") + {" DD/Mon/YYYY | "} + span_bold("HEIGHT:") + {" XXXcm | "} + span_bold("SEX:") + {" X

	The individual named above is licensed by the Nanotrasen Department of Civil Protection to openly carry XYZ. CONDITIONS.
	This license expires on DD/Mon/YYYY and must be renewed by CentCom prior to this date."}
*/
