/obj/item/clothing/mask/breath/transparent
	name = "transparent breath mask"
	item_state = "golem"  //This is dumb and hacky but was here when I got here.
	sprite_sheets = null

/obj/item/clothing/mask/altevian_breath
	name = "Spacer Tuned Mask"
	desc = "A mask designed for long-term use in areas where breathing comes at a premium."
	icon_state = "altevian-mask"
	icon = 'icons/inventory/face/item_vr.dmi'
	icon_override = 'icons/inventory/face/mob_vr.dmi'
	sprite_sheets = null
	item_state_slots = list(slot_r_hand_str = "breath", slot_l_hand_str = "breath")
	item_flags = AIRTIGHT|FLEXIBLEMATERIAL
	body_parts_covered = FACE
	w_class = ITEMSIZE_SMALL
	gas_transfer_coefficient = 0.10
	permeability_coefficient = 0.50
	species_restricted = list(SPECIES_ALTEVIAN)
	pickup_sound = 'sound/items/pickup/component.ogg'
	drop_sound = 'sound/items/drop/component.ogg'
