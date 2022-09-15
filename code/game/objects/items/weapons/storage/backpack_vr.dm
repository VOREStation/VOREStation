/obj/item/weapon/storage/backpack/saddlebag
	name = "Horse Saddlebags"
	desc = "A saddle that holds items. Seems slightly bulky."
	icon = 'icons/inventory/back/item_vr.dmi'
	icon_override = 'icons/inventory/back/mob_vr.dmi'
	item_state = "saddlebag"
	icon_state = "saddlebag"
	max_storage_space = INVENTORY_DUFFLEBAG_SPACE //Saddlebags can hold more, like dufflebags
	slowdown = 1 //And are slower, too...
	var/taurtype = /datum/sprite_accessory/tail/taur/horse //Acceptable taur type to be wearing this
	var/no_message = "You aren't the appropriate taur type to wear this!"

/obj/item/weapon/storage/backpack/saddlebag/mob_can_equip(var/mob/living/carbon/human/H, slot, disable_warning = 0)
	if(..())
		if(istype(H) && istype(H.tail_style, taurtype))
			return 1
		else
			to_chat(H, "<span class='warning'>[no_message]</span>")
			return 0

/* If anyone wants to make some... this is how you would.
/obj/item/weapon/storage/backpack/saddlebag/spider
	name = "Drider Saddlebags"
	item_state = "saddlebag_drider"
	icon_state = "saddlebag_drider"
	var/taurtype = /datum/sprite_accessory/tail/taur/spider
*/

/obj/item/weapon/storage/backpack/saddlebag_common //Shared bag for other taurs with sturdy backs
	name = "Taur Saddlebags"
	desc = "A saddle that holds items. Seems slightly bulky."
	icon = 'icons/inventory/back/item_vr.dmi'
	icon_override = 'icons/inventory/back/mob_vr.dmi'
	item_state = "saddlebag"
	icon_state = "saddlebag"
	var/icon_base = "saddlebag"
	max_storage_space = INVENTORY_DUFFLEBAG_SPACE //Saddlebags can hold more, like dufflebags
	slowdown = 1 //And are slower, too...
	var/no_message = "You aren't the appropriate taur type to wear this!"

/obj/item/weapon/storage/backpack/saddlebag_common/mob_can_equip(var/mob/living/carbon/human/H, slot, disable_warning = 0)
	if(..())
		if(!istype(H))//Error, non HUMAN.
			log_runtime("[H] was not a valid human!")
			return

		var/datum/sprite_accessory/tail/taur/TT = H.tail_style
		if(istype(TT))
			item_state = "[icon_base]_[TT.icon_sprite_tag]"	//icon_sprite_tag is something like "deer"
			return 1



/obj/item/weapon/storage/backpack/saddlebag_common/robust //Shared bag for other taurs with sturdy backs
	name = "Robust Saddlebags"
	desc = "A saddle that holds items. Seems robust."
	icon = 'icons/inventory/back/item_vr.dmi'
	icon_override = 'icons/inventory/back/mob_vr.dmi'
	item_state = "robustsaddle"
	icon_state = "robustsaddle"
	icon_base = "robustsaddle"

/obj/item/weapon/storage/backpack/saddlebag_common/vest //Shared bag for other taurs with sturdy backs
	name = "Taur Duty Vest"
	desc = "An armored vest with the armor modules replaced with various handy compartments with decent storage capacity. Useless for protection though. Holds less than a saddle."
	icon = 'icons/inventory/back/item_vr.dmi'
	icon_override = 'icons/inventory/back/mob_vr.dmi'
	item_state = "taurvest"
	icon_state = "taurvest"
	icon_base = "taurvest"
	max_storage_space = INVENTORY_STANDARD_SPACE
	slowdown = 0

/obj/item/weapon/storage/backpack/dufflebag/fluff //Black dufflebag without syndie buffs.
	name = "plain black dufflebag"
	desc = "A large dufflebag for holding extra tactical supplies."
	icon_state = "duffle_syndie"

/obj/item/weapon/storage/backpack
	sprite_sheets = list(
		SPECIES_TESHARI = 'icons/inventory/back/mob_teshari.dmi',
		SPECIES_WEREBEAST = 'icons/inventory/back/mob_vr_werebeast.dmi')

/obj/item/weapon/storage/backpack/ert
	max_storage_space = INVENTORY_DUFFLEBAG_SPACE

///Exploration Bags///

/obj/item/weapon/storage/backpack/explorer
	name = "exploration backpack"
	desc = "A backpack for carrying a large number of supplies easily."
	icon = 'icons/inventory/back/item_vr.dmi'
	icon_override = 'icons/inventory/back/mob_vr.dmi'
	icon_state = "explorer"

/obj/item/weapon/storage/backpack/satchel/explorer
	name = "exploration satchel"
	desc = "A satchel for carrying a large number of supplies easily."
	icon = 'icons/inventory/back/item_vr.dmi'
	icon_override = 'icons/inventory/back/mob_vr.dmi'
	icon_state = "explorer_satchel"
	item_state_slots = null

/obj/item/weapon/storage/backpack/messenger/explorer
	name = "exploration messenger bag"
	desc = "A sturdy backpack worn over one shoulder."
	icon = 'icons/inventory/back/item_vr.dmi'
	icon_override = 'icons/inventory/back/mob_vr.dmi'
	icon_state = "explorer_courier"
	item_state_slots = null

/obj/item/weapon/storage/backpack/dufflebag/explorer
	name = "exploration dufflebag"
	desc = "A large dufflebag for holding extra supplies."
	icon = 'icons/inventory/back/item_vr.dmi'
	icon_override = 'icons/inventory/back/mob_vr.dmi'
	icon_state = "explorer_duffle"

///Talon Bags///

/obj/item/weapon/storage/backpack/talon
	name = "Talon backpack"
	desc = "A backpack for carrying a large number of supplies easily."
	icon = 'icons/inventory/back/item_vr.dmi'
	icon_override = 'icons/inventory/back/mob_vr.dmi'
	icon_state = "talon"

/obj/item/weapon/storage/backpack/satchel/talon
	name = "Talon satchel"
	desc = "A satchel for carrying a large number of supplies easily."
	icon = 'icons/inventory/back/item_vr.dmi'
	icon_override = 'icons/inventory/back/mob_vr.dmi'
	icon_state = "talon_satchel"
	item_state_slots = null

/obj/item/weapon/storage/backpack/messenger/talon
	name = "Talon messenger bag"
	desc = "A sturdy backpack worn over one shoulder."
	icon = 'icons/inventory/back/item_vr.dmi'
	icon_override = 'icons/inventory/back/mob_vr.dmi'
	icon_state = "talon_courier"
	item_state_slots = null

/obj/item/weapon/storage/backpack/dufflebag/talon
	name = "Talon dufflebag"
	desc = "A large dufflebag for holding extra supplies."
	icon = 'icons/inventory/back/item_vr.dmi'
	icon_override = 'icons/inventory/back/mob_vr.dmi'
	icon_state = "talon_duffle"

///Roboticist Bags///

/obj/item/weapon/storage/backpack/satchel/roboticist
	name = "roboticist satchel"
	desc = "A satchel for carrying a large number of spare parts easily."
	icon = 'icons/inventory/back/item_vr.dmi'
	icon_override = 'icons/inventory/back/mob_vr.dmi'
	item_state = "satchel-robo"
	icon_state = "satchel-robo"

/obj/item/weapon/storage/backpack/roboticist
	name = "roboticist backpack"
	desc = "A backpack for carrying a large number of spare parts easily."
	icon = 'icons/inventory/back/item_vr.dmi'
	icon_override = 'icons/inventory/back/mob_vr.dmi'
	item_state = "backpack-robo"
	icon_state = "backpack-robo"

///Vintage Military Bags///

/obj/item/weapon/storage/backpack/vietnam
	name = "vietnam backpack"
	desc = "There are tangos in the trees! We need napalm right now! Why is my gun jammed?"
	icon = 'icons/inventory/back/item_vr.dmi'
	icon_override = 'icons/inventory/back/mob_vr.dmi'
	item_state = "nambackpack"
	icon_state = "nambackpack"

/obj/item/weapon/storage/backpack/russian
	name = "russian backpack"
	desc = "Useful for carrying large quantities of vodka."
	icon = 'icons/inventory/back/item_vr.dmi'
	icon_override = 'icons/inventory/back/mob_vr.dmi'
	item_state = "ru_rucksack"
	icon_state = "ru_rucksack"

/obj/item/weapon/storage/backpack/korean
	name = "korean backpack"
	desc = "Insert witty description here."
	icon = 'icons/inventory/back/item_vr.dmi'
	icon_override = 'icons/inventory/back/mob_vr.dmi'
	item_state = "kr_rucksack"
	icon_state = "kr_rucksack"


//strapless
/obj/item/weapon/storage/backpack/satchel/strapless
	name = "strapless satchel"
	desc = "A satchel for carrying a large number of supplies easily. Without Straps"
	icon = 'icons/inventory/back/item_vr.dmi'
	icon_override = 'icons/inventory/back/mob_vr.dmi'
	icon_state = "satchel_strapless"
	item_state_slots = null

