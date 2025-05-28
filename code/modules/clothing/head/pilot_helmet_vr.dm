//Pilot helmets
/obj/item/clothing/head/pilot_vr
	name = "standard pilot helmet"
	desc = "Standard pilot gear. Protects the head from impacts. This one has a retractable visor"
	icon = 'icons/inventory/head/item_vr.dmi'
	icon_state = "pilot1"
	armor = list(melee = 20, bullet = 10, laser = 10, energy = 5, bomb = 10, bio = 0, rad = 0)
	flags_inv = HIDEEARS
	min_cold_protection_temperature = HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	max_heat_protection_temperature = HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	w_class = ITEMSIZE_NORMAL
	item_icons = list(slot_head_str = 'icons/inventory/head/mob_vr.dmi')
	sprite_sheets = list(
		SPECIES_TESHARI = 'icons/inventory/head/mob_vr_teshari.dmi'
		)
	actions_types = list(/datum/action/item_action/toggle_visor)

/obj/item/clothing/head/pilot_vr/attack_self(mob/user as mob)
	if(src.icon_state == initial(icon_state))
		src.icon_state = "[icon_state]up"
		to_chat(user, "You raise the visor on the pilot helmet.")
	else
		src.icon_state = initial(icon_state)
		to_chat(user, "You lower the visor on the pilot helmet.")
	update_clothing_icon() //so our mob-overlays update

/obj/item/clothing/head/pilot_vr/alt
	name = "colored pilot helmet"
	desc = "A colored version of the standard pilot helmet. Protects the head from impacts. This one has a retractable visor"
	icon_state = "pilot2"
	item_icons = list(slot_head_str = 'icons/inventory/head/mob_vr.dmi')
	sprite_sheets = list(
		SPECIES_TESHARI = 'icons/inventory/head/mob_vr_teshari.dmi'
		)
	actions_types = list(/datum/action/item_action/toggle_visor)

/obj/item/clothing/head/pilot_vr/alt/attack_self(mob/user as mob)
	if(src.icon_state == initial(icon_state))
		src.icon_state = "[icon_state]up"
		to_chat(user, "You raise the visor on the pilot helmet.")
	else
		src.icon_state = initial(icon_state)
		to_chat(user, "You lower the visor on the pilot helmet.")
	update_clothing_icon() //so our mob-overlays update

//////////Talon Pilot Headgear//////////

/obj/item/clothing/head/pilot_vr/talon
	name = "Talon pilot helmet"
	desc = "An ITV Talon version of the standard pilot helmet. Protects the head from impacts. This one has a retractable visor"
	icon_state = "pilot3"
	item_icons = list(slot_head_str = 'icons/inventory/head/mob_vr.dmi')
	sprite_sheets = list(
		SPECIES_TESHARI = 'icons/inventory/head/mob_vr_teshari.dmi'
		)
	actions_types = list(/datum/action/item_action/toggle_visor)

/obj/item/clothing/head/pilot_vr/talon/attack_self(mob/user as mob)
	if(src.icon_state == initial(icon_state))
		src.icon_state = "[icon_state]up"
		to_chat(user, "You raise the visor on the pilot helmet.")
	else
		src.icon_state = initial(icon_state)
		to_chat(user, "You lower the visor on the pilot helmet.")
	update_clothing_icon() //so our mob-overlays update

//////////Major Bill's Pilot Headgear//////////

/obj/item/clothing/head/pilot_vr/mbill
	name = "\improper Major Bill's pilot helmet"
	desc = "An Major Bill's Transportation version of the standard pilot helmet. Protects the head from impacts. This one has a retractable visor"
	icon_state = "pilot3"
	item_icons = list(slot_head_str = 'icons/inventory/head/mob_vr.dmi')
	catalogue_data = list(/datum/category_item/catalogue/information/organization/major_bills)
	sprite_sheets = list(
		SPECIES_TESHARI = 'icons/inventory/head/mob_vr_teshari.dmi'
		)
	actions_types = list(/datum/action/item_action/toggle_visor)

/obj/item/clothing/head/pilot_vr/mbill/attack_self(mob/user as mob)
	if(src.icon_state == initial(icon_state))
		src.icon_state = "[icon_state]up"
		to_chat(user, "You raise the visor on the pilot helmet.")
	else
		src.icon_state = initial(icon_state)
		to_chat(user, "You lower the visor on the pilot helmet.")
	update_clothing_icon() //so our mob-overlays update
