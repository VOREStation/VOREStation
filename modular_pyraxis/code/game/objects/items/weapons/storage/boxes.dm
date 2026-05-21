/obj/item/storage/box/event

/obj/item/storage/box/event/cookies
	starts_with = list(
		/obj/item/reagent_containers/food/snacks/cookie = 10
	)

/obj/item/storage/box/event/explosive

/obj/item/storage/box/event/explosive/open(mob/user)
	. = ..()
	explosion(get_turf(src), -1, -1, -1, 1)
	qdel(src)
