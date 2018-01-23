//Pilot

/obj/item/clothing/head/pilot
	name = "pilot helmet"
	desc = "Standard pilot gear. Protects the head from impacts."
	icon_state = "pilot_helmet1"
	item_icons = list(slot_head_str = 'maps/southern_cross/icons/mob/sc_head.dmi')
	icon = 'maps/southern_cross/icons/obj/sc_hats.dmi'
	sprite_sheets = list(
			"Teshari" = 'maps/southern_cross/icons/mob/species/teshari/sc_head.dmi'
			)
	flags = THICKMATERIAL
	armor = list(melee = 20, bullet = 10, laser = 10, energy = 5, bomb = 10, bio = 0, rad = 0)
	flags_inv = HIDEEARS
	cold_protection = HEAD
	min_cold_protection_temperature = HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HEAD
	max_heat_protection_temperature = HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	w_class = ITEMSIZE_NORMAL

/obj/item/clothing/head/pilot/alt
	name = "pilot helmet"
	desc = "Standard pilot gear. Protects the head from impacts. This one has a retractable visor"
	icon_state = "pilot_helmet2"
	sprite_sheets = list(
			"Teshari" = 'maps/southern_cross/icons/mob/species/teshari/sc_head.dmi'
			)
	action_button_name = "Toggle Visor"

/obj/item/clothing/head/pilot/alt/attack_self(mob/user as mob)
	if(src.icon_state == initial(icon_state))
		src.icon_state = "[icon_state]up"
		user << "You raise the visor on the pilot helmet."
	else
		src.icon_state = initial(icon_state)
		user << "You lower the visor on the pilot helmet."
	update_clothing_icon() //so our mob-overlays update