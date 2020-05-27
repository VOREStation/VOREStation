/obj/item/clothing/head/helmet/space/void/captain
	name = "\improper director helmet"
	desc = "A special helmet designed for work in a hazardous, low pressure environment. This model sacrifices mobility for even more armor."
	icon_state = "capvoid"
	item_state_slots = list(slot_r_hand_str = "sec_helm", slot_l_hand_str = "sec_helm")
	armor = list(melee = 60, bullet = 35, laser = 35, energy = 15, bomb = 55, bio = 100, rad = 20)

/obj/item/clothing/suit/space/void/captain
	name = "\improper director armor"
	desc = "A special suit that protects against hazardous, low pressure environments. This model sacrifices mobility for even more armor."
	icon_state = "capsuit_void"
	item_state_slots = list(slot_r_hand_str = "sec_voidsuit", slot_l_hand_str = "sec_voidsuit")
	slowdown = 1.5
	armor = list(melee = 60, bullet = 35, laser = 35, energy = 15, bomb = 55, bio = 100, rad = 20)

/obj/item/clothing/head/helmet/space/void/merc/prototype
	name = "\improper prototype voidsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low pressure environment. This is an advanced model commonly used by militaries and emergency response."
	icon_state = "hosproto"

/obj/item/clothing/suit/space/void/merc/prototype
	name = "\improper prototype voidsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. This is an advanced model commonly used by militaries and emergency response."
	icon_state = "hosproto_void"

/obj/item/clothing/head/helmet/space/void/merc/odst
	name = "\improper ODST Helmet"
	desc = "<i>\"... we are glad to plunge feet first into hell in the knowledge that we will rise.\"</i>"
	icon_state = "rig0-odst"
	item_state = "rig0-odst"
	item_state_slots = null
	icon = 'icons/obj/clothing/hats_vr.dmi'
	icon_override = 'icons/mob/head_vr.dmi'
	light_overlay = "helmet_light_dual"
	species_restricted = null

/*/obj/item/clothing/head/helmet/space/void/merc/odst/jertheace // Given to Acacius during an event. Save this for use in events.
	name = "\improper Ace's ODST Helmet"
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "rig0-odst_ace"
	desc = "Etched under the inner visor is the phrase <i>\"Don’t let your past define you; let it mold you into the person you want to be.\"</i>"
	icon = 'icons/obj/clothing/hats_vr.dmi'
	icon_override = 'icons/mob/head_vr.dmi'*/

/obj/item/clothing/suit/space/void/merc/odst
	name = "ODST Armor"
	desc = "<i>\"... we are glad to plunge feet first into hell in the knowledge that we will rise.\"</i>"
	icon_state = "odst"
	item_state = "odst"
	item_state_slots = null
	icon = 'icons/obj/clothing/suits_vr.dmi'
	icon_override = 'icons/mob/suit_vr.dmi'
	species_restricted = null
