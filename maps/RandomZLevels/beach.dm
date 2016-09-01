/obj/effect/spawner/beach // Hacky as all hell and causes slow round loads BUT IT FUCKING WORKS NOW, DOESN'T IT? -Ace
	icon = 'icons/misc/beach.dmi'
	icon_state = "coconuts"

	New()
		switch(rand(1,100)) // It's written fucky so it's more efficient, trying the most likely options first to cause less lag hopefully.
			if(26 to 99)
				qdel(src)
			if(1 to 10)
				new /obj/effect/overlay/palmtree_r(get_turf(src))
			if(11 to 20)
				new /obj/effect/overlay/palmtree_l(get_turf(src))
			if(21 to 25)
				new /obj/effect/overlay/coconut(get_turf(src))
			if(100)
				var/trash = pick(/obj/item/trash/raisins, /obj/item/trash/candy, /obj/item/trash/cheesie, /obj/item/trash/chips,
							/obj/item/trash/popcorn, /obj/item/trash/sosjerky, /obj/item/trash/syndi_cakes, /obj/item/trash/plate,
							/obj/item/trash/pistachios, /obj/item/trash/semki, /obj/item/trash/tray, /obj/item/trash/liquidfood,
							/obj/item/trash/tastybread, /obj/item/trash/snack_bowl, /mob/living/simple_animal/crab)
				new trash(get_turf(src))
		qdel(src)