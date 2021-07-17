/obj/item/clothing/head/helmet/space/void/captain
	name = "\improper manager helmet"
	desc = "A special helmet designed for work in a hazardous, low pressure environment. This model sacrifices mobility for even more armor."
	icon_state = "capvoid"
	item_state_slots = list(slot_r_hand_str = "sec_helm", slot_l_hand_str = "sec_helm")
	armor = list(melee = 60, bullet = 35, laser = 35, energy = 15, bomb = 55, bio = 100, rad = 20)

/obj/item/clothing/suit/space/void/captain
	name = "\improper manager armor"
	desc = "A special suit that protects against hazardous, low pressure environments. This model sacrifices mobility for even more armor."
	icon_state = "capsuit_void"
	item_state_slots = list(slot_r_hand_str = "sec_voidsuit", slot_l_hand_str = "sec_voidsuit")
	slowdown = 1.5
	armor = list(melee = 60, bullet = 35, laser = 35, energy = 15, bomb = 55, bio = 100, rad = 20)
	breach_threshold = 14 //These are kinda thicc
	resilience = 0.15 //Armored

/obj/item/clothing/head/helmet/space/void/security/prototype
	name = "\improper security prototype voidsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low pressure environment. It's a little ostentatious, but it gets the job done."
	icon_state = "hosproto"

/obj/item/clothing/suit/space/void/security/prototype
	name = "\improper security prototype voidsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. It's a little ostentatious, but it gets the job done."
	icon_state = "hosproto_void"

/obj/item/clothing/head/helmet/space/void/merc/odst
	name = "\improper ODST Helmet"
	desc = "<i>\"... we are glad to plunge feet first into hell in the knowledge that we will rise.\"</i>"
	icon_state = "rig0-odst"
	item_state = "rig0-odst"
	item_state_slots = null
	icon = 'icons/inventory/head/item_vr.dmi'
	icon_override = 'icons/inventory/head/mob_vr.dmi'
	light_overlay = "helmet_light_dual"
	species_restricted = null

/*/obj/item/clothing/head/helmet/space/void/merc/odst/jertheace // Given to Acacius during an event. Save this for use in events.
	name = "\improper Ace's ODST Helmet"
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "rig0-odst_ace"
	desc = "Etched under the inner visor is the phrase <i>\"Don�t let your past define you; let it mold you into the person you want to be.\"</i>"
	icon = 'icons/inventory/head/item_vr.dmi'
	icon_override = 'icons/inventory/head/mob_vr.dmi'*/

/obj/item/clothing/suit/space/void/merc/odst
	name = "ODST Armor"
	desc = "<i>\"... we are glad to plunge feet first into hell in the knowledge that we will rise.\"</i>"
	icon_state = "odst"
	item_state = "odst"
	item_state_slots = null
	icon = 'icons/inventory/suit/item_vr.dmi'
	icon_override = 'icons/inventory/suit/mob_vr.dmi'
	species_restricted = null
	breach_threshold = 16 //Extra Thicc
	resilience = 0.05 //Military Armor

