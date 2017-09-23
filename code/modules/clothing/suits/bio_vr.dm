//Biosuits for use with taurs (Currently only nagas)

//Virology biosuit, green stripe
/obj/item/clothing/suit/bio_suit/virology/taur
	name = "taur specific bio suit"
	desc = "A suit that protects against biological contamination. It has a sticker saying one size fits all taurs on it. Below the sticker, it states that it only fits horses, wolves, and naga taurs."
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS
	flags_inv = HIDEGLOVES|HIDEJUMPSUIT|HIDETAIL|HIDETIE|HIDEHOLSTER
	species_restricted = null //Species restricted since all it cares about is a taur half
	mob_can_equip(var/mob/living/carbon/human/H, slot, disable_warning = 0)
		if(..())
			if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/naga))
				icon = 'icons/mob/taursuits_vr.dmi'
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "bioviro-naga"
				item_state = "bioviro-naga"
				pixel_x = -16
				return 1
			else
				H << "<span class='warning'>You need to have a horse, wolf, or naga half to wear this.</span>"
				return 0

//Security biosuit, grey with red stripe across the chest
/obj/item/clothing/suit/bio_suit/security/taur
	name = "taur specific bio suit"
	desc = "A suit that protects against biological contamination. It has a sticker saying one size fits all taurs on it. Below the sticker, it states that it only fits horses, wolves, and naga taurs."
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS
	flags_inv = HIDEGLOVES|HIDEJUMPSUIT|HIDETAIL|HIDETIE|HIDEHOLSTER
	species_restricted = null //Species restricted since all it cares about is a taur half
	mob_can_equip(var/mob/living/carbon/human/H, slot, disable_warning = 0)
		if(..())
			if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/naga))
				icon = 'icons/mob/taursuits_vr.dmi'
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "biosec-naga"
				item_state = "biosec-naga"
				pixel_x = -16
				return 1
			else
				H << "<span class='warning'>You need to have a horse, wolf, or naga half to wear this.</span>"
				return 0

//Janitor's biosuit, grey with purple arms
/obj/item/clothing/suit/bio_suit/janitor/taur
	name = "taur specific bio suit"
	desc = "A suit that protects against biological contamination. It has a sticker saying one size fits all taurs on it. Below the sticker, it states that it only fits horses, wolves, and naga taurs."
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS
	flags_inv = HIDEGLOVES|HIDEJUMPSUIT|HIDETAIL|HIDETIE|HIDEHOLSTER
	species_restricted = null //Species restricted since all it cares about is a taur half
	mob_can_equip(var/mob/living/carbon/human/H, slot, disable_warning = 0)
		if(..())
			if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/naga))
				icon = 'icons/mob/taursuits_vr.dmi'
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "biojan-naga"
				item_state = "biojan-naga"
				pixel_x = -16
				return 1
			else
				H << "<span class='warning'>You need to have a horse, wolf, or naga half to wear this.</span>"
				return 0

//Scientist's biosuit, white with a pink-ish hue
/obj/item/clothing/suit/bio_suit/scientist/taur
	name = "taur specific bio suit"
	desc = "A suit that protects against biological contamination. It has a sticker saying one size fits all taurs on it. Below the sticker, it states that it only fits horses, wolves, and naga taurs."
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS
	flags_inv = HIDEGLOVES|HIDEJUMPSUIT|HIDETAIL|HIDETIE|HIDEHOLSTER
	species_restricted = null //Species restricted since all it cares about is a taur half
	mob_can_equip(var/mob/living/carbon/human/H, slot, disable_warning = 0)
		if(..())
			if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/naga))
				icon = 'icons/mob/taursuits_vr.dmi'
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "biosci-naga"
				item_state = "biosci-naga"
				pixel_x = -16
				return 1
			else
				H << "<span class='warning'>You need to have a horse, wolf, or naga half to wear this.</span>"
				return 0

//CMO's biosuit, blue stripe
/obj/item/clothing/suit/bio_suit/cmo/taur
	name = "taur specific bio suit"
	desc = "A suit that protects against biological contamination. It has a sticker saying one size fits all taurs on it. Below the sticker, it states that it only fits horses, wolves, and naga taurs."
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS
	flags_inv = HIDEGLOVES|HIDEJUMPSUIT|HIDETAIL|HIDETIE|HIDEHOLSTER
	species_restricted = null //Species restricted since all it cares about is a taur half
	mob_can_equip(var/mob/living/carbon/human/H, slot, disable_warning = 0)
		if(..())
			if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/naga))
				icon = 'icons/mob/taursuits_vr.dmi'
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "biocmo-naga"
				item_state = "biocmo-naga"
				pixel_x = -16
				return 1
			else
				H << "<span class='warning'>You need to have a horse, wolf, or naga half to wear this.</span>"
				return 0