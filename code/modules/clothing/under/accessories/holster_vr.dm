/obj/item/clothing/accessory/holster/waist/kinetic_accelerator
	name = "KA holster"
	desc = "A specialized holster, made specifically for Kinetic Accelerators."
	can_hold = list(/obj/item/gun/energy/kinetic_accelerator)

/obj/item/clothing/accessory/holster/waist/lanyard
	name = "baton lanyard"
	desc = "A sturdy tether with quick-release carabiner that can keep several patterns of standard-issue security baton ready for quick usage."
	icon_state = "holster_lanyard"
	overlay_state = "holster_lanyard"
	can_hold = list(
		/obj/item/melee/baton,
		/obj/item/melee/classic_baton,
		/obj/item/melee/telebaton		
		)

/obj/item/clothing/accessory/holster/machete/rapier
	name = "rapier sheath"
	desc = "A beautiful red sheath, probably for a beautiful blade."
	icon = 'icons/inventory/accessory/item_vr.dmi'
	icon_state = "sheath"
	slot_flags = SLOT_BELT|ACCESSORY_SLOT_WEAPON
	var/has_full_icon = 1
	icon_override = 'icons/inventory/accessory/mob_vr.dmi'
	overlay_state = "sheath"
	can_hold = list(/obj/item/melee/rapier)

/obj/item/clothing/accessory/holster/machete/rapier/swords
	name = "sword sheath"
	desc = "A beautiful red sheath, probably for a beautiful blade."
	can_hold = list(
		/obj/item/melee/rapier,
		/obj/item/material/sword/katana,
		/obj/item/toy/cultsword,
		/obj/item/material/sword,
		/obj/item/melee/cursedblade,
		/obj/item/melee/cultblade
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
