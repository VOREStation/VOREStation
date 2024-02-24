/obj/item/clothing/head/helmet/solgov
	name = "peacekeeper helmet"
	desc = "A helmet painted in Peacekeeper blue. Stands out like a sore thumb."

/obj/item/clothing/head/helmet/solgov/command
	name = "peacekeeper commander helmet"
	desc = "A more sophisticated helmet painted in Peacekeeper blue. Stands out like a sore thumb."

/obj/item/clothing/head/helmet/combat/USDF
	name = "marine helmet"
	desc = "If you wanna to keep your brain inside yo' head, you'd best put this on!"
	icon_state = "unsc_helm"
	item_state = "unsc_helm"
	icon = 'icons/inventory/head/item_vr.dmi'
	icon_override = 'icons/inventory/head/mob_vr.dmi'

/obj/item/clothing/head/helmet/combat/imperial
	name = "imperial soldier helmet"
	desc = "Veni, vidi, vici; I came, I saw, I conquered."
	icon_state = "ge_helm"
	icon = 'icons/inventory/head/item_vr.dmi'
	icon_override = 'icons/inventory/head/mob_vr.dmi'

/obj/item/clothing/head/helmet/combat/imperial/centurion
	name = "imperial centurion helmet"
	desc = "Vendi, vidi, visa; I came, I saw, I realised this hat was too expensive."
	icon_state = "ge_helmcent"
	icon = 'icons/inventory/head/item_vr.dmi'
	icon_override = 'icons/inventory/head/mob_vr.dmi'

// Armor Versions Here	
/obj/item/clothing/head/helmet/combat/crusader
	name = "crusader helmet"
	desc = "ye olde armored helmet"
	icon_state = "crusader"
	icon = 'icons/inventory/head/item_vr.dmi'
	icon_override = 'icons/inventory/head/item_vr.dmi'
	armor = list(melee = 80, bullet = 50, laser = 10, energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 2

/obj/item/clothing/head/helmet/combat/bedevere
	name = "bedevere's helmet"
	desc = "ye olde armored helmet"
	icon_state = "bedevere_helmet"
	icon = 'icons/inventory/head/item_vr.dmi'
	icon_override = 'icons/inventory/head/item_vr.dmi'
	armor = list(melee = 80, bullet = 50, laser = 10, energy = 0, bomb = 0, bio = 0, rad = 0)
	tint = TINT_HEAVY
	siemens_coefficient = 2
	
	var/base_state
	var/up = FALSE
	
/obj/item/clothing/head/helmet/combat/bedevere/attack_self()
	toggle()

/obj/item/clothing/head/helmet/combat/bedevere/verb/toggle()
	set category = "Object"
	set name = "Adjust helmet visor"
	set src in usr

	if(!base_state)
		base_state = icon_state

	if(usr.canmove && !usr.stat && !usr.restrained())
		if(src.up)
			src.up = !src.up
			body_parts_covered |= (EYES|FACE)
			flags_inv |= (HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE)
			icon_state = base_state
			tint = initial(tint)
			to_chat(usr, "You flip the [src] down to protect yourself from the horrors of this universe. Narry a creature shall harm you with its beams of light.")
			playsound(src, 'sound/machines/hatch_open.ogg', 75, 1)
		else
			src.up = !src.up
			body_parts_covered &= ~(EYES|FACE)
			flags_inv &= ~(HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE)
			icon_state = "[base_state]_up"
			tint = TINT_NONE
			to_chat(usr, "You push the [src] up out of your face, ineffectively clearing your vision.")
			playsound(src, 'sound/machines/hatch_open.ogg', 75, 1)
		update_clothing_icon()	//so our mob-overlays
		if (ismob(src.loc)) //should allow masks to update when it is opened/closed
			var/mob/M = src.loc
			M.update_inv_wear_mask()
		usr.update_action_buttons()
		
// Costume Versions Here
/obj/item/clothing/head/helmet/combat/crusader_costume
	name = "crusader costume helmet"
	desc = "ye olde armored helmet"
	icon_state = "crusader"
	icon = 'icons/inventory/head/item_vr.dmi'
	icon_override = 'icons/inventory/head/item_vr.dmi'
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 1

/obj/item/clothing/head/helmet/combat/bedevere_costume
	name = "bedevere's costume helmet"
	desc = "ye olde armored helmet"
	icon_state = "bedevere_helmet"
	icon = 'icons/inventory/head/item_vr.dmi'
	icon_override = 'icons/inventory/head/item_vr.dmi'
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)
	tint = TINT_HEAVY
	siemens_coefficient = 1
	
	var/base_state
	var/up = FALSE
	
/obj/item/clothing/head/helmet/combat/bedevere_costume/attack_self()
	toggle()

/obj/item/clothing/head/helmet/combat/bedevere_costume/verb/toggle()
	set category = "Object"
	set name = "Adjust helmet visor"
	set src in usr

	if(!base_state)
		base_state = icon_state

	if(usr.canmove && !usr.stat && !usr.restrained())
		if(src.up)
			src.up = !src.up
			body_parts_covered |= (EYES|FACE)
			flags_inv |= (HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE)
			icon_state = base_state
			tint = initial(tint)
			to_chat(usr, "You flip the [src] down to protect yourself from the horrors of this universe. Narry a creature shall harm you with its beams of light.")
			playsound(src, 'sound/machines/hatch_open.ogg', 75, 1)
		else
			src.up = !src.up
			body_parts_covered &= ~(EYES|FACE)
			flags_inv &= ~(HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE)
			icon_state = "[base_state]_up"
			tint = TINT_NONE
			to_chat(usr, "You push the [src] up out of your face, ineffectively clearing your vision.")
			playsound(src, 'sound/machines/hatch_open.ogg', 75, 1)
		update_clothing_icon()	//so our mob-overlays
		if (ismob(src.loc)) //should allow masks to update when it is opened/closed
			var/mob/M = src.loc
			M.update_inv_wear_mask()
		usr.update_action_buttons()