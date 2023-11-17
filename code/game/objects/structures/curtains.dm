/obj/structure/curtain
	name = "curtain"
	desc = "The show must go on! At least, until you close these."
	icon = 'icons/obj/curtain.dmi'
	icon_state = "closed"
	plane = MOB_PLANE
	layer = ABOVE_MOB_LAYER
	opacity = 1
	density = FALSE

/obj/structure/curtain/open
	icon_state = "open"
	plane = OBJ_PLANE
	layer = OBJ_LAYER
	opacity = 0

/obj/structure/curtain/bullet_act(obj/item/projectile/P, def_zone)
	if(!P.nodamage)
		visible_message("<span class='warning'>[P] tears [src] down!</span>")
		qdel(src)
	else
		..(P, def_zone)

/obj/structure/curtain/attack_hand(mob/user)
	playsound(src, "rustle", 15, 1, -5)
	toggle()
	..()

/obj/structure/curtain/proc/toggle()
	set_opacity(!opacity)
	if(opacity)
		icon_state = "closed"
		plane = MOB_PLANE
		layer = ABOVE_MOB_LAYER
	else
		icon_state = "open"
		plane = OBJ_PLANE
		layer = OBJ_LAYER

/obj/structure/curtain/attackby(obj/item/P, mob/user)
	if(P.has_tool_quality(TOOL_WIRECUTTER))
		playsound(src, P.usesound, 50, 1)
		to_chat(user, "<span class='notice'>You start to cut the shower curtains.</span>")
		if(do_after(user, 10))
			to_chat(user, "<span class='notice'>You cut the shower curtains.</span>")
			new /obj/item/stack/material/plastic(src.loc, 3)
			qdel(src)
		return
	else
		src.attack_hand(user)
	return

/obj/structure/curtain/black
	name = "black curtain"
	color = "#222222"

/obj/structure/curtain/medical
	name = "plastic curtain"
	color = "#B8F5E3"
	alpha = 200

/obj/structure/curtain/open/bed
	name = "bed curtain"
	color = "#854636"

/obj/structure/curtain/open/privacy
	name = "privacy curtain"
	color = "#B8F5E3"

/obj/structure/curtain/open/shower
	name = "shower curtain"
	color = "#ACD1E9"
	alpha = 200

/obj/structure/curtain/open/shower/engineering
	color = "#FFA500"

/obj/structure/curtain/open/shower/medical
	color = "#B8F5E3"

/obj/structure/curtain/open/shower/security
	color = "#AA0000"
