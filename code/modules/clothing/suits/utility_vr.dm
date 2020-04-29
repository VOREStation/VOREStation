/obj/item/clothing/head/bomb_hood/security
	icon_state = "bombsuitsec"
	body_parts_covered = HEAD

/obj/item/clothing/suit/storage/toggle/paramedic
	name = "paramedic vest"
	desc = "A vest that protects against minor chemical spills."
	icon = 'icons/obj/clothing/suits_vr.dmi'
	icon_override = 'icons/mob/suit_vr.dmi'
	icon_state = "paramedic-vest"
	item_state = "paramedic-vest"
	item_state_slots = list(slot_r_hand_str = "blue_labcoat", slot_l_hand_str = "blue_labcoat")
	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO
	flags_inv = HIDEHOLSTER
	allowed = list(/obj/item/device/analyzer,/obj/item/stack/medical,/obj/item/weapon/dnainjector,/obj/item/weapon/reagent_containers/dropper,/obj/item/weapon/reagent_containers/syringe,/obj/item/weapon/reagent_containers/hypospray,/obj/item/device/healthanalyzer,/obj/item/device/flashlight/pen,/obj/item/weapon/reagent_containers/glass/bottle,/obj/item/weapon/reagent_containers/glass/beaker,/obj/item/weapon/reagent_containers/pill,/obj/item/weapon/storage/pill_bottle,/obj/item/weapon/paper)
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 50, rad = 0)
	index = 1
	
/obj/item/clothing/suit/storage/ascent
	name = "mantid gear harness"
	desc = "A complex tangle of articulated cables and straps."
	species_restricted = list(SPECIES_MANTID_ALATE)
	icon = 'icons/obj/clothing/suits_vr.dmi'
	icon_state = "ascent_harness"
	body_parts_covered = 0
	slot_flags = SLOT_OCLOTHING | SLOT_BELT
	allowed = list(
		/obj/item/device/flashlight,
		/obj/item/weapon/tank,
		/obj/item/device/suit_cooling_unit,
		/obj/item/weapon/inflatable_dispenser,
		/obj/item/weapon/rcd
	)
