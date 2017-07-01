/obj/item/clothing/head/helmet/space/rig
	sprite_sheets = list(
		"Tajara" 				= 'icons/mob/species/tajaran/helmet.dmi',
		"Skrell" 				= 'icons/mob/species/skrell/helmet.dmi',
		"Unathi" 				= 'icons/mob/species/unathi/helmet.dmi',
		"Nevrean" 				= 'icons/mob/species/nevrean/helmet_vr.dmi',
		"Akula" 				= 'icons/mob/species/akula/helmet_vr.dmi',
		"Sergal"				= 'icons/mob/species/sergal/helmet_vr.dmi',
		"Flatland Zorren" 		= 'icons/mob/species/fennec/helmet_vr.dmi',
		"Highlander Zorren" 	= 'icons/mob/species/fox/helmet_vr.dmi',
		"Vulpkanin"				= 'icons/mob/species/vulpkanin/helmet.dmi',
		"Promethean"			= 'icons/mob/species/skrell/helmet.dmi',
		"Xenomorph Hybrid"		= 'icons/mob/species/unathi/helmet.dmi'
		)



/obj/item/clothing/suit/space/rig
	sprite_sheets = list(
		"Tajara" 				= 'icons/mob/species/tajaran/suit.dmi',
		"Skrell" 				= 'icons/mob/species/skrell/suit.dmi',
		"Unathi" 				= 'icons/mob/species/unathi/suit.dmi',
		"Nevrean" 				= 'icons/mob/species/nevrean/suit_vr.dmi',
		"Akula" 				= 'icons/mob/species/akula/suit_vr.dmi',
		"Sergal"				= 'icons/mob/species/sergal/suit_vr.dmi',
		"Flatland Zorren" 		= 'icons/mob/species/fennec/suit_vr.dmi',
		"Highlander Zorren" 	= 'icons/mob/species/fox/suit_vr.dmi',
		"Vulpkanin"				= 'icons/mob/species/vulpkanin/suit.dmi',
		"Promethean"			= 'icons/mob/species/skrell/suit.dmi',
		"Xenomorph Hybrid"		= 'icons/mob/species/unathi/suit.dmi'
		)

/obj/item/clothing/suit/space/rig
	mob_can_equip(var/mob/living/carbon/human/H, slot, disable_warning = 0)
		if(icon_state == "security_rig_sealed")
			if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/horse))
				icon = 'icons/mob/taursuits_vr.dmi'
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "breacher_rig_cheap-horse_sealed" //They have to toggle the chest piece off then on again for this to show up.
				pixel_x = -16
				update_icon()
				return 1
			else if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/wolf))
				icon = 'icons/mob/taursuits_vr.dmi'
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "breacher_rig_cheap-wolf_sealed"
				pixel_x = -16
				update_icon()
				return 1
			else if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/naga))
				icon = 'icons/mob/taursuits_vr.dmi'
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "breacher_rig_cheap-naga_sealed"
				pixel_x = -16
				update_icon()
				return 1
			else
				icon = 'icons/obj/clothing/suits.dmi'
				icon_override = null
				icon_state = "security_rig_sealed"
				pixel_x = 0
				update_icon()
				return 1
		else if(icon_state == "engineering_rig_sealed")
			if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/horse))
				icon = 'icons/mob/taursuits_vr.dmi'
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "industrial_rig-horse_sealed"
				pixel_x = -16
				update_icon()
				return 1
			else if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/wolf))
				icon = 'icons/mob/taursuits_vr.dmi'
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "industrial_rig-wolf_sealed"
				pixel_x = -16
				update_icon()
				return 1
			else if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/naga))
				icon = 'icons/mob/taursuits_vr.dmi'
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "industrial_rig-naga_sealed"
				pixel_x = -16
				update_icon()
				return 1
			else
				icon = 'icons/obj/clothing/suits.dmi'
				icon_override = null
				icon_state = "engineering_rig_sealed"
				pixel_x = 0
				update_icon()
				return 1
		else if(icon_state == "science_rig_sealed")
			if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/horse))
				icon = 'icons/mob/taursuits_vr.dmi'
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "science_rig-horse_sealed"
				pixel_x = -16
				update_icon()
				return 1
			else if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/wolf))
				icon = 'icons/mob/taursuits_vr.dmi'
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "science_rig-wolf_sealed"
				pixel_x = -16
				update_icon()
				return 1
			else if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/naga))
				icon = 'icons/mob/taursuits_vr.dmi'
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "science_rig-naga_sealed"
				pixel_x = -16
				update_icon()
				return 1
			else
				icon = 'icons/obj/clothing/suits.dmi'
				icon_override = null
				icon_state = "science_rig_sealed"
				pixel_x = 0
				update_icon()
				return 1
		else if(icon_state == "medical_rig_sealed")
			if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/horse))
				icon = 'icons/mob/taursuits_vr.dmi'
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "medical_rig-horse_sealed"
				pixel_x = -16
				update_icon()
				return 1
			else if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/wolf))
				icon = 'icons/mob/taursuits_vr.dmi'
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "medical_rig-wolf_sealed"
				pixel_x = -16
				update_icon()
				return 1
			else if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/naga))
				icon = 'icons/mob/taursuits_vr.dmi'
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "medical_rig-naga_sealed"
				pixel_x = -16
				update_icon()
				return 1
			else
				icon = 'icons/obj/clothing/suits.dmi'
				icon_override = null
				icon_state = "medical_rig_sealed"
				pixel_x = 0
				update_icon()
				return 1
		else if(icon_state == "security_rig")
			if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/horse))
				icon = 'icons/mob/taursuits_vr.dmi'
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "breacher_rig_cheap-horse_sealed"
				pixel_x = -16
				update_icon()
				return 1
			else if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/wolf))
				icon = 'icons/mob/taursuits_vr.dmi'
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "breacher_rig_cheap-wolf_sealed"
				pixel_x = -16
				update_icon()
				return 1
			else if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/naga))
				icon = 'icons/mob/taursuits_vr.dmi'
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "breacher_rig_cheap-naga_sealed"
				pixel_x = -16
				update_icon()
				return 1
			else
				icon = 'icons/obj/clothing/suits.dmi'
				icon_override = null
				icon_state = "security_rig"
				pixel_x = 0
				update_icon()
				return 1
		else if(icon_state == "engineering_rig")
			if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/horse))
				icon = 'icons/mob/taursuits_vr.dmi'
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "industrial_rig-horse_sealed"
				pixel_x = -16
				update_icon()
				return 1
			else if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/wolf))
				icon = 'icons/mob/taursuits_vr.dmi'
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "industrial_rig-wolf_sealed"
				pixel_x = -16
				update_icon()
				return 1
			else if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/naga))
				icon = 'icons/mob/taursuits_vr.dmi'
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "industrial_rig-naga_sealed"
				pixel_x = -16
				update_icon()
				return 1
			else
				icon = 'icons/obj/clothing/suits.dmi'
				icon_override = null
				icon_state = "engineering_rig"
				pixel_x = 0
				update_icon()
				return 1
		else if(icon_state == "science_rig")
			if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/horse))
				icon = 'icons/mob/taursuits_vr.dmi'
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "science_rig-horse_sealed"
				pixel_x = -16
				update_icon()
				return 1
			else if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/wolf))
				icon = 'icons/mob/taursuits_vr.dmi'
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "science_rig-wolf_sealed"
				return 1
			else if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/naga))
				icon = 'icons/mob/taursuits_vr.dmi'
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "science_rig-naga_sealed"
				pixel_x = -16
				update_icon()
				return 1
			else
				icon = 'icons/obj/clothing/suits.dmi'
				icon_override = null
				icon_state = "science_rig"
				pixel_x = 0
				update_icon()
				return 1
		else if(icon_state == "medical_rig")
			if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/horse))
				icon = 'icons/mob/taursuits_vr.dmi'
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "medical_rig-horse_sealed"
				pixel_x = -16
				update_icon()
				return 1
			else if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/wolf))
				icon = 'icons/mob/taursuits_vr.dmi'
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "medical_rig-wolf_sealed"
				pixel_x = -16
				update_icon()
				return 1
			else if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/naga))
				icon = 'icons/mob/taursuits_vr.dmi'
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "medical_rig-naga_sealed"
				pixel_x = -16
				update_icon()
				return 1
			else
				icon = 'icons/obj/clothing/suits.dmi'
				icon_override = null
				icon_state = "medical_rig"
				pixel_x = 0
				update_icon()
				return 1
		else
			return 1



/obj/item/clothing/suit/space/rig/ce
	mob_can_equip(var/mob/living/carbon/human/H, slot, disable_warning = 0)
		if(icon_state == "ce_rig")
			if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/horse))
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "ce_rig-horse"
				pixel_x = -16
				update_icon()
				return 1
			else if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/wolf))
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "ce_rig-wolf"
				pixel_x = -16
				update_icon()
				return 1
			else if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/naga))
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "ce_rig-naga"
				pixel_x = -16
				update_icon()
				return 1
			else
				icon = 'icons/obj/clothing/suits.dmi'
				icon_override = null
				icon_state = "ce_rig"
				pixel_x = 0
				update_icon()
				return 1
		else if(icon_state == "ce_rig_sealed")
			if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/horse))
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "ce_rig-horse_sealed"
				pixel_x = -16
				update_icon()
				return 1
			else if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/wolf))
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "ce_rig-wolf_sealed"
				pixel_x = -16
				update_icon()
				return 1
			else if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/naga))
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "ce_rig-naga_sealed"
				pixel_x = -16
				update_icon()
				return 1
			else
				icon = 'icons/obj/clothing/suits.dmi'
				icon_override = null
				icon_state = "ce_rig_sealed"
				pixel_x = 0
				update_icon()
				return 1
		else
			return 1

/obj/item/clothing/head/helmet/space/rig
	phoronproof = 1
/obj/item/clothing/gloves/gauntlets/rig
	phoronproof = 1
/obj/item/clothing/shoes/magboots/rig
	phoronproof = 1
/obj/item/clothing/suit/space/rig
	phoronproof = 1
