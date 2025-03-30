/datum/find
	var/find_type = 0				//random according to the digsite type
	var/excavation_required = 0		//random 10 - 190
	var/view_range = 200			//how close excavation has to come to show an overlay on the turf
	var/prob_delicate = 0			//probability it requires an active suspension field to not insta-crumble. Set to 0 to nullify the need for suspension field.

/datum/find/New(var/digsite, var/exc_req)
	excavation_required = exc_req
	find_type = get_random_find_type(digsite)

/obj/item/strangerock
	name = "Strange rock"
	desc = "Seems to have some unusal strata evident throughout it."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "strange"
	var/datum/geosample/geologic_data
	origin_tech = list(TECH_MATERIAL = 5)
	w_class = ITEMSIZE_SMALL

/obj/item/strangerock/Initialize(mapload, var/inside_item_type = 0)
	. = ..()
	pixel_x = rand(0,16)-8
	pixel_y = rand(0,8)-8
	var/d100 = rand(1,100)

	if(inside_item_type)
		switch(d100)
			if(51 to 100) //standard spawn logic 50% of the time
				new /obj/item/archaeological_find(src, inside_item_type)
			if(21 to 50) // 30% chance
				new /obj/item/research_sample/common(src)
			if(6 to 20) // 15% chance
				new /obj/item/research_sample/uncommon(src)
			if(1 to 5) // 5% chance
				new /obj/item/research_sample/rare(src)
			else	//if something went wrong, somehow, generate the usual find
				new /obj/item/archaeological_find(src, inside_item_type)
	else	//if this strange rock isn't set to generate a find for whatever reason, create a sample 75% of the time (this shouldn't happen unless the rock is mapped in or adminspawned)
		switch(d100)
			if(76 to 100)
				return
			if(21 to 75)
				new /obj/item/research_sample/common(src)
			if(6 to 20)
				new /obj/item/research_sample/uncommon(src)
			if(1 to 5)
				new /obj/item/research_sample/rare(src)
			else	//if we somehow glitched
				return	//do nothing

/obj/item/strangerock/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/pickaxe)) //Whatever, if you use a hand pick it should work just like a brush. No reason for otherwise.
		var/obj/item/inside = locate() in src
		if(inside)
			inside.loc = get_turf(src)
			visible_message(span_info("\The [src] is mined away, revealing \the [inside]."))
		else
			visible_message(span_info("\The [src] is mined away into nothing."))
		qdel(src)
		return

	if(I.has_tool_quality(TOOL_WELDER))
		var/obj/item/weldingtool/W = I.get_welder()
		if(W.isOn())
			if(W.get_fuel() >= 2)
				var/obj/item/inside = locate() in src
				if(inside)
					inside.loc = get_turf(src)
					visible_message(span_info("\The [src] burns away revealing \the [inside]."))
				else
					visible_message(span_info("\The [src] burns away into nothing."))
				qdel(src)
				W.remove_fuel(2)
			else
				visible_message(span_info("A few sparks fly off \the [src], but nothing else happens."))
				W.remove_fuel(1)
			return

	else if(istype(I, /obj/item/core_sampler))
		var/obj/item/core_sampler/S = I
		S.sample_item(src, user)
		return

	..()

	if(prob(33))
		src.visible_message(span_warning("[src] crumbles away, leaving some dust and gravel behind."))
		qdel(src)
