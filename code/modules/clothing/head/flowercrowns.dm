/obj/item/clothing/head/woodcirclet
	name = "wood circlet"
	desc = "A small wood circlet for making a flower crown."
	icon_state = "woodcirclet"
	w_class = ITEMSIZE_SMALL
	body_parts_covered = 0

/obj/item/clothing/head/woodcirclet/attackby(obj/item/W as obj, mob/user as mob)
	var/obj/item/complete
	if(istype(W, /obj/item/reagent_containers/food/snacks/grown))
		var/obj/item/reagent_containers/food/snacks/grown/G = W
		if(G.seed.kitchen_tag == "poppy")
			to_chat(user, "You attach the poppy to the circlet and create a beautiful flower crown.")
			complete = new /obj/item/clothing/head/poppy_crown(get_turf(user))
		else if(G.seed.kitchen_tag == PLANT_SUNFLOWERS)
			to_chat(user, "You attach the sunflower to the circlet and create a beautiful flower crown.")
			complete = new /obj/item/clothing/head/sunflower_crown(get_turf(user))
		else if(G.seed.kitchen_tag == PLANT_LAVENDER)
			to_chat(user, "You attach the lavender to the circlet and create a beautiful flower crown.")
			complete = new /obj/item/clothing/head/lavender_crown(get_turf(user))
		else if(G.seed.kitchen_tag == PLANT_ROSE)
			to_chat(user, "You attach the rose to the circlet and create a beautiful flower crown.")
			complete = new /obj/item/clothing/head/rose_crown(get_turf(user))
		user.drop_from_inventory(W)
		user.drop_from_inventory(src)
		qdel(W)
		qdel(src)
		user.put_in_hands(complete)
		return
	return ..()

//Flower crowns

/obj/item/clothing/head/sunflower_crown
	name = "sunflower crown"
	desc = "A flower crown weaved with sunflowers."
	icon_state = "sunflower_crown"
	body_parts_covered = 0
	drop_sound = 'sound/items/drop/herb.ogg'
	pickup_sound = 'sound/items/pickup/herb.ogg'

/obj/item/clothing/head/lavender_crown
	name = "lavender crown"
	desc = "A flower crown weaved with lavender."
	icon_state = "lavender_crown"
	body_parts_covered = 0
	drop_sound = 'sound/items/drop/herb.ogg'
	pickup_sound = 'sound/items/pickup/herb.ogg'

/obj/item/clothing/head/poppy_crown
	name = "poppy crown"
	desc = "A flower crown weaved with poppies."
	icon_state = "poppy_crown"
	body_parts_covered = 0
	drop_sound = 'sound/items/drop/herb.ogg'
	pickup_sound = 'sound/items/pickup/herb.ogg'

/obj/item/clothing/head/rose_crown
	name = "rose crown"
	desc = "A flower crown weaved with roses."
	icon_state = "poppy_crown"
	body_parts_covered = 0
	drop_sound = 'sound/items/drop/herb.ogg'
	pickup_sound = 'sound/items/pickup/herb.ogg'
