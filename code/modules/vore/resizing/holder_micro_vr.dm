// Micro Holders - Extends /obj/item/weapon/holder

/obj/item/weapon/holder/micro
	name = "micro"
	desc = "Another crewmember, small enough to fit in your hand."
	icon_state = "micro"
	slot_flags = SLOT_FEET | SLOT_HEAD | SLOT_ID
	w_class = ITEMSIZE_SMALL
	item_icons = list() // No in-hand sprites (for now, anyway, we could totally add some)
	pixel_y = 0			// Override value from parent.

/obj/item/weapon/holder/micro/examine(var/mob/user)
	for(var/mob/living/M in contents)
		M.examine(user)

/obj/item/weapon/holder/MouseDrop(mob/M as mob)
	..()
	if(M != usr) return
	if(usr == src) return
	if(!Adjacent(usr)) return
	if(istype(M,/mob/living/silicon/ai)) return
	for(var/mob/living/carbon/human/O in contents)
		O.show_inv(usr)

/obj/item/weapon/holder/micro/attack_self(var/mob/living/user)
	for(var/mob/living/carbon/human/M in contents)
		M.help_shake_act(user)

/obj/item/weapon/holder/micro/update_state()
	if(istype(loc,/turf) || !(held_mob) || !(held_mob.loc == src))
		qdel(src)

/obj/item/weapon/holder/micro/Destroy()
	var/turf/here = get_turf(src)
	for(var/atom/movable/A in src)
		A.forceMove(here)
	return ..()