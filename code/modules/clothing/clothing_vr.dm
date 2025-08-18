/obj/item/clothing
	var/recent_struggle = 0

//This is a crazy 'sideways' override.
/obj/item/clothing/shoes/attackby(var/obj/item/I, var/mob/user)
	if(istype(I,/obj/item/holder/micro))
		var/full = 0
		for(var/mob/M in src)
			if(isvoice(M)) //Don't count voices as people!
				continue
			full++
		if(full >= 2)
			to_chat(user, span_warning("You can't fit anyone else into \the [src]!"))
		else
			var/obj/item/holder/micro/holder = I
			if(holder.held_mob && (holder.held_mob in holder))
				var/mob/living/M = holder.held_mob
				holder.dump_mob()
				to_chat(M, span_warning("[user] stuffs you into \the [src]!"))
				M.forceMove(src)
				to_chat(user, span_notice("You stuff \the [M] into \the [src]!"))
	else
		..()

/obj/item/clothing/gloves
	sprite_sheets = list(
		SPECIES_TESHARI = 'icons/inventory/hands/mob_teshari.dmi',
		SPECIES_VOX = 'icons/inventory/hands/mob_vox.dmi',
		SPECIES_WEREBEAST = 'icons/inventory/hands/mob_werebeast.dmi')

/obj/item/clothing/relaymove(var/mob/living/user,var/direction)

	if(recent_struggle)
		return

	recent_struggle = 1

	spawn(100)
		recent_struggle = 0

	if(ishuman(src.loc)) //Is this on a person?
		var/mob/living/carbon/human/H = src.loc
		if(isvoice(user)) //Is this a possessed item? Spooky. It can move on it's own!
			to_chat(H, span_red("The [src] shifts about, almost as if squirming!"))
			to_chat(user, span_red("You cause the [src] to shift against [H]'s form! Well, what little you can get to, given your current state!"))
		else if(H.shoes == src)
			to_chat(H, span_red("[user]'s tiny body presses against you in \the [src], squirming!"))
			to_chat(user, span_red("Your body presses out against [H]'s form! Well, what little you can get to!"))
		else
			to_chat(H, span_red("[user]'s form shifts around in the \the [src], squirming!"))
			to_chat(user, span_red("You move around inside the [src], to no avail."))
	else if(isvoice(user)) //Possessed!
		src.visible_message(span_red("The [src] shifts about!"))
		to_chat(user, span_red("You cause the [src] to shift about!"))
	else
		src.visible_message(span_red("\The [src] moves a little!"))
		to_chat(user, span_red("You throw yourself against the inside of \the [src]!"))

//Mask
/obj/item/clothing/mask
	name = "mask"
	icon = 'icons/inventory/face/item_vr.dmi' // This is intentional because of our custom species.
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_masks.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_masks.dmi',
		)
	body_parts_covered = HEAD|FACE|EYES
	slot_flags = SLOT_MASK
	item_icons = list(
		slot_wear_mask_str = 'icons/inventory/face/mob_vr.dmi'
		)
	sprite_sheets = list(
		SPECIES_TESHARI		= 'icons/inventory/face/mob_teshari.dmi',
		SPECIES_VOX 		= 'icons/inventory/face/mob_vox.dmi',
		SPECIES_TAJARAN 		= 'icons/inventory/face/mob_tajaran.dmi',
		SPECIES_UNATHI 		= 'icons/inventory/face/mob_unathi.dmi',
		SPECIES_SERGAL 		= 'icons/inventory/face/mob_vr_sergal.dmi',
		SPECIES_NEVREAN 	= 'icons/inventory/face/mob_vr_nevrean.dmi',
		SPECIES_ZORREN_HIGH	= 'icons/inventory/face/mob_vr_fox.dmi',
		SPECIES_ZORREN_FLAT = 'icons/inventory/face/mob_vr_fox.dmi',
		SPECIES_AKULA 		= 'icons/inventory/face/mob_vr_akula.dmi',
		SPECIES_VULPKANIN 	= 'icons/inventory/face/mob_vr_vulpkanin.dmi',
		SPECIES_XENOCHIMERA	= 'icons/inventory/face/mob_vr_tajaran.dmi',
		SPECIES_WEREBEAST	= 'icons/inventory/face/mob_vr_werebeast.dmi'
		)
//"Spider" 		= 'icons/inventory/mask/mob_spider.dmi' Add this later when they have custom mask sprites and everything.

/obj/item/clothing/head
	sprite_sheets = list(
		SPECIES_TESHARI = 'icons/inventory/head/mob_teshari.dmi',
		SPECIES_VOX = 'icons/inventory/head/mob_vox.dmi',
		SPECIES_WEREBEAST = 'icons/inventory/head/mob_vr_werebeast.dmi')
