/obj/structure/extinguisher_cabinet
	name = "extinguisher cabinet"
	desc = "A small wall mounted cabinet designed to hold a fire extinguisher."
	icon = 'icons/obj/closet.dmi'
	icon_state = "extinguisher_closed"
	layer = ABOVE_WINDOW_LAYER
	anchored = 1
	density = 0
	var/obj/item/weapon/extinguisher/has_extinguisher
	var/opened = 0

/obj/structure/extinguisher_cabinet/New(var/loc, var/dir, var/building = 0)
	..()

	if(building)
		if(loc)
			src.loc = loc

		pixel_x = (dir & 3)? 0 : (dir == 4 ? -27 : 27)
		pixel_y = (dir & 3)? (dir ==1 ? -27 : 27) : 0
		update_icon()
		return
	else
		has_extinguisher = new/obj/item/weapon/extinguisher(src)

/obj/structure/extinguisher_cabinet/attackby(obj/item/O, mob/user)
	if(isrobot(user))
		return
	if(istype(O, /obj/item/weapon/extinguisher))
		if(!has_extinguisher && opened)
			user.remove_from_mob(O)
			contents += O
			has_extinguisher = O
			to_chat(user, "<span class='notice'>You place [O] in [src].</span>")
		else
			opened = !opened
	if(O.is_wrench())
		if(!has_extinguisher)
			to_chat(user, "<span class='notice'>You start to unwrench the extinguisher cabinet.</span>")
			playsound(src, O.usesound, 50, 1)
			if(do_after(user, 15 * O.toolspeed))
				to_chat(user, "<span class='notice'>You unwrench the extinguisher cabinet.</span>")
				new /obj/item/frame/extinguisher_cabinet( src.loc )
				qdel(src)
			return
	else
		opened = !opened
	update_icon()


/obj/structure/extinguisher_cabinet/attack_hand(mob/living/user)
	if(isrobot(user))
		return
	if (ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/external/temp = H.organs_by_name["r_hand"]
		if (user.hand)
			temp = H.organs_by_name["l_hand"]
		if(temp && !temp.is_usable())
			to_chat(user, "<span class='notice'>You try to move your [temp.name], but cannot!</span>")
			return
	if(has_extinguisher)
		user.put_in_hands(has_extinguisher)
		to_chat(user, "<span class='notice'>You take [has_extinguisher] from [src].</span>")
		has_extinguisher = null
		opened = 1
	else
		opened = !opened
	update_icon()

/obj/structure/extinguisher_cabinet/attack_tk(mob/user)
	if(has_extinguisher)
		has_extinguisher.loc = loc
		to_chat(user, "<span class='notice'>You telekinetically remove [has_extinguisher] from [src].</span>")
		has_extinguisher = null
		opened = 1
	else
		opened = !opened
	update_icon()

/obj/structure/extinguisher_cabinet/update_icon()
	if(!opened)
		icon_state = "extinguisher_closed"
		return
	if(has_extinguisher)
		if(istype(has_extinguisher, /obj/item/weapon/extinguisher/mini))
			icon_state = "extinguisher_mini"
		else
			icon_state = "extinguisher_full"
	else
		icon_state = "extinguisher_empty"
