/obj/item/clothing/accessory/vest
	name = "black vest"
	desc = "Slick black suit vest."
	icon_state = "det_vest"

/obj/item/clothing/accessory/tan_jacket
	name = "tan suit jacket"
	desc = "Cozy suit jacket."
	icon_state = "tan_jacket"

/obj/item/clothing/accessory/charcoal_jacket
	name = "charcoal suit jacket"
	desc = "Strict suit jacket."
	icon_state = "charcoal_jacket"

/obj/item/clothing/accessory/navy_jacket
	name = "navy suit jacket"
	desc = "Official suit jacket."
	icon_state = "navy_jacket"

/obj/item/clothing/accessory/burgundy_jacket
	name = "burgundy suit jacket"
	desc = "Expensive suit jacket."
	icon_state = "burgundy_jacket"

/obj/item/clothing/accessory/checkered_jacket
	name = "checkered suit jacket"
	desc = "Lucky suit jacket."
	icon_state = "checkered_jacket"


/obj/item/clothing/accessory/chaps
	name = "brown chaps"
	desc = "A pair of loose, brown leather chaps."
	icon_state = "chaps"

/obj/item/clothing/accessory/chaps/black
	name = "black chaps"
	desc = "A pair of loose, black leather chaps."
	icon_state = "chaps_black"

/*
 * Poncho
 */
/obj/item/clothing/accessory/poncho
	name = "poncho"
	desc = "A simple, comfortable poncho."
	icon_state = "classicponcho"
	item_state = "classicponcho"
	icon_override = 'icons/mob/ties.dmi'
	var/fire_resist = T0C+100
	allowed = list(/obj/item/weapon/tank/emergency/oxygen)
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	slot_flags = SLOT_OCLOTHING | SLOT_TIE
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	siemens_coefficient = 0.9
	w_class = ITEMSIZE_NORMAL
	slot = "over"

	sprite_sheets = list(
		"Teshari" = 'icons/mob/species/seromi/suit.dmi'
		)

/obj/item/clothing/accessory/poncho/green
	name = "green poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is green."
	icon_state = "greenponcho"
	item_state = "greenponcho"

/obj/item/clothing/accessory/poncho/red
	name = "red poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is red."
	icon_state = "redponcho"
	item_state = "redponcho"

/obj/item/clothing/accessory/poncho/purple
	name = "purple poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is purple."
	icon_state = "purpleponcho"
	item_state = "purpleponcho"

/obj/item/clothing/accessory/poncho/blue
	name = "blue poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is blue."
	icon_state = "blueponcho"
	item_state = "blueponcho"

/obj/item/clothing/accessory/poncho/roles/security
	name = "security poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is black and red, standard NanoTrasen Security colors."
	icon_state = "secponcho"
	item_state = "secponcho"

/obj/item/clothing/accessory/poncho/roles/medical
	name = "medical poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is white with green and blue tint, standard Medical colors."
	icon_state = "medponcho"
	item_state = "medponcho"

/obj/item/clothing/accessory/poncho/roles/engineering
	name = "engineering poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is yellow and orange, standard Engineering colors."
	icon_state = "engiponcho"
	item_state = "engiponcho"

/obj/item/clothing/accessory/poncho/roles/science
	name = "science poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is white with purple trim, standard NanoTrasen Science colors."
	icon_state = "sciponcho"
	item_state = "sciponcho"

/obj/item/clothing/accessory/poncho/roles/cargo
	name = "cargo poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is tan and grey, the colors of Cargo."
	icon_state = "cargoponcho"
	item_state = "cargoponcho"

/obj/item/clothing/accessory/hawaii
	name = "flower-pattern shirt"
	desc = "You probably need some welder googles to look at this."
	icon_state = "hawaii"

/obj/item/clothing/accessory/hawaii/red
	icon_state = "hawaii2"

/obj/item/clothing/accessory/hawaii/random
	name = "flower-pattern shirt"

/obj/item/clothing/accessory/hawaii/random/New()
	if(prob(50))
		icon_state = "hawaii2"
	color = color_rotation(rand(-11,12)*15)

/obj/item/clothing/accessory/wcoat
	name = "waistcoat"
	desc = "For some classy, murderous fun."
	icon_state = "vest"
	item_state = "vest"
	icon_override = 'icons/mob/ties.dmi'
	item_state_slots = list(slot_r_hand_str = "wcoat", slot_l_hand_str = "wcoat")
	allowed = list(/obj/item/weapon/pen, /obj/item/weapon/paper, /obj/item/device/flashlight, /obj/item/weapon/tank/emergency/oxygen, /obj/item/weapon/storage/fancy/cigarettes, /obj/item/weapon/storage/box/matches, /obj/item/weapon/reagent_containers/food/drinks/flask)
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	slot_flags = SLOT_OCLOTHING | SLOT_TIE
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	siemens_coefficient = 0.9
	w_class = ITEMSIZE_NORMAL

/obj/item/clothing/accessory/wcoat/red
	name = "red waistcoat"
	icon_state = "red_waistcoat"

/obj/item/clothing/accessory/wcoat/grey
	name = "grey waistcoat"
	icon_state = "grey_waistcoat"

/obj/item/clothing/accessory/wcoat/brown
	name = "brown waistcoat"
	icon_state = "brown_waistcoat"

/obj/item/clothing/accessory/wcoat/gentleman
	name = "elegant waistcoat"
	icon_state = "elegant_waistcoat"

/obj/item/clothing/accessory/wcoat/swvest
	name = "black sweatervest"
	desc = "A sleeveless sweater. Wear this if you don't want your arms to be warm, or if you're a nerd."
	icon_state = "sweatervest"

/obj/item/clothing/accessory/wcoat/swvest/blue
	name = "blue sweatervest"
	icon_state = "sweatervest_blue"

/obj/item/clothing/accessory/wcoat/swvest/red
	name = "red sweatervest"
	icon_state = "sweatervest_red"