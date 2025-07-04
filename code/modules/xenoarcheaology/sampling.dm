/obj/item/rocksliver
	name = "rock sliver"
	desc = "It looks extremely delicate."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "sliver1"
	randpixel = 8
	w_class = ITEMSIZE_TINY
	sharp = TRUE
	var/datum/geosample/geological_data

/obj/item/rocksliver/Initialize(mapload)
	. = ..()
	icon_state = "sliver[rand(1, 3)]"
	randpixel_xy()

/datum/geosample
	var/age = 0
	var/age_thousand = 0
	var/age_million = 0
	var/age_billion = 0
	var/artifact_id = ""
	var/artifact_distance = -1
	var/source_mineral = REAGENT_ID_CHLORINE
	var/list/find_presence = list()

/datum/geosample/New(var/turf/simulated/mineral/container)
	UpdateTurf(container)

/datum/geosample/proc/UpdateTurf(var/turf/simulated/mineral/container)
	if(!istype(container))
		return

	age = rand(1, 999)

	if(container.mineral)
		if(islist(container.mineral.xarch_ages))
			var/list/ages = container.mineral.xarch_ages
			if(ages["thousand"])
				age_thousand = rand(1, ages["thousand"])
			if(ages["million"])
				age_million = rand(1, ages["million"])
			if(ages["billion"])
				if(ages["billion_lower"])
					age_billion = rand(ages["billion_lower"], ages["billion"])
				else
					age_billion = rand(1, ages["billion"])
		if(container.mineral.xarch_source_mineral)
			source_mineral = container.mineral.xarch_source_mineral

	if(prob(75))
		find_presence[REAGENT_ID_PHOSPHORUS] = rand(1, 500) / 100
	if(prob(25))
		find_presence[REAGENT_ID_MERCURY] = rand(1, 500) / 100
	find_presence[REAGENT_ID_CHLORINE] = rand(500, 2500) / 100

	for(var/datum/find/F in container.finds)
		var/responsive_reagent = get_responsive_reagent(F.find_type)
		find_presence[responsive_reagent] = 25 //Just making this phoron because this this feature was axed 8 years ago.

	var/total_presence = 0
	for(var/carrier in find_presence)
		total_presence += find_presence[carrier]
	for(var/carrier in find_presence)
		find_presence[carrier] = find_presence[carrier] / total_presence

/datum/geosample/proc/UpdateNearbyArtifactInfo(var/turf/simulated/mineral/container)
	if(!container || !istype(container))
		return

	if(container.artifact_find)
		artifact_distance = rand()
		artifact_id = container.artifact_find.artifact_id
	else
		if(SSxenoarch) //Sanity check due to runtimes ~Z
			for(var/turf/simulated/mineral/T in SSxenoarch.artifact_spawning_turfs)
				if(T.artifact_find)
					var/cur_dist = get_dist(container, T) * 2
					if( (artifact_distance < 0 || cur_dist < artifact_distance))
						artifact_distance = cur_dist + rand() * 2 - 1
						artifact_id = T.artifact_find.artifact_id
				else
					SSxenoarch.artifact_spawning_turfs.Remove(T)

/obj/item/core_sampler
	name = "core sampler"
	desc = "Used to extract geological core samples."
	icon = 'icons/obj/device.dmi'
	icon_state = "sampler0"
	item_state = "screwdriver_brown"
	w_class = ITEMSIZE_TINY

	var/sampled_turf = ""
	var/num_stored_bags = 10
	var/obj/item/evidencebag/filled_bag
	pickup_sound = 'sound/items/pickup/device.ogg'
	drop_sound = 'sound/items/drop/device.ogg'

/obj/item/core_sampler/examine(var/mob/user)
	. = ..()
	if(get_dist(user, src) <= 2)
		. += span_notice("Used to extract geological core samples - this one is [sampled_turf ? "full" : "empty"], and has [num_stored_bags] bag[num_stored_bags != 1 ? "s" : ""] remaining.")

/obj/item/core_sampler/attackby(var/obj/item/I, var/mob/living/user)
	if(istype(I, /obj/item/evidencebag))
		if(I.contents.len)
			to_chat(user, span_warning("\The [I] is full."))
			return
		if(num_stored_bags < 10)
			qdel(I)
			num_stored_bags += 1
			to_chat(user, span_notice("You insert \the [I] into \the [src]."))
		else
			to_chat(user, span_warning("\The [src] can not fit any more bags."))
	else
		return ..()

/obj/item/core_sampler/proc/sample_item(var/item_to_sample, var/mob/user)
	var/datum/geosample/geo_data

	if(ismineralturf(item_to_sample))
		var/turf/simulated/mineral/T = item_to_sample
		T.geologic_data.UpdateNearbyArtifactInfo(T)
		geo_data = T.geologic_data
	else if(istype(item_to_sample, /obj/item/ore))
		var/obj/item/ore/O = item_to_sample
		geo_data = O.geologic_data

	if(geo_data)
		if(filled_bag)
			to_chat(user, span_warning("The core sampler is full."))
		else if(num_stored_bags < 1)
			to_chat(user, span_warning("The core sampler is out of sample bags."))
		else
			//create a new sample bag which we'll fill with rock samples
			filled_bag = new /obj/item/evidencebag(src)
			filled_bag.name = "sample bag"
			filled_bag.desc = "a bag for holding research samples."

			icon_state = "sampler1"
			--num_stored_bags

			//put in a rock sliver
			var/obj/item/rocksliver/R = new(filled_bag)
			R.geological_data = geo_data

			//update the sample bag
			filled_bag.icon_state = "evidence"
			var/image/I = image("icon"=R, "layer"=FLOAT_LAYER)
			add_overlay(I)
			add_overlay("evidence")
			filled_bag.w_class = ITEMSIZE_TINY

			to_chat(user, span_notice("You take a core sample of the [item_to_sample]."))
	else
		to_chat(user, span_warning("You are unable to take a sample of [item_to_sample]."))

/obj/item/core_sampler/attack_self(var/mob/living/user)
	if(filled_bag)
		to_chat(user, span_notice("You eject the full sample bag."))
		var/success = 0
		if(istype(src.loc, /mob))
			var/mob/M = src.loc
			success = M.put_in_inactive_hand(filled_bag)
		if(!success)
			filled_bag.loc = get_turf(src)
		filled_bag = null
		icon_state = "sampler0"
	else
		to_chat(user, span_warning("The core sampler is empty."))
