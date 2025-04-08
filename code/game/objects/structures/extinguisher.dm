/obj/structure/extinguisher_cabinet
	name = "extinguisher cabinet"
	desc = "A small wall mounted cabinet designed to hold a fire extinguisher."
	icon = 'icons/obj/closet.dmi'
	icon_state = "extinguisher" // map preview sprite
	layer = ABOVE_WINDOW_LAYER
	anchored = TRUE
	density = FALSE
	var/obj/item/extinguisher/has_extinguisher
	var/opened = 0

/obj/structure/extinguisher_cabinet/Initialize(mapload, var/dir, var/building = 0)
	. = ..()

	if(building)
		pixel_x = (dir & 3)? 0 : (dir == 4 ? -27 : 27)
		pixel_y = (dir & 3)? (dir ==1 ? -27 : 27) : 0
	else
		has_extinguisher = new/obj/item/extinguisher(src)

	update_icon()

/obj/structure/extinguisher_cabinet/attackby(obj/item/O, mob/user)
	if(isrobot(user))
		return
	if(istype(O, /obj/item/extinguisher))
		if(!has_extinguisher && opened)
			user.remove_from_mob(O)
			contents += O
			has_extinguisher = O
			to_chat(user, span_notice("You place [O] in [src]."))
		else
			opened = !opened
	if(O.has_tool_quality(TOOL_WRENCH))
		if(!has_extinguisher)
			to_chat(user, span_notice("You start to unwrench the extinguisher cabinet."))
			playsound(src, O.usesound, 50, 1)
			if(do_after(user, 15 * O.toolspeed))
				to_chat(user, span_notice("You unwrench the extinguisher cabinet."))
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
		var/obj/item/organ/external/temp = H.organs_by_name[BP_R_HAND]
		if (user.hand)
			temp = H.organs_by_name[BP_L_HAND]
		if(temp && !temp.is_usable())
			to_chat(user, span_notice("You try to move your [temp.name], but cannot!"))
			return
	if(has_extinguisher)
		user.put_in_hands(has_extinguisher)
		to_chat(user, span_notice("You take [has_extinguisher] from [src]."))
		has_extinguisher = null
		opened = 1
	else
		opened = !opened
	update_icon()

/obj/structure/extinguisher_cabinet/attack_tk(mob/user)
	if(has_extinguisher)
		has_extinguisher.loc = loc
		to_chat(user, span_notice("You telekinetically remove [has_extinguisher] from [src]."))
		has_extinguisher = null
		opened = 1
	else
		opened = !opened
	update_icon()

/obj/structure/extinguisher_cabinet/update_icon()
	var/suffix = "empty"
	if(has_extinguisher)
		if(istype(has_extinguisher, /obj/item/extinguisher/mini))
			suffix = "mini"
		if(istype(has_extinguisher, /obj/item/extinguisher/atmo))
			suffix = "advanced"
		else
			suffix = "standard"

	icon_state = "[initial(icon_state)][opened ? "" : "_closed"]_[suffix]"

/obj/structure/extinguisher_cabinet/old
	name = "extinguisher cabinet"
	desc = "A classic small wall mounted cabinet designed to hold a fire extinguisher."
	icon = 'icons/obj/closet.dmi'
	icon_state = "oldextinguisher" // map preview sprite
