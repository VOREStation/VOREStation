// Micro Holders - Extends /obj/item/weapon/holder

/obj/item/weapon/holder/micro
	name = "micro"
	desc = "Another crewmember, small enough to fit in your hand."
	icon_state = "micro"
	icon_override = 'icons/inventory/head/mob_vr.dmi'
	slot_flags = SLOT_FEET | SLOT_HEAD | SLOT_ID | SLOT_HOLSTER
	w_class = ITEMSIZE_SMALL
	item_icons = null // No in-hand sprites (for now, anyway, we could totally add some)
	pixel_y = 0		  // Override value from parent.

/obj/item/weapon/holder/examine(mob/user)
	. = list()
	for(var/mob/living/M in contents)
		. += M.examine(user)

/obj/item/weapon/holder/MouseDrop(mob/M)
	..()
	if(M != usr) return
	if(usr == src) return
	if(!Adjacent(usr)) return
	if(isAI(M)) return
	for(var/mob/living/carbon/human/O in contents)
		O.show_inventory_panel(usr, state = GLOB.tgui_deep_inventory_state)

/obj/item/weapon/holder/micro/attack_self(mob/living/carbon/user) //reworked so it works w/ nonhumans
	user.setClickCooldown(user.get_attack_speed())
	for(var/L in contents)
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			H.help_shake_act(user)
		if(isanimal(L))
			var/mob/living/simple_mob/S = L
			user.visible_message("<span class='notice'>[user] [S.response_help] \the [S].</span>")

//Egg features.
/obj/item/weapon/holder/attack_hand(mob/living/user as mob)
	if(istype(src.loc, /obj/item/weapon/storage/vore_egg)) //Don't scoop up the egged mob
		src.pickup(user)
		user.drop_from_inventory(src)
		return
	..()

/obj/item/weapon/holder/container_resist(mob/living/held)
	if(!istype(src.loc, /obj/item/weapon/storage/vore_egg))
		..()
	else
		var/obj/item/weapon/storage/vore_egg/E = src.loc
		if(isbelly(E.loc))
			var/obj/belly/B = E.loc
			B.relay_resist(held, E)
			return
		E.hatch(held)
		return
