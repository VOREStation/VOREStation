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

/obj/item/clothing/suit/taur_dress
	icon = 'icons/mob/taursuits_horse_vr.dmi'
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	pixel_x = -16

/obj/item/clothing/suit/taur_dress/white
	name = "white wedding dress"
	desc = "A fancy white dress with a blue underdress."
	icon_state = "whitedress1"
	flags_inv = HIDESHOES

