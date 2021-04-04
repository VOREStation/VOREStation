/obj/item/clothing/accessory/holster/waist/kinetic_accelerator
	name = "KA holster"
	desc = "A specialized holster, made specifically for Kinetic Accelerator."
	can_hold = list(/obj/item/weapon/gun/energy/kinetic_accelerator)

/obj/item/clothing/accessory/holster/machete/rapier
	name = "sword sheath"
	desc = "A beautiful red sheath, probably for a beautiful blade."
	icon = 'icons/obj/clothing/ties_vr.dmi'
	icon_state = "sheath"
	slot = ACCESSORY_SLOT_WEAPON || SLOT_BELT
	can_hold = list(
		/obj/item/weapon/melee/rapier,
		/obj/item/weapon/material/sword/katana,
		/obj/item/toy/cultsword,
		/obj/item/weapon/material/sword,
		/obj/item/weapon/melee/cursedblade,
		/obj/item/weapon/melee/cultblade
		)

/obj/item/clothing/accessory/holster/holster(var/obj/item/I, var/mob/living/user)
	. = ..()
	icon_state = initial(icon_state)
	item_state = initial(item_state)
	for(var/item in contents)
     if(istype(item, /obj/item/weapon/melee/rapier))
		icon_state = "[icon_state]-rapier"
		item_state = "[item_state]-rapier"
		else
			icon_state = "[icon_state]-other"
			item_state = "[item_state]-other"

/obj/item/clothing/accessory/holster/machete/rapier/unholster(mob/user as mob)
	icon_state = initial(icon_state)
	item_state = initial(item_state)

