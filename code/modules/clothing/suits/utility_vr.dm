/obj/item/clothing/head/bomb_hood/security
	icon_state = "bombsuitsec"
	body_parts_covered = HEAD

/obj/item/clothing/suit/storage/toggle/paramedic
	name = "paramedic vest"
	desc = "A vest that protects against minor chemical spills."
	icon = 'icons/inventory/suit/item_vr.dmi'
	icon_override = 'icons/inventory/suit/mob_vr.dmi'
	icon_state = "paramedic-vest"
	item_state = "paramedic-vest"
	item_state_slots = list(slot_r_hand_str = "blue_labcoat", slot_l_hand_str = "blue_labcoat")
	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO
	flags_inv = HIDEHOLSTER
	allowed = list(/obj/item/analyzer,/obj/item/stack/medical,/obj/item/dnainjector,/obj/item/reagent_containers/dropper,/obj/item/reagent_containers/syringe,/obj/item/reagent_containers/hypospray,/obj/item/healthanalyzer,/obj/item/flashlight/pen,/obj/item/reagent_containers/glass/bottle,/obj/item/reagent_containers/glass/beaker,/obj/item/reagent_containers/pill,/obj/item/storage/pill_bottle,/obj/item/paper)
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 50, rad = 0)

/obj/item/clothing/head/radiation
	sprite_sheets = list(
		SPECIES_TESHARI = 'icons/inventory/head/mob_vr_teshari.dmi',
		SPECIES_VOX = 'icons/inventory/head/mob_vox.dmi',
		SPECIES_WEREBEAST = 'icons/inventory/head/mob_vr_werebeast.dmi'
		)

/obj/item/clothing/suit/radiation
	sprite_sheets = list(
		SPECIES_TESHARI = 'icons/inventory/suit/mob_vr_teshari.dmi',
		SPECIES_VOX = 'icons/inventory/suit/mob_vox.dmi',
		SPECIES_WEREBEAST = 'icons/inventory/suit/mob_vr_werebeast.dmi'
		)


