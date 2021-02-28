/obj/item/weapon/shield/energy/imperial
	name = "energy scutum"
	desc = "It's really easy to mispronounce the name of this shield if you've only read it in books."
	icon = 'icons/obj/weapons_vr.dmi'
	icon_state = "impshield" // eshield1 for expanded
	item_icons = list(slot_l_hand_str = 'icons/mob/items/lefthand_melee_vr.dmi', slot_r_hand_str = 'icons/mob/items/righthand_melee_vr.dmi')

/obj/item/weapon/shield/fluff/wolfgirlshield
	name = "Autumn Shield"
	desc = "A shiny silvery shield with a large red leaf symbol in the center."
	icon = 'icons/obj/weapons_vr.dmi'
	icon_state = "wolfgirlshield"
	slot_flags = SLOT_BACK | SLOT_OCLOTHING
	force = 5.0
	throwforce = 5.0
	throw_speed = 2
	throw_range = 6
	item_icons = list(slot_l_hand_str = 'icons/mob/items/lefthand_melee_vr.dmi', slot_r_hand_str = 'icons/mob/items/righthand_melee_vr.dmi', slot_back_str = 'icons/vore/custom_items_vr.dmi', slot_wear_suit_str = 'icons/vore/custom_items_vr.dmi')
	attack_verb = list("shoved", "bashed")
	var/cooldown = 0 //shield bash cooldown. based on world.time
	allowed = list(/obj/item/weapon/melee/fluffstuff/wolfgirlsword)


/obj/item/weapon/shield/riot/explorer
	name = "green explorer shield"
	desc = "A shield issued to exploration teams to help protect them when advancing into the unknown. It is lighter and cheaper but less protective than some of its counterparts. It has a flashlight straight in the middle to help draw attention."
	icon = 'icons/obj/weapons_vr.dmi'
	icon_state = "explorer_shield"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_melee_vr.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_melee_vr.dmi'
	)
	base_block_chance = 40
	slot_flags = SLOT_BACK
	var/brightness_on
	brightness_on = 6
	var/on = 0
	var/light_applied
	//var/light_overlay

//POURPEL WHY U NO COVER

/obj/item/weapon/shield/riot/explorer/attack_self(mob/user)
	if(brightness_on)
		if(!isturf(user.loc))
			to_chat(user, "You cannot turn the light on while in this [user.loc]")
			return
		on = !on
		to_chat(user, "You [on ? "enable" : "disable"] the shield light.")
		update_flashlight(user)

		if(istype(user,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = user
			H.update_inv_l_hand()
			H.update_inv_r_hand()
	else
		return ..(user)

/obj/item/weapon/shield/riot/explorer/proc/update_flashlight(var/mob/user = null)
	if(on && !light_applied)
		set_light(brightness_on)
		light_applied = 1
	else if(!on && light_applied)
		set_light(0)
		light_applied = 0
	update_icon(user)
	user.update_action_buttons()
	playsound(src, 'sound/weapons/empty.ogg', 15, 1, -3)

/obj/item/weapon/shield/riot/explorer/update_icon()
	if(on)
		icon_state = "explorer_shield_lighted"
	else
		icon_state = "explorer_shield"

/obj/item/weapon/shield/riot/explorer/purple
	name = "purple explorer shield"
	desc = "A shield issued to exploration teams to help protect them when advancing into the unknown. It is lighter and cheaper but less protective than some of its counterparts. It has a flashlight straight in the middle to help draw attention. This one is POURPEL"
	icon_state = "explorer_shield_P"

/obj/item/weapon/shield/riot/explorer/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/material/knife/machete))
		if(cooldown < world.time - 25)
			user.visible_message("<span class='warning'>[user] bashes [src] with [W]!</span>")
			playsound(src, 'sound/effects/shieldbash.ogg', 50, 1)
			cooldown = world.time
	else
		..()

/obj/item/weapon/shield/riot/explorer/purple/update_icon()
	if(on)
		icon_state = "explorer_shield_P_lighted"
	else
		icon_state = "explorer_shield_P"
