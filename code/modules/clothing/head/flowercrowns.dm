/obj/item/clothing/head/woodcirclet
	name = "wood circlet"
	desc = "A small wood circlet for making a flower crown."
	icon_state = "woodcirclet"
	w_class = ITEMSIZE_SMALL
	body_parts_covered = 0

/obj/item/clothing/head/woodcirclet/attackby(obj/item/W as obj, mob/user as mob)
	var/obj/item/complete
	if(istype(W,/obj/item/seeds/poppyseed))
		user << "You attach the poppy to the circlet and create a beautiful flower crown."
		complete = new /obj/item/clothing/head/poppy_crown(get_turf(user))
		user.drop_from_inventory(W)
		user.drop_from_inventory(src)
		qdel(W)
		qdel(src)
		user.put_in_hands(complete)
		return
	else if(istype(W,/obj/item/seeds/sunflowerseed))
		user << "You attach the sunflower to the circlet and create a beautiful flower crown."
		complete = new /obj/item/clothing/head/sunflower_crown(get_turf(user))
		user.drop_from_inventory(W)
		user.drop_from_inventory(src)
		qdel(W)
		qdel(src)
		user.put_in_hands(complete)
		return
	else if(istype(W,/obj/item/seeds/lavenderseed))
		user << "You attach the lavender to the circlet and create a beautiful flower crown."
		complete = new /obj/item/clothing/head/lavender_crown(get_turf(user))
		user.drop_from_inventory(W)
		user.drop_from_inventory(src)
		qdel(W)
		qdel(src)
		user.put_in_hands(complete)
		return

//Flower crowns

/obj/item/clothing/head/sunflower_crown
	name = "sunflower crown"
	desc = "A flower crown weaved with sunflowers."
	icon_state = "sunflower_crown"
	body_parts_covered = 0

/obj/item/clothing/head/lavender_crown
	name = "lavender crown"
	desc = "A flower crown weaved with lavender."
	icon_state = "lavender_crown"
	body_parts_covered = 0

/obj/item/clothing/head/poppy_crown
	name = "poppy crown"
	desc = "A flower crown weaved with poppies."
	icon_state = "poppy_crown"
	body_parts_covered = 0