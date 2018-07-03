/obj/item/clothing/suit/armor/heavy
	name = "heavy armor"
	desc = "An old military-grade suit of armor. Incredibly robust against brute force damage! However, it offers little protection from energy-based weapons, which, combined with its bulk, makes it woefully obsolete."
	icon_state = "heavy"
	item_state_slots = list(slot_r_hand_str = "swat", slot_l_hand_str = "swat")
	armor = list(melee = 90, bullet = 80, laser = 10, energy = 10, bomb = 80, bio = 0, rad = 0)
	w_class = ITEMSIZE_HUGE // massively bulky item
	gas_transfer_coefficient = 0.90
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	slowdown = 5 // If you're a tank you're gonna move like a tank.
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	siemens_coefficient = 0


/obj/item/clothing/suit/armor/vest/wolftaur
	name = "wolf-taur armor vest"
	desc = "An armored vest that protects against some damage. It appears to be created for a wolf-taur."
	species_restricted = null //Species restricted since all it cares about is a taur half
	icon = 'icons/mob/taursuits_wolf_vr.dmi'
	icon_state = "heavy_wolf_armor"
	item_state = "heavy_wolf_armor"
	mob_can_equip(var/mob/living/carbon/human/H, slot, disable_warning = 0)
		if(..())
			if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/wolf))
				return ..()
			else
				to_chat(H,"<span class='warning'>You need to have a wolf-taur half to wear this.</span>")
				return 0

// HoS armor improved by Vorestation to be slightly better than normal security stuff.
/obj/item/clothing/suit/storage/vest/hoscoat
	armor = list(melee = 50, bullet = 40, laser = 40, energy = 25, bomb = 25, bio = 0, rad = 0)

/obj/item/clothing/suit/storage/vest/hos
	armor = list(melee = 50, bullet = 40, laser = 40, energy = 25, bomb = 25, bio = 0, rad = 0)

/obj/item/clothing/suit/storage/vest/hoscoat/jensen
	name = "armored trenchcoat"
	desc = "A trenchcoat augmented with a special alloy for some protection and style."
	icon_state = "hostrench"
	flags_inv = HIDEHOLSTER

// Override Polaris's "confederate" naming convention. I hate it.
/obj/item/clothing/suit/storage/vest/solgov
	name = "\improper Solar Central Government armored vest"
	desc = "A synthetic armor vest. This one is marked with the crest of the Solar Central Government."

/obj/item/clothing/suit/storage/vest/solgov/heavy
	name = "\improper Solar Central Government heavy armored vest"
	desc = "A synthetic armor vest with SECURITY printed in distinctive blue lettering on the chest. This one has added webbing and ballistic plates." // USDF does peacekeeping, not these guys.

/obj/item/clothing/suit/storage/vest/solgov/security
	name = "master at arms heavy armored vest"
	desc = "A synthetic armor vest with MASTER AT ARMS printed in silver lettering on the chest. This one has added webbing and ballistic plates."

/obj/item/clothing/suit/storage/vest/solgov/command
	name = "command heavy armored vest"
	desc = "A synthetic armor vest with Solar Central Government printed in detailed gold lettering on the chest. This one has added webbing and ballistic plates."

/obj/item/clothing/suit/armor/combat/USDF
	name = "marine body armor"
	desc = "When I joined the Corps, we didn't have any fancy-schmanzy armor. We had sticks! Two sticks, and a rock for the whole platoon–and we had to <i>share</i> the rock!"
	icon_state = "unsc_armor"
	icon = 'icons/obj/clothing/suits_vr.dmi'
	icon_override = 'icons/mob/suit_vr.dmi'
	body_parts_covered = UPPER_TORSO|LOWER_TORSO // ToDo: Break up the armor into smaller bits.

/obj/item/clothing/suit/armor/combat/imperial
	name = "imperial soldier armor"
	desc = "Made out of an especially light metal, it lets you conquer in style."
	icon_state = "ge_armor"
	icon = 'icons/obj/clothing/suits_vr.dmi'
	icon_override = 'icons/mob/suit_vr.dmi'
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/suit/armor/combat/imperial/centurion
	name = "imperial centurion armor"
	desc = "Not all heroes wear capes, but it'd be cooler if they did."
	icon_state = "ge_armorcent"