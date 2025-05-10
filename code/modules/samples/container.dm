/obj/item/storage/sample_container
	name = "sample container"
	desc = "A small containment device used to safely collect and carry up to eight research samples. Has a loop for attaching to belts."
	description_info = "You can use the sample container directly on a sample to quickly scoop it up, or on a tile to scoop up all samples on that tile. This negates the risk of hurting yourself if you don't have thick enough gloves to safely handle the samples!"
	icon = 'icons/obj/samples.dmi'
	icon_state = "sample_container_0"

	w_class = ITEMSIZE_SMALL
	slot_flags = SLOT_BELT
	max_w_class = ITEMSIZE_TINY
	storage_slots = 8
	max_storage_space = ITEMSIZE_TINY * 8
	var/lightcolor = "#EFF1BF"

	drop_sound = 'sound/items/drop/gascan.ogg'
	pickup_sound = 'sound/items/pickup/gascan.ogg'

	can_hold = list(/obj/item/research_sample)

/obj/item/storage/sample_container/update_icon()
	..()
	icon_state = "sample_container_[contents.len]"
	if(contents.len > 0)
		set_light(1, contents.len, lightcolor)
	else
		set_light(0)

/obj/item/storage/sample_container/afterattack(turf/T as turf, mob/user as mob)
	for(var/obj/item/research_sample/S in T)
		if(contents.len >= max_storage_space)
			to_chat(user, span_notice("\The [src] is full!"))
			return
		else
			S.loc = src
			update_icon()
			to_chat(user, span_notice("You scoop \the [S] into \the [src]."))
