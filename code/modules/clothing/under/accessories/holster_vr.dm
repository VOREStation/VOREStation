/obj/item/clothing/accessory/holster/waist/kinetic_accelerator
	name = "KA holster"
	desc = "A specialized holster, made specifically for Kinetic Accelerators."
	can_hold = list(/obj/item/weapon/gun/energy/kinetic_accelerator)

/obj/item/clothing/accessory/holster/machete/rapier
	name = "rapier sheath"
	desc = "A beautiful red sheath, probably for a beautiful blade."
	icon = 'icons/inventory/accessory/item_vr.dmi'
	icon_state = "sheath"
	slot_flags = SLOT_BELT|ACCESSORY_SLOT_WEAPON
	var/has_full_icon = 1
	icon_override = 'icons/inventory/accessory/mob_vr.dmi'
	overlay_state = "sheath"
	can_hold = list(/obj/item/weapon/melee/rapier)

/obj/item/clothing/accessory/holster/machete/rapier/swords
	name = "sword sheath"
	desc = "A beautiful red sheath, probably for a beautiful blade."
	can_hold = list(
		/obj/item/weapon/melee/rapier,
		/obj/item/weapon/material/sword/katana,
		/obj/item/toy/cultsword,
		/obj/item/weapon/material/sword,
		/obj/item/weapon/melee/cursedblade,
		/obj/item/weapon/melee/cultblade
		)

/obj/item/clothing/accessory/holster/machete/rapier/proc/occupied()
	if(!has_full_icon)
		return
	if(contents.len)
		overlay_state = "[initial(overlay_state)]-rapier"
	else
		overlay_state = initial(overlay_state)

/obj/item/clothing/accessory/holster/machete/rapier/swords/occupied()
	if(!has_full_icon)
		return
	if(contents.len)
		overlay_state = "[initial(overlay_state)]-secondary"
	else
		overlay_state = initial(overlay_state)

/obj/item/clothing/accessory/holster/machete/rapier/holster(var/obj/item/I, var/mob/living/user)
	..()
	occupied()
	if(has_suit)
		has_suit.update_clothing_icon()

/obj/item/clothing/accessory/holster/machete/rapier/unholster(var/obj/item/I, var/mob/living/user)
	..()
	occupied()
	if(has_suit)
		has_suit.update_clothing_icon()
