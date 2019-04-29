/obj/item/weapon/card/exploration_point_card
	name = "exploration point card"
	desc = "A small card preloaded with exploration points. Swipe your Cataloguer over it to transfer the points, then discard."
	icon_state = "data"
	var/points = 50

/obj/item/weapon/card/exploration_point_card/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/device/cataloguer))
		if(points)
			var/obj/item/device/cataloguer/C = I
			C.points_stored += points
			to_chat(user, "<span class='info'>You transfer [points] points to [C].</span>")
			points = 0
		else
			to_chat(user, "<span class='info'>There's no points left on [src].</span>")
	..()

/obj/item/weapon/card/exploration_point_card/examine(mob/user)
	..(user)
	to_chat(user, "There's [points] points on the card.")

/obj/item/weapon/card/exploration_point_card/can_catalogue(mob/user)
	return FALSE