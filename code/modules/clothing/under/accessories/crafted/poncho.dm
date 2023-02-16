/obj/item/clothing/accessory/storage/poncho/crafted
	name = "poncho"
	desc = "A handmade poncho, little more than a rough sheet with a neckhole in it."
	icon_state = "poncho_base"
	item_state = "poncho_base"
	default_material = MAT_CLOTH
	material_slowdown_multiplier = 0
	icon = 'icons/obj/clothing/crafted_poncho.dmi'
	icon_override = 'icons/mob/crafted_poncho.dmi'
	sprite_sheets = list(
		SPECIES_TESHARI = 'icons/mob/species/teshari/crafted_poncho.dmi'
	)

	var/dyed = FALSE
	var/list/initial_armor
	var/list/plates
	var/max_plates = 3
	var/static/list/accepts_dyes = list(
		"sifsap",
		"crayon_dust",
		"crayon_dust_red",
		"crayon_dust_orange",
		"crayon_dust_yellow",
		"crayon_dust_green",
		"crayon_dust_blue",
		"crayon_dust_purple",
		"crayon_dust_grey",
		"crayon_dust_brown",
		"marker_ink",
		"marker_ink_black",
		"marker_ink_red",
		"marker_ink_orange",
		"marker_ink_yellow",
		"marker_ink_green",
		"marker_ink_blue",
		"marker_ink_purple",
		"marker_ink_grey",
		"marker_ink_brown",
		"paint"
	)

/obj/item/clothing/accessory/storage/poncho/crafted/cloak
	name = "cloak"
	desc = "A handmade cloak, little more than a rough shroud with a collar and clasp attacked."
	icon_state = "cloak_base"
	item_state = "cloak_base"
	icon = 'icons/obj/clothing/crafted_cloak.dmi'
	icon_override = 'icons/mob/crafted_cloak.dmi'
	sprite_sheets = list(
		SPECIES_TESHARI = 'icons/mob/species/teshari/crafted_cloak.dmi'
	)

/obj/item/clothing/accessory/storage/poncho/crafted/Initialize()
	. = ..()
	update_icon()

/obj/item/clothing/accessory/storage/poncho/crafted/Destroy()
	QDEL_NULL_LIST(plates)
	return ..()

/obj/item/clothing/accessory/storage/poncho/crafted/update_clothing_icon()
	if(ismob(loc))
		var/mob/M = src.loc
		M.update_inv_wear_suit()
	. = ..()

/obj/item/clothing/accessory/storage/poncho/crafted/proc/recalculate_armor()
	LAZYINITLIST(armor)
	if(!initial_armor)
		initial_armor = armor.Copy()
	else
		armor = initial_armor.Copy()
	if(length(plates))
		var/list/averaged_plate_armour = list()
		for(var/obj/item/clothing/accessory/plate in plates)
			for(var/armor_key in plate.armor)
				averaged_plate_armour[armor_key] = averaged_plate_armour[armor_key] + plate.armor[armor_key]
		for(var/armor_key in averaged_plate_armour)
			armor[armor_key] = max(armor[armor_key], round(averaged_plate_armour[armor_key] / max_plates))

	update_icon()
	update_clothing_icon()

/obj/item/clothing/accessory/storage/poncho/crafted/get_worn_overlay(var/mob/living/wearer, var/body_type, var/slot_name, var/inhands, var/default_icon, var/default_layer, var/icon/clip_mask)
	var/image/standing = ..()
	if(standing && slot_name == slot_wear_suit_str)
		var/use_icon = LAZYACCESS(sprite_sheets, body_type) || icon_override
		if(use_icon)
			var/list/plate_overlays = list()
			for(var/i = 1 to length(plates))
				var/atom/plate = plates[i]
				var/image/I = image(use_icon, "[icon_state]_plate[i]")
				I.appearance_flags |= RESET_COLOR
				I.color = plate.color
				plate_overlays += I
			standing.overlays = plate_overlays
	return standing

/obj/item/clothing/accessory/storage/poncho/crafted/update_icon()
	cut_overlays()
	for(var/i = 1 to length(plates))
		var/atom/plate = plates[i]
		var/image/I = image(icon, "[icon_state]_plate[i]")
		I.appearance_flags |= RESET_COLOR
		I.color = plate.color
		add_overlay(I)

/obj/item/clothing/accessory/storage/poncho/crafted/attackby(var/obj/item/O, var/mob/user)

	if(istype(O, /obj/item/clothing/accessory/armor) || istype(O, /obj/item/clothing/accessory/material/makeshift))
		if(length(plates) >= max_plates)
			to_chat(user, SPAN_WARNING("\The [src] is already plated with [length(plates)] plate\s, and cannot support more."))
		else if(user.unEquip(O, src))
			O.forceMove(src)
			LAZYADD(plates, O)
			user.visible_message(SPAN_NOTICE("\The [user] secures \the [O] to \the [src]."))
			recalculate_armor()
		return TRUE

	if(O.is_wirecutter())
		if(!length(plates))
			to_chat(user, SPAN_WARNING("\The [src] has no plating to remove."))
		else
			var/obj/item/plate = plates[1]
			user.visible_message(SPAN_NOTICE("\The [user] removes \the [plate] from \the [src]."))
			plate.dropInto(user.loc)
			LAZYREMOVE(plates, plate)
			recalculate_armor()
		return TRUE

	if(istype(O, /obj/item/reagent_containers/glass))
		var/obj/item/reagent_containers/glass/vessel = O

		// If it's closed, handle it as a normal attackby.
		if(!vessel.is_open_container())
			return ..()

		// Check some general preconditions...
		if(dyed)
			to_chat(user, SPAN_WARNING("\The [src] has already been dyed; the material won't take another pigment."))
			return TRUE
		if(!isturf(loc))
			to_chat(user, SPAN_WARNING("\The [src] must be on the ground before you can get to work."))
			return TRUE
		if(!vessel.reagents?.total_volume)
			to_chat(user, SPAN_WARNING("\The [vessel] is empty."))
			return TRUE

		// Look for a valid pigment and sufficient reagents.
		var/has_pigment = FALSE
		for(var/datum/reagent/R in vessel.reagents.reagent_list)
			if(R.id in accepts_dyes)
				has_pigment = TRUE
				break
		if(!has_pigment)
			to_chat(user, SPAN_WARNING("There is nothing in \the [vessel] that will bind to \the [src]."))
			return TRUE
		if(vessel.reagents.total_volume < 10)
			to_chat(user, SPAN_WARNING("You will need at least 10u of pigment to dye \the [src]."))
			return TRUE

		// Do the actual dye operation.
		var/apply_colour = vessel.reagents.get_color() // Keep this so when we remove on the next step it doesn't change.
		vessel.reagents.remove_any(10)
		visible_message(SPAN_NOTICE("\The [user] lays out \the [src] and begins soaking it with the contents of \the [vessel]."))
		user.setClickCooldown(5 SECONDS) // Prevents spamming the dye interaction.
		if(!do_after(user, 5 SECONDS, src) || QDELETED(src) || QDELETED(vessel))
			to_chat(user, SPAN_WARNING("You fail to dye \the [src], wasting the pigment."))
			return TRUE
		visible_message(SPAN_NOTICE("\The [user] dyes \the [src] with the contents of \the [vessel]."))
		color = apply_colour
		applies_material_color = FALSE
		return TRUE

	return ..()
