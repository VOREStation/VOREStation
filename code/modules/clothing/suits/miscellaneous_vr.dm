/obj/item/clothing/suit/customs
	desc = "A standard SolCom Customs formal jacket."

/obj/item/clothing/suit/chiton
	name = "chiton"
	desc = "A traditional piece of clothing from Greece."
	icon = 'icons/inventory/suit/item_vr.dmi'
	icon_state = "chiton"
	icon_override = 'icons/inventory/suit/mob_vr.dmi'

/obj/item/clothing/suit/oversize
	name = "oversized t-shirt"
	desc = "This ain't your daddy's shirt! Well, it might be..."
	icon = 'icons/inventory/suit/item_vr.dmi'
	icon_state = "oversize"
	icon_override = 'icons/inventory/suit/mob_vr.dmi'

//HERE BE TAUR RELATED CLOTHES

/*
 * Contains:
 *		Centaur Barding
 *		Drake cloak
 *		Centaur Wedding dress
 */


/obj/item/clothing/suit/drake_cloak
	name = "drake cloak"
	desc = "A simple cloak for drake-taurs."
	icon = 'icons/mob/taursuits_drake_vr.dmi'
	icon_state = "cloak"
	item_state_slots = list(slot_r_hand_str = "capjacket", slot_l_hand_str = "capjacket")
	body_parts_covered = UPPER_TORSO|ARMS
	pixel_x = -16

/obj/item/clothing/suit/drake_cloak/mob_can_equip(var/mob/living/carbon/human/H, slot, disable_warning = 0)
	if(..())
		if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/drake))
			return ..()
		else
			to_chat(H, "<span class='warning'>You need to have a drake-taur half to wear this.</span>")
			return 0

/obj/item/clothing/suit/barding
	description_info = "You need to be a horsy to wear that."
	icon = 'icons/mob/taursuits_horse_vr.dmi'
	item_state_slots = list(slot_r_hand_str = "capjacket", slot_l_hand_str = "capjacket")
	body_parts_covered = UPPER_TORSO|ARMS|LOWER_TORSO|LEGS
	pixel_x = -16
	armor = list(melee = 5, bullet = 5, laser = 5, energy = 5, bomb = 5, bio = 0, rad = 0)//Minor armor for fluff.

/obj/item/clothing/suit/barding/mob_can_equip(var/mob/living/carbon/human/H, slot, disable_warning = 0)
	if(..())
		if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/horse))
			return ..()
		else
			to_chat(H, "<span class='warning'>You need to have a horse-taur half to wear this.</span>")
			return 0

//Bardings are medieval suits of armor.
/obj/item/clothing/suit/barding/agatha
	name = "Agatha barding"
	desc = "Knightly armor for a mount who doesn't need any rider. This one is marked to the house of Agatha."
	icon_state = "Agatha_barding"

/obj/item/clothing/suit/barding/alt_agatha
	name = "Agatha barding"
	desc = "Knightly armor for a mount who doesn't need any rider. This one is marked to the house of Agatha."
	icon_state = "Agatha_barding_alt"

/obj/item/clothing/suit/barding/mason
	name = "Mason barding"
	desc = "Knightly armor for a mount who doesn't need any rider. This one is marked to the house of Mason."
	icon_state = "Mason_barding"

/obj/item/clothing/suit/taur
	icon = 'icons/mob/taursuits_horse_vr.dmi'
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	pixel_x = -16

/obj/item/clothing/suit/taur/dress
	name = "white wedding dress"
	desc = "A fancy white dress with a blue underdress."
	icon_state = "whitedress1"
	flags_inv = HIDESHOES

/obj/item/clothing/suit/storage/det_trench/alt
	name = "sleek modern coat"
	desc = "A sleek overcoat made of neo-laminated fabric. Has a reasonably sized pocket on the inside."

	icon = 'icons/inventory/suit/item_vr.dmi'
	default_worn_icon = 'icons/inventory/suit/mob_vr.dmi'
	icon_state = "cyberpunksleek"

/obj/item/clothing/suit/storage/det_trench/alt2
	name = "sleek modern coat (long)"
	desc = "A sleek long overcoat made of neo-laminated fabric. Has a reasonably sized pocket on the inside."

	icon = 'icons/inventory/suit/item_vr.dmi'
	default_worn_icon = 'icons/inventory/suit/mob_vr.dmi'
	icon_state = "cyberpunksleek_long"

/obj/item/clothing/suit/storage/det_trench/alt/black
	icon_state = "cyberpunksleek_black"

/obj/item/clothing/suit/storage/det_trench/alt2/black
	icon_state = "cyberpunksleek_long_black"

//Talon Hoodie
/obj/item/clothing/suit/storage/toggle/hoodie/talon
	name = "Talon hoodie"
	desc = "A warm, blue sweatshirt bearing ITV Talon markings."
	icon = 'icons/inventory/suit/item_vr.dmi'
	icon_override = 'icons/inventory/suit/mob_vr.dmi'
	icon_state = "talonhoodie"
	item_state_slots = list(slot_r_hand_str = "suit_blue", slot_l_hand_str = "suit_blue")

// Bladerunner coat
/obj/item/clothing/suit/storage/bladerunner
	name = "leather coat"
	desc = "An old leather coat. Has probably seen things you wouldn't believe."

	icon = 'icons/inventory/suit/item_vr.dmi'
	default_worn_icon = 'icons/inventory/suit/mob_vr.dmi'
	icon_state = "bladerunner_coat"

// Cyberpunk 'orange' vest
/obj/item/clothing/suit/cyberpunk
	name = "cyberpunk vest"
	desc = "A red vest with golden streaks. It's made out of tough materials, and can protect fairly well against bullets. Wake the fuck up, Samurai."

	icon = 'icons/inventory/suit/item_vr.dmi'
	default_worn_icon = 'icons/inventory/suit/mob_vr.dmi'
	icon_state = "cyberpunk"
	armor = list("melee" = 10, "bullet" = 20, "laser" = 10, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0)
