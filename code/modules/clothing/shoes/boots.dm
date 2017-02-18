/obj/item/clothing/shoes/boots
	name = "boots"
	desc = "Generic boots."
	icon_state = "workboots"
	force = 3
	can_hold_knife = 1

/obj/item/clothing/shoes/boots/cowboy
	name = "cowboy boots"
	desc = "Lacking a durasteel horse to ride."
	icon_state = "cowboy"

/obj/item/clothing/shoes/boots/jackboots
	name = "jackboots"
	desc = "Standard-issue Security combat boots for combat scenarios or combat situations. All combat, all the time."
	icon_state = "jackboots"
	armor = list(melee = 30, bullet = 10, laser = 10, energy = 15, bomb = 20, bio = 0, rad = 0)
	siemens_coefficient = 0.7

/obj/item/clothing/shoes/boots/jackboots/toeless
	name = "toe-less jackboots"
	desc = "Modified pair of jackboots, particularly friendly to those species whose toes hold claws."
	icon_state = "digiboots"
	item_state_slots = list(slot_r_hand_str = "jackboots", slot_l_hand_str = "jackboots")
	species_restricted = null

/obj/item/clothing/shoes/boots/workboots
	name = "workboots"
	desc = "A pair of steel-toed work boots designed for use in industrial settings. Safety first."
	icon_state = "workboots"
	armor = list(melee = 40, bullet = 0, laser = 0, energy = 15, bomb = 20, bio = 0, rad = 20)
	siemens_coefficient = 0.7

/obj/item/clothing/shoes/boots/workboots/toeless
	name = "toe-less workboots"
	desc = "A pair of toeless work boots designed for use in industrial settings. Modified for species whose toes have claws."
	icon_state = "workbootstoeless"
	item_state_slots = list(slot_r_hand_str = "workboots", slot_l_hand_str = "workboots")
	species_restricted = null

/obj/item/clothing/shoes/boots/winter
	name = "winter boots"
	desc = "Boots lined with 'synthetic' animal fur."
	icon_state = "winterboots"
	cold_protection = FEET|LEGS
	min_cold_protection_temperature = SHOE_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = FEET|LEGS
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/shoes/boots/tactical
	name = "tactical boots"
	desc = "Tan boots with extra padding and armor."
	icon_state = "jungle"
	armor = list(melee = 40, bullet = 30, laser = 40,energy = 25, bomb = 50, bio = 0, rad = 0)
	siemens_coefficient = 0.7

/obj/item/clothing/shoes/boots/duty
	name = "duty boots"
	desc = "A pair of steel-toed synthleather boots with a mirror shine."
	icon_state = "duty"
	armor = list(melee = 40, bullet = 0, laser = 0, energy = 15, bomb = 20, bio = 0, rad = 20)
	siemens_coefficient = 0.7

/obj/item/clothing/shoes/boots/jungle
	name = "jungle boots"
	desc = "A pair of durable brown boots. Waterproofed for use planetside."
	icon_state = "jungle"
	armor = list(melee = 30, bullet = 10, laser = 10, energy = 15, bomb = 20, bio = 10, rad = 0)
	siemens_coefficient = 0.7

/obj/item/clothing/shoes/boots/swat
	name = "\improper SWAT shoes"
	desc = "When you want to turn up the heat."
	icon_state = "swat"
	armor = list(melee = 80, bullet = 60, laser = 50,energy = 25, bomb = 50, bio = 10, rad = 0)
	item_flags = NOSLIP
	siemens_coefficient = 0.6

/obj/item/clothing/shoes/boots/combat //Basically SWAT shoes combined with galoshes.
	name = "combat boots"
	desc = "When you REALLY want to turn up the heat"
	icon_state = "swat"
	force = 5
	armor = list(melee = 80, bullet = 60, laser = 50,energy = 25, bomb = 50, bio = 10, rad = 0)
	item_flags = NOSLIP
	siemens_coefficient = 0.6

	cold_protection = FEET
	min_cold_protection_temperature = SHOE_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = FEET
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROTECTION_TEMPERATURE

//Stolen from CM, refurbished to be less terrible.
/obj/item/clothing/shoes/boots/marine
	name = "combat boots"
	desc = "Standard issue combat boots for combat scenarios or combat situations. All combat, all the time.  It can hold a Strategical knife."
	icon_state = "jackboots"
	armor = list(melee = 80, bullet = 60, laser = 50,energy = 25, bomb = 50, bio = 10, rad = 0)
	siemens_coefficient = 0.6
