/obj/item/clothing/head/helmet
	name = "helmet"
	desc = "Standard Security gear. Protects the head from impacts."
	icon_state = "helmet"
	item_state_slots = list(
		slot_l_hand_str = "helmet",
		slot_r_hand_str = "helmet",
		)
	flags = THICKMATERIAL
	armor = list(melee = 40, bullet = 30, laser = 30, energy = 10, bomb = 10, bio = 0, rad = 0)
	flags_inv = HIDEEARS|HIDEEYES
	cold_protection = HEAD
	min_cold_protection_temperature = HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HEAD
	max_heat_protection_temperature = HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.7
	w_class = 3
	ear_protection = 1

/obj/item/clothing/head/helmet/riot
	name = "riot helmet"
	desc = "It's a helmet specifically designed to protect against close range attacks."
	icon_state = "riot"
	armor = list(melee = 80, bullet = 10, laser = 10, energy = 10, bomb = 0, bio = 0, rad = 0)
	flags_inv = HIDEEARS
	siemens_coefficient = 0.7
	action_button_name = "Toggle Visor"

/obj/item/clothing/head/helmet/riot/attack_self(mob/user as mob)
	if(src.icon_state == initial(icon_state))
		src.icon_state = "[icon_state]up"
		user << "You raise the visor on the riot helmet."
	else
		src.icon_state = initial(icon_state)
		user << "You lower the visor on the riot helmet."
	update_clothing_icon()	//so our mob-overlays update

/obj/item/clothing/head/helmet/laserproof
	name = "ablative helmet"
	desc = "It's a helmet specifically designed to protect against energy projectiles."
	icon_state = "helmet_reflec"
	armor = list(melee = 10, bullet = 10, laser = 80 ,energy = 50, bomb = 0, bio = 0, rad = 0)
	flags_inv = HIDEEARS
	siemens_coefficient = 0.1

/obj/item/clothing/head/helmet/bulletproof
	name = "bullet-resistant helmet"
	desc = "It's a helmet specifically designed to protect against ballistic projectiles."
	icon_state = "helmet_bulletproof"
	armor = list(melee = 10, bullet = 80, laser = 10 ,energy = 10, bomb = 0, bio = 0, rad = 0)
	flags_inv = HIDEEARS
	siemens_coefficient = 0.7

/obj/item/clothing/head/helmet/combat
	name = "combat helmet"
	desc = "It's a general purpose combat helmet, designed to protect against typical dangers to your head."
	icon_state = "helmet_combat"
	armor = list(melee = 50, bullet = 50, laser = 50 ,energy = 30, bomb = 30, bio = 0, rad = 0)
	flags_inv = HIDEEARS
	siemens_coefficient = 0.6

/obj/item/clothing/head/helmet/swat
	name = "\improper SWAT helmet"
	desc = "They're often used by highly trained SWAT Officers."
	icon_state = "swat"
	armor = list(melee = 80, bullet = 60, laser = 50,energy = 25, bomb = 50, bio = 10, rad = 0)
	flags_inv = HIDEEARS|HIDEEYES
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.5

/obj/item/clothing/head/helmet/thunderdome
	name = "\improper Thunderdome helmet"
	desc = "<i>'Let the battle commence!'</i>"
	icon_state = "thunderdome"
	armor = list(melee = 80, bullet = 60, laser = 50,energy = 10, bomb = 25, bio = 10, rad = 0)
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 1

/obj/item/clothing/head/helmet/gladiator
	name = "gladiator helmet"
	desc = "Ave, Imperator, morituri te salutant."
	icon_state = "gladiator"
	flags = BLOCKHAIR
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES
	siemens_coefficient = 1

/obj/item/clothing/head/helmet/tactical
	name = "tactical helmet"
	desc = "An armored helmet capable of being fitted with a multitude of attachments."
	icon_state = "swathelm"
	sprite_sheets = list(
		"Tajara" = 'icons/mob/species/tajaran/helmet.dmi',
		"Unathi" = 'icons/mob/species/unathi/helmet.dmi',
		)

	armor = list(melee = 60, bullet = 60, laser = 60, energy = 40, bomb = 40, bio = 0, rad = 0)
	flags_inv = HIDEEARS
	siemens_coefficient = 0.7

/obj/item/clothing/head/helmet/augment
	name = "Augment Array"
	desc = "A helmet with optical and cranial augments coupled to it."
	icon_state = "v62"
	armor = list(melee = 80, bullet = 60, laser = 50,energy = 25, bomb = 50, bio = 10, rad = 0)
	flags_inv = HIDEEARS|HIDEEYES
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.5

//Non-hardsuit ERT helmets.
/obj/item/clothing/head/helmet/ert
	name = "emergency response team helmet"
	desc = "An in-atmosphere helmet worn by members of the NanoTrasen Emergency Response Team. Protects the head from impacts."
	icon_state = "erthelmet_cmd"
	item_state_slots = list(
		slot_l_hand_str = "syndicate-helm-green",
		slot_r_hand_str = "syndicate-helm-green",
		)
	armor = list(melee = 62, bullet = 50, laser = 50,energy = 35, bomb = 10, bio = 2, rad = 0)

//Commander
/obj/item/clothing/head/helmet/ert/command
	name = "emergency response team commander helmet"
	desc = "An in-atmosphere helmet worn by the commander of a NanoTrasen Emergency Response Team. Has blue highlights."

//Security
/obj/item/clothing/head/helmet/ert/security
	name = "emergency response team security helmet"
	desc = "An in-atmosphere helmet worn by security members of the NanoTrasen Emergency Response Team. Has red highlights."
	icon_state = "erthelmet_sec"

//Engineer
/obj/item/clothing/head/helmet/ert/engineer
	name = "emergency response team engineer helmet"
	desc = "An in-atmosphere helmet worn by engineering members of the NanoTrasen Emergency Response Team. Has orange highlights."
	icon_state = "erthelmet_eng"

//Medical
/obj/item/clothing/head/helmet/ert/medical
	name = "emergency response team medical helmet"
	desc = "A set of armor worn by medical members of the NanoTrasen Emergency Response Team. Has red and white highlights."
	icon_state = "erthelmet_med"
