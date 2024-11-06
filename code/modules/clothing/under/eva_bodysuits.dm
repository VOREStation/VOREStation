/obj/item/clothing/under/undersuit // undersuits! intended for wearing under hardsuits or for being too lazy to not wear anything other than it
	name = "undersuit"
	desc = "A nondescript undersuit, intended for wearing under a voidsuit or other EVA equipment. Breathable, yet sleek."
	icon = 'icons/inventory/uniform/item_vr.dmi'
	default_worn_icon = 'icons/inventory/uniform/mob_vr.dmi'
	rolled_down_icon = 'icons/inventory/uniform/mob_vr_rolled_down.dmi'
	icon_state = "bodysuit"
	item_state = "bodysuit"
	rolled_sleeves = -1
	rolled_down_icon_override = FALSE

/obj/item/clothing/under/undersuit/eva
	name = "EVA undersuit"
	desc = "A nondescript undersuit, intended for wearing under a voidsuit or other EVA equipment. This one is specifically made for EVA usage, but differs little from the standard."
	icon_state = "bodysuit_eva"
	item_state = "bodysuit_eva"

/obj/item/clothing/under/undersuit/command
	name = "command undersuit"
	desc = "A fancy undersuit, intended for wearing under a voidsuit or other EVA equipment. This one is specifically made for those in Command, and comes with a swanky gold trim and navy blue inlay."
	icon_state = "bodysuit_com"
	item_state = "bodysuit_com"

/obj/item/clothing/under/undersuit/sec
	name = "security undersuit"
	desc = "A reinforced undersuit, intended for wearing under a voidsuit or other EVA equipment. This one is specifically made for those in Security, and has slight protective capabilities against simple melee attacks."
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9
	icon_state = "bodysuit_sec"
	item_state = "bodysuit_sec"

/obj/item/clothing/under/undersuit/sec/hos
	name = "security command undersuit"
	desc = "A reinforced undersuit, intended for wearing under a voidsuit or other EVA equipment. This one is specifically made for the " + JOB_HEAD_OF_SECURITY + " or equivalent, and has slight protective capabilities against simple melee attacks."
	icon_state = "bodysuit_seccom"
	item_state = "bodysuit_seccom"

/obj/item/clothing/under/undersuit/hazard
	name = "hazard undersuit"
	desc = "An undersuit, intended for wearing under a voidsuit or other EVA equipment. This one is specifically made for Engineering crew, and comes with slight radiation absorption capabilities. Not a lot, but it's there."
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 10)
	icon_state = "bodysuit_haz"
	item_state = "bodysuit_haz"

/obj/item/clothing/under/undersuit/mining
	name = "mining undersuit"
	desc = "An undersuit, intended for wearing under a voidsuit or other EVA equipment. This one is specifically made for Mining crew, and comes with an interestingly colored trim."
	icon_state = "bodysuit_min"
	item_state = "bodysuit_min"

/obj/item/clothing/under/undersuit/emt
	name = "medical technician undersuit"
	desc = "An undersuit, intended for wearing under a voidsuit or other EVA equipment. This one is specifically made for Medical response crew, and comes with a distinctive coloring scheme."
	icon_state = "bodysuit_emt"
	item_state = "bodysuit_emt"

/obj/item/clothing/under/undersuit/explo
	name = "exploration undersuit"
	desc = "An undersuit, intended for wearing under a voidsuit or other EVA equipment. This one is specifically made for Exploration crew, for hazardous environments."
	icon_state = "bodysuit_exp"
	item_state = "bodysuit_exp"

/obj/item/clothing/under/undersuit/centcom
	name = "Central Command undersuit"
	desc = "A very descript undersuit, intended for wearing under a voidsuit or other EVA equipment. This one is specifically made for NanoTrasen Central Command officers, and comes with a swanky gold trim and other fancy markings."
	icon_state = "bodysuit_cent"
	item_state = "bodysuit_cent"

/obj/item/clothing/under/undersuit/alt
	name = "alternate undersuit"
	desc = "A skin-tight synthetic bodysuit designed for comfort and mobility underneath hardsuits and voidsuits. This basic version is a sleek onyx grey comes with the standard induction ports."
	icon_state = "altbodysuit"
	item_state = "altbodysuit"

/obj/item/clothing/under/undersuit/alt/sleeveless
	name = "alternate undersuit, sleeveless"
	desc = "A skin-tight synthetic bodysuit designed for comfort and mobility underneath hardsuits and voidsuits. This one is designed to stop at the mid-bicep, allowing total freedom to the wearer's forearms."
	item_state = "altbodysuit_sleeveless"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/under/undersuit/alt/fem
	name = "alternate undersuit, feminine"
	desc = "A skin-tight synthetic bodysuit designed for comfort and mobility underneath hardsuits and voidsuits. This basic version is a sleek onyx grey comes with the standard induction ports."
	item_state = "altbodysuitfem"

/obj/item/clothing/under/undersuit/alt/sleeveless/fem
	name = "alternate undersuit, feminine sleeveless"
	desc = "A skin-tight synthetic bodysuit designed for comfort and mobility underneath hardsuits and voidsuits. This one is designed to stop at the mid-bicep, allowing total freedom to the wearer's forearms."
	item_state = "altbodysuitfem_sleeveless"
