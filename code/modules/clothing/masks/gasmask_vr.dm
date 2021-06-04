// Our clear gas masks don't hide faces, but changing the var on mask/gas would require un-chaging it on all children. This is nicer.
/obj/item/clothing/mask/gas/New()
	if(type == /obj/item/clothing/mask/gas)
		flags_inv &= ~HIDEFACE
	..()

// Since we changed the gas mask sprite, if we want the old one for some reason use this.
/obj/item/clothing/mask/gas/wwii
	icon = 'icons/obj/clothing/masks.dmi'
	icon_override = 'icons/mob/mask.dmi'
	flags_inv = HIDEEARS|HIDEEYES|HIDEFACE

/obj/item/clothing/mask/gas/imperial
	name = "imperial soldier facemask"
	desc = "A close-fitting tactical mask that can be connected to an air supply."
	icon_state = "ge_visor"
	icon = 'icons/obj/clothing/masks_vr.dmi'
	icon_override = 'icons/mob/mask_vr.dmi'
	body_parts_covered = FACE|EYES
	flags_inv = HIDEEARS|HIDEEYES|HIDEFACE
	
/obj/item/clothing/mask/gas/invisible
	name = "Cyber Tech PCM"
	desc = "The latest in nanotechnology. This sensor suite conforms to the user and creates an invisible nanoweve around vital facial components without obstructing their sense of fashion or ability to eat."
	icon = 'icons/obj/items.dmi'
	icon_state = "implantpad-0"
	item_flags = BLOCK_GAS_SMOKE_EFFECT | AIRTIGHT | FLEXIBLEMATERIAL
	body_parts_covered = FACE|EYES|HEAD
	flags_inv = null
	armor = list(melee = 0, bullet = 0, laser = 2,energy = 2, bomb = 0, bio = 90, rad = 0)
	
/obj/item/clothing/mask/gas/invisible/administrative
	name = "administrative Cyber Tech PCM"
	desc = "The latest in nanotechnology. This sensor suite conforms to the user and creates an invisible nanoweve around vital facial components without obstructing their sense of fashion or ability to eat. It's a heavily enhanced version used for administrative duties."
	armor = list(melee = 100, bullet = 100, laser = 100,energy = 100, bomb = 100, bio = 100, rad = 100)
	siemens_coefficient = 0
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	min_pressure_protection = 0 * ONE_ATMOSPHERE
	max_pressure_protection = 2 * ONE_ATMOSPHERE
	flash_protection = FLASH_PROTECTION_MAJOR
	
/obj/item/clothing/mask/gas/invisible/enhanced
	name = "enhanced Cyber Tech PCM"
	desc = "The latest in nanotechnology. This sensor suite conforms to the user and creates an invisible nanoweve around vital facial components without obstructing their sense of fashion or ability to eat. This one has an advanced shielding unit installed."
	armor = list(melee = 10, bullet = 5, laser = 5,energy = 5, bomb = 0, bio = 90, rad = 0)
	siemens_coefficient = 0.7
	
/obj/item/clothing/mask/gas/invisible/minusphoron
	name = "-TX Cyber Tech PCM"
	desc = "The latest in nanotechnology. This sensor suite conforms to the user and creates an invisible nanoweve around vital facial components without obstructing their sense of fashion or ability to eat. This version is designed with phoron breathers in mind."
	filtered_gases = list("oxygen", "nitrous_oxide")
	
/obj/item/clothing/mask/gas/invisible/plusnitrogen
	name = "+02 Cyber Tech PCM"
	desc = "The latest in nanotechnology. This sensor suite conforms to the user and creates an invisible nanoweve around vital facial components without obstructing their sense of fashion or ability to eat. This version is designed with nitrogen breathers in mind."
	filtered_gases = list("phoron", "oxygen", "nitrous_oxide")
	
/obj/item/clothing/mask/gas/invisible/zaddat
	name = "+N2 Cyber Tech PCM"
	desc = "The latest in nanotechnology. This sensor suite conforms to the user and creates an invisible nanoweve around vital facial components without obstructing their sense of fashion or ability to eat. This version is designed for those with an aversion to nitrogen."
	filtered_gases = list("phoron", "nitrogen", "nitrous_oxide")