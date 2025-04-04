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

//Splice research sample containers into the list of valid items for these belts *without* overriding the lists entirely
/obj/item/storage/belt/explorer/Initialize(mapload)
	. = ..()
	can_hold.Add(/obj/item/storage/sample_container)

/obj/item/storage/belt/miner/Initialize(mapload)
	. = ..()
	can_hold.Add(/obj/item/storage/sample_container)

/obj/item/storage/belt/archaeology/Initialize(mapload)
	. = ..()
	can_hold.Add(/obj/item/storage/sample_container)

//ditto, lockers and redemption machines
/obj/structure/closet/secure_closet/miner/Initialize(mapload)
	. = ..()
	starts_with += /obj/item/storage/sample_container

/obj/structure/closet/secure_closet/xenoarchaeologist/Initialize(mapload)
	. = ..()
	starts_with += /obj/item/storage/sample_container

/obj/machinery/mineral/equipment_vendor/Initialize(mapload)
	. = ..()
	prize_list["Gear"] += list(EQUIPMENT("Exotic Sample Container",				/obj/item/storage/sample_container,									100))

/obj/machinery/mineral/equipment_vendor/survey/Initialize(mapload)
	. = ..()
	prize_list["Gear"] += list(EQUIPMENT("Survey Tools - Exotic Sample Container",				/obj/item/storage/sample_container,									100))
