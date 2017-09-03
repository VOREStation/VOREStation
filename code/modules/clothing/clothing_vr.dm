//This is a crazy 'sideways' override.
/obj/item/clothing/shoes/attackby(var/obj/item/I, var/mob/user)
	if(istype(I,/obj/item/weapon/holder/micro))
		var/full = 0
		for(var/mob/M in src)
			full++
		if(full >= 2)
			to_chat(user,"<span class='warning'>You can't fit anyone else into \the [src]!</span>")
		else
			var/obj/item/weapon/holder/micro/holder = I
			if(holder.held_mob && holder.held_mob in holder)
				to_chat(holder.held_mob,"<span class='warning'>[user] stuffs you into \the [src]!</span>")
				holder.held_mob.forceMove(src)
				to_chat(user,"<span class='notice'>You stuff \the [holder.held_mob] into \the [src]!</span>")
	else
		..()

/obj/item/clothing/shoes/attack_self(var/mob/user)
	for(var/mob/M in src)
		M.forceMove(get_turf(user))
		to_chat(M,"<span class='warning'>[user] shakes you out of \the [src]!</span>")
		to_chat(user,"<span class='notice'>You shake [M] out of \the [src]!</span>")

	..()

//Mask
/obj/item/clothing/mask
	name = "mask"
	icon = 'icons/obj/clothing/masks_vr.dmi' // This is intentional because of our custom species.
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_masks.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_masks.dmi',
		)
	body_parts_covered = HEAD
	slot_flags = SLOT_MASK
	body_parts_covered = FACE|EYES
	sprite_sheets = list(
		"Teshari"		= 'icons/mob/species/seromi/masks_vr.dmi',
		"Vox" 			= 'icons/mob/species/vox/masks.dmi',
		"Tajara" 		= 'icons/mob/species/tajaran/mask_vr.dmi',
		"Unathi" 		= 'icons/mob/species/unathi/mask_vr.dmi',
		"Sergal" 		= 'icons/mob/species/sergal/mask_vr.dmi',
		"Nevrean" 		= 'icons/mob/species/nevrean/mask_vr.dmi',
		"Fox" 			= 'icons/mob/species/fox/mask_vr.dmi',
		"Fennec" 		= 'icons/mob/species/fennec/mask_vr.dmi',
		"Akula" 		= 'icons/mob/species/akula/mask_vr.dmi',
		"Vulpkanin" 	= 'icons/mob/species/vulpkanin/mask.dmi',
		"Xenochimera"	= 'icons/mob/species/tajaran/mask_vr.dmi'
		)
//"Spider" 		= 'icons/mob/species/spider/mask_vr.dmi' Add this later when they have custom mask sprites and everything.