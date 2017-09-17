/*
 * Contains:
 *		Bomb protection
 *		Radiation protection
 */

/*
 * Bomb protection
 */

/obj/item/clothing/suit/bomb_suit/taur
	name = "taur specific bomb suit"
	desc = "A suit designed for safety when handling explosives. It has a sticker saying one size fits all taurs on it. Below the sticker, it states that it only fits horses, wolves, and naga taurs."
	w_class = ITEMSIZE_LARGE//bulky item
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	slowdown = 2
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 100, bio = 0, rad = 0)
	flags_inv = HIDEJUMPSUIT|HIDETAIL|HIDETIE|HIDEHOLSTER
	heat_protection = UPPER_TORSO|LOWER_TORSO
	max_heat_protection_temperature = ARMOR_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0

	species_restricted = null
	mob_can_equip(var/mob/living/carbon/human/H, slot, disable_warning = 0)
		if(..())
			if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/horse))
				icon = 'icons/mob/taursuits_vr.dmi'
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "bombsuit-horse"
				item_state = "bombsuit-horse"
				pixel_x = -16
				return 1
			else if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/wolf))
				icon = 'icons/mob/taursuits_vr.dmi'
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "bombsuit-wolf"
				item_state = "bombsuit-wolf"
				pixel_x = -16
				return 1
			else if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/naga))
				icon = 'icons/mob/taursuits_vr.dmi'
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "bombsuit-naga"
				item_state = "bombsuit-naga"
				pixel_x = -16
				return 1
			else
				H << "<span class='warning'>You need to have a horse, wolf, or naga half to wear this.</span>"
				return 0


/obj/item/clothing/head/bomb_hood/security
	icon_state = "bombsuitsec"
	body_parts_covered = HEAD

/obj/item/clothing/suit/bomb_suit/taur/security
	allowed = list(/obj/item/weapon/gun/energy,/obj/item/weapon/melee/baton,/obj/item/weapon/handcuffs)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	species_restricted = null
	mob_can_equip(var/mob/living/carbon/human/H, slot, disable_warning = 0)
		if(..())
			if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/horse))
				icon = 'icons/mob/taursuits_vr.dmi'
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "bombsuit-horse"
				item_state = "bombsuit-horse"
				pixel_x = -16
				return 1
			else if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/wolf))
				icon = 'icons/mob/taursuits_vr.dmi'
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "bombsuit-wolf"
				item_state = "bombsuit-wolf"
				pixel_x = -16
				return 1
			else if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/naga))
				icon = 'icons/mob/taursuits_vr.dmi'
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "bombsuit-naga"
				item_state = "bombsuit-naga"
				pixel_x = -16
				return 1
			else
				H << "<span class='warning'>You need to have a horse, wolf, or naga half to wear this.</span>"
				return 0

/*
 * Radiation protection
 */

/obj/item/clothing/suit/radiation/taur
	name = "taur specific radiation suit"
	desc = "A suit that protects against radiation. Label: Made with lead, do not eat insulation. It has a sticker saying one size fits all taurs on it. Below the sticker, it states that it only fits horses, wolves, and naga taurs."
	w_class = ITEMSIZE_LARGE//bulky item
	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.50
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS|HANDS|FEET
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/emergency/oxygen,/obj/item/clothing/head/radiation,/obj/item/clothing/mask/gas)
	slowdown = 1.5
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 60, rad = 100)
	flags_inv = HIDEJUMPSUIT|HIDETAIL|HIDETIE|HIDEHOLSTER

	species_restricted = null
	mob_can_equip(var/mob/living/carbon/human/H, slot, disable_warning = 0)
		if(..())
			if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/horse))
				icon = 'icons/mob/taursuits_vr.dmi'
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "radsuit-horse"
				item_state = "radsuit-horse"
				pixel_x = -16
				return 1
			else if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/wolf))
				icon = 'icons/mob/taursuits_vr.dmi'
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "radsuit-wolf"
				item_state = "radsuit-wolf"
				pixel_x = -16
				return 1
			else if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/naga))
				icon = 'icons/mob/taursuits_vr.dmi'
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "radsuit-naga"
				item_state = "radsuit-naga"
				pixel_x = -16
				return 1
			else
				H << "<span class='warning'>You need to have a horse, wolf, or naga half to wear this.</span>"
				return 0