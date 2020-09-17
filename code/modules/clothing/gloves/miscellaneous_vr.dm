/obj/item/clothing/gloves/color
	desc = "A pair of gloves, they don't look special in any way."
	item_state_slots = list(slot_r_hand_str = "white", slot_l_hand_str = "white")
	icon_state = "latex"

// Armor Versions Here
/obj/item/clothing/gloves/combat/knight
	desc = "ye olde armored gauntlets"
	name = "knight gauntlets"
	icon_state = "black"
	item_state = "black"
	siemens_coefficient = 2
	permeability_coefficient = 0.05
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROTECTION_TEMPERATURE
	armor = list(melee = 80, bullet = 50, laser = 10, energy = 0, bomb = 0, bio = 0, rad = 0)
	
/obj/item/clothing/gloves/combat/knight/brown
	desc = "ye olde armored gauntlets"
	name = "knight gauntlets"
	icon_state = "brown"
	item_state = "brown"

// Costume Versions Here
/obj/item/clothing/gloves/combat/knight_costume
	desc = "ye olde armored gauntlets"
	name = "knight gauntlets"
	icon_state = "black"
	item_state = "black"
	siemens_coefficient = 2
	permeability_coefficient = 0.05
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROTECTION_TEMPERATURE
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)
	
/obj/item/clothing/gloves/combat/knight_costume/brown
	desc = "ye olde armored gauntlets"
	name = "knight gauntlets"
	icon_state = "brown"
	item_state = "brown"