/obj/effect/spawner/beach // If this doesn't make the shit spawn I swear to fuck I will kill someone. I don't care how much lag this causes or how hacky it is.
	icon = 'icons/misc/beach.dmi'
	icon_state = "coconuts"

	New()
		var/palmchance = rand(1,100)
		if(palmchance >= 1 && palmchance <= 10)
			new /obj/effect/overlay/palmtree_r(get_turf(src))
		if(palmchance >= 11 && palmchance <= 20)
			new /obj/effect/overlay/palmtree_l(get_turf(src))
		if(palmchance >= 21 && palmchance <= 25)
			new /obj/effect/overlay/coconut(get_turf(src))
		if(palmchance == 100) // Tourists like to litter. :(
			var/trash = pick(/obj/item/trash/raisins, /obj/item/trash/candy, /obj/item/trash/cheesie, /obj/item/trash/chips,
							/obj/item/trash/popcorn, /obj/item/trash/sosjerky, /obj/item/trash/syndi_cakes, /obj/item/trash/plate,
							/obj/item/trash/pistachios, /obj/item/trash/semki, /obj/item/trash/tray, /obj/item/trash/liquidfood,
							/obj/item/trash/tastybread, /obj/item/trash/snack_bowl, /mob/living/simple_animal/crab/small)
			new trash(get_turf(src))
		del(src)