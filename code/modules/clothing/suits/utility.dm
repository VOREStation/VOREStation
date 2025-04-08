/*
 * Contains:
 *		Fire protection
 *		Bomb protection
 *		Radiation protection
 */

/*
 * Fire protection
 */

/obj/item/clothing/suit/fire
	name = "emergency firesuit"
	desc = "A suit that protects against fire and heat."
	icon_state = "firesuit"
	item_state_slots = list(slot_r_hand_str = "black_suit", slot_l_hand_str = "black_suit")
	w_class = ITEMSIZE_LARGE//bulky item
	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.50
	body_parts_covered = CHEST|LEGS|FEET|ARMS|HANDS
	allowed = list(POCKET_GENERIC, POCKET_EMERGENCY, /obj/item/extinguisher)
	slowdown = 1.0
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL|HIDETIE|HIDEHOLSTER
	item_flags = 0
	heat_protection = CHEST|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	cold_protection = CHEST|LEGS|FEET|ARMS|HANDS
	min_pressure_protection = 0.2 * ONE_ATMOSPHERE
	max_pressure_protection = 20  * ONE_ATMOSPHERE

/obj/item/clothing/suit/fire/firefighter
	name = "firesuit"
	icon_state = "firesuit2"
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE+5000

/obj/item/clothing/suit/fire/heavy
	name = "atmospheric firesuit"
	desc = "A suit that protects against extreme fire and heat."
	icon_state = "atmos_firesuit"
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE+10000
	slowdown = 1.5

/*
 * Bomb protection
 */
/obj/item/clothing/head/bomb_hood
	name = "bomb hood"
	desc = "Use in case of bomb."
	icon_state = "bombsuit"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 100, bio = 0, rad = 0)
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|BLOCKHAIR
	body_parts_covered = HEAD|FACE|EYES
	siemens_coefficient = 0

/obj/item/clothing/suit/bomb_suit
	name = "bomb suit"
	desc = "A suit designed for safety when handling explosives."
	icon_state = "bombsuit"
	w_class = ITEMSIZE_LARGE//bulky item
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	slowdown = 2
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 100, bio = 0, rad = 0)
	flags_inv = HIDEJUMPSUIT|HIDETAIL|HIDETIE|HIDEHOLSTER
	heat_protection = CHEST|LEGS|FEET|ARMS|HANDS
	cold_protection = CHEST|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = ARMOR_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0

/obj/item/clothing/head/bomb_hood/security
	icon_state = "bombsuitsec"
	body_parts_covered = HEAD

/obj/item/clothing/suit/bomb_suit/security
	icon_state = "bombsuitsec"
	allowed = list(POCKET_SECURITY)
	body_parts_covered = CHEST|LEGS|FEET|ARMS|HANDS

/*
 * Radiation protection
 */
/obj/item/clothing/head/radiation
	name = "Radiation hood"
	icon_state = "rad"
	desc = "A hood with radiation protective properties. Label: Made with lead, do not eat insulation"
	flags_inv = BLOCKHAIR
	item_flags = THICKMATERIAL
	body_parts_covered = HEAD|FACE|EYES
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 60, rad = 100)

/obj/item/clothing/suit/radiation
	name = "Radiation suit"
	desc = "A suit that protects against radiation. Label: Made with lead, do not eat insulation."
	icon_state = "rad"
	w_class = ITEMSIZE_LARGE//bulky item
	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.50
	body_parts_covered = CHEST|LEGS|ARMS|HANDS|FEET
	allowed = list(POCKET_GENERIC, POCKET_EMERGENCY, /obj/item/clothing/head/radiation)
	slowdown = 1.5
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 60, rad = 100)
	flags_inv = HIDEJUMPSUIT|HIDETAIL|HIDETIE|HIDEHOLSTER
	item_flags = THICKMATERIAL

/obj/item/clothing/suit/radiation/teshari
	name = "Small radiation suit"
	desc = "A specialist suit that protects against radiation, designed specifically for use by Teshari. Made to order by Aether."
	icon = 'icons/inventory/suit/item_teshari.dmi'
	icon_override = 'icons/inventory/suit/mob_teshari.dmi'
	icon_state = "rad_fitted"
	species_restricted = list(SPECIES_TESHARI)
	slowdown = 0.5

/obj/item/clothing/head/radiation/teshari
	name = "Small radiation hood"
	desc = "A specialist hood with radiation protective properties, designed specifically for use by Teshari. Made to order by Aether."
	icon = 'icons/inventory/head/item_teshari.dmi'
	icon_override = 'icons/inventory/head/mob_teshari.dmi'
	icon_state = "rad_fitted"
	species_restricted = list(SPECIES_TESHARI)
