/obj/item/clothing/suit/armor/heavy
	name = "heavy armor"
	desc = "An old military-grade suit of armor. Incredibly robust against brute force damage! However, it offers little protection from energy-based weapons, which, combined with its bulk, makes it woefully obsolete."
	icon_state = "heavy"
	item_state_slots = list(slot_r_hand_str = "swat", slot_l_hand_str = "swat")
	armor = list(melee = 90, bullet = 80, laser = 10, energy = 10, bomb = 80, bio = 0, rad = 0)
	w_class = 5 // massively bulky item
	gas_transfer_coefficient = 0.90
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	slowdown = 5 // If you're a tank you're gonna move like a tank.
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	siemens_coefficient = 0



/obj/item/clothing/suit/armor/vest/wolftaur
	name = "wolf-taur armor vest"
	desc = "An armored vest that protects against some damage. It appears to be created for a wolf-taur."
	species_restricted = null //Species restricted since all it cares about is a taur half
	icon_override = 'icons/mob/taursuits_vr.dmi'
	icon_state = "heavy_wolf_armor"
	mob_can_equip(var/mob/living/carbon/human/H, slot, disable_warning = 0)
		if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/wolf))
			icon_override = 'icons/mob/taursuits_vr.dmi' //Just in case
			icon_state = "heavy_wolf_armor" //Just in case
			pixel_x = -16
			return 1
		else
			H << "<span class='warning'>You need to have a wolf-taur half to wear this.</span>"
			return 0