/obj/item/clothing/glasses/proc/prescribe(var/mob/user)
	prescription = !prescription

	//Look it's really not that fancy. It's not ACTUALLY unique scrip data.
	if(prescription)
		name = "[initial(name)] (pr)"
		user.visible_message("[user] replaces the lenses in \the [src] with a new prescription.")
	else
		name = "[initial(name)]"
		user.visible_message("[user] replaces the prescription lenses in \the [src] with generics.")

	playsound(src,'sound/items/screwdriver.ogg', 50, 1)

//Prescription kit
/obj/item/glasses_kit
	name = "prescription glasses kit"
	desc = "A kit containing all the needed tools and parts to develop and apply a prescription for someone."
	icon = 'icons/obj/device.dmi'
	icon_state = "modkit"
	var/scrip_loaded = 0

/obj/item/glasses_kit/afterattack(var/target, var/mob/living/carbon/human/user, var/proximity)
	if(!proximity)
		return
	if(!istype(user))
		return

	//Too difficult
	if(target == user)
		to_chat(user, span_warning("You can't use this on yourself. Get someone to help you."))
		return

	//We're applying a prescription
	if(istype(target,/obj/item/clothing/glasses))
		var/obj/item/clothing/glasses/G = target
		if(!scrip_loaded)
			to_chat(user, span_warning("You need to build a prescription from someone first! Use the kit on someone."))
			return

		if(do_after(user,5 SECONDS))
			G.prescribe(user)
			scrip_loaded = 0

	//We're getting a prescription
	else if(ishuman(target))
		var/mob/living/carbon/human/T = target
		if(T.glasses || (T.head && T.head.flags_inv & HIDEEYES))
			to_chat(user, span_warning("The person's eyes can't be covered!"))
			return

		T.visible_message("[user] begins making measurements for prescription lenses for [target].","[user] begins measuring your eyes. Hold still!")
		if(do_after(user,5 SECONDS,T))
			T.flash_eyes()
			scrip_loaded = 1
			T.visible_message("[user] finishes making prescription lenses for [target].",span_warning("Gah, that's bright!"))

	else
		..()

/obj/item/clothing/glasses/sunglasses/sechud/tactical
	item_flags = AIRTIGHT
	body_parts_covered = EYES

/obj/item/clothing/glasses/graviton/medgravpatch
	name = "medical graviton eyepatch"
	desc = "A graviton eyepatch with a medical overlay."
	icon = 'icons/inventory/eyes/item_vr.dmi'
	icon_override = 'icons/inventory/eyes/mob_vr.dmi'
	icon_state = "medgravpatch"
	item_state_slots = list(slot_r_hand_str = "blindfold", slot_l_hand_str = "blindfold")
	actions_types = list(/datum/action/item_action/toggle_eyepatch)
	off_state = "eyepatch"
	enables_planes = list(VIS_CH_STATUS,VIS_CH_HEALTH,VIS_FULLBRIGHT,VIS_MESONS)

/obj/item/clothing/glasses/sunglasses/sechud/tactical_sec_vis
	name = "tactical AR visor"
	desc = "Special AR visor designed for security teams, protects your eyes and provides useful data. The red lights provide extra style and intimidation."
	icon_state = "tacsecvis1"
	icon = 'icons/inventory/eyes/item_vr.dmi'
	icon_override = 'icons/inventory/eyes/mob_vr.dmi'
	enables_planes = list(VIS_CH_ID,VIS_CH_WANTED,VIS_CH_IMPTRACK,VIS_CH_IMPLOYAL,VIS_CH_IMPCHEM)
	flash_protection = FLASH_PROTECTION_MODERATE
	item_flags = AIRTIGHT
	body_parts_covered = EYES
	actions_types = list(/datum/action/item_action/hands_free/change_scanning_pattern)
	var/static/list/tac_sec_vis_anim = list()

/obj/item/clothing/glasses/sunglasses/sechud/tactical_sec_vis/Initialize(mapload)
	. = ..()
	tac_sec_vis_anim = list(
		"Scanning pattern 1" = image(icon = src.icon, icon_state = "tacsecvis1"),
		"Scanning pattern 2" = image(icon = src.icon, icon_state = "tacsecvis2"),
		"Scanning pattern 3" = image(icon = src.icon, icon_state = "tacsecvis3"),
		"Scanning pattern 4" = image(icon = src.icon, icon_state = "tacsecvis4"),
		)

/obj/item/clothing/glasses/sunglasses/sechud/tactical_sec_vis/attack_self(mob/user)
	. = ..()
	if(!istype(user) || user.incapacitated())
		return

	var/static/list/options = list("Scanning pattern 1" = "tacsecvis1", "Scanning pattern 2" = "tacsecvis2", "Scanning pattern 3" = "tacsecvis3","Scanning pattern 4" ="tacsecvis4")

	var/choice = show_radial_menu(user, src, tac_sec_vis_anim, custom_check = FALSE, radius = 36, require_near = TRUE)

	if(src && choice && !user.incapacitated() && in_range(user,src))
		icon_state = options[choice]
		user.update_inv_glasses()
		user.update_mob_action_buttons()
		to_chat(user, span_notice("Your [src] now displays [choice] ."))
		return 1

/*---Tajaran-specific Eyewear---*/

/obj/item/clothing/glasses/tajblind
	name = "embroidered veil"
	desc = "An Tajaran made veil that allows the user to see while obscuring their eyes."
	icon = 'icons/inventory/eyes/item_vr.dmi'
	icon_override = 'icons/inventory/eyes/mob_vr.dmi'
	icon_state = "tajblind"
	item_state = "tajblind"
	prescription = 1
	body_parts_covered = EYES
	sprite_sheets = list(SPECIES_VOX = 'icons/inventory/eyes/mob_vox.dmi')

/obj/item/clothing/glasses/hud/health/tajblind
	name = "lightweight veil"
	desc = "An Tajaran made veil that allows the user to see while obscuring their eyes. This one has an installed medical HUD."
	icon = 'icons/inventory/eyes/item_vr.dmi'
	icon_override = 'icons/inventory/eyes/mob_vr.dmi'
	icon_state = "tajblind_med"
	item_state = "tajblind_med"
	body_parts_covered = EYES
	sprite_sheets = list(SPECIES_VOX = 'icons/inventory/eyes/mob_vox.dmi')

/obj/item/clothing/glasses/sunglasses/sechud/tajblind
	name = "sleek veil"
	desc = "An Tajaran made veil that allows the user to see while obscuring their eyes. This one has an in-built security HUD."
	icon = 'icons/inventory/eyes/item_vr.dmi'
	icon_override = 'icons/inventory/eyes/mob_vr.dmi'
	icon_state = "tajblind_sec"
	item_state = "tajblind_sec"
	prescription = 1
	body_parts_covered = EYES
	sprite_sheets = list(SPECIES_VOX = 'icons/inventory/eyes/mob_vox.dmi')

/obj/item/clothing/glasses/meson/prescription/tajblind
	name = "industrial veil"
	desc = "An Tajaran made veil that allows the user to see while obscuring their eyes. This one has installed mesons."
	icon = 'icons/inventory/eyes/item_vr.dmi'
	icon_override = 'icons/inventory/eyes/mob_vr.dmi'
	icon_state = "tajblind_meson"
	item_state = "tajblind_meson"
	off_state = "tajblind"
	body_parts_covered = EYES
	sprite_sheets = list(SPECIES_VOX = 'icons/inventory/eyes/mob_vox.dmi')

/obj/item/clothing/glasses/material/prescription/tajblind
	name = "mining veil"
	desc = "An Tajaran made veil that allows the user to see while obscuring their eyes. This one has an installed material scanner."
	icon = 'icons/inventory/eyes/item_vr.dmi'
	icon_override = 'icons/inventory/eyes/mob_vr.dmi'
	icon_state = "tajblind_meson"
	item_state = "tajblind_meson"
	off_state = "tajblind"
	body_parts_covered = EYES
	sprite_sheets = list(SPECIES_VOX = 'icons/inventory/eyes/mob_vox.dmi')

/obj/item/clothing/glasses
	name = DEVELOPER_WARNING_NAME
	sprite_sheets = list(
		SPECIES_TESHARI = 'icons/inventory/eyes/mob_teshari.dmi',
		SPECIES_VOX = 'icons/inventory/eyes/mob_vox.dmi',
		SPECIES_WEREBEAST = 'icons/inventory/eyes/mob_werebeast.dmi'
		)
