// Micro Holders - Extends /obj/item/weapon/holder

/obj/item/weapon/holder/micro
	name = "micro"
	desc = "Another crewmember, small enough to fit in your hand."
	icon_state = "micro"
	icon_override = 'icons/mob/head_vr.dmi'
	slot_flags = SLOT_FEET | SLOT_HEAD | SLOT_ID
	w_class = ITEMSIZE_SMALL
	item_icons = list() // No in-hand sprites (for now, anyway, we could totally add some)
	pixel_y = 0			// Override value from parent.

/obj/item/weapon/holder/micro/examine(mob/user)
	for(var/mob/living/M in contents)
		M.examine(user)

/obj/item/weapon/holder/MouseDrop(mob/M)
	..()
	if(M != usr) return
	if(usr == src) return
	if(!Adjacent(usr)) return
	if(isAI(M)) return
	for(var/mob/living/carbon/human/O in contents)
		O.show_inv(usr)

/obj/item/weapon/holder/micro/attack_self(mob/living/carbon/user) //reworked so it works w/ nonhumans
	for(var/L in contents)
		if(ishuman(L) && user.canClick()) // These canClicks() are repeated here to make sure users can't avoid the click delay
			var/mob/living/carbon/human/H = L
			H.help_shake_act(user)
			user.setClickCooldown(user.get_attack_speed()) //uses the same cooldown as regular attack_hand
			return
		if(isanimal(L) && user.canClick())
			var/mob/living/simple_mob/S = L
			user.visible_message("<span class='notice'>[user] [S.response_help] \the [S].</span>")
			user.setClickCooldown(user.get_attack_speed())
			

/obj/item/weapon/holder/micro/update_state()
	if(isturf(loc) || !held_mob || held_mob.loc != src)
		qdel(src)

/obj/item/weapon/holder/micro/Destroy()
	var/turf/here = get_turf(src)
	for(var/atom/movable/A in src)
		A.forceMove(here)
	return ..()

/obj/item/weapon/holder/micro/sync(var/mob/living/M)
	..()
	for(var/mob/living/carbon/human/I in contents)
		item_state = lowertext(I.species.name)